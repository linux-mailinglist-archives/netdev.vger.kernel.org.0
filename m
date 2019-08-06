Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D6B82A6F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 06:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfHFEjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 00:39:06 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:36604 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfHFEjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 00:39:06 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x764bcwx031340;
        Tue, 6 Aug 2019 13:37:39 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x764bcwx031340
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1565066259;
        bh=DssnpgN3lxR1x9/Nc48fcCal/c42cAzZLORr8Jquom8=;
        h=From:To:Cc:Subject:Date:From;
        b=FBEhx0k1/VXFd+9Dyo7ZWsGCBPr/2mFs1YQm9vEP+No8jX4tLt36lr4TS2uWCgoPm
         OZ71RUINKTQ5aCSfr0ZJ9dTWXzX+aWQ48+KmEhokWh497XyppQEVSzKET09f5uOVAa
         viOcZmihxO0kvAq9FIE7k8n5umcrD0h+Zzec1uVpsrwd3mLytGMhErJZIfZakifOEZ
         u5KVVJDq9bHWUEyLDNxUsQHQdGZ+m4xWWMnIJgOKXOBjOhbo5GWoB9pEnR7wE2ht2u
         dfWSIuAmgqisoQMyCBEG02Bw9hJwlM0jjnf8iiFLOQYfLokQ2IfZ5SEy0aUEAQmQPE
         /S8Hg7ZRjo33Q==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH] kbuild: re-implement detection of CONFIG options leaked to user-space
Date:   Tue,  6 Aug 2019 13:37:29 +0900
Message-Id: <20190806043729.5562-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

scripts/headers_check.pl can detect references to CONFIG options in
exported headers, but it has been disabled for more than a decade.

Reverting commit 7e3fa5614117 ("kbuild: drop check for CONFIG_ in
headers_check") would emit the following warnings for headers_check
on x86:

usr/include/mtd/ubi-user.h:283: leaks CONFIG_MTD_UBI_BEB_LIMIT to userspace where it is not valid
usr/include/linux/elfcore.h:62: leaks CONFIG_BINFMT_ELF_FDPIC to userspace where it is not valid
usr/include/linux/atmdev.h:104: leaks CONFIG_COMPAT to userspace where it is not valid
usr/include/linux/raw.h:17: leaks CONFIG_MAX_RAW_DEVS to userspace where it is not valid
usr/include/linux/pktcdvd.h:37: leaks CONFIG_CDROM_PKTCDVD_WCACHE to userspace where it is not valid
usr/include/linux/videodev2.h:2465: leaks CONFIG_VIDEO_ADV_DEBUG to userspace where it is not valid
usr/include/linux/bpf.h:249: leaks CONFIG_EFFICIENT_UNALIGNED_ACCESS to userspace where it is not valid
usr/include/linux/bpf.h:819: leaks CONFIG_CGROUP_NET_CLASSID to userspace where it is not valid
usr/include/linux/bpf.h:1011: leaks CONFIG_IP_ROUTE_CLASSID to userspace where it is not valid
usr/include/linux/bpf.h:1742: leaks CONFIG_BPF_KPROBE_OVERRIDE to userspace where it is not valid
usr/include/linux/bpf.h:1747: leaks CONFIG_FUNCTION_ERROR_INJECTION to userspace where it is not valid
usr/include/linux/bpf.h:1936: leaks CONFIG_XFRM to userspace where it is not valid
usr/include/linux/bpf.h:2184: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
usr/include/linux/bpf.h:2210: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
usr/include/linux/bpf.h:2227: leaks CONFIG_SOCK_CGROUP_DATA to userspace where it is not valid
usr/include/linux/bpf.h:2311: leaks CONFIG_NET to userspace where it is not valid
usr/include/linux/bpf.h:2348: leaks CONFIG_NET to userspace where it is not valid
usr/include/linux/bpf.h:2422: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
usr/include/linux/bpf.h:2528: leaks CONFIG_NET to userspace where it is not valid
usr/include/linux/eventpoll.h:82: leaks CONFIG_PM_SLEEP to userspace where it is not valid
usr/include/linux/hw_breakpoint.h:27: leaks CONFIG_HAVE_MIXED_BREAKPOINTS_REGS to userspace where it is not valid
usr/include/linux/cm4000_cs.h:26: leaks CONFIG_COMPAT to userspace where it is not valid
usr/include/linux/pkt_cls.h:301: leaks CONFIG_NET_CLS_ACT to userspace where it is not valid
usr/include/asm-generic/unistd.h:651: leaks CONFIG_MMU to userspace where it is not valid
usr/include/asm-generic/fcntl.h:119: leaks CONFIG_64BIT to userspace where it is not valid
usr/include/asm-generic/bitsperlong.h:9: leaks CONFIG_64BIT to userspace where it is not valid
usr/include/asm/e820.h:14: leaks CONFIG_NODES_SHIFT to userspace where it is not valid
usr/include/asm/e820.h:39: leaks CONFIG_X86_PMEM_LEGACY to userspace where it is not valid
usr/include/asm/e820.h:49: leaks CONFIG_INTEL_TXT to userspace where it is not valid
usr/include/asm/mman.h:7: leaks CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS to userspace where it is not valid
usr/include/asm/auxvec.h:14: leaks CONFIG_IA32_EMULATION to userspace where it is not valid

Most of these are false positives because scripts/headers_check.pl
parses comment lines.

It is also false negative. arch/x86/include/uapi/asm/auxvec.h contains
CONFIG_IA32_EMULATION and CONFIG_X86_64, but the only former is reported.

It would be possible to fix scripts/headers_check.pl, of course.
However, we already have some duplicated checks between headers_check
and CONFIG_UAPI_HEADER_TEST. At this moment of time, there are still
dozens of headers excluded from the header test (usr/include/Makefile),
but we might be able to remove headers_check when the time comes.

I re-implemented it in scripts/headers_install.sh by using sed because
the most of code in scripts/headers_install.sh is written is sed.

This patch works like this:

[1] Run scripts/unifdef first because we need to drop the code
    surrounded by #ifdef __KERNEL__ ... #endif

[2] Remove all C style comments. The sed code is somewhat complicated
    since we need to deal with both single and multi line comments.

    Precisely speaking, a comment block is replaced with a space just
    in case.

      CONFIG_FOO/* this is a comment */CONFIG_BAR

    should be converted into:

      CONFIG_FOO CONFIG_BAR

    instead of:

      CONFIG_FOOCONFIG_BAR

[3] Match CONFIG_... pattern. It correctly matches to all CONFIG options
    that appear in a single line.

After this commit, you will see the following warnings, all of which
are real ones.

warning: include/uapi/linux/elfcore.h: leaks CONFIG_BINFMT_ELF_FDPIC to user-space
warning: include/uapi/linux/atmdev.h: leaks CONFIG_COMPAT to user-space
warning: include/uapi/linux/raw.h: leaks CONFIG_MAX_RAW_DEVS to user-space
warning: include/uapi/linux/pktcdvd.h: leaks CONFIG_CDROM_PKTCDVD_WCACHE to user-space
warning: include/uapi/linux/eventpoll.h: leaks CONFIG_PM_SLEEP to user-space
warning: include/uapi/linux/hw_breakpoint.h: leaks CONFIG_HAVE_MIXED_BREAKPOINTS_REGS to user-space
warning: include/uapi/asm-generic/fcntl.h: leaks CONFIG_64BIT to user-space
warning: arch/x86/include/uapi/asm/mman.h: leaks CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS to user-space
warning: arch/x86/include/uapi/asm/auxvec.h: leaks CONFIG_IA32_EMULATION to user-space
warning: arch/x86/include/uapi/asm/auxvec.h: leaks CONFIG_X86_64 to user-space

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

I was playing with sed yesterday, but the resulted code might be unreadable.

Sed scripts tend to be somewhat unreadable.
I just wondered which language is appropriate for this?
Maybe perl, or what else? I am not good at perl, though.

Maybe, it will be better to fix existing warnings
before enabling this check.
If somebody takes a closer look at them, that would be great.

 scripts/headers_install.sh | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index bbaf29386995..73d95e457090 100755
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -41,5 +41,34 @@ sed -E -e '
 scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ $TMPFILE > $OUTFILE
 [ $? -gt 1 ] && exit 1
 
+# Remove /* ... */ style comments, and find CONFIG_ references in code
+configs=$(sed -e '
+:comment
+	s:/\*[^*][^*]*:/*:
+	s:/\*\*\**\([^/]\):/*\1:
+	t comment
+	s:/\*\*/: :
+	t comment
+	/\/\*/! b check
+	N
+	b comment
+:print
+	P
+	D
+:check
+	s:^[^[:alnum:]_][^[:alnum:]_]*::
+	t check
+	s:^\(CONFIG_[[:alnum:]_]*\):\1\n:
+	t print
+	s:^[[:alnum:]_][[:alnum:]_]*::
+	t check
+	d
+' $OUTFILE)
+
+for c in $configs
+do
+	echo "warning: $INFILE: leaks $c to user-space" >&2
+done
+
 rm -f $TMPFILE
 trap - EXIT
-- 
2.17.1

