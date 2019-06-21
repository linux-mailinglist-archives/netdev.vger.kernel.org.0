Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA784F039
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 22:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfFUU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 16:59:38 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44948 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfFUU7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 16:59:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1heQdD-0002FZ-Bo; Fri, 21 Jun 2019 22:59:35 +0200
Date:   Fri, 21 Jun 2019 22:59:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Removing skb_orphan() from ip_rcv_core()
Message-ID: <20190621205935.og7ajx57j7usgycq@breakpoint.cc>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Stringer <joe@wand.net.nz> wrote:
> As discussed during LSFMM, I've been looking at adding something like
> an `skb_sk_assign()` helper to BPF so that logic similar to TPROXY can
> be implemented with integration into other BPF logic, however
> currently any attempts to do so are blocked by the skb_orphan() call
> in ip_rcv_core() (which will effectively ignore any socket assign
> decision made by the TC BPF program).
> 
> Recently I was attempting to remove the skb_orphan() call, and I've
> been trying different things but there seems to be some context I'm
> missing. Here's the core of the patch:
> 
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index ed97724c5e33..16aea980318a 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -500,8 +500,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff
> *skb, struct net *net)
>        memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
>        IPCB(skb)->iif = skb->skb_iif;
> 
> -       /* Must drop socket now because of tproxy. */
> -       skb_orphan(skb);
> 
>        return skb;
> 
> The statement that the socket must be dropped because of tproxy
> doesn't make sense to me, because the PRE_ROUTING hook is hit after
> this, which will call into the tproxy logic and eventually
> nf_tproxy_assign_sock() which already does the skb_orphan() itself.

in comment: s/tproxy/skb_steal_sock/

at least thats what I concluded a few years ago when I looked into
the skb_oprhan() need.

IIRC some device drivers use skb->sk for backpressure, so without this
non-tcp socket would be stolen by skb_steal_sock.

We also recently removed skb orphan when crossing netns:

commit 9c4c325252c54b34d53b3d0ffd535182b744e03d
Author: Flavio Leitner <fbl@redhat.com>
skbuff: preserve sock reference when scrubbing the skb.

So thats another case where this orphan is needed.

What could be done is adding some way to delay/defer the orphaning
further, but we would need at the very least some annotation for
skb_steal_sock to know when the skb->sk is really from TPROXY or
if it has to orphan.

Same for the safety check in the forwarding path.
Netfilter modules need o be audited as well, they might make assumptions
wrt. skb->sk being inet sockets (set by local stack or early demux).

> However, if I drop these lines then I end up causing sockets to
> release references too many times. Seems like if we don't orphan the
> skb here, then later logic assumes that we have one more reference
> than we actually have, and decrements the count when it shouldn't
> (perhaps the skb_steal_sock() call in __inet_lookup_skb() which seems
> to assume we always have a reference to the socket?)

We might be calling the wrong destructor (i.e., the one set by tcp
receive instead of the one set at tx time)?
