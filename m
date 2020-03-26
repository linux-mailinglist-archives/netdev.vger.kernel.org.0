Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F409F193778
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgCZFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgCZFN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 01:13:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 376C22070A;
        Thu, 26 Mar 2020 05:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585199605;
        bh=zF+GhN0JedFJh21aHnCOMjRwKvcEl5EiWjUBOM95tCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pXzzMPf8i5aLRhR7V5cRIx8fOp2dVSZoZB6t+vgEjrzCG5p50dHZDYdITA9gByDoR
         DEahSo/YBRUvl0qlPiI06jGkTwrr6NPXU6M+3L/9SZlp09vggW9XUzRH+Ll4HPjQoi
         naZQlFExNqOWeQdg1jYr3JxzrLLM+lJM9Wkl86kU=
Date:   Wed, 25 Mar 2020 22:13:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
        <87369wrcyv.fsf@toke.dk>
        <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 17:16:13 -0700 Andrii Nakryiko wrote:
> > >> Well, I wasn't talking about any of those subsystems, I was talking
> > >> about networking :)  
> > >
> > > So it's not "BPF subsystem's relation to the rest of the kernel" from
> > > your previous email, it's now only "talking about networking"? Since
> > > when the rest of the kernel is networking?  
> >
> > Not really, I would likely argue the same for any other subsystem, I  
> 
> And you would like lose that argument :) You already agreed that for
> tracing this is not the case. BPF is not attached by writing text into
> ftrace's debugfs entries. Same for cgroups, we don't
> create/update/write special files in cgroupfs, we have an explicit
> attachment API in BPF.
> 
> BTW, kprobes started out with the same model as XDP has right now. You
> had to do a bunch of magic writes into various debugfs files to attach
> BPF program. If user-space application crashed, kprobe stayed
> attached. This was horrible and led to many problems in real world
> production uses. So a completely different interface was created,
> allowing to do it through perf_event_open() and created anonymous
> inode for BPF program attachment. That allowed crashing program to
> auto-detach kprobe and not harm production use case.
> 
> Now we are coming after cgroup BPF programs, which have similar issues
> and similar pains in production. cgroup BPF progs actually have extra
> problems: programs can user-space applications can accidentally
> replace a critical cgroup program and ruin the day for many folks that
> have to deal with production breakage after that. Which is why I'm
> implementing bpf_link with all its properties: to solve real pain and
> real problem.
>
> Now for XDP. It has same flawed model. And even if it seems to you
> that it's not a big issue, and even if Jakub thinks we are trying to
> solve non-existing problem, it is a real problem and a real concern
> from people that have to support XDP in production with many

More than happy to talk to those folks, and see the tickets.

Toke has actual user space code which needs his extension, and for
which "ownership" makes no difference as it would just be passed with
whoever touched the program last.

> well-meaning developers developing BPF applications independently.

There is one single program which can be attached to the XDP hook, 
the "everybody attaches their program model" does not apply.

TW agent should just listen on netlink notifications to see if someone
replaced its program. cgroups have multi-attachment and no notifications
(although not sure anyone was explicitly asking for links there,
either).

In production a no-op XDP program is likely to be attached from the
moment machine boots, to avoid traffic interruption and the risk of
something going wrong with the driver when switching between skb to 
xdp datapath. And then the program is only replaced, not detached.

Not to mention the fact that networking applications generally don't
want to remove their policy from the kernel when they crash :/

> Now, those were fundamental things, but I'd like to touch on a "nice
> things we get with that". Having a proper kernel object representing
> single instance of attached BPF program to some other kernel object
> allows to build an uniform and consistent API around bpf_link with
> same semantics. We can do LINK_UPDATE and allow to atomically replace
> BPF program inside the established bpf_link. It's applicable to all
> types of BPF program attachment and can be done in a way that ensures
> no BPF program invocation is skipped while BPF programs are swapped
> (because at the lowest level it boils down to an atomic pointer swap).
> Of course not all bpf_links might have this support initially, but
> we'll establish a lot of common infrastructure which will make it
> simpler, faster and more reliable to add this functionality.

XDP replace is already atomic, no packet will be passed without either
old or new program executed on it.

> And to wrap up. I agree, consistent API is not a goal in itself, as
> Jakub mentioned. But it is a worthy goal nevertheless, especially if
> it doesn't cost anything extra. It makes kernel developers lives

Not sure how having two interfaces instead of one makes kernel
developer's life easier.
