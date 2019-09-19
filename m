Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F969BEDBB
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfIZIra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46772 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIZIr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so1404767pfg.13
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MfKiaD7BLDCj9sb393V4hNHiOobedPu8xnBx7OnK1E0=;
        b=B+tje5GpeSqlDQFsoh6doItPI/xBdQOdP6g8N12+POdRZGl6FtzJdnFb3TYJAkvrBi
         HCEqfRWVbfGBtUFyjJ+n/BHnA0l47mKzN9lrZNehhyAeKSwHZOMgJ9tzFcxidmTiy7Y5
         eu4rEaUg4e6cwBl611Ob+Gb7dEPTZ8Vho/7W4dvfblF1FmhTtaRUveDMIUaxv92Fr5lk
         o9QgRsfzUGU/1Pb80Q6GmDnNK3GaCI+0ZidXPkg5FhWDAkz4/pxNGUOVECD5AWftcBWp
         Fvry43QjWRITrzirIgFKJm1Il9I8S4fogIMOs3jR8GIl2jX3KqplqAGfvfG8n4CFo+Bw
         mahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MfKiaD7BLDCj9sb393V4hNHiOobedPu8xnBx7OnK1E0=;
        b=luldWdHtCFkfTsBmYYH4afIUR7xvJCqVg49AP/uE9VEYy0ujc4oDqc4UK/YOcc/VjV
         qiZfaRF6PIo63zIUwVOWA9MJnzcxnfJ3nkO/lGH6w60S5KUqK+TDpycAA8dE9O46tkoC
         U4KFcurpavbVNOUBhp8T9wfNPaIwLoiQqjhjxwFs6umdktZwW4+eXv1O9AoXF4Ynt6SX
         0iBfacvOlHfMZmUlmae87Wt1FHrXENPLQtmlpjB6SCBm4HO3ORtbDHcntz0yUwWGIgLl
         6GQz2Brc4ixUygU5kUZY62/Y+Re2e9XFQxq8yP2PwyeY07ooozbM3upjLZo/EeTFMFPY
         FCpQ==
X-Gm-Message-State: APjAAAXcEm15AMFb2+JgvQrEeOyGVYcX0daA1maub+8Gssj2Owme3puw
        Sj5kAwsghW9yGRR7+4fxtrr2s2g04Mo=
X-Google-Smtp-Source: APXvYqy5CwqM5C5FnpTvGLWuRKDMY23conjUj6coQT/8cudvk8+JT+/F9sNI1gICgX/Xs31VZDjfGg==
X-Received: by 2002:a63:4142:: with SMTP id o63mr2351863pga.426.1569487648479;
        Thu, 26 Sep 2019 01:47:28 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:28 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 4/7] net: openvswitch: optimize flow mask cache hash collision
Date:   Fri, 20 Sep 2019 00:54:50 +0800
Message-Id: <1568912093-68535-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
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
---
 net/openvswitch/flow_table.c | 95 ++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 9c72aab..e59fac5 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -516,6 +516,9 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	return NULL;
 }
 
+/* Flow lookup does full lookup on flow table. It starts with
+ * mask from index passed in *index.
+ */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
 				   struct mask_array *ma,
@@ -524,18 +527,31 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *index)
 {
 	struct sw_flow *flow;
+	struct sw_flow_mask *mask;
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
 
@@ -554,58 +570,54 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
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
@@ -615,9 +627,8 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
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

