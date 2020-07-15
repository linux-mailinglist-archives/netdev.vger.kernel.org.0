Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51C220CB0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgGOMKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:10:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726968AbgGOMKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594815004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=50yuhQ3EHVgbnj5YJeXX0BZiHl0J90wUXi5OulAm17Y=;
        b=A4hQ4QRQ5kt6ooGtGZc+3ZpUHJToyxm0W0XWkxr7F9mycFTAqedljsscXBXfZRowMbFs8V
        eBNW3DgeRtMuTHbT5NaY1zzyYwct+r4oJKf2dGSQwQkfHkvXUumFkcSrPcFlZhx4GsC2yc
        TnPPzH/aFgjp9XV6LmnW1ky18YzZA5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-cyEz6eXFPlSI4xMv-bmI5A-1; Wed, 15 Jul 2020 08:10:01 -0400
X-MC-Unique: cyEz6eXFPlSI4xMv-bmI5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 596D518A1DED;
        Wed, 15 Jul 2020 12:10:00 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-133.ams2.redhat.com [10.36.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBC09710DD;
        Wed, 15 Jul 2020 12:09:57 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net-next] net: openvswitch: reorder masks array based on usage
Date:   Wed, 15 Jul 2020 14:09:28 +0200
Message-Id: <159481496860.37198.8385493040681064040.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reorders the masks array every 4 seconds based on their
usage count. This greatly reduces the masks per packet hit, and
hence the overall performance. Especially in the OVS/OVN case for
OpenShift.

Here are some results from the OVS/OVN OpenShift test, which use
8 pods, each pod having 512 uperf connections, each connection
sends a 64-byte request and gets a 1024-byte response (TCP).
All uperf clients are on 1 worker node while all uperf servers are
on the other worker node.

Kernel without this patch     :  7.71 Gbps
Kernel with this patch applied: 14.52 Gbps

We also run some tests to verify the rebalance activity does not
lower the flow insertion rate, which does not.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Tested-by: Andrew Theurer <atheurer@redhat.com>
---
 net/openvswitch/datapath.c   |   22 +++++
 net/openvswitch/datapath.h   |    8 +-
 net/openvswitch/flow_table.c |  173 +++++++++++++++++++++++++++++++++++++++++-
 net/openvswitch/flow_table.h |   11 +++
 4 files changed, 207 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 94b024534987..95805f0e27bd 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -130,6 +130,8 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *,
 				  const struct dp_upcall_info *,
 				  uint32_t cutlen);
 
+static void ovs_dp_masks_rebalance(struct work_struct *work);
+
 /* Must be called with rcu_read_lock or ovs_mutex. */
 const char *ovs_dp_name(const struct datapath *dp)
 {
@@ -1653,6 +1655,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto err_destroy_reply;
 
 	ovs_dp_set_net(dp, sock_net(skb->sk));
+	INIT_DELAYED_WORK(&dp->masks_rebalance, ovs_dp_masks_rebalance);
 
 	/* Allocate table. */
 	err = ovs_flow_tbl_init(&dp->table);
@@ -1712,6 +1715,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_net = net_generic(ovs_dp_get_net(dp), ovs_net_id);
 	list_add_tail_rcu(&dp->list_node, &ovs_net->dps);
 
+	schedule_delayed_work(&dp->masks_rebalance,
+			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
+
 	ovs_unlock();
 
 	ovs_notify(&dp_datapath_genl_family, reply, info);
@@ -1756,6 +1762,9 @@ static void __dp_destroy(struct datapath *dp)
 
 	/* RCU destroy the flow table */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
+
+	/* Cancel remaining work. */
+	cancel_delayed_work_sync(&dp->masks_rebalance);
 }
 
 static int ovs_dp_cmd_del(struct sk_buff *skb, struct genl_info *info)
@@ -2338,6 +2347,19 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static void ovs_dp_masks_rebalance(struct work_struct *work)
+{
+	struct datapath *dp = container_of(work, struct datapath,
+					   masks_rebalance.work);
+
+	ovs_lock();
+	ovs_flow_masks_rebalance(&dp->table);
+	ovs_unlock();
+
+	schedule_delayed_work(&dp->masks_rebalance,
+			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
+}
+
 static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 	[OVS_VPORT_ATTR_NAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1 },
 	[OVS_VPORT_ATTR_STATS] = { .len = sizeof(struct ovs_vport_stats) },
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 2016dd107939..697a2354194b 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -20,8 +20,9 @@
 #include "meter.h"
 #include "vport-internal_dev.h"
 
-#define DP_MAX_PORTS           USHRT_MAX
-#define DP_VPORT_HASH_BUCKETS  1024
+#define DP_MAX_PORTS                USHRT_MAX
+#define DP_VPORT_HASH_BUCKETS       1024
+#define DP_MASKS_REBALANCE_INTERVAL 4000
 
 /**
  * struct dp_stats_percpu - per-cpu packet processing statistics for a given
@@ -83,6 +84,9 @@ struct datapath {
 
 	/* Switch meters. */
 	struct dp_meter_table meter_tbl;
+
+	/* re-balance flow masks timer */
+	struct delayed_work masks_rebalance;
 };
 
 /**
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 2398d7238300..af22c9ee28dd 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -29,6 +29,7 @@
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
 #include <linux/rculist.h>
+#include <linux/sort.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ndisc.h>
@@ -169,16 +170,70 @@ static struct table_instance *table_instance_alloc(int new_size)
 	return ti;
 }
 
+static void __mask_array_destroy(struct mask_array *ma)
+{
+	free_percpu(ma->masks_usage_cntr);
+	kfree(ma);
+}
+
+static void mask_array_rcu_cb(struct rcu_head *rcu)
+{
+	struct mask_array *ma = container_of(rcu, struct mask_array, rcu);
+
+	__mask_array_destroy(ma);
+}
+
+static void tbl_mask_array_reset_counters(struct mask_array *ma)
+{
+	int i, cpu;
+
+	/* As the per CPU counters are not atomic we can not go ahead and
+	 * reset them from another CPU. To be able to still have an approximate
+	 * zero based counter we store the value at reset, and subtract it
+	 * later when processing.
+	 */
+	for (i = 0; i < ma->max; i++)  {
+		ma->masks_usage_zero_cntr[i] = 0;
+
+		for_each_possible_cpu(cpu) {
+			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
+							  cpu);
+			unsigned int start;
+			u64 counter;
+
+			do {
+				start = u64_stats_fetch_begin_irq(&ma->syncp);
+				counter = usage_counters[i];
+			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+
+			ma->masks_usage_zero_cntr[i] += counter;
+		}
+	}
+}
+
 static struct mask_array *tbl_mask_array_alloc(int size)
 {
 	struct mask_array *new;
 
 	size = max(MASK_ARRAY_SIZE_MIN, size);
 	new = kzalloc(sizeof(struct mask_array) +
-		      sizeof(struct sw_flow_mask *) * size, GFP_KERNEL);
+		      sizeof(struct sw_flow_mask *) * size +
+		      sizeof(u64) * size, GFP_KERNEL);
 	if (!new)
 		return NULL;
 
+	new->masks_usage_zero_cntr = (u64 *)((u8 *)new +
+					     sizeof(struct mask_array) +
+					     sizeof(struct sw_flow_mask *) *
+					     size);
+
+	new->masks_usage_cntr = __alloc_percpu(sizeof(u64) * size,
+					       __alignof__(u64));
+	if (!new->masks_usage_cntr) {
+		kfree(new);
+		return NULL;
+	}
+
 	new->count = 0;
 	new->max = size;
 
@@ -202,10 +257,10 @@ static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
 			if (ovsl_dereference(old->masks[i]))
 				new->masks[new->count++] = old->masks[i];
 		}
+		call_rcu(&old->rcu, mask_array_rcu_cb);
 	}
 
 	rcu_assign_pointer(tbl->mask_array, new);
-	kfree_rcu(old, rcu);
 
 	return 0;
 }
@@ -223,6 +278,11 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
 			return err;
 
 		ma = ovsl_dereference(tbl->mask_array);
+	} else {
+		/* On every add or delete we need to reset the counters so
+		 * every new mask gets a fair chance of being prioritized.
+		 */
+		tbl_mask_array_reset_counters(ma);
 	}
 
 	BUG_ON(ovsl_dereference(ma->masks[ma_count]));
@@ -260,6 +320,9 @@ static void tbl_mask_array_del_mask(struct flow_table *tbl,
 	if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
 	    ma_count <= (ma->max / 3))
 		tbl_mask_array_realloc(tbl, ma->max / 2);
+	else
+		tbl_mask_array_reset_counters(ma);
+
 }
 
 /* Remove 'mask' from the mask list, if it is not needed any more. */
@@ -312,7 +375,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
 free_ti:
 	__table_instance_destroy(ti);
 free_mask_array:
-	kfree(ma);
+	__mask_array_destroy(ma);
 free_mask_cache:
 	free_percpu(table->mask_cache);
 	return -ENOMEM;
@@ -392,7 +455,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
-	kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
+	call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
 	table_instance_destroy(table, ti, ufid_ti, false);
 }
 
@@ -606,6 +669,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *n_mask_hit,
 				   u32 *index)
 {
+	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
 	struct sw_flow *flow;
 	struct sw_flow_mask *mask;
 	int i;
@@ -614,8 +678,12 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-			if (flow)
+			if (flow) {
+				u64_stats_update_begin(&ma->syncp);
+				usage_counters[*index]++;
+				u64_stats_update_end(&ma->syncp);
 				return flow;
+			}
 		}
 	}
 
@@ -631,6 +699,9 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
 			*index = i;
+			u64_stats_update_begin(&ma->syncp);
+			usage_counters[*index]++;
+			u64_stats_update_end(&ma->syncp);
 			return flow;
 		}
 	}
@@ -934,6 +1005,98 @@ int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
 	return 0;
 }
 
+static int compare_mask_and_count(const void *a, const void *b)
+{
+	const struct mask_count *mc_a = a;
+	const struct mask_count *mc_b = b;
+
+	return (s64)mc_b->counter - (s64)mc_a->counter;
+}
+
+/* Must be called with OVS mutex held. */
+void ovs_flow_masks_rebalance(struct flow_table *table)
+{
+	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
+	struct mask_count *masks_and_count;
+	struct mask_array *new;
+	int masks_entries = 0;
+	int i;
+
+	/* Build array of all current entries with use counters. */
+	masks_and_count = kmalloc_array(ma->max, sizeof(*masks_and_count),
+					GFP_KERNEL);
+	if (!masks_and_count)
+		return;
+
+	for (i = 0; i < ma->max; i++)  {
+		struct sw_flow_mask *mask;
+		unsigned int start;
+		int cpu;
+
+		mask = rcu_dereference_ovsl(ma->masks[i]);
+		if (unlikely(!mask))
+			break;
+
+		masks_and_count[i].index = i;
+		masks_and_count[i].counter = 0;
+
+		for_each_possible_cpu(cpu) {
+			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
+							  cpu);
+			u64 counter;
+
+			do {
+				start = u64_stats_fetch_begin_irq(&ma->syncp);
+				counter = usage_counters[i];
+			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+
+			masks_and_count[i].counter += counter;
+		}
+
+		/* Subtract the zero count value. */
+		masks_and_count[i].counter -= ma->masks_usage_zero_cntr[i];
+
+		/* Rather than calling tbl_mask_array_reset_counters()
+		 * below when no change is needed, do it inline here.
+		 */
+		ma->masks_usage_zero_cntr[i] += masks_and_count[i].counter;
+	}
+
+	if (i == 0)
+		goto free_mask_entries;
+
+	/* Sort the entries */
+	masks_entries = i;
+	sort(masks_and_count, masks_entries, sizeof(*masks_and_count),
+	     compare_mask_and_count, NULL);
+
+	/* If the order is the same, nothing to do... */
+	for (i = 0; i < masks_entries; i++) {
+		if (i != masks_and_count[i].index)
+			break;
+	}
+	if (i == masks_entries)
+		goto free_mask_entries;
+
+	/* Rebuilt the new list in order of usage. */
+	new = tbl_mask_array_alloc(ma->max);
+	if (!new)
+		goto free_mask_entries;
+
+	for (i = 0; i < masks_entries; i++) {
+		int index = masks_and_count[i].index;
+
+		new->masks[new->count++] =
+			rcu_dereference_ovsl(ma->masks[index]);
+	}
+
+	rcu_assign_pointer(table->mask_array, new);
+	call_rcu(&ma->rcu, mask_array_rcu_cb);
+
+free_mask_entries:
+	kfree(masks_and_count);
+}
+
 /* Initializes the flow module.
  * Returns zero if successful or a negative error code. */
 int ovs_flow_init(void)
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 8a5cea6ae111..1f664b050e3b 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -27,9 +27,17 @@ struct mask_cache_entry {
 	u32 mask_index;
 };
 
+struct mask_count {
+	int index;
+	u64 counter;
+};
+
 struct mask_array {
 	struct rcu_head rcu;
 	int count, max;
+	u64 __percpu *masks_usage_cntr;
+	u64 *masks_usage_zero_cntr;
+	struct u64_stats_sync syncp;
 	struct sw_flow_mask __rcu *masks[];
 };
 
@@ -86,4 +94,7 @@ bool ovs_flow_cmp(const struct sw_flow *, const struct sw_flow_match *);
 
 void ovs_flow_mask_key(struct sw_flow_key *dst, const struct sw_flow_key *src,
 		       bool full, const struct sw_flow_mask *mask);
+
+void ovs_flow_masks_rebalance(struct flow_table *table);
+
 #endif /* flow_table.h */

