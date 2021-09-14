Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3CC40ABAD
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhINKaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhINKaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 06:30:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7647FC061760;
        Tue, 14 Sep 2021 03:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=AkAmP+XwbC3u2EnOmWg1+d8TikSHpIOHKHRYg4gt8m4=; b=foLIYWAOURNP6S9e3efY4E2F63
        /ox7MO547cQ0+xsln+MJfQULrWJ3p8DKN6l1dYf0D2gYrzNijDm0oJupoPwgLFjDKxNHJx82oZ8ea
        Vx2NaDdVnJ+mGD/aME4xaVWc+g/zGrJyh7t0UXvIvzkaRH8aTb1ut08L+/jQ2YS9fCQ3WP8gAZV71
        JNB5NeMRR3ImOff6K1MWJTb2mpaxLMaEC0Cc4fxlz3YKggS9uuHjzeOkVbRsJZyPzTLA10doxV47p
        7LCBYC3gln9qFgg0U7JKAnlgz9zo6Jkqx7tZcPnbIZO4bUSeMrJbUvl74P3qckqsjcdymZEPcJeBu
        4Gut303g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQ5g7-0037U7-35; Tue, 14 Sep 2021 10:28:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6F2E2300255;
        Tue, 14 Sep 2021 12:28:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 579792D0615D5; Tue, 14 Sep 2021 12:28:37 +0200 (CEST)
Date:   Tue, 14 Sep 2021 12:28:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-perf-users@vger.kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: fix panic by mark recursion inside
 perf_log_throttle
Message-ID: <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 09:58:44AM +0800, 王贇 wrote:
> On 2021/9/13 下午6:24, Peter Zijlstra wrote:

> > I'm confused tho; where does the #DF come from? Because taking a #PF
> > from NMI should be perfectly fine.
> > 
> > AFAICT that callchain is something like:
> > 
> > 	NMI
> > 	  perf_event_nmi_handler()
> > 	    (part of the chain is missing here)
> > 	      perf_log_throttle()
> > 	        perf_output_begin() /* events/ring_buffer.c */
> > 		  rcu_read_lock()
> > 		    rcu_lock_acquire()
> > 		      lock_acquire()
> > 		        trace_lock_acquire() --> perf_trace_foo
> > 
> > 			  ...
> > 			    perf_callchain()
> > 			      perf_callchain_user()
> > 			        #PF (fully expected during a userspace callchain)
> > 				  (some stuff, until the first __fentry)
> > 				    perf_trace_function_call
> > 				      perf_trace_buf_alloc()
> > 				        perf_swevent_get_recursion_context()
> > 					  *BOOM*
> > 
> > Now, supposedly we then take another #PF from get_recursion_context() or
> > something, but that doesn't make sense. That should just work...
> > 
> > Can you figure out what's going wrong there? going with the RIP, this
> > almost looks like 'swhash->recursion' goes splat, but again that makes
> > no sense, that's a per-cpu variable.
> 
> That's true, I actually have tried several approach to avoid the issue, but
> it trigger panic as long as we access 'swhash->recursion', the array should
> be accessible but somehow broken, that's why I consider this a suspected
> stack overflow, since nmi repeated and trace seems very long, but just a
> suspect...

You can simply increase the exception stack size to test this:

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index a8d4ad856568..e9e2c3ba5923 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -15,7 +15,7 @@
 #define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)



Also, something like this might be useful:


diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index f248eb2ac2d4..4dfdbb9395eb 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -33,6 +33,8 @@ bool in_task_stack(unsigned long *stack, struct task_struct *task,
 
 bool in_entry_stack(unsigned long *stack, struct stack_info *info);
 
+bool in_exception_stack_guard(unsigned long *stack);
+
 int get_stack_info(unsigned long *stack, struct task_struct *task,
 		   struct stack_info *info, unsigned long *visit_mask);
 bool get_stack_info_noinstr(unsigned long *stack, struct task_struct *task,
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 5601b95944fa..056cf4f31599 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -126,6 +126,39 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	return true;
 }
 
+noinstr bool in_exception_stack_guard(unsigned long *stack)
+{
+	unsigned long begin, end, stk = (unsigned long)stack;
+	const struct estack_pages *ep;
+	unsigned int k;
+
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
+
+	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
+	/*
+	 * Handle the case where stack trace is collected _before_
+	 * cea_exception_stacks had been initialized.
+	 */
+	if (!begin)
+		return false;
+
+	end = begin + sizeof(struct cea_exception_stacks);
+	/* Bail if @stack is outside the exception stack area. */
+	if (stk < begin || stk >= end)
+		return false;
+
+	/* Calc page offset from start of exception stacks */
+	k = (stk - begin) >> PAGE_SHIFT;
+	/* Lookup the page descriptor */
+	ep = &estack_pages[k];
+	/* Guard page? */
+	if (!ep->size)
+		return true;
+
+	return false;
+}
+
+
 static __always_inline bool in_irq_stack(unsigned long *stack, struct stack_info *info)
 {
 	unsigned long *end = (unsigned long *)this_cpu_read(hardirq_stack_ptr);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed..8b043ed02c0d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -459,6 +459,9 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 		handle_stack_overflow("kernel stack overflow (double-fault)",
 				      regs, address);
 	}
+
+	if (in_exception_stack_guard((void *)address))
+		pr_emerg("PANIC: exception stack guard: 0x%lx\n", address);
 #endif
 
 	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
