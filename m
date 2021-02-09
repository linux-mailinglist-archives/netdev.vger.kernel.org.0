Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0690315A92
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhBJAE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234873AbhBIXPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:15:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8ADA64E66;
        Tue,  9 Feb 2021 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612912505;
        bh=GjKtDov2e20s4suAnKPKNoJN30GSYuXcgZ8iZ64nx70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=unOsqKXOlzacTMQkIgsK9QKX1o69G9sVyuFIZwt4TPMMXePGNOrSw9ct5GntjggOR
         NipAXvpchcZxIjcoNPr3cnvg1LjR7HCCoLjSbmboasTiAG2Dh2c2zNVlcUAlSya7dm
         lzwxrm1Nmv2Ue6K6QXKxMLZuPVqlWK8MZZATGSxWrjNDFv0Ke7fDvFnozcJHmzKTGz
         A2VlZLKLAEZtC94a7uexQryVf2+O98uQ10FbahS5jFMf+cvl1Iu4LAf/38yCEsOO5L
         9Nc2I62iziHZj39iskNQ8mLjV4djj7GvLGQUJ/JZeVO2VzIk1z4RPjK0H0+NMbFGsB
         y+hNpR1K+9JSA==
Date:   Tue, 9 Feb 2021 16:15:03 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Kiss <daniel.kiss@arm.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <20210209231503.GA19859@ubuntu-m3-large-x86>
References: <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
 <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
 <YCL1qLzuATlvM8Dh@krava>
 <YCMBmNujLsMg0Q0q@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCMBmNujLsMg0Q0q@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:41:44PM +0100, Jiri Olsa wrote:
> On Tue, Feb 09, 2021 at 09:50:48PM +0100, Jiri Olsa wrote:
> > On Tue, Feb 09, 2021 at 12:09:31PM -0800, Nick Desaulniers wrote:
> > > On Tue, Feb 9, 2021 at 11:06 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Tue, Feb 09, 2021 at 05:13:42PM +0100, Jiri Olsa wrote:
> > > > > On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> > > > >
> > > > > SNIP
> > > > >
> > > > > > > > > >                 DW_AT_prototyped        (true)
> > > > > > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > > > > > >                 DW_AT_external  (true)
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > > > > > strange, given vfs_truncate is just a normal global function.
> > > > > > >
> > > > > > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > > > > > that appears to be nops, which would suggest it's traceable
> > > > > > >
> > > > > > >   ffff80001031f430 <vfs_truncate>:
> > > > > > >   ffff80001031f430: 5f 24 03 d5   hint    #34
> > > > > > >   ffff80001031f434: 1f 20 03 d5   nop
> > > > > > >   ffff80001031f438: 1f 20 03 d5   nop
> > > > > > >   ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > > > > >
> > > > > > > > >
> > > > > > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > > > > > addresses only for static functions, not the global ones (global ones
> > > > > > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > > > > >
> > > > > > I'm still trying to build the kernel.. however ;-)
> > > > >
> > > > > I finally reproduced.. however arm's not using mcount_loc
> > > > > but some other special section.. so it's new mess for me
> > > >
> > > > so ftrace data actualy has vfs_truncate address but with extra 4 bytes:
> > > >
> > > >         ffff80001031f434
> > > >
> > > > real vfs_truncate address:
> > > >
> > > >         ffff80001031f430 g     F .text  0000000000000168 vfs_truncate
> > > >
> > > > vfs_truncate disasm:
> > > >
> > > >         ffff80001031f430 <vfs_truncate>:
> > > >         ffff80001031f430: 5f 24 03 d5   hint    #34
> > > >         ffff80001031f434: 1f 20 03 d5   nop
> > > >         ffff80001031f438: 1f 20 03 d5   nop
> > > >         ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > >
> > > > thats why we don't match it in pahole.. I checked few other functions
> > > > and some have the same problem and some match the function boundary
> > > >
> > > > those that match don't have that first hint instrucion, like:
> > > >
> > > >         ffff800010321e40 <do_faccessat>:
> > > >         ffff800010321e40: 1f 20 03 d5   nop
> > > >         ffff800010321e44: 1f 20 03 d5   nop
> > > >         ffff800010321e48: 3f 23 03 d5   hint    #25
> > > >
> > > > any hints about hint instructions? ;-)
> > > 
> > > aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
> > > encoding space to make software backwards compatible on older hardware
> > > that doesn't support such instructions.  Is this BTI, perhaps? (The
> > > function is perhaps the destination of an indirect call?)
> > 
> > I see, I think we can't take ftrace addresses as start of the function
> > because there could be extra instruction(s) related to the call before
> > it like here
> > 
> > we need to check ftrace address be within the function/symbol,
> > not exact start
> 
> the build with gcc passed only because mcount data are all zeros
> and pahole falls back to 'not-ftrace' mode
> 
> 	$ llvm-objdump -t build/aarch64-gcc/vmlinux | grep mcount
> 	ffff800011eb4840 g       .init.data     0000000000000000 __stop_mcount_loc
> 	ffff800011e47d58 g       .init.data     0000000000000000 __start_mcount_loc
> 
> 	$ llvm-objdump -s build/aarch64-gcc/vmlinux	
> 	ffff800011e47d50 00000000 00000000 00000000 00000000  ................
> 	ffff800011e47d60 00000000 00000000 00000000 00000000  ................
> 	ffff800011e47d70 00000000 00000000 00000000 00000000  ................
> 	ffff800011e47d80 00000000 00000000 00000000 00000000  ................
> 	ffff800011e47d90 00000000 00000000 00000000 00000000  ................
> 	...
> 
> 	we should check on why it's zero
> 
> 	Nathan, any chance you could run kernel built with gcc and check on ftrace?

Sure, with GCC 10.2.0:

/ # cat /proc/version
Linux version 5.11.0-rc7 (nathan@ubuntu-m3-large-x86) (aarch64-linux-gcc (GCC) 10.2.0, GNU ld (GNU Binutils) 2.35) #1 SMP PREEMPT Tue Feb 9 16:04:19 MST 2021

/ # grep vfs_truncate /sys/kernel/debug/tracing/available_filter_functions
vfs_truncate

/ # zcat /proc/config.gz | grep "DEBUG_INFO_BTF\|FTRACE\|BPF"
# CONFIG_CGROUP_BPF is not set
CONFIG_BPF=y
# CONFIG_BPF_LSM is not set
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
# CONFIG_BPF_JIT_ALWAYS_ON is not set
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_BPFILTER is not set
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_ACT_BPF is not set
CONFIG_BPF_JIT=y
CONFIG_HAVE_EBPF_JIT=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_DEBUG_INFO_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BPF_EVENTS=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_TEST_BPF is not set

Cheers,
Nathan

> the build with clang fails because the ftrace data are there,
> but pahole takes them as 'start' of the function, which is wrong
> 
> 	$ llvm-objdump -t build/aarch64/vmlinux | grep mcount
> 	ffff800011d27d10 g       .init.data     0000000000000000 __start_mcount_loc
> 	ffff800011d90038 g       .init.data     0000000000000000 __stop_mcount_loc
> 
> 	$ llvm-objdump -s build/aarch64-gcc/vmlinux	
> 	ffff800011d27d10 cc330110 0080ffff 1c340110 0080ffff  .3.......4......
> 	ffff800011d27d20 6c340110 0080ffff 1004c111 0080ffff  l4..............
> 	ffff800011d27d30 3804c111 0080ffff 6004c111 0080ffff  8.......`.......
> 	ffff800011d27d40 8804c111 0080ffff 0405c111 0080ffff  ................
> 	ffff800011d27d50 3805c111 0080ffff 7c05c111 0080ffff  8.......|.......
> 	...
> 
> I think if we fix pahole to take check the ftrace address is
> within the processed function, we should be fine.. I'll try to
> send something soon
> 
> jirka
> 
