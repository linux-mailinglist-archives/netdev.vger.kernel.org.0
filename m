Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897546268D6
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiKLKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiKLKWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB9C2B605
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28EA7B8075F
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA091C433D6;
        Sat, 12 Nov 2022 10:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248527;
        bh=z36lnbI3Tro45K4U10mwJv95+dphlso8nX69kKeXafo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsGberLGYDWg1zf8um+xB6fRiIvY6tSHnvLOzQJKf0TwnKiHttXr4oUa2K1At/HRR
         YyL9LlH6S6bLtH5O1Of9NPpK5eZ9xe5ZmSzJSRBco0mO4BusAej3SvoAXPBAxr/dlN
         MGsSxcBOkgPtUG9uENmqMm94YOIpswsW9m/TB8cY6nVGhYat64g4qPLnr3trbhmgmf
         CSDKj2pHqLgAaNbw5dTMGSA5HDcBh6CJu9zxKQZ59/m9pqZROAwi511CyssNiGvlJL
         gB0zSpOh240FFDau5S92SvyeqF223JHNoK8EHegCMuoi/Mk8b58YLangLeOoEx4a3C
         Uv+2CR4J+QInQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: ethtool: get_link_ext_stats for PHY down events
Date:   Sat, 12 Nov 2022 02:21:47 -0800
Message-Id: <20221112102147.496378-16-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Implement ethtool_op get_link_ext_stats for PHY down events

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c    |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_stats.c  | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_stats.h  |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 24aa25da482b..d9397ffb396b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2463,4 +2463,5 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_eth_mac_stats = mlx5e_get_eth_mac_stats,
 	.get_eth_ctrl_stats = mlx5e_get_eth_ctrl_stats,
 	.get_rmon_stats    = mlx5e_get_rmon_stats,
+	.get_link_ext_stats = mlx5e_get_link_ext_stats
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 03c1841970f1..70c4ea3841d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1241,6 +1241,23 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
+void mlx5e_get_link_ext_stats(struct net_device *dev,
+			      struct ethtool_link_ext_stats *stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
+	mlx5_core_access_reg(priv->mdev, in, sz, out,
+			     MLX5_ST_SZ_BYTES(ppcnt_reg), MLX5_REG_PPCNT, 0, 0);
+
+	stats->link_down_events = MLX5_GET(ppcnt_reg, out,
+					   counter_set.phys_layer_cntrs.link_down_events);
+}
+
 static int fec_num_lanes(struct mlx5_core_dev *dev)
 {
 	u32 out[MLX5_ST_SZ_DW(pmlp_reg)] = {};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9f781085be47..cbc831ca646b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -126,6 +126,8 @@ void mlx5e_stats_eth_ctrl_get(struct mlx5e_priv *priv,
 void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
 			  struct ethtool_rmon_stats *rmon,
 			  const struct ethtool_rmon_hist_range **ranges);
+void mlx5e_get_link_ext_stats(struct net_device *dev,
+			      struct ethtool_link_ext_stats *stats);
 
 /* Concrete NIC Stats */
 
-- 
2.38.1

