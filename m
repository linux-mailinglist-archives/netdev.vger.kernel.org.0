Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0241897F5
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgCRJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:32:54 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43922 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgCRJcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:32:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DB83542026;
        Wed, 18 Mar 2020 17:32:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com, paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
Date:   Wed, 18 Mar 2020 17:32:39 +0800
Message-Id: <1584523959-6587-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
References: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9KS0tLS0hJT0lPQkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBg6Pgw5OTg6MBw#KhhNGBQN
        USlPCQlVSlVKTkNPTklIQk1LS0tPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhIQ0I3Bg++
X-HM-Tid: 0a70ecfcde6f2086kuqydb83542026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
in FT mode.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: rebase to master

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 057f5f9..a88c70b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -732,6 +732,52 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
 	}
 }
 
+static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+	struct mlx5e_priv *mpriv = netdev_priv(priv->rpriv->netdev);
+	struct mlx5_eswitch *esw = mpriv->mdev->priv.eswitch;
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload tmp;
+	unsigned long flags;
+	int err;
+
+	flags = MLX5_TC_FLAG(EGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		memcpy(&tmp, f, sizeof(*f));
+
+		if (!mlx5_esw_chains_prios_supported(esw))
+			return -EOPNOTSUPP;
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 *
+		 * FT offload can use prio range [0, INT_MAX], so we normalize
+		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
+		 * as with tc, where prio 0 isn't supported.
+		 *
+		 * We only support chain 0 of FT offload.
+		 */
+		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
+			return -EOPNOTSUPP;
+		if (tmp.common.chain_index != 0)
+			return -EOPNOTSUPP;
+
+		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.prio++;
+		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
+		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
@@ -809,6 +855,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
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

