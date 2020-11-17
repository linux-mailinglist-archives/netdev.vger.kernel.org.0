Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B80D2B702B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgKQUe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKQUe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:34:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A0FF2225B;
        Tue, 17 Nov 2020 20:34:53 +0000 (UTC)
Date:   Tue, 17 Nov 2020 15:34:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
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
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201117153451.3015c5c9@gandalf.local.home>
In-Reply-To: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 14:47:20 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> There seems to be more effect on the data size: adding the "stub_func" field
> in struct tracepoint adds 8320 bytes of data to my vmlinux. But considering
> the layout of struct tracepoint:
> 
> struct tracepoint {
>         const char *name;               /* Tracepoint name */
>         struct static_key key;
>         struct static_call_key *static_call_key;
>         void *static_call_tramp;
>         void *iterator;
>         int (*regfunc)(void);
>         void (*unregfunc)(void);
>         struct tracepoint_func __rcu *funcs;
>         void *stub_func;
> };
> 
> I would argue that we have many other things to optimize there if we want to
> shrink the bloat, starting with static keys and system call reg/unregfunc pointers.

This is the part that I want to decrease, and yes there's other fish to fry
in that code, but I really don't want to be adding more.

> 
> > 
> > Since all tracepoints callbacks have at least one parameter (__data), we
> > could declare tp_stub_func as:
> > 
> > static void tp_stub_func(void *data, ...)
> > {
> >	return;
> > }
> > 
> > And now C knows that tp_stub_func() can be called with one or more
> > parameters, and had better be able to deal with it!  
> 
> AFAIU this won't work.
> 
> C99 6.5.2.2 Function calls
> 
> "If the function is defined with a type that is not compatible with the type (of the
> expression) pointed to by the expression that denotes the called function, the behavior is
> undefined."

But is it really a problem in practice. I'm sure we could create an objtool
function to check to make sure we don't break anything at build time.

> 
> and
> 
> 6.7.5.3 Function declarators (including prototypes), item 15:
> 
> "For two function types to be compatible, both shall specify compatible return types.

But all tracepoint callbacks have void return types, which means they are
compatible.

> 
> Moreover, the parameter type lists, if both are present, shall agree in the number of
> parameters and in use of the ellipsis terminator; corresponding parameters shall have
> compatible types. [...]"

Which is why I gave the stub function's first parameter the same type that
all tracepoint callbacks have a prototype that starts with "void *data"

and my solution is to define:

	void tp_stub_func(void *data, ...) { return; }

Which is in line with: "corresponding parameters shall have compatible
types". The corresponding parameter is simply "void *data".

> 
> What you suggest here is to use the ellipsis in the stub definition, but the caller
> prototype does not use the ellipsis, which brings us into undefined behavior territory
> again.

And I believe the "undefined behavior" is that you can't trust what is in
the parameters if the callee chooses to look at them, and that is not the
case here. But since the called function doesn't care, I highly doubt it
will ever be an issue. I mean, the only way this can break is if the caller
places something in the stack that it expects the callee to fix. With all
the functions in assembly we have, I'm pretty confident that if a compiler
does something like this, it would break all over the place.

-- Steve
