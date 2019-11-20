Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5486810406A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfKTQNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:13:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:45344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729412AbfKTQNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 11:13:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 290CBB2F16;
        Wed, 20 Nov 2019 16:13:35 +0000 (UTC)
Date:   Wed, 20 Nov 2019 17:13:34 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191120161334.p63723g4jyk6k7p3@pathway.suse.cz>
References: <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
 <20191119004119.GC208047@google.com>
 <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
 <20191120013005.GA3191@tigerII.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120013005.GA3191@tigerII.localdomain>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2019-11-20 10:30:05, Sergey Senozhatsky wrote:
> On (19/11/19 10:41), Petr Mladek wrote:
> [..]
> > > > I do not like this. As a result, normal printk() will always deadlock
> > > > in the scheduler code, including WARN() calls. The chance of the
> > > > deadlock is small now. It happens only when there is another
> > > > process waiting for console_sem.
> > > 
> > > Why would it *always* deadlock? If this is the case, why we don't *always*
> > > deadlock doing the very same wake_up_process() from console_unlock()?
> > 
> > I speak about _normal_ printk() and not about printk_deferred().
> > 
> > wake_up_process() is called in console_unlock() only when
> > sem->wait_list is not empty, see up() in kernel/locking/semaphore.c.
> > printk() itself uses console_trylock() and does not wait.
> 
> > I believe that this is the rason why printk_sched() was added
> > so late in 2012.
> 
> Right. I also think scheduler people do pretty nice work avoiding printk
> calls under ->rq lock.
> 
> What I tried to say - it's really not that hard to have a non-empty
> console_sem ->wait_list, any "wrong" printk() call from scheduler
> will deadlock us, because we have something to wake_up().

I am sorry but I do not take this as an argument that it would be
acceptable to replace irq_work_queue() with wake_up_interruptible().

It is the first time that I hear about problem caused by the
irq_work(). But we deal with deadlocks caused by wake_up() for years.
It would be like replacing a lightly dripping tap with a heavily
dripping one.

I see reports with WARN() from scheduler code from time to time.
I would get reports about silent death instead.

RT guys are going to make printk() fully lockless. It would be
really great achievement. irq_work is lockless. While wake_up()
is not.

There must be a better way how to break the infinite loop caused
by the irq_work.

Best Regards,
Petr
