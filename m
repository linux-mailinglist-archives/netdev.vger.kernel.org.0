Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD15B107F
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiIGXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiIGXhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE01956AF;
        Wed,  7 Sep 2022 16:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB0861AEF;
        Wed,  7 Sep 2022 23:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE644C43470;
        Wed,  7 Sep 2022 23:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593833;
        bh=q+fcQngiIAA8ENhOsYYGw2CaYPV4YU9SKwPJvCPk6Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5LyV49FW1lLiCXSDLRHYLumI5LoCmmT/JRbPm6fval52wUkS8xzWbztjq8ly0wHr
         6ixyRfBz92gYvIpCLKHbobg6MIeRFs/sVEYLGag6E/5WTSGTGqqvQN4NdpuCbdbjOA
         UEQQQH7I3S8dVdCe6wExua2lgBttv5w9oBQ99fO5fphvfuONe3oZwNNGfLMoaPGvh9
         1fTYJRgCxvDC07Jg0kJzvT7NVqYqeaxWhYxtPpMSYMUgFmhKAJw1zHxvZb2euGgdjG
         CxRVFes1ScqQUV1UadDsGhGabzvul08E9UgoZ7n+oHScYhAUnLqYgj2ghRXmRZWBhw
         x/Hu1ZkgWzM5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 05/14] net/mlx5: Lag, set active ports if support bypass port select flow table
Date:   Wed,  7 Sep 2022 16:36:27 -0700
Message-Id: <20220907233636.388475-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Liu, Changcheng" <jerrliu@nvidia.com>

active_port bit mask indicates the current active ports. Set bit indicates
the port is active. Update active ports info to FW to redirect the QP/TIS
from inactive ports to other ports.

Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 58 ++++++++++++++++++-
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 26c7f72403eb..d4d4d1d1e8c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -65,6 +65,21 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
+static u8 lag_active_port_bits(struct mlx5_lag *ldev)
+{
+	u8 enabled_ports[MLX5_MAX_PORTS] = {};
+	u8 active_port = 0;
+	int num_enabled;
+	int idx;
+
+	mlx5_infer_tx_enabled(&ldev->tracker, ldev->ports, enabled_ports,
+			      &num_enabled);
+	for (idx = 0; idx < num_enabled; idx++)
+		active_port |= BIT_MASK(enabled_ports[idx]);
+
+	return active_port;
+}
+
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
 			       unsigned long flags)
 {
@@ -77,9 +92,21 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
 	lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, fdb_sel_mode);
-	if (port_sel_mode == MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY) {
+
+	switch (port_sel_mode) {
+	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY:
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
+		break;
+	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT:
+		if (!MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass))
+			break;
+
+		MLX5_SET(lagc, lag_ctx, active_port,
+			 lag_active_port_bits(mlx5_lag_dev(dev)));
+		break;
+	default:
+		break;
 	}
 	MLX5_SET(lagc, lag_ctx, port_select_mode, port_sel_mode);
 
@@ -386,12 +413,37 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 	}
 }
 
+static int mlx5_cmd_modify_active_port(struct mlx5_core_dev *dev, u8 ports)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_lag_in)] = {};
+	void *lag_ctx;
+
+	lag_ctx = MLX5_ADDR_OF(modify_lag_in, in, ctx);
+
+	MLX5_SET(modify_lag_in, in, opcode, MLX5_CMD_OP_MODIFY_LAG);
+	MLX5_SET(modify_lag_in, in, field_select, 0x2);
+
+	MLX5_SET(lagc, lag_ctx, active_port, ports);
+
+	return mlx5_cmd_exec_in(dev, modify_lag, in);
+}
+
 static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	u8 active_ports;
+	int ret;
 
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags))
-		return mlx5_lag_port_sel_modify(ldev, ports);
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags)) {
+		ret = mlx5_lag_port_sel_modify(ldev, ports);
+		if (ret ||
+		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
+			return ret;
+
+		active_ports = lag_active_port_bits(ldev);
+
+		return mlx5_cmd_modify_active_port(dev0, active_ports);
+	}
 	return mlx5_cmd_modify_lag(dev0, ldev->ports, ports);
 }
 
-- 
2.37.2

