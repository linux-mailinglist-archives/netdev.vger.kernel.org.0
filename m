Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579052C1870
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbgKWWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:31:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38812 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgKWWbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:31:21 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606170678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsOujzOTu45u93BqvvN6/gmIXAdDDBFarr10AXDoJl0=;
        b=Glh+XE7J1hnuXnT0iBF4aZ6YFNhQRjuoW6FpOduCf45cNJy1iYTzDcNwSk6wKPiOVAp138
        +mv3K0CLI8G8v5ybst8ylCS/13FuAjJu1qaFk0RmKStveW7Ia4uYG/ogm7WDK3PtdOv965
        vtHZ9Ht08tC1X5uY9Ds5A8mQaCQXCD/ui7NraCH2GPVf5v44XOodPCvVzKxLn4dML4WgOm
        WvF9zx2AM6sSN2sjQS92bgeuHnuiVSCbfmg8jBhtghHTDvXrNsOIVqfisVGuefPylcIQes
        vftFGZ0dDH6loWjy/N2BOGOLtce3cLMFFmZaiWX77nJgt+vYG1+b+bE5NQ66kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606170678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsOujzOTu45u93BqvvN6/gmIXAdDDBFarr10AXDoJl0=;
        b=pebOa7GKlC90OcQb3GyFNNhE381wCRYZRE0wHGc9ph3dY3Qp9DcoQGYTHCtYeywDNN0fBb
        fXAldr06xchV2DBQ==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "trix\@redhat.com" <trix@redhat.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx\@redhat.com" <peterx@redhat.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "will\@kernel.org" <will@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "leon\@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld\@redhat.com" <pauld@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/9] task_isolation: Add task isolation hooks to arch-independent code
In-Reply-To: <ec4bacce635fed4e77ab46752d41432f270edf83.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com> <ec4bacce635fed4e77ab46752d41432f270edf83.camel@marvell.com>
Date:   Mon, 23 Nov 2020 23:31:18 +0100
Message-ID: <875z5vn1s9.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex,

On Mon, Nov 23 2020 at 17:57, Alex Belits wrote:
> Kernel entry and exit functions for task isolation are added to context
> tracking and common entry points. Common handling of pending work on exit
> to userspace now processes isolation breaking, cleanup and start.

Again: You fail to explain the rationale and just explain what the patch
is doing. I can see what the patch is doing from the patch itself.

> ---
>  include/linux/hardirq.h   |  2 ++
>  include/linux/sched.h     |  2 ++
>  kernel/context_tracking.c |  5 +++++
>  kernel/entry/common.c     | 10 +++++++++-
>  kernel/irq/irqdesc.c      |  5 +++++

At least 3 different subsystems, which means this again failed to be
split into seperate patches.

>  extern void synchronize_irq(unsigned int irq);
> @@ -115,6 +116,7 @@ extern void rcu_nmi_exit(void);
>  	do {							\
>  		lockdep_off();					\
>  		arch_nmi_enter();				\
> +		task_isolation_kernel_enter();			\

Where is the explanation why this is safe and correct vs. this fragile
code path?

> @@ -1762,6 +1763,7 @@ extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
>  #ifdef CONFIG_SMP
>  static __always_inline void scheduler_ipi(void)
>  {
> +	task_isolation_kernel_enter();

Why is the scheduler_ipi() special? Just because everything else cannot
happen at all? Oh well...

>  #define CREATE_TRACE_POINTS
>  #include <trace/events/context_tracking.h>
> @@ -100,6 +101,8 @@ void noinstr __context_tracking_enter(enum ctx_state state)
>  		__this_cpu_write(context_tracking.state, state);
>  	}
>  	context_tracking_recursion_exit();
> +
> +	task_isolation_exit_to_user_mode();

Why is this here at all and why is it outside of the recursion
protection

>  }
>  EXPORT_SYMBOL_GPL(__context_tracking_enter);
>  
> @@ -148,6 +151,8 @@ void noinstr __context_tracking_exit(enum ctx_state state)
>  	if (!context_tracking_recursion_enter())
>  		return;
>  
> +	task_isolation_kernel_enter();

while this is inside?

And why has the scheduler_ipi() on x86 call this twice? Just because?

>  	if (__this_cpu_read(context_tracking.state) == state) {
>  		if (__this_cpu_read(context_tracking.active)) {
>  			/*
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
>  static void exit_to_user_mode_prepare(struct pt_regs *regs)
>  {
> -	unsigned long ti_work = READ_ONCE(current_thread_info()->flags);
> +	unsigned long ti_work;
>  
>  	lockdep_assert_irqs_disabled();
>  
> +	task_isolation_before_pending_work_check();
> +
> +	ti_work = READ_ONCE(current_thread_info()->flags);
> +
>  	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
>  		ti_work = exit_to_user_mode_loop(regs, ti_work);
>  
> +	if (unlikely(ti_work & _TIF_TASK_ISOLATION))
> +		task_isolation_start();

Where is the explaination of this change?

Aside of that how does anything of this compile on x86 at all?

Answer: It does not ...

Stop this frenzy right now. It's going nowhere and all you achieve is to
make people more grumpy than they are already.

Thanks,

        tglx
