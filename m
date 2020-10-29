Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20F29E747
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgJ2J2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgJ2J2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:28:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79990C0613CF;
        Thu, 29 Oct 2020 02:28:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kY4EY-0007hc-HH; Thu, 29 Oct 2020 10:28:38 +0100
Date:   Thu, 29 Oct 2020 10:28:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf 2/2] netfilter: use actual socket sk rather than skb
 sk when routing harder
Message-ID: <20201029092838.GC15770@breakpoint.cc>
References: <20201029025606.3523771-1-Jason@zx2c4.com>
 <20201029025606.3523771-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029025606.3523771-3-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> If netfilter changes the packet mark when mangling, the packet is
> rerouted using the route_me_harder set of functions. Prior to this
> commit, there's one big difference between route_me_harder and the
> ordinary initial routing functions, described in the comment above
> __ip_queue_xmit():
> 
>    /* Note: skb->sk can be different from sk, in case of tunnels */
>    int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
> 
> That function goes on to correctly make use of sk->sk_bound_dev_if,
> rather than skb->sk->sk_bound_dev_if. And indeed the comment is true: a
> tunnel will receive a packet in ndo_start_xmit with an initial skb->sk.
> It will make some transformations to that packet, and then it will send
> the encapsulated packet out of a *new* socket. That new socket will
> basically always have a different sk_bound_dev_if (otherwise there'd be
> a routing loop). So for the purposes of routing the encapsulated packet,
> the routing information as it pertains to the socket should come from
> that socket's sk, rather than the packet's original skb->sk. For that
> reason __ip_queue_xmit() and related functions all do the right thing.
> 
> One might argue that all tunnels should just call skb_orphan(skb) before
> transmitting the encapsulated packet into the new socket. But tunnels do
> *not* do this -- and this is wisely avoided in skb_scrub_packet() too --
> because features like TSQ rely on skb->destructor() being called when
> that buffer space is truely available again. Calling skb_orphan(skb) too
> early would result in buffers filling up unnecessarily and accounting
> info being all wrong. Instead, additional routing must take into account
> the new sk, just as __ip_queue_xmit() notes.
> 
> So, this commit addresses the problem by fishing the correct sk out of
> state->sk -- it's already set properly in the call to nf_hook() in
> __ip_local_out(), which receives the sk as part of its normal
> functionality. So we make sure to plumb state->sk through the various
> route_me_harder functions, and then make correct use of it following the
> example of __ip_queue_xmit().

Reviewed-by: Florian Westphal <fw@strlen.de>
