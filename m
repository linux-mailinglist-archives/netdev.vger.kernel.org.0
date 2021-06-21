Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C2E3AE7DF
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhFULHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 07:07:48 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:58292 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhFULHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 07:07:45 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id D28D780004E;
        Mon, 21 Jun 2021 13:05:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 13:05:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 21 Jun
 2021 13:05:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id ED7C431803E8; Mon, 21 Jun 2021 13:05:28 +0200 (CEST)
Date:   Mon, 21 Jun 2021 13:05:28 +0200
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
Message-ID: <20210621110528.GZ40979@gauss3.secunet.de>
References: <20210618141101.18168-1-varad.gautam@suse.com>
 <20210621082949.GX40979@gauss3.secunet.de>
 <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 11:11:18AM +0200, Varad Gautam wrote:
> On 6/21/21 10:29 AM, Steffen Klassert wrote:
> > On Fri, Jun 18, 2021 at 04:11:01PM +0200, Varad Gautam wrote:
> >> Commit "xfrm: policy: Read seqcount outside of rcu-read side in
> >> xfrm_policy_lookup_bytype" [Linked] resolved a locking bug in
> >> xfrm_policy_lookup_bytype that causes an RCU reader-writer deadlock on
> >> the mutex wrapped by xfrm_policy_hash_generation on PREEMPT_RT since
> >> 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated
> >> lock").
> >>
> >> However, xfrm_sk_policy_lookup can still reach xfrm_policy_lookup_bytype
> >> while holding rcu_read_lock(), as:
> >> xfrm_sk_policy_lookup()
> >>   rcu_read_lock()
> >>   security_xfrm_policy_lookup()
> >>     xfrm_policy_lookup()
> > 
> > Hm, I don't see that call chain. security_xfrm_policy_lookup() calls
> > a hook with the name xfrm_policy_lookup. The only LSM that has
> > registered a function to that hook is selinux. It registers
> > selinux_xfrm_policy_lookup() and I don't see how we can call
> > xfrm_policy_lookup() from there.
> > 
> > Did you actually trigger that bug?
> > 
> 
> Right, I misread the call chain - security_xfrm_policy_lookup does not reach
> xfrm_policy_lookup, making this patch unnecessary. The bug I have is:
> 
> T1, holding hash_resize_mutex and sleeping inside synchronize_rcu:
> 
> __schedule
> schedule
> schedule_timeout
> wait_for_completion
> __wait_rcu_gp
> synchronize_rcu
> xfrm_hash_resize
> 
> And T2 producing RCU-stalls since it blocked on the mutex:
> 
> __schedule
> schedule
> __rt_mutex_slowlock
> rt_mutex_slowlock_locked
> rt_mutex_slowlock
> xfrm_policy_lookup_bytype.constprop.77

Ugh, why does xfrm_policy_lookup_bytype use a mutex? This is called
in the receive path inside a sofirq.

The bug was introduced by: 

commit 77cc278f7b202e4f16f8596837219d02cb090b96
Author: Ahmed S. Darwish <a.darwish@linutronix.de>
Date:   Mon Jul 20 17:55:22 2020 +0200

    xfrm: policy: Use sequence counters with associated lock

    A sequence counter write side critical section must be protected by some
    form of locking to serialize writers. If the serialization primitive is
    not disabling preemption implicitly, preemption has to be explicitly
    disabled before entering the sequence counter write side critical
    section.

    A plain seqcount_t does not contain the information of which lock must
    be held when entering a write side critical section.

    Use the new seqcount_spinlock_t and seqcount_mutex_t data types instead,
    which allow to associate a lock with the sequence counter. This enables
    lockdep to verify that the lock used for writer serialization is held
    when the write side critical section is entered.

    If lockdep is disabled this lock association is compiled out and has
    neither storage size nor runtime overhead.

    Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: https://lkml.kernel.org/r/20200720155530.1173732-17-a.darwish@linutronix.de

This uses a seqcount_mutex_t for xfrm_policy_hash_generation, that's
wrong.

