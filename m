Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE191B4401
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgDVMIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:08:18 -0400
Received: from foss.arm.com ([217.140.110.172]:48626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgDVMIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:08:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A2C131B;
        Wed, 22 Apr 2020 05:08:16 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 983793F6CF;
        Wed, 22 Apr 2020 05:08:14 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:08:12 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 07/13] task_isolation: arch/arm64: enable task
 isolation functionality
Message-ID: <20200422120811.GA3585@gaia>
References: <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
 <299c02b268a6438704693ddb77cdcb49f382c0ea.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <299c02b268a6438704693ddb77cdcb49f382c0ea.camel@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 03:23:35PM +0000, Alex Belits wrote:
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
> +			return -1;
> +	}

Is this supposed to be called only when syscall tracing is enabled?
It only gets here if the task has any of the _TIF_SYSCALL_WORK flags.

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

AFAICT, that's just _TIF_WORK_MASK without _TIF_TASK_ISOLATION. I'd
rather not duplicate these, they are prone to get out of sync. You could
do something like:

#define NOTIFY_RESUME_LOOP_FLAGS (_TIF_WORK_MASK & ~_TIF_TASK_ISOLATION)

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

-- 
Catalin
