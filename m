Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7230ABC8C
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394838AbfIFPcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:32:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfIFPcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 11:32:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22975AD69;
        Fri,  6 Sep 2019 15:32:10 +0000 (UTC)
Date:   Fri, 6 Sep 2019 17:32:09 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, davem@davemloft.net,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906153209.ugkeuaespn2q5yix@pathway.suse.cz>
References: <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <20190905132334.52b13d95@oasis.local.home>
 <20190906033900.GB1253@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906033900.GB1253@jagdpanzerIV>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2019-09-06 12:39:00, Sergey Senozhatsky wrote:
> On (09/05/19 13:23), Steven Rostedt wrote:
> > > I think we can queue significantly much less irq_work-s from printk().
> > > 
> > > Petr, Steven, what do you think?
> 
> [..]
> > I mean, really, do we need to keep calling wake up if it
> > probably never even executed?
> 
> I guess ratelimiting you are talking about ("if it probably never even
> executed") would be to check if we have already called wake up on the
> log_wait ->head. For that we need to, at least, take log_wait spin_lock
> and check that ->head is still in TASK_INTERRUPTIBLE; which is (quite,
> but not exactly) close to what wake_up_interruptible() does - it doesn't
> wake up the same task twice, it bails out on `p->state & state' check.

I have just realized that only sleeping tasks are in the waitqueue.
It is already handled by waitqueue_active() check.

I am afraid that we could not ratelimit the wakeups. The userspace
loggers might then miss the last lines for a long.

We could move wake_up_klogd() back to console_unlock(). But it might
end up with a back-and-forth games according to who is currently
complaining.

Sigh, I still suggest to ratelimit the warning about failed
allocation.

Best Regards,
Petr
