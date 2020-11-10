Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E32AD999
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgKJPCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:02:16 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:40470 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgKJPCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:02:15 -0500
Received: from think (unknown [185.12.128.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id BD6AE402A5;
        Tue, 10 Nov 2020 16:02:13 +0100 (CET)
Message-ID: <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with
 async Netfilter rules
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:02:13 +0100
In-Reply-To: <20201110133506.GA1777@salvia>
References: <20201106073030.3974927-1-martin@strongswan.org>
         <20201110133506.GA1777@salvia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,
 
> > +static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
> > +				     struct sk_buff *skb)
> > +{
> > +	vrf_finish_direct(skb);
> > +
> > +	return vrf_ip6_local_out(net, sk, skb);
> > +}
> > +
> >  static int vrf_output6_direct(struct net *net, struct sock *sk,
> >  			      struct sk_buff *skb)
> >  {
> > +	int err = 1;
> > +
> >  	skb->protocol = htons(ETH_P_IPV6);
> >  
> > -	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> > -			    net, sk, skb, NULL, skb->dev,
> > -			    vrf_finish_direct,
> > -			    !(IPCB(skb)->flags & IPSKB_REROUTED));
> > +	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
> > +		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
> > +			      NULL, skb->dev, vrf_output6_direct_finish);
> 
> I might missing something... this looks very similar to NF_HOOK_COND
> but it's open-coded.
> 
> My question, could you still use NF_HOOK_COND?
> 
>         ret = NF_HOOK_COND(NFPROTO_IPV6, ..., vrf_output6_direct_finish);
> 
> just update the okfn.

I don't think this will work. The point of the patch is to have
different paths for sync and async Netfilter rules: In the async case
we call vrf_output6_direct_finish() to additionally do dst_output(). In
the (existing) synchronous path we just do vrf_finish_direct() and let
the caller do the dst_output().

If we prefer a common okfn(), we could return 0 to omit dst_output() in
ip/ip6_local_out(). This changes/extends the call stack for the common
case, though, and this is what I've tried to avoid.

> > +	if (likely(err == 1))
> 
> I'd suggest you remove likely() here and elsewhere in this patch.
> Just let the branch predictor make its work instead of assuming that
> the ruleset accepts traffic.

The likely() may be questionable, but I seems that is done in most
places when checking for synchronous Netfilter completion. But I'm fine
with changing these hunks, if you prefer.

Thanks,
Martin

