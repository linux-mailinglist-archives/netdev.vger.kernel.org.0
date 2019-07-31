Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFEC7BB41
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfGaIMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:12:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50627 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfGaIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:12:39 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 500D041A41;
        Wed, 31 Jul 2019 16:12:35 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/6] cls_api: add flow_indr_block_call function
Date:   Wed, 31 Jul 2019 16:12:30 +0800
Message-Id: <1564560753-32603-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564560753-32603-1-git-send-email-wenxu@ucloud.cn>
References: <1564560753-32603-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngg6Egw4ATg5TUgBPA8wHjMf
        NVYaCitVSlVKTk1PTk1LTE5OT05OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhLTUw3Bg++
X-HM-Tid: 0a6c47168aa22086kuqy500d041a41
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch make indr_block_call don't access struct tc_indr_block_cb
and tc_indr_block_dev directly

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_api.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index f9643fa..617b098 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -783,13 +783,30 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
+static void flow_indr_block_call(struct flow_block *flow_block,
+				 struct net_device *dev,
+				 struct flow_block_offload *bo,
+				 enum flow_block_command command)
+{
+	struct tc_indr_block_cb *indr_block_cb;
+	struct tc_indr_block_dev *indr_dev;
+
+	indr_dev = tc_indr_block_dev_lookup(dev);
+	if (!indr_dev)
+		return;
+
+	indr_dev->flow_block = command == FLOW_BLOCK_BIND ? flow_block : NULL;
+
+	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
+				  bo);
+}
+
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
 			       enum flow_block_command command,
 			       struct netlink_ext_ack *extack)
 {
-	struct tc_indr_block_cb *indr_block_cb;
-	struct tc_indr_block_dev *indr_dev;
 	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
@@ -800,17 +817,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	indr_dev = tc_indr_block_dev_lookup(dev);
-	if (!indr_dev)
-		return;
-
-	indr_dev->flow_block = command == FLOW_BLOCK_BIND ?
-					  &block->flow_block : NULL;
-
-	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-				  &bo);
-
+	flow_indr_block_call(&block->flow_block, dev, &bo, command);
 	tcf_block_setup(block, &bo);
 }
 
-- 
1.8.3.1

