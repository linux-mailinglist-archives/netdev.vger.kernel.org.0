Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C966C2D2396
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgLHG1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLHG1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:27:32 -0500
Message-ID: <76aa0d16e3d03cf12496184c848f60069bf71872.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607408812;
        bh=3cqG6VivsWrSlLedrd3FqDI2vK8xiJwq1cHOubcBqNE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KDxdDO4MN6oh6589QpAaSwgvkdQqaXFO7K4xxGYVFv8sMZM3Lj4ipD66vLMlVMwzB
         UQE7a4iS1/Knt+WGujNd8EhSM35n4Nn/dh8L6FCq7LGZmRkIJl5J8TL2Jubbipg6XP
         22AQN+D9YkuaHD/o51zssQ9Ng77I7q7m7RGkkALTliRs91+VxkCwKuXs3cmMbJVAay
         8wjAU9/3HVIhEMTSzpx/P0UwUm3Fo2XKb15bL2Jq5cFefhfAQQnLxWO/wosaFxgoiS
         iA16HpZiY+sBYWmSfnljRzY0vvp1jqX1Mpss+bsBSw5ajkx96xbZ3Icurz8NinQ6Fl
         6qDGtjGPzFr4g==
Subject: Re: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Date:   Mon, 07 Dec 2020 22:26:50 -0800
In-Reply-To: <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
References: <20201207052057.397223-1-saeed@kernel.org>
         <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 19:14 -0800, Andrii Nakryiko wrote:
> On Sun, Dec 6, 2020 at 9:21 PM <saeed@kernel.org> wrote:
> > From: Saeed Mahameed <saeedm@nvidia.com>
> > 
> > While playing with BTF for modules, i noticed that executing the
> > command:
> > $ bpftool btf dump id <module's btf id>
> > 
> > Fails due to lack of information in the BTF data.
> > 
> > Maybe I am missing a step but actually adding the support for this
> > is
> > very simple.
> 
> yes, bpftool takes -B <path> argument for specifying base BTF. So if
> you added -B /sys/kernel/btf/vmlinux, it should have worked. I've
> added auto-detection logic for the case of `btf dump file
> /sys/kernel/btf/<module>` (see [0]), and we can also add it for when
> ID corresponds to a module BTF. But I think it's simplest to re-use
> the logic and just open /sys/kernel/btf/vmlinux, instead of adding
> narrowly-focused libbpf API for that.
> 

When dumping with a file it works even without the -B since you lookup
the vmlinux file, but the issue is not dumping from a file source, we
need it by id..

> > To completely parse modules BTF data, we need the vmlinux BTF as
> > their
> > "base btf", which can be easily found by iterating through the btf
> > ids and
> > looking for btf.name == "vmlinux".
> > 
> > I am not sure why this hasn't been added by the original patchset
> 
> because I never though of dumping module BTF by id, given there is
> nicely named /sys/kernel/btf/<module> :)
> 

What if i didn't compile my kernel with SYSFS ? a user experience is a
user experience, there is no reason to not support dump a module btf by
id or to have different behavior for different BTF sources.

I can revise this patch to support -B option and lookup vmlinux file if
not provided for module btf dump by ids.

but we  still need to pass base_btf to btf__get_from_id() in order to
support that, as was done for btf__parse_split() ... :/

Are you sure you don't like the current patch/libbpf API ? it is pretty
straight forward and correct.

> > "Integrate kernel module BTF support", as adding the support for
> > this is very trivial. Unless i am missing something, CCing Andrii..
> > 
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > CC: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c      | 57
> > ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/btf.h      |  2 ++
> >  tools/lib/bpf/libbpf.map |  1 +
> >  3 files changed, 60 insertions(+)
> > 
> 
> [...]

