Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE0F14DEB2
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgA3QP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 11:15:26 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46839 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727158AbgA3QP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 11:15:26 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Jan 2020 18:15:22 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00UGFM6g011610;
        Thu, 30 Jan 2020 18:15:22 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: Use nf_flow_offload_tuple for stats as well
Date:   Thu, 30 Jan 2020 18:15:18 +0200
Message-Id: <1580400918-9632-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch doesn't change any functionality.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_offload.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 83e1db3..7c5540b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -597,6 +597,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 				 struct nf_flow_rule *flow_rule,
 				 enum flow_offload_tuple_dir dir,
 				 int priority, int cmd,
+				 struct flow_stats *stats,
 				 struct list_head *block_cb_list)
 {
 	struct flow_cls_offload cls_flow = {};
@@ -619,6 +620,9 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 		i++;
 	}
 
+	if (cmd == FLOW_CLS_STATS)
+		memcpy(stats, &cls_flow.stats, sizeof(*stats));
+
 	return i;
 }
 
@@ -628,7 +632,7 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 {
 	return nf_flow_offload_tuple(offload->flowtable, offload->flow,
 				     flow_rule, dir, offload->priority,
-				     FLOW_CLS_REPLACE,
+				     FLOW_CLS_REPLACE, NULL,
 				     &offload->flowtable->flow_block.cb_list);
 }
 
@@ -636,7 +640,7 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 				   enum flow_offload_tuple_dir dir)
 {
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
-			      offload->priority, FLOW_CLS_DESTROY,
+			      offload->priority, FLOW_CLS_DESTROY, NULL,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
@@ -682,19 +686,9 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 				     enum flow_offload_tuple_dir dir,
 				     struct flow_stats *stats)
 {
-	struct nf_flowtable *flowtable = offload->flowtable;
-	struct flow_cls_offload cls_flow = {};
-	struct flow_block_cb *block_cb;
-	struct netlink_ext_ack extack;
-	__be16 proto = ETH_P_ALL;
-
-	nf_flow_offload_init(&cls_flow, proto, offload->priority,
-			     FLOW_CLS_STATS,
-			     &offload->flow->tuplehash[dir].tuple, &extack);
-
-	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
-	memcpy(stats, &cls_flow.stats, sizeof(*stats));
+	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
+			      offload->priority, FLOW_CLS_STATS, stats,
+			      &offload->flowtable->flow_block.cb_list);
 }
 
 static void flow_offload_work_stats(struct flow_offload_work *offload)
-- 
1.8.3.1

