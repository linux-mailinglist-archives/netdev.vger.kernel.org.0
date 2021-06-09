Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C710D3A1F43
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhFIVro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60504 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhFIVrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D36A563087;
        Wed,  9 Jun 2021 23:44:21 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/13] netfilter: flowtable: Set offload timeouts according to proto values
Date:   Wed,  9 Jun 2021 23:45:17 +0200
Message-Id: <20210609214523.1678-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Currently the aging period for tcp/udp connections is hard coded to
30 seconds. Aged tcp/udp connections configure a hard coded 120/30
seconds pickup timeout for conntrack.
This configuration may be too aggressive or permissive for some users.

Dynamically configure the nf flow table GC timeout intervals according
to the user defined values.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    | 47 +++++++++++++++++++++------
 net/netfilter/nf_flow_table_offload.c |  4 +--
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 48ef7460ff30..a3647fadf1cc 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -177,6 +177,8 @@ struct flow_offload {
 #define NF_FLOW_TIMEOUT (30 * HZ)
 #define nf_flowtable_time_stamp	(u32)jiffies
 
+unsigned long flow_offload_get_timeout(struct flow_offload *flow);
+
 static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 {
 	return (__s32)(timeout - nf_flowtable_time_stamp);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1d02650dd715..1e50908b1b7e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -178,12 +178,10 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 	tcp->seen[1].td_maxwin = 0;
 }
 
-#define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
-#define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
-
 static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
 
@@ -191,12 +189,17 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (!l4proto)
 		return;
 
-	if (l4num == IPPROTO_TCP)
-		timeout = NF_FLOWTABLE_TCP_PICKUP_TIMEOUT;
-	else if (l4num == IPPROTO_UDP)
-		timeout = NF_FLOWTABLE_UDP_PICKUP_TIMEOUT;
-	else
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		timeout = tn->offload_pickup;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+
+		timeout = tn->offload_pickup;
+	} else {
 		return;
+	}
 
 	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
 		ct->timeout = nfct_time_stamp + timeout;
@@ -268,11 +271,35 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
+unsigned long flow_offload_get_timeout(struct flow_offload *flow)
+{
+	const struct nf_conntrack_l4proto *l4proto;
+	unsigned long timeout = NF_FLOW_TIMEOUT;
+	struct net *net = nf_ct_net(flow->ct);
+	int l4num = nf_ct_protonum(flow->ct);
+
+	l4proto = nf_ct_l4proto_find(l4num);
+	if (!l4proto)
+		return timeout;
+
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		timeout = tn->offload_timeout;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+
+		timeout = tn->offload_timeout;
+	}
+
+	return timeout;
+}
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
@@ -304,7 +331,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 528b2f172684..f92006cec94c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -937,7 +937,7 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-				       lastused + NF_FLOW_TIMEOUT);
+				       lastused + flow_offload_get_timeout(offload->flow));
 
 	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
 		if (stats[0].pkts)
@@ -1041,7 +1041,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	__s32 delta;
 
 	delta = nf_flow_timeout_delta(flow->timeout);
-	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
+	if ((delta >= (9 * flow_offload_get_timeout(flow)) / 10))
 		return;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_STATS);
-- 
2.30.2

