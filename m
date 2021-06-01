Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E92397C26
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhFAWId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbhFAWIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 26018641CD;
        Wed,  2 Jun 2021 00:05:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/16] netfilter: x_tables: improve limit_mt scalability
Date:   Wed,  2 Jun 2021 00:06:19 +0200
Message-Id: <20210601220629.18307-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

We've seen this spin_lock show up high in profiles. Let's introduce a
lockless version. I've tested this using pktgen_sample01_simple.sh.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_limit.c | 46 +++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 24d4afb9988d..8b4fd27857f2 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -8,16 +8,14 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_limit.h>
 
 struct xt_limit_priv {
-	spinlock_t lock;
 	unsigned long prev;
-	uint32_t credit;
+	u32 credit;
 };
 
 MODULE_LICENSE("GPL");
@@ -66,22 +64,31 @@ limit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateinfo *r = par->matchinfo;
 	struct xt_limit_priv *priv = r->master;
-	unsigned long now = jiffies;
-
-	spin_lock_bh(&priv->lock);
-	priv->credit += (now - xchg(&priv->prev, now)) * CREDITS_PER_JIFFY;
-	if (priv->credit > r->credit_cap)
-		priv->credit = r->credit_cap;
-
-	if (priv->credit >= r->cost) {
-		/* We're not limited. */
-		priv->credit -= r->cost;
-		spin_unlock_bh(&priv->lock);
-		return true;
-	}
-
-	spin_unlock_bh(&priv->lock);
-	return false;
+	unsigned long now;
+	u32 old_credit, new_credit, credit_increase = 0;
+	bool ret;
+
+	/* fastpath if there is nothing to update */
+	if ((READ_ONCE(priv->credit) < r->cost) && (READ_ONCE(priv->prev) == jiffies))
+		return false;
+
+	do {
+		now = jiffies;
+		credit_increase += (now - xchg(&priv->prev, now)) * CREDITS_PER_JIFFY;
+		old_credit = READ_ONCE(priv->credit);
+		new_credit = old_credit;
+		new_credit += credit_increase;
+		if (new_credit > r->credit_cap)
+			new_credit = r->credit_cap;
+		if (new_credit >= r->cost) {
+			ret = true;
+			new_credit -= r->cost;
+		} else {
+			ret = false;
+		}
+	} while (cmpxchg(&priv->credit, old_credit, new_credit) != old_credit);
+
+	return ret;
 }
 
 /* Precision saver. */
@@ -122,7 +129,6 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-	spin_lock_init(&priv->lock);
 
 	return 0;
 }
-- 
2.30.2

