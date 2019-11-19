Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46810102109
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfKSJlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:41:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:51456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727336AbfKSJlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 04:41:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E917CB28C;
        Tue, 19 Nov 2019 09:41:34 +0000 (UTC)
Date:   Tue, 19 Nov 2019 10:41:34 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
References: <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
 <20191119004119.GC208047@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119004119.GC208047@google.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2019-11-19 09:41:19, Sergey Senozhatsky wrote:
> On (19/11/18 16:27), Petr Mladek wrote:
> > > > @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > > >  	pending_output = (curr_log_seq != log_next_seq);
> > > >  	logbuf_unlock_irqrestore(flags);
> > > >  
> > > > +	if (!pending_output)
> > > > +		return printed_len;
> > > > +
> > > >  	/* If called from the scheduler, we can not call up(). */
> > > > -	if (!in_sched && pending_output) {
> > > > +	if (!in_sched) {
> > > >  		/*
> > > >  		 * Disable preemption to avoid being preempted while holding
> > > >  		 * console_sem which would prevent anyone from printing to
> > > > @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> > > >  		if (console_trylock_spinning())
> > > >  			console_unlock();
> > > >  		preempt_enable();
> > > > -	}
> > > >  
> > > > -	if (pending_output)
> > > > +		wake_up_interruptible(&log_wait);
> > 
> > I do not like this. As a result, normal printk() will always deadlock
> > in the scheduler code, including WARN() calls. The chance of the
> > deadlock is small now. It happens only when there is another
> > process waiting for console_sem.
> 
> Why would it *always* deadlock? If this is the case, why we don't *always*
> deadlock doing the very same wake_up_process() from console_unlock()?

I speak about _normal_ printk() and not about printk_deferred().

wake_up_process() is called in console_unlock() only when
sem->wait_list is not empty, see up() in kernel/locking/semaphore.c.
printk() itself uses console_trylock() and does not wait.

I believe that this is the rason why printk_sched() was added
so late in 2012. It was more than 10 years after adding
the semaphore into console_unlock(). IMHO, the deadlock
was rare. Of course, it was also hard to debug but it
would not take 10 years.

Best Regards,
Petr
