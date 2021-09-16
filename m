Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA540D20D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIPDgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:36:09 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:53282 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233856AbhIPDgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:36:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UoY1VFK_1631763283;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoY1VFK_1631763283)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Sep 2021 11:34:44 +0800
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
Message-ID: <8322f202-a2e9-8cc2-78c7-f6c98f360afb@linux.alibaba.com>
Date:   Thu, 16 Sep 2021 11:34:43 +0800
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

It seems like not working properly, we get very long trace ending as below:

Regards,
Michael Wang

[   34.662432][    C0] BUG: unable to handle page fault for address: fffffe0000008ff0
[   34.662435][    C0] #PF: supervisor read access in kernel mode
[   34.662438][    C0] #PF: error_code(0x0000) - not-present page
[   34.662442][    C0] PGD 13ffef067 P4D 13ffef067 PUD 13ffed067 PMD 13ffec067 PTE 0
[   34.662455][    C0] Oops: 0000 [#11] SMP PTI
[   34.662459][    C0] CPU: 0 PID: 713 Comm: a.out Not tainted 5.14.0-next-20210913+ #530
[   34.662465][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   34.662468][    C0] RIP: 0010:get_stack_info_noinstr+0x8d/0xf0
[   34.662474][    C0] Code: 40 82 66 85 c9 74 33 8b 34 d5 40 6d 40 82 0f b7 14 d5 46 6d 40 82 48 01 f0 41 89 14 24 48 01 c1 49 89 44 24 08 49 89 4c 24 10 <48> 8b 41 f0 49 89 44 24 18 b8 01 00 00 00 eb 87 65 48 8b 05 43 c5
[   34.662485][    C0] RSP: 0018:fffffe0000009bb0 EFLAGS: 00010086
[   34.662490][    C0] RAX: fffffe0000008000 RBX: ffff888107422180 RCX: fffffe0000009000
[   34.662494][    C0] RDX: 0000000000000085 RSI: 0000000000000000 RDI: fffffe0000008f30
[   34.662498][    C0] RBP: fffffe0000008f30 R08: ffffffff82754eff R09: fffffe0000009b78
[   34.662502][    C0] R10: 0000000000000000 R11: 0000000000000006 R12: fffffe0000009c28
[   34.662506][    C0] R13: 0000000000000000 R14: ffff888107422180 R15: fffffe0000009c48
[   34.662510][    C0] FS:  00007f5298fe2740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[   34.662516][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.662520][    C0] CR2: fffffe0000008ff0 CR3: 0000000109b5a005 CR4: 00000000003606f0
[   34.662524][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   34.662528][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   34.662532][    C0] Call Trace:
[   34.662534][    C0]  <#DF>
[   34.662542][    C0]  get_stack_info+0x30/0xb0
[   34.662556][    C0]  show_trace_log_lvl+0xf9/0x410
[   34.662571][    C0]  ? sprint_symbol_build_id+0x30/0x30
[   34.662605][    C0]  ? 0xffffffffa0106083
[   34.662628][    C0]  __die_body+0x1a/0x60
[   34.662641][    C0]  page_fault_oops+0xe8/0x560
[   34.662671][    C0]  kernelmode_fixup_or_oops+0x107/0x120
[   34.662687][    C0]  __bad_area_nosemaphore+0x1b8/0x280
[   34.662707][    C0]  do_kern_addr_fault+0x57/0xc0
[   34.662719][    C0]  exc_page_fault+0x1c1/0x300
[   34.662735][    C0]  asm_exc_page_fault+0x1e/0x30
[   34.662742][    C0] RIP: 0010:get_stack_info_noinstr+0x8d/0xf0
[   34.662749][    C0] Code: 40 82 66 85 c9 74 33 8b 34 d5 40 6d 40 82 0f b7 14 d5 46 6d 40 82 48 01 f0 41 89 14 24 48 01 c1 49 89 44 24 08 49 89 4c 24 10 <48> 8b 41 f0 49 89 44 24 18 b8 01 00 00 00 eb 87 65 48 8b 05 43 c5
[   34.662754][    C0] RSP: 0018:fffffe0000009ee8 EFLAGS: 00010086
[   34.662759][    C0] RAX: fffffe0000008000 RBX: ffff888107422180 RCX: fffffe0000009000
[   34.662763][    C0] RDX: 0000000000000085 RSI: 0000000000000000 RDI: fffffe0000008f28
[   34.662767][    C0] RBP: fffffe0000008f28 R08: 0000000000000000 R09: 0000000000000000
[   34.662771][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: fffffe0000009f08
[   34.662775][    C0] R13: fffffe0000008f28 R14: 0000000109b5a005 R15: 0000000000000000
[   34.662816][    C0]  ? get_stack_info_noinstr+0x12/0xf0
[   34.662828][    C0]  exc_double_fault+0x138/0x1a0
[   34.662851][    C0]  asm_exc_double_fault+0x1e/0x30
[   34.662858][    C0] RIP: 0010:perf_ftrace_function_call+0x26/0x2e0
[   34.662866][    C0] Code: 5b 5d c3 90 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 f5 53 49 89 fc 48 89 d3 48 81 ec d0 00 00 00 65 48 8b 04 25 28 00 00 00 <48> 89 45 d0 31 c0 e8 9f 69 fa ff e8 2a 4a f1 ff 84 c0 74 14 e8 91
[   34.662872][    C0] RSP: 0018:fffffe0000008f30 EFLAGS: 00010086
[   34.662877][    C0] RAX: 0c14fdf027d1e500 RBX: ffff8881002f99f0 RCX: fffffe0000009038
[   34.662881][    C0] RDX: ffff8881002f99f0 RSI: ffffffff817cd61f RDI: ffffffff811cc7b0
[   34.662884][    C0] RBP: fffffe0000009028 R08: ffffffff82754ed9 R09: fffffe00000095d0
[   34.662888][    C0] R10: fffffe00000095e8 R11: 0000000020455450 R12: ffffffff811cc7b0
[   34.662892][    C0] R13: ffffffff817cd61f R14: ffff0a00ffffff05 R15: ffffffff81edac2d
[   34.662896][    C0]  ? get_stack_info_noinstr+0x8d/0xf0
[   34.662904][    C0]  ? symbol_string+0xbf/0x160
[   34.662911][    C0]  ? sprint_symbol_build_id+0x30/0x30
[   34.662935][    C0]  ? symbol_string+0xbf/0x160
[   34.662942][    C0]  ? sprint_symbol_build_id+0x30/0x30
[   34.662959][    C0]  </#DF>
[   34.662964][    C0] BUG: unable to handle page fault for address: fffffe0000008ff0
[   34.662966][    C0] #PF: supervisor read access in kernel mode
[   34.662970][    C0] #PF: error_code(0x0000) - not-present page
[   34.662973][    C0] PGD 13ffef067 P4D 13ffef067 PUD 13ffed067 PMD 13ffec067 PTE 0
[   34.662986][    C0] Oops: 0000 [#12] SMP PTI
[   34.662991][    C0] CPU: 0 PID: 713 Comm: a.out Not tainted 5.14.0-next-20210913+ #530
[   34.662996][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011


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
