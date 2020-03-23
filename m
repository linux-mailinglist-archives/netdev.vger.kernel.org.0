Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FD918F6E8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCWO2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:28:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:14039 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgCWO2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:28:50 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 72A06415BE;
        Mon, 23 Mar 2020 22:27:10 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     paulb@mellanox.com, vladbu@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
Date:   Mon, 23 Mar 2020 22:27:09 +0800
Message-Id: <1584973629-18728-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584973629-18728-1-git-send-email-wenxu@ucloud.cn>
References: <1584973629-18728-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0JNQkJCTE1PT09JT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pjo6Qio*CDgwMBMXGiwBPh4Z
        TQlPFCxVSlVKTkNPQkxITUhLTklOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPQkw3Bg++
X-HM-Tid: 0a7107ca4c192086kuqy72a06415be
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
in FT mode.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: rebase to the master
v3: fix reverse xmas tree style

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 52 ++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 057f5f9..30c81c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -732,6 +732,55 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
 	}
 }
 
+static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload tmp;
+	struct mlx5e_priv *mpriv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	mpriv = netdev_priv(priv->rpriv->netdev);
+	esw = mpriv->mdev->priv.eswitch;
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
@@ -809,6 +858,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
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

