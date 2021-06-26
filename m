Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7F3B4F42
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFZPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 11:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhFZPpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 11:45:18 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE6C61941;
        Sat, 26 Jun 2021 15:42:55 +0000 (UTC)
Date:   Sat, 26 Jun 2021 11:41:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
Message-ID: <20210626114157.765d9371@rorschach.local.home>
In-Reply-To: <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
        <20210626101834.55b4ecf1@rorschach.local.home>
        <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Jun 2021 00:13:17 +0900
Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> On 2021/06/26 23:18, Steven Rostedt wrote:
> > On Sat, 26 Jun 2021 22:58:45 +0900
> > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> >   
> >> syzbot is hitting WARN_ON_ONCE() at tracepoint_add_func() [1], but
> >> func_add() returning -EEXIST and func_remove() returning -ENOENT are
> >> not kernel bugs that can justify crashing the system.  
> > 
> > There should be no path that registers a tracepoint twice. That's a bug
> > in the kernel. Looking at the link below, I see the backtrace:
> > 
> > Call Trace:
> >  tracepoint_probe_register_prio kernel/tracepoint.c:369 [inline]
> >  tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:389
> >  __bpf_probe_register kernel/trace/bpf_trace.c:2154 [inline]
> >  bpf_probe_register+0x15a/0x1c0 kernel/trace/bpf_trace.c:2159
> >  bpf_raw_tracepoint_open+0x34a/0x720 kernel/bpf/syscall.c:2878
> >  __do_sys_bpf+0x2586/0x4f40 kernel/bpf/syscall.c:4435
> >  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
> > 
> > So BPF is allowing the user to register the same tracepoint more than
> > once? That looks to be a bug in the BPF code where it shouldn't be
> > allowing user space to register the same tracepoint multiple times.  
> 
> I didn't catch your question.
> 
>   (1) func_add() can reject an attempt to add same tracepoint multiple times
>       by returning -EINVAL to the caller.
>   (2) But tracepoint_add_func() (the caller of func_add()) is calling WARN_ON_ONCE()
>       if func_add() returned -EINVAL.

That's because (before BPF) there's no place in the kernel that tries
to register the same tracepoint multiple times, and was considered a
bug if it happened, because there's no ref counters to deal with adding
them multiple times.

If the tracepoint is already registered (with the given function and
data), then something likely went wrong.

>   (3) And tracepoint_add_func() is triggerable via request from userspace.

Only via BPF correct?

I'm not sure how it works, but can't BPF catch that it is registering
the same tracepoint again?

We could add this patch, but then we need to add the WARN_ON_ONCE() to
all the other callers, because for the other callers it's a bug if the
tracepoint was registered twice with the same callback and data.

Or we can add another interface that wont warn, and BPF can use that.

>   (4) tracepoint_probe_register_prio() serializes tracepoint_add_func() call
>       triggered by concurrent request from userspace using tracepoints_mutex mutex.

You keep saying user space. Is it a BPF program?

>   (5) But tracepoint_add_func() does not check whether same tracepoint multiple
>       is already registered before calling func_add().

Because it's considered a bug in the kernel if that is the case.

>   (6) As a result, tracepoint_add_func() receives -EINVAL from func_add(), and
>       calls WARN_ON_ONCE() and the system crashes due to panic_on_warn == 1.
> 
> Why this is a bug in the BPF code? The BPF code is not allowing userspace to
> register the same tracepoint multiple times. I think that tracepoint_add_func()

Then how is the same tracepoint being registered multiple times?

You keep saying "user space" but the only way user space is doing this
is through BPF. Or am I missing something?

> is stupid enough to crash the kernel instead of rejecting when an attempt to
> register the same tracepoint multiple times is made.

Because its a bug in the kernel, and WARN_ON_ONCE() is what is used
when you detect something that is considered a bug in the kernel. If
you don't want warnings to crash the kernel, you don't add
"panic_on_warning".

If BPF is expected to register the same tracepoint with the same
callback and data more than once, then let's add a call to do that
without warning. Like I said, other callers expect the call to succeed
unless it's out of memory, which tends to cause other problems.

FYI, this warning has caught bugs in my own code, that triggered my
tests to fail, and had me go fix that bug before pushing it further.
And my tests fail only on a full warning.

-- Steve
