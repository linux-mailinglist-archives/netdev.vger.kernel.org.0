Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2858D46D5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfJKRnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:43:10 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:47098 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728416AbfJKRnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:43:10 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id A41B7181D341A;
        Fri, 11 Oct 2019 17:43:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,
X-HE-Tag: cause95_7231ee8247c49
X-Filterd-Recvd-Size: 9632
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Fri, 11 Oct 2019 17:43:04 +0000 (UTC)
Message-ID: <9fe980f7e28242c2835ffae34914c5f68e8268a7.camel@perches.com>
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-sctp@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shawn Landden <shawn@git.icu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Fri, 11 Oct 2019 10:43:03 -0700
In-Reply-To: <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
References: <cover.1570292505.git.joe@perches.com>
         <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-11 at 09:29 -0700, Linus Torvalds wrote:
> On Sat, Oct 5, 2019 at 9:46 AM Joe Perches <joe@perches.com> wrote:
> > Add 'fallthrough' pseudo-keyword to enable the removal of comments
> > like '/* fallthrough */'.
> 
> I applied patches 1-3 to my tree just to make it easier for people to
> start doing this. Maybe some people want to do the conversion on their
> own subsystem rather than with a global script, but even if not, this
> looks better as a "prepare for the future" series and I feel that if
> we're doing the "fallthrough" thing eventually, the sooner we do the
> prepwork the better.
> 
> I'm a tiny bit worried that the actual conversion is just going to
> cause lots of pain for the stable people, but I'll not worry about it
> _too_ much. If the stable people decide that it's too painful for them
> to deal with the comment vs keyword model, they may want to backport
> these three patches too.

Shouldn't a conversion script be public somewhere?
The old cvt_style script could be reduced to something like the below.

From: Joe Perches <joe@perches.com>
Date: Fri, 11 Oct 2019 10:34:04 -0700
Subject: [PATCH] scripts:cvt_fallthrough.pl: Add script to convert /* fallthrough */ comments

Convert /* fallthrough */ style comments to the pseudo-keyword fallthrough;
to allow clang 10 and higher to work at finding missing fallthroughs too.

Requires a git repository and this overwrites the input sources.

Run with a path like:

    ./scripts/cvt_fallthrough.pl block

and all files in the path will be converted or a specific file like:

   ./scripts/cvt_fallthrough.pl drivers/net/wireless/zydas/zd1201.c

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/cvt_fallthrough.pl | 201 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 201 insertions(+)
 create mode 100755 scripts/cvt_fallthrough.pl

diff --git a/scripts/cvt_fallthrough.pl b/scripts/cvt_fallthrough.pl
new file mode 100755
index 000000000000..013379464f86
--- /dev/null
+++ b/scripts/cvt_fallthrough.pl
@@ -0,0 +1,201 @@
+#!/usr/bin/perl -w
+
+# script to modify /* fallthrough */ style comments to fallthrough;
+# use: perl cvt_fallthrough.pl <paths|files>
+# e.g.: perl cvtfallthrough.pl drivers/net/ethernet/intel
+
+use strict;
+
+my $P = $0;
+my $modified = 0;
+my $quiet = 0;
+
+sub expand_tabs {
+    my ($str) = @_;
+
+    my $res = '';
+    my $n = 0;
+    for my $c (split(//, $str)) {
+	if ($c eq "\t") {
+	    $res .= ' ';
+	    $n++;
+	    for (; ($n % 8) != 0; $n++) {
+		$res .= ' ';
+	    }
+	    next;
+	}
+	$res .= $c;
+	$n++;
+    }
+
+    return $res;
+}
+
+my $args = join(" ", @ARGV);
+my $output = `git ls-files -- $args`;
+my @files = split("\n", $output);
+
+foreach my $file (@files) {
+    my $f;
+    my $cvt = 0;
+    my $text;
+
+# read the file
+
+    next if ((-d $file));
+
+    open($f, '<', $file)
+	or die "$P: Can't open $file for read\n";
+    $text = do { local($/) ; <$f> };
+    close($f);
+
+    next if ($text eq "");
+
+    # for style:
+
+    # /* <fallthrough comment> */
+    # case FOO:
+
+    # while (comment has fallthrough and next non-blank, non-continuation line is (case or default:)) {
+    #   remove newline, whitespace before, fallthrough comment and whitespace after
+    #   insert newline, adjusted spacing and fallthrough; newline
+    # }
+
+    my $count = 0;
+    my @fallthroughs = (
+	'fallthrough',
+	'@fallthrough@',
+	'lint -fallthrough[ \t]*',
+	'[ \t.!]*(?:ELSE,? |INTENTIONAL(?:LY)? )?',
+	'intentional(?:ly)?[ \t]*fall(?:(?:s | |-)[Tt]|t)hr(?:ough|u|ew)',
+	'(?:else,?\s*)?FALL(?:S | |-)?THR(?:OUGH|U|EW)[ \t.!]*(?:-[^\n\r]*)?',
+	'[ \t.!]*(?:Else,? |Intentional(?:ly)? )?',
+	'Fall(?:(?:s | |-)[Tt]|t)hr(?:ough|u|ew)[ \t.!]*(?:-[^\n\r]*)?',
+	'[ \t.!]*(?:[Ee]lse,? |[Ii]ntentional(?:ly)? )?',
+	'fall(?:s | |-)?thr(?:ough|u|ew)[ \t.!]*(?:-[^\n\r]*)?',
+    );
+    do {
+	$count = 0;
+	pos($text) = 0;
+	foreach my $ft (@fallthroughs) {
+	    my $regex = '(((?:[ \t]*\n)*[ \t]*)(/\*\s*(?!\*/)?\b' . "$ft" . '\s*(?!\*/)?\*/(?:[ \t]*\n)*)([ \t]*))(?:case\s+|default\s*:)';
+
+	    while ($text =~ m{${regex}}i) {
+		my $all_but_case = $1;
+		my $space_before = $2;
+		my $fallthrough = $3;
+		my $space_after = $4;
+		my $pos_before = $-[1];
+		my $pos_after = $+[3];
+
+		# try to maintain any additional comment on the same line
+		my $comment = "";
+		if ($regex =~ /\\r/) {
+		    $comment = $fallthrough;
+		    $comment =~ s@^/\*\s*@@;
+		    $comment =~ s@\s*\*/\s*$@@;
+		    $comment =~ s@^\s*(?:intentional(?:ly)?\s+|else,?\s*)?fall[s\-]*\s*thr(?:ough|u|ew)[\s\.\-]*@@i;
+		    $comment =~ s@\s+$@@;
+		    $comment =~ s@\.*$@@;
+		    $comment = "\t/* $comment */" if ($comment ne "");
+		}
+		substr($text, $pos_before, $pos_after - $pos_before, "");
+		substr($text, $pos_before, 0, "\n${space_after}\tfallthrough;${comment}\n");
+		pos($text) = $pos_before;
+		$count++;
+	    }
+	}
+	$cvt += $count;
+        } while ($count > 0);
+
+    # Reset the fallthroughs types to a single regex
+
+    @fallthroughs = (
+	'fall(?:(?:s | |-)[Tt]|t)hr(?:ough|u|ew)'
+    );
+
+    # Convert the // <fallthrough> style comments followed by case/default:
+
+    do {
+	$count = 0;
+	pos($text) = 0;
+	foreach my $ft (@fallthroughs) {
+	    my $regex = '(((?:[ \t]*\n)*[ \t]*)(//[ \t]*(?!\n)?\b' . "$ft" . '[ \t]*(?!\n)?\n(?:[ \t]*\n)*)([ \t]*))(?:case\s+|default\s*:)';
+	    while ($text =~ m{${regex}}i) {
+		my $all_but_case = $1;
+		my $space_before = $2;
+		my $fallthrough = $3;
+		my $space_after = $4;
+		my $pos_before = $-[1];
+		my $pos_after = $+[3];
+
+		substr($text, $pos_before, $pos_after - $pos_before, "");
+		substr($text, $pos_before, 0, "\n${space_after}\tfallthrough;\n");
+		pos($text) = $pos_before;
+		$count++;
+	    }
+	}
+	$cvt += $count;
+    } while ($count > 0);
+
+    # Convert /* fallthrough */ comment macro lines with trailing \
+
+    do {
+	$count = 0;
+	pos($text) = 0;
+	foreach my $ft (@fallthroughs) {
+	    my $regex = '((?:[ \t]*\\\\\n)*([ \t]*)(/\*[ \t]*\b' . "$ft" . '[ \t]*\*/)([ \t]*))\\\\\n*([ \t]*(?:case\s+|default\s*:))';
+
+	    while ($text =~ m{${regex}}i) {
+		my $all_but_case = $1;
+		my $space_before = $2;
+		my $fallthrough = $3;
+		my $space_after = $4;
+		my $pos_before = $-[2];
+		my $pos_after = $+[4];
+
+		my $oldline = "${space_before}${fallthrough}${space_after}";
+		my $len = length(expand_tabs($oldline));
+
+		my $newline = "${space_before}fallthrough;${space_after}";
+		$newline .= "\t" while (length(expand_tabs($newline)) < $len);
+
+		substr($text, $pos_before, $pos_after - $pos_before, "");
+		substr($text, $pos_before, 0, "$newline");
+		pos($text) = $pos_before;
+		$count++;
+	    }
+	}
+	$cvt += $count;
+    } while ($count > 0);
+
+# write the file if something was changed
+
+    if ($cvt > 0) {
+	$modified = 1;
+
+	open($f, '>', $file)
+	    or die "$P: Can't open $file for write\n";
+	print $f $text;
+	close($f);
+
+	print "fallthroughs: $cvt	$file\n" if (!$quiet);
+    }
+}
+
+if ($modified && !$quiet) {
+    print <<EOT;
+
+Warning: these changes may not be correct.
+
+These changes should be carefully reviewed manually and not combined with
+any functional changes.
+
+Compile, build and test your changes.
+
+You should understand and be responsible for all object changes.
+
+Make sure you read Documentation/SubmittingPatches before sending
+any changes to reviewers, maintainers or mailing lists.
+EOT
+}
-- 
2.15.0




