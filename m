Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746353676B4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbhDVBRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 21:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234970AbhDVBRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 21:17:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864E5613AB;
        Thu, 22 Apr 2021 01:17:09 +0000 (UTC)
Date:   Wed, 21 Apr 2021 21:17:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210421211706.3589473e@oasis.local.home>
In-Reply-To: <YICbK5JLqRXnjgEW@krava>
References: <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
        <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
        <20210416124834.05862233@gandalf.local.home>
        <YH7OXrjBIqvEZbsc@krava>
        <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
        <YH8GxNi5VuYjwNmK@krava>
        <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
        <YIArVa6IE37vsazU@krava>
        <20210421100541.3ea5c3bf@gandalf.local.home>
        <YICbK5JLqRXnjgEW@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 23:37:47 +0200
Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > One thing that ftrace gives you is a way to have each function call its own
> > trampoline, then depending on what is attached, each one can have multiple
> > implementations.  
> 
> but that would cut off other tracers for the function, right?

No, actually just the opposite. It can be updated by what is attached
to it to provide the best trampoline for the use case.

If all the callbacks are attached to a single function with a limited
set of required args, it could jump to a trampoline that only saves the
required args.

If any of the callbacks are attached to multiple functions, and needs
all the args, then it can jump to a trampoline to save all of them.

This is similar to how it works now. One is for a trampoline that only
cares about saving the arguments, another is for a trampoline that
wants to save *all* the regs. And if there's a callback that wants
both, it will use the trampoline that can handle all the callbacks to
that function.

> 
> AFAICT it's used only when there's single ftrace_ops registered
> for the probe and if there are more ftrace_ops, ops->trampoline
> is replaced by the generic one and ftrace will call ops->func
> instead, right?

Somewhat, but let me explain it in more detail.

There's currently two variables that determine what trampoline to call.

Variable 1: number of callbacks attached. It cares about 0, 1, more than one.

Variable 2: Does any callback require a full set of regs?

Variable 1 determines if the trampoline that is called will call a loop
function, that will loop through all the attached callbacks.

Variable 2 determines if it should save all the regs or not.

If all the callbacks attached to a function do not require saving all
the regs, then it will only save the regs that are required for calling
functions (which is all the arguments but not all the regs). Then it
calls the loop function with a limited number of regs saved.

If one of the functions attached requires all the regs, then it will
save all the regs, and pass that to the loop function that calls the
callbacks. All the callbacks will get the full set of regs, even though
only one might care about them. But the work was already done, and the
regs is just a pointer passed to the callbacks.


> 
> if we would not care about sharing function by multiple tracers,
> we could make special 'exclusive' trampoline that would require
> that no other tracer is (or will be) registered for the function
> while the tracer is registered

We don't want to restrict other traces. But you can switch trampolines,
without disruption. We do that now.

If a single callback that doesn't care about all regs is attached to a
function, then a custom trampoline is created, and when the function is
called, it calls that trampoline, which saves the required regs, and
then does a direct call to the callback.

If we add another callback to that same function, and that callback
also doesn't care for all regs, then we switch to a new trampoline that
instead of calling the original callback directly, it calls the loop
function, that iterates over all the functions. The first callback sees
no difference. We just switch the function "fentry" to point to the new
trampoline.

Then if we add a callback to that same function, but this callback
wants all the regs, then we switch to a new trampoline that will save
all the regs and call the loop function. The first two callbacks notice
no change.

And this can be backed out as well when callbacks are removed from a
function. All this accounting is taken care of by
__ftrace_hash_rec_update() in kernel/trace/ftrace. And yes, it takes a
bit of care to get this right.

The point is, you can modify the trampolines dynamically individually
per function depending on the callback requirements that are attached
to it.

The state of each function is determined by the dyn_ftrace structure
flags field. (see include/linux/ftrace.h)

The 23 least significant bits of flags is a counter. 2^23 is much more
than needed, because there should never be that many callbacks attached
to a single function. Variable 1 above is determined by the count. 0,
1 , more than one.

And you'll see the flags for: REGS / REGS_EN, TRAMP / TRAMP_EN and even
DIRECT / DIRECT_EN, for whether or not the function wants regs, if the
function calls a trampoline directly or uses the loop, and if it has a
direct caller or not, respectively.

The "_EN" part of those flags show the state that the actual function
is in. The __ftrace_hash_rec_update() will look at the ftrace_ops that
is being registered or unregistered, and will update each of the functions
it traces dyn_ftrace non "_EN" flags. Then the code that actually does
the modifications will look at each record (that represent all
traceable functions), and if the non "_EN" flag does not match the
"_EN" part it knows to update that function appropriately, and then it
updates the "_EN" flag.


> 
> then we could run BPF trampolines directly without 'direct' API
> and use ftrace for mass attach
> 
> that is if we don't care about other tracers for the function,
> which I guess was concern when the 'direct' API was introduced

I still very much care about other traces for the function. Remember,
kprobes and perf uses this too, and kprobes was the one that requires
all regs being saved.

-- Steve

