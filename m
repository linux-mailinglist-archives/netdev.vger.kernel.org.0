Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA56C40B1D9
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhINOrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhINOrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49A6D6113E;
        Tue, 14 Sep 2021 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631630763;
        bh=SzoyUum2B0DE7xPe6ja9737NC/MhgWEojg7/8AlrEow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bid0XZXXDBLyQTE+mtgkKpcoivwgvgldsRdezGyizGnKAnaY3xIfw4iykd/YvAHtQ
         aneALf7PJAr8OdOk9EvSgEypBMmbL+mu1B7I/+0EMKv5AaApM0UGYEWBXhdlYL/CZK
         5RqSzoP2YdFDUY+vmywRVE9DZRnTpNmZrycj2fSTs7/t18JKVlQMcMcL+BqAQuDH4/
         vGbAlUoMj/myYC445hC7GoB2NYRWZvZCCijQPL+lZYZ56TP1xzS4yYZ7DfKZpR48HT
         G9Jwg6MXmI8BPfYIIt6hzWblEU5caOKPpJYsw1JjEpO50GdppTK3/D6dERlD5kk8i5
         MMgyadfM+h2zw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQ9hB-000KzA-CT; Tue, 14 Sep 2021 16:46:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Tony Luck <tony.luck@intel.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/5] scripts: get_abi.pl: Check for missing symbols at the ABI specs
Date:   Tue, 14 Sep 2021 16:45:55 +0200
Message-Id: <2872f38bae3cd96466e2388bc5eabde6654e7563.1631629987.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631629987.git.mchehab+huawei@kernel.org>
References: <cover.1631629987.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for the symbols that exists under /sys but aren't
defined at Documentation/ABI.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 scripts/get_abi.pl | 90 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/scripts/get_abi.pl b/scripts/get_abi.pl
index 3b25d0a855ad..ded6dd8b9f71 100755
--- a/scripts/get_abi.pl
+++ b/scripts/get_abi.pl
@@ -13,7 +13,9 @@ my $help = 0;
 my $man = 0;
 my $debug = 0;
 my $enable_lineno = 0;
+my $show_warnings = 1;
 my $prefix="Documentation/ABI";
+my $sysfs_prefix="/sys";
 
 #
 # If true, assumes that the description is formatted with ReST
@@ -36,7 +38,7 @@ pod2usage(2) if (scalar @ARGV < 1 || @ARGV > 2);
 
 my ($cmd, $arg) = @ARGV;
 
-pod2usage(2) if ($cmd ne "search" && $cmd ne "rest" && $cmd ne "validate");
+pod2usage(2) if ($cmd ne "search" && $cmd ne "rest" && $cmd ne "validate" && $cmd ne "undefined");
 pod2usage(2) if ($cmd eq "search" && !$arg);
 
 require Data::Dumper if ($debug);
@@ -50,6 +52,8 @@ my %symbols;
 sub parse_error($$$$) {
 	my ($file, $ln, $msg, $data) = @_;
 
+	return if (!$show_warnings);
+
 	$data =~ s/\s+$/\n/;
 
 	print STDERR "Warning: file $file#$ln:\n\t$msg";
@@ -521,11 +525,88 @@ sub search_symbols {
 	}
 }
 
+# Exclude /sys/kernel/debug and /sys/kernel/tracing from the search path
+sub skip_debugfs {
+	if (($File::Find::dir =~ m,^/sys/kernel,)) {
+		return grep {!/(debug|tracing)/ } @_;
+	}
+
+	if (($File::Find::dir =~ m,^/sys/fs,)) {
+		return grep {!/(pstore|bpf|fuse)/ } @_;
+	}
+
+	return @_
+}
+
+my %leaf;
+
+my $escape_symbols = qr { ([\x01-\x08\x0e-\x1f\x21-\x29\x2b-\x2d\x3a-\x40\x7b-\xff]) }x;
+sub parse_existing_sysfs {
+	my $file = $File::Find::name;
+
+	my $mode = (stat($file))[2];
+	return if ($mode & S_IFDIR);
+
+	my $leave = $file;
+	$leave =~ s,.*/,,;
+
+	if (defined($leaf{$leave})) {
+		# FIXME: need to check if the path makes sense
+		my $what = $leaf{$leave};
+
+		$what =~ s/,/ /g;
+
+		$what =~ s/\<[^\>]+\>/.*/g;
+		$what =~ s/\{[^\}]+\}/.*/g;
+		$what =~ s/\[[^\]]+\]/.*/g;
+		$what =~ s,/\.\.\./,/.*/,g;
+		$what =~ s,/\*/,/.*/,g;
+
+		$what =~ s/\s+/ /g;
+
+		# Escape all other symbols
+		$what =~ s/$escape_symbols/\\$1/g;
+
+		foreach my $i (split / /,$what) {
+			if ($file =~ m#^$i$#) {
+#				print "$file: $i: OK!\n";
+				return;
+			}
+		}
+
+		print "$file: $leave is defined at $what\n";
+
+		return;
+	}
+
+	print "$file not found.\n";
+}
+
+sub undefined_symbols {
+	foreach my $w (sort keys %data) {
+		foreach my $what (split /\xac /,$w) {
+			my $leave = $what;
+			$leave =~ s,.*/,,;
+
+			if (defined($leaf{$leave})) {
+				$leaf{$leave} .= " " . $what;
+			} else {
+				$leaf{$leave} = $what;
+			}
+		}
+	}
+
+	find({wanted =>\&parse_existing_sysfs, preprocess =>\&skip_debugfs, no_chdir => 1}, $sysfs_prefix);
+}
+
 # Ensure that the prefix will always end with a slash
 # While this is not needed for find, it makes the patch nicer
 # with --enable-lineno
 $prefix =~ s,/?$,/,;
 
+if ($cmd eq "undefined" || $cmd eq "search") {
+	$show_warnings = 0;
+}
 #
 # Parses all ABI files located at $prefix dir
 #
@@ -536,7 +617,9 @@ print STDERR Data::Dumper->Dump([\%data], [qw(*data)]) if ($debug);
 #
 # Handles the command
 #
-if ($cmd eq "search") {
+if ($cmd eq "undefined") {
+	undefined_symbols;
+} elsif ($cmd eq "search") {
 	search_symbols;
 } else {
 	if ($cmd eq "rest") {
@@ -575,6 +658,9 @@ B<rest>                  - output the ABI in ReST markup language
 
 B<validate>              - validate the ABI contents
 
+B<undefined>             - existing symbols at the system that aren't
+                           defined at Documentation/ABI
+
 =back
 
 =head1 OPTIONS
-- 
2.31.1

