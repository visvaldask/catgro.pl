#!/usr/bin/perl -w
# A script to merge several gro files into one big one.
#
# Usage: $0 file1.gro file2.gro ...  > mergedfile.gro (or to standard output if the merged file name is not specified)
#
# Does not renumber atoms or residues but that's normally not a problem when using as an input to GROMACS or obabel
# V. Kairys, Life Sciences Center at  Vilnius University

use strict;
use warnings;

die "Usage: $0 file1.gro file2.gro ...  > mergedfile.gro (or to standard output if the merged file name is not specified)\n" if(@ARGV==0);


print STDERR "input files: ";
foreach my $file ( @ARGV ){
    print STDERR "$file ";
}
print STDERR "\n";

my $commandline = join " ", $0, @ARGV;
my $infoline="";
my $totatoms=0;
my @atoms=();
foreach my $file (@ARGV){
    open(MOLF,"<$file") or die "Error while opening $file $!\n";
    my $thisnat=-999999999999999;
    while(<MOLF>){
        next if($. == 1);
        if($. == 2){
            chomp; my @tmp=split;
            print STDERR "file $file, number of atoms $tmp[0]\n";
            $totatoms += $tmp[0];
            $thisnat=$tmp[0];
            next;
        }
        next if($. == $thisnat+3 ); #skip last line
        push @atoms,$_; #push atoms into an array
    }
    close(MOLF);
}
print STDERR "total number of atoms $totatoms\n";
print STDERR "infoline $commandline\n";
print STDERR "printing into the standard output the merged molecule\n";
print "$commandline\n";
print "$totatoms\n";
foreach my $line (@atoms){
    print $line;
}
print "   0.00000   0.00000   0.00000\n";
