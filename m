Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053B94ED4C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfFUQle convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jun 2019 12:41:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43922 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfFUQld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:41:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1heMbT-0000zX-1t; Fri, 21 Jun 2019 18:41:31 +0200
Date:   Fri, 21 Jun 2019 18:41:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
Message-ID: <20190621164131.6ghtx6b7dzivsfxk@breakpoint.cc>
References: <20190618130050.8344-1-jakub@cloudflare.com>
 <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com>
 <20190621125155.2sdw7pugepj3ityx@breakpoint.cc>
 <f373a4d7-c16b-bce2-739d-788525ea4f96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <f373a4d7-c16b-bce2-739d-788525ea4f96@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > AFAICS so far this would be enough:
> > 
> > 1. remove the BUG_ON() in skb_orphan, letting it clear skb->sk instead
> > 2. in nf_queue_entry_get_refs(), if skb->sk and no destructor:
> >    call nf_tproxy_assign_sock() so a reference gets taken.
> > 3. change skb_steal_sock:
> >    static inline struct sock *skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> >     [..]
> >     *refcounted = skb->destructor != NULL;
> > 4. make tproxy sk assign elide the destructor assigment in case of
> >    a listening sk.
> > 
> 
> Okay, but how do we make sure the skb->sk association does not leak from rcu section ?

From netfilter pov the only escape point is nfqueue (and kfree_skb),
so for tcp/udp it will end up in their respective rx path eventually.
But you are right in that we need to also audit all NF_STOLEN users that
can be invoked from PRE_ROUTING and INPUT hooks.

OUTPUT/FORWARD/POSTROUTING are not relevant, in case skb enters IP forwarding,
it will be dropped there (we have a check to toss skb with socket
attached in forward).

In recent hallway discussion Eric suggested to add a empty destructor
stub, it would allow to do the needed annotation, i.e.
no need to change skb_orphan(), *refcounted would be set via
skb->destructor != noref_listen_skb_destructor check.

> Note we have the noref/refcounted magic for skb_dst(), we might try to use something similar
> for skb->sk

Yes, would be more code churn because we have to replace skb->sk access
by a helper to mask off NOREF bit (or we need to add a "noref" bit in
sk_buff itself).
