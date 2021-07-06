Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DE3BCAC4
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhGFKwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 06:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhGFKwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 06:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA35619A9;
        Tue,  6 Jul 2021 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625568567;
        bh=GwNQpm53q/wD0dTeAU0sFMJs9aBW0jJQzZ/Q08A+rOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hF+CJyGwa8VJ58W3zQfKAuUsEM7xJsHylSntyaxp050NhC0NH15kZ1d7AYJjL/EGy
         h5zsyzA8R3nfLDIJfLFqAJgm5XK/SzweauEFiEhBqboTBkjqEzsPpYmRsm1dVyAPC2
         mq2lki54A9DBlljf3nCgswDbXqTHKuMxAX4B31gmiItaiDl1VsuYK2pliAaUxT8jMX
         Rcy26GPNbWZM6WCPlHPIPcyAMgJ7H5SegyOKIKIbu2HaANuu1rXx30ZJj+b6u69lgP
         wloSqlmfoNr9cPyAVsTLABR/dq85ZDTu2uLhjpdSsnZX39EeItD0zrvwRpeNH2X01D
         +htI3dExU6Faw==
Date:   Tue, 6 Jul 2021 12:49:24 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        stable@vger.kernel.org, Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Message-ID: <20210706104924.GA107277@lothringen>
References: <20210628133428.5660-1-frederic@kernel.org>
 <20210630065753.GU40979@gauss3.secunet.de>
 <20210705115850.GF40979@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705115850.GF40979@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 01:58:50PM +0200, Steffen Klassert wrote:
> On Wed, Jun 30, 2021 at 08:57:53AM +0200, Steffen Klassert wrote:
> > On Mon, Jun 28, 2021 at 03:34:28PM +0200, Frederic Weisbecker wrote:
> > > xfrm_bydst_resize() calls synchronize_rcu() while holding
> > > hash_resize_mutex. But then on PREEMPT_RT configurations,
> > > xfrm_policy_lookup_bytype() may acquire that mutex while running in an
> > > RCU read side critical section. This results in a deadlock.
> > > 
> > > In fact the scope of hash_resize_mutex is way beyond the purpose of
> > > xfrm_policy_lookup_bytype() to just fetch a coherent and stable policy
> > > for a given destination/direction, along with other details.
> > > 
> > > The lower level net->xfrm.xfrm_policy_lock, which among other things
> > > protects per destination/direction references to policy entries, is
> > > enough to serialize and benefit from priority inheritance against the
> > > write side. As a bonus, it makes it officially a per network namespace
> > > synchronization business where a policy table resize on namespace A
> > > shouldn't block a policy lookup on namespace B.
> > > 
> > > Fixes: 77cc278f7b20 (xfrm: policy: Use sequence counters with associated lock)
> > > Cc: stable@vger.kernel.org
> > > Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> > > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Cc: Varad Gautam <varad.gautam@suse.com>
> > > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > 
> > Your patch has a conflicht with ("commit d7b0408934c7 xfrm: policy: Read
> > seqcount outside of rcu-read side in xfrm_policy_lookup_bytype")
> > from Varad. Can you please rebase onto the ipsec tree?
> 
> This patch is now applied to the ipsec tree (on top of the
> revert of commit d7b0408934c7).
> 
> Thanks everyone!

Thanks a lot!
