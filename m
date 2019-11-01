Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1BFEC49C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKAOYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36140 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id v19so7195722pfm.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ly8ZGZldGeMEyOyDTGYNxgf6VANdx6un83/HEOyfeC0=;
        b=lRHG3p2r0kRBY8xghWYmD3bEwoa+ehTWIbvzfwSmuJWexQEg2Z3BBtc5mmJOS+ptZ6
         NDmmPKZQ0duJ7/nxWmt5q9l412RL4mxCs/pgQLXhyaTJzFWgEI+Z61P/qZ/EaYg376G5
         rpfmWNAX+Tme9NMNQC65tf43majk+bRY1dFXsv6F8RMyc8/Cpvq9u9EK5rf3amOFFLHn
         WOT8A6NjKjJqa6GJG5WyHl53Ti8H04kUp2n7ZKh+PL1wLjgUrMAgR4d8TTTnELch1cnD
         uKJ5Qe+ckrNVTWoMv6UO3m6vYn6ZtNTe8HOf5S30rHpWqe+O3W/xOeBKw5vtNFbnPzoj
         zPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ly8ZGZldGeMEyOyDTGYNxgf6VANdx6un83/HEOyfeC0=;
        b=Lp1SFgf2APoaRwZpLYoQUZmpNaDR+wJHWObLZqw87jOI0n3IPN2XuIrU4qQV6Jv05Z
         fSs2HOGueIk0o5Qpt23JqS8no37KdMIchmt9Mkvw1mEKyn2fl5HNnr0jf+r0NBAsCDpf
         lv2i0TfHcetGUYKAau51TY/zc96JwsjMnURUqbwLZdrfABB1ptJaHTsXaBditvwy/Nka
         VruYUGe1N24Xh3hvgYj87xq2aSZypIxHqttxtLSkV9FjE0PaN2bBAshGvi2YqFwNpojP
         Ps/BRmavBNOePzCMK0FAUc+n583LP9XKOSrp0e/A2iJPG9xTppAeFoL/xHJEew3sjJtr
         3xqw==
X-Gm-Message-State: APjAAAX/kCUkHJcKNvqJIxAi/gIxn/4skWxvzqpxBWU5quInqaJQOc0L
        Rt3U+ykbJvTM/sLqTEbw5jg=
X-Google-Smtp-Source: APXvYqzjhMqjN6xslx/4IMEEMMuZqJhG83v0iWTh2oe6RUeOP2kDcUhsxPWL85jD1IR5At6znuhJRQ==
X-Received: by 2002:a63:1e59:: with SMTP id p25mr13415474pgm.361.1572618259700;
        Fri, 01 Nov 2019 07:24:19 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:19 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 04/10] net: openvswitch: optimize flow mask cache hash collision
Date:   Fri,  1 Nov 2019 22:23:48 +0800
Message-Id: <1572618234-6904-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Port the codes to linux upstream and with little changes.

Pravin B Shelar, says:
| In case hash collision on mask cache, OVS does extra flow
| lookup. Following patch avoid it.

Link: https://github.com/openvswitch/ovs/commit/0e6efbe2712da03522532dc5e84806a96f6a0dd1
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 95 ++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0c0fcd6..c7ba435 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -508,6 +508,9 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	return NULL;
 }
 
+/* Flow lookup does full lookup on flow table. It starts with
+ * mask from index passed in *index.
+ */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
 				   struct mask_array *ma,
@@ -515,19 +518,32 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *n_mask_hit,
 				   u32 *index)
 {
+	struct sw_flow_mask *mask;
 	struct sw_flow *flow;
 	int i;
 
-	for (i = 0; i < ma->max; i++)  {
-		struct sw_flow_mask *mask;
-
-		mask = rcu_dereference_ovsl(ma->masks[i]);
+	if (*index < ma->max) {
+		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-			if (flow) { /* Found */
-				*index = i;
+			if (flow)
 				return flow;
-			}
+		}
+	}
+
+	for (i = 0; i < ma->max; i++)  {
+
+		if (i == *index)
+			continue;
+
+		mask = rcu_dereference_ovsl(ma->masks[i]);
+		if (!mask)
+			continue;
+
+		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
+		if (flow) { /* Found */
+			*index = i;
+			return flow;
 		}
 	}
 
@@ -546,58 +562,54 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 					  u32 skb_hash,
 					  u32 *n_mask_hit)
 {
-	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
-	struct mask_cache_entry  *entries, *ce, *del;
+	struct mask_array *ma = rcu_dereference(tbl->mask_array);
+	struct table_instance *ti = rcu_dereference(tbl->ti);
+	struct mask_cache_entry *entries, *ce;
 	struct sw_flow *flow;
-	u32 hash = skb_hash;
+	u32 hash;
 	int seg;
 
 	*n_mask_hit = 0;
 	if (unlikely(!skb_hash)) {
-		u32 __always_unused mask_index;
+		u32 mask_index = 0;
 
 		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
 	}
 
-	del = NULL;
+	/* Pre and post recirulation flows usually have the same skb_hash
+	 * value. To avoid hash collisions, rehash the 'skb_hash' with
+	 * 'recirc_id'.  */
+	if (key->recirc_id)
+		skb_hash = jhash_1word(skb_hash, key->recirc_id);
+
+	ce = NULL;
+	hash = skb_hash;
 	entries = this_cpu_ptr(tbl->mask_cache);
 
+	/* Find the cache entry 'ce' to operate on. */
 	for (seg = 0; seg < MC_HASH_SEGS; seg++) {
-		int index;
-
-		index = hash & (MC_HASH_ENTRIES - 1);
-		ce = &entries[index];
-
-		if (ce->skb_hash == skb_hash) {
-			struct sw_flow_mask *mask;
-			struct sw_flow *flow;
-
-			mask = rcu_dereference_ovsl(ma->masks[ce->mask_index]);
-			if (mask) {
-				flow = masked_flow_lookup(ti, key, mask,
-							  n_mask_hit);
-				if (flow)  /* Found */
-					return flow;
-			}
-
-			del = ce;
-			break;
+		int index = hash & (MC_HASH_ENTRIES - 1);
+		struct mask_cache_entry *e;
+
+		e = &entries[index];
+		if (e->skb_hash == skb_hash) {
+			flow = flow_lookup(tbl, ti, ma, key, n_mask_hit,
+					   &e->mask_index);
+			if (!flow)
+				e->skb_hash = 0;
+			return flow;
 		}
 
-		if (!del || (del->skb_hash && !ce->skb_hash) ||
-		    (rcu_dereference_ovsl(ma->masks[del->mask_index]) &&
-		     !rcu_dereference_ovsl(ma->masks[ce->mask_index]))) {
-			del = ce;
-		}
+		if (!ce || e->skb_hash < ce->skb_hash)
+			ce = e;  /* A better replacement cache candidate. */
 
 		hash >>= MC_HASH_SHIFT;
 	}
 
-	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &del->mask_index);
-
+	/* Cache miss, do full lookup. */
+	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &ce->mask_index);
 	if (flow)
-		del->skb_hash = skb_hash;
+		ce->skb_hash = skb_hash;
 
 	return flow;
 }
@@ -607,9 +619,8 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 {
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-
 	u32 __always_unused n_mask_hit;
-	u32 __always_unused index;
+	u32 index = 0;
 
 	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
 }
-- 
1.8.3.1

