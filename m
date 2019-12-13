Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B763711E1E3
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfLMKZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 05:25:23 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39274 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbfLMKZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 05:25:22 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ifi8G-0002dj-1t; Fri, 13 Dec 2019 11:25:12 +0100
Date:   Fri, 13 Dec 2019 11:25:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Josh Hunt <johunt@akamai.com>, herbert@gondor.apana.org.au,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: Re: crash in __xfrm_state_lookup on 4.19 LTS
Message-ID: <20191213102512.GP795@breakpoint.cc>
References: <0b3ab776-2b8b-1725-d36e-70af66c138da@akamai.com>
 <20191212132132.GL8621@gauss3.secunet.de>
 <c328f835-6eb7-3ab9-1f7c-dc565634f8bd@akamai.com>
 <20191213072144.GC26283@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213072144.GC26283@gauss3.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > index f3423562d933..c3d7df1387c8 100644
> > --- a/net/xfrm/xfrm_state.c
> > +++ b/net/xfrm/xfrm_state.c
> > @@ -1730,9 +1730,9 @@ xfrm_state_lookup(struct net *net, u32 mark, const
> > xfrm_address_t *daddr, __be32
> >  {
> >         struct xfrm_state *x;
> > 
> > -       rcu_read_lock();
> > +       spin_lock_bh(&net->xfrm.xfrm_state_lock);
> >         x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
> > -       rcu_read_unlock();
> > +       spin_unlock_bh(&net->xfrm.xfrm_state_lock);
> >         return x;
> >  }
> 
> While that could fix it, it adds a global list lock
> to the packet path and reverts:
> 
> commit c2f672fc94642bae96821a393f342edcfa9794a6
> xfrm: state lookup can be lockless
> 
> I've Cced Florian who did that change.
> 
> I thought to do a rcu_read_lock_bh(), but in between I think
> it would make the problem just less likely to occur.
> 
> We destroy the states with a workqueue by doing schedule_work().
> I think we should better use call_rcu to make sure that a
> rcu grace period has elapsed before the states are destroyed.

xfrm_state_gc_task calls synchronize_rcu after stealing the gc list and
before destroying those states, so I don't think this is a problem.
