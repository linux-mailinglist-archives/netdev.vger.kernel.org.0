Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B2618DDA1
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 03:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgCUC3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 22:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCUC3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 22:29:31 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2952B2072D;
        Sat, 21 Mar 2020 02:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584757771;
        bh=cx0T7j4Rw8DmtudaxpEVF5LLRRX3FTiCAV1kPl7Nbgc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=1kXb4KEWo2dzCCzN7/6klHda+1PJHiAUGD5QuqlYfAOdT7fYlhmYaBMMtTuy/WNZN
         ECiV3hXYdLV0vb5/erVarifnSX6rfZroo+HOqk7zb9SGh8nx4anjDrE1g+i0bZAwHB
         pzevk+XrUrbjAD4JQ5Js8pF94X/E75fBizrexOo8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id E979835226B5; Fri, 20 Mar 2020 19:29:30 -0700 (PDT)
Date:   Fri, 20 Mar 2020 19:29:30 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200321022930.GU3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200320160145.GN3199@paulmck-ThinkPad-P72>
 <87mu8apzxr.fsf@nanos.tec.linutronix.de>
 <20200320210243.GT3199@paulmck-ThinkPad-P72>
 <874kuipsbw.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kuipsbw.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 11:36:03PM +0100, Thomas Gleixner wrote:
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> > On Fri, Mar 20, 2020 at 08:51:44PM +0100, Thomas Gleixner wrote:
> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
> >> >
> >> >  - The soft interrupt related suffix (_bh()) still disables softirq
> >> >    handlers.  However, unlike non-PREEMPT_RT kernels (which disable
> >> >    preemption to get this effect), PREEMPT_RT kernels use a per-CPU
> >> >    lock to exclude softirq handlers.
> >> 
> >> I've made that:
> >> 
> >>   - The soft interrupt related suffix (_bh()) still disables softirq
> >>     handlers.
> >> 
> >>     Non-PREEMPT_RT kernels disable preemption to get this effect.
> >> 
> >>     PREEMPT_RT kernels use a per-CPU lock for serialization. The lock
> >>     disables softirq handlers and prevents reentrancy by a preempting
> >>     task.
> >
> > That works!  At the end, I would instead say "prevents reentrancy
> > due to task preemption", but what you have works.
> 
> Yours is better.
> 
> >>    - Task state is preserved across spinlock acquisition, ensuring that the
> >>      task-state rules apply to all kernel configurations.  Non-PREEMPT_RT
> >>      kernels leave task state untouched.  However, PREEMPT_RT must change
> >>      task state if the task blocks during acquisition.  Therefore, it
> >>      saves the current task state before blocking and the corresponding
> >>      lock wakeup restores it. A regular not lock related wakeup sets the
> >>      task state to RUNNING. If this happens while the task is blocked on
> >>      a spinlock then the saved task state is changed so that correct
> >>      state is restored on lock wakeup.
> >> 
> >> Hmm?
> >
> > I of course cannot resist editing the last two sentences:
> >
> >    ... Other types of wakeups unconditionally set task state to RUNNING.
> >    If this happens while a task is blocked while acquiring a spinlock,
> >    then the task state is restored to its pre-acquisition value at
> >    lock-wakeup time.
> 
> Errm no. That would mean
> 
>      state = UNINTERRUPTIBLE
>      lock()
>        block()
>          real_state = state
>          state = SLEEPONLOCK
> 
>                                non lock wakeup
>                                  state = RUNNING    <--- FAIL #1
> 
>                                lock wakeup
>                                  state = real_state <--- FAIL #2
> 
> How it works is:
> 
>      state = UNINTERRUPTIBLE
>      lock()
>        block()
>          real_state = state
>          state = SLEEPONLOCK
> 
>                                non lock wakeup
>                                  real_state = RUNNING
> 
>                                lock wakeup
>                                  state = real_state == RUNNING
> 
> If there is no 'non lock wakeup' before the lock wakeup:
> 
>      state = UNINTERRUPTIBLE
>      lock()
>        block()
>          real_state = state
>          state = SLEEPONLOCK
> 
>                                lock wakeup
>                                  state = real_state == UNINTERRUPTIBLE
> 
> I agree that what I tried to express is hard to parse, but it's at least
> halfways correct :)

Apologies!  That is what I get for not looking it up in the source.  :-/

OK, so I am stupid enough not only to get it wrong, but also to try again:

   ... Other types of wakeups would normally unconditionally set the
   task state to RUNNING, but that does not work here because the task
   must remain blocked until the lock becomes available.  Therefore,
   when a non-lock wakeup attempts to awaken a task blocked waiting
   for a spinlock, it instead sets the saved state to RUNNING.  Then,
   when the lock acquisition completes, the lock wakeup sets the task
   state to the saved state, in this case setting it to RUNNING.

Is that better?

							Thanx, Paul
