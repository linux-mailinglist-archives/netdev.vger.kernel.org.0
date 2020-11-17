Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB12B708B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKQU64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgKQU64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:58:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010ED241A5;
        Tue, 17 Nov 2020 20:58:52 +0000 (UTC)
Date:   Tue, 17 Nov 2020 15:58:51 -0500
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
Message-ID: <20201117155851.0c915705@gandalf.local.home>
In-Reply-To: <20201117153451.3015c5c9@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 15:34:51 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 17 Nov 2020 14:47:20 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > There seems to be more effect on the data size: adding the "stub_func" field
> > in struct tracepoint adds 8320 bytes of data to my vmlinux. But considering
> > the layout of struct tracepoint:
> > 
> > struct tracepoint {
> >         const char *name;               /* Tracepoint name */
> >         struct static_key key;
> >         struct static_call_key *static_call_key;
> >         void *static_call_tramp;
> >         void *iterator;
> >         int (*regfunc)(void);
> >         void (*unregfunc)(void);
> >         struct tracepoint_func __rcu *funcs;
> >         void *stub_func;
> > };
> > 
> > I would argue that we have many other things to optimize there if we want to
> > shrink the bloat, starting with static keys and system call reg/unregfunc pointers.  
> 
> This is the part that I want to decrease, and yes there's other fish to fry
> in that code, but I really don't want to be adding more.

If it comes down to not trusting calling a stub, I'll still keep the stub
logic in, and just add the following:

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 0f21617f1a66..d50a1a652d61 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,6 +33,8 @@ struct trace_eval_map {
 
 #define TRACEPOINT_DEFAULT_PRIO	10
 
+extern void tp_stub_func(void *data, ...);
+
 extern struct srcu_struct tracepoint_srcu;
 
 extern int
@@ -310,7 +312,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		do {							\
 			it_func = (it_func_ptr)->func;			\
 			__data = (it_func_ptr)->data;			\
-			((void(*)(void *, proto))(it_func))(__data, args); \
+			if (likely(it_func != tp_stub_func))		\
+				((void(*)(void *, proto))(it_func))(__data, args); \
 		} while ((++it_func_ptr)->func);			\
 		return 0;						\
 	}								\
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 774b3733cbbe..f3bb0ee478d1 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -54,7 +54,7 @@ struct tp_probes {
 };
 
 /* Called in removal of a func but failed to allocate a new tp_funcs */
-static void tp_stub_func(void)
+void tp_stub_func(void *data, ...)
 {
 	return;
 }


-- Steve
