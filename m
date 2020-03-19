Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED1B18A9EF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCSApN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:45:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59198 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSApM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 20:45:12 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEjIR-0005E3-Fd; Thu, 19 Mar 2020 01:44:27 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id CFC0A103088; Thu, 19 Mar 2020 01:44:26 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
In-Reply-To: <20200319003351.GA211584@google.com>
References: <20200318204302.693307984@linutronix.de> <20200318204408.521507446@linutronix.de> <20200319003351.GA211584@google.com>
Date:   Thu, 19 Mar 2020 01:44:26 +0100
Message-ID: <87a74ddvh1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joel,

Joel Fernandes <joel@joelfernandes.org> writes:
> On Wed, Mar 18, 2020 at 09:43:13PM +0100, Thomas Gleixner wrote:
>> The spinlock in the wait queue head cannot be replaced by a raw_spinlock
>> because:
>> 
>>   - wait queues can have custom wakeup callbacks, which acquire other
>>     spinlock_t locks and have potentially long execution times
>
> Cool, makes sense.
>
>>   - wake_up() walks an unbounded number of list entries during the wake up
>>     and may wake an unbounded number of waiters.
>
> Just to clarify here, wake_up() will really wake up just 1 waiter if all the
> waiters on the queue are exclusive right? So in such scenario at least, the
> "unbounded number of waiters" would not be an issue if everything waiting was
> exclusive and waitqueue with wake_up() was used. Please correct me if I'm
> wrong about that though.

Correct.

> So the main reasons to avoid waitqueue in favor of swait (as you mentioned)
> would be the sleep-while-atomic issue in truly atomic context on RT, and the
> fact that callbacks can take a long time.

Yes.

Thanks,

        tglx

