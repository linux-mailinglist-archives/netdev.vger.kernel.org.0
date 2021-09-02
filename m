Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4CD3FE834
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhIBD5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhIBD53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 23:57:29 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FB0C061575;
        Wed,  1 Sep 2021 20:56:31 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k65so1128521yba.13;
        Wed, 01 Sep 2021 20:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKgRgusoL+QYowmKHfDwYp0vEIBLL/6souhgFEag4SE=;
        b=FxJYKhf1bvXKfH/ZEmw/w9tAaMZIpGwPKuSw4ln5PruEvP4ezAkXIYmRf0RmyT/1LJ
         2DAbLCU8T3lYofucx/fN1XWMV1OpHG2bhkjqIFUUxXtnSx6LeWghQKHRwMOQAFhYcrK9
         m3k6eQ6NXStxmzoB03T81sn9dqf0QhbJzH4dC93Bp54gL/qsSN7GHwSvb+l6Uh3+lwP0
         JgEqb9Y/6GnjkeRV1A6SoKDcqDZAv8fJuuKm65VRFftTnr5PquBik3cYp9F+lrrteclD
         208L+j7b/iYK26sj042ItkJOyzvS+DwvK0SzzJ56ac4YTII5zLRvCfT9fwl8ji6HbCXX
         v/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKgRgusoL+QYowmKHfDwYp0vEIBLL/6souhgFEag4SE=;
        b=Se+zpiTi+/Yyn4Q5qdupVDKmh1qlbBz+Z2xywsTJNgo2riJ3uKI40x7QWV6VQQqNQH
         hlMihg1wAJixwCicbHsduZK0l8YY269DuiIJi8tzxdB0Sep8L6pQ4pBYYJUziWKwILC6
         AXaeSgU5UoLwSR7RlDMRBIMDbmAXeWtqLNGFZoKDDPkbs8NZVfp/H2LU0ZY7oh3wjSy8
         /uwdoyaXtogBpiFrW8vzVaVMsVSvzYsEv1jE4FPOjspiGsXnJ3Pi22Sp5r+DEoimPf+b
         Ck2/vTnZ94dgkUrWBaIZN6rpfJ5HHOgG0//18nszJxlSyE8uPDE5OdstpR1AzLPKZen1
         dhIA==
X-Gm-Message-State: AOAM532OmU8Km++mkiUsEWxBzHtNqul9PfEL77nDhC7EBwthgQj4Gmy8
        My68sULdJ/fGGDj9EsckwBveCkDo9b35ggxMBzk=
X-Google-Smtp-Source: ABdhPJynwLNJDO3m60AXnDKpiqMmoFVXif/MVeLunuNOPi5SEzELFps3tgIq3fyxrS4rbRBlMVPE9zTiMynyj7JFIuQ=
X-Received: by 2002:a5b:142:: with SMTP id c2mr1617807ybp.425.1630554990452;
 Wed, 01 Sep 2021 20:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-19-jolsa@kernel.org>
 <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com> <YS+ZAbb+h9uAX6EP@krava>
In-Reply-To: <YS+ZAbb+h9uAX6EP@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Sep 2021 20:56:19 -0700
Message-ID: <CAEf4BzY1XhuZ5huinfTmUZGhrT=wgACOgKbbdEPmnek=nN6YgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value
 for trampoline with multi func programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 8:15 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Aug 31, 2021 at 04:51:18PM -0700, Andrii Nakryiko wrote:
> > On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > When we have multi func program attached, the trampoline
> > > switched to the function model of the multi func program.
> > >
> > > This breaks already attached standard programs, for example
> > > when we attach following program:
> > >
> > >   SEC("fexit/bpf_fentry_test2")
> > >   int BPF_PROG(test1, int a, __u64 b, int ret)
> > >
> > > the trampoline pushes on stack args 'a' and 'b' and return
> > > value 'ret'.
> > >
> > > When following multi func program is attached to bpf_fentry_test2:
> > >
> > >   SEC("fexit.multi/bpf_fentry_test*")
> > >   int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d,
> > >                        __u64 e, __u64 f, int ret)
> > >
> > > the trampoline takes this program model and pushes all 6 args
> > > and return value on stack.
> > >
> > > But we still have the original 'test1' program attached, that
> > > expects 'ret' value where there's 'c' argument now:
> > >
> > >   test1(a, b, c)
> > >
> > > To fix that we simply overwrite 'c' argument with 'ret' value,
> > > so test1 is called as expected and test2 gets called as:
> > >
> > >   test2(a, b, ret, d, e, f, ret)
> > >
> > > which is ok, because 'c' is not defined for bpf_fentry_test2
> > > anyway.
> > >
> >
> > What if we change the order on the stack to be the return value first,
> > followed by input arguments. That would get us a bit closer to
> > unifying multi-trampoline and the normal one, right? BPF verifier
> > should be able to rewrite access to the last argument (i.e., return
> > value) for fexit programs to actually be at offset 0, and shift all
> > other arguments by 8 bytes. For fentry, if that helps to keep things
> > more aligned, we'd just skip the first 8 bytes on the stack and store
> > all the input arguments in the same offsets. So BPF verifier rewriting
> > logic stays consistent (except offset 0 will be disallowed).
>
> nice idea, with this in place we could cut that args re-arranging code
>
> >
> > Basically, I'm thinking how we can make normal and multi trampolines
> > more interoperable to remove those limitations that two
> > multi-trampolines can't be attached to the same function, which seems
> > like a pretty annoying limitation which will be easy to hit in
> > practice. Alexei previously proposed (as an optimization) to group all
> > to-be-attached functions into groups by number of arguments, so that
> > we can have up to 6 different trampolines tailored to actual functions
> > being attached. So that we don't save unnecessary extra input
> > arguments saving, which will be even more important once we allow more
> > than 6 arguments in the future.
> >
> > With such logic, we should be able to split all the functions into
> > multiple underlying trampolines, so it seems like it should be
> > possible to also allow multiple multi-fentry programs to be attached
> > to the same function by having a separate bpf_trampoline just for
> > those functions. It will be just an extension of the above "just 6
> > trampolines" strategy to "as much as we need trampolines".
>
> I'm probably missing something here.. say we have 2 functions with single
> argument:
>
>   foo1(int a)
>   foo2(int b)
>
> then having 2 programs:
>
>   A - attaching to foo1
>   B - attaching to foo2
>
> then you need to have 2 different trampolines instead of single 'generic-1-argument-trampoline'

right, you have two different BPF progs attached to two different
functions. You have to have 2 trampolines, not sure what's
confusing?..

>
> >
> > It's just a vague idea, sorry, I don't understand all the code yet.
> > But the limitation outlined in one of the previous patches seems very
> > limiting and unpleasant. I can totally see that some 24/7 running BPF
> > tracing app uses multi-fentry for tracing a small subset of kernel
> > functions non-stop, and then someone is trying to use bpftrace or
> > retsnoop to trace overlapping set of functions. And it immediately
> > fails. Very frustrating.
>
> so the current approach is to some extent driven by the direct ftrace
> batch API:
>
>   you have ftrace_ops object and set it up with functions you want
>   to change with calling:
>
>   ftrace_set_filter_ip(ops, ip1);
>   ftrace_set_filter_ip(ops, ip2);
>   ...
>
> and then register trampoline with those functions:
>
>   register_ftrace_direct_multi(ops, tramp_addr);
>
> and with this call being the expensive one (it does the actual work
> and sync waiting), my objective was to call it just once for update
>
> now with 2 intersecting multi trampolines we end up with 3 functions
> sets:
>
>   A - functions for first multi trampoline
>   B - functions for second multi trampoline
>   C - intersection of them
>
> each set needs different trampoline:
>
>   tramp A - calls program for first multi trampoline
>   tramp B - calls program for second multi trampoline
>   tramp C - calls both programs
>
> so we need to call register_ftrace_direct_multi 3 times

Yes, that's the minimal amount of trampolines you need. Calling
register_ftrace_direct_multi() three times is not that bad at all,
compared to calling it 1000s of times. If you are worried about 1 vs 3
calls, I think you are over-optimizing here. I'd rather take no
restrictions on what can be attached to what and in which sequences
but taking 3ms vs having obscure (for uninitiated users) restrictions,
but in some cases allowing attachment to happen in 1ms.

The goal with multi-attach is to make it decently fast when attaching
to a lot functions, but if attachment speed is fast enough, then such
small performance differences don't matter anymore.

>
> if we allow also standard trampolines being attached, it makes
> it even more complicated and ultimatelly gets broken to
> 1-function/1-trampoline pairs, ending up with attach speed
> that we have now
>

So let's make sure that we are on the same page. Let me write out an example.

Let's say we have 5 kernel functions: a, b, c, d, e. Say a, b, c all
have 1 input args, and d and e have 2.

Now let's say we attach just normal fentry program A to function a.
Also we attach normal fexit program E to func e.

We'll have A  attached to a with trampoline T1. We'll also have E
attached to e with trampoline T2. Right?

And now we try to attach generic fentry (fentry.multi in your
terminology) prog X to all 5 of them. If A and E weren't attached,
we'd need two generic trampolines, one for a, b, c (because 1 input
argument) and another for d,e (because 2 input arguments). But because
we already have A and B attached, we'll end up needing 4:

T1 (1 arg)  for func a calling progs A and X
T2 (2 args) for func e calling progs E and X
T3 (1 arg)  for func b and c calling X
T4 (2 args) for func d calling X

We can't have less than that and satisfy all the constraints. But 4 is
not that bad. If the example has 1000s of functions, you'd still need
between 4 and 8 trampolines (if we had 3, 4, 5, and 6 input args for
kernel functions). That's way less than 1000s of trampolines needed
today. And it's still fast enough on the attachment.

The good thing with what we discussed with making current trampoline
co-exist with generic (multi) fentry/fexit, is that we'll still have
just one trampoline, saving exactly as many input arguments as
attached function(s) have. So at least we don't have to maintain two
separate pieces of logic for that. Then the only added complexity
would be breaking up all to-be-attached kernel functions into groups,
as described in the example.

It sounds a bit more complicated in writing than it will be in
practice, probably. I think the critical part is unification of
trampoline to work with fentry/fexit and fentry.multi/fexit.multi
simultaneously, which seems like you agreed above is achievable.

> ...
>
> I have test code for ftrace direct interface that would
> allow to register/change separate function/addr pairs,
> so in one call you can change multiple ips each to
> different tramp addresss
>
> but even with that, I ended up with lot of new complexity
> on bpf side keeping track of multi trampolines intersections,
> so I thought I'd start with something limited and simpler
>
> perhaps I should move back to that approach and see how bad
> it ends ;-)
>
> or this could be next step on top of current work, that should
> get simpler with the args re-arranging you proposed
>
> jirka
>
