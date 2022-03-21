Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D764E4E2673
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347435AbiCUMcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347402AbiCUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F04358597F;
        Mon, 21 Mar 2022 05:31:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D84A06304C;
        Mon, 21 Mar 2022 13:28:24 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 18/19] netfilter: flowtable: remove redundant field in flow_offload_work struct
Date:   Mon, 21 Mar 2022 13:30:51 +0100
Message-Id: <20220321123052.70553-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321123052.70553-1-pablo@netfilter.org>
References: <20220321123052.70553-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Already available through the flowtable object, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index cac4468a8a6a..11b6e1942092 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -20,7 +20,6 @@ static struct workqueue_struct *nf_flow_offload_stats_wq;
 struct flow_offload_work {
 	struct list_head	list;
 	enum flow_cls_command	cmd;
-	int			priority;
 	struct nf_flowtable	*flowtable;
 	struct flow_offload	*flow;
 	struct work_struct	work;
@@ -874,7 +873,8 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 				  enum flow_offload_tuple_dir dir)
 {
 	return nf_flow_offload_tuple(offload->flowtable, offload->flow,
-				     flow_rule, dir, offload->priority,
+				     flow_rule, dir,
+				     offload->flowtable->priority,
 				     FLOW_CLS_REPLACE, NULL,
 				     &offload->flowtable->flow_block.cb_list);
 }
@@ -883,7 +883,8 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 				   enum flow_offload_tuple_dir dir)
 {
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
-			      offload->priority, FLOW_CLS_DESTROY, NULL,
+			      offload->flowtable->priority,
+			      FLOW_CLS_DESTROY, NULL,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
@@ -934,7 +935,8 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 				     struct flow_stats *stats)
 {
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
-			      offload->priority, FLOW_CLS_STATS, stats,
+			      offload->flowtable->priority,
+			      FLOW_CLS_STATS, stats,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
@@ -1012,7 +1014,6 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 
 	offload->cmd = cmd;
 	offload->flow = flow;
-	offload->priority = flowtable->priority;
 	offload->flowtable = flowtable;
 	INIT_WORK(&offload->work, flow_offload_work_handler);
 
-- 
2.30.2

