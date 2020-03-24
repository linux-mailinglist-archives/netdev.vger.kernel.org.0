Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD819137F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCXOob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:44:31 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:63671 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgCXOob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:44:31 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DFDFD41630;
        Tue, 24 Mar 2020 22:44:20 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     paulb@mellanox.com, vladbu@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH net-next v6 1/2] net/mlx5e: refactor indr setup block
Date:   Tue, 24 Mar 2020 22:44:18 +0800
Message-Id: <1585061059-6591-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585061059-6591-1-git-send-email-wenxu@ucloud.cn>
References: <1585061059-6591-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0pJS0tLS0NIQklISE9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PVE6TAw4Qjg5MBIoEjoaSB0Y
        QzEaFC9VSlVKTkNOS01KS01KS0pMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5DSU43Bg++
X-HM-Tid: 0a710d0061422086kuqydfdfd41630
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor indr setup block for support ft indr setup in the
next patch. IThe function mlx5e_rep_indr_offload exposes
'flags' in order set additional flag for FT in next patch.
Rename mlx5e_rep_indr_setup_tc_block to mlx5e_rep_indr_setup_block
and add flow_setup_cb_t callback parameters in order set the
specific callback for FT in next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: change the comments
v6: no change

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 42 ++++++++++++------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a33d151..057f5f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -694,9 +694,9 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
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
 
@@ -717,20 +717,22 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
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
 
@@ -741,9 +743,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
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
@@ -769,9 +772,8 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
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
@@ -786,9 +788,7 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f->block,
-						mlx5e_rep_indr_setup_block_cb,
-						indr_priv);
+		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
 		if (!block_cb)
 			return -ENOENT;
 
@@ -802,13 +802,13 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
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
@@ -820,7 +820,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 	int err;
 
 	err = __flow_indr_block_cb_register(netdev, rpriv,
-					    mlx5e_rep_indr_setup_tc_cb,
+					    mlx5e_rep_indr_setup_cb,
 					    rpriv);
 	if (err) {
 		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
@@ -834,7 +834,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
 static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
 					    struct net_device *netdev)
 {
-	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_tc_cb,
+	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
 					rpriv);
 }
 
-- 
1.8.3.1

