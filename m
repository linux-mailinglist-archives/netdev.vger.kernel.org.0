Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA62EBE3E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAFNIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:08:14 -0500
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:26446
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbhAFNIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:08:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDYXur/TTqaa0w8/vr3kGHU6zpYepHJZZMOiZ85FNTeAXkHIu/HbXsW6orMoRCWdJUF24Wt7ZcDFvr25IfpMFvL4kNvyHhy4legGSCjjPlJTFwF1S8Tk8izlv+ShABoLMblPJvRGzJouFKwQJWUsy9oPAR0WEe39irXsJks0Z5zyMBKxi6ANTJ0QjQxS+t+F8CJLvCD6ejR5y4gi61RMaLJ9k8DoNSkM2hSXOg9R2BEb9eHuw8T8uBiQo8yvWyw9oShiIYSXkcIFDhxhsggyV+eGnimbbZgKDfbPHR9zzLaqlY6cPSCjgtn0NxNE6YYWKzXBPMjD4IOCNq62uTObFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKLk6L3XB/vKicYkbSR1skju+GfjNK/S/DzptLIddwg=;
 b=ipF5rQzgmjf+ASl5JZnvawSGdvuvvGDzTLsERaKwp1WaRN6ewjmI65R19wYmeFufVGOkLkOfH7hcty9b5JVVL9P4Ezn/RonEoPCaoC+9ZvVe0XVFlNOG2QWHWzbvrf3j4Keouxmb2IloR9LfgI4uTi4Ve3CvBRlNDJh5cnIyH3x/j29Fjun86OfOEapuUUtTr0D8FvYa0TdKKOCSpSHd6iyOr+MjUfhhxrwOrOQUhq/ox5FbzNrn5X6RkJVv4ccxmuBWWEOTLdF3rwW/Nl0xsI/g8vyzic5em5FId5Cf930bGVEbcMZsfrj/htIhpvY5Myb0cprkl8N1Lh9YTJOiaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKLk6L3XB/vKicYkbSR1skju+GfjNK/S/DzptLIddwg=;
 b=b2a8m5ErDD2WB8XoVEOxVzH2TcovxgaM0WA0QEaQoFJXPYqm3XmgQXHYTeZC8TQNQcmOGfHivUG/rkAexh1kIlDzCimQQFcFRZpyUvBRSBTYzGv24KXn+gVSHyNjS7uzmcX4Hc/JAfFPk95L0SmMwOepAJAuYnBFn2fdravRl3g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:06:49 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:49 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 6/7] mlxsw: ethtool: Pass link mode in use to ethtool
Date:   Wed,  6 Jan 2021 15:06:21 +0200
Message-Id: <20210106130622.2110387-7-danieller@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d811acad-a25f-435f-08b1-08d8b243edf0
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674030A8F5E51606CA9D448D5D00@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKSt91MD8+Ecy0crlHiE8EvFxorMyHRriihghI1CXX5FWebFDC7npPN2ErcVDrFA+YAUtIb4pnYtMjsodfqUyUcu/jJ5yiMx41R1XNa7vDGz6Y9Q4a+MqLDgVHikfex50VnriNRB56Mi+IxDwLv2Zgn2DGILtsbfhlxqAMZTgmTbnHfEj1k138hLWtM0v1lKJQ62usmb0SRAfihlZnnaOVFuYc56n0soGOfBepKw9KOwT+BM4xBIwI0vipSBetIaTJ0oGEU7G41k6fBub0KlMDt2lHPVfZS1sGxovMWt0zFn5oosEXCqcCYdyv3sNaiVRHGastPamirF3OJgjWYpuvHn/uxxLg1kyKXWzS/aYdwBpt2qhghLdSElg5SGGkxtqyP1bcFSU0wni88yDprJhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(86362001)(2906002)(4326008)(1076003)(6666004)(478600001)(5660300002)(8676002)(66556008)(956004)(7416002)(66476007)(66946007)(2616005)(6486002)(16526019)(186003)(83380400001)(26005)(52116002)(8936002)(36756003)(6512007)(6506007)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v51XN1toyFB68N+ytMtjvzgVtqIA0SXqUtW38QIUN9Ue4RyDKg91Eu1a6e7f?=
 =?us-ascii?Q?SraLKe5etf6yqG95l8nimVBGhFdDFjYRj/NuAqkPZkl5HjZ2r1fqNg+28rkz?=
 =?us-ascii?Q?ZCRJtwTdZ2Ev6G52m8ItrsGXaFSIiZV8qHUGs3l7GBjM5ZIbA+/4CQTYwSSO?=
 =?us-ascii?Q?rBy5QSXF0576I6denv7M1NeX6XdiDL+fYxLB4Vio69wPv3DAsRlSQ3bHYBR9?=
 =?us-ascii?Q?vEzzANGdmeC5NA5nwH4I+dVFbtMSkGzEYrzIvs2nqKitVuFLDY8CLYM+DRxD?=
 =?us-ascii?Q?BNFRFvGNE48UUfRPEYa7OcueH0L0y2sBP20kNHhUMaRUqskXhdsLe3FWt6Wr?=
 =?us-ascii?Q?w+sMudYxCgwelAekucAktrlFF7mvb4qDF8NYzVF0zI0fjhOQGLkbza8IK4sv?=
 =?us-ascii?Q?SliuNy+SPajQXiXRv47xoz8NF24/JiEbYBiwUvTXByPnE3E8DXBqizbRQ6zT?=
 =?us-ascii?Q?Qt4qcBQU3N2lshdwodsAyToe/NPplMGt+RVuSTNmKsANYbgZR2W8uEHLbbEP?=
 =?us-ascii?Q?XAnWLoVFswTqXcjaCqfDUa1OCmd99YesNpb7AAPpqQMKZT/BLjLx3SoKr2vY?=
 =?us-ascii?Q?Uo8q/DvR0/hPehzlfxfFX6MBPJytyA9vbm9hrfN79eGmkrdHHLjVSYRjmsqk?=
 =?us-ascii?Q?AVKATQXyBV3pc5Z7pyW1lIBUkQT60BYbR5Jvy+g2UiAqtASQHOr9WM7vv9df?=
 =?us-ascii?Q?v/jz78Enc1BiF5KCJwKo2HTNbMHKleSTXojp1GkZ3kBIQEKdrAlgS6a8Dry2?=
 =?us-ascii?Q?GnYAsxo9ZwW8OOdCfQLZ4V9w5/O7ji4AxhUve1p5Ck/5F2VJ/RVi9AWW7c1D?=
 =?us-ascii?Q?See5Pub1sRyjXJOrQsrRuj2d2NcQfgTSudoxgOKtxyl5uu/KPH4W6upVueu3?=
 =?us-ascii?Q?AJcuPtKB7sdGsBcHPqmYOqvcaUoDvusOktvVyuqaxC+RWBIxfDRFw4InCJkz?=
 =?us-ascii?Q?HzGgJqD8s+pvskpDdNbnjyMCj8OrDZs2OiabNjvsHizwIs6vA8xEI/TehuDE?=
 =?us-ascii?Q?kXyE?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:49.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: d811acad-a25f-435f-08b1-08d8b243edf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMxm0RCBjykZJCUJcrJTK47/Q1S6EiwtKrmiTPWNNcXz3QgJo7sLpWPV/ccDJ0HGPXcB3dt4dPMFtCVTMTWytg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when user space queries the link's parameters, as speed and
duplex, each parameter is passed from the driver to ethtool.

Instead, pass the link mode bit in use.
In Spectrum-1, simply pass the bit that is set to '1' from PTYS register.
In Spectrum-2, pass the first link mode bit in the mask of the used
link mode.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Reword commit message.
    	* Pass link mode bit to ethtool instead of link parameters.
    	* Use u32 for lanes param instead ETHTOOL_LANES defines.

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 47 +++++++++++--------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 0ad6b8a581d5..4bf5c4ebc030 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -331,9 +331,9 @@ struct mlxsw_sp_port_type_speed_ops {
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
-	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
-				       bool carrier_ok, u32 ptys_eth_proto,
-				       struct ethtool_link_ksettings *cmd);
+	void (*from_ptys_link_mode)(struct mlxsw_sp *mlxsw_sp,
+				    bool carrier_ok, u32 ptys_eth_proto,
+				    struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index b6c19a76388f..db2e61ed47e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -966,8 +966,8 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
-	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
-				    eth_proto_oper, cmd);
+	ops->from_ptys_link_mode(mlxsw_sp, netif_carrier_ok(dev),
+				 eth_proto_oper, cmd);
 
 	return 0;
 }
@@ -1223,19 +1223,21 @@ mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 }
 
 static void
-mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp1_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
+	int i;
+
+	cmd->link_mode = LINK_MODE_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
-	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			cmd->link_mode = mlxsw_sp1_port_link_mode[i].mask_ethtool;
+	}
 }
 
 static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1324,7 +1326,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
+	.from_ptys_link_mode		= mlxsw_sp1_from_ptys_link_mode,
 	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp1_to_ptys_speed_lanes,
@@ -1660,19 +1662,24 @@ mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 }
 
 static void
-mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
+	struct mlxsw_sp2_port_link_mode link;
+	int i;
+
+	cmd->link_mode = LINK_MODE_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
-	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
+			link = mlxsw_sp2_port_link_mode[i];
+			cmd->link_mode = link.mask_ethtool[1];
+		}
+	}
 }
 
 static int mlxsw_sp2_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1795,7 +1802,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
+	.from_ptys_link_mode		= mlxsw_sp2_from_ptys_link_mode,
 	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp2_to_ptys_speed_lanes,
-- 
2.26.2

