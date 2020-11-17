Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834002B7162
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgKQWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKQWTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:19:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4D6120678;
        Tue, 17 Nov 2020 22:19:05 +0000 (UTC)
Date:   Tue, 17 Nov 2020 17:19:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201117171904.2d455699@gandalf.local.home>
In-Reply-To: <202011171330.94C6BA7E93@keescook>
References: <20201116175107.02db396d@gandalf.local.home>
        <202011171330.94C6BA7E93@keescook>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 13:33:42 -0800
Kees Cook <keescook@chromium.org> wrote:

> As I think got discussed in the thread, what you had here wouldn't work
> in a CFI build if the function prototype of the call site and the
> function don't match. (Though I can't tell if .func() is ever called?)
> 
> i.e. .func's prototype must match tp_stub_func()'s.
> 


Hmm, I wonder how you handle tracepoints? This is called here:

include/linux/tracepoint.h:


#define DEFINE_TRACE_FN(_name, _reg, _unreg, proto, args)		\
	static const char __tpstrtab_##_name[]				\
	__section("__tracepoints_strings") = #_name;			\
	extern struct static_call_key STATIC_CALL_KEY(tp_func_##_name);	\
	int __traceiter_##_name(void *__data, proto);			\
	struct tracepoint __tracepoint_##_name	__used			\
	__section("__tracepoints") = {					\
		.name = __tpstrtab_##_name,				\
		.key = STATIC_KEY_INIT_FALSE,				\
		.static_call_key = &STATIC_CALL_KEY(tp_func_##_name),	\
		.static_call_tramp = STATIC_CALL_TRAMP_ADDR(tp_func_##_name), \
		.iterator = &__traceiter_##_name,			\
		.regfunc = _reg,					\
		.unregfunc = _unreg,					\
		.funcs = NULL };					\
	__TRACEPOINT_ENTRY(_name);					\
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

			^^^^ called above ^^^^

Where args is unique for every tracepoint, but func is simply a void
pointer.

-- Steve


		} while ((++it_func_ptr)->func);			\
		return 0;						\
	}								\
