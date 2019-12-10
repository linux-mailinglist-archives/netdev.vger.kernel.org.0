Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA84711846E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLJKIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:08:50 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:24953 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfLJKIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:08:49 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E13004182D;
        Tue, 10 Dec 2019 18:08:45 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     pablo@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net/mlx5e: refactor indr setup block
Date:   Tue, 10 Dec 2019 18:08:44 +0800
Message-Id: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNSkpLS0tLTUpLSE5KTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBw6Qjo4PjgxVkkhTi4WIlYS
        CilPCyNVSlVKTkxOQkxJTklNS0lDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5JSUI3Bg++
X-HM-Tid: 0a6eef4857722086kuqye13004182d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor indr setup block for support ft indr setup in the
next patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 42 ++++++++++++------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb2..6f304f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -710,9 +710,9 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
 static int
 mlx5e_rep_indr_offload(struct net_device *netdev,
 		       struct flow_cls_offload *flower,
-		       struct mlx5e_rep_indr_block_priv *indr_priv)
+		       struct mlx5e_rep_indr_block_priv *indr_priv,
+		       unsigned long flags)
 {
-	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
 	int err = 0;
 
@@ -733,20 +733,22 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
 	return err;
 }
 
-static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
-					 void *type_data, void *indr_priv)
+static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
 {
+	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
 
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv);
+		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
+					      flags);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
+static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
 
@@ -757,9 +759,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int
-mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
-			      struct mlx5e_rep_priv *rpriv,
-			      struct flow_block_offload *f)
+mlx5e_rep_indr_setup_block(struct net_device *netdev,
+			   struct mlx5e_rep_priv *rpriv,
+			   struct flow_block_offload *f,
+			   flow_setup_cb_t *setup_cb)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
@@ -785,9 +788,8 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(mlx5e_rep_indr_setup_block_cb,
-					       indr_priv, indr_priv,
-					       mlx5e_rep_indr_tc_block_unbind);
+		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
+					       mlx5e_rep_indr_block_unbind);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
@@ -802,9 +804,7 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f->block,
-						mlx5e_rep_indr_setup_block_cb,
-						indr_priv);
+		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
 		if (!block_cb)
 			return -ENOENT;
 
@@ -818,13 +818,13 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 }
 
 static
-int mlx5e_rep_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
-			       enum tc_setup_type type, void *type_data)
+int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
+			    enum tc_setup_type type, void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_indr_setup_tc_block(netdev, cb_priv,
-						      type_data);
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_tc_cb);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -836,7 +836,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 	int err;
 
 	err = __flow_indr_block_cb_register(netdev, rpriv,
-					    mlx5e_rep_indr_setup_tc_cb,
+					    mlx5e_rep_indr_setup_cb,
 					    rpriv);
 	if (err) {
 		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
@@ -850,7 +850,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
 					    struct net_device *netdev)
 {
-	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_tc_cb,
+	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
 					rpriv);
 }
 
-- 
1.8.3.1

