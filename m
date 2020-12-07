Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E142D0FD2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgLGL6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:58:08 -0500
Received: from foss.arm.com ([217.140.110.172]:48514 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgLGL6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 06:58:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0D011042;
        Mon,  7 Dec 2020 03:57:21 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.27.106])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 420573F718;
        Mon,  7 Dec 2020 03:57:17 -0800 (PST)
Date:   Mon, 7 Dec 2020 11:57:14 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alex Belits <abelits@marvell.com>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 6/9] task_isolation: arch/arm64: enable task
 isolation functionality
Message-ID: <20201207115714.GB18365@C02TD0UTHF1T.local>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <91496c0cf8d24717a2641fc4d02063f3f10dc733.camel@marvell.com>
 <20201202135957.GA66958@C02TD0UTHF1T.local>
 <9dee82d9f9af4fd8a6b8226f4ed190efeb24d5c5.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dee82d9f9af4fd8a6b8226f4ed190efeb24d5c5.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:37:32AM +0000, Alex Belits wrote:
> On Wed, 2020-12-02 at 13:59 +0000, Mark Rutland wrote:
> > On Mon, Nov 23, 2020 at 05:58:06PM +0000, Alex Belits wrote:

> > As a heads-up, the arm64 entry code is changing, as we found that
> > our lockdep, RCU, and context-tracking management wasn't quite
> > right. I have a series of patches:
> > 
> > https://lore.kernel.org/r/20201130115950.22492-1-mark.rutland@arm.com
> > 
> > ... which are queued in the arm64 for-next/fixes branch. I intend to
> > have some further rework ready for the next cycle.

> > That was quite obviously broken if PROVE_LOCKING and NO_HZ_FULL were
> > chosen and context tracking was in use (e.g. with
> > CONTEXT_TRACKING_FORCE),
> 
> I am not yet sure about TRACE_IRQFLAGS, however NO_HZ_FULL and
> CONTEXT_TRACKING have to be enabled for it to do anything.
> 
> I will check it with PROVE_LOCKING and your patches.
	
Thanks. In future, please do test this functionality with PROVE_LOCKING,
because otherwise bugs with RCU and IRQ state maangement will easily be
missed (as has been the case until very recently).

Testing with all those debug optiosn enabled (and stating that you have
done so) will give reviuewers much greater confidence that this works,
and if that does start spewing errors it save everyone the time
identifying that.

> Entry code only adds an inline function that, if task isolation is
> enabled, uses raw_local_irq_save() / raw_local_irq_restore(), low-level 
> operations and accesses per-CPU variabled by offset, so at very least
> it should not add any problems. Even raw_local_irq_save() /
> raw_local_irq_restore() probably should be removed, however I wanted to
> have something that can be safely called if by whatever reason
> interrupts were enabled before kernel was fully entered.

Sure. In the new flows we have new enter_from_*() and exit_to_*()
functions where these calls should be able to live (and so we should be
able to ensure a more consistent environment).

The near-term plan for arm64 is to migrate more of the exception triage
assembly to C, then to rework the arm64 entry code and generic entry
code to be more similar, then to migrate as much as possible to the
generic entry code. So please bear in mind that anything that adds to
the differences between the two is goingf to be problematic.

> >  so I'm assuming that this series has not been
> > tested in that configuration. What sort of testing has this seen?
> 
> On various available arm64 hardware, with enabled
> 
> CONFIG_TASK_ISOLATION
> CONFIG_NO_HZ_FULL
> CONFIG_HIGH_RES_TIMERS
> 
> and disabled:
> 
> CONFIG_HZ_PERIODIC
> CONFIG_NO_HZ_IDLE
> CONFIG_NO_HZ

Ok. I'd recommend looking at the various debug options under the "kernel
hacking" section in kconfig, and enabling some of those. At the very
least PROVE_LOCKING, ideally also using the lockup dectors and anything
else for debugging RCU, etc.

[...]

> > > Functions called from there:
> > > asm_nmi_enter() -> nmi_enter() -> task_isolation_kernel_enter()
> > > asm_nmi_exit() -> nmi_exit() -> task_isolation_kernel_return()
> > > 
> > > Handlers:
> > > do_serror() -> nmi_enter() -> task_isolation_kernel_enter()
> > >   or task_isolation_kernel_enter()
> > > el1_sync_handler() -> task_isolation_kernel_enter()
> > > el0_sync_handler() -> task_isolation_kernel_enter()
> > > el0_sync_compat_handler() -> task_isolation_kernel_enter()
> > > 
> > > handle_arch_irq() is irqchip-specific, most call
> > > handle_domain_irq()
> > > There is a separate patch for irqchips that do not follow this
> > > rule.
> > > 
> > > handle_domain_irq() -> task_isolation_kernel_enter()
> > > do_handle_IPI() -> task_isolation_kernel_enter() (may be redundant)
> > > nmi_enter() -> task_isolation_kernel_enter()
> > 
> > The IRQ cases look very odd to me. With the rework I've just done
> > for arm64, we'll do the regular context tracking accounting before
> > we ever get into handle_domain_irq() or similar, so I suspect that's
> > not necessary at all?
> 
> The goal is to call task_isolation_kernel_enter() before anything that
> depends on a CPU state, including pipeline, that could remain un-
> synchronized when the rest of the kernel was sending synchronization
> IPIs. Similarly task_isolation_kernel_return() should be called when it
> is safe to turn off synchronization. If rework allows it to be done
> earlier, there is no need to touch more specific functions.

Sure; I think that's sorted as a result of the changes I made recently.

> 
> > --- a/arch/arm64/include/asm/barrier.h
> > > +++ b/arch/arm64/include/asm/barrier.h
> > > @@ -49,6 +49,7 @@
> > >  #define dma_rmb()	dmb(oshld)
> > >  #define dma_wmb()	dmb(oshst)
> > >  
> > > +#define instr_sync()	isb()
> > 
> > I think I've asked on prior versions of the patchset, but what is
> > this for? Where is it going to be used, and what is the expected
> > semantics?  I'm wary of exposing this outside of arch code because
> > there aren't strong cross-architectural semantics, and at the least
> > this requires some documentation.
> 
> This is intended as an instruction pipeline flush for the situation
> when arch-independent code has to synchronize with potential changes
> that it missed. This is necessary after some other CPUs could modify
> code (and send IPIs to notify the rest but not isolated CPU) while this
> one was still running isolated task or, more likely, exiting from it,
> so it might be unlucky enough to pick the old instructions before that
> point.
> 
> It's only used on kernel entry.

Sure. My point is that instr_sync() is a very generic sounding name
that doesn't get any of that across, and it's entirely undocumented.

I think something like arch_simulate_kick_cpu() would be better to get
the intended semantic across, and we should add thorough documentation
somewhere as to what this is meant to do.

Thanks,
Mark.
