Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3558D3B143A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFWG5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:57:17 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:56114 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFWG5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:57:11 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 14C8A800056;
        Wed, 23 Jun 2021 08:54:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:54:52 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:54:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5AF37318047C; Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/6] xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype
Date:   Wed, 23 Jun 2021 08:54:45 +0200
Message-ID: <20210623065449.2143405-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210623065449.2143405-1-steffen.klassert@secunet.com>
References: <20210623065449.2143405-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

xfrm_policy_lookup_bytype loops on seqcount mutex xfrm_policy_hash_generation
within an RCU read side critical section. Although ill advised, this is fine if
the loop is bounded.

xfrm_policy_hash_generation wraps mutex hash_resize_mutex, which is used to
serialize writers (xfrm_hash_resize, xfrm_hash_rebuild). This is fine too.

On PREEMPT_RT=y, the read_seqcount_begin call within xfrm_policy_lookup_bytype
emits a mutex lock/unlock for hash_resize_mutex. Mutex locking is fine, since
RCU read side critical sections are allowed to sleep with PREEMPT_RT.

xfrm_hash_resize can, however, block on synchronize_rcu while holding
hash_resize_mutex.

This leads to the following situation on PREEMPT_RT, where the writer is
blocked on RCU grace period expiry, while the reader is blocked on a lock held
by the writer:

Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)

				rcu_read_lock();
mutex_lock(&hash_resize_mutex);
				read_seqcount_begin(&xfrm_policy_hash_generation);
				mutex_lock(&hash_resize_mutex); // block
xfrm_bydst_resize();
synchronize_rcu(); // block
		<RCU stalls in xfrm_policy_lookup_bytype>

Move the read_seqcount_begin call outside of the RCU read side critical section,
and do an rcu_read_unlock/retry if we got stale data within the critical section.

On non-PREEMPT_RT, this shortens the time spent within RCU read side critical
section in case the seqcount needs a retry, and avoids unbounded looping.

Fixes: 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated lock")
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org # v4.9
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 net/xfrm/xfrm_policy.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b74f28cabe24..8c56e3e59c3c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2092,12 +2092,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	if (unlikely(!daddr || !saddr))
 		return NULL;
 
-	rcu_read_lock();
  retry:
-	do {
-		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
-		chain = policy_hash_direct(net, daddr, saddr, family, dir);
-	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
+	sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
+	rcu_read_lock();
+
+	chain = policy_hash_direct(net, daddr, saddr, family, dir);
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
+		goto retry;
+	}
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2128,11 +2131,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	}
 
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
 		goto retry;
+	}
 
-	if (ret && !xfrm_pol_hold_rcu(ret))
+	if (ret && !xfrm_pol_hold_rcu(ret)) {
+		rcu_read_unlock();
 		goto retry;
+	}
 fail:
 	rcu_read_unlock();
 
-- 
2.25.1

