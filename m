Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806D9362373
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245644AbhDPPDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245542AbhDPPDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 11:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5558C6115B;
        Fri, 16 Apr 2021 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618585391;
        bh=86L27VqL5JYvSkRC73dm4+m1ITEjr+NCf8nSCM+wR1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T7HrHOHZ3WrC44vwjDsKTnm3363YJYqZO/682HTI+yJqDRxvI0tcd6XsBl1SjgMKA
         Kk6SaUrq4KBnDxiSKNJ0uDxYHk7MVNMyNR/xn1liG+k1mlTyR6DqSXbuU4yQDXpWja
         3bJ7y30RAFkcIM50SY10qEea70ARrqRZhQ23xhL9ig9695/IeqzwAMIAfdMIdQJyiH
         8Jquhro1Yd4aRBdZ+kiGcKSfJh4uRQuNm0+cfo9Hp6q+fMFjqdO2HYJppargqNG0dQ
         u1sI4DMFK/JGoNFwP95ocvwNqhZloSGrVCRP82mNzWi3QBYVxzUvi2acgNPxuQ3ttl
         894JhNVXaWJ4Q==
Date:   Sat, 17 Apr 2021 00:03:04 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Viktor Malik <vmalik@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-Id: <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
In-Reply-To: <20210415170007.31420132@gandalf.local.home>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 15 Apr 2021 17:00:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [
>   Added Masami, as I didn't realize he wasn't on Cc. He's the maintainer of
>   kretprobes.
> 
>   Masami, you may want to use lore.kernel.org to read the history of this
>   thread.
> ]
> 
> On Thu, 15 Apr 2021 13:45:06 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> > > I don't know how the BPF code does it, but if you are tracing the exit
> > > of a function, I'm assuming that you hijack the return pointer and replace
> > > it with a call to a trampoline that has access to the arguments. To do  
> > 
> > As Jiri replied, BPF trampoline doesn't do it the same way as
> > kretprobe does it. Which gives the fexit BPF program another critical
> > advantage over kretprobe -- we know traced function's entry IP in both
> > entry and exit cases, which allows us to generically correlate them.
> > 
> > I've tried to figure out how to get that entry IP from kretprobe and
> > couldn't find any way. Do you know if it's possible at all or it's a
> > fundamental limitation of the way kretprobe is implemented (through
> > hijacking return address)?

Inside the kretprobe handler, you can get the entry IP from kretprobe as below;

static int my_kretprobe_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
	struct kretprobe *rp = get_kretprobe(ri);
	unsigned long entry = (unsigned long)rp->kp.addr;
	unsigned long retaddr = (unsigned long)ri->ret_addr;
	...
}

It is ensured that rp != NULL in the handler.

> 
> The function graph tracer has the entry IP on exit, today. That's how we
> can trace and show this:
> 
>  # cd /sys/kernel/tracing
>  # echo 1 > echo 1 > options/funcgraph-tail
>  # echo function_graph > current_tracer
>  # cat trace
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  7)   1.358 us    |  rcu_idle_exit();
>  7)   0.169 us    |  sched_idle_set_state();
>  7)               |  cpuidle_reflect() {
>  7)               |    menu_reflect() {
>  7)   0.170 us    |      tick_nohz_idle_got_tick();
>  7)   0.585 us    |    } /* menu_reflect */
>  7)   1.115 us    |  } /* cpuidle_reflect */
> 
> That's how we can show the tail function that's called. I'm sure kreprobes
> could do the same thing.

Yes, I have to update the document how to do that (and maybe introduce 2 functions
to wrap the entry/retaddr code)

> 
> The patch series I shared with Jiri, was work to allow kretprobes to be
> built on top of the function graph tracer.
> 
> https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> 
> The feature missing from that series, and why I didn't push it (as I had
> ran out of time to work on it), was that kreprobes wants the full regs
> stack as well. And since kretprobes was the main client of this work, that
> I decided to work on this at another time. But like everything else, I got
> distracted by other work, and didn't realize it has been almost 2 years
> since looking at it :-p
> 
> Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> return (who cares about the registers on return, except for the return
> value?)

I think kretprobe and ftrace are for a bit different usage. kretprobe can be
used for something like debugger. In that case, accessing full regs stack
will be more preferrable. (BTW, what the not "full regs" means? Does that
save partial registers?)


Thank you,

> But this code could easily save the parameters as well.
> 
> > 
> > > this you need a shadow stack to save the real return as well as the
> > > parameters of the function. This is something that I have patches that do
> > > similar things with function graph.
> > >
> > > If you want this feature, lets work together and make this work for both
> > > BPF and ftrace.  
> > 
> > Absolutely, ultimately for users it doesn't matter what specific
> > mechanism is used under the cover. It just seemed like BPF trampoline
> > has all the useful tracing features (entry IP and input arguments in
> > fexit) already and is just mostly missing a quick batch attach API. If
> > we can get the same from ftrace, all the better.
> 
> Let me pull these patches out again, and see what we can do. Since then,
> I've added the code that lets function tracer save parameters and the
> stack, and function graph can use that as well.
> 
> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
