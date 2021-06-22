Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D83B0AB6
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhFVQ4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhFVQ4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4ED56128E;
        Tue, 22 Jun 2021 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624380863;
        bh=b9b4NkRRK3gv50twvnktyVXHKJ8zXX6J3NFPrZwvvNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OyB5VK9A8wXxYjqegIbqwZ+vvxQfABejc01PuTBtKzX/MnPywxiC9VbLuCTbIvvyZ
         3GEvWr/EIF2q63h4u75lWvKkXeA/MCooMsY6Vzy2Vax3Zu1DNABKYER0eCUkGOMKNR
         4w3LttsSXbj3FBgvP372uiRkpOIEmFivh2h+9c580aeC/Hl2B1ZPJepfYoyROoAMJP
         DSF6i5GKoJNe7ogdEMxBJMvHNLfoLOCOycCPfIWe9yewdaqhyOe6xlydNmz5KP854Y
         0K8m9/GJVBr3B83y/mN7/Gdv9+5p36P9ThWVdhrnvyNNJTbxtKtwFQ6GdaHs7tbYFs
         S+7zgn4D1JYZA==
Date:   Tue, 22 Jun 2021 09:54:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 16:12:11 +0200 Eric Dumazet wrote:
> On 6/22/21 1:13 AM, Jakub Kicinski wrote:
> > Dave observed number of machines hitting OOM on the UDP send
> > path. The workload seems to be sending large UDP packets over
> > loopback. Since loopback has MTU of 64k kernel will try to
> > allocate an skb with up to 64k of head space. This has a good
> > chance of failing under memory pressure. What's worse if
> > the message length is <32k the allocation may trigger an
> > OOM killer.
> > 
> > This is entirely avoidable, we can use an skb with frags.
> > 
> > The scenario is unlikely and always using frags requires
> > an extra allocation so opt for using fallback, rather
> > then always using frag'ed/paged skb when payload is large.
> > 
> > Note that the size heuristic (header_len > PAGE_SIZE)
> > is not entirely accurate, __alloc_skb() will add ~400B
> > to size. Occasional order-1 allocation should be fine,
> > though, we are primarily concerned with order-3.
> > 
> > Reported-by: Dave Jones <dsj@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>

> > +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
> > +{
> > +	*old = sk->sk_allocation;
> > +	sk->sk_allocation |= flag;
> > +}
> > +  
> 
> This is not thread safe.
> 
> Remember UDP sendmsg() does not lock the socket for non-corking sends.

Ugh, you're right :(

> > +static inline void sk_allocation_pop(struct sock *sk, gfp_t old)
> > +{
> > +	sk->sk_allocation = old;
> > +}
> > +
> >  static inline void sk_acceptq_removed(struct sock *sk)
> >  {
> >  	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index c3efc7d658f6..a300c2c65d57 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
> >  				alloclen += rt->dst.trailer_len;
> >  
> >  			if (transhdrlen) {
> > -				skb = sock_alloc_send_skb(sk,
> > -						alloclen + hh_len + 15,
> > +				size_t header_len = alloclen + hh_len + 15;
> > +				gfp_t sk_allocation;
> > +
> > +				if (header_len > PAGE_SIZE)
> > +					sk_allocation_push(sk, __GFP_NORETRY,
> > +							   &sk_allocation);
> > +				skb = sock_alloc_send_skb(sk, header_len,
> >  						(flags & MSG_DONTWAIT), &err);
> > +				if (header_len > PAGE_SIZE) {
> > +					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
> > +
> > +					sk_allocation_pop(sk, sk_allocation);
> > +					if (unlikely(!skb) && !paged &&
> > +					    rt->dst.dev->features & NETIF_F_SG) {
> > +						paged = true;
> > +						goto alloc_new_skb;
> > +					}
> > +				}  
> 
> 
> What about using sock_alloc_send_pskb(... PAGE_ALLOC_COSTLY_ORDER)
> (as we did in unix_dgram_sendmsg() for large packets), for SG enabled interfaces ?

PAGE_ALLOC_COSTLY_ORDER in itself is more of a problem than a solution.
AFAIU the app sends messages primarily above the ~60kB mark, which is
above COSTLY, and those do not trigger OOM kills. All OOM kills we see
have order=3. Checking with Rik and Johannes W that's expected, OOM
killer is only invoked for allocations <= COSTLY, larger ones will just
return NULL and let us deal with it (e.g. by falling back).

So adding GFP_NORETRY is key for 0 < order <= COSTLY,
skb_page_frag_refill()-style.

> We do not _have_ to put all the payload in skb linear part,
> we could instead use page frags (order-0 if high order pages are not available)
