Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A102B7F4F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgKROWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgKROWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 09:22:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D40D246AA;
        Wed, 18 Nov 2020 14:22:30 +0000 (UTC)
Date:   Wed, 18 Nov 2020 09:22:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201118092228.4f6e5930@gandalf.local.home>
In-Reply-To: <87h7pmwyta.fsf@mid.deneb.enyo.de>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <87h7pmwyta.fsf@mid.deneb.enyo.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 14:59:29 +0100
Florian Weimer <fw@deneb.enyo.de> wrote:

> * Peter Zijlstra:
> 
> > I think that as long as the function is completely empty (it never
> > touches any of the arguments) this should work in practise.
> >
> > That is:
> >
> >   void tp_nop_func(void) { }
> >
> > can be used as an argument to any function pointer that has a void
> > return. In fact, I already do that, grep for __static_call_nop().  
> 
> You can pass it as a function parameter, but in general, you cannot
> call the function with a different prototype.  Even trivial
> differences such as variadic vs non-variadic prototypes matter.

In this case, I don't believe we need to worry about that, for either
tracepoints or static calls. As both don't have any variadic functions.

The function prototypes are defined by macros. For tracepoints, it's
TP_PROTO() and they require matching arguments. And to top it off, the
functions defined, are added to an array of indirect functions and called
separately. It would take a bit of work to even allow tracepoint callbacks
to be variadic functions. The same is true for static calls I believe.

Thus, all functions will be non-variadic in these cases.

> 
> The default Linux calling conventions are all of the cdecl family,
> where the caller pops the argument off the stack.  You didn't quote
> enough to context to tell whether other calling conventions matter in
> your case.
> 
> > I'm not sure what the LLVM-CFI crud makes of it, but that's their
> > problem.  
> 
> LTO can cause problems as well, particularly with whole-program
> optimization.

Again, for tracepoints and static calls that will likely not be an issue.
Because tracepoint callbacks are function parameters. So are static calls.
What happens is, when you update these locations, you pass in a function
you want as a callback, and it's added to an array (and this code is used
for all tracepoints with all different kinds of prototypes, as the function
is simply a void pointer). Then at the call sites, the function pointers are
typecast to the type of the callback function needed, and called.

It basically can not be optimized even when looking at the entire kernel.

-- Steve
