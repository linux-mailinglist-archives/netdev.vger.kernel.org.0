Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812454C19B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFSTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:41:13 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50311 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfFSTlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:41:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 294872104A;
        Wed, 19 Jun 2019 15:41:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 15:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OMe9fw
        3KZG3r+NteQ/iy/R2/v9HNAoflytVf85hj7+s=; b=rBipBGwrgxLMocd7U31YE4
        ZuIj2pJwZseaa0jTnAd9Zm93YfcOTcnBfE5r6fIDwEu9uTHtAKYKh3YIJ31+5434
        hqQLGbZFJgplY1HfNfapiL7anMjQUHRlzyShvMOmcVsyB/290aVEhWlaTkvF6hT7
        S3lYhjwQkpIxFNQSORfE5ddwo2AiRg4ARBZ4cARFhTAn57nKXeH9v2fCrgPC8UzV
        6xkJCLN/gCQu66yBD0MzishDpdfSNgzCeyORZowVlcxJe3ar7br2CrIuyRsyRhyG
        H3gXgSnG+8DTpsy0Gir8NnvRRxSXW//m8Pt7kCZLX229uUVkPbJ2SH2kR5rKLMJA
        ==
X-ME-Sender: <xms:1Y8KXTjXOMCGHtIb7mdZEL_7NLHq7yVpZjmBI0RwDJ0vmtpy5OCKPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeejje
    drudefkedrvdegledrvddtleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1Y8KXWf1l_BJFnxFgQYHJKa4B4ZqE7KNofeAT3A6RELl-yc0jtKw6A>
    <xmx:1Y8KXb49UVJ4BG5CkLBDWUgl40qtebMoRtmTS0WG9apr5G6kgbgB2Q>
    <xmx:1Y8KXfjx5ynvfXQln5MU3NrKynqZpYHyyaazhjrbiWT8pdW6ogDiJQ>
    <xmx:1o8KXcp_g9WrkJKdbHplgFsWRcAjhTWalG3OkzOuOR5ki4V6sUducw>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F46C80063;
        Wed, 19 Jun 2019 15:41:08 -0400 (EDT)
Date:   Wed, 19 Jun 2019 22:40:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next] ipv6: Check if route exists before notifying it
Message-ID: <20190619194058.GA8498@splinter>
References: <20190619175500.7145-1-idosch@idosch.org>
 <69f3262d-e6d0-943e-20a0-c711be4d35d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f3262d-e6d0-943e-20a0-c711be4d35d7@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 01:10:08PM -0600, David Ahern wrote:
> On 6/19/19 11:55 AM, Ido Schimmel wrote:
> > diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> > index 1d16a01eccf5..241a0e9a07c3 100644
> > --- a/net/ipv6/ip6_fib.c
> > +++ b/net/ipv6/ip6_fib.c
> > @@ -393,6 +393,8 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
> >  		.nsiblings = nsiblings,
> >  	};
> >  
> > +	if (!rt)
> > +		return -EINVAL;
> >  	rt->fib6_table->fib_seq++;
> >  	return call_fib6_notifiers(net, event_type, &info.info);
> >  }
> 
> The call to call_fib6_multipath_entry_notifiers in
> ip6_route_multipath_add happens without rt_notif set because the MPATH
> spec is empty? 

There is a nexthop in the syzbot reproducer, but its length is shorter
than sizeof(struct rtnexthop).

> It seems like that check should be done in ip6_route_multipath_add
> rather than call_fib6_multipath_entry_notifiers with an extack saying
> the reason for the failure.

It seemed consistent with ip6_route_mpath_notify(). We can check if
rt6_nh_list is empty and send a proper error message. I'll do that
tomorrow morning since it's already late here.

> My expectation for call_fib6_multipath_entry_notifiers is any errors are
> only for offload handlers. (And we need to get extack added to that for
> relaying reasons.)

We already have extack there...
