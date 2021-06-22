Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF593B049E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFVMgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:36:02 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:54906 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhFVMgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 08:36:02 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 823C5800057;
        Tue, 22 Jun 2021 14:33:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 14:33:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 22 Jun
 2021 14:33:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D1B3A318045C; Tue, 22 Jun 2021 14:33:43 +0200 (CEST)
Date:   Tue, 22 Jun 2021 14:33:43 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Frederic Weisbecker <frederic@kernel.org>
CC:     Varad Gautam <varad.gautam@suse.com>,
        <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xfrm: policy: Restructure RCU-read locking in
 xfrm_sk_policy_lookup
Message-ID: <20210622123343.GD40979@gauss3.secunet.de>
References: <20210618141101.18168-1-varad.gautam@suse.com>
 <20210621082949.GX40979@gauss3.secunet.de>
 <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
 <20210621110528.GZ40979@gauss3.secunet.de>
 <20210622112159.GC40979@gauss3.secunet.de>
 <20210622115124.GA109262@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210622115124.GA109262@lothringen>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 01:51:24PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 22, 2021 at 01:21:59PM +0200, Steffen Klassert wrote:
> > On Mon, Jun 21, 2021 at 01:05:28PM +0200, Steffen Klassert wrote:
> > > On Mon, Jun 21, 2021 at 11:11:18AM +0200, Varad Gautam wrote:
> > > > 
> > > > Right, I misread the call chain - security_xfrm_policy_lookup does not reach
> > > > xfrm_policy_lookup, making this patch unnecessary. The bug I have is:
> > > > 
> > > > T1, holding hash_resize_mutex and sleeping inside synchronize_rcu:
> > > > 
> > > > __schedule
> > > > schedule
> > > > schedule_timeout
> > > > wait_for_completion
> > > > __wait_rcu_gp
> > > > synchronize_rcu
> > > > xfrm_hash_resize
> > > > 
> > > > And T2 producing RCU-stalls since it blocked on the mutex:
> > > > 
> > > > __schedule
> > > > schedule
> > > > __rt_mutex_slowlock
> > > > rt_mutex_slowlock_locked
> > > > rt_mutex_slowlock
> > > > xfrm_policy_lookup_bytype.constprop.77
> > > 
> > > Ugh, why does xfrm_policy_lookup_bytype use a mutex? This is called
> > > in the receive path inside a sofirq.
> > > 
> > > The bug was introduced by: 
> > > 
> > > commit 77cc278f7b202e4f16f8596837219d02cb090b96
> > > Author: Ahmed S. Darwish <a.darwish@linutronix.de>
> > > Date:   Mon Jul 20 17:55:22 2020 +0200
> > > 
> > >     xfrm: policy: Use sequence counters with associated lock
> > > 
> > >     A sequence counter write side critical section must be protected by some
> > >     form of locking to serialize writers. If the serialization primitive is
> > >     not disabling preemption implicitly, preemption has to be explicitly
> > >     disabled before entering the sequence counter write side critical
> > >     section.
> > > 
> > >     A plain seqcount_t does not contain the information of which lock must
> > >     be held when entering a write side critical section.
> > > 
> > >     Use the new seqcount_spinlock_t and seqcount_mutex_t data types instead,
> > >     which allow to associate a lock with the sequence counter. This enables
> > >     lockdep to verify that the lock used for writer serialization is held
> > >     when the write side critical section is entered.
> > > 
> > >     If lockdep is disabled this lock association is compiled out and has
> > >     neither storage size nor runtime overhead.
> > > 
> > >     Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> > >     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > >     Link: https://lkml.kernel.org/r/20200720155530.1173732-17-a.darwish@linutronix.de
> > > 
> > > This uses a seqcount_mutex_t for xfrm_policy_hash_generation, that's
> > > wrong.
> > 
> > Varad, can you try to replace the seqcount_mutex_t for xfrm_policy_hash_generation
> > by a seqcount_spinlock_t? I'm not familiar with that seqcount changes,
> > but we should not end up with using a mutex in this codepath.
> 
> Something like this? (beware, untested, also I don't know if the read side
> should then disable bh, doesn't look necessary for PREEMPT_RT, but I may be
> missing something...)

Looking a bit deeper into this it seems that the problem is that
xfrm_policy_hash_generation and hash_resize_mutex do not protect
the same thing.

hash_resize_mutex protects user configuration against a worker thread
that rebalances the hash buckets. xfrm_policy_hash_generation protects
user configuration against the data path that runs in softirq.

Finally the following line from xfrm_init() relates these two:

seqcount_mutex_init(&xfrm_policy_hash_generation, &hash_resize_mutex);

That looks a bit odd. This line was also introduced with the above
mentioned patch.
