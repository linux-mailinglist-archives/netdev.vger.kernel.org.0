Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077AA2345A5
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbgGaMVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:21:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733212AbgGaMVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596198104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EmuXea/+h7Paz+myZ/LoZMIu03We/7/lYDZGTtV95LA=;
        b=JZwYZbJD/Pc2dh7Ee5xoLsgKEsA5a6MGPQ3aeJRybpbaQU84Lpjr1QzyWnB3tw+8Ttey79
        UU5LZlgxc+eG6p9E6DOOj3JOLiroFkHp92U5xvAVsDVhM4oE/NsevS8g63fCP5QfNa5yVL
        LzB0APFRoWPQCqJtCZ6m2TCDhXBK5q8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-yhaVwJUPNgKw4VQ05gFbqw-1; Fri, 31 Jul 2020 08:21:42 -0400
X-MC-Unique: yhaVwJUPNgKw4VQ05gFbqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65E1280183C;
        Fri, 31 Jul 2020 12:21:40 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-26.ams2.redhat.com [10.36.114.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEF2560BF3;
        Fri, 31 Jul 2020 12:21:38 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de,
        xiangxia.m.yue@gmail.com
Subject: [PATCH net-next v4 2/2] net: openvswitch: make masks cache size configurable
Date:   Fri, 31 Jul 2020 14:21:34 +0200
Message-Id: <159619806657.973760.6924472281855287588.stgit@ebuild>
In-Reply-To: <159619801209.973760.834607259658375498.stgit@ebuild>
References: <159619801209.973760.834607259658375498.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the masks cache size configurable, or with
a size of 0, disable it.

Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---

Changes in v4:
 - Remove null check before calling free_percpu()
 - Make ovs_dp_change() return appropriate error codes

Changes in v3:
 - Use is_power_of_2() function
 - Use array_size() function
 - Fix remaining sparse errors

Changes in v2:
 - Fix sparse warnings
 - Fix netlink policy items reported by Florian Westphal

 include/uapi/linux/openvswitch.h |    1 
 net/openvswitch/datapath.c       |   17 ++++++
 net/openvswitch/flow_table.c     |  101 +++++++++++++++++++++++++++++++++-----
 net/openvswitch/flow_table.h     |   10 +++-
 4 files changed, 115 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 7cb76e5ca7cf..8300cc29dec8 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -86,6 +86,7 @@ enum ovs_datapath_attr {
 	OVS_DP_ATTR_MEGAFLOW_STATS,	/* struct ovs_dp_megaflow_stats */
 	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
 	OVS_DP_ATTR_PAD,
+	OVS_DP_ATTR_MASKS_CACHE_SIZE,
 	__OVS_DP_ATTR_MAX
 };
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a54df1fe3ec4..b58604eca032 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1498,6 +1498,7 @@ static size_t ovs_dp_cmd_msg_size(void)
 	msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_stats));
 	msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_megaflow_stats));
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
+	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
 
 	return msgsize;
 }
@@ -1535,6 +1536,10 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 	if (nla_put_u32(skb, OVS_DP_ATTR_USER_FEATURES, dp->user_features))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, OVS_DP_ATTR_MASKS_CACHE_SIZE,
+			ovs_flow_tbl_masks_cache_size(&dp->table)))
+		goto nla_put_failure;
+
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
@@ -1599,6 +1604,16 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 #endif
 	}
 
+	if (a[OVS_DP_ATTR_MASKS_CACHE_SIZE]) {
+		int err;
+		u32 cache_size;
+
+		cache_size = nla_get_u32(a[OVS_DP_ATTR_MASKS_CACHE_SIZE]);
+		err = ovs_flow_tbl_masks_cache_resize(&dp->table, cache_size);
+		if (err)
+			return err;
+	}
+
 	dp->user_features = user_features;
 
 	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
@@ -1894,6 +1909,8 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
 	[OVS_DP_ATTR_NAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1 },
 	[OVS_DP_ATTR_UPCALL_PID] = { .type = NLA_U32 },
 	[OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
+	[OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
+		PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
 };
 
 static const struct genl_ops dp_datapath_genl_ops[] = {
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index a5912ea05352..6527d84c3ea6 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -38,8 +38,8 @@
 #define MASK_ARRAY_SIZE_MIN	16
 #define REHASH_INTERVAL		(10 * 60 * HZ)
 
+#define MC_DEFAULT_HASH_ENTRIES	256
 #define MC_HASH_SHIFT		8
-#define MC_HASH_ENTRIES		(1u << MC_HASH_SHIFT)
 #define MC_HASH_SEGS		((sizeof(uint32_t) * 8) / MC_HASH_SHIFT)
 
 static struct kmem_cache *flow_cache;
@@ -341,15 +341,79 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 	}
 }
 
+static void __mask_cache_destroy(struct mask_cache *mc)
+{
+	free_percpu(mc->mask_cache);
+	kfree(mc);
+}
+
+static void mask_cache_rcu_cb(struct rcu_head *rcu)
+{
+	struct mask_cache *mc = container_of(rcu, struct mask_cache, rcu);
+
+	__mask_cache_destroy(mc);
+}
+
+static struct mask_cache *tbl_mask_cache_alloc(u32 size)
+{
+	struct mask_cache_entry __percpu *cache = NULL;
+	struct mask_cache *new;
+
+	/* Only allow size to be 0, or a power of 2, and does not exceed
+	 * percpu allocation size.
+	 */
+	if ((!is_power_of_2(size) && size != 0) ||
+	    (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)
+		return NULL;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	new->cache_size = size;
+	if (new->cache_size > 0) {
+		cache = __alloc_percpu(array_size(sizeof(struct mask_cache_entry),
+						  new->cache_size),
+				       __alignof__(struct mask_cache_entry));
+		if (!cache) {
+			kfree(new);
+			return NULL;
+		}
+	}
+
+	new->mask_cache = cache;
+	return new;
+}
+int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
+{
+	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+	struct mask_cache *new;
+
+	if (size == mc->cache_size)
+		return 0;
+
+	if ((!is_power_of_2(size) && size != 0) ||
+	    (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)
+		return -EINVAL;
+
+	new = tbl_mask_cache_alloc(size);
+	if (!new)
+		return -ENOMEM;
+
+	rcu_assign_pointer(table->mask_cache, new);
+	call_rcu(&mc->rcu, mask_cache_rcu_cb);
+
+	return 0;
+}
+
 int ovs_flow_tbl_init(struct flow_table *table)
 {
 	struct table_instance *ti, *ufid_ti;
+	struct mask_cache *mc;
 	struct mask_array *ma;
 
-	table->mask_cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
-					   MC_HASH_ENTRIES,
-					   __alignof__(struct mask_cache_entry));
-	if (!table->mask_cache)
+	mc = tbl_mask_cache_alloc(MC_DEFAULT_HASH_ENTRIES);
+	if (!mc)
 		return -ENOMEM;
 
 	ma = tbl_mask_array_alloc(MASK_ARRAY_SIZE_MIN);
@@ -367,6 +431,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
 	rcu_assign_pointer(table->ti, ti);
 	rcu_assign_pointer(table->ufid_ti, ufid_ti);
 	rcu_assign_pointer(table->mask_array, ma);
+	rcu_assign_pointer(table->mask_cache, mc);
 	table->last_rehash = jiffies;
 	table->count = 0;
 	table->ufid_count = 0;
@@ -377,7 +442,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
 free_mask_array:
 	__mask_array_destroy(ma);
 free_mask_cache:
-	free_percpu(table->mask_cache);
+	__mask_cache_destroy(mc);
 	return -ENOMEM;
 }
 
@@ -453,9 +518,11 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 {
 	struct table_instance *ti = rcu_dereference_raw(table->ti);
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
+	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
 
-	free_percpu(table->mask_cache);
-	call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
+	call_rcu(&mc->rcu, mask_cache_rcu_cb);
+	call_rcu(&ma->rcu, mask_array_rcu_cb);
 	table_instance_destroy(table, ti, ufid_ti, false);
 }
 
@@ -724,6 +791,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 					  u32 *n_mask_hit,
 					  u32 *n_cache_hit)
 {
+	struct mask_cache *mc = rcu_dereference(tbl->mask_cache);
 	struct mask_array *ma = rcu_dereference(tbl->mask_array);
 	struct table_instance *ti = rcu_dereference(tbl->ti);
 	struct mask_cache_entry *entries, *ce;
@@ -733,7 +801,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 
 	*n_mask_hit = 0;
 	*n_cache_hit = 0;
-	if (unlikely(!skb_hash)) {
+	if (unlikely(!skb_hash || mc->cache_size == 0)) {
 		u32 mask_index = 0;
 		u32 cache = 0;
 
@@ -749,11 +817,11 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 
 	ce = NULL;
 	hash = skb_hash;
-	entries = this_cpu_ptr(tbl->mask_cache);
+	entries = this_cpu_ptr(mc->mask_cache);
 
 	/* Find the cache entry 'ce' to operate on. */
 	for (seg = 0; seg < MC_HASH_SEGS; seg++) {
-		int index = hash & (MC_HASH_ENTRIES - 1);
+		int index = hash & (mc->cache_size - 1);
 		struct mask_cache_entry *e;
 
 		e = &entries[index];
@@ -867,6 +935,13 @@ int ovs_flow_tbl_num_masks(const struct flow_table *table)
 	return READ_ONCE(ma->count);
 }
 
+u32 ovs_flow_tbl_masks_cache_size(const struct flow_table *table)
+{
+	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+
+	return READ_ONCE(mc->cache_size);
+}
+
 static struct table_instance *table_instance_expand(struct table_instance *ti,
 						    bool ufid)
 {
@@ -1095,8 +1170,8 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 	for (i = 0; i < masks_entries; i++) {
 		int index = masks_and_count[i].index;
 
-		new->masks[new->count++] =
-			rcu_dereference_ovsl(ma->masks[index]);
+		if (ovsl_dereference(ma->masks[index]))
+			new->masks[new->count++] = ma->masks[index];
 	}
 
 	rcu_assign_pointer(table->mask_array, new);
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 325e939371d8..74ce48fecba9 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -27,6 +27,12 @@ struct mask_cache_entry {
 	u32 mask_index;
 };
 
+struct mask_cache {
+	struct rcu_head rcu;
+	u32 cache_size;  /* Must be ^2 value. */
+	struct mask_cache_entry __percpu *mask_cache;
+};
+
 struct mask_count {
 	int index;
 	u64 counter;
@@ -53,7 +59,7 @@ struct table_instance {
 struct flow_table {
 	struct table_instance __rcu *ti;
 	struct table_instance __rcu *ufid_ti;
-	struct mask_cache_entry __percpu *mask_cache;
+	struct mask_cache __rcu *mask_cache;
 	struct mask_array __rcu *mask_array;
 	unsigned long last_rehash;
 	unsigned int count;
@@ -77,6 +83,8 @@ int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
 			const struct sw_flow_mask *mask);
 void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow);
 int  ovs_flow_tbl_num_masks(const struct flow_table *table);
+u32  ovs_flow_tbl_masks_cache_size(const struct flow_table *table);
+int  ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size);
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
 				       u32 *bucket, u32 *idx);
 struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,

