Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A6F28F774
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390054AbgJORJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389725AbgJORJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602781783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rOZn4VSKnJnp6C2TuuNsdspA2c0BFXEXOh0g4OMp0/E=;
        b=RnZidrLZaoJzuQyFBspKod7N6o3NmbAUj4G1gChLSRpCUqAyrBfT4Gyyf3mNJbNcLv1DaC
        kCW0JMAikyLqS1clczMWiltVeImMwc6/fiLnVsW1Wj3oW334SvwCkDMzuBGCFkgMcz5mbi
        0jcIicOUikkHQVJk0fD72koqg3i1H44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-MfNI3l2iOsyY2r_Km_E8pw-1; Thu, 15 Oct 2020 13:09:40 -0400
X-MC-Unique: MfNI3l2iOsyY2r_Km_E8pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 616E7AF9A0;
        Thu, 15 Oct 2020 17:09:38 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-61.ams2.redhat.com [10.36.115.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B1EB75128;
        Thu, 15 Oct 2020 17:09:36 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, jlelli@redhat.com,
        bigeasy@linutronix.de, i.maximets@ovn.org
Subject: [PATCH net v3] net: openvswitch: fix to make sure flow_lookup() is not preempted
Date:   Thu, 15 Oct 2020 19:09:33 +0200
Message-Id: <160278168341.905188.913081997609088316.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow_lookup() function uses per CPU variables, which must be called
with BH disabled. However, this is fine in the general NAPI use case
where the local BH is disabled. But, it's also called from the netlink
context. The below patch makes sure that even in the netlink path, the
BH is disabled.

In addition, u64_stats_update_begin() requires a lock to ensure one writer
which is not ensured here. Making it per-CPU and disabling NAPI (softirq)
ensures that there is always only one writer.

Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
Reported-by: Juri Lelli <jlelli@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
v3: - Add comment to flow_lookup() call
    - Some update in code comments, and commit message

v2: - Add u64_stats_update_begin() sync point protection
    - Moved patch to net from net-next branch

 net/openvswitch/flow_table.c |   58 +++++++++++++++++++++++++-----------------
 net/openvswitch/flow_table.h |    8 ++++--
 2 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e2235849a57e..7d50c45fea37 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -172,7 +172,7 @@ static struct table_instance *table_instance_alloc(int new_size)
 
 static void __mask_array_destroy(struct mask_array *ma)
 {
-	free_percpu(ma->masks_usage_cntr);
+	free_percpu(ma->masks_usage_stats);
 	kfree(ma);
 }
 
@@ -196,15 +196,15 @@ static void tbl_mask_array_reset_counters(struct mask_array *ma)
 		ma->masks_usage_zero_cntr[i] = 0;
 
 		for_each_possible_cpu(cpu) {
-			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
-							  cpu);
+			struct mask_array_stats *stats;
 			unsigned int start;
 			u64 counter;
 
+			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&ma->syncp);
-				counter = usage_counters[i];
-			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				counter = stats->usage_cntrs[i];
+			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
 			ma->masks_usage_zero_cntr[i] += counter;
 		}
@@ -227,9 +227,10 @@ static struct mask_array *tbl_mask_array_alloc(int size)
 					     sizeof(struct sw_flow_mask *) *
 					     size);
 
-	new->masks_usage_cntr = __alloc_percpu(sizeof(u64) * size,
-					       __alignof__(u64));
-	if (!new->masks_usage_cntr) {
+	new->masks_usage_stats = __alloc_percpu(sizeof(struct mask_array_stats) +
+						sizeof(u64) * size,
+						__alignof__(u64));
+	if (!new->masks_usage_stats) {
 		kfree(new);
 		return NULL;
 	}
@@ -723,6 +724,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 
 /* Flow lookup does full lookup on flow table. It starts with
  * mask from index passed in *index.
+ * This function MUST be called with BH disabled due to the use
+ * of CPU specific variables.
  */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
@@ -732,7 +735,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *n_cache_hit,
 				   u32 *index)
 {
-	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
+	struct mask_array_stats *stats = this_cpu_ptr(ma->masks_usage_stats);
 	struct sw_flow *flow;
 	struct sw_flow_mask *mask;
 	int i;
@@ -742,9 +745,9 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 			if (flow) {
-				u64_stats_update_begin(&ma->syncp);
-				usage_counters[*index]++;
-				u64_stats_update_end(&ma->syncp);
+				u64_stats_update_begin(&stats->syncp);
+				stats->usage_cntrs[*index]++;
+				u64_stats_update_end(&stats->syncp);
 				(*n_cache_hit)++;
 				return flow;
 			}
@@ -763,9 +766,9 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
 			*index = i;
-			u64_stats_update_begin(&ma->syncp);
-			usage_counters[*index]++;
-			u64_stats_update_end(&ma->syncp);
+			u64_stats_update_begin(&stats->syncp);
+			stats->usage_cntrs[*index]++;
+			u64_stats_update_end(&stats->syncp);
 			return flow;
 		}
 	}
@@ -851,9 +854,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
 	u32 __always_unused n_mask_hit;
 	u32 __always_unused n_cache_hit;
+	struct sw_flow *flow;
 	u32 index = 0;
 
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	/* This function gets called trough the netlink interface and therefore
+	 * is preemptible. However, flow_lookup() function needs to be called
+	 * with BH disabled due to CPU specific variables.
+	 */
+	local_bh_disable();
+	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	local_bh_enable();
+	return flow;
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
@@ -1109,7 +1120,6 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 
 	for (i = 0; i < ma->max; i++)  {
 		struct sw_flow_mask *mask;
-		unsigned int start;
 		int cpu;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
@@ -1120,14 +1130,16 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 		masks_and_count[i].counter = 0;
 
 		for_each_possible_cpu(cpu) {
-			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
-							  cpu);
+			struct mask_array_stats *stats;
+			unsigned int start;
 			u64 counter;
 
+			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&ma->syncp);
-				counter = usage_counters[i];
-			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				counter = stats->usage_cntrs[i];
+			} while (u64_stats_fetch_retry_irq(&stats->syncp,
+							   start));
 
 			masks_and_count[i].counter += counter;
 		}
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 6e7d4ac59353..43144396e192 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -38,12 +38,16 @@ struct mask_count {
 	u64 counter;
 };
 
+struct mask_array_stats {
+	struct u64_stats_sync syncp;
+	u64 usage_cntrs[];
+};
+
 struct mask_array {
 	struct rcu_head rcu;
 	int count, max;
-	u64 __percpu *masks_usage_cntr;
+	struct mask_array_stats __percpu *masks_usage_stats;
 	u64 *masks_usage_zero_cntr;
-	struct u64_stats_sync syncp;
 	struct sw_flow_mask __rcu *masks[];
 };
 

