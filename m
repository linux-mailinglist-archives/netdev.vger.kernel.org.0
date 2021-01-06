Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B502EBE3A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbhAFNHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:07:39 -0500
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:5571
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbhAFNHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:07:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay2s9M2lBr9joQhz92JPA0bovNDLAnRtpqj6RVC2fxcf/T3/Gb39QnWXzUUzge/YEM1Wa1rB7PgT/IW0MdMFjKpcn81FwR5SeY3/hPXWPRJV3IXi95MB5ovlUCpa0sHp9b33n3qN8r72rG8wGfa+LlnmDk6KiK2ypWJgOTAO5cfZKJrCb1Ld/pQjWtb395XWtC9DRFL34MqzJ9qAD2eVTXgk1YTrHcNR5SQaBMNE9NjulfUJ1BcKs8FSpZILz+jfjWW3/Kl8fe3erejcI+WB4dTO1l0hixcLt78m0oRM8fD9eh6+X7fM6Q7+f0HATp/5kEWoB0Br82EYJ8DOSSbfPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE5yJdNFngWs3soS7YOhqVfG+iAUGdBw7rwciig15g=;
 b=Rx0/2uNxHOj0DaCGqN1ETo2N3trrJmedhnedfVaCnY/oF7on5SI4DHA9aBJUcmlnitPVJwnusHg2P+2OG4cweToAdgs9EvjZJR246G7pjrGzmRhQEOysVejolV7MAV/bucZrAVvZSju5GV5+CoJcCtHekYS7qTEp0OM9zssZLse+r5R17Wl10H9gHje4/xXoGyK0uxWLH0hvHNrrDu74Uuqp8ZfbF7bl+BOrCqJqww/XvO/aIfJTT9OkqwnoSVE+EF0JXOQQUbZNpHj1vQSNofblAQOUyxR+vfEijSrHbfR6lATXi/6UlKjd1v6rOqWBj8mnRd9jAtJJKVZhmxi5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE5yJdNFngWs3soS7YOhqVfG+iAUGdBw7rwciig15g=;
 b=Lsw/lDaCYQnmjMdfMrYIpuzg8LhlRuWeeiaM6T0sqodcuWBxRwf14qx5NDNrUyc8oO8BmziPioklZb+t7xXcJFUtCtejqBrPpp3Y6K08qGdcEqMq9/0JTaWstTRVGGRbjulTtoRQN3ZnyxDwx3TMTJJFqA+nkPl75cQ7y0N11Ys=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:06:48 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:48 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 5/7] mlxsw: ethtool: Add support for setting lanes when autoneg is off
Date:   Wed,  6 Jan 2021 15:06:20 +0200
Message-Id: <20210106130622.2110387-6-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c69045bc-af67-4baf-1619-08d8b243ecf6
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674C188F9A79F9F8E67B1A6D5D00@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V25HXRKwepLZ41sAi4AmvZuxHH09i/8vZpUrxDOHDP+0ygdzgcMD0IrM/tnCzeVScleWWI+VHdgfaT2Hdr2xLlvdcj9K7/tSzdCIR2Q5Fe1FQE7MlXE1QLUhueedR+SOxYwarxW38MtExgtzVIowluJNrFIclxILAXj6poAbgOfecftf+tugCThyzIzXGFMDk45SEkzSNbB5L06qJrsswr3TWNz7nfFmcIxBpGWyKBhfiCrSJboYq8uX7eMVwpWjoVGDCZvmr1Mq7DjUUbqonKjScIGu67zzIXEXq+xjyeGMYL+XdQUHRyELdk6rnM4MDF5icQB1G6piZMvT3g6uVIuis5dY9oUb1l+cmc3ztAhmZIgPteG8YZhxxVmCqPvD3q5SeZAEGJtnPB0PSzwRBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(86362001)(2906002)(4326008)(1076003)(6666004)(478600001)(5660300002)(30864003)(8676002)(66556008)(956004)(7416002)(66476007)(66946007)(2616005)(6486002)(16526019)(186003)(83380400001)(26005)(52116002)(8936002)(36756003)(6512007)(6506007)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?z4Kw5+u3isHpAnVqt21rwChPTt2m/Q/j6qyaL+2SAlfTaa4vtqD5mKrBr61/?=
 =?us-ascii?Q?tlSuevGJy3MSmd5e1MevWlyaGAvuZu0tzIR3RCZNezMHavdD8+up47312TS5?=
 =?us-ascii?Q?Lmsx1sLKBCKSIlfMCnbiMkgUOGfG9Fx5nGBKwPFMxCw1ol/03I0Lx4woL+HY?=
 =?us-ascii?Q?36J+I0WVkoygcmM11lztnajAUwfBFsAgBfplsPuGuaKIZWuslP1z2kDZzNNO?=
 =?us-ascii?Q?yHVHLzbFe1SwljkWUKlhmxJig8AiysL/rtwOx7ZMdSIFLmaBDSw5AoSonzah?=
 =?us-ascii?Q?dZfybBL95G2fokx6AnaGxkJqdl4ADTqM+henzHe8rgInX5SAie8Xx7nW4OeA?=
 =?us-ascii?Q?nX3/8IIvK/yq/t8irS7B7S+YENiBY5SSZIjXsl1BDLmxmwojwGyNM3vMlx1/?=
 =?us-ascii?Q?4+wS41Cf8Tu04AI84FeJZHm8kUx1VwHYCnc9zuuQTWHJ6E3Bl5skpmuJDqgh?=
 =?us-ascii?Q?tgx9qe4AjhTvcGGaBlGTErXSb8yqmeSyJWKbiToQjIHsNemtkCfaT8z6Gvg8?=
 =?us-ascii?Q?PunQun+XSKgsaddj5HeYmpeNk2ArBmvCmARi5wX+uZft58NdvyhMfOQxXtv8?=
 =?us-ascii?Q?JWT757yl6F4w/LglmyrUi+zRtzy2nB9DBJ2hSMZSoDPdVkrPoxaGpZE8Tcso?=
 =?us-ascii?Q?u3G17Y1JrPBEHThqRJ8YVwQFKwLk9apKlP/wCD+/vzB21ZIlI0xGdVK+v9bo?=
 =?us-ascii?Q?uYBrRwaQ+pmBgxxrNf+O+mKLyryHvQQ2xLUo53QB7YtK4bTtIdyTfO7iZkJH?=
 =?us-ascii?Q?HcDBFvAmgUU1bXzpbs5mJHdCh3zFnUTxCm5nIkmKxS9q1OLt1TjKKenv58O/?=
 =?us-ascii?Q?2g4+3/mFaGYbxw7MwZbzjFOasElOxemVEYMMEuLsC4OmporhpQh3jTNFU1vA?=
 =?us-ascii?Q?3deDxtA5P2p4pkmXHov5QKtYddBPZ02XHLaSRgaISOKwFUy2dfcS7ymTZl7v?=
 =?us-ascii?Q?c5FbII55yazybWf7p0P8lwDf5BK/Wf92FG3PXox5m0Af+NgZS0RO8KeBV2KA?=
 =?us-ascii?Q?VMM3?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:47.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: c69045bc-af67-4baf-1619-08d8b243ecf6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkFTldP+yC0RV/EUMgzPH2S9jKw+svxjtFDNvV8TiFgzGHRc83L/CLYqyfAE8UhyklOAeElIK00rLcID7Wvdkg==
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

