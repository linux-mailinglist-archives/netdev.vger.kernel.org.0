Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7718E4D5
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 22:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgCUVtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 17:49:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39343 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgCUVtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 17:49:46 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFlzN-0001VX-Ok; Sat, 21 Mar 2020 22:49:06 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C8A961040D5; Sat, 21 Mar 2020 22:49:04 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
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
In-Reply-To: <20200321212144.GA6475@google.com>
References: <20200318204302.693307984@linutronix.de> <20200318204408.211530902@linutronix.de> <20200321212144.GA6475@google.com>
Date:   Sat, 21 Mar 2020 22:49:04 +0100
Message-ID: <874kuhqsz3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joel Fernandes <joel@joelfernandes.org> writes:
>> +rwlock_t
>> +========
>> +
>> +rwlock_t is a multiple readers and single writer lock mechanism.
>> +
>> +On a non PREEMPT_RT enabled kernel rwlock_t is implemented as a spinning
>> +lock and the suffix rules of spinlock_t apply accordingly. The
>> +implementation is fair and prevents writer starvation.
>>
>
> You mentioned writer starvation, but I think it would be good to also mention
> that rwlock_t on a non-PREEMPT_RT kernel also does not have _reader_
> starvation problem, since it uses queued implementation.  This fact is worth
> mentioning here, since further below you explain that an rwlock in PREEMPT_RT
> does have reader starvation problem.

It's worth mentioning. But RT really has only write starvation not
reader starvation.

>> +rwlock_t and PREEMPT_RT
>> +-----------------------
>> +
>> +On a PREEMPT_RT enabled kernel rwlock_t is mapped to a separate
>> +implementation based on rt_mutex which changes the semantics:
>> +
>> + - Same changes as for spinlock_t
>> +
>> + - The implementation is not fair and can cause writer starvation under
>> +   certain circumstances. The reason for this is that a writer cannot grant
>> +   its priority to multiple readers. Readers which are blocked on a writer
>> +   fully support the priority inheritance protocol.
>
> Is it hard to give priority to multiple readers because the number of readers
> to give priority to could be unbounded?

Yes, and it's horribly complex and racy. We had an implemetation years
ago which taught us not to try it again :)

>> +PREEMPT_RT also offers a local_lock mechanism to substitute the
>> +local_irq_disable/save() constructs in cases where a separation of the
>> +interrupt disabling and the locking is really unavoidable. This should be
>> +restricted to very rare cases.
>
> It would also be nice to mention where else local_lock() can be used, such as
> protecting per-cpu variables without disabling preemption. Could we add a
> section on protecting per-cpu data? (Happy to do that and send a patch if you
> prefer).

The local lock section will come soon when we post the local lock
patches again.

>> +rwsems have grown interfaces which allow non owner release for special
>> +purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
>> +substitutes all locking primitives except semaphores with RT-mutex based
>> +implementations to provide priority inheritance for all lock types except
>> +the truly spinning ones. Priority inheritance on ownerless locks is
>> +obviously impossible.
>> +
>> +For now the rwsem non-owner release excludes code which utilizes it from
>> +being used on PREEMPT_RT enabled kernels.
>
> I could not parse the last sentence here, but I think you meant "For now,
> PREEMPT_RT enabled kernels disable code that perform a non-owner release of
> an rwsem". Correct me if I'm wrong.

Right, that's what I wanted to say :)

Care to send a delta patch?

Thanks!

        tglx
