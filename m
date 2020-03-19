Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E76318AE82
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSIms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSImr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 04:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9125A20724;
        Thu, 19 Mar 2020 08:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584607367;
        bh=bc6Fify+38nZAY3Cia1aV1OdCk4gn2q4y8vjHO0jHQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tziaOs8nF6qC2ZxtPxDt+NdfWpIrzDmvKzsswJgbGZoj8i6PseYVNTHnVQCWhF3l7
         BlaCfZEzl2+/751CB3Sz2r9W2tBaPF/Ha6955QYPrXbnsfvJrB3QDPo2+ZfG4d0stK
         TebhEBXc4YrP7M09KzptbT9OYlt0nFKptulOurBg=
Date:   Thu, 19 Mar 2020 09:42:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
Message-ID: <20200319084244.GC3492783@kroah.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.521507446@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204408.521507446@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:13PM +0100, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> completion uses a wait_queue_head_t to enqueue waiters.
> 
> wait_queue_head_t contains a spinlock_t to protect the list of waiters
> which excludes it from being used in truly atomic context on a PREEMPT_RT
> enabled kernel.
> 
> The spinlock in the wait queue head cannot be replaced by a raw_spinlock
> because:
> 
>   - wait queues can have custom wakeup callbacks, which acquire other
>     spinlock_t locks and have potentially long execution times
> 
>   - wake_up() walks an unbounded number of list entries during the wake up
>     and may wake an unbounded number of waiters.
> 
> For simplicity and performance reasons complete() should be usable on
> PREEMPT_RT enabled kernels.
> 
> completions do not use custom wakeup callbacks and are usually single
> waiter, except for a few corner cases.
> 
> Replace the wait queue in the completion with a simple wait queue (swait),
> which uses a raw_spinlock_t for protecting the waiter list and therefore is
> safe to use inside truly atomic regions on PREEMPT_RT.
> 
> There is no semantical or functional change:
> 
>   - completions use the exclusive wait mode which is what swait provides
> 
>   - complete() wakes one exclusive waiter
> 
>   - complete_all() wakes all waiters while holding the lock which protects
>     the wait queue against newly incoming waiters. The conversion to swait
>     preserves this behaviour.
> 
> complete_all() might cause unbound latencies with a large number of waiters
> being woken at once, but most complete_all() usage sites are either in
> testing or initialization code or have only a really small number of
> concurrent waiters which for now does not cause a latency problem. Keep it
> simple for now.
> 
> The fixup of the warning check in the USB gadget driver is just a straight
> forward conversion of the lockless waiter check from one waitqueue type to
> the other.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> V2: Split out the orinoco and usb gadget parts and amended change log
> ---
>  drivers/usb/gadget/function/f_fs.c |    2 +-
>  include/linux/completion.h         |    8 ++++----
>  kernel/sched/completion.c          |   36 +++++++++++++++++++-----------------
>  3 files changed, 24 insertions(+), 22 deletions(-)

For USB portion:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
