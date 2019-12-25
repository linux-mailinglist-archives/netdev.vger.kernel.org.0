Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F412A718
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 10:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLYJsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 04:48:37 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26274 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfLYJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 04:48:30 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 80E554198B;
        Wed, 25 Dec 2019 17:48:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, jiri@mellanox.com
Subject: [PATCH net-next 2/5] netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup to support indir setup
Date:   Wed, 25 Dec 2019 17:48:20 +0800
Message-Id: <1577267303-24780-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlOQkJCQk5KSE1JTUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAg6UQw*Ezg9KUIPMBUVMhQD
        MwwKCzpVSlVKTkxMSU1MSEtOSkNKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNT0k3Bg++
X-HM-Tid: 0a6f3c75186b2086kuqy80e554198b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nf_flow_table_offload_setup to support indir setup in
the next patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index de7a0d1..89eb1a5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -808,26 +808,31 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	return err;
 }
 
-int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
-				struct net_device *dev,
-				enum flow_block_command cmd)
+static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
+					     struct net *net,
+					     enum flow_block_command cmd,
+					     struct nf_flowtable *flowtable,
+					     struct netlink_ext_ack *extack)
+{
+	memset(bo, 0, sizeof(*bo));
+	bo->net		= net;
+	bo->block	= &flowtable->flow_block;
+	bo->command	= cmd;
+	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo->extack	= extack;
+	INIT_LIST_HEAD(&bo->cb_list);
+}
+
+static int nf_flow_table_offload_cmd(struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd)
 {
 	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo = {};
+	struct flow_block_offload bo;
 	int err;
 
-	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
-		return 0;
-
-	if (!dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
-	bo.net		= dev_net(dev);
-	bo.block	= &flowtable->flow_block;
-	bo.command	= cmd;
-	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack	= &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
+	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
+					 &extack);
 
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, &bo);
 	if (err < 0)
@@ -835,6 +840,23 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 
 	return nf_flow_table_block_setup(flowtable, &bo, cmd);
 }
+
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	int err;
+
+	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+		return 0;
+
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = nf_flow_table_offload_cmd(flowtable, dev, cmd);
+	else
+		err = -EOPNOTSUPP;
+
+	return err;
+}
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
 int nf_flow_table_offload_init(void)
-- 
1.8.3.1

