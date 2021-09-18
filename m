Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73F5410309
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhIRCji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:39:38 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38281 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232471AbhIRCjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:39:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0Uoje9Dt_1631932689;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Uoje9Dt_1631932689)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 10:38:11 +0800
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
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
 <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
 <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
 <a11f43d2-f12e-18c2-65d4-debd8d085fa8@linux.alibaba.com>
 <YURsJGaB0vKgPT8x@hirez.programming.kicks-ass.net>
 <YUTE/NuqnaWbST8n@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <50ccb496-0bbd-bdfe-1180-fb0a9d7fd87e@linux.alibaba.com>
Date:   Sat, 18 Sep 2021 10:38:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUTE/NuqnaWbST8n@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/18 上午12:40, Peter Zijlstra wrote:
[snip]
> -	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
> -		 (void *)fault_address, current->stack,
> -		 (char *)current->stack + THREAD_SIZE - 1);
> -	die(message, regs, 0);
> +	const char *name = stack_type_name(info->type);
> +
> +	printk(KERN_EMERG "BUG: %s stack guard page was hit at %p (stack is %p..%p)\n",
> +	       name, (void *)fault_address, info->begin, info->end);

Just found that the printed pointer address is not correct:
  BUG: NMI stack guard page was hit at 0000000085fd977b (stack is 000000003a55b09e..00000000d8cce1a5)

Maybe we could use %px instead?

Regards,
Michael Wang

> +
> +	die("stack guard page", regs, 0);
>  
>  	/* Be absolutely certain we don't return. */
> -	panic("%s", message);
> +	panic("%s stack guard hit", name);
>  }
>  #endif
>  
> @@ -353,6 +355,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
>  
>  #ifdef CONFIG_VMAP_STACK
>  	unsigned long address = read_cr2();
> +	struct stack_info info;
>  #endif
>  
>  #ifdef CONFIG_X86_ESPFIX64
> @@ -455,10 +458,8 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
>  	 * stack even if the actual trigger for the double fault was
>  	 * something else.
>  	 */
> -	if ((unsigned long)task_stack_page(tsk) - 1 - address < PAGE_SIZE) {
> -		handle_stack_overflow("kernel stack overflow (double-fault)",
> -				      regs, address);
> -	}
> +	if (get_stack_guard_info((void *)address, &info))
> +		handle_stack_overflow(regs, address, &info);
>  #endif
>  
>  	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index b2eefdefc108..edb5152f0866 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -32,6 +32,7 @@
>  #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
>  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
>  #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
> +#include <asm/irq_stack.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -631,6 +632,9 @@ static noinline void
>  page_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  		unsigned long address)
>  {
> +#ifdef CONFIG_VMAP_STACK
> +	struct stack_info info;
> +#endif
>  	unsigned long flags;
>  	int sig;
>  
> @@ -649,9 +653,7 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  	 * that we're in vmalloc space to avoid this.
>  	 */
>  	if (is_vmalloc_addr((void *)address) &&
> -	    (((unsigned long)current->stack - 1 - address < PAGE_SIZE) ||
> -	     address - ((unsigned long)current->stack + THREAD_SIZE) < PAGE_SIZE)) {
> -		unsigned long stack = __this_cpu_ist_top_va(DF) - sizeof(void *);
> +	    get_stack_guard_info((void *)address, &info)) {
>  		/*
>  		 * We're likely to be running with very little stack space
>  		 * left.  It's plausible that we'd hit this condition but
> @@ -662,13 +664,11 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  		 * and then double-fault, though, because we're likely to
>  		 * break the console driver and lose most of the stack dump.
>  		 */
> -		asm volatile ("movq %[stack], %%rsp\n\t"
> -			      "call handle_stack_overflow\n\t"
> -			      "1: jmp 1b"
> -			      : ASM_CALL_CONSTRAINT
> -			      : "D" ("kernel stack overflow (page fault)"),
> -				"S" (regs), "d" (address),
> -				[stack] "rm" (stack));
> +		call_on_stack(__this_cpu_ist_top_va(DF) - sizeof(void*),
> +			      handle_stack_overflow,
> +			      ASM_CALL_ARG3,
> +			      , [arg1] "r" (regs), [arg2] "r" (address), [arg3] "r" (&info));
> +
>  		unreachable();
>  	}
>  #endif
> 
