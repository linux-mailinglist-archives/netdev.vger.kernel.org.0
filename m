Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48011846D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfLJKIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:08:49 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:24971 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfLJKIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:08:49 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0D44F411A4;
        Tue, 10 Dec 2019 18:08:46 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     pablo@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
Date:   Tue, 10 Dec 2019 18:08:45 +0800
Message-Id: <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9PS0tLS05IT0tOTE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzI6Tio*CDg2PUktTi4QIgMK
        CR8KCxpVSlVKTkxOQkxJTklNSklPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCQkw3Bg++
X-HM-Tid: 0a6eef4857f82086kuqy0d44f411a4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
in FT mode.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 37 ++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6f304f6..e0da17c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -748,6 +748,40 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
 	}
 }
 
+static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+	struct mlx5e_priv *mpriv = netdev_priv(priv->rpriv->netdev);
+	struct mlx5_eswitch *esw = mpriv->mdev->priv.eswitch;
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload cls_flower;
+	unsigned long flags;
+	int err;
+
+	flags = MLX5_TC_FLAG(EGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
+			return -EOPNOTSUPP;
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 */
+		memcpy(&cls_flower, f, sizeof(*f));
+		cls_flower.common.chain_index = FDB_FT_CHAIN;
+		err = mlx5e_rep_indr_offload(priv->netdev, &cls_flower, priv,
+					     flags);
+		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
@@ -825,6 +859,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_tc_cb);
+	case TC_SETUP_FT:
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_ft_cb);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.1

