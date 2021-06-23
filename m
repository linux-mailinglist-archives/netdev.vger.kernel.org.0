Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74513B2239
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFWVJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWVJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B648F6128D;
        Wed, 23 Jun 2021 21:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624482439;
        bh=WcBNFpaV4ey5OIqhKbUkuCChXBRkvhdJTXR0StZNpLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rCgy38p8tT5mjI3oeUy6xd3akXkE8fFjnXnodxu5K/HLDNICr2QWSaXw/dUZ5AKU4
         pbl4QoDYEYEak49tCSwuWtynAY+jELNgjYaqeiVzvWBEM8ZJ0C8Xq72bC5axajHYkW
         4ACdW+IQuK4sKCMBDtPLcBaUEaJwjRMPrfdvbCssb2pkWCLP4JMiZOrOB20pdkU6nB
         MQW3/qUIQ02YzyaFL1JBGpCJNwyEnWHjneyKICEl7XudRLEw5DR/nHsQ046tbjLvnZ
         dwzf+H1WuF3ZBFij3I/mrT4M9zxVuIJRWIjhryNjbztr71bkTerB5qMKYxBW6KTN04
         25u0+9DcoIzaA==
Date:   Wed, 23 Jun 2021 14:07:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP
 sends over loopback
Message-ID: <20210623140717.22997203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210623214555.5c683821@carbon>
References: <20210623162328.2197645-1-kuba@kernel.org>
        <20210623214555.5c683821@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 21:45:55 +0200 Jesper Dangaard Brouer wrote:
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index c3efc7d658f6..790dd28fd198 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1077,7 +1077,9 @@ static int __ip_append_data(struct sock *sk,
> >  			if ((flags & MSG_MORE) &&
> >  			    !(rt->dst.dev->features&NETIF_F_SG))
> >  				alloclen = mtu;
> > -			else if (!paged)
> > +			else if (!paged &&
> > +				 (fraglen + hh_len + 15 < SKB_MAX_ALLOC ||  
> 
> What does the number 15 represent here?

No idea, it's there on the allocation line, so I need to include it on
the size check.

Looking at super old code (2.4.x) it looks like it may have gotten
copy & pasted mistakenly? The hard headers are rounded up to 16B,
and there is code which does things like:

	skb_alloc(size + dev->hard_header_len + 15);
	skb_reserve(skb, (dev->hard_header_len + 15) & ~15);

in other spots. So if I was to guess I'd say someone decided to add the
15B "to be safe" even though hh_len already includes the round up here.

But that's just my guess. I can't get this simple patch right,
so take that with a grain of salt :/

> > +				  !(rt->dst.dev->features & NETIF_F_SG)))
> >  				alloclen = fraglen;
> >  			else {
> >  				alloclen = min_t(int, fraglen, MAX_HEADER);
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index ff4f9ebcf7f6..ae8dbd6cdab1 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -1585,7 +1585,9 @@ static int __ip6_append_data(struct sock *sk,
> >  			if ((flags & MSG_MORE) &&
> >  			    !(rt->dst.dev->features&NETIF_F_SG))
> >  				alloclen = mtu;
> > -			else if (!paged)
> > +			else if (!paged &&
> > +				 (fraglen + hh_len < SKB_MAX_ALLOC ||  
> 
> The number 15 is not use here.
> 
> > +				  !(rt->dst.dev->features & NETIF_F_SG)))
> >  				alloclen = fraglen;
> >  			else {
> >  				alloclen = min_t(int, fraglen, MAX_HEADER);  
