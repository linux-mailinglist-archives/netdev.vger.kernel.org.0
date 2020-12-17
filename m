Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7539B2DCE00
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgLQI7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:59:09 -0500
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:10627
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbgLQI7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:59:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lay4+Hh2dTDVuA2LAIbWav3B8TuSMuEyV+WGO44MSV1+8p204OmYZPUgRkJxD1lgESzedauNblLayYlgH0wipAwGWSf/YYrwAiz0A/L7rMrrBBDXAdM9OVwL9T2cXqDLEMRzNo04nehiixNLA1VAF3wuNVAuKIYy5F1ktWuYJ6UmeOD8Uf19A5nmzvvPiMg9alrGgsHX0uckVRNKa0jxOgtjLT0IWSrNkIdP0SQYxzkdpNVCXkIegzaz57ZQejPc/Hu4H4Y8MOgrKKcYnTkf6nunQnusRUrQT5rVdz67GuFdij49LBV6UXjUlW2uSoh7BK6ZYsm3cB4PBoKgrwjZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE5yJdNFngWs3soS7YOhqVfG+iAUGdBw7rwciig15g=;
 b=knRZfTX6TK/bbcBYoiV104eDRgteY5A7JNeeQyOXaIvjjVt1J41BKnZIb50r7ta9S3Vai5h1pcqvSxHCtghpjtRdZGCEDBzQnGbSAs2P1p75B6TvsE3IFTg9aDrzTe/gjIoIA1SmG6y1XZeOXjmZiJ05r+v82BYI+YR/e1dUakzOwd0KMNqJCgmlIzgAtbSV8D6c1xNdopt1/6UUIjwaNLi2K6Ht+9KRKBjb3wnQBRmdHXjJb+D8MVQMuD42sWEHXVKNMq4tAyCWYBRWCIBSdczjGrc/ItHpJqeReA0+oiTlRFnA5lGQSD2nwyKcKOtpn/IZYZeYrb8ybiCAGqiqJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE5yJdNFngWs3soS7YOhqVfG+iAUGdBw7rwciig15g=;
 b=YN5qhsyMblMSl5aGoW0GbRFY6JLGfRWUUDAp2+yTVlDqgsNhb0s3jUy/ayeQoAEjl0VOAb5/kllNY6NVi/ZT3neWfspQ+HR2GmOB29DHeJkhsfOWhQkkm9sci68WqScAXwxqjhkTX9eCK2u+a7DUDs6r7JZ/cyiiHPDIgMyVooc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:37 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:37 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 5/7] mlxsw: ethtool: Add support for setting lanes when autoneg is off
Date:   Thu, 17 Dec 2020 10:57:15 +0200
Message-Id: <20201217085717.4081793-6-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bf93225f-9821-4c23-0321-08d8a269cd5f
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB667487F3856B0BA74149B4B7D5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1H+TJbOIal2iIq5xeUAxdVz0k94N5NTkQJcM3LfOdwgDrtMMoTHvBYPIv5v/FjOtWq3oL4oCYc38lfqrOUT6AVZjYiiJE51hM3KEcna+GjjGEijlklcmRKpgqmTHLKp5mFpCAuqOoG7u7YDHsdXRG483CCsTZSktIU01aSijPwhxX9qniethUEoHphs8jV/AoOGsy86n//Cx74dYHR4tH3xJXu9GLSTaUGeFDE8TCyYaMQChsHj3XOpVqZE9NyDJLpoQ6NZh5Blp6ZcGDAwSNn593Mmq2G+RRLXOCU4nOysxA051U+73Ixwu1E5EwQlQskzEL7fdUAlVXPDbJd/Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(30864003)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hj+Mj1Gvjb7Nk70W2HwWxNkIfqD3wgxecQui9Sny9JmWzJdkPTBnpd2ZuaCG?=
 =?us-ascii?Q?hjuD1l//Yjhk0bsHTpfcAcZmldYG4BJ7MlGH3T8447BYMNxtRKf8aTm0RSAr?=
 =?us-ascii?Q?Qe7+YfEk/UFgFPxUHy3Xvcv+WQo4JMyEplS00g+mpWSoNnjgLjT47uTpkqKu?=
 =?us-ascii?Q?tWKcNjzHRODRPRPMmNfa6T8uvC2eI8uJHKfbKBR25aaAC3tzKI9x31bmAaeG?=
 =?us-ascii?Q?8WRbBsvE/AxHrvnfJOEdZtMAA3+P0HCG8MxDXvdXPYVgg5NflA+LVyvd5tE/?=
 =?us-ascii?Q?erScnXy/gXkLckCotZpDQOO8+SihyV+afMZ9AQT1v77YbbJaiO67ZYOOCEHn?=
 =?us-ascii?Q?VpKax9Y+e7sQPU0C2v/1RJ2ZWEZviYUXH0QrAaeWu+39Uq3cq+oEGg7P0S+7?=
 =?us-ascii?Q?4N0L9oS4XM1wBiDKg5DL7hfq0n1cuVXA9uUQLiz89B3hEVbnEsaWqDxTV7DX?=
 =?us-ascii?Q?G39IUzdLr5ARX+Fe6Jft4Uki9iO/pQ9JNmz5HISjFTADw6kb3Mt2h49xfEkS?=
 =?us-ascii?Q?KJpc9k3AucZJ+QIiPsgXXMArCsRsFRH1m68vjhPO4rdM5Vh/bF6Hl1ARp8Qd?=
 =?us-ascii?Q?/pPLUiCBprfVMqFWiMGLa1GPWUUORycsOPoVb8fR4Zjw5Dic4s/iCAdHsPrf?=
 =?us-ascii?Q?zyh+uB+rTBH6DMgp0YqAuvyfaGkrQcZSsTYCdnyCkfHHvrow0izS1zEJkfMS?=
 =?us-ascii?Q?eyj98HcB2htv4Fs5aW8M8hKFvqS6Ma6dtG+jPwBLiPbg9NHAHzxEDR8DCsni?=
 =?us-ascii?Q?F5zYuy4GpGW/b7WN9yQOxWg3fEjjrbXywAEm/CrYzZa1ifOa4OGo1ZMrzblK?=
 =?us-ascii?Q?bAfEA5PezYG7QzB6pWxTBD05Kg8ab48mhXQ6Gv2Oj/eFZJYhmKDyvvzU3dX9?=
 =?us-ascii?Q?eFWxDdI8Us3dl9N77yHalb7HaakRjVfhTCYPs1UNFWi1ZFy4cANVSc9/QdFq?=
 =?us-ascii?Q?QSJ+mAbX3ZMQghnD3WwAt5uUcGWU67T9Og3V4u84R23LVEI6HUaWOM4d9Ynl?=
 =?us-ascii?Q?6K3s?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:37.3147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: bf93225f-9821-4c23-0321-08d8a269cd5f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFnl4TX6yvowcAJxEBEEhLc6X7E9RVaVg8SgCHaElFKw4QzxyAL1a0qUzYWH9NTCH7nnSj6weAGpfuMAPG4D7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

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
    v2:
    	* Reword commit message.
    	* Add an actual width field for Spectrum-2 link modes, and change
    	  accordingly the conditions for choosing a link mode bit.

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 88 +++++++++++++------
 2 files changed, 64 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index cc4aeb3cdd10..0ad6b8a581d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -337,7 +337,8 @@ struct mlxsw_sp_port_type_speed_ops {
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
-	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
+	u32 (*to_ptys_speed_lanes)(struct mlxsw_sp *mlxsw_sp, u8 width,
+				   const struct ethtool_link_ksettings *cmd);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
 				  u8 local_port, u32 proto_admin, bool autoneg);
 	void (*reg_ptys_eth_unpack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index aa13af0f33f0..b6c19a76388f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -996,12 +996,12 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
 	eth_proto_new = autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
-		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
-				   cmd->base.speed);
+		ops->to_ptys_speed_lanes(mlxsw_sp, mlxsw_sp_port->mapping.width,
+					 cmd);
 
 	eth_proto_new = eth_proto_new & eth_proto_cap;
 	if (!eth_proto_new) {
-		netdev_err(dev, "No supported speed requested\n");
+		netdev_err(dev, "No supported speed or lanes requested\n");
 		return -EINVAL;
 	}
 
@@ -1062,6 +1062,7 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 }
 
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
+	.capabilities           = ETHTOOL_CAP_LINK_LANES_SUPPORTED,
 	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ext_state	= mlxsw_sp_port_get_link_ext_state,
@@ -1273,14 +1274,17 @@ mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
-				   u32 speed)
+static u32 mlxsw_sp1_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto = 0;
 	int i;
 
+	if (cmd->lanes > width)
+		return ptys_proto;
+
 	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (speed == mlxsw_sp1_port_link_mode[i].speed)
+		if (cmd->base.speed == mlxsw_sp1_port_link_mode[i].speed)
 			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
 	}
 	return ptys_proto;
@@ -1323,7 +1327,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
 	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
+	.to_ptys_speed_lanes		= mlxsw_sp1_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
 	.ptys_proto_cap_masked_get	= mlxsw_sp1_ptys_proto_cap_masked_get,
@@ -1485,7 +1489,8 @@ struct mlxsw_sp2_port_link_mode {
 	int m_ethtool_len;
 	u32 mask;
 	u32 speed;
-	u8 mask_width;
+	u32 width;
+	u8 mask_sup_width;
 };
 
 static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
@@ -1493,105 +1498,117 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_sgmii_100m,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_1000base_x_sgmii,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_1000,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_5gbase_r,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_5000,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_10000,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_40000,
+		.width		= 4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_25000,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_2_LAUI_2_50GBASE_CR2_KR2,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
 				  MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_50000,
+		.width		= 2,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X,
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_1X,
 		.speed		= SPEED_50000,
+		.width		= 1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100000,
+		.width		= 4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X,
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_2X,
 		.speed		= SPEED_100000,
+		.width		= 2,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_200000,
+		.width		= 4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_400gaui_8,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_400000,
+		.width		= 8,
 	},
 };
 
@@ -1709,17 +1726,36 @@ mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
-				   u8 width, u32 speed)
+static u32 mlxsw_sp2_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
+	struct mlxsw_sp2_port_link_mode link_mode;
 	u32 ptys_proto = 0;
 	int i;
 
+	if (cmd->lanes > width)
+		return ptys_proto;
+
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((speed == mlxsw_sp2_port_link_mode[i].speed) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
-			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
+		if (cmd->base.speed == mlxsw_sp2_port_link_mode[i].speed) {
+			link_mode = mlxsw_sp2_port_link_mode[i];
+
+			if (cmd->lanes == ETHTOOL_LANES_UNKNOWN) {
+				/* If number of lanes was not set by user space,
+				 * choose the link mode that supports the width
+				 * of the port.
+				 */
+				if (mask_width & link_mode.mask_sup_width)
+					ptys_proto |= link_mode.mask;
+			} else if (cmd->lanes == link_mode.width) {
+				/* Else if the number of lanes was set, choose
+				 * the link mode that its actual width equals to
+				 * it.
+				 */
+				ptys_proto |= link_mode.mask;
+			}
+		}
 	}
 	return ptys_proto;
 }
@@ -1762,7 +1798,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
 	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
+	.to_ptys_speed_lanes		= mlxsw_sp2_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
 	.ptys_proto_cap_masked_get	= mlxsw_sp2_ptys_proto_cap_masked_get,
-- 
2.26.2

