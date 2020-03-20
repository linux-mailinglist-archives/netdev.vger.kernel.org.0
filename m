Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA918DB3B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCTWgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:36:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37622 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgCTWgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 18:36:35 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFQFI-0005GA-2c; Fri, 20 Mar 2020 23:36:04 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7EC4C1039FC; Fri, 20 Mar 2020 23:36:03 +0100 (CET)
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
In-Reply-To: <20200320210243.GT3199@paulmck-ThinkPad-P72>
References: <20200320160145.GN3199@paulmck-ThinkPad-P72> <87mu8apzxr.fsf@nanos.tec.linutronix.de> <20200320210243.GT3199@paulmck-ThinkPad-P72>
Date:   Fri, 20 Mar 2020 23:36:03 +0100
Message-ID: <874kuipsbw.fsf@nanos.tec.linutronix.de>
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
> On Fri, Mar 20, 2020 at 08:51:44PM +0100, Thomas Gleixner wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >
>> >  - The soft interrupt related suffix (_bh()) still disables softirq
>> >    handlers.  However, unlike non-PREEMPT_RT kernels (which disable
>> >    preemption to get this effect), PREEMPT_RT kernels use a per-CPU
>> >    lock to exclude softirq handlers.
>> 
>> I've made that:
>> 
>>   - The soft interrupt related suffix (_bh()) still disables softirq
>>     handlers.
>> 
>>     Non-PREEMPT_RT kernels disable preemption to get this effect.
>> 
>>     PREEMPT_RT kernels use a per-CPU lock for serialization. The lock
>>     disables softirq handlers and prevents reentrancy by a preempting
>>     task.
>
> That works!  At the end, I would instead say "prevents reentrancy
> due to task preemption", but what you have works.

Yours is better.

>>    - Task state is preserved across spinlock acquisition, ensuring that the
>>      task-state rules apply to all kernel configurations.  Non-PREEMPT_RT
>>      kernels leave task state untouched.  However, PREEMPT_RT must change
>>      task state if the task blocks during acquisition.  Therefore, it
>>      saves the current task state before blocking and the corresponding
>>      lock wakeup restores it. A regular not lock related wakeup sets the
>>      task state to RUNNING. If this happens while the task is blocked on
>>      a spinlock then the saved task state is changed so that correct
>>      state is restored on lock wakeup.
>> 
>> Hmm?
>
> I of course cannot resist editing the last two sentences:
>
>    ... Other types of wakeups unconditionally set task state to RUNNING.
>    If this happens while a task is blocked while acquiring a spinlock,
>    then the task state is restored to its pre-acquisition value at
>    lock-wakeup time.

Errm no. That would mean

     state = UNINTERRUPTIBLE
     lock()
       block()
         real_state = state
         state = SLEEPONLOCK

                               non lock wakeup
                                 state = RUNNING    <--- FAIL #1

                               lock wakeup
                                 state = real_state <--- FAIL #2

How it works is:

     state = UNINTERRUPTIBLE
     lock()
       block()
         real_state = state
         state = SLEEPONLOCK

                               non lock wakeup
                                 real_state = RUNNING

                               lock wakeup
                                 state = real_state == RUNNING

If there is no 'non lock wakeup' before the lock wakeup:

     state = UNINTERRUPTIBLE
     lock()
       block()
         real_state = state
         state = SLEEPONLOCK

                               lock wakeup
                                 state = real_state == UNINTERRUPTIBLE

I agree that what I tried to express is hard to parse, but it's at least
halfways correct :)

Thanks,

        tglx
