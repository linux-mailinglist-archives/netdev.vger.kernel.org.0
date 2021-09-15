Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E367040C815
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhIOPTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbhIOPTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 11:19:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79441C061574;
        Wed, 15 Sep 2021 08:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=lE5kf7OISKlmTZmmgfiMeKh8f7VRtSv6f6uAFhkQPd8=; b=DTnmtBm9d6aGHwLICCv1Mnk1Tl
        0rdkj6iZwR7Ylr4AsvspVewzAMlj7CHujgfTbyerJW03D+ClesOlIPv020grFF39Pbn6CXcyNKgIY
        UUYmrSv8oK1Tl0HwYwgVWJZzk/umB9Z1ntJiUn0pgNo7Ibih5RtXkhD3OZbBnL2NYC61PVv6mqdpI
        9bh8KjBdnJLXsORzvImv2pbm9UeMhhTMP5aXtrk16Jm+QkOZNXa3caoNnfIyOodp/A2vxhWJcz4++
        tFrHDYrthotUHlTI5mI5zjChbBp4s+TdGfs0jFaaMdQgFXKSuAtNHgLhU0AjbfDbnSgTBBkC1mDXl
        N9Psv2UQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQWf6-003QAE-CY; Wed, 15 Sep 2021 15:17:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 45A7730003A;
        Wed, 15 Sep 2021 17:17:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1D05220CB3027; Wed, 15 Sep 2021 17:17:22 +0200 (CEST)
Date:   Wed, 15 Sep 2021 17:17:22 +0200
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
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org
Subject: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
Message-ID: <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 09:51:57AM +0800, 王贇 wrote:

> > +
> > +	if (in_exception_stack_guard((void *)address))
> > +		pr_emerg("PANIC: exception stack guard: 0x%lx\n", address);
> >  #endif
> >  
> >  	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
> > 
> 
> The panic triggered as below after the stack size recovered, I found this info
> could be helpful, maybe we should keep it?

Could you please test this?

---
Subject: x86/dumpstack/64: Add guard pages to stack_info
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Sep 15 17:12:59 CEST 2021

Explicitly add the exception stack guard pages to stack_info and
report on them from #DF.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/cpu_entry_area.h |    3 +++
 arch/x86/include/asm/stacktrace.h     |    3 ++-
 arch/x86/kernel/dumpstack_64.c        |   17 ++++++++++++++++-
 arch/x86/kernel/traps.c               |   17 ++++++++++++++++-
 4 files changed, 37 insertions(+), 3 deletions(-)

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
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -32,9 +32,15 @@ const char *stack_type_name(enum stack_t
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
@@ -111,10 +122,11 @@ static __always_inline bool in_exception
 	k = (stk - begin) >> PAGE_SHIFT;
 	/* Lookup the page descriptor */
 	ep = &estack_pages[k];
-	/* Guard page? */
+	/* unknown entry */
 	if (!ep->size)
 		return false;
 
+
 	begin += (unsigned long)ep->offs;
 	end = begin + (unsigned long)ep->size;
 	regs = (struct pt_regs *)end - 1;
@@ -193,6 +205,9 @@ int get_stack_info(unsigned long *stack,
 	if (!get_stack_info_noinstr(stack, task, info))
 		goto unknown;
 
+	if (info->type & STACK_TYPE_GUARD)
+		goto unknown;
+
 	/*
 	 * Make sure we don't iterate through any given stack more than once.
 	 * If it comes up a second time then there's something wrong going on:
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -461,6 +461,19 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	}
 #endif
 
+#ifdef CONFIG_X86_64
+	{
+		struct stack_info info;
+
+		if (get_stack_info_noinstr((void *)address, current, &info) &&
+		    info.type & STACK_TYPE_GUARD) {
+			const char *name = stack_type_name(info.type & ~STACK_TYPE_GUARD);
+			pr_emerg("BUG: %s stack guard hit at %p (stack is %p..%p)\n",
+				 name, (void *)address, info.begin, info.end);
+		}
+	}
+#endif
+
 	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
 	die("double fault", regs, error_code);
 	panic("Machine halted.");
@@ -708,7 +721,9 @@ asmlinkage __visible noinstr struct pt_r
 	sp    = regs->sp;
 	stack = (unsigned long *)sp;
 
-	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
+	if (!get_stack_info_noinstr(stack, current, &info) ||
+	    info.type & STACK_TYPE_GUARD ||
+	    info.type == STACK_TYPE_ENTRY ||
 	    info.type >= STACK_TYPE_EXCEPTION_LAST)
 		sp = __this_cpu_ist_top_va(VC2);
 
