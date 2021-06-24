Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684D43B33F0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFXQas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXQao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E55613C7;
        Thu, 24 Jun 2021 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624552105;
        bh=0eCSVwcHM/SBTZCb7Rzxy3Mo0ffe1VZFNd0rw7ZVjfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kVXC/sFFEkCCSLHGlCiw5elkHuAhSKe1rJlDE8Y+T1bXxhCNBxv64Hj8TIuyEKsVk
         j6aYxLC9tcyy2obmgt9+7AlszkZ1apnKX5bhedmffG5DlebJj9jszb9sOnXmVNDNU/
         rV/nKhD+ey6y+0THuElMeIYN+zGKx3dSnzsbtXZocx1BG/k5nge6NNba2HYgeGC5Yu
         xttljW41FPo/MjQ/7KenlY9wnbLBYQ32KXv4YFdulhA9aXJTmeuigmjiHjyy9H2HUF
         +uxbzo+lvR8za5dIGJ0lLeaCfwvLuQfYTYnfiuTh0xf5x2v7/W1tb2bPHHoxiM6tsN
         BcfNmb6MbQIxg==
Date:   Thu, 24 Jun 2021 09:28:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        brouer@redhat.com, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next v4] net: ip: avoid OOM kills with large UDP
 sends over loopback
Message-ID: <20210624092824.7d7103a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
References: <20210623214438.2276538-1-kuba@kernel.org>
        <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 22:21:11 -0400 Willem de Bruijn wrote:
> On Wed, Jun 23, 2021 at 5:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Dave observed number of machines hitting OOM on the UDP send
> > path. The workload seems to be sending large UDP packets over
> > loopback. Since loopback has MTU of 64k kernel will try to
> > allocate an skb with up to 64k of head space. This has a good
> > chance of failing under memory pressure. What's worse if
> > the message length is <32k the allocation may trigger an
> > OOM killer.
> >
> > This is entirely avoidable, we can use an skb with page frags.
> >
> > af_unix solves a similar problem by limiting the head
> > length to SKB_MAX_ALLOC. This seems like a good and simple
> > approach. It means that UDP messages > 16kB will now
> > use fragments if underlying device supports SG, if extra
> > allocator pressure causes regressions in real workloads
> > we can switch to trying the large allocation first and
> > falling back.
> >
> > v4: pre-calculate all the additions to alloclen so
> >     we can be sure it won't go over order-2
> >
> > Reported-by: Dave Jones <dsj@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/ipv4/ip_output.c  | 32 ++++++++++++++++++--------------
> >  net/ipv6/ip6_output.c | 32 +++++++++++++++++---------------
> >  2 files changed, 35 insertions(+), 29 deletions(-)
> >
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index c3efc7d658f6..8d8a8da3ae7e 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1054,7 +1054,7 @@ static int __ip_append_data(struct sock *sk,
> >                         unsigned int datalen;
> >                         unsigned int fraglen;
> >                         unsigned int fraggap;
> > -                       unsigned int alloclen;
> > +                       unsigned int alloclen, alloc_extra;  
> 
> Separate line?

But why? What makes it preferable to have logically connected variables
declared on separate lines? The function is already 300 LoC. I've been
meaning to ask someone about this preference for a while :)

> >                         unsigned int pagedlen;
> >                         struct sk_buff *skb_prev;
> >  alloc_new_skb:
> > @@ -1074,35 +1074,39 @@ static int __ip_append_data(struct sock *sk,
> >                         fraglen = datalen + fragheaderlen;
> >                         pagedlen = 0;
> >
> > +                       alloc_extra = hh_len + 15;
> > +                       alloc_extra += exthdrlen;
> > +
> > +                       /* The last fragment gets additional space at tail.
> > +                        * Note, with MSG_MORE we overallocate on fragments,
> > +                        * because we have no idea what fragment will be
> > +                        * the last.
> > +                        */
> > +                       if (datalen == length + fraggap)
> > +                               alloc_extra += rt->dst.trailer_len;
> > +
> >                         if ((flags & MSG_MORE) &&
> >                             !(rt->dst.dev->features&NETIF_F_SG))
> >                                 alloclen = mtu;
> > -                       else if (!paged)
> > +                       else if (!paged &&
> > +                                (fraglen + alloc_extra < SKB_MAX_ALLOC ||
> > +                                 !(rt->dst.dev->features & NETIF_F_SG)))  
> 
> This perhaps deserves a comment. Something like this?
> 
>   /* avoid order-3 allocations where possible: replace with frags if
> allowed (sg) */

Here I thought comparing skb alloc size to SKB_MAX_ALLOC is explanatory
enough ;)

In the middle of the test, like this, right?

                 else if (!paged &&
                          /* avoid order-3 allocations if device
                           * can handle skb frags (sg)
                           */
                          (fraglen + alloc_extra < SKB_MAX_ALLOC ||
                          !(rt->dst.dev->features & NETIF_F_SG)))  

I should make it less-equal while at it.

> >                                 alloclen = fraglen;
> >                         else {
> >                                 alloclen = min_t(int, fraglen, MAX_HEADER);
> >                                 pagedlen = fraglen - alloclen;
> >                         }
> >
> > -                       alloclen += exthdrlen;
> > -
> > -                       /* The last fragment gets additional space at tail.
> > -                        * Note, with MSG_MORE we overallocate on fragments,
> > -                        * because we have no idea what fragment will be
> > -                        * the last.
> > -                        */
> > -                       if (datalen == length + fraggap)
> > -                               alloclen += rt->dst.trailer_len;
> > +                       alloclen += alloc_extra;
> >
> >                         if (transhdrlen) {
> > -                               skb = sock_alloc_send_skb(sk,
> > -                                               alloclen + hh_len + 15,
> > +                               skb = sock_alloc_send_skb(sk, alloclen,
> >                                                 (flags & MSG_DONTWAIT), &err);
> >                         } else {
> >                                 skb = NULL;
> >                                 if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
> >                                     2 * sk->sk_sndbuf)
> > -                                       skb = alloc_skb(alloclen + hh_len + 15,
> > +                                       skb = alloc_skb(alloclen,
> >                                                         sk->sk_allocation);
> >                                 if (unlikely(!skb))
> >                                         err = -ENOBUFS;  
> 
> Is there any risk of regressions? If so, would it be preferable to try
> regular alloc and only on failure, just below here, do the size and SG
> test and if permitted jump back to the last of the three alloc_len
> options?

There is, that's what I tried in v1, Eric pointed out that we can't
modify sk->sk_allocation here because UDP fast path doesn't take the
lock, and pointed out that UNIX code has to handle similar problem. 
So I decided to just copy what AF_UNIX does. In practical terms
MTU > 16k is highly unlikely on physical devices (AFAIK) and with
messages that large hopefully the trip thru the memory allocator won't
be all that noticeable? If we were capping at one page that'd be a
problem, but my gut feeling was that order-2 cap is unlikely to hurt.

But I can go back, I'd have to refactor sock_alloc_send_pskb() to pass
gfp_t explicitly. Probably by creating another layer of helpers
(__sock_alloc_send_pskb()?). sock_alloc_send_pskb() already takes 6
params so I was also thinking of converting it to ERR_PTR() return
(instead of passing the error pointer) (6 is max for register passing).

Should I go back to retry?
