Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24CFF198429
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgC3TWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:21 -0400
Received: from correo.us.es ([193.147.175.20]:48590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbgC3TWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 813341022B0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BDD4100A4B
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64D7E100A45; Mon, 30 Mar 2020 21:21:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BDE4100A63;
        Mon, 30 Mar 2020 21:21:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 454F042EF4E1;
        Mon, 30 Mar 2020 21:21:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/28] netfilter: flowtable: Fix incorrect tc_setup_type type
Date:   Mon, 30 Mar 2020 21:21:21 +0200
Message-Id: <20200330192136.230459-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The indirect block setup should use TC_SETUP_FT as the type instead of
TC_SETUP_BLOCK. Adjust existing users of the indirect flow block
infrastructure.

Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h            | 3 ++-
 net/core/flow_offload.c               | 6 +++---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 net/netfilter/nf_tables_offload.c     | 2 +-
 net/sched/cls_api.c                   | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1e30b0d44b61..1afb6bd4530d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -520,6 +520,7 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 
 void flow_indr_block_call(struct net_device *dev,
 			  struct flow_block_offload *bo,
-			  enum flow_block_command command);
+			  enum flow_block_command command,
+			  enum tc_setup_type type);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 7440e6117c81..e951b743bed3 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -511,7 +511,8 @@ EXPORT_SYMBOL_GPL(flow_indr_block_cb_unregister);
 
 void flow_indr_block_call(struct net_device *dev,
 			  struct flow_block_offload *bo,
-			  enum flow_block_command command)
+			  enum flow_block_command command,
+			  enum tc_setup_type type)
 {
 	struct flow_indr_block_cb *indr_block_cb;
 	struct flow_indr_block_dev *indr_dev;
@@ -521,8 +522,7 @@ void flow_indr_block_call(struct net_device *dev,
 		return;
 
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-				  bo);
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, type, bo);
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a68136a8d750..0c6437fab4fe 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -938,7 +938,7 @@ static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 {
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
-	flow_indr_block_call(dev, bo, cmd);
+	flow_indr_block_call(dev, bo, cmd, TC_SETUP_FT);
 
 	if (list_empty(&bo->cb_list))
 		return -EOPNOTSUPP;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2bb28483af22..954bccb7f32a 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -313,7 +313,7 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
 
-	flow_indr_block_call(dev, &bo, cmd);
+	flow_indr_block_call(dev, &bo, cmd, TC_SETUP_BLOCK);
 
 	if (list_empty(&bo.cb_list))
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index eefacb3176e3..84f8ee6f2009 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -708,7 +708,7 @@ static void tc_indr_block_call(struct tcf_block *block,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	flow_indr_block_call(dev, &bo, command);
+	flow_indr_block_call(dev, &bo, command, TC_SETUP_BLOCK);
 	tcf_block_setup(block, &bo);
 }
 
-- 
2.11.0

