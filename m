Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AAC41260C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353812AbhITSwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385896AbhITSwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 14:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9917561245;
        Mon, 20 Sep 2021 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632161580;
        bh=BTFUxJdX1hY0RCDSw/MYkhqvEyalCtcTZ06jVH+EaBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pHLpyoEaYbGLeiy+MgEQlB7qjzDEzYqd8Cy9B+ZyLIOD3PXxurkO5b93YMJCHewsd
         9RyHSnDwC8hYkN7pypn/t7Km8+B6xZBwAQk+pWMTQFkebHJVBL6ylEK4wklKW/flAE
         EpceAzmO0iU33bUHTvJIgBGnzl7q52j+9CXVikSpr7zNjdGRvyODeTDVZy/CX0WxIz
         MC3UeisCT+iDYLYR3nwsD/lCNYu+r3euqtC5Lk3ECXwF4+wieTA/Mct/yMOlB08UDa
         vnCaRX9o7bVRhT84U3Jh0Nm0c3PW61TvT7j6YVleFV4BKV7tmYeXTNR4seLWgGSHzt
         dYoo2wNzgpnLA==
Date:   Mon, 20 Sep 2021 11:12:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
Message-ID: <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
        <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Sep 2021 13:05:28 +0300 Vasily Averin wrote:
> On 9/17/21 7:24 PM, Jakub Kicinski wrote:
> > From: Vasily Averin <vvs@virtuozzo.com>
> > 
> > Christoph Paasch reports [1] about incorrect skb->truesize
> > after skb_expand_head() call in ip6_xmit.
> > This may happen because of two reasons:
> >  - skb_set_owner_w() for newly cloned skb is called too early,
> >    before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> >  - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> >    In this case sk->sk_wmem_alloc should be adjusted too.
> > 
> > Eric cautions us against increasing sk_wmem_alloc if the old
> > skb did not hold any wmem references.

> > @@ -1810,21 +1829,28 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
> >  	if (skb_shared(skb)) {
> >  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
> >  
> > -		if (likely(nskb)) {
> > -			if (skb->sk)
> > -				skb_set_owner_w(nskb, skb->sk);
> > -			consume_skb(skb);
> > -		} else {
> > -			kfree_skb(skb);
> > -		}
> > +		if (unlikely(!nskb))
> > +			goto err_free;
> > +
> > +		skb_owner_inherit(nskb, skb);
> > +		consume_skb(skb);
> >  		skb = nskb;
> >  	}
> > -	if (skb &&
> > -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> > -		kfree_skb(skb);
> > -		skb = NULL;
> > -	}
> > +
> > +	if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
> > +		goto err_free;
> > +	delta = skb_end_offset(skb) - osize;
> > +
> > +	/* pskb_expand_head() will adjust truesize itself for non-sk cases
> > +	 * todo: move the adjustment there at some point?
> > +	 */
> > +	if (skb->sk && skb->destructor != sock_edemux)
> > +		skb_increase_truesize(skb, delta);  
> 
> I think it is wrong.
> 1) there are a few skb destructors called sock_wfree inside. I've found: 
>    tpacket_destruct_skb, sctp_wfree, unix_destruct_scm and xsk_destruct_skb.
>    If any such skb can be use here it will not adjust sk_wmem_alloc.   I afraid there might be other similar destructors, out of tree,
>    so we cannot have full white list for wfree-compatible destructors.
> 
> 2) in fact you increase truesize here for all skb types.
>    If it is acceptable it could be done directly inside pskb_expand_head().
>    However it isn't.  As you pointed sock_rfree case is handled incorrectly. 
>    I've found other similar destructors: sock_rmem_free, netlink_skb_destructor,
>    kcm_rfree, sock_ofree. They will be handled incorrectly too, but even without WARN_ON.
>    Few other descriptors seems should not fail but do not require truesize update.
> 
> From my POV v6 patch version works correctly in any cases. If necessary it calls
> original destructor, correctly set up new one and correctly adjust truesize
> and sk_wmem_alloc.
> If you still have doubts, we can just go back and clone non-wmem skb, 
> like we did before.

Thanks for taking a look. I would prefer not to bake any ideas about
the skb's function into generic functions. Enumerating every destructor
callback in generic code is impossible (technically so, since the code
may reside in modules).

Let me think about it. Perhaps we can extend sock callbacks with
skb_sock_inherit, and skb_adjust_trusize? That'd transfer the onus of
handling the adjustments done on splitting to the protocols. I'll see
if that's feasible unless someone can immediately call this path
ghastly.
