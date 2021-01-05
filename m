Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0060F2EAC86
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbhAEN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:58:52 -0500
Received: from gofer.mess.org ([88.97.38.141]:45217 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbhAEN6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 08:58:51 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id F2539C637E; Tue,  5 Jan 2021 13:58:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1609855089; bh=gH+Lz6nVQLvOPcvGmGMj2CJj4YjwnBzm+oF+wUpTKBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gv6wjYb3gwZkeT1yOF/i+WCz0iHlLUILW8Lj+yeF6Pk7W3PCwposSzOrlgyfnt4CG
         E6i7P7zI+sYpI6D8z1mvlxt04wejgD+qSO6ypv5yY83LUZyNyOJAL9ubzjjpCmjiUb
         +UXOfU64U4P1e1bAw1/IA+BkBtKHYbjq0av9vodOXCc4QT1OGiu4nDsLGDlQ4jiSK3
         FQPbpE9SaHQe5NuL+/WFUTGfsyxgj+1sSj9YM7a1RYmoChlTITvkmnfdDoB6QV3PoO
         LVttg9P6ny4co6Peh016HnKUhyZnKDeHqfq+xnVxpyDMF79UOfsSvp1YsjBQxzpSYZ
         /7ut9Xx1dJQKg==
Date:   Tue, 5 Jan 2021 13:58:08 +0000
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] btf: support ints larger than 128 bits
Message-ID: <20210105135808.GA13438@gofer.mess.org>
References: <20201219163652.GA22049@gofer.mess.org>
 <bf26fcc9-a2b5-9d6f-a2ac-e39a0b14d838@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf26fcc9-a2b5-9d6f-a2ac-e39a0b14d838@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 10:21:09AM -0800, Yonghong Song wrote:
> On 12/19/20 8:36 AM, Sean Young wrote:
> > clang supports arbitrary length ints using the _ExtInt extension. This
> > can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> > 
> > Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> > case for these.
> > 
> > This requires the _ExtInt extension enabled in clang, which is under
> > review.
> > 
> > Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> > Link: https://reviews.llvm.org/D93103
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> > changes since v2:
> >   - added tests as suggested by Yonghong Song
> >   - added kernel pretty-printer
> > 
> >   Documentation/bpf/btf.rst                     |   4 +-
> >   include/uapi/linux/btf.h                      |   2 +-
> >   kernel/bpf/btf.c                              |  54 +-
> >   tools/bpf/bpftool/btf_dumper.c                |  40 ++
> >   tools/include/uapi/linux/btf.h                |   2 +-
> >   tools/lib/bpf/btf.c                           |   2 +-
> >   tools/testing/selftests/bpf/Makefile          |   3 +-
> >   tools/testing/selftests/bpf/prog_tests/btf.c  |   3 +-
> >   .../selftests/bpf/progs/test_btf_extint.c     |  50 ++
> >   tools/testing/selftests/bpf/test_extint.py    | 535 ++++++++++++++++++
> 
> For easier review, maybe you can break this patch into a patch series like
> below?
>   patch 1 (kernel related changes and doc)
>       kernel/bpf/btf.c, include/uapi/linux/btf.h,
>       tools/include/uapi/linux/btf.h
>       Documentation/bpf/btf.rst
>   patch 2 (libbpf support)
>       tools/lib/bpf/btf.c
>   patch 3 (bpftool support)
>       tools/bpf/bpftool/btf_dumper.c
>   patch 4 (testing)
>       rest files

That makes sense, I'll send out v3 shortly.

Thanks,

Sean
