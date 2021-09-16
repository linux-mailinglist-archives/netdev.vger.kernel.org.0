Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6740D226
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhIPDtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:49:18 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:51809 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234265AbhIPDtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:49:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UoXWzBQ_1631764069;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoXWzBQ_1631764069)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Sep 2021 11:47:50 +0800
Subject: Re: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
To:     Peter Zijlstra <peterz@infradead.org>
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
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
Date:   Thu, 16 Sep 2021 11:47:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/15 下午11:17, Peter Zijlstra wrote:
> On Wed, Sep 15, 2021 at 09:51:57AM +0800, 王贇 wrote:
> 
>>> +
>>> +	if (in_exception_stack_guard((void *)address))
>>> +		pr_emerg("PANIC: exception stack guard: 0x%lx\n", address);
>>>  #endif
>>>  
>>>  	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
>>>
>>
>> The panic triggered as below after the stack size recovered, I found this info
>> could be helpful, maybe we should keep it?
> 
> Could you please test this?

I did some debug and found the issue, we are missing:

@@ -122,7 +137,10 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
        info->type      = ep->type;
        info->begin     = (unsigned long *)begin;
        info->end       = (unsigned long *)end;
-       info->next_sp   = (unsigned long *)regs->sp;
+
+       if (!(ep->type & STACK_TYPE_GUARD))
+               info->next_sp   = (unsigned long *)regs->sp;
+
        return true;
 }

as the guard page are not working as real stack I guess?

With that one things going on correctly, and some trivials below.

> 
> ---
> Subject: x86/dumpstack/64: Add guard pages to stack_info
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Sep 15 17:12:59 CEST 2021
> 
> Explicitly add the exception stack guard pages to stack_info and
> report on them from #DF.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/cpu_entry_area.h |    3 +++
>  arch/x86/include/asm/stacktrace.h     |    3 ++-
>  arch/x86/kernel/dumpstack_64.c        |   17 ++++++++++++++++-
>  arch/x86/kernel/traps.c               |   17 ++++++++++++++++-
>  4 files changed, 37 insertions(+), 3 deletions(-)
> 
> --- a/arch/x86/include/asm/cpu_entry_area.h
> +++ b/arch/x86/include/asm/cpu_entry_area.h
> @@ -61,6 +61,9 @@ enum exception_stack_ordering {
>  #define CEA_ESTACK_OFFS(st)					\
>  	offsetof(struct cea_exception_stacks, st## _stack)
>  
> +#define CEA_EGUARD_OFFS(st)					\
> +	offsetof(struct cea_exception_stacks, st## _stack_guard)
> +
>  #define CEA_ESTACK_PAGES					\
>  	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
>  
> --- a/arch/x86/include/asm/stacktrace.h
> +++ b/arch/x86/include/asm/stacktrace.h
> @@ -14,13 +14,14 @@
>  #include <asm/switch_to.h>
>  
>  enum stack_type {
> -	STACK_TYPE_UNKNOWN,
> +	STACK_TYPE_UNKNOWN = 0,

Is this necessary?

>  	STACK_TYPE_TASK,
>  	STACK_TYPE_IRQ,
>  	STACK_TYPE_SOFTIRQ,
>  	STACK_TYPE_ENTRY,
>  	STACK_TYPE_EXCEPTION,
>  	STACK_TYPE_EXCEPTION_LAST = STACK_TYPE_EXCEPTION + N_EXCEPTION_STACKS-1,
> +	STACK_TYPE_GUARD = 0x80,
>  };
>  
>  struct stack_info {
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -32,9 +32,15 @@ const char *stack_type_name(enum stack_t
>  {
>  	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
>  
> +	if (type == STACK_TYPE_TASK)
> +		return "TASK";
> +
>  	if (type == STACK_TYPE_IRQ)
>  		return "IRQ";
>  
> +	if (type == STACK_TYPE_SOFTIRQ)
> +		return "SOFTIRQ";
> +

Do we need one for GUARD too?

>  	if (type == STACK_TYPE_ENTRY) {
>  		/*
>  		 * On 64-bit, we have a generic entry stack that we
> @@ -63,6 +69,11 @@ struct estack_pages {
>  };
>  
>  #define EPAGERANGE(st)							\
> +	[PFN_DOWN(CEA_EGUARD_OFFS(st))] = {				\
> +		.offs	= CEA_EGUARD_OFFS(st),				\
> +		.size	= PAGE_SIZE,					\
> +		.type	= STACK_TYPE_GUARD +				\
> +			  STACK_TYPE_EXCEPTION + ESTACK_ ##st, },	\
>  	[PFN_DOWN(CEA_ESTACK_OFFS(st)) ...				\
>  	 PFN_DOWN(CEA_ESTACK_OFFS(st) + CEA_ESTACK_SIZE(st) - 1)] = {	\
>  		.offs	= CEA_ESTACK_OFFS(st),				\
> @@ -111,10 +122,11 @@ static __always_inline bool in_exception
>  	k = (stk - begin) >> PAGE_SHIFT;
>  	/* Lookup the page descriptor */
>  	ep = &estack_pages[k];
> -	/* Guard page? */
> +	/* unknown entry */
>  	if (!ep->size)
>  		return false;
>  
> +

Extra line?

Regards,
Michael Wang

>  	begin += (unsigned long)ep->offs;
>  	end = begin + (unsigned long)ep->size;
>  	regs = (struct pt_regs *)end - 1;
> @@ -193,6 +205,9 @@ int get_stack_info(unsigned long *stack,
>  	if (!get_stack_info_noinstr(stack, task, info))
>  		goto unknown;
>  
> +	if (info->type & STACK_TYPE_GUARD)
> +		goto unknown;
> +
>  	/*
>  	 * Make sure we don't iterate through any given stack more than once.
>  	 * If it comes up a second time then there's something wrong going on:
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -461,6 +461,19 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
>  	}
>  #endif
>  
> +#ifdef CONFIG_X86_64
> +	{
> +		struct stack_info info;
> +
> +		if (get_stack_info_noinstr((void *)address, current, &info) &&
> +		    info.type & STACK_TYPE_GUARD) {
> +			const char *name = stack_type_name(info.type & ~STACK_TYPE_GUARD);
> +			pr_emerg("BUG: %s stack guard hit at %p (stack is %p..%p)\n",
> +				 name, (void *)address, info.begin, info.end);
> +		}
> +	}
> +#endif
> +
>  	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
>  	die("double fault", regs, error_code);
>  	panic("Machine halted.");
> @@ -708,7 +721,9 @@ asmlinkage __visible noinstr struct pt_r
>  	sp    = regs->sp;
>  	stack = (unsigned long *)sp;
>  
> -	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
> +	if (!get_stack_info_noinstr(stack, current, &info) ||
> +	    info.type & STACK_TYPE_GUARD ||
> +	    info.type == STACK_TYPE_ENTRY ||
>  	    info.type >= STACK_TYPE_EXCEPTION_LAST)
>  		sp = __this_cpu_ist_top_va(VC2);
>  
> 
