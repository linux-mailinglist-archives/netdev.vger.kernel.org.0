Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602BB315408
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhBIQgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhBIQf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 11:35:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B439C64D9D;
        Tue,  9 Feb 2021 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612888516;
        bh=FbZyTh5IczKDN/f7KiXflfh/9H+InBheqAUMJUtXGRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MDbYDSB44ibcP7lZKLq6Qo6XKgCV5ltsbVfIM888A5hpBsfY9oLURbwT/A4j7/ic4
         kzN/9qvNjg01SDV9szLYbpPnK4Pjv7fk6FRi1Lwh4hUao3zw5SIZ5uRXVPNEcv38ck
         kmqwUYAy7nA3qkDaYdEW9GnjFvUyJhwQFb7NvjnKFl8pNrpNHq9frVU1PGZ5ZzMPTc
         Z88ateENrrPTouxGwjj/i9HKNIja6N62VvjIKLCJrapKfc9rfgRstr1cfFrhdYUk30
         j24cOZygvuK7tw65v4T1q+sgCrIzm44iMEQ3JvvxlbyKcyKBg1euqZsL7cIyHsJCx3
         wdILx3ASkeoHQ==
Date:   Tue, 9 Feb 2021 09:35:14 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <20210209163514.GA1226277@ubuntu-m3-large-x86>
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
 <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCKwxNDkS9rdr43W@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:13:38PM +0100, Jiri Olsa wrote:
> On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> 
> SNIP
> 
> > > > > >                 DW_AT_prototyped        (true)
> > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > >                 DW_AT_external  (true)
> > > > > >
> > > > > 
> > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > strange, given vfs_truncate is just a normal global function.
> > > 
> > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > that appears to be nops, which would suggest it's traceable
> > > 
> > > 	ffff80001031f430 <vfs_truncate>:
> > > 	ffff80001031f430: 5f 24 03 d5   hint    #34
> > > 	ffff80001031f434: 1f 20 03 d5   nop
> > > 	ffff80001031f438: 1f 20 03 d5   nop
> > > 	ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > 
> > > > > 
> > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > addresses only for static functions, not the global ones (global ones
> > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > 
> > I'm still trying to build the kernel.. however ;-)
> 
> I finally reproduced.. however arm's not using mcount_loc
> but some other special section.. so it's new mess for me
> 
> however I tried the same build without LLVM=1 and it passed,
> so my guess is that clang is doing something unexpected
> 
> jirka
> 

Additionally, if I remove the btfid generation section in
scripts/link-vmlinux.sh to bypass that and get a working Image.gz,
vfs_truncate is in the list of available functions:

/ # grep vfs_truncate /sys/kernel/debug/tracing/available_filter_functions
vfs_truncate

/ # cat /proc/version
Linux version 5.11.0-rc7-dirty (nathan@ubuntu-m3-large-x86) (ClangBuiltLinux clang version 13.0.0 (https://github.com/llvm/llvm-project 8f130f108fedfcf6cb80ef594560a87341028a37), LLD 13.0.0 (https://github.com/llvm/llvm-project 8f130f108fedfcf6cb80ef594560a87341028a37)) #1 SMP PREEMPT Tue Feb 9 09:25:36 MST 2021

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
