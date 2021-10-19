Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CB9432C33
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhJSDXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232025AbhJSDXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7345361355;
        Tue, 19 Oct 2021 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613653;
        bh=Gp9DlCJBfIASNs6LWpt4Yh2ZP5t5nxdMiWXyD4MR0Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxNx2u5IHRQZ8bdlermFccD1vH3KhEv+S4NOtkO9I70qZt0qEggSQcO8NqCIvLctS
         JWqHtmexhjzgohtakO/7nM22FX/0ZUjMG8Yi06Br86mZX+GwNqkX9VS64ubF4qipz7
         PjvB+8ffC+ywvA53Z+p2grBF/8Cpf5918TxPuPGmfa9Rl2Umc+kTwEa2zis5OoNDi0
         sqE+w8GjNqWvuykoFh9TgisKejHjg//eVk4Za+6WFyS1xBLCcpMxswIAQyqnCFgcxl
         1RpRXHgkLXZd+p2RbNMHtB0I2xt+abSkUro+xZbDOPHeflPMSPNhod1oYpuxdnFDRu
         3k5mMR10Pr+kA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/13] net/mlx5: Lag, add support to create TTC tables for LAG port selection
Date:   Mon, 18 Oct 2021 20:20:43 -0700
Message-Id: <20211019032047.55660-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add support to create inner and outer TTC tables for LAG port
selection. These tables are used to classify the packets in
order to select the related definer.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/lag/port_sel.c         | 91 +++++++++++++++++++
 .../mellanox/mlx5/core/lag/port_sel.h         |  1 +
 2 files changed, 92 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 06bc7c7dbb6d..a855b9e86791 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -5,6 +5,8 @@
 #include "lag.h"
 
 enum {
+	MLX5_LAG_FT_LEVEL_TTC,
+	MLX5_LAG_FT_LEVEL_INNER_TTC,
 	MLX5_LAG_FT_LEVEL_DEFINER,
 };
 
@@ -420,3 +422,92 @@ static void set_tt_map(struct mlx5_lag_port_sel *port_sel,
 		break;
 	}
 }
+
+#define SET_IGNORE_DESTS_BITS(tt_map, dests)				\
+	do {								\
+		int idx;						\
+									\
+		for_each_clear_bit(idx, tt_map, MLX5_NUM_TT)		\
+			set_bit(idx, dests);				\
+	} while (0)
+
+static void mlx5_lag_set_inner_ttc_params(struct mlx5_lag *ldev,
+					  struct ttc_params *ttc_params)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct mlx5_flow_table_attr *ft_attr;
+	int tt;
+
+	ttc_params->ns = mlx5_get_flow_namespace(dev,
+						 MLX5_FLOW_NAMESPACE_PORT_SEL);
+	ft_attr = &ttc_params->ft_attr;
+	ft_attr->level = MLX5_LAG_FT_LEVEL_INNER_TTC;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		ttc_params->dests[tt].type =
+			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		ttc_params->dests[tt].ft = port_sel->inner.definers[tt]->ft;
+	}
+	SET_IGNORE_DESTS_BITS(port_sel->tt_map, ttc_params->ignore_dests);
+}
+
+static void mlx5_lag_set_outer_ttc_params(struct mlx5_lag *ldev,
+					  struct ttc_params *ttc_params)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct mlx5_flow_table_attr *ft_attr;
+	int tt;
+
+	ttc_params->ns = mlx5_get_flow_namespace(dev,
+						 MLX5_FLOW_NAMESPACE_PORT_SEL);
+	ft_attr = &ttc_params->ft_attr;
+	ft_attr->level = MLX5_LAG_FT_LEVEL_TTC;
+
+	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
+		ttc_params->dests[tt].type =
+			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		ttc_params->dests[tt].ft = port_sel->outer.definers[tt]->ft;
+	}
+	SET_IGNORE_DESTS_BITS(port_sel->tt_map, ttc_params->ignore_dests);
+
+	ttc_params->inner_ttc = port_sel->tunnel;
+	if (!port_sel->tunnel)
+		return;
+
+	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
+		ttc_params->tunnel_dests[tt].type =
+			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		ttc_params->tunnel_dests[tt].ft =
+			mlx5_get_ttc_flow_table(port_sel->inner.ttc);
+	}
+}
+
+static int mlx5_lag_create_ttc_table(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct ttc_params ttc_params = {};
+
+	mlx5_lag_set_outer_ttc_params(ldev, &ttc_params);
+	port_sel->outer.ttc = mlx5_create_ttc_table(dev, &ttc_params);
+	if (IS_ERR(port_sel->outer.ttc))
+		return PTR_ERR(port_sel->outer.ttc);
+
+	return 0;
+}
+
+static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
+	struct ttc_params ttc_params = {};
+
+	mlx5_lag_set_inner_ttc_params(ldev, &ttc_params);
+	port_sel->inner.ttc = mlx5_create_ttc_table(dev, &ttc_params);
+	if (IS_ERR(port_sel->inner.ttc))
+		return PTR_ERR(port_sel->inner.ttc);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
index 1b9e2130a0a5..045dceec0fab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -14,6 +14,7 @@ struct mlx5_lag_definer {
 };
 
 struct mlx5_lag_ttc {
+	struct mlx5_ttc_table *ttc;
 	struct mlx5_lag_definer *definers[MLX5_NUM_TT];
 };
 
-- 
2.31.1

