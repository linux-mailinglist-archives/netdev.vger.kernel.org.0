Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF23BEC71
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGGQpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhGGQo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 12:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F96B61CC9;
        Wed,  7 Jul 2021 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625676139;
        bh=p7JWEZZ5FyAZ7TfdKVc9jFwbgMkD0Zwgu/xDE16ibq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p2lsV6uRzSOYznp5RCxMxmV5VKDFOZV1hVH0xAobKXWR77l40gM0ZkZs/2LjArsC4
         S6Yeq/rzemP9/1x+/90+ri5znqSrB7v0onIBPRgipOziSeF0EdQeN6HTsQefyEP5cW
         +B7qXtSztUyP5ydIfmzD0S/k8L6+Ki88hsJh+h5wEZD6IRqO1zF85VSUd3ymjGYKDN
         4oblNR7VdrBXlfM0QCIBqWZ7x/cZxRo76rAp9+h+byhd7SK2gnKSX84FeiZZxDLTQF
         JJXdjx0HkDdN5EIa6cz1EcDeG1kVQ225jNzLqooIZNaLM00ZGBptxy3unHi3kI5O3r
         3NGRY1b2cY3sg==
Date:   Wed, 7 Jul 2021 09:42:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
Message-ID: <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
References: <cover.1625665132.git.vvs@virtuozzo.com>
        <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
        <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 08:45:13 -0600 David Ahern wrote:
> On 7/7/21 8:04 AM, Vasily Averin wrote:
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index ff4f9eb..e5af740 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -61,9 +61,24 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
> >  	struct dst_entry *dst = skb_dst(skb);
> >  	struct net_device *dev = dst->dev;
> >  	const struct in6_addr *nexthop;
> > +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
> >  	struct neighbour *neigh;
> >  	int ret;
> >  
> > +	/* Be paranoid, rather than too clever. */
> > +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> > +		struct sk_buff *skb2;
> > +
> > +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));  
> 
> why not use hh_len here?

Is there a reason for the new skb? Why not pskb_expand_head()?

> > +		if (!skb2) {
> > +			kfree_skb(skb);
> > +			return -ENOMEM;
> > +		}
> > +		if (skb->sk)
> > +			skb_set_owner_w(skb2, skb->sk);
> > +		consume_skb(skb);
> > +		skb = skb2;
> > +	}
> >  	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
> >  		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));


