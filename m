Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2221C3B81F6
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbhF3MXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:23:37 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:40758 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbhF3MXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:23:36 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2F24A800056;
        Wed, 30 Jun 2021 14:21:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 14:21:06 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 14:21:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 808F8318040F; Wed, 30 Jun 2021 14:21:05 +0200 (CEST)
Date:   Wed, 30 Jun 2021 14:21:05 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Varad Gautam <varad.gautam@suse.com>
CC:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        <stable@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Message-ID: <20210630122105.GY40979@gauss3.secunet.de>
References: <20210628133428.5660-1-frederic@kernel.org>
 <20210630065753.GU40979@gauss3.secunet.de>
 <ff82a4ad-179e-6a81-eacc-addc8ed12b0f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ff82a4ad-179e-6a81-eacc-addc8ed12b0f@suse.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 02:11:24PM +0200, Varad Gautam wrote:
> On 6/30/21 8:57 AM, Steffen Klassert wrote:
> > On Mon, Jun 28, 2021 at 03:34:28PM +0200, Frederic Weisbecker wrote:
> >> xfrm_bydst_resize() calls synchronize_rcu() while holding
> >> hash_resize_mutex. But then on PREEMPT_RT configurations,
> >> xfrm_policy_lookup_bytype() may acquire that mutex while running in an
> >> RCU read side critical section. This results in a deadlock.
> >>
> >> In fact the scope of hash_resize_mutex is way beyond the purpose of
> >> xfrm_policy_lookup_bytype() to just fetch a coherent and stable policy
> >> for a given destination/direction, along with other details.
> >>
> >> The lower level net->xfrm.xfrm_policy_lock, which among other things
> >> protects per destination/direction references to policy entries, is
> >> enough to serialize and benefit from priority inheritance against the
> >> write side. As a bonus, it makes it officially a per network namespace
> >> synchronization business where a policy table resize on namespace A
> >> shouldn't block a policy lookup on namespace B.
> >>
> >> Fixes: 77cc278f7b20 (xfrm: policy: Use sequence counters with associated lock)
> >> Cc: stable@vger.kernel.org
> >> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> >> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> >> Cc: Varad Gautam <varad.gautam@suse.com>
> >> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Cc: David S. Miller <davem@davemloft.net>
> >> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > 
> > Your patch has a conflicht with ("commit d7b0408934c7 xfrm: policy: Read
> > seqcount outside of rcu-read side in xfrm_policy_lookup_bytype")
> > from Varad. Can you please rebase onto the ipsec tree?
> > 
> > Btw. Varad, your above mentioned patch tried to fix the same issue.
> > Do we still need it, or is it obsolete with the fix from Frederic?
> > 
> 
> The patch "xfrm: policy: Read seqcount outside of rcu-read side in
> xfrm_policy_lookup_bytype" shouldn't be needed after Frederic's fix since
> the offending mutex is now gone. It can be dropped.

Ok, so I'll revert your patch and apply Frederic's patch on
top of that revert.

Thanks a lot everyone!
