Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77113149BB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhBIHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhBIHtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:49:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADCB564DAD;
        Tue,  9 Feb 2021 07:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612856946;
        bh=/SNqtftskEpElNwIO7PvQ63VYNJ2uOZGomafU5ITgG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AnU+F4OMQglm+KCbEUNPKBByBMHdxGg2BlpS37vc7BaS4/9OaIDorR0qho1RCYKol
         lCQVZvOkBvn2e5M5JdrswjybtXGMe6hGL93eqOUOGPHov9pIEum3pr16AQEPck3mfH
         tXn3Ysi8fWmiIud9fZRen27TtJh9rM0v/joAgoVg39Akt5Zs1B9blDGTpzi12ekvA6
         WTXrJYnkA5o8IOyGYUBlJ1B+E2Jtme47P7Hg1huR+KrUL84o5OLvh4OKKk8bu5VGxp
         kJ2DGqlJ9doqszRqRj9DhWwVxQRjTzmRXtxIfDlKNsTJlMFCJpSKTUb+xFYIGBUU1f
         Kk3Mov6C3AwmQ==
Date:   Tue, 9 Feb 2021 00:49:04 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20210209074904.GA286822@ubuntu-m3-large-x86>
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
 <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 10:56:36PM -0800, Andrii Nakryiko wrote:
> On Mon, Feb 8, 2021 at 10:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Feb 8, 2021 at 10:09 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Feb 8, 2021 at 9:23 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > >
> > > > On Mon, Feb 08, 2021 at 08:45:43PM -0800, Andrii Nakryiko wrote:
> > > > > On Mon, Feb 8, 2021 at 7:44 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > > >
> > > > > > Hi all,
> > > > > >
> > > > > > Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
> > > > > > https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ
> > > > > >
> > > > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > > > >                       LLVM=1 O=build/aarch64 defconfig
> > > > > >
> > > > > > $ scripts/config \
> > > > > >     --file build/aarch64/.config \
> > > > > >     -e BPF_SYSCALL \
> > > > > >     -e DEBUG_INFO_BTF \
> > > > > >     -e FTRACE \
> > > > > >     -e FUNCTION_TRACER
> > > > > >
> > > > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > > > >                       LLVM=1 O=build/aarch64 olddefconfig all
> > > > > > ...
> > > > > > FAILED unresolved symbol vfs_truncate
> > > > > > ...
> > > > > >
> > > > > > My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
> > > > > > although that seems obvious given that is what introduced
> > > > > > BTF_ID(func, vfs_truncate).
> > > > > >
> > > > > > I am using the latest pahole v1.20 and LLVM is at
> > > > > > https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
> > > > > > although I can reproduce back to LLVM 10.0.1, which is the earliest
> > > > > > version that the kernel supports. I am very unfamiliar with BPF so I
> > > > > > have no idea what is going wrong here. Is this a known issue?
> > > > > >
> > > > >
> > > > > I'll skip the reproduction games this time and will just request the
> > > > > vmlinux image. Please upload somewhere so that we can look at DWARF
> > > > > and see what's going on. Thanks.
> > > > >
> > > >
> > > > Sure thing, let me know if this works. I uploaded in two places to make
> > > > it easier to grab:
> > > >
> > > > zstd compressed:
> > > > https://github.com/nathanchance/bug-files/blob/3b2873751e29311e084ae2c71604a1963f5e1a48/btf-aarch64/vmlinux.zst
> > > >
> > >
> > > Thanks. I clearly see at least one instance of seemingly well-formed
> > > vfs_truncate DWARF declaration. Also there is a proper ELF symbol for
> > > it. Which means it should have been generated in BTF, but it doesn't
> > > appear to be, so it does seem like a pahole bug. I (or someone else
> > > before me) will continue tomorrow.
> > >
> > > $ llvm-dwarfdump vmlinux
> > > ...
> > >
> > > 0x00052e6f:   DW_TAG_subprogram
> > >                 DW_AT_name      ("vfs_truncate")
> > >                 DW_AT_decl_file
> > > ("/home/nathan/cbl/src/linux/include/linux/fs.h")
> > >                 DW_AT_decl_line (2520)
> > >                 DW_AT_prototyped        (true)
> > >                 DW_AT_type      (0x000452cb "long int")
> > >                 DW_AT_declaration       (true)
> > >                 DW_AT_external  (true)
> > >
> > > 0x00052e7b:     DW_TAG_formal_parameter
> > >                   DW_AT_type    (0x00045fc6 "const path*")
> > >
> > > 0x00052e80:     DW_TAG_formal_parameter
> > >                   DW_AT_type    (0x00045213 "long long int")
> > >
> > > ...
> > >
> >
> > ... and here's the *only* other one (not marked as declaration, but I
> > thought we already handle that, Jiri?):
> >
> > 0x01d0da35:   DW_TAG_subprogram
> >                 DW_AT_low_pc    (0xffff80001031f430)
> >                 DW_AT_high_pc   (0xffff80001031f598)
> >                 DW_AT_frame_base        (DW_OP_reg29)
> >                 DW_AT_GNU_all_call_sites        (true)
> >                 DW_AT_name      ("vfs_truncate")
> >                 DW_AT_decl_file ("/home/nathan/cbl/src/linux/fs/open.c")
> >                 DW_AT_decl_line (69)
> >                 DW_AT_prototyped        (true)
> >                 DW_AT_type      (0x01cfdfe4 "long int")
> >                 DW_AT_external  (true)
> >
> 
> Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> vfs_truncate's address is not recorded as ftrace-attachable, and thus
> pahole ignores it. I don't know why this happens and it's quite
> strange, given vfs_truncate is just a normal global function.
> 
> I'd like to understand this issue before we try to fix it, but there
> is at least one improvement we can make: pahole should check ftrace
> addresses only for static functions, not the global ones (global ones
> should be always attachable, unless they are special, e.g., notrace
> and stuff). We can easily check that by looking at the corresponding
> symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> for that particular kernel. For that we'll need Nathan's cooperation,
> unless someone else can build an arm64 kernel with the same problem
> and check.

Sure, just let me know what I need to do and I can do it!

Cheers,
Nathan

> >
> > > $ llvm-readelf -s vmlinux | rg vfs_truncate
> > >  15013: ffff800011c22418     4 OBJECT  LOCAL  DEFAULT    24
> > > __BTF_ID__func__vfs_truncate__609
> > >  22531: ffff80001189fe0d     0 NOTYPE  LOCAL  DEFAULT    17
> > > __kstrtab_vfs_truncate
> > >  22532: ffff8000118a985b     0 NOTYPE  LOCAL  DEFAULT    17
> > > __kstrtabns_vfs_truncate
> > >  22534: ffff800011873b7c     0 NOTYPE  LOCAL  DEFAULT     8
> > > __ksymtab_vfs_truncate
> > > 176099: ffff80001031f430   360 FUNC    GLOBAL DEFAULT     2 vfs_truncate
> > >
> > > $ bpftool btf dump file vmlinux | rg vfs_truncate
> > > <nothing>
> > >
> > > > uncompressed:
> > > > https://1drv.ms/u/s!AsQNYeB-IEbqjQiUOspbEdXx49o7?e=ipA9Hv
> > > >
> > > > Cheers,
> > > > Nathan
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAEf4Bzax90hn_5axpnCpW%2BE6gVc1mtUgCXWqmxV0tJ4Ud7bsaA%40mail.gmail.com.
