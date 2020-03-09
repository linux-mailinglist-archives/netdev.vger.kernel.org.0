Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6245017E536
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 17:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgCIQ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 12:59:51 -0400
Received: from foss.arm.com ([217.140.110.172]:54762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgCIQ7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 12:59:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 020081FB;
        Mon,  9 Mar 2020 09:59:50 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1926E3F534;
        Mon,  9 Mar 2020 09:59:47 -0700 (PDT)
Date:   Mon, 9 Mar 2020 16:59:46 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH v2 06/12] task_isolation: arch/arm64: enable task
 isolation functionality
Message-ID: <20200309165945.GB44566@lakrids.cambridge.arm.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
 <b559513e03dfd09f64ace29452590ddb92c3196f.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b559513e03dfd09f64ace29452590ddb92c3196f.camel@marvell.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 03:50:58AM +0000, Alex Belits wrote:
> From: Chris Metcalf <cmetcalf@mellanox.com>
> 
> In do_notify_resume(), call task_isolation_start() for
> TIF_TASK_ISOLATION tasks. Add _TIF_TASK_ISOLATION to _TIF_WORK_MASK,
> and define a local NOTIFY_RESUME_LOOP_FLAGS to check in the loop,
> since we don't clear _TIF_TASK_ISOLATION in the loop.
> 
> We instrument the smp_send_reschedule() routine so that it checks for
> isolated tasks and generates a suitable warning if needed.
> 
> Finally, report on page faults in task-isolation processes in
> do_page_faults().
> 
> Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
> [abelits@marvell.com: simplified to match kernel 5.6]
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h |  5 ++++-
>  arch/arm64/kernel/ptrace.c           | 10 ++++++++++
>  arch/arm64/kernel/signal.c           | 13 ++++++++++++-
>  arch/arm64/kernel/smp.c              |  7 +++++++
>  arch/arm64/mm/fault.c                |  5 +++++
>  6 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 0b30e884e088..93b6aabc8be9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -129,6 +129,7 @@ config ARM64
>  	select HAVE_ARCH_PREL32_RELOCATIONS
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
> +	select HAVE_ARCH_TASK_ISOLATION
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index f0cec4160136..7563098eb5b2 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -63,6 +63,7 @@ void arch_release_task_struct(struct task_struct *tsk);
>  #define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
>  #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
>  #define TIF_FSCHECK		5	/* Check FS is USER_DS on return */
> +#define TIF_TASK_ISOLATION	6
>  #define TIF_NOHZ		7
>  #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
>  #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
> @@ -83,6 +84,7 @@ void arch_release_task_struct(struct task_struct *tsk);
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_FOREIGN_FPSTATE	(1 << TIF_FOREIGN_FPSTATE)
> +#define _TIF_TASK_ISOLATION	(1 << TIF_TASK_ISOLATION)
>  #define _TIF_NOHZ		(1 << TIF_NOHZ)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
> @@ -96,7 +98,8 @@ void arch_release_task_struct(struct task_struct *tsk);
>  
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
> -				 _TIF_UPROBE | _TIF_FSCHECK)
> +				 _TIF_UPROBE | _TIF_FSCHECK | \
> +				 _TIF_TASK_ISOLATION)
>  
>  #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
>  				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index cd6e5fa48b9c..b35b9b0c594c 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -29,6 +29,7 @@
>  #include <linux/regset.h>
>  #include <linux/tracehook.h>
>  #include <linux/elf.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/compat.h>
>  #include <asm/cpufeature.h>
> @@ -1836,6 +1837,15 @@ int syscall_trace_enter(struct pt_regs *regs)
>  			return -1;
>  	}
>  
> +	/*
> +	 * In task isolation mode, we may prevent the syscall from
> +	 * running, and if so we also deliver a signal to the process.
> +	 */
> +	if (test_thread_flag(TIF_TASK_ISOLATION)) {
> +		if (task_isolation_syscall(regs->syscallno) == -1)

Please use NO_SYSCALL rather than -1 here.

> +			return -1;
> +	}
> +
>  	/* Do the secure computing after ptrace; failures should be fast. */
>  	if (secure_computing() == -1)
>  		return -1;
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 339882db5a91..d488c91a4877 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -20,6 +20,7 @@
>  #include <linux/tracehook.h>
>  #include <linux/ratelimit.h>
>  #include <linux/syscalls.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/daifflags.h>
>  #include <asm/debug-monitors.h>
> @@ -898,6 +899,11 @@ static void do_signal(struct pt_regs *regs)
>  	restore_saved_sigmask();
>  }
>  
> +#define NOTIFY_RESUME_LOOP_FLAGS \
> +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
> +	_TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
> +	_TIF_UPROBE | _TIF_FSCHECK)
> +
>  asmlinkage void do_notify_resume(struct pt_regs *regs,
>  				 unsigned long thread_flags)
>  {
> @@ -908,6 +914,8 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
>  	 */
>  	trace_hardirqs_off();
>  
> +	task_isolation_check_run_cleanup();
> +
>  	do {
>  		/* Check valid user FS if needed */
>  		addr_limit_user_check();
> @@ -938,7 +946,10 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
>  
>  		local_daif_mask();
>  		thread_flags = READ_ONCE(current_thread_info()->flags);
> -	} while (thread_flags & _TIF_WORK_MASK);
> +	} while (thread_flags & NOTIFY_RESUME_LOOP_FLAGS);
> +
> +	if (thread_flags & _TIF_TASK_ISOLATION)
> +		task_isolation_start();
>  }
>  
>  unsigned long __ro_after_init signal_minsigstksz;
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index d4ed9a19d8fe..00f0f77adea0 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -32,6 +32,7 @@
>  #include <linux/irq_work.h>
>  #include <linux/kexec.h>
>  #include <linux/kvm_host.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/alternative.h>
>  #include <asm/atomic.h>
> @@ -818,6 +819,7 @@ void arch_send_call_function_single_ipi(int cpu)
>  #ifdef CONFIG_ARM64_ACPI_PARKING_PROTOCOL
>  void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
>  {
> +	task_isolation_remote_cpumask(mask, "wakeup IPI");
>  	smp_cross_call(mask, IPI_WAKEUP);
>  }
>  #endif
> @@ -886,6 +888,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>  		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
>  	}
>  
> +	task_isolation_interrupt("IPI type %d (%s)", ipinr,
> +				 ipinr < NR_IPI ? ipi_types[ipinr] : "unknown");

When I previously asked about tracing, I was asking about the format
strings, since we don't bother with that kind of thing elsewhere.

What exactly are these hooks used for? I assume the strings are only
there as a debugging aid?

What about other IRQs? Does we need something in the irqchip driver? 

If we need to track that /any/ interrupt was received, I think that
would be better to put in the top-level interrupt exception handler than
to sprinkle hooks into every potential handler.

> +
>  	switch (ipinr) {
>  	case IPI_RESCHEDULE:
>  		scheduler_ipi();
> @@ -948,12 +953,14 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>  
>  void smp_send_reschedule(int cpu)
>  {
> +	task_isolation_remote(cpu, "reschedule IPI");
>  	smp_cross_call(cpumask_of(cpu), IPI_RESCHEDULE);
>  }
>  
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
>  void tick_broadcast(const struct cpumask *mask)
>  {
> +	task_isolation_remote_cpumask(mask, "timer IPI");
>  	smp_cross_call(mask, IPI_TIMER);
>  }
>  #endif
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 85566d32958f..fc4b42c81c4f 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -23,6 +23,7 @@
>  #include <linux/perf_event.h>
>  #include <linux/preempt.h>
>  #include <linux/hugetlb.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/acpi.h>
>  #include <asm/bug.h>
> @@ -543,6 +544,10 @@ static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
>  	 */
>  	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
>  			      VM_FAULT_BADACCESS)))) {
> +		/* No signal was generated, but notify task-isolation tasks. */
> +		if (user_mode(regs))
> +			task_isolation_interrupt("page fault at %#lx", addr);

This isn't an interrupt. Why do we need to hook this?

What about /other/ exceptions caused by userspace?

If we need to notify userspace, it would be much more reliable to do so
in the return path.

Thanks,
Mark.

> +
>  		/*
>  		 * Major/minor page fault accounting is only done
>  		 * once. If we go through a retry, it is extremely
> -- 
> 2.20.1
> 
