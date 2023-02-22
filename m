Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A694969FC4B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjBVTgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBVTgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886A33E0BF
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04AFCB816A2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 19:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD45C4339E;
        Wed, 22 Feb 2023 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677094564;
        bh=oj2VOhmrIrdfJQQubWRnS0m0+bnGFLtazPGgKIrRMh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNPLxH0gAWyU5mdXJ/p4KD3cNuAje1Th3A7S7OtBYkRbFEOCgxsYF7PSq4VedbzeZ
         5WX9lCKbDwCPP49PvoIXeNLym/k6NqBmukOebZlNRjpFwGAcqdWZNf9Vtxh1d3dpck
         aum8TpSaroAxz/ZBAEyA9OJZ3CQw1GmJ05VKngkuWWv/g/mqgMXoWsvcv3xH/kyfcH
         AFI3Ne4wQP+BvNVHdqjGuJgbQBWLlHVBN6XUP/vF8z2/tOseLXpknkWvKHc7K0HoK7
         AL93Xprffdujfldv9XaMfG27TgXXYIXA3GcKLOnW3vkuqHTIgSvXlSUdwlc5gYr7NS
         gAMsgAsXAezmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Move needed PTYS functions to core layer
Date:   Wed, 22 Feb 2023 11:35:46 -0800
Message-Id: <20230222193548.502031-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222193548.502031-1-saeed@kernel.org>
References: <20230222193548.502031-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Downstream patches require devlink params to access the PTYS register,
move the needed functions from mlx5e to the core layer.

Issue: 3222646
Signed-off-by: Gal Pressman <gal@nvidia.com>
Change-Id: Iffeeb77186d141c38176327b4376a57cfc00c6e2
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 157 +-----------------
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  14 --
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/port.c    | 151 +++++++++++++++++
 include/linux/mlx5/port.h                     |  16 ++
 8 files changed, 179 insertions(+), 177 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index a21bd1179477..561da78d3b5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -553,7 +553,7 @@ bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
 	u32 link_speed = 0;
 	u32 pci_bw = 0;
 
-	mlx5e_port_max_linkspeed(mdev, &link_speed);
+	mlx5_port_max_linkspeed(mdev, &link_speed);
 	pci_bw = pcie_bandwidth_available(mdev->pdev, NULL, NULL, NULL);
 	mlx5_core_dbg_once(mdev, "Max link speed = %d, PCI BW = %d\n",
 			   link_speed, pci_bw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 505ba41195b9..dbe2b19a9570 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -32,101 +32,6 @@
 
 #include "port.h"
 
-/* speed in units of 1Mb */
-static const u32 mlx5e_link_speed[MLX5E_LINK_MODES_NUMBER] = {
-	[MLX5E_1000BASE_CX_SGMII] = 1000,
-	[MLX5E_1000BASE_KX]       = 1000,
-	[MLX5E_10GBASE_CX4]       = 10000,
-	[MLX5E_10GBASE_KX4]       = 10000,
-	[MLX5E_10GBASE_KR]        = 10000,
-	[MLX5E_20GBASE_KR2]       = 20000,
-	[MLX5E_40GBASE_CR4]       = 40000,
-	[MLX5E_40GBASE_KR4]       = 40000,
-	[MLX5E_56GBASE_R4]        = 56000,
-	[MLX5E_10GBASE_CR]        = 10000,
-	[MLX5E_10GBASE_SR]        = 10000,
-	[MLX5E_10GBASE_ER]        = 10000,
-	[MLX5E_40GBASE_SR4]       = 40000,
-	[MLX5E_40GBASE_LR4]       = 40000,
-	[MLX5E_50GBASE_SR2]       = 50000,
-	[MLX5E_100GBASE_CR4]      = 100000,
-	[MLX5E_100GBASE_SR4]      = 100000,
-	[MLX5E_100GBASE_KR4]      = 100000,
-	[MLX5E_100GBASE_LR4]      = 100000,
-	[MLX5E_100BASE_TX]        = 100,
-	[MLX5E_1000BASE_T]        = 1000,
-	[MLX5E_10GBASE_T]         = 10000,
-	[MLX5E_25GBASE_CR]        = 25000,
-	[MLX5E_25GBASE_KR]        = 25000,
-	[MLX5E_25GBASE_SR]        = 25000,
-	[MLX5E_50GBASE_CR2]       = 50000,
-	[MLX5E_50GBASE_KR2]       = 50000,
-};
-
-static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
-	[MLX5E_SGMII_100M]			= 100,
-	[MLX5E_1000BASE_X_SGMII]		= 1000,
-	[MLX5E_5GBASE_R]			= 5000,
-	[MLX5E_10GBASE_XFI_XAUI_1]		= 10000,
-	[MLX5E_40GBASE_XLAUI_4_XLPPI_4]		= 40000,
-	[MLX5E_25GAUI_1_25GBASE_CR_KR]		= 25000,
-	[MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2]	= 50000,
-	[MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR]	= 50000,
-	[MLX5E_CAUI_4_100GBASE_CR4_KR4]		= 100000,
-	[MLX5E_100GAUI_2_100GBASE_CR2_KR2]	= 100000,
-	[MLX5E_200GAUI_4_200GBASE_CR4_KR4]	= 200000,
-	[MLX5E_400GAUI_8]			= 400000,
-	[MLX5E_100GAUI_1_100GBASE_CR_KR]	= 100000,
-	[MLX5E_200GAUI_2_200GBASE_CR2_KR2]	= 200000,
-	[MLX5E_400GAUI_4_400GBASE_CR4_KR4]	= 400000,
-};
-
-bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev)
-{
-	struct mlx5e_port_eth_proto eproto;
-	int err;
-
-	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet))
-		return true;
-
-	err = mlx5_port_query_eth_proto(mdev, 1, true, &eproto);
-	if (err)
-		return false;
-
-	return !!eproto.cap;
-}
-
-static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
-				     const u32 **arr, u32 *size,
-				     bool force_legacy)
-{
-	bool ext = force_legacy ? false : mlx5e_ptys_ext_supported(mdev);
-
-	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
-		      ARRAY_SIZE(mlx5e_link_speed);
-	*arr  = ext ? mlx5e_ext_link_speed : mlx5e_link_speed;
-}
-
-int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
-			      struct mlx5e_port_eth_proto *eproto)
-{
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	int err;
-
-	if (!eproto)
-		return -EINVAL;
-
-	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN, port);
-	if (err)
-		return err;
-
-	eproto->cap   = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
-					   eth_proto_capability);
-	eproto->admin = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_admin);
-	eproto->oper  = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_oper);
-	return 0;
-}
-
 void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
 				 u8 *an_disable_cap, u8 *an_disable_admin)
 {
@@ -172,30 +77,14 @@ int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
 			    sizeof(out), MLX5_REG_PTYS, 0, 1);
 }
 
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
-			  bool force_legacy)
-{
-	unsigned long temp = eth_proto_oper;
-	const u32 *table;
-	u32 speed = 0;
-	u32 max_size;
-	int i;
-
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
-	i = find_first_bit(&temp, max_size);
-	if (i < max_size)
-		speed = table[i];
-	return speed;
-}
-
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
-	struct mlx5e_port_eth_proto eproto;
+	struct mlx5_port_eth_proto eproto;
 	bool force_legacy = false;
 	bool ext;
 	int err;
 
-	ext = mlx5e_ptys_ext_supported(mdev);
+	ext = mlx5_ptys_ext_supported(mdev);
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		goto out;
@@ -205,7 +94,7 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 		if (err)
 			goto out;
 	}
-	*speed = mlx5e_port_ptys2speed(mdev, eproto.oper, force_legacy);
+	*speed = mlx5_port_ptys2speed(mdev, eproto.oper, force_legacy);
 	if (!(*speed))
 		err = -EINVAL;
 
@@ -213,46 +102,6 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 	return err;
 }
 
-int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
-{
-	struct mlx5e_port_eth_proto eproto;
-	u32 max_speed = 0;
-	const u32 *table;
-	u32 max_size;
-	bool ext;
-	int err;
-	int i;
-
-	ext = mlx5e_ptys_ext_supported(mdev);
-	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
-	if (err)
-		return err;
-
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size, false);
-	for (i = 0; i < max_size; ++i)
-		if (eproto.cap & MLX5E_PROT_MASK(i))
-			max_speed = max(max_speed, table[i]);
-
-	*speed = max_speed;
-	return 0;
-}
-
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
-			       bool force_legacy)
-{
-	u32 link_modes = 0;
-	const u32 *table;
-	u32 max_size;
-	int i;
-
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
-	for (i = 0; i < max_size; ++i) {
-		if (table[i] == speed)
-			link_modes |= MLX5E_PROT_MASK(i);
-	}
-	return link_modes;
-}
-
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out)
 {
 	int sz = MLX5_ST_SZ_BYTES(pbmc_reg);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 3f474e370828..d1da225f35da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -36,25 +36,11 @@
 #include <linux/mlx5/driver.h>
 #include "en.h"
 
-struct mlx5e_port_eth_proto {
-	u32 cap;
-	u32 admin;
-	u32 oper;
-};
-
-int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
-			      struct mlx5e_port_eth_proto *eproto);
 void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *dev, u8 *an_status,
 				 u8 *an_disable_cap, u8 *an_disable_admin);
 int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
 			   u32 proto_admin, bool ext);
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
-			  bool force_legacy);
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
-int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
-			       bool force_legacy);
-bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev);
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
 int mlx5e_port_query_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7708acc9b2ab..53c35147f29b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -220,7 +220,7 @@ static void mlx5e_ethtool_get_speed_arr(struct mlx5_core_dev *mdev,
 					struct ptys2ethtool_config **arr,
 					u32 *size)
 {
-	bool ext = mlx5e_ptys_ext_supported(mdev);
+	bool ext = mlx5_ptys_ext_supported(mdev);
 
 	*arr = ext ? ptys2ext_ethtool_table : ptys2legacy_ethtool_table;
 	*size = ext ? ARRAY_SIZE(ptys2ext_ethtool_table) :
@@ -895,7 +895,7 @@ static void get_speed_duplex(struct net_device *netdev,
 	if (!netif_carrier_ok(netdev))
 		goto out;
 
-	speed = mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper, force_legacy);
+	speed = mlx5_port_ptys2speed(priv->mdev, eth_proto_oper, force_legacy);
 	if (!speed) {
 		if (data_rate_oper)
 			speed = 100 * data_rate_oper;
@@ -980,7 +980,7 @@ static void get_lp_advertising(struct mlx5_core_dev *mdev, u32 eth_proto_lp,
 			       struct ethtool_link_ksettings *link_ksettings)
 {
 	unsigned long *lp_advertising = link_ksettings->link_modes.lp_advertising;
-	bool ext = mlx5e_ptys_ext_supported(mdev);
+	bool ext = mlx5_ptys_ext_supported(mdev);
 
 	ptys2ethtool_adver_link(lp_advertising, eth_proto_lp, ext);
 }
@@ -1160,7 +1160,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 				     const struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_port_eth_proto eproto;
+	struct mlx5_port_eth_proto eproto;
 	const unsigned long *adver;
 	bool an_changes = false;
 	u8 an_disable_admin;
@@ -1180,7 +1180,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	autoneg = link_ksettings->base.autoneg;
 	speed = link_ksettings->base.speed;
 
-	ext_supported = mlx5e_ptys_ext_supported(mdev);
+	ext_supported = mlx5_ptys_ext_supported(mdev);
 	ext = ext_requested(autoneg, adver, ext_supported);
 	if (!ext_supported && ext)
 		return -EOPNOTSUPP;
@@ -1194,7 +1194,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 		goto out;
 	}
 	link_modes = autoneg == AUTONEG_ENABLE ? ethtool2ptys_adver_func(adver) :
-		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
+		mlx5_port_speed2linkmodes(mdev, speed, !ext);
 
 	err = mlx5e_speed_validate(priv->netdev, ext, link_modes, autoneg);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 70b8d2dfa751..79dd8ad5ede7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1108,7 +1108,7 @@ mlx5e_hairpin_params_init(struct mlx5e_hairpin_params *hairpin_params,
 
 	hairpin_params->mdev = mdev;
 	/* set hairpin pair per each 50Gbs share of the link */
-	mlx5e_port_max_linkspeed(mdev, &link_speed);
+	mlx5_port_max_linkspeed(mdev, &link_speed);
 	link_speed = max_t(u32, link_speed, 50000);
 	link_speed64 = link_speed;
 	do_div(link_speed64, 50000);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 75015d370922..7c79476cc5f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -744,7 +744,7 @@ static int esw_qos_devlink_rate_to_mbps(struct mlx5_core_dev *mdev, const char *
 	u64 value;
 	int err;
 
-	err = mlx5e_port_max_linkspeed(mdev, &link_speed_max);
+	err = mlx5_port_max_linkspeed(mdev, &link_speed_max);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to get link maximum speed");
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index a1548e6bfb35..0daeb4b72cca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -1054,3 +1054,154 @@ int mlx5_query_dscp2prio(struct mlx5_core_dev *mdev, u8 *dscp2prio)
 	kfree(out);
 	return err;
 }
+
+/* speed in units of 1Mb */
+static const u32 mlx5e_link_speed[MLX5E_LINK_MODES_NUMBER] = {
+	[MLX5E_1000BASE_CX_SGMII] = 1000,
+	[MLX5E_1000BASE_KX]       = 1000,
+	[MLX5E_10GBASE_CX4]       = 10000,
+	[MLX5E_10GBASE_KX4]       = 10000,
+	[MLX5E_10GBASE_KR]        = 10000,
+	[MLX5E_20GBASE_KR2]       = 20000,
+	[MLX5E_40GBASE_CR4]       = 40000,
+	[MLX5E_40GBASE_KR4]       = 40000,
+	[MLX5E_56GBASE_R4]        = 56000,
+	[MLX5E_10GBASE_CR]        = 10000,
+	[MLX5E_10GBASE_SR]        = 10000,
+	[MLX5E_10GBASE_ER]        = 10000,
+	[MLX5E_40GBASE_SR4]       = 40000,
+	[MLX5E_40GBASE_LR4]       = 40000,
+	[MLX5E_50GBASE_SR2]       = 50000,
+	[MLX5E_100GBASE_CR4]      = 100000,
+	[MLX5E_100GBASE_SR4]      = 100000,
+	[MLX5E_100GBASE_KR4]      = 100000,
+	[MLX5E_100GBASE_LR4]      = 100000,
+	[MLX5E_100BASE_TX]        = 100,
+	[MLX5E_1000BASE_T]        = 1000,
+	[MLX5E_10GBASE_T]         = 10000,
+	[MLX5E_25GBASE_CR]        = 25000,
+	[MLX5E_25GBASE_KR]        = 25000,
+	[MLX5E_25GBASE_SR]        = 25000,
+	[MLX5E_50GBASE_CR2]       = 50000,
+	[MLX5E_50GBASE_KR2]       = 50000,
+};
+
+static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
+	[MLX5E_SGMII_100M] = 100,
+	[MLX5E_1000BASE_X_SGMII] = 1000,
+	[MLX5E_5GBASE_R] = 5000,
+	[MLX5E_10GBASE_XFI_XAUI_1] = 10000,
+	[MLX5E_40GBASE_XLAUI_4_XLPPI_4] = 40000,
+	[MLX5E_25GAUI_1_25GBASE_CR_KR] = 25000,
+	[MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2] = 50000,
+	[MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR] = 50000,
+	[MLX5E_CAUI_4_100GBASE_CR4_KR4] = 100000,
+	[MLX5E_100GAUI_2_100GBASE_CR2_KR2] = 100000,
+	[MLX5E_200GAUI_4_200GBASE_CR4_KR4] = 200000,
+	[MLX5E_400GAUI_8] = 400000,
+	[MLX5E_100GAUI_1_100GBASE_CR_KR] = 100000,
+	[MLX5E_200GAUI_2_200GBASE_CR2_KR2] = 200000,
+	[MLX5E_400GAUI_4_400GBASE_CR4_KR4] = 400000,
+};
+
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
+			      struct mlx5_port_eth_proto *eproto)
+{
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
+	int err;
+
+	if (!eproto)
+		return -EINVAL;
+
+	err = mlx5_query_port_ptys(dev, out, sizeof(out), MLX5_PTYS_EN, port);
+	if (err)
+		return err;
+
+	eproto->cap   = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
+					   eth_proto_capability);
+	eproto->admin = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_admin);
+	eproto->oper  = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_oper);
+	return 0;
+}
+
+bool mlx5_ptys_ext_supported(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_port_eth_proto eproto;
+	int err;
+
+	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet))
+		return true;
+
+	err = mlx5_port_query_eth_proto(mdev, 1, true, &eproto);
+	if (err)
+		return false;
+
+	return !!eproto.cap;
+}
+
+static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
+				     const u32 **arr, u32 *size,
+				     bool force_legacy)
+{
+	bool ext = force_legacy ? false : mlx5_ptys_ext_supported(mdev);
+
+	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
+		      ARRAY_SIZE(mlx5e_link_speed);
+	*arr  = ext ? mlx5e_ext_link_speed : mlx5e_link_speed;
+}
+
+u32 mlx5_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			 bool force_legacy)
+{
+	unsigned long temp = eth_proto_oper;
+	const u32 *table;
+	u32 speed = 0;
+	u32 max_size;
+	int i;
+
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
+	i = find_first_bit(&temp, max_size);
+	if (i < max_size)
+		speed = table[i];
+	return speed;
+}
+
+u32 mlx5_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			      bool force_legacy)
+{
+	u32 link_modes = 0;
+	const u32 *table;
+	u32 max_size;
+	int i;
+
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
+	for (i = 0; i < max_size; ++i) {
+		if (table[i] == speed)
+			link_modes |= MLX5E_PROT_MASK(i);
+	}
+	return link_modes;
+}
+
+int mlx5_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
+{
+	struct mlx5_port_eth_proto eproto;
+	u32 max_speed = 0;
+	const u32 *table;
+	u32 max_size;
+	bool ext;
+	int err;
+	int i;
+
+	ext = mlx5_ptys_ext_supported(mdev);
+	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
+	if (err)
+		return err;
+
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, false);
+	for (i = 0; i < max_size; ++i)
+		if (eproto.cap & MLX5E_PROT_MASK(i))
+			max_speed = max(max_speed, table[i]);
+
+	*speed = max_speed;
+	return 0;
+}
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index e96ee1e348cb..98b2e1e149f9 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -141,6 +141,12 @@ enum mlx5_ptys_width {
 	MLX5_PTYS_WIDTH_12X	= 1 << 4,
 };
 
+struct mlx5_port_eth_proto {
+	u32 cap;
+	u32 admin;
+	u32 oper;
+};
+
 #define MLX5E_PROT_MASK(link_mode) (1U << link_mode)
 #define MLX5_GET_ETH_PROTO(reg, out, ext, field)	\
 	(ext ? MLX5_GET(reg, out, ext_##field) :	\
@@ -218,4 +224,14 @@ int mlx5_set_trust_state(struct mlx5_core_dev *mdev, u8 trust_state);
 int mlx5_query_trust_state(struct mlx5_core_dev *mdev, u8 *trust_state);
 int mlx5_set_dscp2prio(struct mlx5_core_dev *mdev, u8 dscp, u8 prio);
 int mlx5_query_dscp2prio(struct mlx5_core_dev *mdev, u8 *dscp2prio);
+
+int mlx5_port_query_eth_proto(struct mlx5_core_dev *dev, u8 port, bool ext,
+			      struct mlx5_port_eth_proto *eproto);
+bool mlx5_ptys_ext_supported(struct mlx5_core_dev *mdev);
+u32 mlx5_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			 bool force_legacy);
+u32 mlx5_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			      bool force_legacy);
+int mlx5_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
+
 #endif /* __MLX5_PORT_H__ */
-- 
2.39.1

