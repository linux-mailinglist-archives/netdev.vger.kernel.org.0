Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E143B02A3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFVLYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:24:22 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:60190 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:24:18 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 5323680004E;
        Tue, 22 Jun 2021 13:22:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 13:22:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 22 Jun
 2021 13:21:59 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 681FC318045C; Tue, 22 Jun 2021 13:21:59 +0200 (CEST)
Date:   Tue, 22 Jun 2021 13:21:59 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Varad Gautam <varad.gautam@suse.com>
CC:     <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xfrm: policy: Restructure RCU-read locking in
 xfrm_sk_policy_lookup
Message-ID: <20210622112159.GC40979@gauss3.secunet.de>
References: <20210618141101.18168-1-varad.gautam@suse.com>
 <20210621082949.GX40979@gauss3.secunet.de>
 <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
 <20210621110528.GZ40979@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210621110528.GZ40979@gauss3.secunet.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 01:05:28PM +0200, Steffen Klassert wrote:
> On Mon, Jun 21, 2021 at 11:11:18AM +0200, Varad Gautam wrote:
> > 
> > Right, I misread the call chain - security_xfrm_policy_lookup does not reach
> > xfrm_policy_lookup, making this patch unnecessary. The bug I have is:
> > 
> > T1, holding hash_resize_mutex and sleeping inside synchronize_rcu:
> > 
> > __schedule
> > schedule
> > schedule_timeout
> > wait_for_completion
> > __wait_rcu_gp
> > synchronize_rcu
> > xfrm_hash_resize
> > 
> > And T2 producing RCU-stalls since it blocked on the mutex:
> > 
> > __schedule
> > schedule
> > __rt_mutex_slowlock
> > rt_mutex_slowlock_locked
> > rt_mutex_slowlock
> > xfrm_policy_lookup_bytype.constprop.77
> 
> Ugh, why does xfrm_policy_lookup_bytype use a mutex? This is called
> in the receive path inside a sofirq.
> 
> The bug was introduced by: 
> 
> commit 77cc278f7b202e4f16f8596837219d02cb090b96
> Author: Ahmed S. Darwish <a.darwish@linutronix.de>
> Date:   Mon Jul 20 17:55:22 2020 +0200
> 
>     xfrm: policy: Use sequence counters with associated lock
> 
>     A sequence counter write side critical section must be protected by some
>     form of locking to serialize writers. If the serialization primitive is
>     not disabling preemption implicitly, preemption has to be explicitly
>     disabled before entering the sequence counter write side critical
>     section.
> 
>     A plain seqcount_t does not contain the information of which lock must
>     be held when entering a write side critical section.
> 
>     Use the new seqcount_spinlock_t and seqcount_mutex_t data types instead,
>     which allow to associate a lock with the sequence counter. This enables
>     lockdep to verify that the lock used for writer serialization is held
>     when the write side critical section is entered.
> 
>     If lockdep is disabled this lock association is compiled out and has
>     neither storage size nor runtime overhead.
> 
>     Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Link: https://lkml.kernel.org/r/20200720155530.1173732-17-a.darwish@linutronix.de
> 
> This uses a seqcount_mutex_t for xfrm_policy_hash_generation, that's
> wrong.

Varad, can you try to replace the seqcount_mutex_t for xfrm_policy_hash_generation
by a seqcount_spinlock_t? I'm not familiar with that seqcount changes,
but we should not end up with using a mutex in this codepath.

