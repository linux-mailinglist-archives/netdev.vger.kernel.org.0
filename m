Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64F19EFE6
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 06:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgDFEcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 00:32:14 -0400
Received: from mout02.posteo.de ([185.67.36.66]:43131 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgDFEcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 00:32:14 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id B6C06240100
        for <netdev@vger.kernel.org>; Mon,  6 Apr 2020 06:32:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1586147525; bh=cK319W5AuajClIwEnOcTFdZH3bJKf3Pa1oL4sJ7+Mvc=;
        h=Date:From:To:Cc:Subject:From;
        b=Bk7hBlnf9wfyzmKqybBEpELFtQ1TtZ2j80u+LreOacgt9p26YBhMLGnTddlN3CWFP
         XEKiheqm0WZZlwg3RDw/xaM8hNiqWSdegdOgvF5cP1UUIFmofPF6Uch/mv/qxYOqnm
         Inw8wHS8TJOmvqPxgfyAPTvo0OBm+Y7IRvju/kRBWI72p4W8cpwy6sG+ZVSCOLWHA/
         eonCnv6L1SkutgJJnryJdWQhIPyeRBYOd3RfgzVxqeFHGoGFC74BNOYdlCmuZ91ht0
         OPR5scNLGJOjLowdO7x2/gigW3bmpN0fAB7O1Nq2oaglJCJdwxC1v9P9QIGG7pEcgW
         JsdThHsLTlWYA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 48wd0w3vTZz9rxL;
        Mon,  6 Apr 2020 06:32:00 +0200 (CEST)
Date:   Mon, 6 Apr 2020 00:31:57 -0400
From:   Kevyn-Alexandre =?utf-8?B?UGFyw6k=?= <kapare@posteo.net>
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
Subject: Re: [PATCH v2 03/12] task_isolation: userspace hard isolation from
 kernel
Message-ID: <20200406043157.x4bovr6qxcs3gw5c@x1>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
 <105f17f25e90a9a58299a7ed644bdd0f36434c87.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105f17f25e90a9a58299a7ed644bdd0f36434c87.camel@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 03:47:08AM +0000, Alex Belits wrote:
> The existing nohz_full mode is designed as a "soft" isolation mode
> that makes tradeoffs to minimize userspace interruptions while
> still attempting to avoid overheads in the kernel entry/exit path,
> to provide 100% kernel semantics, etc.
> 
> However, some applications require a "hard" commitment from the
> kernel to avoid interruptions, in particular userspace device driver
> style applications, such as high-speed networking code.
> 
> This change introduces a framework to allow applications
> to elect to have the "hard" semantics as needed, specifying
> prctl(PR_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) to do so.
> 
> The kernel must be built with the new TASK_ISOLATION Kconfig flag
> to enable this mode, and the kernel booted with an appropriate
> "isolcpus=nohz,domain,CPULIST" boot argument to enable
> nohz_full and isolcpus. The "task_isolation" state is then indicated
> by setting a new task struct field, task_isolation_flag, to the
> value passed by prctl(), and also setting a TIF_TASK_ISOLATION
> bit in the thread_info flags. When the kernel is returning to
> userspace from the prctl() call and sees TIF_TASK_ISOLATION set,
> it calls the new task_isolation_start() routine to arrange for
> the task to avoid being interrupted in the future.
> 
> With interrupts disabled, task_isolation_start() ensures that kernel
> subsystems that might cause a future interrupt are quiesced. If it
> doesn't succeed, it adjusts the syscall return value to indicate that
> fact, and userspace can retry as desired. In addition to stopping
> the scheduler tick, the code takes any actions that might avoid
> a future interrupt to the core, such as a worker thread being
> scheduled that could be quiesced now (e.g. the vmstat worker)
> or a future IPI to the core to clean up some state that could be
> cleaned up now (e.g. the mm lru per-cpu cache).
> 
> Once the task has returned to userspace after issuing the prctl(),
> if it enters the kernel again via system call, page fault, or any
> other exception or irq, the kernel will kill it with SIGKILL.
> In addition to sending a signal, the code supports a kernel
> command-line "task_isolation_debug" flag which causes a stack
> backtrace to be generated whenever a task loses isolation.
> 
> To allow the state to be entered and exited, the syscall checking
> test ignores the prctl(PR_TASK_ISOLATION) syscall so that we can
> clear the bit again later, and ignores exit/exit_group to allow
> exiting the task without a pointless signal being delivered.
> 
> The prctl() API allows for specifying a signal number to use instead
> of the default SIGKILL, to allow for catching the notification
> signal; for example, in a production environment, it might be
> helpful to log information to the application logging mechanism
> before exiting. Or, the signal handler might choose to reset the
> program counter back to the code segment intended to be run isolated
> via prctl() to continue execution.
> 
> In a number of cases we can tell on a remote cpu that we are
> going to be interrupting the cpu, e.g. via an IPI or a TLB flush.
> In that case we generate the diagnostic (and optional stack dump)
> on the remote core to be able to deliver better diagnostics.
> If the interrupt is not something caught by Linux (e.g. a
> hypervisor interrupt) we can also request a reschedule IPI to
> be sent to the remote core so it can be sure to generate a
> signal to notify the process.
> 
> Separate patches that follow provide these changes for x86, arm,
> and arm64.
> 
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |   6 +
>  include/linux/hrtimer.h                       |   4 +
>  include/linux/isolation.h                     | 229 ++++++
>  include/linux/sched.h                         |   4 +
>  include/linux/tick.h                          |   3 +
>  include/uapi/linux/prctl.h                    |   6 +
>  init/Kconfig                                  |  28 +
>  kernel/Makefile                               |   2 +
>  kernel/context_tracking.c                     |   2 +
>  kernel/isolation.c                            | 774 ++++++++++++++++++
>  kernel/signal.c                               |   2 +
>  kernel/sys.c                                  |   6 +
>  kernel/time/hrtimer.c                         |  27 +
>  kernel/time/tick-sched.c                      |  18 +
>  14 files changed, 1111 insertions(+)
>  create mode 100644 include/linux/isolation.h
>  create mode 100644 kernel/isolation.c
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index c07815d230bc..e4a2d6e37645 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4808,6 +4808,12 @@
>  			neutralize any effect of /proc/sys/kernel/sysrq.
>  			Useful for debugging.
>  
> +	task_isolation_debug	[KNL]
> +			In kernels built with CONFIG_TASK_ISOLATION, this
> +			setting will generate console backtraces to
> +			accompany the diagnostics generated about
> +			interrupting tasks running with task isolation.
> +
>  	tcpmhash_entries= [KNL,NET]
>  			Set the number of tcp_metrics_hash slots.
>  			Default value is 8192 or 16384 depending on total
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index 15c8ac313678..e81252eb4f92 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -528,6 +528,10 @@ extern void __init hrtimers_init(void);
>  /* Show pending timers: */
>  extern void sysrq_timer_list_show(void);
>  
> +#ifdef CONFIG_TASK_ISOLATION
> +extern void kick_hrtimer(void);
> +#endif
> +
>  int hrtimers_prepare_cpu(unsigned int cpu);
>  #ifdef CONFIG_HOTPLUG_CPU
>  int hrtimers_dead_cpu(unsigned int cpu);
> diff --git a/include/linux/isolation.h b/include/linux/isolation.h
> new file mode 100644
> index 000000000000..6bd71c67f10f
> --- /dev/null
> +++ b/include/linux/isolation.h
> @@ -0,0 +1,229 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Task isolation support
> + *
> + * Authors:
> + *   Chris Metcalf <cmetcalf@mellanox.com>
> + *   Alex Belits <abelits@marvell.com>
> + *   Yuri Norov <ynorov@marvell.com>
> + */
> +#ifndef _LINUX_ISOLATION_H
> +#define _LINUX_ISOLATION_H
> +
> +#include <stdarg.h>
> +#include <linux/errno.h>
> +#include <linux/cpumask.h>
> +#include <linux/prctl.h>
> +#include <linux/types.h>
> +
> +struct task_struct;
> +
> +#ifdef CONFIG_TASK_ISOLATION
> +
> +int task_isolation_message(int cpu, int level, bool supp, const char *fmt, ...);
> +
> +#define pr_task_isol_emerg(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_EMERG, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_alert(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_ALERT, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_crit(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_CRIT, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_err(cpu, fmt, ...)				\
> +	task_isolation_message(cpu, LOGLEVEL_ERR, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_warn(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_WARNING, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_notice(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_NOTICE, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_info(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_INFO, false, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_debug(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_DEBUG, false, fmt, ##__VA_ARGS__)
> +
> +#define pr_task_isol_emerg_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_EMERG, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_alert_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_ALERT, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_crit_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_CRIT, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_err_supp(cpu, fmt, ...)				\
> +	task_isolation_message(cpu, LOGLEVEL_ERR, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_warn_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_WARNING, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_notice_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_NOTICE, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_info_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_INFO, true, fmt, ##__VA_ARGS__)
> +#define pr_task_isol_debug_supp(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_DEBUG, true, fmt, ##__VA_ARGS__)
> +DECLARE_PER_CPU(unsigned long, tsk_thread_flags_copy);

gcc output:

In file included from ./arch/x86/include/asm/apic.h:6,
                 from arch/x86/kernel/apic/apic_noop.c:14:
./include/linux/isolation.h:58:32: error: unknown type name 'tsk_thread_flags_copy'
 DECLARE_PER_CPU(unsigned long, tsk_thread_flags_copy);
                                ^~~~~~~~~~~~~~~~~~~~~

My fix:

iff --git a/include/linux/isolation.h b/include/linux/isolation.h
index 6bd71c67f10f..a392abed304b 100644
--- a/include/linux/isolation.h
+++ b/include/linux/isolation.h
@@ -55,7 +55,7 @@ int task_isolation_message(int cpu, int level, bool supp, const char *fmt, ...);
        task_isolation_message(cpu, LOGLEVEL_INFO, true, fmt, ##__VA_ARGS__)
 #define pr_task_isol_debug_supp(cpu, fmt, ...)                 \
        task_isolation_message(cpu, LOGLEVEL_DEBUG, true, fmt, ##__VA_ARGS__)
-DECLARE_PER_CPU(unsigned long, tsk_thread_flags_copy);
+//DECLARE_PER_CPU(unsigned long, tsk_thread_flags_copy);
 extern cpumask_var_t task_isolation_map;
 
 /**

> +extern cpumask_var_t task_isolation_map;
> +
> +/**
> + * task_isolation_request() - prctl hook to request task isolation
> + * @flags:	Flags from <linux/prctl.h> PR_TASK_ISOLATION_xxx.
> + *
> + * This is called from the generic prctl() code for PR_TASK_ISOLATION.
> + *
> + * Return: Returns 0 when task isolation enabled, otherwise a negative
> + * errno.
> + */
> +extern int task_isolation_request(unsigned int flags);
> +extern void task_isolation_cpu_cleanup(void);
> +/**
> + * task_isolation_start() - attempt to actually start task isolation
> + *
> + * This function should be invoked as the last thing prior to returning to
> + * user space if TIF_TASK_ISOLATION is set in the thread_info flags.  It
> + * will attempt to quiesce the core and enter task-isolation mode.  If it
> + * fails, it will reset the system call return value to an error code that
> + * indicates the failure mode.
> + */
> +extern void task_isolation_start(void);
> +
> +/**
> + * is_isolation_cpu() - check if CPU is intended for running isolated tasks.
> + * @cpu:	CPU to check.
> + */
> +static inline bool is_isolation_cpu(int cpu)
> +{
> +	return task_isolation_map != NULL &&
> +		cpumask_test_cpu(cpu, task_isolation_map);
> +}
> +
> +/**
> + * task_isolation_on_cpu() - check if the cpu is running isolated task
> + * @cpu:	CPU to check.
> + */
> +extern int task_isolation_on_cpu(int cpu);
> +extern void task_isolation_check_run_cleanup(void);
> +
> +/**
> + * task_isolation_cpumask() - set CPUs currently running isolated tasks
> + * @mask:	Mask to modify.
> + */
> +extern void task_isolation_cpumask(struct cpumask *mask);
> +
> +/**
> + * task_isolation_clear_cpumask() - clear CPUs currently running isolated tasks
> + * @mask:      Mask to modify.
> + */
> +extern void task_isolation_clear_cpumask(struct cpumask *mask);
> +
> +/**
> + * task_isolation_syscall() - report a syscall from an isolated task
> + * @nr:		The syscall number.
> + *
> + * This routine should be invoked at syscall entry if TIF_TASK_ISOLATION is
> + * set in the thread_info flags.  It checks for valid syscalls,
> + * specifically prctl() with PR_TASK_ISOLATION, exit(), and exit_group().
> + * For any other syscall it will raise a signal and return failure.
> + *
> + * Return: 0 for acceptable syscalls, -1 for all others.
> + */
> +extern int task_isolation_syscall(int nr);
> +
> +/**
> + * _task_isolation_interrupt() - report an interrupt of an isolated task
> + * @fmt:	A format string describing the interrupt
> + * @...:	Format arguments, if any.
> + *
> + * This routine should be invoked at any exception or IRQ if
> + * TIF_TASK_ISOLATION is set in the thread_info flags.  It is not necessary
> + * to invoke it if the exception will generate a signal anyway (e.g. a bad
> + * page fault), and in that case it is preferable not to invoke it but just
> + * rely on the standard Linux signal.  The macro task_isolation_syscall()
> + * wraps the TIF_TASK_ISOLATION flag test to simplify the caller code.
> + */
> +extern void _task_isolation_interrupt(const char *fmt, ...);
> +#define task_isolation_interrupt(fmt, ...)				\
> +	do {								\
> +		if (current_thread_info()->flags & _TIF_TASK_ISOLATION)	\
> +			_task_isolation_interrupt(fmt, ## __VA_ARGS__);	\
> +	} while (0)
> +
> +/**
> + * task_isolation_remote() - report a remote interrupt of an isolated task
> + * @cpu:	The remote cpu that is about to be interrupted.
> + * @fmt:	A format string describing the interrupt
> + * @...:	Format arguments, if any.
> + *
> + * This routine should be invoked any time a remote IPI or other type of
> + * interrupt is being delivered to another cpu. The function will check to
> + * see if the target core is running a task-isolation task, and generate a
> + * diagnostic on the console if so; in addition, we tag the task so it
> + * doesn't generate another diagnostic when the interrupt actually arrives.
> + * Generating a diagnostic remotely yields a clearer indication of what
> + * happened then just reporting only when the remote core is interrupted.
> + *
> + */
> +extern void task_isolation_remote(int cpu, const char *fmt, ...);
> +
> +/**
> + * task_isolation_remote_cpumask() - report interruption of multiple cpus
> + * @mask:	The set of remotes cpus that are about to be interrupted.
> + * @fmt:	A format string describing the interrupt
> + * @...:	Format arguments, if any.
> + *
> + * This is the cpumask variant of _task_isolation_remote().  We
> + * generate a single-line diagnostic message even if multiple remote
> + * task-isolation cpus are being interrupted.
> + */
> +extern void task_isolation_remote_cpumask(const struct cpumask *mask,
> +					  const char *fmt, ...);
> +
> +/**
> + * _task_isolation_signal() - disable task isolation when signal is pending
> + * @task:	The task for which to disable isolation.
> + *
> + * This function generates a diagnostic and disables task isolation; it
> + * should be called if TIF_TASK_ISOLATION is set when notifying a task of a
> + * pending signal.  The task_isolation_interrupt() function normally
> + * generates a diagnostic for events that just interrupt a task without
> + * generating a signal; here we need to hook the paths that correspond to
> + * interrupts that do generate a signal.  The macro task_isolation_signal()
> + * wraps the TIF_TASK_ISOLATION flag test to simplify the caller code.
> + */
> +extern void _task_isolation_signal(struct task_struct *task);
> +#define task_isolation_signal(task)					\
> +	do {								\
> +		if (task_thread_info(task)->flags & _TIF_TASK_ISOLATION) \
> +			_task_isolation_signal(task);			\
> +	} while (0)
> +
> +/**
> + * task_isolation_user_exit() - debug all user_exit calls
> + *
> + * By default, we don't generate an exception in the low-level user_exit()
> + * code, because programs lose the ability to disable task isolation: the
> + * user_exit() hook will cause a signal prior to task_isolation_syscall()
> + * disabling task isolation.  In addition, it means that we lose all the
> + * diagnostic info otherwise available from task_isolation_interrupt() hooks
> + * later in the interrupt-handling process.  But you may enable it here for
> + * a special kernel build if you are having undiagnosed userspace jitter.
> + */
> +static inline void task_isolation_user_exit(void)
> +{
> +#ifdef DEBUG_TASK_ISOLATION
> +	task_isolation_interrupt("user_exit");
> +#endif
> +}
> +
> +#else /* !CONFIG_TASK_ISOLATION */
> +static inline int task_isolation_request(unsigned int flags) { return -EINVAL; }
> +static inline void task_isolation_start(void) { }
> +static inline bool is_isolation_cpu(int cpu) { return 0; }
> +static inline int task_isolation_on_cpu(int cpu) { return 0; }
> +static inline void task_isolation_cpumask(struct cpumask *mask) { }
> +static inline void task_isolation_clear_cpumask(struct cpumask *mask) { }
> +static inline void task_isolation_cpu_cleanup(void) { }
> +static inline void task_isolation_check_run_cleanup(void) { }
> +static inline int task_isolation_syscall(int nr) { return 0; }
> +static inline void task_isolation_interrupt(const char *fmt, ...) { }
> +static inline void task_isolation_remote(int cpu, const char *fmt, ...) { }
> +static inline void task_isolation_remote_cpumask(const struct cpumask *mask,
> +						 const char *fmt, ...) { }
> +static inline void task_isolation_signal(struct task_struct *task) { }
> +static inline void task_isolation_user_exit(void) { }
> +#endif
> +
> +#endif /* _LINUX_ISOLATION_H */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..52fdb32aa3b9 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1280,6 +1280,10 @@ struct task_struct {
>  	unsigned long			lowest_stack;
>  	unsigned long			prev_lowest_stack;
>  #endif
> +#ifdef CONFIG_TASK_ISOLATION
> +	unsigned short			task_isolation_flags;  /* prctl */
> +	unsigned short			task_isolation_state;
> +#endif
>  
>  	/*
>  	 * New fields for task_struct should be added above here, so that
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index 7340613c7eff..27c7c033d5a8 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -268,6 +268,9 @@ static inline void tick_dep_clear_signal(struct signal_struct *signal,
>  extern void tick_nohz_full_kick_cpu(int cpu);
>  extern void __tick_nohz_task_switch(void);
>  extern void __init tick_nohz_full_setup(cpumask_var_t cpumask);
> +#ifdef CONFIG_TASK_ISOLATION
> +extern int try_stop_full_tick(void);
> +#endif
>  #else
>  static inline bool tick_nohz_full_enabled(void) { return false; }
>  static inline bool tick_nohz_full_cpu(int cpu) { return false; }
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 07b4f8131e36..f4848ed2a069 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -238,4 +238,10 @@ struct prctl_mm_map {
>  #define PR_SET_IO_FLUSHER		57
>  #define PR_GET_IO_FLUSHER		58
>  
> +/* Enable task_isolation mode for TASK_ISOLATION kernels. */
> +#define PR_TASK_ISOLATION		48
> +# define PR_TASK_ISOLATION_ENABLE	(1 << 0)
> +# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
> +# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index 20a6ac33761c..ecdf567f6bd4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -576,6 +576,34 @@ config CPU_ISOLATION
>  
>  source "kernel/rcu/Kconfig"
>  
> +config HAVE_ARCH_TASK_ISOLATION
> +	bool
> +
> +config TASK_ISOLATION
> +	bool "Provide hard CPU isolation from the kernel on demand"
> +	depends on NO_HZ_FULL && HAVE_ARCH_TASK_ISOLATION
> +	help
> +
> +	Allow userspace processes that place themselves on cores with
> +	nohz_full and isolcpus enabled, and run prctl(PR_TASK_ISOLATION),
> +	to "isolate" themselves from the kernel.  Prior to returning to
> +	userspace, isolated tasks will arrange that no future kernel
> +	activity will interrupt the task while the task is running in
> +	userspace.  Attempting to re-enter the kernel while in this mode
> +	will cause the task to be terminated with a signal; you must
> +	explicitly use prctl() to disable task isolation before resuming
> +	normal use of the kernel.
> +
> +	This "hard" isolation from the kernel is required for userspace
> +	tasks that are running hard real-time tasks in userspace, such as
> +	a high-speed network driver in userspace.  Without this option, but
> +	with NO_HZ_FULL enabled, the kernel will make a best-faith, "soft"
> +	effort to shield a single userspace process from interrupts, but
> +	makes no guarantees.
> +
> +	You should say "N" unless you are intending to run a
> +	high-performance userspace driver or similar task.
> +
>  config BUILD_BIN2C
>  	bool
>  	default n
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 4cb4130ced32..2f2ae91f90d5 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -122,6 +122,8 @@ obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
>  KASAN_SANITIZE_stackleak.o := n
>  KCOV_INSTRUMENT_stackleak.o := n
>  
> +obj-$(CONFIG_TASK_ISOLATION) += isolation.o
> +
>  $(obj)/configs.o: $(obj)/config_data.gz
>  
>  targets += config_data.gz
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 0296b4bda8f1..e9206736f219 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -21,6 +21,7 @@
>  #include <linux/hardirq.h>
>  #include <linux/export.h>
>  #include <linux/kprobes.h>
> +#include <linux/isolation.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/context_tracking.h>
> @@ -157,6 +158,7 @@ void __context_tracking_exit(enum ctx_state state)
>  			if (state == CONTEXT_USER) {
>  				vtime_user_exit(current);
>  				trace_user_exit(0);
> +				task_isolation_user_exit();
>  			}
>  		}
>  		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
> diff --git a/kernel/isolation.c b/kernel/isolation.c
> new file mode 100644
> index 000000000000..ae29732c376c
> --- /dev/null
> +++ b/kernel/isolation.c
> @@ -0,0 +1,774 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  linux/kernel/isolation.c
> + *
> + *  Implementation of task isolation.
> + *
> + * Authors:
> + *   Chris Metcalf <cmetcalf@mellanox.com>
> + *   Alex Belits <abelits@marvell.com>
> + *   Yuri Norov <ynorov@marvell.com>
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/swap.h>
> +#include <linux/vmstat.h>
> +#include <linux/sched.h>
> +#include <linux/isolation.h>
> +#include <linux/syscalls.h>
> +#include <linux/smp.h>
> +#include <linux/tick.h>
> +#include <asm/unistd.h>
> +#include <asm/syscall.h>
> +#include <linux/hrtimer.h>
> +
> +/*
> + * These values are stored in task_isolation_state.
> + * Note that STATE_NORMAL + TIF_TASK_ISOLATION means we are still
> + * returning from sys_prctl() to userspace.
> + */
> +enum {
> +	STATE_NORMAL = 0,	/* Not isolated */
> +	STATE_ISOLATED = 1	/* In userspace, isolated */
> +};
> +
> +/*
> + * This variable contains thread flags copied at the moment
> + * when schedule() switched to the task on a given CPU,
> + * or 0 if no task is running.
> + */
> +DEFINE_PER_CPU(unsigned long, tsk_thread_flags_cache);
> +
> +/*
> + * Counter for isolation state on a given CPU, increments when entering
> + * isolation and decrements when exiting isolation (before or after the
> + * cleanup). Multiple simultaneously running procedures entering or
> + * exiting isolation are prevented by checking the result of
> + * incrementing or decrementing this variable. This variable is both
> + * incremented and decremented by CPU that caused isolation entering or
> + * exit.
> + *
> + * This is necessary because multiple isolation-breaking events may happen
> + * at once (or one as the result of the other), however isolation exit
> + * may only happen once to transition from isolated to non-isolated state.
> + * Therefore, if decrementing this counter results in a value less than 0,
> + * isolation exit procedure can't be started -- it already happened, or is
> + * in progress, or isolation is not entered yet.
> + */
> +DEFINE_PER_CPU(atomic_t, isol_counter);
> +
> +/*
> + * Description of the last two tasks that ran isolated on a given CPU.
> + * This is intended only for messages about isolation breaking. We
> + * don't want any references to actual task while accessing this from
> + * CPU that caused isolation breaking -- we know nothing about timing
> + * and don't want to use locking or RCU.
> + */
> +struct isol_task_desc {
> +	atomic_t curr_index;
> +	atomic_t curr_index_wr;
> +	bool	warned[2];
> +	pid_t	pid[2];
> +	pid_t	tgid[2];
> +	char	comm[2][TASK_COMM_LEN];
> +};
> +static DEFINE_PER_CPU(struct isol_task_desc, isol_task_descs);
> +
> +/*
> + * Counter for isolation exiting procedures (from request to the start of
> + * cleanup) being attempted at once on a CPU. Normally incrementing of
> + * this counter is performed from the CPU that caused isolation breaking,
> + * however decrementing is done from the cleanup procedure, delegated to
> + * the CPU that is exiting isolation, not from the CPU that caused isolation
> + * breaking.
> + *
> + * If incrementing this counter while starting isolation exit procedure
> + * results in a value greater than 0, isolation exiting is already in
> + * progress, and cleanup did not start yet. This means, counter should be
> + * decremented back, and isolation exit that is already in progress, should
> + * be allowed to complete. Otherwise, a new isolation exit procedure should
> + * be started.
> + */
> +DEFINE_PER_CPU(atomic_t, isol_exit_counter);
> +
> +/*
> + * Descriptor for isolation-breaking SMP calls
> + */
> +DEFINE_PER_CPU(call_single_data_t, isol_break_csd);
> +
> +cpumask_var_t task_isolation_map;
> +cpumask_var_t task_isolation_cleanup_map;
> +static DEFINE_SPINLOCK(task_isolation_cleanup_lock);
> +
> +/* We can run on cpus that are isolated from the scheduler and are nohz_full. */
> +static int __init task_isolation_init(void)
> +{
> +	alloc_bootmem_cpumask_var(&task_isolation_cleanup_map);
> +	if (alloc_cpumask_var(&task_isolation_map, GFP_KERNEL))
> +		/*
> +		 * At this point task isolation should match
> +		 * nohz_full. This may change in the future.
> +		 */
> +		cpumask_copy(task_isolation_map, tick_nohz_full_mask);
> +	return 0;
> +}
> +core_initcall(task_isolation_init)
> +
> +/* Enable stack backtraces of any interrupts of task_isolation cores. */
> +static bool task_isolation_debug;
> +static int __init task_isolation_debug_func(char *str)
> +{
> +	task_isolation_debug = true;
> +	return 1;
> +}
> +__setup("task_isolation_debug", task_isolation_debug_func);
> +
> +/*
> + * Record name, pid and group pid of the task entering isolation on
> + * the current CPU.
> + */
> +static void record_curr_isolated_task(void)
> +{
> +	int ind;
> +	int cpu = smp_processor_id();
> +	struct isol_task_desc *desc = &per_cpu(isol_task_descs, cpu);
> +	struct task_struct *task = current;
> +
> +	/* Finish everything before recording current task */
> +	smp_mb();
> +	ind = atomic_inc_return(&desc->curr_index_wr) & 1;
> +	desc->comm[ind][sizeof(task->comm) - 1] = '\0';
> +	memcpy(desc->comm[ind], task->comm, sizeof(task->comm) - 1);
> +	desc->pid[ind] = task->pid;
> +	desc->tgid[ind] = task->tgid;
> +	desc->warned[ind] = false;
> +	/* Write everything, to be seen by other CPUs */
> +	smp_mb();
> +	atomic_inc(&desc->curr_index);
> +	/* Everyone will see the new record from this point */
> +	smp_mb();
> +}
> +
> +/*
> + * Print message prefixed with the description of the current (or
> + * last) isolated task on a given CPU. Intended for isolation breaking
> + * messages that include target task for the user's convenience.
> + *
> + * Messages produced with this function may have obsolete task
> + * information if isolated tasks managed to exit, start and enter
> + * isolation multiple times, or multiple tasks tried to enter
> + * isolation on the same CPU at once. For those unusual cases it would
> + * contain a valid description of the cause for isolation breaking and
> + * target CPU number, just not the correct description of which task
> + * ended up losing isolation.
> + */
> +int task_isolation_message(int cpu, int level, bool supp, const char *fmt, ...)
> +{
> +	struct isol_task_desc *desc;
> +	struct task_struct *task;
> +	va_list args;
> +	char buf_prefix[TASK_COMM_LEN + 20 + 3 * 20];
> +	char buf[200];
> +	int curr_cpu, ind_counter, ind_counter_old, ind;
> +
> +	curr_cpu = get_cpu();
> +	desc = &per_cpu(isol_task_descs, cpu);
> +	ind_counter = atomic_read(&desc->curr_index);
> +
> +	if (curr_cpu == cpu) {
> +		/*
> +		 * Message is for the current CPU so current
> +		 * task_struct should be used instead of cached
> +		 * information.
> +		 *
> +		 * Like in other diagnostic messages, if issued from
> +		 * interrupt context, current will be the interrupted
> +		 * task. Unlike other diagnostic messages, this is
> +		 * always relevant because the message is about
> +		 * interrupting a task.
> +		 */
> +		ind = ind_counter & 1;
> +		if (supp && desc->warned[ind]) {
> +			/*
> +			 * If supp is true, skip the message if the
> +			 * same task was mentioned in the message
> +			 * originated on remote CPU, and it did not
> +			 * re-enter isolated state since then (warned
> +			 * is true). Only local messages following
> +			 * remote messages, likely about the same
> +			 * isolation breaking event, are skipped to
> +			 * avoid duplication. If remote cause is
> +			 * immediately followed by a local one before
> +			 * isolation is broken, local cause is skipped
> +			 * from messages.
> +			 */
> +			put_cpu();
> +			return 0;
> +		}
> +		task = current;
> +		snprintf(buf_prefix, sizeof(buf_prefix),
> +			 "isolation %s/%d/%d (cpu %d)",
> +			 task->comm, task->tgid, task->pid, cpu);
> +		put_cpu();
> +	} else {
> +		/*
> +		 * Message is for remote CPU, use cached information.
> +		 */
> +		put_cpu();
> +		/*
> +		 * Make sure, index remained unchanged while data was
> +		 * copied. If it changed, data that was copied may be
> +		 * inconsistent because two updates in a sequence could
> +		 * overwrite the data while it was being read.
> +		 */
> +		do {
> +			/* Make sure we are reading up to date values */
> +			smp_mb();
> +			ind = ind_counter & 1;
> +			snprintf(buf_prefix, sizeof(buf_prefix),
> +				 "isolation %s/%d/%d (cpu %d)",
> +				 desc->comm[ind], desc->tgid[ind],
> +				 desc->pid[ind], cpu);
> +			desc->warned[ind] = true;
> +			ind_counter_old = ind_counter;
> +			/* Record the warned flag, then re-read descriptor */
> +			smp_mb();
> +			ind_counter = atomic_read(&desc->curr_index);
> +			/*
> +			 * If the counter changed, something was updated, so
> +			 * repeat everything to get the current data
> +			 */
> +		} while (ind_counter != ind_counter_old);
> +	}
> +
> +	va_start(args, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, args);
> +	va_end(args);
> +
> +	switch (level) {
> +	case LOGLEVEL_EMERG:
> +		pr_emerg("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_ALERT:
> +		pr_alert("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_CRIT:
> +		pr_crit("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_ERR:
> +		pr_err("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_WARNING:
> +		pr_warn("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_NOTICE:
> +		pr_notice("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_INFO:
> +		pr_info("%s: %s", buf_prefix, buf);
> +		break;
> +	case LOGLEVEL_DEBUG:
> +		pr_debug("%s: %s", buf_prefix, buf);
> +		break;
> +	default:
> +		/* No message without a valid level */
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +/*
> + * Dump stack if need be. This can be helpful even from the final exit
> + * to usermode code since stack traces sometimes carry information about
> + * what put you into the kernel, e.g. an interrupt number encoded in
> + * the initial entry stack frame that is still visible at exit time.
> + */
> +static void debug_dump_stack(void)
> +{
> +	if (task_isolation_debug)
> +		dump_stack();
> +}
> +
> +/*
> + * Set the flags word but don't try to actually start task isolation yet.
> + * We will start it when entering user space in task_isolation_start().
> + */
> +int task_isolation_request(unsigned int flags)
> +{
> +	struct task_struct *task = current;
> +
> +	/*
> +	 * The task isolation flags should always be cleared just by
> +	 * virtue of having entered the kernel.
> +	 */
> +	WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_TASK_ISOLATION));
> +	WARN_ON_ONCE(task->task_isolation_flags != 0);
> +	WARN_ON_ONCE(task->task_isolation_state != STATE_NORMAL);
> +
> +	task->task_isolation_flags = flags;
> +	if (!(task->task_isolation_flags & PR_TASK_ISOLATION_ENABLE))
> +		return 0;
> +
> +	/* We are trying to enable task isolation. */
> +	set_tsk_thread_flag(task, TIF_TASK_ISOLATION);
> +
> +	/*
> +	 * Shut down the vmstat worker so we're not interrupted later.
> +	 * We have to try to do this here (with interrupts enabled) since
> +	 * we are canceling delayed work and will call flush_work()
> +	 * (which enables interrupts) and possibly schedule().
> +	 */
> +	quiet_vmstat_sync();
> +
> +	/* We return 0 here but we may change that in task_isolation_start(). */
> +	return 0;
> +}
> +
> +/*
> + * Perform actions that should be done immediately on exit from isolation.
> + */
> +static void fast_task_isolation_cpu_cleanup(void *info)
> +{
> +	atomic_dec(&per_cpu(isol_exit_counter, smp_processor_id()));
> +	/* At this point breaking isolation from other CPUs is possible again */
> +
> +	/*
> +	 * This task is no longer isolated (and if by any chance this
> +	 * is the wrong task, it's already not isolated)
> +	 */
> +	current->task_isolation_flags = 0;
> +	clear_tsk_thread_flag(current, TIF_TASK_ISOLATION);
> +
> +	/* Run the rest of cleanup later */
> +	set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
> +
> +	/* Copy flags with task isolation disabled */
> +	this_cpu_write(tsk_thread_flags_cache,
> +		       READ_ONCE(task_thread_info(current)->flags));
> +}
> +
> +/* Disable task isolation for the specified task. */
> +static void stop_isolation(struct task_struct *p)
> +{
> +	int cpu, this_cpu;
> +	unsigned long flags;
> +
> +	this_cpu = get_cpu();
> +	cpu = task_cpu(p);
> +	if (atomic_inc_return(&per_cpu(isol_exit_counter, cpu)) > 1) {
> +		/* Already exiting isolation */
> +		atomic_dec(&per_cpu(isol_exit_counter, cpu));
> +		put_cpu();
> +		return;
> +	}
> +
> +	if (p == current) {
> +		p->task_isolation_state = STATE_NORMAL;
> +		fast_task_isolation_cpu_cleanup(NULL);
> +		task_isolation_cpu_cleanup();
> +		if (atomic_dec_return(&per_cpu(isol_counter, cpu)) < 0) {
> +			/* Is not isolated already */
> +			atomic_inc(&per_cpu(isol_counter, cpu));
> +		}
> +		put_cpu();
> +	} else {
> +		if (atomic_dec_return(&per_cpu(isol_counter, cpu)) < 0) {
> +			/* Is not isolated already */
> +			atomic_inc(&per_cpu(isol_counter, cpu));
> +			atomic_dec(&per_cpu(isol_exit_counter, cpu));
> +			put_cpu();
> +			return;
> +		}
> +		/*
> +		 * Schedule "slow" cleanup. This relies on
> +		 * TIF_NOTIFY_RESUME being set
> +		 */
> +		spin_lock_irqsave(&task_isolation_cleanup_lock, flags);
> +		cpumask_set_cpu(cpu, task_isolation_cleanup_map);
> +		spin_unlock_irqrestore(&task_isolation_cleanup_lock, flags);
> +		/*
> +		 * Setting flags is delegated to the CPU where
> +		 * isolated task is running
> +		 * isol_exit_counter will be decremented from there as well.
> +		 */
> +		per_cpu(isol_break_csd, cpu).func =
> +		    fast_task_isolation_cpu_cleanup;
> +		per_cpu(isol_break_csd, cpu).info = NULL;
> +		per_cpu(isol_break_csd, cpu).flags = 0;
> +		smp_call_function_single_async(cpu,
> +					       &per_cpu(isol_break_csd, cpu));
> +		put_cpu();
> +	}
> +}
> +
> +/*
> + * This code runs with interrupts disabled just before the return to
> + * userspace, after a prctl() has requested enabling task isolation.
> + * We take whatever steps are needed to avoid being interrupted later:
> + * drain the lru pages, stop the scheduler tick, etc.  More
> + * functionality may be added here later to avoid other types of
> + * interrupts from other kernel subsystems.
> + *
> + * If we can't enable task isolation, we update the syscall return
> + * value with an appropriate error.
> + */
> +void task_isolation_start(void)
> +{
> +	int error;
> +
> +	/*
> +	 * We should only be called in STATE_NORMAL (isolation disabled),
> +	 * on our way out of the kernel from the prctl() that turned it on.
> +	 * If we are exiting from the kernel in another state, it means we
> +	 * made it back into the kernel without disabling task isolation,
> +	 * and we should investigate how (and in any case disable task
> +	 * isolation at this point).  We are clearly not on the path back
> +	 * from the prctl() so we don't touch the syscall return value.
> +	 */
> +	if (WARN_ON_ONCE(current->task_isolation_state != STATE_NORMAL)) {
> +		/* Increment counter, this will allow isolation breaking */
> +		if (atomic_inc_return(&per_cpu(isol_counter,
> +					      smp_processor_id())) > 1) {
> +			atomic_dec(&per_cpu(isol_counter, smp_processor_id()));
> +		}
> +		atomic_inc(&per_cpu(isol_counter, smp_processor_id()));
> +		stop_isolation(current);
> +		return;
> +	}
> +
> +	/*
> +	 * Must be affinitized to a single core with task isolation possible.
> +	 * In principle this could be remotely modified between the prctl()
> +	 * and the return to userspace, so we have to check it here.
> +	 */
> +	if (current->nr_cpus_allowed != 1 ||
> +	    !is_isolation_cpu(smp_processor_id())) {
> +		error = -EINVAL;
> +		goto error;
> +	}
> +
> +	/* If the vmstat delayed work is not canceled, we have to try again. */
> +	if (!vmstat_idle()) {
> +		error = -EAGAIN;
> +		goto error;
> +	}
> +
> +	/* Try to stop the dynamic tick. */
> +	error = try_stop_full_tick();
> +	if (error)
> +		goto error;
> +
> +	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
> +	lru_add_drain();
> +
> +	/* Increment counter, this will allow isolation breaking */
> +	if (atomic_inc_return(&per_cpu(isol_counter,
> +				      smp_processor_id())) > 1) {
> +		atomic_dec(&per_cpu(isol_counter, smp_processor_id()));
> +	}
> +
> +	/* Record isolated task IDs and name */
> +	record_curr_isolated_task();
> +
> +	/* Copy flags with task isolation enabled */
> +	this_cpu_write(tsk_thread_flags_cache,
> +		       READ_ONCE(task_thread_info(current)->flags));
> +
> +	current->task_isolation_state = STATE_ISOLATED;
> +	return;
> +
> +error:
> +	/* Increment counter, this will allow isolation breaking */
> +	if (atomic_inc_return(&per_cpu(isol_counter,
> +				      smp_processor_id())) > 1) {
> +		atomic_dec(&per_cpu(isol_counter, smp_processor_id()));
> +	}
> +	stop_isolation(current);
> +	syscall_set_return_value(current, current_pt_regs(), error, 0);
> +}
> +
> +/* Stop task isolation on the remote task and send it a signal. */
> +static void send_isolation_signal(struct task_struct *task)
> +{
> +	int flags = task->task_isolation_flags;
> +	kernel_siginfo_t info = {
> +		.si_signo = PR_TASK_ISOLATION_GET_SIG(flags) ?: SIGKILL,
> +	};
> +
> +	stop_isolation(task);
> +	send_sig_info(info.si_signo, &info, task);
> +}
> +
> +/* Only a few syscalls are valid once we are in task isolation mode. */
> +static bool is_acceptable_syscall(int syscall)
> +{
> +	/* No need to incur an isolation signal if we are just exiting. */
> +	if (syscall == __NR_exit || syscall == __NR_exit_group)
> +		return true;
> +
> +	/* Check to see if it's the prctl for isolation. */
> +	if (syscall == __NR_prctl) {
> +		unsigned long arg[SYSCALL_MAX_ARGS];
> +
> +		syscall_get_arguments(current, current_pt_regs(), arg);
> +		if (arg[0] == PR_TASK_ISOLATION)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * This routine is called from syscall entry, prevents most syscalls
> + * from executing, and if needed raises a signal to notify the process.
> + *
> + * Note that we have to stop isolation before we even print a message
> + * here, since otherwise we might end up reporting an interrupt due to
> + * kicking the printk handling code, rather than reporting the true
> + * cause of interrupt here.
> + *
> + * The message is not suppressed by previous remotely triggered
> + * messages.
> + */
> +int task_isolation_syscall(int syscall)
> +{
> +	struct task_struct *task = current;
> +
> +	if (is_acceptable_syscall(syscall)) {
> +		stop_isolation(task);
> +		return 0;
> +	}
> +
> +	send_isolation_signal(task);
> +
> +	pr_task_isol_warn(smp_processor_id(),
> +			  "task_isolation lost due to syscall %d\n",
> +			  syscall);
> +	debug_dump_stack();
> +
> +	syscall_set_return_value(task, current_pt_regs(), -ERESTARTNOINTR, -1);
> +	return -1;
> +}
> +
> +/*
> + * This routine is called from any exception or irq that doesn't
> + * otherwise trigger a signal to the user process (e.g. page fault).
> + *
> + * Messages will be suppressed if there is already a reported remote
> + * cause for isolation breaking, so we don't generate multiple
> + * confusingly similar messages about the same event.
> + */
> +void _task_isolation_interrupt(const char *fmt, ...)
> +{
> +	struct task_struct *task = current;
> +	va_list args;
> +	char buf[100];
> +
> +	/* RCU should have been enabled prior to this point. */
> +	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
> +
> +	/* Are we exiting isolation already? */
> +	if (atomic_read(&per_cpu(isol_exit_counter, smp_processor_id())) != 0) {
> +		task->task_isolation_state = STATE_NORMAL;
> +		return;
> +	}
> +	/*
> +	 * Avoid reporting interrupts that happen after we have prctl'ed
> +	 * to enable isolation, but before we have returned to userspace.
> +	 */
> +	if (task->task_isolation_state == STATE_NORMAL)
> +		return;
> +
> +	va_start(args, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, args);
> +	va_end(args);
> +
> +	/* Handle NMIs minimally, since we can't send a signal. */
> +	if (in_nmi()) {
> +		pr_task_isol_err(smp_processor_id(),
> +				 "isolation: in NMI; not delivering signal\n");
> +	} else {
> +		send_isolation_signal(task);
> +	}
> +
> +	if (pr_task_isol_warn_supp(smp_processor_id(),
> +				   "task_isolation lost due to %s\n", buf))
> +		debug_dump_stack();
> +}
> +
> +/*
> + * Called before we wake up a task that has a signal to process.
> + * Needs to be done to handle interrupts that trigger signals, which
> + * we don't catch with task_isolation_interrupt() hooks.
> + *
> + * This message is also suppressed if there was already a remotely
> + * caused message about the same isolation breaking event.
> + */
> +void _task_isolation_signal(struct task_struct *task)
> +{
> +	struct isol_task_desc *desc;
> +	int ind, cpu;
> +	bool do_warn = (task->task_isolation_state == STATE_ISOLATED);
> +
> +	cpu = task_cpu(task);
> +	desc = &per_cpu(isol_task_descs, cpu);
> +	ind = atomic_read(&desc->curr_index) & 1;
> +	if (desc->warned[ind])
> +		do_warn = false;
> +
> +	stop_isolation(task);
> +
> +	if (do_warn) {
> +		pr_warn("isolation: %s/%d/%d (cpu %d): task_isolation lost due to signal\n",
> +			task->comm, task->tgid, task->pid, cpu);
> +		debug_dump_stack();
> +	}
> +}
> +
> +/*
> + * Generate a stack backtrace if we are going to interrupt another task
> + * isolation process.
> + */
> +void task_isolation_remote(int cpu, const char *fmt, ...)
> +{
> +	struct task_struct *curr_task;
> +	va_list args;
> +	char buf[200];
> +
> +	if (!is_isolation_cpu(cpu) || !task_isolation_on_cpu(cpu))
> +		return;
> +
> +	curr_task = current;
> +
> +	va_start(args, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, args);
> +	va_end(args);
> +	if (pr_task_isol_warn(cpu,
> +			      "task_isolation lost due to %s by %s/%d/%d on cpu %d\n",
> +			      buf,
> +			      curr_task->comm, curr_task->tgid,
> +			      curr_task->pid, smp_processor_id()))
> +		debug_dump_stack();
> +}
> +
> +/*
> + * Generate a stack backtrace if any of the cpus in "mask" are running
> + * task isolation processes.
> + */
> +void task_isolation_remote_cpumask(const struct cpumask *mask,
> +				   const char *fmt, ...)
> +{
> +	struct task_struct *curr_task;
> +	cpumask_var_t warn_mask;
> +	va_list args;
> +	char buf[200];
> +	int cpu, first_cpu;
> +
> +	if (task_isolation_map == NULL ||
> +		!zalloc_cpumask_var(&warn_mask, GFP_KERNEL))
> +		return;
> +
> +	first_cpu = -1;
> +	for_each_cpu_and(cpu, mask, task_isolation_map) {
> +		if (task_isolation_on_cpu(cpu)) {
> +			if (first_cpu < 0)
> +				first_cpu = cpu;
> +			else
> +				cpumask_set_cpu(cpu, warn_mask);
> +		}
> +	}
> +
> +	if (first_cpu < 0)
> +		goto done;
> +
> +	curr_task = current;
> +
> +	va_start(args, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, args);
> +	va_end(args);
> +
> +	if (cpumask_weight(warn_mask) == 0)
> +		pr_task_isol_warn(first_cpu,
> +				  "task_isolation lost due to %s by %s/%d/%d on cpu %d\n",
> +				  buf, curr_task->comm, curr_task->tgid,
> +				  curr_task->pid, smp_processor_id());
> +	else
> +		pr_task_isol_warn(first_cpu,
> +				  " and cpus %*pbl: task_isolation lost due to %s by %s/%d/%d on cpu %d\n",
> +				  cpumask_pr_args(warn_mask),
> +				  buf, curr_task->comm, curr_task->tgid,
> +				  curr_task->pid, smp_processor_id());
> +	debug_dump_stack();
> +
> +done:
> +	free_cpumask_var(warn_mask);
> +}
> +
> +/*
> + * Check if given CPU is running isolated task.
> + */
> +int task_isolation_on_cpu(int cpu)
> +{
> +	return test_bit(TIF_TASK_ISOLATION,
> +			&per_cpu(tsk_thread_flags_cache, cpu));
> +}
> +
> +/*
> + * Set CPUs currently running isolated tasks in CPU mask.
> + */
> +void task_isolation_cpumask(struct cpumask *mask)
> +{
> +	int cpu;
> +
> +	if (task_isolation_map == NULL)
> +		return;
> +
> +	for_each_cpu(cpu, task_isolation_map)
> +		if (task_isolation_on_cpu(cpu))
> +			cpumask_set_cpu(cpu, mask);
> +}
> +
> +/*
> + * Clear CPUs currently running isolated tasks in CPU mask.
> + */
> +void task_isolation_clear_cpumask(struct cpumask *mask)
> +{
> +	int cpu;
> +
> +	if (task_isolation_map == NULL)
> +		return;
> +
> +	for_each_cpu(cpu, task_isolation_map)
> +		if (task_isolation_on_cpu(cpu))
> +			cpumask_clear_cpu(cpu, mask);
> +}
> +
> +/*
> + * Cleanup procedure. The call to this procedure may be delayed.
> + */
> +void task_isolation_cpu_cleanup(void)
> +{
> +	kick_hrtimer();
> +}
> +
> +/*
> + * Check if cleanup is scheduled on the current CPU, and if so, run it.
> + * Intended to be called from notify_resume() or another such callback
> + * on the target CPU.
> + */
> +void task_isolation_check_run_cleanup(void)
> +{
> +	int cpu;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&task_isolation_cleanup_lock, flags);
> +
> +	cpu = smp_processor_id();
> +
> +	if (cpumask_test_cpu(cpu, task_isolation_cleanup_map)) {
> +		cpumask_clear_cpu(cpu, task_isolation_cleanup_map);
> +		spin_unlock_irqrestore(&task_isolation_cleanup_lock, flags);
> +		task_isolation_cpu_cleanup();
> +	} else
> +		spin_unlock_irqrestore(&task_isolation_cleanup_lock, flags);
> +}
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 5b2396350dd1..1df57e38c361 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -46,6 +46,7 @@
>  #include <linux/livepatch.h>
>  #include <linux/cgroup.h>
>  #include <linux/audit.h>
> +#include <linux/isolation.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/signal.h>
> @@ -758,6 +759,7 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
>   */
>  void signal_wake_up_state(struct task_struct *t, unsigned int state)
>  {
> +	task_isolation_signal(t);
>  	set_tsk_thread_flag(t, TIF_SIGPENDING);
>  	/*
>  	 * TASK_WAKEKILL also means wake it up in the stopped/traced/killable
> diff --git a/kernel/sys.c b/kernel/sys.c
> index f9bc5c303e3f..0a4059a8c4f9 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -42,6 +42,7 @@
>  #include <linux/syscore_ops.h>
>  #include <linux/version.h>
>  #include <linux/ctype.h>
> +#include <linux/isolation.h>
>  
>  #include <linux/compat.h>
>  #include <linux/syscalls.h>
> @@ -2513,6 +2514,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  
>  		error = (current->flags & PR_IO_FLUSHER) == PR_IO_FLUSHER;
>  		break;
> +	case PR_TASK_ISOLATION:
> +		if (arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		error = task_isolation_request(arg2);
> +		break;
>  	default:
>  		error = -EINVAL;
>  		break;
> diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
> index 3a609e7344f3..5bb98f39bde6 100644
> --- a/kernel/time/hrtimer.c
> +++ b/kernel/time/hrtimer.c
> @@ -30,6 +30,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/interrupt.h>
>  #include <linux/tick.h>
> +#include <linux/isolation.h>
>  #include <linux/err.h>
>  #include <linux/debugobjects.h>
>  #include <linux/sched/signal.h>
> @@ -721,6 +722,19 @@ static void retrigger_next_event(void *arg)
>  	raw_spin_unlock(&base->lock);
>  }
>  
> +#ifdef CONFIG_TASK_ISOLATION
> +void kick_hrtimer(void)
> +{
> +	unsigned long flags;
> +
> +	preempt_disable();
> +	local_irq_save(flags);
> +	retrigger_next_event(NULL);
> +	local_irq_restore(flags);
> +	preempt_enable();
> +}
> +#endif
> +
>  /*
>   * Switch to high resolution mode
>   */
> @@ -868,8 +882,21 @@ static void hrtimer_reprogram(struct hrtimer *timer, bool reprogram)
>  void clock_was_set(void)
>  {
>  #ifdef CONFIG_HIGH_RES_TIMERS
> +#ifdef CONFIG_TASK_ISOLATION
> +	struct cpumask mask;
> +
> +	cpumask_clear(&mask);
> +	task_isolation_cpumask(&mask);
> +	cpumask_complement(&mask, &mask);
> +	/*
> +	 * Retrigger the CPU local events everywhere except CPUs
> +	 * running isolated tasks.
> +	 */
> +	on_each_cpu_mask(&mask, retrigger_next_event, NULL, 1);
> +#else
>  	/* Retrigger the CPU local events everywhere */
>  	on_each_cpu(retrigger_next_event, NULL, 1);
> +#endif
>  #endif
>  	timerfd_clock_was_set();
>  }
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index a792d21cac64..1d4dec9d3ee7 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -882,6 +882,24 @@ static void tick_nohz_full_update_tick(struct tick_sched *ts)
>  #endif
>  }
>  
> +#ifdef CONFIG_TASK_ISOLATION
> +int try_stop_full_tick(void)
> +{
> +	int cpu = smp_processor_id();
> +	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
> +
> +	/* For an unstable clock, we should return a permanent error code. */
> +	if (atomic_read(&tick_dep_mask) & TICK_DEP_MASK_CLOCK_UNSTABLE)
> +		return -EINVAL;
> +
> +	if (!can_stop_full_tick(cpu, ts))
> +		return -EAGAIN;
> +
> +	tick_nohz_stop_sched_tick(ts, cpu);
> +	return 0;
> +}
> +#endif
> +
>  static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  {
>  	/*
> -- 
> 2.20.1
> 
