Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94DA1D31C1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgENNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:49:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49153 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726117AbgENNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:49:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:49:00 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDmxb8025987;
        Thu, 14 May 2020 16:48:59 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 1/3] netfilter: flowtable: Control flow offload timeout interval
Date:   Thu, 14 May 2020 16:48:28 +0300
Message-Id: <1589464110-7571-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting per flow table flow timeout in seconds,
which determines the after how many seconds from last seen packet
to delete the flow from offload. This can be set by the user of the
API before initializing the table, otherwise, the default value (30
seconds) will be used.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h |  7 ++++++-
 net/netfilter/nf_flow_table_core.c    | 12 ++++++++++--
 net/netfilter/nf_flow_table_offload.c |  5 +++--
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6bf6965..8dca957 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -75,6 +75,7 @@ struct nf_flowtable {
 	unsigned int			flags;
 	struct flow_block		flow_block;
 	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
+	u32				flow_timeout;
 	possible_net_t			net;
 };
 
@@ -143,7 +144,6 @@ struct flow_offload {
 	struct rcu_head				rcu_head;
 };
 
-#define NF_FLOW_TIMEOUT (30 * HZ)
 #define nf_flowtable_time_stamp	(u32)jiffies
 
 static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
@@ -151,6 +151,11 @@ static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 	return (__s32)(timeout - nf_flowtable_time_stamp);
 }
 
+static inline __s32 nf_flow_offload_timeout(struct nf_flowtable *flow_table)
+{
+	return flow_table->flow_timeout;
+}
+
 struct nf_flow_route {
 	struct {
 		struct dst_entry	*dst;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4344e57..b9af9f2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -225,7 +225,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp +
+			nf_flow_offload_timeout(flow_table);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
@@ -255,7 +256,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp +
+			nf_flow_offload_timeout(flow_table);
 
 	if (likely(!nf_flowtable_hw_offload(flow_table) ||
 		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
@@ -547,10 +549,16 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
+#define NF_DEFAULT_FLOW_TIMEOUT (30 * HZ)
+
 int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
 	int err;
 
+	flowtable->flow_timeout = flowtable->flow_timeout ?
+				  flowtable->flow_timeout * HZ :
+				  NF_DEFAULT_FLOW_TIMEOUT;
+
 	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6dccbc7..2a43476 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -779,6 +779,7 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 
 static void flow_offload_work_stats(struct flow_offload_work *offload)
 {
+	u64 flow_timeout = nf_flow_offload_timeout(offload->flowtable);
 	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
 	u64 lastused;
 
@@ -787,7 +788,7 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-				       lastused + NF_FLOW_TIMEOUT);
+				       lastused + flow_timeout);
 
 	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
 		if (stats[0].pkts)
@@ -880,7 +881,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	__s32 delta;
 
 	delta = nf_flow_timeout_delta(flow->timeout);
-	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
+	if ((delta >= (9 * nf_flow_offload_timeout(flowtable)) / 10))
 		return;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_STATS);
-- 
1.8.3.1

