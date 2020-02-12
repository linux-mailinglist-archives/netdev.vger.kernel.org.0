Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE515AC28
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgBLPlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:41:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:53848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbgBLPlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 10:41:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AD517B004;
        Wed, 12 Feb 2020 15:41:16 +0000 (UTC)
Date:   Wed, 12 Feb 2020 16:41:16 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: Question about kthread_mod_delayed_work() allowed context
Message-ID: <20200212154116.hh2vdyi7e2xflxr5@pathway.suse.cz>
References: <cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2020-02-11 12:23:59, Grygorii Strashko wrote:
> Hi All,
> 
> I'd like to ask question about allowed calling context for kthread_mod_delayed_work().
> 
> The comment to kthread_mod_delayed_work() says:
> 
>  * This function is safe to call from any context including IRQ handler.
>  * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
>  * for details.
>  */
> 
> But it has del_timer_sync() inside which seems can't be called from hard_irq context:
> kthread_mod_delayed_work()
>   |-__kthread_cancel_work()
>      |- del_timer_sync()
> 	|- WARN_ON(in_irq() && !(timer->flags & TIMER_IRQSAFE));

It is safe because kthread_delayed_work_timer_fn() is IRQ safe.
Note that it uses raw_spin_lock_irqsave(). It is the reason why
the timer could have set TIMER_IRQSAFE flag, see
KTHREAD_DELAYED_WORK_INIT().

In more details. The timer is either canceled before the callback
is called. Or it waits for the callback but the callback is safe
because it can't sleep.


> My use case is related to PTP processing using PTP auxiliary worker:
> (commit d9535cb7b760 ("ptp: introduce ptp auxiliary worker")):
>  - periodic work A is started and res-schedules itself for every dtX
>  - on IRQ - the work A need to be scheduled immediately

This is exactly where kthread_mod_delayed_work() need to be used
in the IRQ context with 0 delay.


> Any advice on how to proceed?
> Can kthread_queue_work() be used even if there is delayed work is
> scheduled already (in general, don't care if work A will be executed one
> more time after timer expiration)?

Yes, it can be used this way. It should behave the same way as
the workqueue API.

I am happy that there are more users for this API. I wanted to
convert more kthreads but it was just falling down in my TODO.

I hope that I answered all questions. Feel free to ask more
when in doubts.

Best Regards,
Petr
