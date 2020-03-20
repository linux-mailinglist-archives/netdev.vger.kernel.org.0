Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCFD18D8BB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCTTwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:52:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37003 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCTTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:52:30 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFNgI-0002w2-14; Fri, 20 Mar 2020 20:51:46 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 626F61039FC; Fri, 20 Mar 2020 20:51:44 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting documentation
In-Reply-To: <20200320160145.GN3199@paulmck-ThinkPad-P72>
Date:   Fri, 20 Mar 2020 20:51:44 +0100
Message-ID: <87mu8apzxr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:
>
>  - The soft interrupt related suffix (_bh()) still disables softirq
>    handlers.  However, unlike non-PREEMPT_RT kernels (which disable
>    preemption to get this effect), PREEMPT_RT kernels use a per-CPU
>    lock to exclude softirq handlers.

I've made that:

  - The soft interrupt related suffix (_bh()) still disables softirq
    handlers.

    Non-PREEMPT_RT kernels disable preemption to get this effect.

    PREEMPT_RT kernels use a per-CPU lock for serialization. The lock
    disables softirq handlers and prevents reentrancy by a preempting
    task.
    
On non-RT this is implicit through preemption disable, but it's non
obvious for RT as preemption stays enabled.

> PREEMPT_RT kernels preserve all other spinlock_t semantics:
>
>  - Tasks holding a spinlock_t do not migrate.  Non-PREEMPT_RT kernels
>    avoid migration by disabling preemption.  PREEMPT_RT kernels instead
>    disable migration, which ensures that pointers to per-CPU variables
>    remain valid even if the task is preempted.
>
>  - Task state is preserved across spinlock acquisition, ensuring that the
>    task-state rules apply to all kernel configurations.  In non-PREEMPT_RT
>    kernels leave task state untouched.  However, PREEMPT_RT must change
>    task state if the task blocks during acquisition.  Therefore, the
>    corresponding lock wakeup restores the task state.  Note that regular
>    (not lock related) wakeups do not restore task state.

   - Task state is preserved across spinlock acquisition, ensuring that the
     task-state rules apply to all kernel configurations.  Non-PREEMPT_RT
     kernels leave task state untouched.  However, PREEMPT_RT must change
     task state if the task blocks during acquisition.  Therefore, it
     saves the current task state before blocking and the corresponding
     lock wakeup restores it. A regular not lock related wakeup sets the
     task state to RUNNING. If this happens while the task is blocked on
     a spinlock then the saved task state is changed so that correct
     state is restored on lock wakeup.

Hmm?

> But this code failes on PREEMPT_RT kernels because the memory allocator
> is fully preemptible and therefore cannot be invoked from truly atomic
> contexts.  However, it is perfectly fine to invoke the memory allocator
> while holding a normal non-raw spinlocks because they do not disable
> preemption::
>
>> +  spin_lock(&lock);
>> +  p = kmalloc(sizeof(*p), GFP_ATOMIC);
>> +
>> +Most places which use GFP_ATOMIC allocations are safe on PREEMPT_RT as the
>> +execution is forced into thread context and the lock substitution is
>> +ensuring preemptibility.
>
> Interestingly enough, most uses of GFP_ATOMIC allocations are
> actually safe on PREEMPT_RT because the the lock substitution ensures
> preemptibility.  Only those GFP_ATOMIC allocations that are invoke
> while holding a raw spinlock or with preemption otherwise disabled need
> adjustment to work correctly on PREEMPT_RT.
>
> [ I am not as confident of the above as I would like to be... ]

I'd leave that whole paragraph out. This documents the rules and from
the above code examples it's pretty clear what works and what not :)

> And meeting time, will continue later!

Enjoy!

Thanks,

        tglx
