Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB614E84B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 14:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFUMv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 08:51:57 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42660 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbfFUMv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 08:51:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1heJ1H-0007uu-2s; Fri, 21 Jun 2019 14:51:55 +0200
Date:   Fri, 21 Jun 2019 14:51:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
Message-ID: <20190621125155.2sdw7pugepj3ityx@breakpoint.cc>
References: <20190618130050.8344-1-jakub@cloudflare.com>
 <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgs6ey43.fsf@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > So, at least for this part I don't see a technical reason why this
> > has to grab a reference for listener socket.
> 
> That's helpful, thanks! We rely on TPROXY, so I would like to help with
> that. Let me see if I can get time to work on it.

AFAICS so far this would be enough:

1. remove the BUG_ON() in skb_orphan, letting it clear skb->sk instead
2. in nf_queue_entry_get_refs(), if skb->sk and no destructor:
   call nf_tproxy_assign_sock() so a reference gets taken.
3. change skb_steal_sock:
   static inline struct sock *skb_steal_sock(struct sk_buff *skb, bool *refcounted)
    [..]
    *refcounted = skb->destructor != NULL;
4. make tproxy sk assign elide the destructor assigment in case of
   a listening sk.

This should work because TPROXY target is restricted to PRE_ROUTING, and
__netif_receive_skb_core runs with rcu readlock already held.

On a side note, it would also be interesting to see what breaks if the
nf_tproxy_sk_is_transparent() check in the tprox eval function is
removed -- if we need the transparent:1 marker only for output, i think
it would be ok to raise the bit transparently in the kernel in case
we assign skb->sk = found_sk; i.e.
 if (unlikely(!sk_is_transparent(sk))
	 make_sk_transparent(sk);

I don't see a reason why we need the explicit setsockopt(IP_TRANSPARENT)
from userspace.
