Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EED314809
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBIFX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhBIFXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 00:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F294864EB1;
        Tue,  9 Feb 2021 05:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612848193;
        bh=cIa4yuE4wgHoWKKtola0MO/gqRhj6bS1TQtpj76aK+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u5V645Vj5Aqw4dAPQZAJLzpFwFTgDcQyDNUftu10FbFLbiurnOBaToQLtz1zwmIDZ
         fnUSUAj+nfDV6Ns9eZiyCyHYOPAcV7wfbQc3lV2hX876bPET7voROaMhChlo75DjGv
         gS3IqKaUNB5mxUNcXv5EfrB4VlE/4Rqj1Qcd/L26gY53e62SgTHy2aa8hgP1Iz1VNn
         HB9s7nGKS8eOaoBe3qKH8D3ktnbV7/CCY1yUSTFEpzgt3qKg79ys1JWP5ZCqcVrhqu
         bZk0ZQvyV1wUfOdgTlmF0vOk/Q7x1e9CXD1HVB+Q+7oSQ/SU4Pvx4TAjGsbP9msrnq
         Gk50UemfBJrXQ==
Date:   Mon, 8 Feb 2021 22:23:11 -0700
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
Message-ID: <20210209052311.GA125918@ubuntu-m3-large-x86>
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
 <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:45:43PM -0800, Andrii Nakryiko wrote:
> On Mon, Feb 8, 2021 at 7:44 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Hi all,
> >
> > Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
> > https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ
> >
> > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> >                       LLVM=1 O=build/aarch64 defconfig
> >
> > $ scripts/config \
> >     --file build/aarch64/.config \
> >     -e BPF_SYSCALL \
> >     -e DEBUG_INFO_BTF \
> >     -e FTRACE \
> >     -e FUNCTION_TRACER
> >
> > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> >                       LLVM=1 O=build/aarch64 olddefconfig all
> > ...
> > FAILED unresolved symbol vfs_truncate
> > ...
> >
> > My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
> > although that seems obvious given that is what introduced
> > BTF_ID(func, vfs_truncate).
> >
> > I am using the latest pahole v1.20 and LLVM is at
> > https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
> > although I can reproduce back to LLVM 10.0.1, which is the earliest
> > version that the kernel supports. I am very unfamiliar with BPF so I
> > have no idea what is going wrong here. Is this a known issue?
> >
> 
> I'll skip the reproduction games this time and will just request the
> vmlinux image. Please upload somewhere so that we can look at DWARF
> and see what's going on. Thanks.
> 

Sure thing, let me know if this works. I uploaded in two places to make
it easier to grab:

zstd compressed:
https://github.com/nathanchance/bug-files/blob/3b2873751e29311e084ae2c71604a1963f5e1a48/btf-aarch64/vmlinux.zst

uncompressed:
https://1drv.ms/u/s!AsQNYeB-IEbqjQiUOspbEdXx49o7?e=ipA9Hv

Cheers,
Nathan
