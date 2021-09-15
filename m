Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B940BD69
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 03:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhIOBxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 21:53:19 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:34217 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhIOBxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 21:53:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UoQhdYh_1631670717;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoQhdYh_1631670717)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 09:51:58 +0800
Subject: Re: [RFC PATCH] perf: fix panic by mark recursion inside
 perf_log_throttle
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
        <bpf@vger.kernel.org>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
Date:   Wed, 15 Sep 2021 09:51:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/14 下午6:28, Peter Zijlstra wrote:
[snip]
> 
> You can simply increase the exception stack size to test this:
> 
> diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
> index a8d4ad856568..e9e2c3ba5923 100644
> --- a/arch/x86/include/asm/page_64_types.h
> +++ b/arch/x86/include/asm/page_64_types.h
> @@ -15,7 +15,7 @@
>  #define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
>  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
>  
> -#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
> +#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
>  #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
>  
>  #define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)

It's working in this case, no more panic.

> 
> 
> 
> Also, something like this might be useful:
> 
> 
> diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
> index f248eb2ac2d4..4dfdbb9395eb 100644
> --- a/arch/x86/include/asm/stacktrace.h
> +++ b/arch/x86/include/asm/stacktrace.h
> @@ -33,6 +33,8 @@ bool in_task_stack(unsigned long *stack, struct task_struct *task,
>  
>  bool in_entry_stack(unsigned long *stack, struct stack_info *info);
>  
> +bool in_exception_stack_guard(unsigned long *stack);
> +
>  int get_stack_info(unsigned long *stack, struct task_struct *task,
>  		   struct stack_info *info, unsigned long *visit_mask);
>  bool get_stack_info_noinstr(unsigned long *stack, struct task_struct *task,
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 5601b95944fa..056cf4f31599 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -126,6 +126,39 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
>  	return true;
>  }
>  
> +noinstr bool in_exception_stack_guard(unsigned long *stack)
> +{
> +	unsigned long begin, end, stk = (unsigned long)stack;
> +	const struct estack_pages *ep;
> +	unsigned int k;
> +
> +	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
> +
> +	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
> +	/*
> +	 * Handle the case where stack trace is collected _before_
> +	 * cea_exception_stacks had been initialized.
> +	 */
> +	if (!begin)
> +		return false;
> +
> +	end = begin + sizeof(struct cea_exception_stacks);
> +	/* Bail if @stack is outside the exception stack area. */
> +	if (stk < begin || stk >= end)
> +		return false;
> +
> +	/* Calc page offset from start of exception stacks */
> +	k = (stk - begin) >> PAGE_SHIFT;
> +	/* Lookup the page descriptor */
> +	ep = &estack_pages[k];
> +	/* Guard page? */
> +	if (!ep->size)
> +		return true;
> +
> +	return false;
> +}
> +
> +
>  static __always_inline bool in_irq_stack(unsigned long *stack, struct stack_info *info)
>  {
>  	unsigned long *end = (unsigned long *)this_cpu_read(hardirq_stack_ptr);
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index a58800973aed..8b043ed02c0d 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -459,6 +459,9 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
>  		handle_stack_overflow("kernel stack overflow (double-fault)",
>  				      regs, address);
>  	}
> +
> +	if (in_exception_stack_guard((void *)address))
> +		pr_emerg("PANIC: exception stack guard: 0x%lx\n", address);
>  #endif
>  
>  	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
> 

The panic triggered as below after the stack size recovered, I found this info
could be helpful, maybe we should keep it?

Regards,
Michael Wang

[   30.515200][    C0] traps: PANIC: exception stack guard: 0xfffffe000000aff8
[   30.515206][    C0] traps: PANIC: double fault, error_code: 0x0
[   30.515216][    C0] double fault: 0000 [#1] SMP PTI
[   30.515223][    C0] CPU: 0 PID: 702 Comm: a.out Not tainted 5.14.0-next-20210913+ #524
[   30.515230][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   30.515233][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
[   30.515246][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
[   30.515253][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
[   30.515259][    C0] RAX: 0000000080120008 RBX: fffffe000000b050 RCX: 0000000000000000
[   30.515264][    C0] RDX: ffff88810cbf2180 RSI: ffffffff81269031 RDI: 000000000000001c
[   30.515268][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
[   30.515272][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   30.515275][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000001
[   30.515280][    C0] FS:  00007fa1b01f4740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[   30.515286][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.515290][    C0] CR2: fffffe000000aff8 CR3: 000000010e26a003 CR4: 00000000003606f0
[   30.515294][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   30.515298][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   30.515302][    C0] Call Trace:
[   30.515305][    C0]  <NMI>
[   30.515308][    C0]  perf_trace_buf_alloc+0x26/0xd0
[   30.515321][    C0]  ? is_prefetch.isra.25+0x260/0x260
[   30.515329][    C0]  ? __bad_area_nosemaphore+0x1b8/0x280
[   30.515336][    C0]  perf_ftrace_function_call+0x18f/0x2e0
[   30.515347][    C0]  ? perf_trace_buf_alloc+0xbf/0xd0
[   30.515385][    C0]  ? 0xffffffffa0106083
[   30.515412][    C0]  0xffffffffa0106083
[   30.515431][    C0]  ? 0xffffffffa0106083
[   30.515452][    C0]  ? kernelmode_fixup_or_oops+0x5/0x120
[   30.515465][    C0]  kernelmode_fixup_or_oops+0x5/0x120
[   30.515472][    C0]  __bad_area_nosemaphore+0x1b8/0x280
[   30.515492][    C0]  do_user_addr_fault+0x410/0x920
[   30.515508][    C0]  ? 0xffffffffa0106083
[   30.515525][    C0]  exc_page_fault+0x92/0x300
[   30.515542][    C0]  asm_exc_page_fault+0x1e/0x30
[   30.515551][    C0] RIP: 0010:__get_user_nocheck_8+0x6/0x13

