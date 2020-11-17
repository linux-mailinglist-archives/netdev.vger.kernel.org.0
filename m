Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222DB2B6E3A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgKQTPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:15:13 -0500
Received: from mail.efficios.com ([167.114.26.124]:52766 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgKQTPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:15:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2E94B2E33B4;
        Tue, 17 Nov 2020 14:15:11 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PWslQkQ6au8F; Tue, 17 Nov 2020 14:15:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BB10E2E31DE;
        Tue, 17 Nov 2020 14:15:10 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com BB10E2E31DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605640510;
        bh=pMCjGD3W3o9yr5EI9OVWHLPsyB3UFgJfUztRMzE6NM4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=jY4LAi5wIj9y0hghJEDCmUkZKjlFqfQxZzeIXcbKAWQKdfmVgFkazxVldbaerXptQ
         6GNdtD99EbtEh9JfC53WO42MpRlBtZbrfF3ijfYTw5KGDknMiz7TsLBarEyMGqRRGm
         wCDKbm81rQs7NGWMBkhNzvDup9/yYRUPqt5DJ81wpikrEoesW8nVSYRqex1680wxxX
         QVxJo9bqPToWujHxx+PXqOAiarLY1qfs/nfmmaWxzg5NfkyjiZLOTXo1M2MpFzeq/3
         WUxqpEZrfBNL55I3aKvGHYJ47Ufawv3ZqxGIdiDADkftupLC/55jk4P4o0F/lVSfaP
         RjONYIA7kAiOQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HzwNQ-9LJXv9; Tue, 17 Nov 2020 14:15:10 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id A40302E306B;
        Tue, 17 Nov 2020 14:15:10 -0500 (EST)
Date:   Tue, 17 Nov 2020 14:15:10 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
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
        Kees Cook <keescook@chromium.org>
Message-ID: <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201116175107.02db396d@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: wK+E+/XqwQK7hF0JAgvCAmWXa5f4Ag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 16, 2020, at 5:51 PM, rostedt rostedt@goodmis.org wrote:

> [ Kees, I added you because you tend to know about these things.
>  Is it OK to assign a void func(void) that doesn't do anything and returns
>  nothing to a function pointer that could be call with parameters? We need
>  to add stubs for tracepoints when we fail to allocate a new array on
>  removal of a callback, but the callbacks do have arguments, but the stub
>  called does not have arguments.

[...]

> +/* Called in removal of a func but failed to allocate a new tp_funcs */
> +static void tp_stub_func(void)
> +{
> +	return;
> +}
> +

In C, the "void" unnamed function parameter specifies that the function has no
parameters. C99 section 6.7.5.3 Function declarators (including prototypes):

"The special case of an unnamed parameter of type void as the only item in the list
specifies that the function has no parameters."

The C99 standard section "6.5.2.2 Function calls" states:

"If the function is defined with a type that is not compatible with the type (of the
expression) pointed to by the expression that denotes the called function, the behavior is
undefined."

"J.2 Undefined behavior" states:

"For a call to a function without a function prototype in scope, the number of
arguments does not equal the number of parameters (6.5.2.2)."

I suspect that calling a function expecting no parameters from a call site with
parameters might work for the cdecl calling convention because the caller
is responsible for stack cleanup, but it seems to rely on a behavior which is
very much tied to the calling convention, and within "undefined behavior" territory
as far as the C standard is concerned.

I checked whether going for "void tp_stub_func()" instead would work better,
but it seems to also mean "no parameter" when applied to the function definition.
It's only when applied on the function declarator that is not part of the definition
that it means no information about the number or type of parameters is supplied.
(see C99 "6.7.5.3 Function declarators (including prototypes)" items 14 and 15)
And the kernel builds with "-Werror=strict-prototypes" which would not allow
it anyway.

One thing which would work with respect to the C standard is to define one stub
function per tracepoint. This add 16 bytes of code per TRACE_DEFINE() on x86-64,
but by specifying that those are cache-cold with "__cold", I notice that it adds
no extra code size my build of kernel/sched/core.o which contains 30 tracepoint
definitions.

diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
index e7c2276be33e..e0351bb0b140 100644
--- a/include/linux/tracepoint-defs.h
+++ b/include/linux/tracepoint-defs.h
@@ -38,6 +38,7 @@ struct tracepoint {
        int (*regfunc)(void);
        void (*unregfunc)(void);
        struct tracepoint_func __rcu *funcs;
+       void *stub_func;
 };
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 0f21617f1a66..b0b805de3779 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -287,6 +287,9 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 #define DEFINE_TRACE_FN(_name, _reg, _unreg, proto, args)              \
        static const char __tpstrtab_##_name[]                          \
        __section("__tracepoints_strings") = #_name;                    \
+       static void __cold __tracepoint_stub_func_##_name(void *__data, proto) \
+       {                                                               \
+       }                                                               \
        extern struct static_call_key STATIC_CALL_KEY(tp_func_##_name); \
        int __traceiter_##_name(void *__data, proto);                   \
        struct tracepoint __tracepoint_##_name  __used                  \
@@ -298,7 +301,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
                .iterator = &__traceiter_##_name,                       \
                .regfunc = _reg,                                        \
                .unregfunc = _unreg,                                    \
-               .funcs = NULL };                                        \
+               .funcs = NULL,                                          \
+               .stub_func = __tracepoint_stub_func_##_name, };         \
        __TRACEPOINT_ENTRY(_name);                                      \
        int __traceiter_##_name(void *__data, proto)                    \
        {                                                               \

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
