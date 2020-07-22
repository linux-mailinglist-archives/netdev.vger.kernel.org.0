Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8924229375
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgGVI1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:27:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37921 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729946AbgGVI1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595406472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4at0S+2tciRsUQPqT2uhZ/GtLbZz7UdUpOihpzDtLZ8=;
        b=KLnMX/1P84PjS858xvPyW3A1AJoG7cZJLenhWB9MCvnN6ZStcDQJO2sGw3pP6lxGOmzxuV
        rmc14JO+Dr4hdkHcSP73MdoN30A09qYybhJU6Q5GWRTXhfzwjUdUzsWeh5U9F1qJpXzYNU
        2f80U/YcTt//LIoL8ggpPAzNgEvH6Hc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-VNYSwCu_P-uqZCkCNNWkkw-1; Wed, 22 Jul 2020 04:27:48 -0400
X-MC-Unique: VNYSwCu_P-uqZCkCNNWkkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0469891270;
        Wed, 22 Jul 2020 08:27:47 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-133.ams2.redhat.com [10.36.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B97F6610AF;
        Wed, 22 Jul 2020 08:27:45 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net-next 1/2] net: openvswitch: add masks cache hit counter
Date:   Wed, 22 Jul 2020 10:27:43 +0200
Message-Id: <159540646349.619787.13678459178598317091.stgit@ebuild>
In-Reply-To: <159540642765.619787.5484526399990292188.stgit@ebuild>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter that counts the number of masks cache hits, and
export it through the megaflow netlink statistics.

Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/uapi/linux/openvswitch.h |    2 +-
 net/openvswitch/datapath.c       |    5 ++++-
 net/openvswitch/datapath.h       |    3 +++
 net/openvswitch/flow_table.c     |   19 ++++++++++++++-----
 net/openvswitch/flow_table.h     |    3 ++-
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 9b14519e74d9..7cb76e5ca7cf 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -102,8 +102,8 @@ struct ovs_dp_megaflow_stats {
 	__u64 n_mask_hit;	 /* Number of masks used for flow lookups. */
 	__u32 n_masks;		 /* Number of masks for the datapath. */
 	__u32 pad0;		 /* Pad for future expension. */
+	__u64 n_cache_hit;       /* Number of cache matches for flow lookups. */
 	__u64 pad1;		 /* Pad for future expension. */
-	__u64 pad2;		 /* Pad for future expension. */
 };
 
 struct ovs_vport_stats {
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 95805f0e27bd..a54df1fe3ec4 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -225,13 +225,14 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	struct dp_stats_percpu *stats;
 	u64 *stats_counter;
 	u32 n_mask_hit;
+	u32 n_cache_hit;
 	int error;
 
 	stats = this_cpu_ptr(dp->stats_percpu);
 
 	/* Look up flow. */
 	flow = ovs_flow_tbl_lookup_stats(&dp->table, key, skb_get_hash(skb),
-					 &n_mask_hit);
+					 &n_mask_hit, &n_cache_hit);
 	if (unlikely(!flow)) {
 		struct dp_upcall_info upcall;
 
@@ -262,6 +263,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	u64_stats_update_begin(&stats->syncp);
 	(*stats_counter)++;
 	stats->n_mask_hit += n_mask_hit;
+	stats->n_cache_hit += n_cache_hit;
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -699,6 +701,7 @@ static void get_dp_stats(const struct datapath *dp, struct ovs_dp_stats *stats,
 		stats->n_missed += local_stats.n_missed;
 		stats->n_lost += local_stats.n_lost;
 		mega_stats->n_mask_hit += local_stats.n_mask_hit;
+		mega_stats->n_cache_hit += local_stats.n_cache_hit;
 	}
 }
 
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 697a2354194b..86d78613edb4 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -38,12 +38,15 @@
  * @n_mask_hit: Number of masks looked up for flow match.
  *   @n_mask_hit / (@n_hit + @n_missed)  will be the average masks looked
  *   up per packet.
+ * @n_cache_hit: The number of received packets that had their mask found using
+ * the mask cache.
  */
 struct dp_stats_percpu {
 	u64 n_hit;
 	u64 n_missed;
 	u64 n_lost;
 	u64 n_mask_hit;
+	u64 n_cache_hit;
 	struct u64_stats_sync syncp;
 };
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index af22c9ee28dd..a5912ea05352 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -667,6 +667,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct mask_array *ma,
 				   const struct sw_flow_key *key,
 				   u32 *n_mask_hit,
+				   u32 *n_cache_hit,
 				   u32 *index)
 {
 	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
@@ -682,6 +683,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				u64_stats_update_begin(&ma->syncp);
 				usage_counters[*index]++;
 				u64_stats_update_end(&ma->syncp);
+				(*n_cache_hit)++;
 				return flow;
 			}
 		}
@@ -719,7 +721,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 					  const struct sw_flow_key *key,
 					  u32 skb_hash,
-					  u32 *n_mask_hit)
+					  u32 *n_mask_hit,
+					  u32 *n_cache_hit)
 {
 	struct mask_array *ma = rcu_dereference(tbl->mask_array);
 	struct table_instance *ti = rcu_dereference(tbl->ti);
@@ -729,10 +732,13 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 	int seg;
 
 	*n_mask_hit = 0;
+	*n_cache_hit = 0;
 	if (unlikely(!skb_hash)) {
 		u32 mask_index = 0;
+		u32 cache = 0;
 
-		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
+		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
+				   &mask_index);
 	}
 
 	/* Pre and post recirulation flows usually have the same skb_hash
@@ -753,7 +759,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 		e = &entries[index];
 		if (e->skb_hash == skb_hash) {
 			flow = flow_lookup(tbl, ti, ma, key, n_mask_hit,
-					   &e->mask_index);
+					   n_cache_hit, &e->mask_index);
 			if (!flow)
 				e->skb_hash = 0;
 			return flow;
@@ -766,10 +772,12 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 	}
 
 	/* Cache miss, do full lookup. */
-	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &ce->mask_index);
+	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, n_cache_hit,
+			   &ce->mask_index);
 	if (flow)
 		ce->skb_hash = skb_hash;
 
+	*n_cache_hit = 0;
 	return flow;
 }
 
@@ -779,9 +787,10 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
 	u32 __always_unused n_mask_hit;
+	u32 __always_unused n_cache_hit;
 	u32 index = 0;
 
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
+	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 1f664b050e3b..325e939371d8 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -82,7 +82,8 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
 struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,
 					  const struct sw_flow_key *,
 					  u32 skb_hash,
-					  u32 *n_mask_hit);
+					  u32 *n_mask_hit,
+					  u32 *n_cache_hit);
 struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *,
 				    const struct sw_flow_key *);
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,

