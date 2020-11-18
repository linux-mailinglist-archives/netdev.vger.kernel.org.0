Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC82B84F4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKRTdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKRTdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:33:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56AC3238E6;
        Wed, 18 Nov 2020 19:33:45 +0000 (UTC)
Date:   Wed, 18 Nov 2020 14:33:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201118143343.4e86e79f@gandalf.local.home>
In-Reply-To: <20201118191127.GM2672@gate.crashing.org>
References: <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
        <20201118121730.12ee645b@gandalf.local.home>
        <20201118181226.GK2672@gate.crashing.org>
        <87o8jutt2h.fsf@mid.deneb.enyo.de>
        <20201118135823.3f0d24b7@gandalf.local.home>
        <20201118191127.GM2672@gate.crashing.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 13:11:27 -0600
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> Calling this via a different declared function type is undefined
> behaviour, but that is independent of how the function is *defined*.
> Your program can make ducks appear from your nose even if that function
> is never called, if you do that.  Just don't do UB, not even once!

But that's the whole point of this conversation. We are going to call this
from functions that are going to have some random set of parameters.

But there is a limit to that. All the callers will expect a void return,
and none of the callers will have a variable number of parameters.

The code in question is tracepoints and static calls. For this
conversation, I'll stick with tracepoints (even though static calls are
used too, but including that in the conversation is confusing).

Let me define what is happening:

We have a macro that creates a defined tracepoint with a defined set of
parameters. But each tracepoint can have a different set of parameters. All
of them will have "void *" as the first parameter, but what comes after
that is unique to each tracepoint (defined by a macro). None of them will
be a variadic function call.

The macro looks like this:

	int __traceiter_##_name(void *__data, proto)			\
	{								\
		struct tracepoint_func *it_func_ptr;			\
		void *it_func;						\
									\
		it_func_ptr =						\
			rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
		do {							\
			it_func = (it_func_ptr)->func;			\
			__data = (it_func_ptr)->data;			\
			((void(*)(void *, proto))(it_func))(__data, args); \
		} while ((++it_func_ptr)->func);			\
		return 0;						\
	}


There's an array of struct tracepoint_func pointers, which has the
definition of:

struct tracepoint_func {
	void *func;
	void *data;
	int prio;
};


And you see the above, the macro does:

	((void(*)(void *, proto))(it_func))(__data, args);

With it_func being the func from the struct tracepoint_func, which is a
void pointer, it is typecast to the function that is defined by the
tracepoint. args is defined as the arguments that match the proto.

The way the array is updated, is to use an RCU method, which is to create a
new array, copy the changes to the new array, then switch the "->funcs"
over to the new copy, and after a RCU grace period is finished, we can free
the old array.

The problem we are solving is on the removal case, if the memory is tight,
it is possible that the new array can not be allocated. But we must still
remove the called function. The idea in this case is to replace the
function saved with a stub. The above loop will call the stub and not the
removed function until another update happens.

This thread is about how safe is it to call:

void tp_stub_func(void) { return ; }

instead of the function that was removed?

Thus, we are indeed calling that stub function from a call site that is not
using the same parameters.

The question is, will this break?

-- Steve
