Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BA27BB42
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfGaIMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:12:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50527 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfGaIMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:12:38 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9228641A12;
        Wed, 31 Jul 2019 16:12:34 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] cls_api: modify the tc_indr_block_ing_cmd parameters.
Date:   Wed, 31 Jul 2019 16:12:28 +0800
Message-Id: <1564560753-32603-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564560753-32603-1-git-send-email-wenxu@ucloud.cn>
References: <1564560753-32603-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pk06KQw6KDgzDEgKFghKHjA5
        OCMwCxNVSlVKTk1PTk1LTE5PTEtIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPSkw3Bg++
X-HM-Tid: 0a6c471687c32086kuqy9228641a12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch make tc_indr_block_ing_cmd can't access struct
tc_indr_block_dev and tc_indr_block_cb.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_api.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3565d9a..2e3b58d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -677,26 +677,28 @@ static void tc_indr_block_cb_del(struct tc_indr_block_cb *indr_block_cb)
 static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
-static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
-				  struct tc_indr_block_cb *indr_block_cb,
+static void tc_indr_block_ing_cmd(struct net_device *dev,
+				  struct tcf_block *block,
+				  tc_indr_block_bind_cb_t *cb,
+				  void *cb_priv,
 				  enum flow_block_command command)
 {
 	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-		.net		= dev_net(indr_dev->dev),
-		.block_shared	= tcf_block_non_null_shared(indr_dev->block),
+		.net		= dev_net(dev),
+		.block_shared	= tcf_block_non_null_shared(block),
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	if (!indr_dev->block)
+	if (!block)
 		return;
 
-	bo.block = &indr_dev->block->flow_block;
+	bo.block = &block->flow_block;
 
-	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-			  &bo);
-	tcf_block_setup(indr_dev->block, &bo);
+	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
+
+	tcf_block_setup(block, &bo);
 }
 
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -715,7 +717,8 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_BIND);
+	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, cb_priv,
+			      FLOW_BLOCK_BIND);
 	return 0;
 
 err_dev_put:
@@ -752,7 +755,8 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 		return;
 
 	/* Send unbind message if required to free any block cbs. */
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_UNBIND);
+	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, indr_block_cb->cb_priv,
+			      FLOW_BLOCK_UNBIND);
 	tc_indr_block_cb_del(indr_block_cb);
 	tc_indr_block_dev_put(indr_dev);
 }
-- 
1.8.3.1

