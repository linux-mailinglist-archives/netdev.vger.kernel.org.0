Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8B1ABB88
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392106AbfIFOzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:55:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:58132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfIFOzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:55:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 79BDCAC67;
        Fri,  6 Sep 2019 14:55:34 +0000 (UTC)
Date:   Fri, 6 Sep 2019 16:55:33 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Qian Cai <cai@lca.pw>,
        davem@davemloft.net, Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906145533.4uw43a5pvsawmdov@pathway.suse.cz>
References: <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905113208.GA521@jagdpanzerIV>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2019-09-05 20:32:08, Sergey Senozhatsky wrote:
> On (09/04/19 16:42), Qian Cai wrote:
> > > Let me think more.
> > 
> > To summary, those look to me are all good long-term improvement that would
> > reduce the likelihood of this kind of livelock in general especially for other
> > unknown allocations that happen while processing softirqs, but it is still up to
> > the air if it fixes it 100% in all situations as printk() is going to take more
> > time
> 
> Well. So. I guess that we don't need irq_work most of the time.
> 
> We need to queue irq_work for "safe" wake_up_interruptible(), when we
> know that we can deadlock in scheduler. IOW, only when we are invoked
> from the scheduler. Scheduler has printk_deferred(), which tells printk()
> that it cannot do wake_up_interruptible(). Otherwise we can just use
> normal wake_up_process() and don't need that irq_work->wake_up_interruptible()
> indirection. The parts of the scheduler, which by mistake call plain printk()
> from under pi_lock or rq_lock have chances to deadlock anyway and should
> be switched to printk_deferred().
> 
> I think we can queue significantly much less irq_work-s from printk().
> 
> Petr, Steven, what do you think?
> 
> Something like this. Call wake_up_interruptible(), switch to
> wake_up_klogd() only when called from sched code.

Replacing irq_work_queue() with wake_up_interruptible() looks
dangerous to me.

As a result, all "normal" printk() calls from the scheduler
code will deadlock. There is almost always a userspace
logger registered.

By "normal" I mean anything that is not printk_deferred(). For
example, any WARN() from sheduler will cause a deadlock.
We will not even have chance to catch these problems in
advance by lockdep.

The difference is that console_unlock() calls wake_up_process()
only when there is a waiter. And the hard console_lock() is not
called that often.


Honestly, scheduling IRQ looks like the most lightweight and reliable
solution for offloading. We are in big troubles if we could not use
it in printk() code.

IMHO, the best solution is to ratelimit the warnings about the
allocation failures. It does not make sense to repeat the same
warning again and again. We might need a better ratelimiting API
if the current one is not reliable.

Best Regards,
Petr
