Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2D381025
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhENS6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhENS6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 14:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F045C6144B;
        Fri, 14 May 2021 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621018610;
        bh=pipED4GhgVWqiRoaEE0cFFAtXnXSrN04hJirWHLSggo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bLrB56YiWkUUkQtzel5P165cdYrUsaeMJHIbwnzdxeIlimLQQoJ+9lbaibfAXxaOm
         uJXQbPbFaD1rh2AxSxqw13Fkqa116WCE2oKd2fQwJeNYtNMs5Gx60ZN7Gt5mawL1tE
         GRkCUIRR7THIqnG38yMIJKPX7TuaXNdWu5XwUBz3rJ4chBBm5ymglkGXUYxYRy3/HK
         Q7KFsPI/vpQ1P20LwHdaEwSJqfe6tCnBLjtD7Hjj+2sZctfanuwtI7yEKExeUVZmIZ
         dhuZuXlu90oXGb+Jwj3tja54f7MkeFkFeVusHMkf2lNNw2LVWRrSULSprRpATb5Ep7
         YUq+qaRQfebJg==
Date:   Fri, 14 May 2021 11:56:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>, stable-rt@vger.kernel.org
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
Message-ID: <20210514115649.6c84fdc3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87k0o360zx.ffs@nanos.tec.linutronix.de>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
        <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
        <87k0o360zx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 00:28:02 +0200 Thomas Gleixner wrote:
> On Wed, May 12 2021 at 23:43, Sebastian Andrzej Siewior wrote:
> > __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> > which can be used where it is known that interrupts are disabled,
> > e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> > callbacks.
> >
> > On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> > threaded interrupt handlers and spinlocks are not disabling interrupts
> > and the NAPI hrtimer callback is forced into softirq context which runs
> > with interrupts enabled as well.
> >
> > Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
> > game so make __napi_schedule_irqoff() invoke __napi_schedule() for
> > PREEMPT_RT kernels.
> >
> > The callers of ____napi_schedule() in the networking core have been
> > audited and are correct on PREEMPT_RT kernels as well.
> >
> > Reported-by: Juri Lelli <juri.lelli@redhat.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>  
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> > ---
> > Alternatively __napi_schedule_irqoff() could be #ifdef'ed out on RT and
> > an inline provided which invokes __napi_schedule().
> >
> > This was not chosen as it creates #ifdeffery all over the place and with
> > the proposed solution the code reflects the documentation consistently
> > and in one obvious place.  
> 
> Blame me for that decision.
> 
> No matter which variant we end up with, this needs to go into all stable
> RT kernels ASAP.

Mumble mumble. I thought we concluded that drivers used on RT can be
fixed, we've already done it for a couple drivers (by which I mean two).
If all the IRQ handler is doing is scheduling NAPI (which it is for
modern NICs) - IRQF_NO_THREAD seems like the right option.

Is there any driver you care about that we can convert to using
IRQF_NO_THREAD so we can have new drivers to "do the right thing"
while the old ones depend on this workaround for now?


Another thing while I have your attention - ____napi_schedule() does
__raise_softirq_irqoff() which AFAIU does not wake the ksoftirq thread.
On non-RT we get occasional NOHZ warnings when drivers schedule napi
from process context, but on RT this is even more of a problem, right?
ksoftirqd won't run until something else actually wakes it up?
