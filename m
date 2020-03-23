Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1CA1901F3
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCWXe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:34:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38496 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCWXe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:34:29 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 80CE941861;
        Tue, 24 Mar 2020 07:34:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next v2] netfilter: Fix incorrect tc_setup_type type for flowtable offload
Date:   Tue, 24 Mar 2020 07:34:25 +0800
Message-Id: <1585006465-27664-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTkJCQkJDT0xPSklKSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MD46LQw5Sjg2PBMaGTU1AT4e
        FxcaClZVSlVKTkNOS0tNT01OTkxNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JSEo3Bg++
X-HM-Tid: 0a7109bf52002086kuqy80ce941861
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Flowtable offload setup flow_offlod_block in TC_SETP_FT. The indr block
offload of flowtable also should setup in TC_SETUP_FT.
But flow_indr_block_call always sets the tc_set_up_type as TC_SETUP_BLOCK.
So function flow_indr_block_call should expose a parameters to set
the tc_setup_type for each offload subsystem.

Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: modify the comments

 include/net/flow_offload.h            | 3 ++-
 net/core/flow_offload.c               | 6 +++---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 net/netfilter/nf_tables_offload.c     | 2 +-
 net/sched/cls_api.c                   | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 51b9893..7e4e089 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -522,6 +522,7 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 
 void flow_indr_block_call(struct net_device *dev,
 			  struct flow_block_offload *bo,
-			  enum flow_block_command command);
+			  enum flow_block_command command,
+			  enum tc_setup_type type);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 7440e61..e951b74 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -511,7 +511,8 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 
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
index ad54931..cd5bd23 100644
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
index 2bb2848..954bccb 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -313,7 +313,7 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
 
-	flow_indr_block_call(dev, &bo, cmd);
+	flow_indr_block_call(dev, &bo, cmd, TC_SETUP_BLOCK);
 
 	if (list_empty(&bo.cb_list))
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index fb6c366..bf4dd4d 100644
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
1.8.3.1

