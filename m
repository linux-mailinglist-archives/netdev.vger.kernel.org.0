Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46943410301
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhIRCcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:32:11 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:60009 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231364AbhIRCcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:32:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UojvAV3_1631932242;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UojvAV3_1631932242)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 10:30:43 +0800
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
Message-ID: <89f8281f-b778-5bf5-13e0-2bda613d963c@linux.alibaba.com>
Date:   Sat, 18 Sep 2021 10:30:42 +0800
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
> On Fri, Sep 17, 2021 at 12:21:24PM +0200, Peter Zijlstra wrote:
>> On Fri, Sep 17, 2021 at 11:02:07AM +0800, 王贇 wrote:
>>>
>>>
>>> On 2021/9/16 下午6:02, Peter Zijlstra wrote:
>>> [snip]
>>>>  
>>>> +static __always_inline bool in_stack_guard(void *addr, void *begin, void *end)
>>>> +{
>>>> +#ifdef CONFIG_VMAP_STACK
>>>> +	if (addr > (begin - PAGE_SIZE))
>>>> +		return true;
>>>
>>> After fix this logical as:
>>>
>>>   addr >= (begin - PAGE_SIZE) && addr < begin
>>>
>>> it's working.
>>
>> Shees, I seem to have a knack for getting it wrong, don't I. Thanks!
>>
>> Anyway, I'll ammend the commit locally, but I'd really like some
>> feedback from Andy, who wrote all that VIRT_STACK stuff in the first
>> place.
> 
> Andy suggested something like this.

Now it seem like working well :-)

[  193.100475][    C0] BUG: NMI stack guard page was hit at 0000000085fd977b (stack is 000000003a55b09e..00000000d8cce1a5)
[  193.100493][    C0] stack guard page: 0000 [#1] SMP PTI
[  193.100499][    C0] CPU: 0 PID: 968 Comm: a.out Not tainted 5.14.0-next-20210913+ #548
[  193.100506][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  193.100510][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
[  193.100523][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
[  193.100529][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
[  193.100535][    C0] RAX: 0000000080120006 RBX: fffffe000000b050 RCX: 0000000000000000
[  193.100540][    C0] RDX: ffff88810de82180 RSI: ffffffff81269031 RDI: 000000000000001c
[  193.100544][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
[  193.100548][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  193.100551][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000009
[  193.100556][    C0] FS:  00007fa18c42d740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[  193.100562][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  193.100566][    C0] CR2: fffffe000000aff8 CR3: 00000001160ac005 CR4: 00000000003606f0
[  193.100570][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  193.100574][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  193.100578][    C0] Call Trace:
[  193.100581][    C0]  <NMI>
[  193.100584][    C0]  perf_trace_buf_alloc+0x26/0xd0
[  193.100597][    C0]  ? is_prefetch.isra.25+0x260/0x260
[  193.100605][    C0]  ? __bad_area_nosemaphore+0x1b8/0x280
[  193.100611][    C0]  perf_ftrace_function_call+0x18f/0x2e0


Tested-by: Michael Wang <yun.wang@linux.alibaba.com>

BTW, would you like to apply the other patch which increasing exception
stack size after this one?

Regards,
Michael Wang


> 
> ---
> diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
> index 562854c60808..9a2e37a7304d 100644
> --- a/arch/x86/include/asm/irq_stack.h
> +++ b/arch/x86/include/asm/irq_stack.h
> @@ -77,11 +77,11 @@
>   *     Function calls can clobber anything except the callee-saved
>   *     registers. Tell the compiler.
>   */
> -#define call_on_irqstack(func, asm_call, argconstr...)			\
> +#define call_on_stack(stack, func, asm_call, argconstr...)		\
>  {									\
>  	register void *tos asm("r11");					\
>  									\
> -	tos = ((void *)__this_cpu_read(hardirq_stack_ptr));		\
> +	tos = ((void *)(stack));					\
>  									\
>  	asm_inline volatile(						\
>  	"movq	%%rsp, (%[tos])				\n"		\
> @@ -98,6 +98,25 @@
>  	);								\
>  }
>  
> +#define ASM_CALL_ARG0							\
> +	"call %P[__func]				\n"
> +
> +#define ASM_CALL_ARG1							\
> +	"movq	%[arg1], %%rdi				\n"		\
> +	ASM_CALL_ARG0
> +
> +#define ASM_CALL_ARG2							\
> +	"movq	%[arg2], %%rsi				\n"		\
> +	ASM_CALL_ARG1
> +
> +#define ASM_CALL_ARG3							\
> +	"movq	%[arg3], %%rdx				\n"		\
> +	ASM_CALL_ARG2
> +
> +#define call_on_irqstack(func, asm_call, argconstr...)			\
> +	call_on_stack(__this_cpu_read(hardirq_stack_ptr),		\
> +		      func, asm_call, argconstr)
> +
>  /* Macros to assert type correctness for run_*_on_irqstack macros */
>  #define assert_function_type(func, proto)				\
>  	static_assert(__builtin_types_compatible_p(typeof(&func), proto))
> @@ -147,8 +166,7 @@
>   */
>  #define ASM_CALL_SYSVEC							\
>  	"call irq_enter_rcu				\n"		\
> -	"movq	%[arg1], %%rdi				\n"		\
> -	"call %P[__func]				\n"		\
> +	ASM_CALL_ARG1							\
>  	"call irq_exit_rcu				\n"
>  
>  #define SYSVEC_CONSTRAINTS	, [arg1] "r" (regs)
> @@ -168,12 +186,10 @@
>   */
>  #define ASM_CALL_IRQ							\
>  	"call irq_enter_rcu				\n"		\
> -	"movq	%[arg1], %%rdi				\n"		\
> -	"movl	%[arg2], %%esi				\n"		\
> -	"call %P[__func]				\n"		\
> +	ASM_CALL_ARG2							\
>  	"call irq_exit_rcu				\n"
>  
> -#define IRQ_CONSTRAINTS	, [arg1] "r" (regs), [arg2] "r" (vector)
> +#define IRQ_CONSTRAINTS	, [arg1] "r" (regs), [arg2] "r" ((long)vector)
>  
>  #define run_irq_on_irqstack_cond(func, regs, vector)			\
>  {									\
> @@ -185,9 +201,6 @@
>  			      IRQ_CONSTRAINTS, regs, vector);		\
>  }
>  
> -#define ASM_CALL_SOFTIRQ						\
> -	"call %P[__func]				\n"
> -
>  /*
>   * Macro to invoke __do_softirq on the irq stack. This is only called from
>   * task context when bottom halves are about to be reenabled and soft
> @@ -197,7 +210,7 @@
>  #define do_softirq_own_stack()						\
>  {									\
>  	__this_cpu_write(hardirq_stack_inuse, true);			\
> -	call_on_irqstack(__do_softirq, ASM_CALL_SOFTIRQ);		\
> +	call_on_irqstack(__do_softirq, ASM_CALL_ARG0);			\
>  	__this_cpu_write(hardirq_stack_inuse, false);			\
>  }
>  
> diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
> index f248eb2ac2d4..17a52793f6c3 100644
> --- a/arch/x86/include/asm/stacktrace.h
> +++ b/arch/x86/include/asm/stacktrace.h
> @@ -38,6 +38,16 @@ int get_stack_info(unsigned long *stack, struct task_struct *task,
>  bool get_stack_info_noinstr(unsigned long *stack, struct task_struct *task,
>  			    struct stack_info *info);
>  
> +static __always_inline
> +bool get_stack_guard_info(unsigned long *stack, struct stack_info *info)
> +{
> +	/* make sure it's not in the stack proper */
> +	if (get_stack_info_noinstr(stack, current, info))
> +		return false;
> +	/* but if it is in the page below it, we hit a guard */
> +	return get_stack_info_noinstr((void *)stack + PAGE_SIZE-1, current, info);
> +}
> +
>  const char *stack_type_name(enum stack_type type);
>  
>  static inline bool on_stack(struct stack_info *info, void *addr, size_t len)
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 7f7200021bd1..6221be7cafc3 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -40,9 +40,9 @@ void math_emulate(struct math_emu_info *);
>  bool fault_in_kernel_space(unsigned long address);
>  
>  #ifdef CONFIG_VMAP_STACK
> -void __noreturn handle_stack_overflow(const char *message,
> -				      struct pt_regs *regs,
> -				      unsigned long fault_address);
> +void __noreturn handle_stack_overflow(struct pt_regs *regs,
> +				      unsigned long fault_address,
> +				      struct stack_info *info);
>  #endif
>  
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 5601b95944fa..6c5defd6569a 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -32,9 +32,15 @@ const char *stack_type_name(enum stack_type type)
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
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index a58800973aed..77857d41289d 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -313,17 +313,19 @@ DEFINE_IDTENTRY_ERRORCODE(exc_alignment_check)
>  }
>  
>  #ifdef CONFIG_VMAP_STACK
> -__visible void __noreturn handle_stack_overflow(const char *message,
> -						struct pt_regs *regs,
> -						unsigned long fault_address)
> +__visible void __noreturn handle_stack_overflow(struct pt_regs *regs,
> +						unsigned long fault_address,
> +						struct stack_info *info)
>  {
> -	printk(KERN_EMERG "BUG: stack guard page was hit at %p (stack is %p..%p)\n",
> -		 (void *)fault_address, current->stack,
> -		 (char *)current->stack + THREAD_SIZE - 1);
> -	die(message, regs, 0);
> +	const char *name = stack_type_name(info->type);
> +
> +	printk(KERN_EMERG "BUG: %s stack guard page was hit at %p (stack is %p..%p)\n",
> +	       name, (void *)fault_address, info->begin, info->end);
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
