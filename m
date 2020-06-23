Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86DB2066B0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgFWV4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:56:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:43560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbgFWV4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:56:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31303ADA3;
        Tue, 23 Jun 2020 21:56:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id F073C602E3; Tue, 23 Jun 2020 23:56:27 +0200 (CEST)
Date:   Tue, 23 Jun 2020 23:56:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
Message-ID: <20200623215627.dczzidomidhur4ra@lion.mk-sys.cz>
References: <20200622205355.GA869719@tws>
 <20200622214449.gyfn33ickesj2j2t@lion.mk-sys.cz>
 <3588d0fc-5c6b-b62a-f137-24abcf660d5f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3588d0fc-5c6b-b62a-f137-24abcf660d5f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:46:34AM +0200, Oliver Herms wrote:
> On 22.06.20 23:44, Michal Kubecek wrote:
> > On Mon, Jun 22, 2020 at 10:53:55PM +0200, Oliver Herms wrote:
> >> When fib6_run_gc is called with parameter force=true the spinlock in
> >> /net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
> >> net.ipv6.route.max_size is exceeded (seen this multiple times).
> >> One sotirq/CPU get's the lock. All others spin to get it. It takes
> >> substantial time until all are done. Effectively it's a DOS vector.
> >>
> >> As the splinlock is only enforcing that there is at most one GC running
> >> at a time, it should IMHO be safe to use force=false here resulting
> >> in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
> >> contention.
> >>
> >> Finding a locked spinlock means some GC is going on already so it is
> >> save to just skip another execution of the GC.
> >>
> >> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> > 
> > I wonder if it wouldn't suffice to revert commit 14956643550f ("ipv6:
> > slight optimization in ip6_dst_gc") as the reasoning in its commit
> > message seems wrong: we do not always skip fib6_run_gc() when
> > entries <= rt_max_size, we do so only if the time since last garbage
> > collector run is shorter than rt_min_interval.
> > 
> > Then you would prevent the "thundering herd" effect when only gc_thresh
> > is exceeded but not max_size, as commit 2ac3ac8f86f2 ("ipv6: prevent
> > fib6_run_gc() contention") intended, but would still preserve enforced
> > garbage collect when max_size is exceeded.
> > 
> > Michal
> > 
> 
> Hi Michal,
> 
> I did some testing with packets causing 17k IPv6 route cache entries per 
> second. With "entries > rt_max_size" all CPUs of the system get stuck 
> waiting for the spinlock. With "false" CPU load stays at <<10% on every single
> CPU core (tested on an Atom C2750). This makes sense as "entries > rt_max_size"
> would not prevent multiple CPUs from trying to get the lock.
> 
> So reverting 14956643550f is not enough.

The problem I see with this kind of test is that you simulate a scenario
where you are routinely using more entries than the cache is sized for.
In other words, if this happened in a real life setup, the actual
problem would be too low settings for gc_thresh and max_size. Also, your
patch would minimize the difference between gc_thresh (where we want to
get) and max_size (hard limit) by making the hard limit "softer".

Michal
