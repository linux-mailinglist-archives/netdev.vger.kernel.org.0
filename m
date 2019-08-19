Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC0927AF
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfHSOzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:55:46 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:33956 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSOzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:55:46 -0400
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x7JEtfPq000772;
        Mon, 19 Aug 2019 23:55:41 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x7JEtfPq000772
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1566226542;
        bh=Q/4yu2quhKpFiAtrUyID1ndn2O+ccw4Wwi6mVMB/jjo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LbzKYxVxMq6Ap89f4+Ed7Q8LWOznLJHx/JFbltr+mEd7hSrgeZFQfdIjmX4YxdPFk
         aGeFjoIvK07y6L2q7c9jf6ejopg/DE4YdSD8DpyK6tLa4EkQFCVcZYYZDoOpQRIGl1
         GfmIWuZHcTo176OsKZfYKnKSoWtg75+ECUflECV7+a/RCAEmwHEHZbdeeuKEvGc5Vs
         CsqO8FWEdaBAjgQcN8FFbQakRs8+4DnETE/er79AT0kuCdOV6LEoPU5+Iex17PYwmN
         jugSIfquONwFX66vXZ0VpfDPT6m+jpypCBZSeVBMzLfjMCUCGqq/abxpPaUAp5CKlQ
         GeJwAKIS8LYWQ==
X-Nifty-SrcIP: [209.85.222.43]
Received: by mail-ua1-f43.google.com with SMTP id g13so751413uap.5;
        Mon, 19 Aug 2019 07:55:41 -0700 (PDT)
X-Gm-Message-State: APjAAAUPkghq/I5i58IVTP5UA4kBMpbgDoumT8id1Qwl4nGsILLQnRUw
        +b3Ef5b+3/Xg1qAXUzASTxKbcGT9tV1PvW4OjCM=
X-Google-Smtp-Source: APXvYqxD8by10RicZpTaoAg56x2if0yN69ea8rMSnyI9Y5de5n+UHSWosKcObR6X5U9kDtQdPA+jb2DVzJhLpBJDPXg=
X-Received: by 2002:ab0:4261:: with SMTP id i88mr3720679uai.95.1566226540561;
 Mon, 19 Aug 2019 07:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190810170135.31183-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190810170135.31183-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 19 Aug 2019 23:55:04 +0900
X-Gmail-Original-Message-ID: <CAK7LNARemN8GC0t9yX2e1W_P=gvqODrf3cH4f1bEEtkTek8CCw@mail.gmail.com>
Message-ID: <CAK7LNARemN8GC0t9yX2e1W_P=gvqODrf3cH4f1bEEtkTek8CCw@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: re-implement detection of CONFIG options
 leaked to user-space
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 2:03 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> scripts/headers_check.pl can detect references to CONFIG options in
> exported headers, but it has been disabled for more than a decade.
>
> Reverting commit 7e3fa5614117 ("kbuild: drop check for CONFIG_ in
> headers_check") would emit the following warnings for headers_check
> on x86:
>
> usr/include/mtd/ubi-user.h:283: leaks CONFIG_MTD_UBI_BEB_LIMIT to userspace where it is not valid
> usr/include/linux/cm4000_cs.h:26: leaks CONFIG_COMPAT to userspace where it is not valid
> usr/include/linux/pkt_cls.h:301: leaks CONFIG_NET_CLS_ACT to userspace where it is not valid
> usr/include/linux/videodev2.h:2465: leaks CONFIG_VIDEO_ADV_DEBUG to userspace where it is not valid
> usr/include/linux/bpf.h:249: leaks CONFIG_EFFICIENT_UNALIGNED_ACCESS to userspace where it is not valid
> usr/include/linux/bpf.h:819: leaks CONFIG_CGROUP_NET_CLASSID to userspace where it is not valid
> usr/include/linux/bpf.h:1011: leaks CONFIG_IP_ROUTE_CLASSID to userspace where it is not valid
> usr/include/linux/bpf.h:1742: leaks CONFIG_BPF_KPROBE_OVERRIDE to userspace where it is not valid
> usr/include/linux/bpf.h:1747: leaks CONFIG_FUNCTION_ERROR_INJECTION to userspace where it is not valid
> usr/include/linux/bpf.h:1936: leaks CONFIG_XFRM to userspace where it is not valid
> usr/include/linux/bpf.h:2184: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
> usr/include/linux/bpf.h:2210: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
> usr/include/linux/bpf.h:2227: leaks CONFIG_SOCK_CGROUP_DATA to userspace where it is not valid
> usr/include/linux/bpf.h:2311: leaks CONFIG_NET to userspace where it is not valid
> usr/include/linux/bpf.h:2348: leaks CONFIG_NET to userspace where it is not valid
> usr/include/linux/bpf.h:2422: leaks CONFIG_BPF_LIRC_MODE2 to userspace where it is not valid
> usr/include/linux/bpf.h:2528: leaks CONFIG_NET to userspace where it is not valid
> usr/include/linux/pktcdvd.h:37: leaks CONFIG_CDROM_PKTCDVD_WCACHE to userspace where it is not valid
> usr/include/linux/hw_breakpoint.h:27: leaks CONFIG_HAVE_MIXED_BREAKPOINTS_REGS to userspace where it is not valid
> usr/include/linux/raw.h:17: leaks CONFIG_MAX_RAW_DEVS to userspace where it is not valid
> usr/include/linux/elfcore.h:62: leaks CONFIG_BINFMT_ELF_FDPIC to userspace where it is not valid
> usr/include/linux/eventpoll.h:82: leaks CONFIG_PM_SLEEP to userspace where it is not valid
> usr/include/linux/atmdev.h:104: leaks CONFIG_COMPAT to userspace where it is not valid
> usr/include/asm-generic/unistd.h:651: leaks CONFIG_MMU to userspace where it is not valid
> usr/include/asm-generic/bitsperlong.h:9: leaks CONFIG_64BIT to userspace where it is not valid
> usr/include/asm-generic/fcntl.h:119: leaks CONFIG_64BIT to userspace where it is not valid
> usr/include/asm/auxvec.h:14: leaks CONFIG_IA32_EMULATION to userspace where it is not valid
> usr/include/asm/e820.h:14: leaks CONFIG_NODES_SHIFT to userspace where it is not valid
> usr/include/asm/e820.h:39: leaks CONFIG_X86_PMEM_LEGACY to userspace where it is not valid
> usr/include/asm/e820.h:49: leaks CONFIG_INTEL_TXT to userspace where it is not valid
> usr/include/asm/mman.h:7: leaks CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS to userspace where it is not valid
>
> Most of these are false positives because scripts/headers_check.pl
> parses comment lines.
>
> It is also false negative. arch/x86/include/uapi/asm/auxvec.h contains
> CONFIG_IA32_EMULATION and CONFIG_X86_64, but the only former is reported.
>
> It would be possible to fix scripts/headers_check.pl, of course.
> However, we already have some duplicated checks between headers_check
> and CONFIG_UAPI_HEADER_TEST. At this moment of time, there are still
> dozens of headers excluded from the header test (usr/include/Makefile),
> but we might be able to remove headers_check eventually.
>
> I re-implemented it in scripts/headers_install.sh by using sed because
> the most of code in scripts/headers_install.sh is written in sed.
>
> This patch works like this:
>
> [1] Run scripts/unifdef first because we need to drop the code
>     surrounded by #ifdef __KERNEL__ ... #endif
>
> [2] Remove all C style comments. The sed code is somewhat complicated
>     since we need to deal with both single and multi line comments.
>
>     Precisely speaking, a comment block is replaced with a space just
>     in case.
>
>       CONFIG_FOO/* this is a comment */CONFIG_BAR
>
>     should be converted into:
>
>       CONFIG_FOO CONFIG_BAR
>
>     instead of:
>
>       CONFIG_FOOCONFIG_BAR
>
> [3] Match CONFIG_... pattern. It correctly matches to all CONFIG
>     options that appear in a single line.
>
> After this commit, this would detect the following warnings, all of
> which are real ones.
>
> warning: include/uapi/linux/pktcdvd.h: leak CONFIG_CDROM_PKTCDVD_WCACHE to user-space
> warning: include/uapi/linux/hw_breakpoint.h: leak CONFIG_HAVE_MIXED_BREAKPOINTS_REGS to user-space
> warning: include/uapi/linux/raw.h: leak CONFIG_MAX_RAW_DEVS to user-space
> warning: include/uapi/linux/elfcore.h: leak CONFIG_BINFMT_ELF_FDPIC to user-space
> warning: include/uapi/linux/eventpoll.h: leak CONFIG_PM_SLEEP to user-space
> warning: include/uapi/linux/atmdev.h: leak CONFIG_COMPAT to user-space
> warning: include/uapi/asm-generic/fcntl.h: leak CONFIG_64BIT to user-space
> warning: arch/x86/include/uapi/asm/auxvec.h: leak CONFIG_IA32_EMULATION to user-space
> warning: arch/x86/include/uapi/asm/auxvec.h: leak CONFIG_X86_64 to user-space
> warning: arch/x86/include/uapi/asm/mman.h: leak CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS to user-space
>
> However, it is not nice to show them right now. I created a list of
> existing leakages. They are not warned, but a new leakage will be
> blocked by the 0-day bot.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---

I slightly fixed up this to avoid warnings for O= building,
and applied.



> Changes in v2:
>   - Add a whitelist. The CONFIG leakages in this list are not warned.
>     This patch can be applied now. A new leakage will be blocked.
>   - Shorten the sed code slightly
>
>  scripts/headers_install.sh | 63 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
> index bbaf29386995..770d239cc11e 100755
> --- a/scripts/headers_install.sh
> +++ b/scripts/headers_install.sh
> @@ -41,5 +41,68 @@ sed -E -e '
>  scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ $TMPFILE > $OUTFILE
>  [ $? -gt 1 ] && exit 1
>
> +# Remove /* ... */ style comments, and find CONFIG_ references in code
> +configs=$(sed -e '
> +:comment
> +       s:/\*[^*][^*]*:/*:
> +       s:/\*\*\**\([^/]\):/*\1:
> +       t comment
> +       s:/\*\*/: :
> +       t comment
> +       /\/\*/! b check
> +       N
> +       b comment
> +:print
> +       P
> +       D
> +:check
> +       s:^\(CONFIG_[[:alnum:]_]*\):\1\n:
> +       t print
> +       s:^[[:alnum:]_][[:alnum:]_]*::
> +       s:^[^[:alnum:]_][^[:alnum:]_]*::
> +       t check
> +       d
> +' $OUTFILE)
> +
> +# The entries in the following list are not warned.
> +# Please do not add a new entry. This list is only for existing ones.
> +# The list will be reduced gradually, and deleted eventually. (hopefully)
> +#
> +# The format is <file-name>:<CONFIG-option> in each line.
> +config_leak_no_warn="
> +arch/alpha/include/uapi/asm/setup.h:CONFIG_ALPHA_LEGACY_START_ADDRESS
> +arch/arc/include/uapi/asm/page.h:CONFIG_ARC_PAGE_SIZE_16K
> +arch/arc/include/uapi/asm/page.h:CONFIG_ARC_PAGE_SIZE_4K
> +arch/arc/include/uapi/asm/swab.h:CONFIG_ARC_HAS_SWAPE
> +arch/arm/include/uapi/asm/ptrace.h:CONFIG_CPU_ENDIAN_BE8
> +arch/hexagon/include/uapi/asm/ptrace.h:CONFIG_HEXAGON_ARCH_VERSION
> +arch/hexagon/include/uapi/asm/user.h:CONFIG_HEXAGON_ARCH_VERSION
> +arch/ia64/include/uapi/asm/cmpxchg.h:CONFIG_IA64_DEBUG_CMPXCHG
> +arch/m68k/include/uapi/asm/ptrace.h:CONFIG_COLDFIRE
> +arch/nios2/include/uapi/asm/swab.h:CONFIG_NIOS2_CI_SWAB_NO
> +arch/nios2/include/uapi/asm/swab.h:CONFIG_NIOS2_CI_SWAB_SUPPORT
> +arch/sh/include/uapi/asm/ptrace.h:CONFIG_CPU_SH5
> +arch/sh/include/uapi/asm/sigcontext.h:CONFIG_CPU_SH5
> +arch/sh/include/uapi/asm/stat.h:CONFIG_CPU_SH5
> +arch/x86/include/uapi/asm/auxvec.h:CONFIG_IA32_EMULATION
> +arch/x86/include/uapi/asm/auxvec.h:CONFIG_X86_64
> +arch/x86/include/uapi/asm/mman.h:CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> +include/uapi/asm-generic/fcntl.h:CONFIG_64BIT
> +include/uapi/linux/atmdev.h:CONFIG_COMPAT
> +include/uapi/linux/elfcore.h:CONFIG_BINFMT_ELF_FDPIC
> +include/uapi/linux/eventpoll.h:CONFIG_PM_SLEEP
> +include/uapi/linux/hw_breakpoint.h:CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
> +include/uapi/linux/pktcdvd.h:CONFIG_CDROM_PKTCDVD_WCACHE
> +include/uapi/linux/raw.h:CONFIG_MAX_RAW_DEVS
> +"
> +
> +for c in $configs
> +do
> +       if echo "$config_leak_no_warn" | grep -q "^$INFILE:$c$"; then
> +               continue
> +       fi
> +       echo "warning: $INFILE: leak $c to user-space" >&2
> +done
> +
>  rm -f $TMPFILE
>  trap - EXIT
> --
> 2.17.1
>


-- 
Best Regards
Masahiro Yamada
