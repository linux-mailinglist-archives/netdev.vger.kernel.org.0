Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11CA06AF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfH1PzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:55:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49441 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbfH1PzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:55:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AE5822214E;
        Wed, 28 Aug 2019 11:55:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 28 Aug 2019 11:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PELyVfPlpqy6CagruEfFUFBDVD+U1xzhOViV5FyTGEc=; b=Y5M2sSuR
        a1ZQCnDOryF+ah9huudCPITRBwgd6kRlO2rloKiGo+hYWDtNlWX4OS94MmWKp+hF
        AMYhmaA5uf4PgytGJ2MOFEc8qMigcfuoWv0FEHdTROSTJaNEYjhX/9r0BN+Lx5z5
        9sDwFcYnjx0zKiEmjRr/h2tel6/ENkxGKa8PCJrEg3DzzIFyFJhFKM1kph7mNhNl
        BfCDbh9kRqgK6DXSuUv6ITwJlJBC2ZBSc/VubEwLObjg9d/P+dDouS4Z56O3Qtvl
        Fl0RlsNoqLOrlrK6vcYyV4O2zkHN8ZgVCF6VLpYqQtRxja4WqlL8H93kEgLkm/Gs
        8h1pyluxCuZQow==
X-ME-Sender: <xms:2qNmXcEPi86yCeIKdlaQdM9Ihq5UyNY9zbNkwev3Io2ESJWE0b6g3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:2qNmXb4k79oJlZpnexnXuQV6FImYjhfpWPvcT1HZ4bes3NrJumnKfA>
    <xmx:2qNmXX224MoPw7oG7bWNi9B5Be0Teb5wQnnm7R0psp4jJYzq6nBBEA>
    <xmx:2qNmXXhTzZijGjMe-0ApBzBNkVFqRcxosK83wanRtprrHUyXhAIOsA>
    <xmx:2qNmXWKPW6DeZPjQOQ8SrTm9HsrUv0LQ5NxbxeVGv6C6m9qioVfjPw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60E1DD6005F;
        Wed, 28 Aug 2019 11:55:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/4] mlxsw: spectrum: Prevent auto negotiation on number of lanes
Date:   Wed, 28 Aug 2019 18:54:35 +0300
Message-Id: <20190828155437.9852-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

After 50G-1-lane and 100G-2-lanes link modes were introduced, the driver
is facing situations in which the hardware auto negotiates not only on
speed and type, but also on number of lanes.

Prevent auto negotiation on number of lanes by allowing only port speeds
that can be supported on a given port according to its width.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 91 +++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 2 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4d1f8b9c46a7..d4e7971e525d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2655,7 +2655,7 @@ mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 unsigned long *mode)
+			 u8 width, unsigned long *mode)
 {
 	int i;
 
@@ -2696,7 +2696,7 @@ mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 }
 
 static u32
-mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
+mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
 			      const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto = 0;
@@ -2710,7 +2710,8 @@ mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 speed)
+static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
+				   u32 speed)
 {
 	u32 ptys_proto = 0;
 	int i;
@@ -2898,11 +2899,31 @@ mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4[] = {
 #define MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN \
 	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4)
 
+#define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
+#define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
+#define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
+
+static u8 mlxsw_sp_port_mask_width_get(u8 width)
+{
+	switch (width) {
+	case 1:
+		return MLXSW_SP_PORT_MASK_WIDTH_1X;
+	case 2:
+		return MLXSW_SP_PORT_MASK_WIDTH_2X;
+	case 4:
+		return MLXSW_SP_PORT_MASK_WIDTH_4X;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
 struct mlxsw_sp2_port_link_mode {
 	const enum ethtool_link_mode_bit_indices *mask_ethtool;
 	int m_ethtool_len;
 	u32 mask;
 	u32 speed;
+	u8 mask_width;
 };
 
 static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
@@ -2910,72 +2931,97 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_sgmii_100m,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_100,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_1000base_x_sgmii,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_1000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_2_5GBASE_X_2_5GMII,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_2500,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_5gbase_r,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_5000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_10000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_40000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_25000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_2_LAUI_2_50GBASE_CR2_KR2,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_50000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X,
 		.speed		= SPEED_50000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_100000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X,
 		.speed		= SPEED_100000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
 		.speed		= SPEED_200000,
 	},
 };
@@ -3003,12 +3049,14 @@ mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 
 static void
 mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 unsigned long *mode)
+			 u8 width, unsigned long *mode)
 {
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
+		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
+		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
 			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 						  mode);
 	}
@@ -3059,27 +3107,32 @@ mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 }
 
 static u32
-mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
+mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
 			      const struct ethtool_link_ksettings *cmd)
 {
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto = 0;
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
+		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 					       cmd->link_modes.advertising))
 			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
 	}
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 speed)
+static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
+				   u8 width, u32 speed)
 {
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto = 0;
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (speed == mlxsw_sp2_port_link_mode[i].speed)
+		if ((speed == mlxsw_sp2_port_link_mode[i].speed) &&
+		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
 			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
 	}
 	return ptys_proto;
@@ -3163,7 +3216,7 @@ mlxsw_sp2_port_type_speed_ops = {
 
 static void
 mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
-				 struct ethtool_link_ksettings *cmd)
+				 u8 width, struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 
@@ -3174,12 +3227,13 @@ mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 
 	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, cmd->link_modes.supported);
+	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
+			    cmd->link_modes.supported);
 }
 
 static void
 mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
-				 u32 eth_proto_admin, bool autoneg,
+				 u32 eth_proto_admin, bool autoneg, u8 width,
 				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
@@ -3190,7 +3244,7 @@ mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
 		return;
 
 	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_admin,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
 			    cmd->link_modes.advertising);
 }
 
@@ -3245,10 +3299,11 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
 				 &eth_proto_admin, &eth_proto_oper);
 
-	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap, cmd);
+	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
+					 mlxsw_sp_port->mapping.width, cmd);
 
 	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
-					 cmd);
+					 mlxsw_sp_port->mapping.width, cmd);
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	connector_type = mlxsw_reg_ptys_connector_type_get(ptys_pl);
@@ -3282,8 +3337,10 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
 	eth_proto_new = autoneg ?
-		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
-		ops->to_ptys_speed(mlxsw_sp, cmd->base.speed);
+		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
+					 cmd) :
+		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
+				   cmd->base.speed);
 
 	eth_proto_new = eth_proto_new & eth_proto_cap;
 	if (!eth_proto_new) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 20c14bba9ccb..12f14a42b43a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -279,14 +279,14 @@ struct mlxsw_sp_port_type_speed_ops {
 					 u32 ptys_eth_proto,
 					 struct ethtool_link_ksettings *cmd);
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			       unsigned long *mode);
+			       u8 width, unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
-	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
+	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
 				   const struct ethtool_link_ksettings *cmd);
-	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 speed);
+	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
 	u32 (*to_ptys_upper_speed)(struct mlxsw_sp *mlxsw_sp, u32 upper_speed);
 	int (*port_speed_base)(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 			       u32 *base_speed);
-- 
2.21.0

