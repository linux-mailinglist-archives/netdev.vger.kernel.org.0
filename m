Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC9CF8F9
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfJHL44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:56:56 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35400 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfJHL4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:56:55 -0400
Received: by mail-pf1-f169.google.com with SMTP id 205so10659405pfw.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Wr0xET2tvmbw9xhJaMx8nDwFsZfDudrDY3Pml6+4Ic=;
        b=fH+0Hz29EqdmiUDDaDWg6wksW+v6xKH08lpAJ68dD5piigkECWyBnsfwAA7uMKZqpv
         OP0Y8j+Kg+xBvOH2Gi2czryvb8GhLUMf5kCpDvJ7Eokoakx6JMC9dHTUsON/x/a783WU
         6+hnWrqrvF9PQXlaiK1zil8AdjrUNEJ9SXxAHWd6gt9TBHkv+FHL5IGCYszsNwZ+NPx4
         p6gn+BpS8gx7UVaexpMMfvu3KvEQql4t9W/zTWxliXjAloH8hCTkLEVPjnzDvhtk9BiA
         pkM5EzYCnNzFwrjehVpwwZyAp5pcF79fVVVUwvLi+cVCuzP6g0wgvdkGY3ypU2fRy0s5
         b1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Wr0xET2tvmbw9xhJaMx8nDwFsZfDudrDY3Pml6+4Ic=;
        b=g8cIzsWGbgtEYOhjjDyKyCg/6qT+FeEstX+0giPIG80L2ipB2kOtSh/P7gW7pENcEm
         kD7Re2Cc6ylLjMFg2AiMTG5Wc1NhiMq5g+U0TOabWczHeH70BTk30VmX3O/tvEnJcAM/
         46Llg2tVLCRiUfDMwNb3cQYpKjouV3qPQMOcLTJcze8g0Z6PoKTv71sgxgqnQopqCHzT
         UhODQm9kTSNDV1WyUGvFb3brvhFaihnu117+poF4132QtoXuY6xWywcrjK+c77nCVmvh
         mvvRb0TN9HhJkJ9q3qzGmBPdrnA5nhOPIvXzA6x51Wu9ylNp4tnyj83HGFjs8ennai8C
         EfKA==
X-Gm-Message-State: APjAAAWRQEU4XOYnHkuH36iML6jV7mdIuF2z/SuAomv1GrA1s9OOcLxz
        LmJO11CU+EagyzkhRSU7LZ8=
X-Google-Smtp-Source: APXvYqyRp3ilBTKNGH2iUL8+PeCXxXqQn19Lfh4OakT8iJjBY9f3gZOVAR3rAb/qFFrTNqVEX826Tg==
X-Received: by 2002:a63:231c:: with SMTP id j28mr13664446pgj.443.1570535814332;
        Tue, 08 Oct 2019 04:56:54 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.56.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:56:53 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 01/10] net: openvswitch: add flow-mask cache for performance
Date:   Tue,  8 Oct 2019 09:00:29 +0800
Message-Id: <1570496438-15460-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The idea of this optimization comes from a patch which
is committed in 2014, openvswitch community. The author
is Pravin B Shelar. In order to get high performance, I
implement it again. Later patches will use it.

Pravin B Shelar, says:
| On every packet OVS needs to lookup flow-table with every
| mask until it finds a match. The packet flow-key is first
| masked with mask in the list and then the masked key is
| looked up in flow-table. Therefore number of masks can
| affect packet processing performance.

Link: https://github.com/openvswitch/ovs/commit/5604935e4e1cbc16611d2d97f50b717aa31e8ec5
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c   |   3 +-
 net/openvswitch/flow_table.c | 109 +++++++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h |  11 ++++-
 3 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index f30e406..9fea7e1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -227,7 +227,8 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	stats = this_cpu_ptr(dp->stats_percpu);
 
 	/* Look up flow. */
-	flow = ovs_flow_tbl_lookup_stats(&dp->table, key, &n_mask_hit);
+	flow = ovs_flow_tbl_lookup_stats(&dp->table, key, skb_get_hash(skb),
+					 &n_mask_hit);
 	if (unlikely(!flow)) {
 		struct dp_upcall_info upcall;
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index cf3582c..3d515c0 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -36,6 +36,10 @@
 #define TBL_MIN_BUCKETS		1024
 #define REHASH_INTERVAL		(10 * 60 * HZ)
 
+#define MC_HASH_SHIFT		8
+#define MC_HASH_ENTRIES		(1u << MC_HASH_SHIFT)
+#define MC_HASH_SEGS		((sizeof(uint32_t) * 8) / MC_HASH_SHIFT)
+
 static struct kmem_cache *flow_cache;
 struct kmem_cache *flow_stats_cache __read_mostly;
 
@@ -168,10 +172,15 @@ int ovs_flow_tbl_init(struct flow_table *table)
 {
 	struct table_instance *ti, *ufid_ti;
 
-	ti = table_instance_alloc(TBL_MIN_BUCKETS);
+	table->mask_cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
+					   MC_HASH_ENTRIES,
+					   __alignof__(struct mask_cache_entry));
+	if (!table->mask_cache)
+		return -ENOMEM;
 
+	ti = table_instance_alloc(TBL_MIN_BUCKETS);
 	if (!ti)
-		return -ENOMEM;
+		goto free_mask_cache;
 
 	ufid_ti = table_instance_alloc(TBL_MIN_BUCKETS);
 	if (!ufid_ti)
@@ -187,6 +196,8 @@ int ovs_flow_tbl_init(struct flow_table *table)
 
 free_ti:
 	__table_instance_destroy(ti);
+free_mask_cache:
+	free_percpu(table->mask_cache);
 	return -ENOMEM;
 }
 
@@ -243,6 +254,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ti = rcu_dereference_raw(table->ti);
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
+	free_percpu(table->mask_cache);
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
@@ -425,7 +437,8 @@ static bool ovs_flow_cmp_unmasked_key(const struct sw_flow *flow,
 
 static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 					  const struct sw_flow_key *unmasked,
-					  const struct sw_flow_mask *mask)
+					  const struct sw_flow_mask *mask,
+					  u32 *n_mask_hit)
 {
 	struct sw_flow *flow;
 	struct hlist_head *head;
@@ -435,6 +448,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	ovs_flow_mask_key(&masked_key, unmasked, false, mask);
 	hash = flow_hash(&masked_key, &mask->range);
 	head = find_bucket(ti, hash);
+	(*n_mask_hit)++;
+
 	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver]) {
 		if (flow->mask == mask && flow->flow_table.hash == hash &&
 		    flow_cmp_masked_key(flow, &masked_key, &mask->range))
@@ -443,30 +458,97 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	return NULL;
 }
 
-struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
-				    const struct sw_flow_key *key,
-				    u32 *n_mask_hit)
+static struct sw_flow *flow_lookup(struct flow_table *tbl,
+				   struct table_instance *ti,
+				   const struct sw_flow_key *key,
+				   u32 *n_mask_hit)
 {
-	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct sw_flow_mask *mask;
 	struct sw_flow *flow;
 
-	*n_mask_hit = 0;
 	list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
-		(*n_mask_hit)++;
-		flow = masked_flow_lookup(ti, key, mask);
+		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow)  /* Found */
 			return flow;
 	}
 	return NULL;
 }
 
+/*
+ * mask_cache maps flow to probable mask. This cache is not tightly
+ * coupled cache, It means updates to  mask list can result in inconsistent
+ * cache entry in mask cache.
+ * This is per cpu cache and is divided in MC_HASH_SEGS segments.
+ * In case of a hash collision the entry is hashed in next segment.
+ * */
+struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
+					  const struct sw_flow_key *key,
+					  u32 skb_hash,
+					  u32 *n_mask_hit)
+{
+	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
+	struct mask_cache_entry  *entries, *ce, *del;
+	struct sw_flow *flow;
+	u32 hash = skb_hash;
+	int seg;
+
+	*n_mask_hit = 0;
+	if (unlikely(!skb_hash))
+		return flow_lookup(tbl, ti, key, n_mask_hit);
+
+	del = NULL;
+	entries = this_cpu_ptr(tbl->mask_cache);
+
+	for (seg = 0; seg < MC_HASH_SEGS; seg++) {
+		int index;
+
+		index = hash & (MC_HASH_ENTRIES - 1);
+		ce = &entries[index];
+
+		if (ce->skb_hash == skb_hash) {
+			struct sw_flow_mask *mask;
+			int i;
+
+			i = 0;
+			list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
+				if (ce->mask_index == i++) {
+					flow = masked_flow_lookup(ti, key, mask,
+								  n_mask_hit);
+					if (flow)  /* Found */
+						return flow;
+
+					break;
+				}
+			}
+
+			del = ce;
+			break;
+		}
+
+		if (!del || (del->skb_hash && !ce->skb_hash)) {
+			del = ce;
+		}
+
+		hash >>= MC_HASH_SHIFT;
+	}
+
+	flow = flow_lookup(tbl, ti, key, n_mask_hit);
+
+	if (flow) {
+		del->skb_hash = skb_hash;
+		del->mask_index = (*n_mask_hit - 1);
+	}
+
+	return flow;
+}
+
 struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 				    const struct sw_flow_key *key)
 {
+	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	u32 __always_unused n_mask_hit;
 
-	return ovs_flow_tbl_lookup_stats(tbl, key, &n_mask_hit);
+	return flow_lookup(tbl, ti, key, &n_mask_hit);
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
@@ -475,10 +557,11 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct sw_flow_mask *mask;
 	struct sw_flow *flow;
+	u32 __always_unused n_mask_hit;
 
 	/* Always called under ovs-mutex. */
 	list_for_each_entry(mask, &tbl->mask_list, list) {
-		flow = masked_flow_lookup(ti, match->key, mask);
+		flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
 		if (flow && ovs_identifier_is_key(&flow->id) &&
 		    ovs_flow_cmp_unmasked_key(flow, match))
 			return flow;
@@ -631,7 +714,7 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 			return -ENOMEM;
 		mask->key = new->key;
 		mask->range = new->range;
-		list_add_rcu(&mask->list, &tbl->mask_list);
+		list_add_tail_rcu(&mask->list, &tbl->mask_list);
 	} else {
 		BUG_ON(!mask->ref_count);
 		mask->ref_count++;
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index bc52045..04b6b1c 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -22,6 +22,11 @@
 
 #include "flow.h"
 
+struct mask_cache_entry {
+	u32 skb_hash;
+	u32 mask_index;
+};
+
 struct table_instance {
 	struct hlist_head *buckets;
 	unsigned int n_buckets;
@@ -34,6 +39,7 @@ struct table_instance {
 struct flow_table {
 	struct table_instance __rcu *ti;
 	struct table_instance __rcu *ufid_ti;
+	struct mask_cache_entry __percpu *mask_cache;
 	struct list_head mask_list;
 	unsigned long last_rehash;
 	unsigned int count;
@@ -60,8 +66,9 @@ int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
 				       u32 *bucket, u32 *idx);
 struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,
-				    const struct sw_flow_key *,
-				    u32 *n_mask_hit);
+					  const struct sw_flow_key *,
+					  u32 skb_hash,
+					  u32 *n_mask_hit);
 struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *,
 				    const struct sw_flow_key *);
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
-- 
1.8.3.1

