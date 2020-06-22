Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508882042D2
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgFVVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:44:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:50596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVVov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:44:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 84B88AF21;
        Mon, 22 Jun 2020 21:44:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 134EE602E5; Mon, 22 Jun 2020 23:44:49 +0200 (CEST)
Date:   Mon, 22 Jun 2020 23:44:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oliver Herms <oliver.peter.herms@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
Message-ID: <20200622214449.gyfn33ickesj2j2t@lion.mk-sys.cz>
References: <20200622205355.GA869719@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622205355.GA869719@tws>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 10:53:55PM +0200, Oliver Herms wrote:
> When fib6_run_gc is called with parameter force=true the spinlock in
> /net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
> net.ipv6.route.max_size is exceeded (seen this multiple times).
> One sotirq/CPU get's the lock. All others spin to get it. It takes
> substantial time until all are done. Effectively it's a DOS vector.
> 
> As the splinlock is only enforcing that there is at most one GC running
> at a time, it should IMHO be safe to use force=false here resulting
> in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
> contention.
> 
> Finding a locked spinlock means some GC is going on already so it is
> save to just skip another execution of the GC.
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>

I wonder if it wouldn't suffice to revert commit 14956643550f ("ipv6:
slight optimization in ip6_dst_gc") as the reasoning in its commit
message seems wrong: we do not always skip fib6_run_gc() when
entries <= rt_max_size, we do so only if the time since last garbage
collector run is shorter than rt_min_interval.

Then you would prevent the "thundering herd" effect when only gc_thresh
is exceeded but not max_size, as commit 2ac3ac8f86f2 ("ipv6: prevent
fib6_run_gc() contention") intended, but would still preserve enforced
garbage collect when max_size is exceeded.

Michal

> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 82cbb46a2a4f..7e6fbaf43549 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3205,7 +3205,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
>  		goto out;
>  
>  	net->ipv6.ip6_rt_gc_expire++;
> -	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
> +	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, false);
>  	entries = dst_entries_get_slow(ops);
>  	if (entries < ops->gc_thresh)
>  		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
> -- 
> 2.25.1
> 
