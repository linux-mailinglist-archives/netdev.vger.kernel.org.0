Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A692CBEEF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgLBOBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 09:01:11 -0500
Received: from foss.arm.com ([217.140.110.172]:40644 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgLBOBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 09:01:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 397B530E;
        Wed,  2 Dec 2020 06:00:09 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.23.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C523E3F718;
        Wed,  2 Dec 2020 06:00:04 -0800 (PST)
Date:   Wed, 2 Dec 2020 13:59:57 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] task_isolation: arch/arm64: enable task isolation
 functionality
Message-ID: <20201202135957.GA66958@C02TD0UTHF1T.local>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <91496c0cf8d24717a2641fc4d02063f3f10dc733.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91496c0cf8d24717a2641fc4d02063f3f10dc733.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Mon, Nov 23, 2020 at 05:58:06PM +0000, Alex Belits wrote:
> In do_notify_resume(), call task_isolation_before_pending_work_check()
> first, to report isolation breaking, then after handling all pending
> work, call task_isolation_start() for TIF_TASK_ISOLATION tasks.
> 
> Add _TIF_TASK_ISOLATION to _TIF_WORK_MASK, and _TIF_SYSCALL_WORK,
> define local NOTIFY_RESUME_LOOP_FLAGS to check in the loop, since we
> don't clear _TIF_TASK_ISOLATION in the loop.
> 
> Early kernel entry code calls task_isolation_kernel_enter(). In
> particular:
> 
> Vectors:
> el1_sync -> el1_sync_handler() -> task_isolation_kernel_enter()
> el1_irq -> asm_nmi_enter(), handle_arch_irq()
> el1_error -> do_serror()
> el0_sync -> el0_sync_handler()
> el0_irq -> handle_arch_irq()
> el0_error -> do_serror()
> el0_sync_compat -> el0_sync_compat_handler()
> el0_irq_compat -> handle_arch_irq()
> el0_error_compat -> do_serror()
> 
> SDEI entry:
> __sdei_asm_handler -> __sdei_handler() -> nmi_enter()

As a heads-up, the arm64 entry code is changing, as we found that our
lockdep, RCU, and context-tracking management wasn't quite right. I have
a series of patches:

  https://lore.kernel.org/r/20201130115950.22492-1-mark.rutland@arm.com

... which are queued in the arm64 for-next/fixes branch. I intend to
have some further rework ready for the next cycle. I'd appreciate if you
could Cc me on any patches altering the arm64 entry code, as I have a
vested interest.

That was quite obviously broken if PROVE_LOCKING and NO_HZ_FULL were
chosen and context tracking was in use (e.g. with
CONTEXT_TRACKING_FORCE), so I'm assuming that this series has not been
tested in that configuration. What sort of testing has this seen?

It would be very helpful for the next posting if you could provide any
instructions on how to test this series (e.g. with pointers to any test
suite that you have), since it's very easy to introduce subtle breakage
in this area without realising it.

> 
> Functions called from there:
> asm_nmi_enter() -> nmi_enter() -> task_isolation_kernel_enter()
> asm_nmi_exit() -> nmi_exit() -> task_isolation_kernel_return()
> 
> Handlers:
> do_serror() -> nmi_enter() -> task_isolation_kernel_enter()
>   or task_isolation_kernel_enter()
> el1_sync_handler() -> task_isolation_kernel_enter()
> el0_sync_handler() -> task_isolation_kernel_enter()
> el0_sync_compat_handler() -> task_isolation_kernel_enter()
> 
> handle_arch_irq() is irqchip-specific, most call handle_domain_irq()
> There is a separate patch for irqchips that do not follow this rule.
> 
> handle_domain_irq() -> task_isolation_kernel_enter()
> do_handle_IPI() -> task_isolation_kernel_enter() (may be redundant)
> nmi_enter() -> task_isolation_kernel_enter()

The IRQ cases look very odd to me. With the rework I've just done for
arm64, we'll do the regular context tracking accounting before we ever
get into handle_domain_irq() or similar, so I suspect that's not
necessary at all?

> 
> Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
> [abelits@marvell.com: simplified to match kernel 5.10]
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/barrier.h     |  1 +
>  arch/arm64/include/asm/thread_info.h |  7 +++++--
>  arch/arm64/kernel/entry-common.c     |  7 +++++++
>  arch/arm64/kernel/ptrace.c           | 10 ++++++++++
>  arch/arm64/kernel/signal.c           | 13 ++++++++++++-
>  arch/arm64/kernel/smp.c              |  3 +++
>  7 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1515f6f153a0..fc958d8d8945 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -141,6 +141,7 @@ config ARM64
>  	select HAVE_ARCH_PREL32_RELOCATIONS
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
> +	select HAVE_ARCH_TASK_ISOLATION
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
> index c3009b0e5239..ad5a6dd380cf 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -49,6 +49,7 @@
>  #define dma_rmb()	dmb(oshld)
>  #define dma_wmb()	dmb(oshst)
>  
> +#define instr_sync()	isb()

I think I've asked on prior versions of the patchset, but what is this
for? Where is it going to be used, and what is the expected semantics?
I'm wary of exposing this outside of arch code because there aren't
strong cross-architectural semantics, and at the least this requires
some documentation.

If it's unused, please delete it.

[...]

> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
> index 43d4c329775f..8152760de683 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
> @@ -8,6 +8,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/ptrace.h>
>  #include <linux/thread_info.h>
> +#include <linux/isolation.h>
>  
>  #include <asm/cpufeature.h>
>  #include <asm/daifflags.h>
> @@ -77,6 +78,8 @@ asmlinkage void notrace el1_sync_handler(struct pt_regs *regs)
>  {
>  	unsigned long esr = read_sysreg(esr_el1);
>  
> +	task_isolation_kernel_enter();

For regular context tracking we only acount the user<->kernel
transitions.

This is a kernel->kernel transition, so surely this is not necessary?

If nothing else, it doesn't feel well-balanced.

I havwe not looked at the rest of this patch (or series) in detail.

Thanks,
Mark.
