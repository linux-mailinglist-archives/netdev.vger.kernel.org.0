Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF78940D700
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhIPKFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbhIPKFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 06:05:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C43CC061574;
        Thu, 16 Sep 2021 03:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xO6cDSV5wGjT8fNnweb5kWrSN55pD3kXCauTwDvtqzY=; b=GnA7b29iRBLxA//NKRj4Ysbja/
        J5izVdQHzEYsf5NZ2mpep/EPuXNNyJ3UbsQjY9lGv0OTLWTT/A8I3Wr5Dj48gvzAPLRNGWWt09f/r
        AYuG7ZRMJXV2HCtnjb6pKRkjztCkrVurQlIrWJIsJGjEfHg2LFNL7FZtk3RMVRHulrIGQNe7a70k/
        3jqquNmbN1ujZHaBAvkp4LX9a5TRr0D13Up5HxRSJa/Qzx43jtLURUqcI8RIPAxgY8JlqqO7BTrbV
        I5jqeQ3tuCwbZkBAUQsZK7Uf4E2iP0EUGREvJxrF84ZKAjOo/5mKORvwcb6xbu/dWh1aU6kht/TGq
        xdhXLFKg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQoDo-00GXg8-6O; Thu, 16 Sep 2021 10:02:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 35733300238;
        Thu, 16 Sep 2021 12:02:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D8DA02CD49D71; Thu, 16 Sep 2021 12:02:21 +0200 (CEST)
Date:   Thu, 16 Sep 2021 12:02:21 +0200
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
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
Message-ID: <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
References: <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
 <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 10:03:19AM +0200, Peter Zijlstra wrote:

> Oh, I'm an idiot... yes it tries to read regs the stack, but clearly
> that won't work for the guard page.

OK, extended it to also cover task and IRQ stacks. get_stack_info()
doesn't seem to know about SOFTIRQ stacks on 64bit, might have to look
into that next.

Andy, what's the story with page_fault_oops(), according to the comment
in exc_double_fault() actual stack overflows will always hit #DF.

---
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 3d52b094850a..c4e92462c2b4 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -61,6 +61,9 @@ enum exception_stack_ordering {
 #define CEA_ESTACK_OFFS(st)					\
 	offsetof(struct cea_exception_stacks, st## _stack)
 
+#define CEA_EGUARD_OFFS(st)					\
+	offsetof(struct cea_exception_stacks, st## _stack_guard)
+
 #define CEA_ESTACK_PAGES					\
 	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
 
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index f248eb2ac2d4..8ff346579330 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -14,13 +14,14 @@
 #include <asm/switch_to.h>
 
 enum stack_type {
-	STACK_TYPE_UNKNOWN,
+	STACK_TYPE_UNKNOWN = 0,
 	STACK_TYPE_TASK,
 	STACK_TYPE_IRQ,
 	STACK_TYPE_SOFTIRQ,
 	STACK_TYPE_ENTRY,
 	STACK_TYPE_EXCEPTION,
 	STACK_TYPE_EXCEPTION_LAST = STACK_TYPE_EXCEPTION + N_EXCEPTION_STACKS-1,
+	STACK_TYPE_GUARD = 0x80,
 };
 
 struct stack_info {
@@ -31,6 +32,15 @@ struct stack_info {
 bool in_task_stack(unsigned long *stack, struct task_struct *task,
 		   struct stack_info *info);
 
+static __always_inline bool in_stack_guard(void *addr, void *begin, void *end)
+{
+#ifdef CONFIG_VMAP_STACK
+	if (addr > (begin - PAGE_SIZE))
+		return true;
+#endif
+	return false;
+}
+
 bool in_entry_stack(unsigned long *stack, struct stack_info *info);
 
 int get_stack_info(unsigned long *stack, struct task_struct *task,
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ea4fe192189d..91b406fe2a39 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -32,12 +32,19 @@ static struct pt_regs exec_summary_regs;
 bool noinstr in_task_stack(unsigned long *stack, struct task_struct *task,
 			   struct stack_info *info)
 {
-	unsigned long *begin = task_stack_page(task);
-	unsigned long *end   = task_stack_page(task) + THREAD_SIZE;
-
-	if (stack < begin || stack >= end)
+	void *begin = task_stack_page(task);
+	void *end   = begin + THREAD_SIZE;
+	int type    = STACK_TYPE_TASK;
+
+	if ((void *)stack < begin || (void *)stack >= end) {
+		if (in_stack_guard(stack, begin, end)) {
+			type |= STACK_TYPE_GUARD;
+			goto fill_info;
+		}
 		return false;
+	}
 
+fill_info:
 	info->type	= STACK_TYPE_TASK;
 	info->begin	= begin;
 	info->end	= end;
@@ -50,14 +57,20 @@ bool noinstr in_task_stack(unsigned long *stack, struct task_struct *task,
 bool noinstr in_entry_stack(unsigned long *stack, struct stack_info *info)
 {
 	struct entry_stack *ss = cpu_entry_stack(smp_processor_id());
-
+	int type = STACK_TYPE_ENTRY;
 	void *begin = ss;
 	void *end = ss + 1;
 
-	if ((void *)stack < begin || (void *)stack >= end)
+	if ((void *)stack < begin || (void *)stack >= end) {
+		if (in_stack_guard(stack, begin, end)) {
+			type |= STACK_TYPE_GUARD;
+			goto fill_info;
+		}
 		return false;
+	}
 
-	info->type	= STACK_TYPE_ENTRY;
+fill_info:
+	info->type	= type;
 	info->begin	= begin;
 	info->end	= end;
 	info->next_sp	= NULL;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 5601b95944fa..3634bdf9ab36 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -32,9 +32,15 @@ const char *stack_type_name(enum stack_type type)
 {
 	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
 
+	if (type == STACK_TYPE_TASK)
+		return "TASK";
+
 	if (type == STACK_TYPE_IRQ)
 		return "IRQ";
 
+	if (type == STACK_TYPE_SOFTIRQ)
+		return "SOFTIRQ";
+
 	if (type == STACK_TYPE_ENTRY) {
 		/*
 		 * On 64-bit, we have a generic entry stack that we
@@ -63,6 +69,11 @@ struct estack_pages {
 };
 
 #define EPAGERANGE(st)							\
+	[PFN_DOWN(CEA_EGUARD_OFFS(st))] = {				\
+		.offs	= CEA_EGUARD_OFFS(st),				\
+		.size	= PAGE_SIZE,					\
+		.type	= STACK_TYPE_GUARD +				\
+			  STACK_TYPE_EXCEPTION + ESTACK_ ##st, },	\
 	[PFN_DOWN(CEA_ESTACK_OFFS(st)) ...				\
 	 PFN_DOWN(CEA_ESTACK_OFFS(st) + CEA_ESTACK_SIZE(st) - 1)] = {	\
 		.offs	= CEA_ESTACK_OFFS(st),				\
@@ -111,7 +122,7 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	k = (stk - begin) >> PAGE_SHIFT;
 	/* Lookup the page descriptor */
 	ep = &estack_pages[k];
-	/* Guard page? */
+	/* unknown entry */
 	if (!ep->size)
 		return false;
 
@@ -122,7 +133,12 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	info->type	= ep->type;
 	info->begin	= (unsigned long *)begin;
 	info->end	= (unsigned long *)end;
-	info->next_sp	= (unsigned long *)regs->sp;
+	info->next_sp	= NULL;
+
+	/* Can't read regs from a guard page. */
+	if (!(ep->type & STACK_TYPE_GUARD))
+		info->next_sp = (unsigned long *)regs->sp;
+
 	return true;
 }
 
@@ -130,6 +146,7 @@ static __always_inline bool in_irq_stack(unsigned long *stack, struct stack_info
 {
 	unsigned long *end = (unsigned long *)this_cpu_read(hardirq_stack_ptr);
 	unsigned long *begin;
+	int type = STACK_TYPE_IRQ;
 
 	/*
 	 * @end points directly to the top most stack entry to avoid a -8
@@ -144,19 +161,27 @@ static __always_inline bool in_irq_stack(unsigned long *stack, struct stack_info
 	 * final operation is 'popq %rsp' which means after that RSP points
 	 * to the original stack and not to @end.
 	 */
-	if (stack < begin || stack >= end)
+	if (stack < begin || stack >= end) {
+		if (in_stack_guard(stack, begin, end)) {
+			type |= STACK_TYPE_GUARD;
+			goto fill_info;
+		}
 		return false;
+	}
 
-	info->type	= STACK_TYPE_IRQ;
+fill_info:
+	info->type	= type;
 	info->begin	= begin;
 	info->end	= end;
+	info->next_sp	= NULL;
 
 	/*
 	 * The next stack pointer is stored at the top of the irq stack
 	 * before switching to the irq stack. Actual stack entries are all
 	 * below that.
 	 */
-	info->next_sp = (unsigned long *)*(end - 1);
+	if (!(type & STACK_TYPE_GUARD))
+		info->next_sp = (unsigned long *)*(end - 1);
 
 	return true;
 }
@@ -193,6 +218,9 @@ int get_stack_info(unsigned long *stack, struct task_struct *task,
 	if (!get_stack_info_noinstr(stack, task, info))
 		goto unknown;
 
+	if (info->type & STACK_TYPE_GUARD)
+		goto unknown;
+
 	/*
 	 * Make sure we don't iterate through any given stack more than once.
 	 * If it comes up a second time then there's something wrong going on:
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed..80f6d8d735eb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -353,6 +353,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 
 #ifdef CONFIG_VMAP_STACK
 	unsigned long address = read_cr2();
+	struct stack_info info;
 #endif
 
 #ifdef CONFIG_X86_ESPFIX64
@@ -455,9 +456,11 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	 * stack even if the actual trigger for the double fault was
 	 * something else.
 	 */
-	if ((unsigned long)task_stack_page(tsk) - 1 - address < PAGE_SIZE) {
-		handle_stack_overflow("kernel stack overflow (double-fault)",
-				      regs, address);
+	if (get_stack_info_noinstr((void *)address, current, &info) &&
+	    info.type & STACK_TYPE_GUARD) {
+		const char *name = stack_type_name(info.type & ~STACK_TYPE_GUARD);
+		pr_emerg("BUG: %s stack guard hit at %p (stack is %p..%p)\n",
+			 name, (void *)address, info.begin, info.end);
 	}
 #endif
 
@@ -708,7 +711,9 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 	sp    = regs->sp;
 	stack = (unsigned long *)sp;
 
-	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
+	if (!get_stack_info_noinstr(stack, current, &info) ||
+	    info.type & STACK_TYPE_GUARD ||
+	    info.type == STACK_TYPE_ENTRY ||
 	    info.type >= STACK_TYPE_EXCEPTION_LAST)
 		sp = __this_cpu_ist_top_va(VC2);
 
