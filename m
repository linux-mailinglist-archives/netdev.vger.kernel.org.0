Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A183613D0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbhDOVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235539AbhDOVAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 17:00:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C635460FDC;
        Thu, 15 Apr 2021 21:00:09 +0000 (UTC)
Date:   Thu, 15 Apr 2021 17:00:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
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
Message-ID: <20210415170007.31420132@gandalf.local.home>
In-Reply-To: <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[
  Added Masami, as I didn't realize he wasn't on Cc. He's the maintainer of
  kretprobes.

  Masami, you may want to use lore.kernel.org to read the history of this
  thread.
]

On Thu, 15 Apr 2021 13:45:06 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> > I don't know how the BPF code does it, but if you are tracing the exit
> > of a function, I'm assuming that you hijack the return pointer and replace
> > it with a call to a trampoline that has access to the arguments. To do  
> 
> As Jiri replied, BPF trampoline doesn't do it the same way as
> kretprobe does it. Which gives the fexit BPF program another critical
> advantage over kretprobe -- we know traced function's entry IP in both
> entry and exit cases, which allows us to generically correlate them.
> 
> I've tried to figure out how to get that entry IP from kretprobe and
> couldn't find any way. Do you know if it's possible at all or it's a
> fundamental limitation of the way kretprobe is implemented (through
> hijacking return address)?

The function graph tracer has the entry IP on exit, today. That's how we
can trace and show this:

 # cd /sys/kernel/tracing
 # echo 1 > echo 1 > options/funcgraph-tail
 # echo function_graph > current_tracer
 # cat trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 7)   1.358 us    |  rcu_idle_exit();
 7)   0.169 us    |  sched_idle_set_state();
 7)               |  cpuidle_reflect() {
 7)               |    menu_reflect() {
 7)   0.170 us    |      tick_nohz_idle_got_tick();
 7)   0.585 us    |    } /* menu_reflect */
 7)   1.115 us    |  } /* cpuidle_reflect */

That's how we can show the tail function that's called. I'm sure kreprobes
could do the same thing.

The patch series I shared with Jiri, was work to allow kretprobes to be
built on top of the function graph tracer.

https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/

The feature missing from that series, and why I didn't push it (as I had
ran out of time to work on it), was that kreprobes wants the full regs
stack as well. And since kretprobes was the main client of this work, that
I decided to work on this at another time. But like everything else, I got
distracted by other work, and didn't realize it has been almost 2 years
since looking at it :-p

Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
return (who cares about the registers on return, except for the return
value?)

But this code could easily save the parameters as well.

> 
> > this you need a shadow stack to save the real return as well as the
> > parameters of the function. This is something that I have patches that do
> > similar things with function graph.
> >
> > If you want this feature, lets work together and make this work for both
> > BPF and ftrace.  
> 
> Absolutely, ultimately for users it doesn't matter what specific
> mechanism is used under the cover. It just seemed like BPF trampoline
> has all the useful tracing features (entry IP and input arguments in
> fexit) already and is just mostly missing a quick batch attach API. If
> we can get the same from ftrace, all the better.

Let me pull these patches out again, and see what we can do. Since then,
I've added the code that lets function tracer save parameters and the
stack, and function graph can use that as well.


-- Steve
