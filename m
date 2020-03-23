Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F4196725
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgC1Pqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:46:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33448 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgC1Pqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:46:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id g18so4717016plq.0
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cWk4oFQDqrwsP/Dl2f22kQXEVJYhtGHvOy5gZec+d/s=;
        b=dHkkb55f5xh6c9Grrt2+aPZGQ4ugta6Y+zEtQpE7nyDBc5W7mLtf+3o2t/IeCY14ao
         p2REl3KK6A2UmDLwVhYb11Ut/lj2Skrire+/1Wt82yop4RCce0j+BetVQiR5EVo+36nG
         Bji2ezi3UnM2AViUb1HbYMjzYS4+CIDAS2j8ZgNd+D/tQZeolAazzdLSj4Pnb/aE7IRw
         kA+4jssmV9BcUgC3k1JpQHyzzgN0Q5zpvVQIkVcuQZuFjiDcl0I6Rf9BvjUgpu4YbK4x
         R6REWFczM66ulZB+IA95XXWljDvoFQwoaWiKFm9HL5UxMxqd4Ym4y/PuKCo5RU0BNltj
         QKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cWk4oFQDqrwsP/Dl2f22kQXEVJYhtGHvOy5gZec+d/s=;
        b=fh59qcRZmxXJ2euS7nBrcULEaUs6Su4K2UlakfJN+WAloXdnbCb6uAeqUpvFuiIAiy
         fzh87UkpNgX8J7cQcu4kX6yYtWvI/Fow9ls7UcUTf2CujVXIGzfMmiaw8POjaQMkRhKQ
         C4QzB8teqDg8epJRWNqbT+E9oSYc/NMUhRtkDRVCRu4poOlxo43U3cJh1B5YexWoP/xV
         KpYoBzWtpG0MJvsHuMJHhPMSYBrHxNr1GmHsxGFIz2FRG/s1fJpfvt7d6nmtJ4V4QVFO
         VhpXD+fnbkw+baK3hLcD+Ctv8UJCAPZsUZGyx06zxqbW22Rnh/kx5AQxM9M6vYhpDMKP
         InOw==
X-Gm-Message-State: ANhLgQ20bA66EdUe11aHwST4wtQVGzxKklqj+6rktK+x9D0hq5FL967z
        bvRTntVrOry2XOco2+Qcb78=
X-Google-Smtp-Source: ADFU+vvyx8iFKZsWEFSP1TV19yaqwIL8dM6+Asmo/3wv1Th8Ky/pjg2UPQ0qfHg/57/HW7joy7TS4g==
X-Received: by 2002:a17:902:864c:: with SMTP id y12mr4395474plt.8.1585410393232;
        Sat, 28 Mar 2020 08:46:33 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id q185sm6375218pfb.154.2020.03.28.08.46.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 08:46:32 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Andy Zhou <azhou@ovn.org>
Subject: [PATCH net-next v1 1/3] net: openvswitch: expand the meters number supported
Date:   Mon, 23 Mar 2020 21:10:37 +0800
Message-Id: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In kernel datapath of Open vSwitch, there are only 1024
buckets of meter in one dp. If installing more than 1024
(e.g. 8192) meters, it may lead to the performance drop.
But in some case, for example, Open vSwitch used as edge
gateway, there should be 200,000+ at least, meters used for
IP address bandwidth limitation.

[Open vSwitch userspace datapath has this issue too.]

For more scalable meter, this patch expands the buckets
when necessary, so we can install more meters in the datapath.

* Introducing the struct *dp_meter_instance*, it's easy to
  expand meter though change the *ti* point in the struct
  *dp_meter_table*.
* Using kvmalloc_array instead of kmalloc_array.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.h |   2 +-
 net/openvswitch/meter.c    | 168 ++++++++++++++++++++++++++++++-------
 net/openvswitch/meter.h    |  17 +++-
 3 files changed, 153 insertions(+), 34 deletions(-)

diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index e239a46c2f94..785105578448 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -82,7 +82,7 @@ struct datapath {
 	u32 max_headroom;
 
 	/* Switch meters. */
-	struct hlist_head *meters;
+	struct dp_meter_table *meters;
 };
 
 /**
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 5010d1ddd4bd..98003b201b45 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -47,40 +47,136 @@ static void ovs_meter_free(struct dp_meter *meter)
 	kfree_rcu(meter, rcu);
 }
 
-static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
+static struct hlist_head *meter_hash_bucket(struct dp_meter_instance *ti,
 					    u32 meter_id)
 {
-	return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
+	u32 hash = jhash_1word(meter_id, ti->hash_seed);
+
+	return &ti->buckets[hash & (ti->n_buckets - 1)];
 }
 
 /* Call with ovs_mutex or RCU read lock. */
-static struct dp_meter *lookup_meter(const struct datapath *dp,
+static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
 				     u32 meter_id)
 {
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct dp_meter *meter;
 	struct hlist_head *head;
 
-	head = meter_hash_bucket(dp, meter_id);
-	hlist_for_each_entry_rcu(meter, head, dp_hash_node,
-				lockdep_ovsl_is_held()) {
+	head = meter_hash_bucket(ti, meter_id);
+	hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
+				 lockdep_ovsl_is_held()) {
 		if (meter->id == meter_id)
 			return meter;
 	}
+
 	return NULL;
 }
 
-static void attach_meter(struct datapath *dp, struct dp_meter *meter)
+static struct dp_meter_instance *dp_meter_instance_alloc(const int size)
+{
+	struct dp_meter_instance *ti;
+	int i;
+
+	ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	if (!ti)
+		return NULL;
+
+	ti->buckets = kvmalloc_array(size, sizeof(struct hlist_head),
+				     GFP_KERNEL);
+	if (!ti->buckets) {
+		kfree(ti);
+		return NULL;
+	}
+
+	for (i = 0; i < size; i++)
+		INIT_HLIST_HEAD(&ti->buckets[i]);
+
+	ti->n_buckets = size;
+	ti->node_ver = 0;
+	get_random_bytes(&ti->hash_seed, sizeof(u32));
+
+	return ti;
+}
+
+static void dp_meter_instance_free_rcu(struct rcu_head *rcu)
 {
-	struct hlist_head *head = meter_hash_bucket(dp, meter->id);
+	struct dp_meter_instance *ti;
 
-	hlist_add_head_rcu(&meter->dp_hash_node, head);
+	ti = container_of(rcu, struct dp_meter_instance, rcu);
+	kvfree(ti->buckets);
+	kfree(ti);
 }
 
-static void detach_meter(struct dp_meter *meter)
+static void dp_meter_instance_insert(struct dp_meter_instance *ti,
+				     struct dp_meter *meter)
+{
+	struct hlist_head *head = meter_hash_bucket(ti, meter->id);
+
+	hlist_add_head_rcu(&meter->hash_node[ti->node_ver], head);
+}
+
+static void dp_meter_instance_remove(struct dp_meter_instance *ti,
+				     struct dp_meter *meter)
 {
+	hlist_del_rcu(&meter->hash_node[ti->node_ver]);
+}
+
+static struct dp_meter_instance *
+dp_meter_instance_expand(struct dp_meter_instance *ti)
+{
+	struct dp_meter_instance *new_ti;
+	int i;
+
+	new_ti = dp_meter_instance_alloc(ti->n_buckets * 2);
+	if (!new_ti)
+		return NULL;
+
+	new_ti->node_ver = !ti->node_ver;
+
+	for (i = 0; i < ti->n_buckets; i++) {
+		struct hlist_head *head = &ti->buckets[i];
+		struct dp_meter *meter;
+
+		hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
+					 lockdep_ovsl_is_held())
+			dp_meter_instance_insert(new_ti, meter);
+	}
+
+	return new_ti;
+}
+
+static void attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
+{
+	struct dp_meter_instance *new_ti;
+	struct dp_meter_instance *ti;
+
+	ti = rcu_dereference_ovsl(tbl->ti);
+	dp_meter_instance_insert(ti, meter);
+
+	/* operate the counter safely, because called with ovs_lock. */
+	tbl->count++;
+
+	if (tbl->count > ti->n_buckets) {
+		new_ti = dp_meter_instance_expand(ti);
+
+		if (new_ti) {
+			rcu_assign_pointer(tbl->ti, new_ti);
+			call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
+		}
+	}
+}
+
+static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
+{
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
+
 	ASSERT_OVSL();
-	if (meter)
-		hlist_del_rcu(&meter->dp_hash_node);
+	if (meter) {
+		/* operate the counter safely, because called with ovs_lock. */
+		tbl->count--;
+		dp_meter_instance_remove(ti, meter);
+	}
 }
 
 static struct sk_buff *
@@ -303,9 +399,9 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
 
 	/* Cannot fail after this. */
-	old_meter = lookup_meter(dp, meter_id);
-	detach_meter(old_meter);
-	attach_meter(dp, meter);
+	old_meter = lookup_meter(dp->meters, meter_id);
+	detach_meter(dp->meters, old_meter);
+	attach_meter(dp->meters, meter);
 	ovs_unlock();
 
 	/* Build response with the meter_id and stats from
@@ -365,7 +461,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Locate meter, copy stats. */
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(dp->meters, meter_id);
 	if (!meter) {
 		err = -ENOENT;
 		goto exit_unlock;
@@ -416,13 +512,13 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 	}
 
-	old_meter = lookup_meter(dp, meter_id);
+	old_meter = lookup_meter(dp->meters, meter_id);
 	if (old_meter) {
 		spin_lock_bh(&old_meter->lock);
 		err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
 		WARN_ON(err);
 		spin_unlock_bh(&old_meter->lock);
-		detach_meter(old_meter);
+		detach_meter(dp->meters, old_meter);
 	}
 	ovs_unlock();
 	ovs_meter_free(old_meter);
@@ -452,7 +548,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	int i, band_exceeded_max = -1;
 	u32 band_exceeded_rate = 0;
 
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(dp->meters, meter_id);
 	/* Do not drop the packet when there is no meter. */
 	if (!meter)
 		return false;
@@ -570,32 +666,44 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
 
 int ovs_meters_init(struct datapath *dp)
 {
-	int i;
+	struct dp_meter_instance *ti;
+	struct dp_meter_table *tbl;
 
-	dp->meters = kmalloc_array(METER_HASH_BUCKETS,
-				   sizeof(struct hlist_head), GFP_KERNEL);
+	tbl = kmalloc(sizeof(*tbl), GFP_KERNEL);
+	if (!tbl)
+		return -ENOMEM;
 
-	if (!dp->meters)
+	tbl->count = 0;
+
+	ti = dp_meter_instance_alloc(METER_HASH_BUCKETS);
+	if (!ti) {
+		kfree(tbl);
 		return -ENOMEM;
+	}
 
-	for (i = 0; i < METER_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dp->meters[i]);
+	rcu_assign_pointer(tbl->ti, ti);
+	dp->meters = tbl;
 
 	return 0;
 }
 
 void ovs_meters_exit(struct datapath *dp)
 {
+	struct dp_meter_table *tbl = dp->meters;
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	int i;
 
-	for (i = 0; i < METER_HASH_BUCKETS; i++) {
-		struct hlist_head *head = &dp->meters[i];
+	for (i = 0; i < ti->n_buckets; i++) {
+		struct hlist_head *head = &ti->buckets[i];
 		struct dp_meter *meter;
 		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(meter, n, head, dp_hash_node)
-			kfree(meter);
+		hlist_for_each_entry_safe(meter, n, head,
+					  hash_node[ti->node_ver])
+			ovs_meter_free(meter);
 	}
 
-	kfree(dp->meters);
+	kvfree(ti->buckets);
+	kfree(ti);
+	kfree(tbl);
 }
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f645913870bd..bc84796d7d4d 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -30,9 +30,7 @@ struct dp_meter_band {
 struct dp_meter {
 	spinlock_t lock;    /* Per meter lock */
 	struct rcu_head rcu;
-	struct hlist_node dp_hash_node; /*Element in datapath->meters
-					 * hash table.
-					 */
+	struct hlist_node hash_node[2];
 	u32 id;
 	u16 kbps:1, keep_stats:1;
 	u16 n_bands;
@@ -42,6 +40,19 @@ struct dp_meter {
 	struct dp_meter_band bands[];
 };
 
+struct dp_meter_instance {
+	struct hlist_head *buckets;
+	struct rcu_head rcu;
+	u32 n_buckets;
+	u32 hash_seed;
+	u8 node_ver;
+};
+
+struct dp_meter_table {
+	struct dp_meter_instance __rcu *ti;
+	u32 count;
+};
+
 extern struct genl_family dp_meter_genl_family;
 int ovs_meters_init(struct datapath *dp);
 void ovs_meters_exit(struct datapath *dp);
-- 
2.23.0

