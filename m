Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013991892ED
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCRAkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:11 -0400
Received: from correo.us.es ([193.147.175.20]:45584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgCRAkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F00D27F8B0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F8DEDA3A3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84EEDDA3A0; Wed, 18 Mar 2020 01:39:40 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5916DA390;
        Wed, 18 Mar 2020 01:39:38 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:38 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8E7ED426CCB9;
        Wed, 18 Mar 2020 01:39:38 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/29] netfilter: flowtable: Use nf_flow_offload_tuple for stats as well
Date:   Wed, 18 Mar 2020 01:39:28 +0100
Message-Id: <20200318003956.73573-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

This patch doesn't change any functionality.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 42b73a084a63..88695ff44e76 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -574,6 +574,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 				 struct nf_flow_rule *flow_rule,
 				 enum flow_offload_tuple_dir dir,
 				 int priority, int cmd,
+				 struct flow_stats *stats,
 				 struct list_head *block_cb_list)
 {
 	struct flow_cls_offload cls_flow = {};
@@ -598,6 +599,9 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	}
 	mutex_unlock(&flowtable->flow_block_lock);
 
+	if (cmd == FLOW_CLS_STATS)
+		memcpy(stats, &cls_flow.stats, sizeof(*stats));
+
 	return i;
 }
 
@@ -607,7 +611,7 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 {
 	return nf_flow_offload_tuple(offload->flowtable, offload->flow,
 				     flow_rule, dir, offload->priority,
-				     FLOW_CLS_REPLACE,
+				     FLOW_CLS_REPLACE, NULL,
 				     &offload->flowtable->flow_block.cb_list);
 }
 
@@ -615,7 +619,7 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 				   enum flow_offload_tuple_dir dir)
 {
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
-			      offload->priority, FLOW_CLS_DESTROY,
+			      offload->priority, FLOW_CLS_DESTROY, NULL,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
@@ -661,21 +665,9 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
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
-	mutex_lock(&flowtable->flow_block_lock);
-	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
-	mutex_unlock(&flowtable->flow_block_lock);
-	memcpy(stats, &cls_flow.stats, sizeof(*stats));
+	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
+			      offload->priority, FLOW_CLS_STATS, stats,
+			      &offload->flowtable->flow_block.cb_list);
 }
 
 static void flow_offload_work_stats(struct flow_offload_work *offload)
-- 
2.11.0

