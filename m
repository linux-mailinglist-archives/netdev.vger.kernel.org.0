Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FDC440479
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhJ2U7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhJ2U7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBBCD610CF;
        Fri, 29 Oct 2021 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541004;
        bh=M1ypQqrlMzu3phbqCXT+mBHYTtbKWdo6H5q2YXdDFLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQAiRK1pnI7/7UcEATT0CYLMt44UH/CQslhWxqs0GWfYRk/o0n21kdz9R3Xtfe7ta
         tfezPHpkYJ4lfLuEgmMAmShoc87G0rSupGkobpfHgOlP/X15Ee7X1MO4eeBxEu/2nY
         PSKepa5ME0gRcq9HCw3Xv5N0MehVROZBdthnZXeJ7ZPEivhk4D8tdaHfEMwqQ8SorQ
         y1nsdzIltCKINqPIVj7Ft4g3eOQ7e333N881328kSLrLmvF+ABRuCbTOcxTd4Niq8Y
         ZcyqN8/nM9H8p5TcukyCUaSWkHIWyXC5H6riH8LGGDdRi4rBSwAB2MNa9zPu3ezhoV
         kPyR2Yuhm6ifA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/14] net/mlx5: CT: Remove warning of ignore_flow_level support for VFs
Date:   Fri, 29 Oct 2021 13:56:20 -0700
Message-Id: <20211029205632.390403-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

ignore_flow_level isn't supported for VFs, and so it causes
post_act and ct to warn about it.

Instead of disabling CT for VFs, and a driver update will be need
to enable CT again once firmware support this, remove this warning
specifically for VFs. This way, it could be automatically enabled on
future firmwares where VFs support ignore_flow_level capability.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/post_act.c       | 13 ++++---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 34 ++++++++++++-------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index a3e43e898a56..31b4e39be2d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -4,6 +4,7 @@
 #include "en_tc.h"
 #include "post_act.h"
 #include "mlx5_core.h"
+#include "fs_core.h"
 
 struct mlx5e_post_act {
 	enum mlx5_flow_namespace_type ns_type;
@@ -28,16 +29,14 @@ struct mlx5e_post_act *
 mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 		       enum mlx5_flow_namespace_type ns_type)
 {
+	enum fs_flow_table_type table_type = ns_type == MLX5_FLOW_NAMESPACE_FDB ?
+					     FS_FT_FDB : FS_FT_NIC_RX;
 	struct mlx5e_post_act *post_act;
 	int err;
 
-	if (ns_type == MLX5_FLOW_NAMESPACE_FDB &&
-	    !MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, ignore_flow_level)) {
-		mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
-		err = -EOPNOTSUPP;
-		goto err_check;
-	} else if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
-		mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
+	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev, ignore_flow_level, table_type)) {
+		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+			mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
 		err = -EOPNOTSUPP;
 		goto err_check;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 740cd6f088b8..f44e5de25037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2039,25 +2039,36 @@ mlx5_tc_ct_init_check_esw_support(struct mlx5_eswitch *esw,
 static int
 mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 			      enum mlx5_flow_namespace_type ns_type,
-			      struct mlx5e_post_act *post_act,
-			      const char **err_msg)
+			      struct mlx5e_post_act *post_act)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	const char *err_msg = NULL;
+	int err = 0;
 
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	/* cannot restore chain ID on HW miss */
 
-	*err_msg = "tc skb extension missing";
-	return -EOPNOTSUPP;
+	err_msg = "tc skb extension missing";
+	err = -EOPNOTSUPP;
+	goto out_err;
 #endif
 	if (IS_ERR_OR_NULL(post_act)) {
-		*err_msg = "tc ct offload not supported, post action is missing";
-		return -EOPNOTSUPP;
+		/* Ignore_flow_level support isn't supported by default for VFs and so post_act
+		 * won't be supported. Skip showing error msg.
+		 */
+		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+			err_msg = "post action is missing";
+		err = -EOPNOTSUPP;
+		goto out_err;
 	}
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB)
-		return mlx5_tc_ct_init_check_esw_support(esw, err_msg);
-	return 0;
+		err = mlx5_tc_ct_init_check_esw_support(esw, &err_msg);
+
+out_err:
+	if (err && err_msg)
+		netdev_dbg(priv->netdev, "tc ct offload not supported, %s\n", err_msg);
+	return err;
 }
 
 #define INIT_ERR_PREFIX "tc ct offload init failed"
@@ -2070,16 +2081,13 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 {
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct mlx5_core_dev *dev;
-	const char *msg;
 	u64 mapping_id;
 	int err;
 
 	dev = priv->mdev;
-	err = mlx5_tc_ct_init_check_support(priv, ns_type, post_act, &msg);
-	if (err) {
-		mlx5_core_warn(dev, "tc ct offload not supported, %s\n", msg);
+	err = mlx5_tc_ct_init_check_support(priv, ns_type, post_act);
+	if (err)
 		goto err_support;
-	}
 
 	ct_priv = kzalloc(sizeof(*ct_priv), GFP_KERNEL);
 	if (!ct_priv)
-- 
2.31.1

