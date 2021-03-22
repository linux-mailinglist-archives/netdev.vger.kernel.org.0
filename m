Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F88B3451D8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCVVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:34:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36793 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCVVdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 17:33:43 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1lOSBB-0006k3-M3; Mon, 22 Mar 2021 21:33:42 +0000
Date:   Mon, 22 Mar 2021 18:33:37 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
Subject: Re: [PATCH 1/2] neighbour: allow referenced neighbours to be removed
Message-ID: <20210322213337.GC4791@mussarela>
References: <20210317185320.1561608-1-cascardo@canonical.com>
 <af0b2c0a-d8a9-1932-e3cd-54a67a3d389b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af0b2c0a-d8a9-1932-e3cd-54a67a3d389b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 05:42:00PM -0600, David Ahern wrote:
> On 3/17/21 12:53 PM, Thadeu Lima de Souza Cascardo wrote:
> > During forced garbage collection, neighbours with more than a reference are
> > not removed. It's possible to DoS the neighbour table by using ARP spoofing
> > in such a way that there is always a timer pending for all neighbours,
> > preventing any of them from being removed. That will cause any new
> > neighbour creation to fail.
> > 
> > Use the same code as used by neigh_flush_dev, which deletes the timer and
> > cleans the queue when there are still references left.
> > 
> > With the same ARP spoofing technique, it was still possible to reach a valid
> > destination when this fix was applied, with no more table overflows.
> 
> And how fast are neighbor entries removed with this patch? The current
> code gives a neighbor entry a minimum lifetime to allow it to exist long
> enough to be confirmed. Removing the minimum lifetime means neighbor
> entries are constantly churning which is just as bad as the arp spoofing
> problem.
> 

The patch should not change the rules of removing entries, so they are removed
only after 5 seconds. When trying to reach the other endpoint of a veth device,
it usually takes between 0 and 6 failures (with 1s interval) before succeeding,
and then, succeeding in succession.

I will be honest and say that I wasn't able yet to find out the exact order of
events in respect to neighbor state and lifetime updates, but the code still
only removes entries if they have been updated more than 5s before "now".

The change here is that entries are removed even if there is a reference to it
because of the timer. The timer is then removed and the entry can be removed.

I still see lots of table overflows with the tests I was able to run lately, so
not sure what changed in respect to when I first tested this patch. However,
then this patch is not applied, I cannot reach the other veth endpoint at all.
And, eventually, I loose remote access to the machine. With the patch applied,
the system is at least accessible, though it may "lag" sometimes, indicating
that access has been lost temporarily, but restored eventually.

Cascardo.

> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  net/core/neighbour.c | 117 +++++++++++++++++++------------------------
> >  1 file changed, 51 insertions(+), 66 deletions(-)
> > 
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index e2982b3970b8..bbc89c7ffdfd 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -173,25 +173,48 @@ static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
> >  	return rc;
> >  }
> >  
> > +static int neigh_del_timer(struct neighbour *n)
> > +{
> > +	if ((n->nud_state & NUD_IN_TIMER) &&
> > +	    del_timer(&n->timer)) {
> > +		neigh_release(n);
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static bool neigh_del(struct neighbour *n, struct neighbour __rcu **np,
> >  		      struct neigh_table *tbl)
> >  {
> > -	bool retval = false;
> > -
> > +	rcu_assign_pointer(*np,
> > +		   rcu_dereference_protected(n->next,
> > +				lockdep_is_held(&tbl->lock)));
> >  	write_lock(&n->lock);
> > -	if (refcount_read(&n->refcnt) == 1) {
> > -		struct neighbour *neigh;
> > -
> > -		neigh = rcu_dereference_protected(n->next,
> > -						  lockdep_is_held(&tbl->lock));
> > -		rcu_assign_pointer(*np, neigh);
> > -		neigh_mark_dead(n);
> > -		retval = true;
> > +	neigh_del_timer(n);
> > +	neigh_mark_dead(n);
> > +	if (refcount_read(&n->refcnt) != 1) {
> > +		/* The most unpleasant situation.
> > +		   We must destroy neighbour entry,
> > +		   but someone still uses it.
> > +
> > +		   The destroy will be delayed until
> > +		   the last user releases us, but
> > +		   we must kill timers etc. and move
> > +		   it to safe state.
> > +		 */
> > +		__skb_queue_purge(&n->arp_queue);
> > +		n->arp_queue_len_bytes = 0;
> > +		n->output = neigh_blackhole;
> > +		if (n->nud_state & NUD_VALID)
> > +			n->nud_state = NUD_NOARP;
> > +		else
> > +			n->nud_state = NUD_NONE;
> > +		neigh_dbg(2, "neigh %p is stray\n", n);
> >  	}
> >  	write_unlock(&n->lock);
> > -	if (retval)
> > -		neigh_cleanup_and_release(n);
> > -	return retval;
> > +	neigh_cleanup_and_release(n);
> > +
> > +	return true;
> >  }
> >  
> >  bool neigh_remove_one(struct neighbour *ndel, struct neigh_table *tbl)
> > @@ -229,22 +252,20 @@ static int neigh_forced_gc(struct neigh_table *tbl)
> >  	write_lock_bh(&tbl->lock);
> >  
> >  	list_for_each_entry_safe(n, tmp, &tbl->gc_list, gc_list) {
> > -		if (refcount_read(&n->refcnt) == 1) {
> > -			bool remove = false;
> > -
> > -			write_lock(&n->lock);
> > -			if ((n->nud_state == NUD_FAILED) ||
> > -			    (tbl->is_multicast &&
> > -			     tbl->is_multicast(n->primary_key)) ||
> > -			    time_after(tref, n->updated))
> > -				remove = true;
> > -			write_unlock(&n->lock);
> > -
> > -			if (remove && neigh_remove_one(n, tbl))
> > -				shrunk++;
> > -			if (shrunk >= max_clean)
> > -				break;
> > -		}
> > +		bool remove = false;
> > +
> > +		write_lock(&n->lock);
> > +		if ((n->nud_state == NUD_FAILED) ||
> > +		    (tbl->is_multicast &&
> > +		     tbl->is_multicast(n->primary_key)) ||
> > +		    time_after(tref, n->updated))
> > +			remove = true;
> > +		write_unlock(&n->lock);
> > +
> > +		if (remove && neigh_remove_one(n, tbl))
> > +			shrunk++;
> > +		if (shrunk >= max_clean)
> > +			break;
> >  	}
> >  
> >  	tbl->last_flush = jiffies;
> > @@ -264,16 +285,6 @@ static void neigh_add_timer(struct neighbour *n, unsigned long when)
> >  	}
> >  }
> >  
> > -static int neigh_del_timer(struct neighbour *n)
> > -{
> > -	if ((n->nud_state & NUD_IN_TIMER) &&
> > -	    del_timer(&n->timer)) {
> > -		neigh_release(n);
> > -		return 1;
> > -	}
> > -	return 0;
> > -}
> > -
> >  static void pneigh_queue_purge(struct sk_buff_head *list)
> >  {
> >  	struct sk_buff *skb;
> > @@ -307,33 +318,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
> >  				np = &n->next;
> >  				continue;
> >  			}
> > -			rcu_assign_pointer(*np,
> > -				   rcu_dereference_protected(n->next,
> > -						lockdep_is_held(&tbl->lock)));
> > -			write_lock(&n->lock);
> > -			neigh_del_timer(n);
> > -			neigh_mark_dead(n);
> > -			if (refcount_read(&n->refcnt) != 1) {
> > -				/* The most unpleasant situation.
> > -				   We must destroy neighbour entry,
> > -				   but someone still uses it.
> > -
> > -				   The destroy will be delayed until
> > -				   the last user releases us, but
> > -				   we must kill timers etc. and move
> > -				   it to safe state.
> > -				 */
> > -				__skb_queue_purge(&n->arp_queue);
> > -				n->arp_queue_len_bytes = 0;
> > -				n->output = neigh_blackhole;
> > -				if (n->nud_state & NUD_VALID)
> > -					n->nud_state = NUD_NOARP;
> > -				else
> > -					n->nud_state = NUD_NONE;
> > -				neigh_dbg(2, "neigh %p is stray\n", n);
> > -			}
> > -			write_unlock(&n->lock);
> > -			neigh_cleanup_and_release(n);
> > +			neigh_del(n, np, tbl);
> >  		}
> >  	}
> >  }
> > 
> 
