Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E32B2B71FF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKQXM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:12:57 -0500
Received: from mail.efficios.com ([167.114.26.124]:50378 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQXM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:12:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 3EFB82E55CE;
        Tue, 17 Nov 2020 18:12:55 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pBa8GWPfhX9y; Tue, 17 Nov 2020 18:12:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D76CA2E57BA;
        Tue, 17 Nov 2020 18:12:54 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D76CA2E57BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605654774;
        bh=vLdftlX/55MeTq+v64XuxgW7pzs9L8WtPSZDqfhYEZc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=r00UlGbYXVI23qEfKALHSeTvyEOjnafOtLQV4K/7L4ZmLD3S70oyS0KU+sT6RBdwV
         4LwlwIqCa1rU5XZJvRID9f9EJ+xaVuzr6NeF2o1kKdKBAKV2wU0H6ZVbgBfOOFS6EH
         RKycNc0RrviB/56ZlPjWLVziKCqEE9CtnBlfbU6oGxQAXxdAQJ5HR57HsIye4UpcM9
         xt6J60/yLMlhSthcceepNrHaDbXJ49rb/XTdMz/r8aWLxE7//Nhf0Yt3dvaDRvdMba
         UoFNE2EmWYdeElJLLTpFtJCuWkKTBIkJ9PlFjprz6/uQQ65WRyDzsE6gWNmNNvdDPO
         hggjt+T982wbg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SHMRXlDdwvao; Tue, 17 Nov 2020 18:12:54 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id C05152E57B9;
        Tue, 17 Nov 2020 18:12:54 -0500 (EST)
Date:   Tue, 17 Nov 2020 18:12:54 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     Kees Cook <keescook@chromium.org>,
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
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <1473764147.48847.1605654774757.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201117171904.2d455699@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <202011171330.94C6BA7E93@keescook> <20201117171904.2d455699@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: Y/jQdv3dPGXvTPsmYxooPni6/fazNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 17, 2020, at 5:19 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 17 Nov 2020 13:33:42 -0800
> Kees Cook <keescook@chromium.org> wrote:
> 
>> As I think got discussed in the thread, what you had here wouldn't work
>> in a CFI build if the function prototype of the call site and the
>> function don't match. (Though I can't tell if .func() is ever called?)
>> 
>> i.e. .func's prototype must match tp_stub_func()'s.
>> 
> 
> 
> Hmm, I wonder how you handle tracepoints? This is called here:
> 
> include/linux/tracepoint.h:
> 
> 
> #define DEFINE_TRACE_FN(_name, _reg, _unreg, proto, args)		\
>	static const char __tpstrtab_##_name[]				\
>	__section("__tracepoints_strings") = #_name;			\
>	extern struct static_call_key STATIC_CALL_KEY(tp_func_##_name);	\
>	int __traceiter_##_name(void *__data, proto);			\
>	struct tracepoint __tracepoint_##_name	__used			\
>	__section("__tracepoints") = {					\
>		.name = __tpstrtab_##_name,				\
>		.key = STATIC_KEY_INIT_FALSE,				\
>		.static_call_key = &STATIC_CALL_KEY(tp_func_##_name),	\
>		.static_call_tramp = STATIC_CALL_TRAMP_ADDR(tp_func_##_name), \
>		.iterator = &__traceiter_##_name,			\
>		.regfunc = _reg,					\
>		.unregfunc = _unreg,					\
>		.funcs = NULL };					\
>	__TRACEPOINT_ENTRY(_name);					\
>	int __traceiter_##_name(void *__data, proto)			\
>	{								\
>		struct tracepoint_func *it_func_ptr;			\
>		void *it_func;						\
>									\
>		it_func_ptr =						\
>			rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
>		do {							\
>			it_func = (it_func_ptr)->func;			\
>			__data = (it_func_ptr)->data;			\
> 
>			((void(*)(void *, proto))(it_func))(__data, args); \
> 
>			^^^^ called above ^^^^
> 
> Where args is unique for every tracepoint, but func is simply a void
> pointer.

That being said, the called functions have a prototype which match the
caller prototype exactly. So within the tracepoint internal data structures,
this function pointer is indeed a void pointer, but it is cast to a prototype
matching the callees to perform the calls. I suspect that as long as CFI checks
that caller/callees prototypes are compatible at runtime when the actual
calls happen, this all works fine.

Thanks,

Mathieu

> 
> -- Steve
> 
> 
>		} while ((++it_func_ptr)->func);			\
>		return 0;						\
> 	}								\

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
