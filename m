Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9B298366
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418595AbgJYTlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1418590AbgJYTlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603654896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j9Dfcijr9zWaJQGCdM62UJQj29w0VqaAFbm9IQLiRk0=;
        b=PW8A83Wprn3S0he6fzni4X0apz0KEGUhWLTNVKLbM+WX96ApV+UrDa/8F90hmAasBqIz7H
        Cc806blr6Vn799IqS0XCUJsz19ttGqBEovNUTzPJNssbk229QiM3auD0gYYnFa8LVciSkf
        sni+8EG6KxppsnKuj9AS0ETxDWw/Sg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-D9omz1PZMxSvfj8Pq9Zd3Q-1; Sun, 25 Oct 2020 15:41:32 -0400
X-MC-Unique: D9omz1PZMxSvfj8Pq9Zd3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CFD4804B74;
        Sun, 25 Oct 2020 19:41:30 +0000 (UTC)
Received: from krava (unknown [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4E6126EF44;
        Sun, 25 Oct 2020 19:41:24 +0000 (UTC)
Date:   Sun, 25 Oct 2020 20:41:23 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
Message-ID: <20201025194123.GD2681365@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-10-jolsa@kernel.org>
 <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com>
 <20201023163110.54e4a202@gandalf.local.home>
 <CAEf4Bza4=KKZS_OGnaLvFELE8W+Nm4sah2--CYP6wopQecxg5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza4=KKZS_OGnaLvFELE8W+Nm4sah2--CYP6wopQecxg5g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 03:23:10PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 23, 2020 at 1:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 23 Oct 2020 13:03:22 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > Basically, maybe ftrace subsystem could provide a set of APIs to
> > > prepare a set of functions to attach to. Then BPF subsystem would just
> > > do what it does today, except instead of attaching to a specific
> > > kernel function, it would attach to ftrace's placeholder. I don't know
> > > anything about ftrace implementation, so this might be far off. But I
> > > thought that looking at this problem from a bit of a different angle
> > > would benefit the discussion. Thoughts?
> >
> > I probably understand bpf internals as much as you understand ftrace
> > internals ;-)
> >
> 
> Heh :) But while we are here, what do you think about this idea of
> preparing a no-op trampoline, that a bunch (thousands, potentially) of
> function entries will jump to. And once all that is ready and patched
> through kernel functions entry points, then allow to attach BPF
> program or ftrace callback (if I get the terminology right) in a one
> fast and simple operation? For users that would mean that they will
> either get calls for all or none of attached kfuncs, with a simple and
> reliable semantics.

so the main pain point the batch interface is addressing, is that
every attach (BPF_RAW_TRACEPOINT_OPEN command) calls register_ftrace_direct,
and you'll need to do the same for nop trampoline, no?

I wonder if we could create some 'transaction object' represented
by fd and add it to bpf_attr::raw_tracepoint

then attach (BPF_RAW_TRACEPOINT_OPEN command) would add program to this
new 'transaction object' instead of updating ftrace directly

and when the collection is done (all BPF_RAW_TRACEPOINT_OPEN command
are executed), we'd call new bpf syscall command on that transaction
and it would call ftrace interface

something like:

  bpf(TRANSACTION_NEW) = fd
  bpf(BPF_RAW_TRACEPOINT_OPEN) for prog_fd_1, fd
  bpf(BPF_RAW_TRACEPOINT_OPEN) for prog_fd_2, fd
  ...
  bpf(TRANSACTION_DONE) for fd

jirka

> 
> Something like this, where bpf_prog attachment (which replaces nop)
> happens as step 2:
> 
> +------------+  +----------+  +----------+
> |  kfunc1    |  |  kfunc2  |  |  kfunc3  |
> +------+-----+  +----+-----+  +----+-----+
>        |             |             |
>        |             |             |
>        +---------------------------+
>                      |
>                      v
>                  +---+---+           +-----------+
>                  |  nop  +----------->  bpf_prog |
>                  +-------+           +-----------+
> 
> 
> > Anyway, what I'm currently working on, is a fast way to get to the
> > arguments of a function. For now, I'm just focused on x86_64, and only add
> > 6 argments.
> >
> > The main issue that Alexei had with using the ftrace trampoline, was that
> > the only way to get to the arguments was to set the "REGS" flag, which
> > would give a regs parameter that contained a full pt_regs. The problem with
> > this approach is that it required saving *all* regs for every function
> > traced. Alexei felt that this was too much overehead.
> >
> > Looking at Jiri's patch, I took a look at the creation of the bpf
> > trampoline, and noticed that it's copying the regs on a stack (at least
> > what is used, which I think could be an issue).
> 
> Right. And BPF doesn't get access to the entire pt_regs struct, so it
> doesn't have to pay the prices of saving it.
> 
> But just FYI. Alexei is out till next week, so don't expect him to
> reply in the next few days. But he's probably best to discuss these
> nitty-gritty details with :)
> 
> >
> > For tracing a function, one must store all argument registers used, and
> > restore them, as that's how they are passed from caller to callee. And
> > since they are stored anyway, I figure, that should also be sent to the
> > function callbacks, so that they have access to them too.
> >
> > I'm working on a set of patches to make this a reality.
> >
> > -- Steve
> 

