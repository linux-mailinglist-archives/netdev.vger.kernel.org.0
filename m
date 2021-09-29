Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0879541CB51
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344933AbhI2RzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245726AbhI2RzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3EA3613CE;
        Wed, 29 Sep 2021 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632938013;
        bh=wElHMAEFjmn31S+fylQDgGg4sIxeUk2AZkB2RIsXSKo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Fr1ydsoJAUMbJLuE8WXZTMrpKKu8Gsb41aWAHmwiaXjyOigUENJ+9m0VWX72JEGmP
         FFBjO3Q6ZEB8fBvlsU5qWMy92WCzVv03b3S5caP9aeRFyT5muv1b9PisMqjR4eTQIB
         nBokWuubKKGIFxpPpGOmtqLzhvNCx24fyl3kMGLXOETRPLFXFFZf4HLbAUcACndk8B
         AsqFDLyPuTpKaJ3TDMiavjw16GDDwMMLinbbKvXda/vdpc7zIxoZ3QvH+lovw1VpSf
         631v6ZcyoLqxcaaA7ySBdJoBNb63ZRfp78VfkAHs0XRYUPA3VCnRuAojrKvJN6/7/P
         EUKcLFpO1J5Kg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 920825C06B9; Wed, 29 Sep 2021 10:53:33 -0700 (PDT)
Date:   Wed, 29 Sep 2021 10:53:33 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious
 rcu_dereference_check() with br_vlan_get_pvid_rcu
Message-ID: <20210929175333.GW880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 02:37:08AM +0300, Vladimir Oltean wrote:
> __dev_queue_xmit(), which is our caller, does run under rcu_read_lock_bh(),
> but in my foolishness I had thought this would be enough to make the
> access, lockdep complains that rcu_read_lock() is not held.

Depending on exactly which primitive is complaining, you can inform
lockdep of your intentions.  For example, you can change
rcu_dereference(p) to rcu_dereference_bh(p).  Or you can change:

	list_for_each_entry_rcu(p, &lh, field) {
		...

To:

	list_for_each_entry_rcu(p, &lh, field, rcu_read_lock_bh_held()) {
		...

And hlist_for_each_entry_rcu() can also take that same optional
lockdep parameter.

> Which it isn't - as it turns out, RCU preempt and RCU-bh are two
> different flavors, and although Paul McKenney has consolidated
> synchronize_rcu() to wait for both preempt as well as bh read-side
> critical sections [1], the reader-side API is different, the lockdep
> maps and keys are different.
> 
> The bridge calls synchronize_rcu() in br_vlan_flush(), and this does
> wait for our TX fastpath reader of the br_vlan_group_rcu to complete
> even though it is in an rcu-bh read side section. So even though this is
> in premise safe, to lockdep this is a case of "who are you? I don't know
> you, you're suspicious".
> 
> Side note, I still don't really understand the different RCU flavors.

RCU BH was there to handle denial-of-service networking loads.
Changes over the years to RCU and to softirq have rendered it obsolete.
But rcu_read_lock_bh() still disables softirq for you.

RCU Sched provides the original semantics.

RCU Preempt, as the name suggests, allows RCU readers to be preempted.
Of course, if you are using rcu_read_lock_sched() or rcu_read_lock_bh(),
you are disabling preemption across the critical section.

> For example, as far as I can see, the core network stack has never
> directly called synchronize_rcu_bh, not even once. Just the initial
> synchronize_kernel(), replaced later with the RCU preempt variant -
> synchronize_rcu(). Very very long story short, dev_queue_xmit has
> started calling this exact variant - rcu_read_lock_bh() - since [2], to
> make dev_deactivate properly wait for network interfaces with
> NETIF_F_LLTX to finish their dev_queue_xmit(). But that relied on an
> existing synchronize_rcu(), not synchronize_rcu_bh(). So does this mean
> that synchronize_net() never really waited for the rcu-bh critical
> section in dev_queue_xmit to finish? I've no idea.

The pre-consolidation Linux kernel v4.16 has these calls to
synchronize_rcu_bh():

drivers/net/team/team.c team_port_disable_netpoll 1094 synchronize_rcu_bh();
drivers/vhost/net.c vhost_net_release 1027 synchronize_rcu_bh();
net/netfilter/ipset/ip_set_hash_gen.h mtype_resize 667 synchronize_rcu_bh();

But to your point, nothing in net/core.

And for v4.16 kernels build with CONFIG_PREEMPT=y, there is no guarantee
that synchronize_rcu() will wait for a rcu_read_lock_bh() critical
section.  A CPU in such a critical section could take a scheduling-clock
interrupt, notice that it was not in an rcu_read_lock() critical section,
and report a quiescent state, which could well end that grace period.

But as you say, in more recent kernels, synchronize_rcu() will indeed
wait for rcu_read_lock_bh() critical sections.

But please be very careful when backporting.

> So basically there are multiple options.
> 
> First would be to duplicate br_vlan_get_pvid_rcu() into a new
> br_vlan_get_pvid_rcu_bh() to appease lockdep for the TX path case. But
> this function already has another brother, br_vlan_get_pvid(), which is
> protected by the update-side rtnl_mutex. We don't want to grow the
> family too big too, especially since br_vlan_get_pvid_rcu_bh() would not
> be a function used by the bridge at all, just exported by it and used by
> the DSA layer.
> 
> The option of getting to the bottom of why does __dev_queue_xmit use
> rcu-bh, and splitting that into local_bh_disable + rcu_read_lock, as it
> was before [3], might be impractical. There have been 15 years of
> development since then, and there are lots of code paths that use
> rcu_dereference_bh() in the TX path. Plus, with the consolidation work
> done in [1], I'm not even sure what are the practical benefits of rcu-bh
> any longer, if the whole point was for synchronize_rcu() to wait for
> everything in sight - how can spammy softirqs like networking paint
> themselves red any longer, and how can certain RCU updaters not wait for
> them now, in order to avoid denial of service? It doesn't appear
> possible from the distance from which I'm looking at the problem.
> So the effort of converting __dev_queue_xmit from rcu-bh to rcu-preempt
> would only appear justified if it went together with the complete
> elimination of rcu-bh. Also, it would appear to be quite a strange and
> roundabout way to fix a "suspicious RCU usage" lockdep message.

The thing to be very careful of is code that might be implicitly assuming
that it cannot be interrupted by a softirq handler.  This assumption will
of course be violated by changing rcu_read_lock_bh() to rcu_read_lock().
The resulting low-probability subtle breakage might be hard to find.

> Last, it appears possible to just give lockdep what it wants, and hold
> an rcu-preempt read-side critical section when calling br_vlan_get_pvid_rcu
> from the TX path. In terms of lines of code and amount of thought needed
> it is certainly the easiest path forward, even though it incurs a small
> (negligible) performance overhead (and avoidable, at that). This is what
> this patch does, in lack of a deeper understanding of lockdep, RCU or
> the network transmission process.
> 
> [1] https://lwn.net/Articles/777036/
> [2] commit d4828d85d188 ("[NET]: Prevent transmission after dev_deactivate")
> [3] commit 43da55cbd54e ("[NET]: Do less atomic count changes in dev_queue_xmit.")
> 
> Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Of course, if no one really needs rcu_read_lock_bh() anymore, I would be
quite happy to simplify my life by getting rid of it.  ;-)

							Thanx, Paul

> ---
>  net/dsa/tag_dsa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index 77d0ce89ab77..178464cd2bdb 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -150,10 +150,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  		 * that's where the packets ingressed from.
>  		 */
>  		if (!br_vlan_enabled(br)) {
> -			/* Safe because __dev_queue_xmit() runs under
> -			 * rcu_read_lock_bh()
> -			 */
> +			rcu_read_lock();
>  			err = br_vlan_get_pvid_rcu(br, &pvid);
> +			rcu_read_unlock();
>  			if (err)
>  				return NULL;
>  		}
> -- 
> 2.25.1
> 
