Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DD51FBE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfFYAMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:51 -0400
Received: from mail.us.es ([193.147.175.20]:38022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbfFYAMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37D47C04AF
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A362DA709
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 158C3DA70F; Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00A83DA70D;
        Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CB4234265A2F;
        Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/26] netfilter: conntrack: small conntrack lookup optimization
Date:   Tue, 25 Jun 2019 02:12:17 +0200
Message-Id: <20190625001233.22057-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

____nf_conntrack_find() performs checks on the conntrack objects in
this order:

1. if (nf_ct_is_expired(ct))

This fetches ct->timeout, in third cache line.

The hnnode that is used to store the list pointers resides in the first
(origin) or second (reply tuple) cache lines.

This test rarely passes, but its necessary to reap obsolete entries.

2. if (nf_ct_is_dying(ct))

This fetches ct->status, also in third cache line.

The test is useless, and can be removed:
  Consider:
     cpu0                                           cpu1
    ct = ____nf_conntrack_find()
    atomic_inc_not_zero(ct) -> ok
    nf_ct_key_equal -> ok
    is_dying -> DYING bit not set, ok
                                                    set_bit(ct, DYING);
						    ... unhash ... etc.
    return ct
    -> returning a ct with dying bit set, despite
    having a test for it.

This (unlikely) case is fine - refcount prevents ct from getting free'd.

3. if (nf_ct_key_equal(h, tuple, zone, net))

nf_ct_key_equal checks in following order:

1. Tuple equal (first or second cacheline)
2. Zone equal (third cacheline)
3. confirmed bit set (->status, third cacheline)
4. net namespace match (third cacheline).

Swapping "timeout" and "cpu" places timeout in the first cacheline.
This has two advantages:

1. For a conntrack that won't even match the original tuple,
   we will now only fetch the first and maybe the second cacheline
   instead of always accessing the 3rd one as well.

2.  in case of TCP ct->timeout changes frequently because we
    reduce/increase it when there are packets outstanding in the network.

The first cacheline contains both the reference count and the ct spinlock,
i.e. moving timeout there avoids writes to 3rd cacheline.

The restart sequence in __nf_conntrack_find() is removed, if we found a
candidate, but then fail to increment the refcount or discover the tuple
has changed (object recycling), just pretend we did not find an entry.

A second lookup won't find anything until another CPU adds a new conntrack
with identical tuple into the hash table, which is very unlikely.

We have the confirmation-time checks (when we hold hash lock) that deal
with identical entries and even perform clash resolution in some cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  7 +++----
 net/netfilter/nf_conntrack_core.c    | 25 +++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5cb19ce454d1..c86657d99630 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -70,7 +70,8 @@ struct nf_conn {
 	struct nf_conntrack ct_general;
 
 	spinlock_t	lock;
-	u16		cpu;
+	/* jiffies32 when this ct is considered dead */
+	u32 timeout;
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	struct nf_conntrack_zone zone;
@@ -82,9 +83,7 @@ struct nf_conn {
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
-	/* jiffies32 when this ct is considered dead */
-	u32 timeout;
-
+	u16		cpu;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2a714527cde1..2855a2e39fc4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -752,9 +752,6 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 			continue;
 		}
 
-		if (nf_ct_is_dying(ct))
-			continue;
-
 		if (nf_ct_key_equal(h, tuple, zone, net))
 			return h;
 	}
@@ -780,20 +777,24 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conn *ct;
 
 	rcu_read_lock();
-begin:
+
 	h = ____nf_conntrack_find(net, zone, tuple, hash);
 	if (h) {
+		/* We have a candidate that matches the tuple we're interested
+		 * in, try to obtain a reference and re-check tuple
+		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (unlikely(nf_ct_is_dying(ct) ||
-			     !atomic_inc_not_zero(&ct->ct_general.use)))
-			h = NULL;
-		else {
-			if (unlikely(!nf_ct_key_equal(h, tuple, zone, net))) {
-				nf_ct_put(ct);
-				goto begin;
-			}
+		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
+				goto found;
+
+			/* TYPESAFE_BY_RCU recycled the candidate */
+			nf_ct_put(ct);
 		}
+
+		h = NULL;
 	}
+found:
 	rcu_read_unlock();
 
 	return h;
-- 
2.11.0

