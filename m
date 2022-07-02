Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9A3564253
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiGBTEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiGBTEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0613E094
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1689761003
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4E7C341C8;
        Sat,  2 Jul 2022 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788669;
        bh=zu7Q87nbdIcfllHcxdWIccKGfSqrdogooFyQFrQMKZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atn+0ZfRMjVRNYwQGxg96S8kXDN1q172xnuvRXy109cMa/t2SsVl/IPMWLCLKPY7a
         gTTShaxFwvFdAed+j82vw+yOHMpYoe/YtbpwXQI0GLQ7fYTgmBhxnZvTR+BkoIYJI+
         vm8lDXHIGDdvvK+US7ep5wTivHlnoTxoNuUacjonScBhIL2Ic2KDR0DTEUD3/zI90X
         F2jDbsPugXeOcUuZlrExldYq5PZQI1zIPb4sTE88iabGZgS9JuCF/QyR/SkkWO+93M
         zANCCdJHtN8vfyLqrYOE+7yWcvYJJ7b2/KEi3JU7kdTa8WFOv5ViwGLve1mXlkEan+
         nEGTJRCWkYYKA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next v2 09/15] net/mlx5e: Prepare for flow meter offload if hardware supports it
Date:   Sat,  2 Jul 2022 12:02:07 -0700
Message-Id: <20220702190213.80858-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

If flow meter aso object is supported, set the allocated range, and
initialize aso wqe.

The allocated range is indicated by log_meter_aso_granularity in HW
capabilities, and currently is 6.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 81 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h | 16 ++++
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 25 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 7 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a3381354a07d..1553d94ba3d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,7 +45,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
-					en/tc/post_act.o en/tc/int_port.o
+					en/tc/post_act.o en/tc/int_port.o en/tc/meter.o
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
new file mode 100644
index 000000000000..1643530ed8f4
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "lib/aso.h"
+#include "en/tc/post_act.h"
+#include "meter.h"
+
+struct mlx5e_flow_meters {
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5_aso *aso;
+	struct mutex aso_lock; /* Protects aso operations */
+	int log_granularity;
+	u32 pdn;
+
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_post_act *post_act;
+};
+
+struct mlx5e_flow_meters *
+mlx5e_flow_meters_init(struct mlx5e_priv *priv,
+		       enum mlx5_flow_namespace_type ns_type,
+		       struct mlx5e_post_act *post_act)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_flow_meters *flow_meters;
+	int err;
+
+	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
+	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (IS_ERR_OR_NULL(post_act)) {
+		netdev_dbg(priv->netdev,
+			   "flow meter offload is not supported, post action is missing\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	flow_meters = kzalloc(sizeof(*flow_meters), GFP_KERNEL);
+	if (!flow_meters)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5_core_alloc_pd(mdev, &flow_meters->pdn);
+	if (err) {
+		mlx5_core_err(mdev, "Failed to alloc pd for flow meter aso, err=%d\n", err);
+		goto err_out;
+	}
+
+	flow_meters->aso = mlx5_aso_create(mdev, flow_meters->pdn);
+	if (IS_ERR(flow_meters->aso)) {
+		mlx5_core_warn(mdev, "Failed to create aso wqe for flow meter\n");
+		err = PTR_ERR(flow_meters->aso);
+		goto err_sq;
+	}
+
+	flow_meters->ns_type = ns_type;
+	flow_meters->mdev = mdev;
+	flow_meters->post_act = post_act;
+	mutex_init(&flow_meters->aso_lock);
+	flow_meters->log_granularity = min_t(int, 6,
+					     MLX5_CAP_QOS(mdev, log_meter_aso_max_alloc));
+
+	return flow_meters;
+
+err_sq:
+	mlx5_core_dealloc_pd(mdev, flow_meters->pdn);
+err_out:
+	kfree(flow_meters);
+	return ERR_PTR(err);
+}
+
+void
+mlx5e_flow_meters_cleanup(struct mlx5e_flow_meters *flow_meters)
+{
+	if (IS_ERR_OR_NULL(flow_meters))
+		return;
+
+	mlx5_aso_destroy(flow_meters->aso);
+	mlx5_core_dealloc_pd(flow_meters->mdev, flow_meters->pdn);
+
+	kfree(flow_meters);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
new file mode 100644
index 000000000000..53dc6c840ffc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_FLOW_METER_H__
+#define __MLX5_EN_FLOW_METER_H__
+
+struct mlx5e_flow_meters;
+
+struct mlx5e_flow_meters *
+mlx5e_flow_meters_init(struct mlx5e_priv *priv,
+		       enum mlx5_flow_namespace_type ns_type,
+		       struct mlx5e_post_act *post_action);
+void
+mlx5e_flow_meters_cleanup(struct mlx5e_flow_meters *flow_meters);
+
+#endif /* __MLX5_EN_FLOW_METER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 3b74a6fd5c43..bb7a6549cd66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -203,6 +203,8 @@ struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow);
 struct mlx5e_tc_int_port_priv *
 mlx5e_get_int_port_priv(struct mlx5e_priv *priv);
 
+struct mlx5e_flow_meters *mlx5e_get_flow_meters(struct mlx5_core_dev *dev);
+
 void *mlx5e_get_match_headers_value(u32 flags, struct mlx5_flow_spec *spec);
 void *mlx5e_get_match_headers_criteria(u32 flags, struct mlx5_flow_spec *spec);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index adf5cc6a7b8c..dec183ccd4ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -62,6 +62,7 @@ struct mlx5_tc_int_port_priv;
 struct mlx5e_rep_bond;
 struct mlx5e_tc_tun_encap;
 struct mlx5e_post_act;
+struct mlx5e_flow_meters;
 
 struct mlx5_rep_uplink_priv {
 	/* indirect block callbacks are invoked on bind/unbind events
@@ -97,6 +98,8 @@ struct mlx5_rep_uplink_priv {
 
 	/* OVS internal port support */
 	struct mlx5e_tc_int_port_priv *int_port_priv;
+
+	struct mlx5e_flow_meters *flow_meters;
 };
 
 struct mlx5e_rep_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 34bf11cdf90f..31b59f6b3f4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -240,6 +240,30 @@ mlx5e_get_int_port_priv(struct mlx5e_priv *priv)
 	return NULL;
 }
 
+struct mlx5e_flow_meters *
+mlx5e_get_flow_meters(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5e_priv *priv;
+
+	if (is_mdev_switchdev_mode(dev)) {
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+		priv = netdev_priv(uplink_rpriv->netdev);
+		if (!uplink_priv->flow_meters)
+			uplink_priv->flow_meters =
+				mlx5e_flow_meters_init(priv,
+						       MLX5_FLOW_NAMESPACE_FDB,
+						       uplink_priv->post_act);
+		if (!IS_ERR(uplink_priv->flow_meters))
+			return uplink_priv->flow_meters;
+	}
+
+	return NULL;
+}
+
 static struct mlx5_tc_ct_priv *
 get_ct_priv(struct mlx5e_priv *priv)
 {
@@ -4956,6 +4980,7 @@ void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
 	mlx5e_tc_int_port_cleanup(uplink_priv->int_port_priv);
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
+	mlx5e_flow_meters_cleanup(uplink_priv->flow_meters);
 	mlx5e_tc_post_act_destroy(uplink_priv->post_act);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index e2a1250aeca1..140b01d4d083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -39,6 +39,7 @@
 #include "en/tc_ct.h"
 #include "en/tc_tun.h"
 #include "en/tc/int_port.h"
+#include "en/tc/meter.h"
 #include "en_rep.h"
 
 #define MLX5E_TC_FLOW_ID_MASK 0x0000ffff
-- 
2.36.1

