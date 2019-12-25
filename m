Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6912A711
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 10:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfLYJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 04:48:29 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26272 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfLYJs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 04:48:28 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 550E641A6B;
        Wed, 25 Dec 2019 17:48:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, jiri@mellanox.com
Subject: [PATCH net-next 1/5] flow_offload: add TC_SETP_FT type in flow_indr_block_call
Date:   Wed, 25 Dec 2019 17:48:19 +0800
Message-Id: <1577267303-24780-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJOQkJCQkxCQkxJQ09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OEk6Sjo6Szg6MUISTxcJMgsu
        QwNPFBJVSlVKTkxMSU1MSEtPTktKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNT0g3Bg++
X-HM-Tid: 0a6f3c7517e22086kuqy550e641a6b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add TC_SETP_FT type in flow_indr_block_call for supporting indr block call
in nf_flow_table_offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/flow_offload.h        | 3 ++-
 net/core/flow_offload.c           | 6 +++---
 net/netfilter/nf_tables_offload.c | 2 +-
 net/sched/cls_api.c               | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd2..5cf9396 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -410,6 +410,7 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 
 void flow_indr_block_call(struct net_device *dev,
 			  struct flow_block_offload *bo,
-			  enum flow_block_command command);
+			  enum flow_block_command command,
+			  enum tc_setup_type type);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 45b6a59..c0d9223 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -483,7 +483,8 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 
 void flow_indr_block_call(struct net_device *dev,
 			  struct flow_block_offload *bo,
-			  enum flow_block_command command)
+			  enum flow_block_command command,
+			  enum tc_setup_type type)
 {
 	struct flow_indr_block_cb *indr_block_cb;
 	struct flow_indr_block_dev *indr_dev;
@@ -493,8 +494,7 @@ void flow_indr_block_call(struct net_device *dev,
 		return;
 
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-				  bo);
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, type, bo);
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index a9ea29a..a9e71b4 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -313,7 +313,7 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
 
-	flow_indr_block_call(dev, &bo, cmd);
+	flow_indr_block_call(dev, &bo, cmd, TC_SETUP_BLOCK);
 
 	if (list_empty(&bo.cb_list))
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6a0eaca..113be4d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -714,7 +714,7 @@ static void tc_indr_block_call(struct tcf_block *block,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	flow_indr_block_call(dev, &bo, command);
+	flow_indr_block_call(dev, &bo, command, TC_SETUP_BLOCK);
 	tcf_block_setup(block, &bo);
 }
 
-- 
1.8.3.1

