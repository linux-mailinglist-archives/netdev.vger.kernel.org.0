Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D2141CFED
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346887AbhI2X3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245025AbhI2X3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 19:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6564E61406;
        Wed, 29 Sep 2021 23:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632958054;
        bh=96Hl5B9Btk7tmr2A/UriG+qDgu/K+LwzVmRdhjtdQBk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=sjX4ZcRYOJ/CbtRd2owC/x3corQbrINNYOAtZSzVcIW7uBQLqCkLylnaLDMhxjacp
         pnvKdVCogzJnDVg1FK9NlNq0/TwGOp24qczka6VYl3+3a8fCe4aEO9Bgiw1/stw85X
         4yJQt3tatMbdcyxRX4K0cuUCDV3iGkrdqFARTXq3QAjGTcVLgcpRScKWPGVxfwslOc
         pON6Q6xeZaR1dlP3ap6scdqo8agAKd3zDFMSkxORy8WN+U6QU0ARyy3ZF23DEQVtE5
         5qea0SefyUjJxLHpyMJJ+FHd1CSfdoNMkHcFJ7Wj/9/jpbyqH67iI06+I09Y8sdcXk
         Qxfs0NXCqK6Sg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 32DF25C1308; Wed, 29 Sep 2021 16:27:34 -0700 (PDT)
Date:   Wed, 29 Sep 2021 16:27:34 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
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
Message-ID: <20210929232734.GE880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
 <20210929175333.GW880162@paulmck-ThinkPad-P17-Gen-1>
 <20210929212822.nvu4n2g6xubczwym@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929212822.nvu4n2g6xubczwym@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 09:28:22PM +0000, Vladimir Oltean wrote:
> On Wed, Sep 29, 2021 at 10:53:33AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 29, 2021 at 02:37:08AM +0300, Vladimir Oltean wrote:
> > > __dev_queue_xmit(), which is our caller, does run under rcu_read_lock_bh(),
> > > but in my foolishness I had thought this would be enough to make the
> > > access, lockdep complains that rcu_read_lock() is not held.
> > 
> > Depending on exactly which primitive is complaining, you can inform
> > lockdep of your intentions.  For example, you can change
> > rcu_dereference(p) to rcu_dereference_bh(p).  Or you can change:
> > 
> > 	list_for_each_entry_rcu(p, &lh, field) {
> > 		...
> > 
> > To:
> > 
> > 	list_for_each_entry_rcu(p, &lh, field, rcu_read_lock_bh_held()) {
> > 		...
> > 
> > And hlist_for_each_entry_rcu() can also take that same optional
> > lockdep parameter.
> 
> This is covered by my first option below, basically I don't want to
> bloat the Ethernet bridge driver too much with a single user, and that
> user being outside the bridge code itself, at that. I'm sure Nikolay and
> Roopa would agree :)

No need to duplicate code.  You can pass in both like this:

rcu_dereference_check(p, rcu_read_lock_bh_held() || rcu_read_lock_held());

But if just switching rcu_read_lock() really works for you, that is
easier.

> The bridge xmit function - br_dev_xmit - takes the rcu_preempt
> rcu_read_lock() too. Although I don't think it is very high-overhead in
> any incarnation, I think it would be seen as a positive improvement if
> it could be removed from that path too (or would it?)

Both rcu_read_lock() and preempt_disable() cost very little, but it
is not zero cost.  The real question is of course "can you see it in a
system-level benchmark?"  Or even in a microbenchmark.

> > > Which it isn't - as it turns out, RCU preempt and RCU-bh are two
> > > different flavors, and although Paul McKenney has consolidated
> > > synchronize_rcu() to wait for both preempt as well as bh read-side
> > > critical sections [1], the reader-side API is different, the lockdep
> > > maps and keys are different.
> > > 
> > > The bridge calls synchronize_rcu() in br_vlan_flush(), and this does
> > > wait for our TX fastpath reader of the br_vlan_group_rcu to complete
> > > even though it is in an rcu-bh read side section. So even though this is
> > > in premise safe, to lockdep this is a case of "who are you? I don't know
> > > you, you're suspicious".
> > > 
> > > Side note, I still don't really understand the different RCU flavors.
> > 
> > RCU BH was there to handle denial-of-service networking loads.
> > Changes over the years to RCU and to softirq have rendered it obsolete.
> > But rcu_read_lock_bh() still disables softirq for you.
> 
> Thank you, I guess? :)

You are welcome, I guess?  ;-)

> > RCU Sched provides the original semantics.
> > 
> > RCU Preempt, as the name suggests, allows RCU readers to be preempted.
> > Of course, if you are using rcu_read_lock_sched() or rcu_read_lock_bh(),
> > you are disabling preemption across the critical section.
> > 
> > > For example, as far as I can see, the core network stack has never
> > > directly called synchronize_rcu_bh, not even once. Just the initial
> > > synchronize_kernel(), replaced later with the RCU preempt variant -
> > > synchronize_rcu(). Very very long story short, dev_queue_xmit has
> > > started calling this exact variant - rcu_read_lock_bh() - since [2], to
> > > make dev_deactivate properly wait for network interfaces with
> > > NETIF_F_LLTX to finish their dev_queue_xmit(). But that relied on an
> > > existing synchronize_rcu(), not synchronize_rcu_bh(). So does this mean
> > > that synchronize_net() never really waited for the rcu-bh critical
> > > section in dev_queue_xmit to finish? I've no idea.
> > 
> > The pre-consolidation Linux kernel v4.16 has these calls to
> > synchronize_rcu_bh():
> > 
> > drivers/net/team/team.c team_port_disable_netpoll 1094 synchronize_rcu_bh();
> > drivers/vhost/net.c vhost_net_release 1027 synchronize_rcu_bh();
> > net/netfilter/ipset/ip_set_hash_gen.h mtype_resize 667 synchronize_rcu_bh();
> > 
> > But to your point, nothing in net/core.
> > 
> > And for v4.16 kernels build with CONFIG_PREEMPT=y, there is no guarantee
> > that synchronize_rcu() will wait for a rcu_read_lock_bh() critical
> > section.  A CPU in such a critical section could take a scheduling-clock
> > interrupt, notice that it was not in an rcu_read_lock() critical section,
> > and report a quiescent state, which could well end that grace period.
> 
> I find it really hard to believe that commit d4828d85d188
> ("[NET]: Prevent transmission after dev_deactivate") did not provide the
> guarantee it promised. It seems much more likely that I'm missing something,
> although I don't see what :)

You guys are the ones who get bitten if there is a problem, so I will
let you guys check it out.  Or not, at your option.  ;-)

> But the team driver, which I did notice, and which you've linked to
> above as well, did have a comment which suggested that yes, if you don't
> call synchronize_rcu_bh(), you don't really wait for __dev_queue_xmit()
> to finish.

And that did change, but then again I changed that to synchronize_rcu()
late in the consolidation effort.

> > But as you say, in more recent kernels, synchronize_rcu() will indeed
> > wait for rcu_read_lock_bh() critical sections.
> > 
> > But please be very careful when backporting.
> 
> No concerns with backporting, the code in question was added last month
> or so.

Very good!

> > > So basically there are multiple options.
> > > 
> > > First would be to duplicate br_vlan_get_pvid_rcu() into a new
> > > br_vlan_get_pvid_rcu_bh() to appease lockdep for the TX path case. But
> > > this function already has another brother, br_vlan_get_pvid(), which is
> > > protected by the update-side rtnl_mutex. We don't want to grow the
> > > family too big too, especially since br_vlan_get_pvid_rcu_bh() would not
> > > be a function used by the bridge at all, just exported by it and used by
> > > the DSA layer.
> > > 
> > > The option of getting to the bottom of why does __dev_queue_xmit use
> > > rcu-bh, and splitting that into local_bh_disable + rcu_read_lock, as it
> > > was before [3], might be impractical. There have been 15 years of
> > > development since then, and there are lots of code paths that use
> > > rcu_dereference_bh() in the TX path. Plus, with the consolidation work
> > > done in [1], I'm not even sure what are the practical benefits of rcu-bh
> > > any longer, if the whole point was for synchronize_rcu() to wait for
> > > everything in sight - how can spammy softirqs like networking paint
> > > themselves red any longer, and how can certain RCU updaters not wait for
> > > them now, in order to avoid denial of service? It doesn't appear
> > > possible from the distance from which I'm looking at the problem.
> > > So the effort of converting __dev_queue_xmit from rcu-bh to rcu-preempt
> > > would only appear justified if it went together with the complete
> > > elimination of rcu-bh. Also, it would appear to be quite a strange and
> > > roundabout way to fix a "suspicious RCU usage" lockdep message.
> > 
> > The thing to be very careful of is code that might be implicitly assuming
> > that it cannot be interrupted by a softirq handler.  This assumption will
> > of course be violated by changing rcu_read_lock_bh() to rcu_read_lock().
> > The resulting low-probability subtle breakage might be hard to find.
> 
> Of course, the networking code would not change functionally with the
> removal of rcu_read_lock_bh(). So rcu_read_lock_bh() would be
> transformed into local_bh_disable() + rcu_read_lock(). I am still a bit
> unclear on the details, but there are reasons why we need softirqs
> disabled - we don't call hard_start_xmit just from the NET_TX softirq,
> that would be just too nice :)
> 
> > > Last, it appears possible to just give lockdep what it wants, and hold
> > > an rcu-preempt read-side critical section when calling br_vlan_get_pvid_rcu
> > > from the TX path. In terms of lines of code and amount of thought needed
> > > it is certainly the easiest path forward, even though it incurs a small
> > > (negligible) performance overhead (and avoidable, at that). This is what
> > > this patch does, in lack of a deeper understanding of lockdep, RCU or
> > > the network transmission process.
> > > 
> > > [1] https://lwn.net/Articles/777036/
> > > [2] commit d4828d85d188 ("[NET]: Prevent transmission after dev_deactivate")
> > > [3] commit 43da55cbd54e ("[NET]: Do less atomic count changes in dev_queue_xmit.")
> > > 
> > > Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Of course, if no one really needs rcu_read_lock_bh() anymore, I would be
> > quite happy to simplify my life by getting rid of it.  ;-)
> > 
> > 							Thanx, Paul
> 
> The basic idea that updaters could be resilient against softirq storms
> sounds great in principle. Although if I understand correctly, that went
> away with the consolidation. So again, it isn't that some resiliency
> wouldn't be nice, but I'm looking at the current code and I just don't
> see what the benefits of rcu_bh are. If the answer is as self-evident as
> a naive person like me thinks it is - i.e. rcu_read_lock_bh is just a
> glorified version of rcu_read_lock which also disables softirqs, just
> with different lockdep rules - then is the consolidation really complete?
> Couldn't the bh-disable readers be modified to just open-code the
> disabling of softirqs, and resolve the lockdep issues that ensue from
> having a separate flavor?

As part of the consolidation effort, I made synchronize_rcu()
also be resilient against softirq storms in the same way that
synchronize_rcu_bh() used to be.  For example, that is why there is now
a call to rcu_softirq_qs() in __do_softirq().

Why didn't we do it that way to start with?  Because this approach relies
on a bunch of subsequent improvements in softirq in general and ksoftirqd
in particular.

If you change all instance of "rcu_read_lock_bh()" to instead be
"local_bh_disable(); rcu_read_lock()", and of "rcu_read_unlock_bh()"
to "rcu_read_unlock(); local_bh_enable()" that would work.  But
there are probably many that can now be just "rcu_read_lock()" and
"rcu_read_unlock()".  Figuring out which is which is a task for someone
who understands that code way better than I do.

And for all I know, there might be some situation that really wants
and rcu_read_lock_bh() for some reason.  But that does seem to me
to be unlikely, and it would be good to get rid of the _bh() variants.

If the uses go away, I am more than happy to get rid of the definitions!

							Thanx, Paul

> > > ---
> > >  net/dsa/tag_dsa.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> > > index 77d0ce89ab77..178464cd2bdb 100644
> > > --- a/net/dsa/tag_dsa.c
> > > +++ b/net/dsa/tag_dsa.c
> > > @@ -150,10 +150,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
> > >  		 * that's where the packets ingressed from.
> > >  		 */
> > >  		if (!br_vlan_enabled(br)) {
> > > -			/* Safe because __dev_queue_xmit() runs under
> > > -			 * rcu_read_lock_bh()
> > > -			 */
> > > +			rcu_read_lock();
> > >  			err = br_vlan_get_pvid_rcu(br, &pvid);
> > > +			rcu_read_unlock();
> > >  			if (err)
> > >  				return NULL;
> > >  		}
> > > -- 
> > > 2.25.1
> > > 
