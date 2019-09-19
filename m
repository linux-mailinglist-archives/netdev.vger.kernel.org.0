Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B4BEDB9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfIZIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46762 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIZIrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so1404632pfg.13
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FOXGs3dGs/tTHBHBhZJVHOJPRZHVi5a8OXwYOCUK8lk=;
        b=uoEav9KDQQ/3zN83BlXsZuAcOY/cEj2pz9jNSkemLNiECTqxDTbrqGWDqwJfdRcT8N
         Uo8uzE11k2XKrb2jc17SrgIJTM79qI77PD8ZqyICWKfG4xxkGGp9D7ySVg7SwCAO+jyv
         W4VyxSsApylLroMF2i6ijWyzooezvefeki5lTohF9GFZRlSfg3+Dqg0hZNMq1oIjw28z
         U6QuqJfVAs9omBYzuV6nlDAkxJUxRBIsOW8YrBGGckaEMz1M15QL+QvZ9z3utstN2ZYG
         fJs2bBxWZNtNQjLMMVnBAG5CbyxzeEXDLn3k8eeCcw50nIoE0AGMeby2+o8+GavpqvN6
         pI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FOXGs3dGs/tTHBHBhZJVHOJPRZHVi5a8OXwYOCUK8lk=;
        b=OphslExIR2bmqoyAVxSj4ZF2IxjzrCklhHt2knslG+7mVQ801I78Mg1fGkYKkjWBZf
         gjaFZbXndFiiA7izAD/ym2CSBpHVvXaCuQ+UfrOrDB93HvmQ+vfVCozgd0X+s1ZSWG7J
         iZfeZHWKk4F1gCtr8fAPrWeED+TqZ62yGmLIJYg1nmOrv1SY6bWkK8s7uzDo8vvlNC4u
         RTUaEaZTnxk8n4BW5QkAE4WbR7j4sdb4noEYmHAde71oyR6kC1Seonpwr/iPGIk4I5qq
         iicgb5y3xhDCz393X9tigZeERCWiWmXX7wpR226PhdxExVQED3YE+CqzHw6v80wc4vn7
         MmYw==
X-Gm-Message-State: APjAAAV+P93OReFthET3fKPs8KQct34kE9fzOn6XfNQo16hKNVP7ji7K
        kr5GuJrprjeBnc0RJ2UQ8B8=
X-Google-Smtp-Source: APXvYqwvzrcpMGe/rCxngZ6qjeScvGzOao8A+ZMcyd1L5Nbp8P2K6ehANOO7lt1KRFdzGLLjo7dzcg==
X-Received: by 2002:a17:90a:6348:: with SMTP id v8mr2326601pjs.7.1569487644079;
        Thu, 26 Sep 2019 01:47:24 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:23 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 2/7] net: openvswitch: convert mask list in mask array
Date:   Fri, 20 Sep 2019 00:54:48 +0800
Message-Id: <1568912093-68535-3-git-send-email-xiangxia.m.yue@gmail.com>
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
| mask caches index of mask in mask_list. On packet recv OVS
| need to traverse mask-list to get cached mask. Therefore array
| is better for retrieving cached mask. This also allows better
| cache replacement algorithm by directly checking mask's existence.

Link: https://github.com/openvswitch/ovs/commit/d49fc3ff53c65e4eca9cabd52ac63396746a7ef5
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 218 +++++++++++++++++++++++++++++++++----------
 net/openvswitch/flow_table.h |   8 +-
 3 files changed, 175 insertions(+), 52 deletions(-)

diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index b830d5f..8080518 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -166,7 +166,6 @@ struct sw_flow_key_range {
 struct sw_flow_mask {
 	int ref_count;
 	struct rcu_head rcu;
-	struct list_head list;
 	struct sw_flow_key_range range;
 	struct sw_flow_key key;
 };
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 3d515c0..99954fa 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -34,6 +34,7 @@
 #include <net/ndisc.h>
 
 #define TBL_MIN_BUCKETS		1024
+#define MASK_ARRAY_SIZE_MIN	16
 #define REHASH_INTERVAL		(10 * 60 * HZ)
 
 #define MC_HASH_SHIFT		8
@@ -168,9 +169,59 @@ static struct table_instance *table_instance_alloc(int new_size)
 	return ti;
 }
 
+static void mask_array_rcu_cb(struct rcu_head *rcu)
+{
+	struct mask_array *ma = container_of(rcu, struct mask_array, rcu);
+
+	kfree(ma);
+}
+
+static struct mask_array *tbl_mask_array_alloc(int size)
+{
+	struct mask_array *new;
+
+	size = max(MASK_ARRAY_SIZE_MIN, size);
+	new = kzalloc(sizeof(struct mask_array) +
+		      sizeof(struct sw_flow_mask *) * size, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	new->count = 0;
+	new->max = size;
+
+	return new;
+}
+
+static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
+{
+	struct mask_array *old;
+	struct mask_array *new;
+
+	new = tbl_mask_array_alloc(size);
+	if (!new)
+		return -ENOMEM;
+
+	old = ovsl_dereference(tbl->mask_array);
+	if (old) {
+		int i;
+
+		for (i = 0; i < old->max; i++) {
+			if (ovsl_dereference(old->masks[i]))
+				new->masks[new->count++] = old->masks[i];
+		}
+       }
+       rcu_assign_pointer(tbl->mask_array, new);
+
+       if (old)
+	       call_rcu(&old->rcu, mask_array_rcu_cb);
+
+       return 0;
+}
+
 int ovs_flow_tbl_init(struct flow_table *table)
 {
 	struct table_instance *ti, *ufid_ti;
+	struct mask_array *ma;
 
 	table->mask_cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
 					   MC_HASH_ENTRIES,
@@ -178,9 +229,13 @@ int ovs_flow_tbl_init(struct flow_table *table)
 	if (!table->mask_cache)
 		return -ENOMEM;
 
+	ma = tbl_mask_array_alloc(MASK_ARRAY_SIZE_MIN);
+	if (!ma)
+		goto free_mask_cache;
+
 	ti = table_instance_alloc(TBL_MIN_BUCKETS);
 	if (!ti)
-		goto free_mask_cache;
+		goto free_mask_array;
 
 	ufid_ti = table_instance_alloc(TBL_MIN_BUCKETS);
 	if (!ufid_ti)
@@ -188,7 +243,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
 
 	rcu_assign_pointer(table->ti, ti);
 	rcu_assign_pointer(table->ufid_ti, ufid_ti);
-	INIT_LIST_HEAD(&table->mask_list);
+	rcu_assign_pointer(table->mask_array, ma);
 	table->last_rehash = jiffies;
 	table->count = 0;
 	table->ufid_count = 0;
@@ -196,6 +251,8 @@ int ovs_flow_tbl_init(struct flow_table *table)
 
 free_ti:
 	__table_instance_destroy(ti);
+free_mask_array:
+	kfree(ma);
 free_mask_cache:
 	free_percpu(table->mask_cache);
 	return -ENOMEM;
@@ -255,6 +312,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
+	kfree(rcu_dereference_raw(table->mask_array));
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
@@ -460,17 +518,27 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
+				   struct mask_array *ma,
 				   const struct sw_flow_key *key,
-				   u32 *n_mask_hit)
+				   u32 *n_mask_hit,
+				   u32 *index)
 {
-	struct sw_flow_mask *mask;
 	struct sw_flow *flow;
+	int i;
 
-	list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
-		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-		if (flow)  /* Found */
-			return flow;
+	for (i = 0; i < ma->max; i++)  {
+		struct sw_flow_mask *mask;
+
+		mask = rcu_dereference_ovsl(ma->masks[i]);
+		if (mask) {
+			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
+			if (flow) { /* Found */
+				*index = i;
+				return flow;
+			}
+		}
 	}
+
 	return NULL;
 }
 
@@ -486,6 +554,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 					  u32 skb_hash,
 					  u32 *n_mask_hit)
 {
+	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_cache_entry  *entries, *ce, *del;
 	struct sw_flow *flow;
@@ -493,8 +562,11 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 	int seg;
 
 	*n_mask_hit = 0;
-	if (unlikely(!skb_hash))
-		return flow_lookup(tbl, ti, key, n_mask_hit);
+	if (unlikely(!skb_hash)) {
+		u32 __always_unused mask_index;
+
+		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
+	}
 
 	del = NULL;
 	entries = this_cpu_ptr(tbl->mask_cache);
@@ -507,37 +579,33 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 
 		if (ce->skb_hash == skb_hash) {
 			struct sw_flow_mask *mask;
-			int i;
-
-			i = 0;
-			list_for_each_entry_rcu(mask, &tbl->mask_list, list) {
-				if (ce->mask_index == i++) {
-					flow = masked_flow_lookup(ti, key, mask,
-								  n_mask_hit);
-					if (flow)  /* Found */
-						return flow;
-
-					break;
-				}
+			struct sw_flow *flow;
+
+			mask = rcu_dereference_ovsl(ma->masks[ce->mask_index]);
+			if (mask) {
+				flow = masked_flow_lookup(ti, key, mask,
+							  n_mask_hit);
+				if (flow)  /* Found */
+					return flow;
 			}
 
 			del = ce;
 			break;
 		}
 
-		if (!del || (del->skb_hash && !ce->skb_hash)) {
+		if (!del || (del->skb_hash && !ce->skb_hash) ||
+		    (rcu_dereference_ovsl(ma->masks[del->mask_index]) &&
+		     !rcu_dereference_ovsl(ma->masks[ce->mask_index]))) {
 			del = ce;
 		}
 
 		hash >>= MC_HASH_SHIFT;
 	}
 
-	flow = flow_lookup(tbl, ti, key, n_mask_hit);
+	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &del->mask_index);
 
-	if (flow) {
+	if (flow)
 		del->skb_hash = skb_hash;
-		del->mask_index = (*n_mask_hit - 1);
-	}
 
 	return flow;
 }
@@ -546,26 +614,38 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 				    const struct sw_flow_key *key)
 {
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
+	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
+
 	u32 __always_unused n_mask_hit;
+	u32 __always_unused index;
 
-	return flow_lookup(tbl, ti, key, &n_mask_hit);
+	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
 					  const struct sw_flow_match *match)
 {
-	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
-	struct sw_flow_mask *mask;
-	struct sw_flow *flow;
-	u32 __always_unused n_mask_hit;
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i;
 
 	/* Always called under ovs-mutex. */
-	list_for_each_entry(mask, &tbl->mask_list, list) {
+	for (i = 0; i < ma->max; i++) {
+		struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
+		u32 __always_unused n_mask_hit;
+		struct sw_flow_mask *mask;
+		struct sw_flow *flow;
+
+		mask = ovsl_dereference(ma->masks[i]);
+		if (!mask)
+			continue;
+
 		flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
 		if (flow && ovs_identifier_is_key(&flow->id) &&
-		    ovs_flow_cmp_unmasked_key(flow, match))
+		    ovs_flow_cmp_unmasked_key(flow, match)) {
 			return flow;
+		}
 	}
+
 	return NULL;
 }
 
@@ -611,13 +691,8 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
 
 int ovs_flow_tbl_num_masks(const struct flow_table *table)
 {
-	struct sw_flow_mask *mask;
-	int num = 0;
-
-	list_for_each_entry(mask, &table->mask_list, list)
-		num++;
-
-	return num;
+	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
+	return ma->count;
 }
 
 static struct table_instance *table_instance_expand(struct table_instance *ti,
@@ -638,8 +713,19 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 		mask->ref_count--;
 
 		if (!mask->ref_count) {
-			list_del_rcu(&mask->list);
-			kfree_rcu(mask, rcu);
+			struct mask_array *ma;
+			int i;
+
+			ma = ovsl_dereference(tbl->mask_array);
+			for (i = 0; i < ma->max; i++) {
+				if (mask == ovsl_dereference(ma->masks[i])) {
+					RCU_INIT_POINTER(ma->masks[i], NULL);
+					ma->count--;
+					kfree_rcu(mask, rcu);
+					return;
+				}
+			}
+			BUG();
 		}
 	}
 }
@@ -689,13 +775,16 @@ static bool mask_equal(const struct sw_flow_mask *a,
 static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
 					   const struct sw_flow_mask *mask)
 {
-	struct list_head *ml;
+	struct mask_array *ma;
+	int i;
 
-	list_for_each(ml, &tbl->mask_list) {
-		struct sw_flow_mask *m;
-		m = container_of(ml, struct sw_flow_mask, list);
-		if (mask_equal(mask, m))
-			return m;
+	ma = ovsl_dereference(tbl->mask_array);
+	for (i = 0; i < ma->max; i++) {
+		struct sw_flow_mask *t;
+		t = ovsl_dereference(ma->masks[i]);
+
+		if (t && mask_equal(mask, t))
+			return t;
 	}
 
 	return NULL;
@@ -706,15 +795,44 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 			    const struct sw_flow_mask *new)
 {
 	struct sw_flow_mask *mask;
+
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
+		struct mask_array *ma;
+		int i;
+
 		/* Allocate a new mask if none exsits. */
 		mask = mask_alloc();
 		if (!mask)
 			return -ENOMEM;
 		mask->key = new->key;
 		mask->range = new->range;
-		list_add_tail_rcu(&mask->list, &tbl->mask_list);
+
+		/* Add mask to mask-list. */
+		ma = ovsl_dereference(tbl->mask_array);
+		if (ma->count >= ma->max) {
+			int err;
+
+			err = tbl_mask_array_realloc(tbl, ma->max +
+						     MASK_ARRAY_SIZE_MIN);
+			if (err) {
+				kfree(mask);
+				return err;
+			}
+
+			ma = ovsl_dereference(tbl->mask_array);
+		}
+
+		for (i = 0; i < ma->max; i++) {
+			const struct sw_flow_mask *t;
+
+			t = ovsl_dereference(ma->masks[i]);
+			if (!t) {
+				rcu_assign_pointer(ma->masks[i], mask);
+				ma->count++;
+				break;
+			}
+		}
 	} else {
 		BUG_ON(!mask->ref_count);
 		mask->ref_count++;
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 04b6b1c..8a5cea6 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -27,6 +27,12 @@ struct mask_cache_entry {
 	u32 mask_index;
 };
 
+struct mask_array {
+	struct rcu_head rcu;
+	int count, max;
+	struct sw_flow_mask __rcu *masks[];
+};
+
 struct table_instance {
 	struct hlist_head *buckets;
 	unsigned int n_buckets;
@@ -40,7 +46,7 @@ struct flow_table {
 	struct table_instance __rcu *ti;
 	struct table_instance __rcu *ufid_ti;
 	struct mask_cache_entry __percpu *mask_cache;
-	struct list_head mask_list;
+	struct mask_array __rcu *mask_array;
 	unsigned long last_rehash;
 	unsigned int count;
 	unsigned int ufid_count;
-- 
1.8.3.1

