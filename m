Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731BC3B1E2C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFWQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230430AbhFWQA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 12:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B365C61185;
        Wed, 23 Jun 2021 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624463892;
        bh=jKEiGAXnxSXo3RHC0lrQbhadWC1tT6+zc+wLZ0+di/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qUrAt7DylkFn4mxXbMyj6WZLymouTgdurhqSptzl0iKCYnN/7ECt7vuO7rTi8Oz4D
         dz29OlePgZOthr2Lfm25u+0To4uPmN6ItyngFtKC5IWDCC0Aeq8hA5yBtBx8lnh30T
         AkFcT33d5/OYBtyP/3nKvzkL6FFyxgZcYJlwvc+l0DHr1Rf2raxKcQNkVgCBJ55r1a
         +Intc0NoKmNkYIb7uMrWbSKIGBPYFbnstKtHjuDv3A7qCzcj7rpBg5I9o9I/Ak8L83
         cfXMWeQvdqyqDJwQVH9fI+nIoc2OygNoGlrB9z2bf8AiM6qh173SuID/OAoZX0bSnt
         n866FhahH14gw==
Date:   Wed, 23 Jun 2021 08:58:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next v2 2/2] net: ip: avoid OOM kills with large UDP
 sends over loopback
Message-ID: <20210623085810.7e281e8d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <11f88247-3193-bae4-39e5-03a5672578f9@gmail.com>
References: <20210622225057.2108592-1-kuba@kernel.org>
        <20210622225057.2108592-2-kuba@kernel.org>
        <11f88247-3193-bae4-39e5-03a5672578f9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 16:25:18 +0200 Eric Dumazet wrote:
> On 6/23/21 12:50 AM, Jakub Kicinski wrote:
> > Dave observed number of machines hitting OOM on the UDP send
> > path. The workload seems to be sending large UDP packets over
> > loopback. Since loopback has MTU of 64k kernel will try to
> > allocate an skb with up to 64k of head space. This has a good
> > chance of failing under memory pressure. What's worse if
> > the message length is <32k the allocation may trigger an
> > OOM killer.
> > 
> > This is entirely avoidable, we can use an skb with frags.  
> 
> Are you referring to IP fragments, or page frags ?

page frags, annoyingly overloaded term. I'll say paged, it's 
not the common term but at least won't be confusing.

> > af_unix solves a similar problem by limiting the head
> > length to SKB_MAX_ALLOC. This seems like a good and simple
> > approach. It means that UDP messages > 16kB will now
> > use fragments if underlying device supports SG, if extra
> > allocator pressure causes regressions in real workloads
> > we can switch to trying the large allocation first and
> > falling back.
> > 
> > Reported-by: Dave Jones <dsj@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/ipv4/ip_output.c  | 2 +-
> >  net/ipv6/ip6_output.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 90031f5446bd..1ab140c173d0 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1077,7 +1077,7 @@ static int __ip_append_data(struct sock *sk,
> >  
> >  			if ((flags & MSG_MORE) && !has_sg)
> >  				alloclen = mtu;
> > -			else if (!paged)
> > +			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))  
> 
> This looks indeed better, but there are some boundary conditions,
> caused by the fact that we add hh_len+15 later when allocating the skb.
> 
> (I expect hh_len+15 being 31)
> 
> 
> You probably need 
> 	else if (!paged && (fraglen + hh_len + 15 < SKB_MAX_ALLOC || !has_sg))
> 
> Otherwise we might still attempt order-3 allocations ?
> 
> SKB_MAX_ALLOC is 16064 currently (skb_shinfo size being 320 on 64bit arches)
> 
> An UDP message with 16034 bytes of payload would translate to
> alloclen==16062. If we add 28 bytes for UDP+IP headers, plus 31 bytes for hh_len+31
> this would go to 16413, thus asking for 32768 bytes (order-3 page)
> 
> (16062+320 = 16382, which is smaller than 16384)

Will do, thanks!

> >  				alloclen = fraglen;
> >  			else {
> >  				alloclen = min_t(int, fraglen, MAX_HEADER);
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index c667b7e2856f..46d805097a79 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -1585,7 +1585,7 @@ static int __ip6_append_data(struct sock *sk,
> >  
> >  			if ((flags & MSG_MORE) && !has_sg)
> >  				alloclen = mtu;
> > -			else if (!paged)
> > +			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))
> >  				alloclen = fraglen;
> >  			else {
> >  				alloclen = min_t(int, fraglen, MAX_HEADER);
> >   

