Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF30430C923
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhBBSKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:10:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17838 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbhBBSHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994b50000>; Tue, 02 Feb 2021 10:06:45 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:42 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 6/8] mlxsw: ethtool: Add support for setting lanes when autoneg is off
Date:   Tue, 2 Feb 2021 20:06:10 +0200
Message-ID: <20210202180612.325099-7-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289205; bh=4QJ9KZ94prDRA4avgb9Re8PUOWs7EbgVegg/Q5QCjWc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=aLG8uP1cS7tfCDaiaVwrcuds57Xif/73C5cW2TPvRFn/0Md2X8ZQRNKkejBbs/Qnl
         GaxeAqrwzs4Aroj3EhwJuIYa7CNMEfY8ZUqTcJPbFbOZuROB328f2K0LX0EdAi6nMX
         eFHIttejy6HWdZxQP9sbt9NVEIrrMu6Z5CvE4FFsDdb4GQUInIhYDrplHNc1NbTjNU
         xwFhhgHFXLabrWfjGqu7TNOo8Mwzy1Lg9dLDf7dRTqUCSeEggZ1ojTxs19+r7Rk/E8
         RaFM23CTPBP4/7SNQuNoYZDNC1DzthxNR8KTZ3s9fzQpdWXI7IgVmMqS2Hgu7nCUxA
         IJdZxp+uEWK8A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when auto negotiation is set to off, the user can force a
specific speed or both speed and duplex. The user cannot influence the
number of lanes that will be forced.

Add support for setting speed along with lanes so one would be able
to choose how many lanes will be forced.

When lanes parameter is passed from user space, choose the link mode
that its actual width equals to it.
Otherwise, the default link mode will be the one that supports the width
of the port.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v3:
    	* Re-set the bitfield of supporting lanes in the driver to 'true'.
   =20
    v2:
    	* Reword commit message.
    	* Add an actual width field for Spectrum-2 link modes, and change
    	  accordingly the conditions for choosing a link mode bit.

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 116 ++++++++++++------
 2 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.h
index cc4aeb3cdd10..0ad6b8a581d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -337,7 +337,8 @@ struct mlxsw_sp_port_type_speed_ops {
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_spe=
ed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
-	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
+	u32 (*to_ptys_speed_lanes)(struct mlxsw_sp *mlxsw_sp, u8 width,
+				   const struct ethtool_link_ksettings *cmd);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
 				  u8 local_port, u32 proto_admin, bool autoneg);
 	void (*reg_ptys_eth_unpack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index aa13af0f33f0..b0031ae7e623 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -996,12 +996,12 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *d=
ev,
 	autoneg =3D cmd->base.autoneg =3D=3D AUTONEG_ENABLE;
 	eth_proto_new =3D autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
-		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
-				   cmd->base.speed);
+		ops->to_ptys_speed_lanes(mlxsw_sp, mlxsw_sp_port->mapping.width,
+					 cmd);
=20
 	eth_proto_new =3D eth_proto_new & eth_proto_cap;
 	if (!eth_proto_new) {
-		netdev_err(dev, "No supported speed requested\n");
+		netdev_err(dev, "No supported speed or lanes requested\n");
 		return -EINVAL;
 	}
=20
@@ -1062,20 +1062,21 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, str=
uct ethtool_ts_info *info)
 }
=20
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops =3D {
-	.get_drvinfo		=3D mlxsw_sp_port_get_drvinfo,
-	.get_link		=3D ethtool_op_get_link,
-	.get_link_ext_state	=3D mlxsw_sp_port_get_link_ext_state,
-	.get_pauseparam		=3D mlxsw_sp_port_get_pauseparam,
-	.set_pauseparam		=3D mlxsw_sp_port_set_pauseparam,
-	.get_strings		=3D mlxsw_sp_port_get_strings,
-	.set_phys_id		=3D mlxsw_sp_port_set_phys_id,
-	.get_ethtool_stats	=3D mlxsw_sp_port_get_stats,
-	.get_sset_count		=3D mlxsw_sp_port_get_sset_count,
-	.get_link_ksettings	=3D mlxsw_sp_port_get_link_ksettings,
-	.set_link_ksettings	=3D mlxsw_sp_port_set_link_ksettings,
-	.get_module_info	=3D mlxsw_sp_get_module_info,
-	.get_module_eeprom	=3D mlxsw_sp_get_module_eeprom,
-	.get_ts_info		=3D mlxsw_sp_get_ts_info,
+	.cap_link_lanes_supported	=3D true,
+	.get_drvinfo			=3D mlxsw_sp_port_get_drvinfo,
+	.get_link			=3D ethtool_op_get_link,
+	.get_link_ext_state		=3D mlxsw_sp_port_get_link_ext_state,
+	.get_pauseparam			=3D mlxsw_sp_port_get_pauseparam,
+	.set_pauseparam			=3D mlxsw_sp_port_set_pauseparam,
+	.get_strings			=3D mlxsw_sp_port_get_strings,
+	.set_phys_id			=3D mlxsw_sp_port_set_phys_id,
+	.get_ethtool_stats		=3D mlxsw_sp_port_get_stats,
+	.get_sset_count			=3D mlxsw_sp_port_get_sset_count,
+	.get_link_ksettings		=3D mlxsw_sp_port_get_link_ksettings,
+	.set_link_ksettings		=3D mlxsw_sp_port_set_link_ksettings,
+	.get_module_info		=3D mlxsw_sp_get_module_info,
+	.get_module_eeprom		=3D mlxsw_sp_get_module_eeprom,
+	.get_ts_info			=3D mlxsw_sp_get_ts_info,
 };
=20
 struct mlxsw_sp1_port_link_mode {
@@ -1273,14 +1274,17 @@ mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxs=
w_sp,
 	return ptys_proto;
 }
=20
-static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
-				   u32 speed)
+static u32 mlxsw_sp1_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 wid=
th,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto =3D 0;
 	int i;
=20
+	if (cmd->lanes > width)
+		return ptys_proto;
+
 	for (i =3D 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (speed =3D=3D mlxsw_sp1_port_link_mode[i].speed)
+		if (cmd->base.speed =3D=3D mlxsw_sp1_port_link_mode[i].speed)
 			ptys_proto |=3D mlxsw_sp1_port_link_mode[i].mask;
 	}
 	return ptys_proto;
@@ -1323,7 +1327,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_p=
ort_type_speed_ops =3D {
 	.from_ptys_speed_duplex		=3D mlxsw_sp1_from_ptys_speed_duplex,
 	.ptys_max_speed			=3D mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		=3D mlxsw_sp1_to_ptys_advert_link,
-	.to_ptys_speed			=3D mlxsw_sp1_to_ptys_speed,
+	.to_ptys_speed_lanes		=3D mlxsw_sp1_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		=3D mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		=3D mlxsw_sp1_reg_ptys_eth_unpack,
 	.ptys_proto_cap_masked_get	=3D mlxsw_sp1_ptys_proto_cap_masked_get,
@@ -1485,7 +1489,8 @@ struct mlxsw_sp2_port_link_mode {
 	int m_ethtool_len;
 	u32 mask;
 	u32 speed;
-	u8 mask_width;
+	u32 width;
+	u8 mask_sup_width;
 };
=20
 static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] =
=3D {
@@ -1493,105 +1498,117 @@ static const struct mlxsw_sp2_port_link_mode mlxs=
w_sp2_port_link_mode[] =3D {
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_sgmii_100m,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_100,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_1000base_x_sgmii,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_1000,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_5gbase_r,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_5000,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_10000,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_40000,
+		.width		=3D 4,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_25000,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_2_LAUI_2_50GBASE_CR2_KR2,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2=
,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR=
2_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_2X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_50000,
+		.width		=3D 2,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_=
LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X,
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_1X,
 		.speed		=3D SPEED_50000,
+		.width		=3D 1,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_100000,
+		.width		=3D 4,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN=
,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_2X,
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_2X,
 		.speed		=3D SPEED_100000,
+		.width		=3D 2,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN=
,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_200000,
+		.width		=3D 4,
 	},
 	{
 		.mask		=3D MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
 		.mask_ethtool	=3D mlxsw_sp2_mask_ethtool_400gaui_8,
 		.m_ethtool_len	=3D MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
-		.mask_width	=3D MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.mask_sup_width	=3D MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		=3D SPEED_400000,
+		.width		=3D 8,
 	},
 };
=20
@@ -1709,17 +1726,36 @@ mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxs=
w_sp,
 	return ptys_proto;
 }
=20
-static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
-				   u8 width, u32 speed)
+static u32 mlxsw_sp2_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 wid=
th,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u8 mask_width =3D mlxsw_sp_port_mask_width_get(width);
+	struct mlxsw_sp2_port_link_mode link_mode;
 	u32 ptys_proto =3D 0;
 	int i;
=20
+	if (cmd->lanes > width)
+		return ptys_proto;
+
 	for (i =3D 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((speed =3D=3D mlxsw_sp2_port_link_mode[i].speed) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
-			ptys_proto |=3D mlxsw_sp2_port_link_mode[i].mask;
+		if (cmd->base.speed =3D=3D mlxsw_sp2_port_link_mode[i].speed) {
+			link_mode =3D mlxsw_sp2_port_link_mode[i];
+
+			if (!cmd->lanes) {
+				/* If number of lanes was not set by user space,
+				 * choose the link mode that supports the width
+				 * of the port.
+				 */
+				if (mask_width & link_mode.mask_sup_width)
+					ptys_proto |=3D link_mode.mask;
+			} else if (cmd->lanes =3D=3D link_mode.width) {
+				/* Else if the number of lanes was set, choose
+				 * the link mode that its actual width equals to
+				 * it.
+				 */
+				ptys_proto |=3D link_mode.mask;
+			}
+		}
 	}
 	return ptys_proto;
 }
@@ -1762,7 +1798,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_p=
ort_type_speed_ops =3D {
 	.from_ptys_speed_duplex		=3D mlxsw_sp2_from_ptys_speed_duplex,
 	.ptys_max_speed			=3D mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		=3D mlxsw_sp2_to_ptys_advert_link,
-	.to_ptys_speed			=3D mlxsw_sp2_to_ptys_speed,
+	.to_ptys_speed_lanes		=3D mlxsw_sp2_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		=3D mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		=3D mlxsw_sp2_reg_ptys_eth_unpack,
 	.ptys_proto_cap_masked_get	=3D mlxsw_sp2_ptys_proto_cap_masked_get,
--=20
2.26.2

