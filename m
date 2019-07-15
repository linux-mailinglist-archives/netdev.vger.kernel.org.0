Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91C668BD5
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbfGONrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:47:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47044 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730713AbfGONrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jlRSv6D32c5vRgHqG1BblcMnQppOzwlRdfFs2cDSlTY=; b=jZsVdfxZVvLDnNWNxhTCEYX97
        b+vx/mwLNqKzRu3S3A5Q4kkc1PBiOknjKNykafyh5/2DyNfYagltlpWR+G9n1XYEDOfUvJp9XUxin
        kKL2IrJkvoSwIn3O8KW5/gXdqxPrZTAPeyzXSPglSLNvdZsNRW/kOomMzWD/urwiVWkWeX5HxCTLS
        D6Wutv/X76bDSV7LcDjtc2PDs/Gw2OnB2asCrtEKNUDRWgQqmLDRNkNC7tYs8ye156KQOa1iZD0FF
        I2TPDeYtmFEzGboruzQ0raXHJyx3VzrslVevbVONRkhjFibG6BQqiKLu8GQsZEDGkj8bc/bvdwCw+
        pd9YAeHow==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hn1Jc-00036x-Ty; Mon, 15 Jul 2019 13:46:53 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 975A72013A7FA; Mon, 15 Jul 2019 15:46:51 +0200 (CEST)
Date:   Mon, 15 Jul 2019 15:46:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190715134651.GI3419@hirez.programming.kicks-ass.net>
References: <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com>
 <20190715132911.GG3419@hirez.programming.kicks-ass.net>
 <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 03:33:11PM +0200, Dmitry Vyukov wrote:
> On Mon, Jul 15, 2019 at 3:29 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Sun, Jul 14, 2019 at 11:49:15AM -0700, Paul E. McKenney wrote:
> > > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > > But short term I don't see any other solution than stop testing
> > > > sched_setattr because it does not check arguments enough to prevent
> > > > system misbehavior. Which is a pity because syzkaller has found some
> > > > bad misconfigurations that were oversight on checking side.
> > > > Any other suggestions?
> > >
> > > Keep the times down to a few seconds?  Of course, that might also
> > > fail to find interesting bugs.
> >
> > Right, if syzcaller can put a limit on the period/deadline parameters
> > (and make sure to not write "-1" to
> > /proc/sys/kernel/sched_rt_runtime_us) then per the in-kernel
> > access-control should not allow these things to happen.
> 
> Since we are racing with emails, could you suggest a 100% safe
> parameters? Because I only hear people saying "safe", "sane",
> "well-behaving" :)
> If we move the check to user-space, it does not mean that we can get
> away without actually defining what that means.

Right, well, that's part of the problem. I think Paul just did the
reverse math and figured that 95% of X must not be larger than my
watchdog timeout and landed on 14 seconds.

I'm thinking 4 seconds (or rather 4.294967296) would be a very nice
number.

> Now thinking of this, if we come up with some simple criteria, could
> we have something like a sysctl that would allow only really "safe"
> parameters?

I suppose we could do that, something like:
sysctl_deadline_period_{min,max}. I'll have to dig back a bit on where
we last talked about that and what the problems where.

For one, setting the min is a lot harder, but I suppose we can start at
TICK_NSEC or something.
