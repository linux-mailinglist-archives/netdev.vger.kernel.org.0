Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158B94ED76
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfFUQyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUQyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 12:54:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1FC431628EC;
        Fri, 21 Jun 2019 16:54:31 +0000 (UTC)
Received: from ovpn-117-217.ams2.redhat.com (ovpn-117-217.ams2.redhat.com [10.36.117.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C387604CC;
        Fri, 21 Jun 2019 16:54:29 +0000 (UTC)
Message-ID: <68be4409580e99b1487b32f36bfc52f3e3f79530.camel@redhat.com>
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
From:   Paolo Abeni <pabeni@redhat.com>
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Date:   Fri, 21 Jun 2019 18:54:27 +0200
In-Reply-To: <20190621164131.6ghtx6b7dzivsfxk@breakpoint.cc>
References: <20190618130050.8344-1-jakub@cloudflare.com>
         <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
         <87sgs6ey43.fsf@cloudflare.com>
         <20190621125155.2sdw7pugepj3ityx@breakpoint.cc>
         <f373a4d7-c16b-bce2-739d-788525ea4f96@gmail.com>
         <20190621164131.6ghtx6b7dzivsfxk@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 21 Jun 2019 16:54:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2019-06-21 at 18:41 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > AFAICS so far this would be enough:
> > > 
> > > 1. remove the BUG_ON() in skb_orphan, letting it clear skb->sk instead
> > > 2. in nf_queue_entry_get_refs(), if skb->sk and no destructor:
> > >    call nf_tproxy_assign_sock() so a reference gets taken.
> > > 3. change skb_steal_sock:
> > >    static inline struct sock *skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> > >     [..]
> > >     *refcounted = skb->destructor != NULL;
> > > 4. make tproxy sk assign elide the destructor assigment in case of
> > >    a listening sk.
> > > 
> > 
> > Okay, but how do we make sure the skb->sk association does not leak from rcu section ?
> 
> From netfilter pov the only escape point is nfqueue (and kfree_skb),
> so for tcp/udp it will end up in their respective rx path eventually.
> But you are right in that we need to also audit all NF_STOLEN users that
> can be invoked from PRE_ROUTING and INPUT hooks.
> 
> OUTPUT/FORWARD/POSTROUTING are not relevant, in case skb enters IP forwarding,
> it will be dropped there (we have a check to toss skb with socket
> attached in forward).
> 
> In recent hallway discussion Eric suggested to add a empty destructor
> stub, it would allow to do the needed annotation, i.e.
> no need to change skb_orphan(), *refcounted would be set via
> skb->destructor != noref_listen_skb_destructor check.

Perhaps I'm misreading the above, but it looks like this has some
overlapping with a past attempt:

https://marc.info/?l=linux-netdev&m=150611442802964&w=2

Cheers,

Paolo

