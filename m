Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6319018C96F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCTJCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:02:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:45570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCTJCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 05:02:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 60CA0AECE;
        Fri, 20 Mar 2020 09:02:12 +0000 (UTC)
Date:   Fri, 20 Mar 2020 02:01:06 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
Message-ID: <20200320090106.6p2lwqvs4jedhvds@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.521507446@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200318204408.521507446@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020, Thomas Gleixner wrote:

>From: Thomas Gleixner <tglx@linutronix.de>
>
>completion uses a wait_queue_head_t to enqueue waiters.
>
>wait_queue_head_t contains a spinlock_t to protect the list of waiters
>which excludes it from being used in truly atomic context on a PREEMPT_RT
>enabled kernel.
>
>The spinlock in the wait queue head cannot be replaced by a raw_spinlock
>because:
>
>  - wait queues can have custom wakeup callbacks, which acquire other
>    spinlock_t locks and have potentially long execution times
>
>  - wake_up() walks an unbounded number of list entries during the wake up
>    and may wake an unbounded number of waiters.
>
>For simplicity and performance reasons complete() should be usable on
>PREEMPT_RT enabled kernels.
>
>completions do not use custom wakeup callbacks and are usually single
>waiter, except for a few corner cases.
>
>Replace the wait queue in the completion with a simple wait queue (swait),
>which uses a raw_spinlock_t for protecting the waiter list and therefore is
>safe to use inside truly atomic regions on PREEMPT_RT.
>
>There is no semantical or functional change:
>
>  - completions use the exclusive wait mode which is what swait provides
>
>  - complete() wakes one exclusive waiter
>
>  - complete_all() wakes all waiters while holding the lock which protects
>    the wait queue against newly incoming waiters. The conversion to swait
>    preserves this behaviour.
>
>complete_all() might cause unbound latencies with a large number of waiters
>being woken at once, but most complete_all() usage sites are either in
>testing or initialization code or have only a really small number of
>concurrent waiters which for now does not cause a latency problem. Keep it
>simple for now.
>
>The fixup of the warning check in the USB gadget driver is just a straight
>forward conversion of the lockless waiter check from one waitqueue type to
>the other.
>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
