Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF92B6E84
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgKQTVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:21:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgKQTVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:21:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92242221FC;
        Tue, 17 Nov 2020 19:21:46 +0000 (UTC)
Date:   Tue, 17 Nov 2020 14:21:45 -0500
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
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201117142145.43194f1a@gandalf.local.home>
In-Reply-To: <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 14:15:10 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
> index e7c2276be33e..e0351bb0b140 100644
> --- a/include/linux/tracepoint-defs.h
> +++ b/include/linux/tracepoint-defs.h
> @@ -38,6 +38,7 @@ struct tracepoint {
>         int (*regfunc)(void);
>         void (*unregfunc)(void);
>         struct tracepoint_func __rcu *funcs;
> +       void *stub_func;
>  };
>  
>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 0f21617f1a66..b0b805de3779 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -287,6 +287,9 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  #define DEFINE_TRACE_FN(_name, _reg, _unreg, proto, args)              \
>         static const char __tpstrtab_##_name[]                          \
>         __section("__tracepoints_strings") = #_name;                    \
> +       static void __cold __tracepoint_stub_func_##_name(void *__data, proto) \
> +       {                                                               \
> +       }                                                               \

The thing is, tracepoints are already bloated. I do not want to add
something like this that will unnecessarily add more text.

Since all tracepoints callbacks have at least one parameter (__data), we
could declare tp_stub_func as:

static void tp_stub_func(void *data, ...)
{
	return;
}

And now C knows that tp_stub_func() can be called with one or more
parameters, and had better be able to deal with it!

-- Steve



>         extern struct static_call_key STATIC_CALL_KEY(tp_func_##_name); \
>         int __traceiter_##_name(void *__data, proto);                   \
>         struct tracepoint __tracepoint_##_name  __used                  \
> @@ -298,7 +301,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>                 .iterator = &__traceiter_##_name,                       \
>                 .regfunc = _reg,                                        \
>                 .unregfunc = _unreg,                                    \
> -               .funcs = NULL };                                        \
> +               .funcs = NULL,                                          \
> +               .stub_func = __tracepoint_stub_func_##_name, };         \
>         __TRACEPOINT_ENTRY(_name);                                      \
>         int __traceiter_##_name(void *__data, proto)                    \
>         {                                                               \
> 
> Thanks,
> 
> Mathieu
> 

