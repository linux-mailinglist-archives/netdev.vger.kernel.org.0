Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BD32B82CD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgKRRRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKRRRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:17:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3EA8248A7;
        Wed, 18 Nov 2020 17:17:32 +0000 (UTC)
Date:   Wed, 18 Nov 2020 12:17:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Subject: Re: violating function pointer signature
Message-ID: <20201118121730.12ee645b@gandalf.local.home>
In-Reply-To: <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 08:50:37 -0800
Nick Desaulniers <ndesaulniers@google.com> wrote:

> On Wed, Nov 18, 2020 at 5:23 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Nov 17, 2020 at 03:34:51PM -0500, Steven Rostedt wrote:
> >  
> > > > > Since all tracepoints callbacks have at least one parameter (__data), we
> > > > > could declare tp_stub_func as:
> > > > >
> > > > > static void tp_stub_func(void *data, ...)
> > > > > {
> > > > >   return;
> > > > > }
> > > > >
> > > > > And now C knows that tp_stub_func() can be called with one or more
> > > > > parameters, and had better be able to deal with it!  
> > > >
> > > > AFAIU this won't work.
> > > >
> > > > C99 6.5.2.2 Function calls
> > > >
> > > > "If the function is defined with a type that is not compatible with the type (of the
> > > > expression) pointed to by the expression that denotes the called function, the behavior is
> > > > undefined."  
> > >
> > > But is it really a problem in practice. I'm sure we could create an objtool
> > > function to check to make sure we don't break anything at build time.  
> >
> > I think that as long as the function is completely empty (it never
> > touches any of the arguments) this should work in practise.
> >
> > That is:
> >
> >   void tp_nop_func(void) { }  
> 
> or `void tp_nop_func()` if you plan to call it with different
> parameter types that are all unused in the body.  If you do plan to
> use them, maybe a pointer to a tagged union would be safer?

This stub function will never use the parameters passed to it.

You can see the patch I have for the tracepoint issue here:

 https://lore.kernel.org/r/20201118093405.7a6d2290@gandalf.local.home

I could change the stub from (void) to () if that would be better.

> 
> >
> > can be used as an argument to any function pointer that has a void
> > return. In fact, I already do that, grep for __static_call_nop().
> >
> > I'm not sure what the LLVM-CFI crud makes of it, but that's their
> > problem.  
> 
> If you have instructions on how to exercise the code in question, we
> can help test it with CFI.  Better to find any potential issues before
> they get committed.

If you apply the patch to the Linux kernel, and then apply:

  https://lore.kernel.org/r/20201116181638.6b0de6f7@gandalf.local.home

Which will force the failed case (to use the stubs). And build and boot the
kernel with those patches applied, you can test it with:


 # mount -t tracefs nodev /sys/kernel/tracing
 # cd /sys/kernel/tracing
 # echo 1 > events/sched/sched_switch/enable
 # mkdir instances/foo
 # echo 1 > instances/foo/events/sched/sched_switch/enable
 # echo 0 > events/sched/sched_switch/enable

Which add two callbacks to the function array for the sched_switch
tracepoint. The remove the first one, which would add the stub instead.

-- Steve
