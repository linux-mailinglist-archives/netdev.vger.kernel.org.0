Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796D21AD1C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGJCbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:18 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgGJCbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+WwG2CfKs0Bi17j0ynCD6BYOOFDl8BbuCAlSBLmb8izxIykh4rymnEmgyA9pUpPDVF5qUYYgh6/C/3bX1Xk6FBBIPRucV3iku5iAY3xjCwvTj6gBPscSnSrm3jPmuwr927b9sT8vL2W0af9iiFECLD7iG4IBnjbfeuUWAXqD1gpyFlUGzi58PHUxDBEeZXc40k6XAArDFhwTxjvgrnO2aFwa/t4Rq58oKJiuJb1qAPcoJ46ChVpifqs7MLQ/ONpNRmhnPDCqTa5mPwSvr2Jc8xZNdknU/DomcJQ3XqnKWE8GSwCWFAKL8mV2Zf8fvY9TPtcI3kGFJzu2MOyG0L2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkHj7dzH23a0FGt1Op2WBt8Gd2NSZ4UN3UoS6tI9sI8=;
 b=Lzf06KnDbkKGpVJ5bA8iLBKvmRipcIegE4Wtf5T+BiE18r54+tjsJWCwo1YxOA0vSi44j1NgYcXRZwUP4oFNlvvwsla8kDYZwkyoxiMdvUQ9kZmj1HkmAamtJj/2J/zjh8rMKDLweicWygLh8O6YYE83BRs5YeT3dJJciN3tuS5AubAuXQnmu+lGj/y/HvjUBc4jP+eIrymV/r/2687ra1UGtRVe/wkbVpSlykaFuchjNi7IIJZ3jf7xEvV39d/q937fTSPu2pz53+F21WWC8jWOzkshG+YTD6TWmNoG8DrS4vphUnqAx+ghdYYBZOV3yicxdv1AdZsN/YuMUnGg/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkHj7dzH23a0FGt1Op2WBt8Gd2NSZ4UN3UoS6tI9sI8=;
 b=ZJDIHZMIkFDcVfLgN7P9JaACA61IDfmf1Xa2kHUYfqV13GBnOGuHZrKXAobkNbcU3kBpOgssEN4oXJFkmqd1sPLNO6Q/++lUEynExAEH9jBhIQgxQd5FmRfhFahhvI0t3HWVu8edgSRO66a3RKpWWrMeFdtyBFKbEsgMyUJk110=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:31:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:31:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 7/9] net/mlx5e: Fix 50G per lane indication
Date:   Thu,  9 Jul 2020 19:30:16 -0700
Message-Id: <20200710023018.31905-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:31:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8038fb04-4eed-428f-487e-08d824794a8b
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB712089DFCF13FA0DD0B933D4BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNrPBr69PxRXjzDmFYbPsYzVOaFm83D+adnJACdsQjcCKPU6qRB1k+vz5ouAtwVWM3kh9C9KEgG8XmnRgWtsFMgcJT3w5IVxCpu3h3ylcupfBiMf/GTFuKFSAbvOMkZcOZt7CEDJ0a1BmXnJAIWWiR3ctZwXRvP/EmYuAZwHOqdKAkWCPK19ue5Q0V5hkD+h7e7B1RvEEbuBRxwQD9Ibij77qh7ly+wKHlTVr1IRdDSOMYFjdkKxOd+/bZr56YxGOvQfEdoNt8dfiEBAWFUxf2s8l3wB99B0EBqzI70wV3tqsEVNIw/5p24NHYz6NshzPb0jKJ99NfuNfcCWEMPelTt8xDf1AOR/mXksRU8J3Oz5SQnPyJivLCQmgKoLNHtQHM8B5XfhSUUuXwK9WNE8e0miQlhqVxKVZ1m3EKfXY5k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LT7jTFLomFei3q93HZ/PUP4hLmFVo8RYJCyMLSvQSwr0/fEBB3nBjtB7+Pm69L9vpOz4Mo0EJqgCH/d+mvQ0Cy8f9ZG3O+P0QSQrXr2uK+lzYnZ3CLmb4E4f+YV1s5MTz77x0tuPtN8dF2PM+9jSP/qhjk3TcLOAqkiZPjh1/xiFydlLV1wXY+wkvmR+L24WEk8S9dL+8VpfXqlPZxxetKP4QO7jgzlsvutQL6re+Ckxa2A85cMvmpECFjiMxLvQgAd2CMVowQ+n/uy0n5dUoUn1Xlqn8BY21J5fklcOJ41Etx0otelWViEDZiYcRgtFSIv27xQdThlM1zqI6cle16Bd4fRtCyPcNzx2jYniRnE4ubDQSTk4edD4xoRmKs1la3j90OYhoOTXXHrM/iWzbg9SL57KAoVsj4RG6U/YtARzcU5JK/hmlxseiXTwRiGY1fK/LTJHK8ZT8fNcDm92Jw+6X0Fz+tKYwPpHeJo/nzo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8038fb04-4eed-428f-487e-08d824794a8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:31:03.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7WW2LfSi5AV2o4dPaxwHvXPy7qiSmYpAnWopQP8rbP4r54lej7mDDpnUme/eefH3h57GhlrlJLzdzMs+3rLBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Some released FW versions mistakenly don't set the capability that 50G
per lane link-modes are supported for VFs (ptys_extended_ethernet
capability bit). When the capability is unset, read
PTYS.ext_eth_proto_capability (always reliable).
If PTYS.ext_eth_proto_capability is valid (has a non-zero value)
conclude that the HCA supports 50G per lane. Otherwise, conclude that
the HCA doesn't support 50G per lane.

Fixes: a08b4ed1373d ("net/mlx5: Add support to ext_* fields introduced in Port Type and Speed register")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 21 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  8 +++----
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 2a8950b3056f..3cf3e35053f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -78,11 +78,26 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
 	[MLX5E_400GAUI_8]			= 400000,
 };
 
+bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_port_eth_proto eproto;
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
 static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
 				     const u32 **arr, u32 *size,
 				     bool force_legacy)
 {
-	bool ext = force_legacy ? false : MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = force_legacy ? false : mlx5e_ptys_ext_supported(mdev);
 
 	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
 		      ARRAY_SIZE(mlx5e_link_speed);
@@ -177,7 +192,7 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 	bool ext;
 	int err;
 
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = mlx5e_ptys_ext_supported(mdev);
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		goto out;
@@ -205,7 +220,7 @@ int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 	int err;
 	int i;
 
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = mlx5e_ptys_ext_supported(mdev);
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index a2ddd446dd59..7a7defe60792 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -54,7 +54,7 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
 			       bool force_legacy);
-
+bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev);
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ec5658bbe3c5..c2464c349117 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -200,7 +200,7 @@ static void mlx5e_ethtool_get_speed_arr(struct mlx5_core_dev *mdev,
 					struct ptys2ethtool_config **arr,
 					u32 *size)
 {
-	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = mlx5e_ptys_ext_supported(mdev);
 
 	*arr = ext ? ptys2ext_ethtool_table : ptys2legacy_ethtool_table;
 	*size = ext ? ARRAY_SIZE(ptys2ext_ethtool_table) :
@@ -883,7 +883,7 @@ static void get_lp_advertising(struct mlx5_core_dev *mdev, u32 eth_proto_lp,
 			       struct ethtool_link_ksettings *link_ksettings)
 {
 	unsigned long *lp_advertising = link_ksettings->link_modes.lp_advertising;
-	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = mlx5e_ptys_ext_supported(mdev);
 
 	ptys2ethtool_adver_link(lp_advertising, eth_proto_lp, ext);
 }
@@ -913,7 +913,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 			   __func__, err);
 		goto err_query_regs;
 	}
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = !!MLX5_GET_ETH_PROTO(ptys_reg, out, true, eth_proto_capability);
 	eth_proto_cap    = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
 					      eth_proto_capability);
 	eth_proto_admin  = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
@@ -1066,7 +1066,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	autoneg = link_ksettings->base.autoneg;
 	speed = link_ksettings->base.speed;
 
-	ext_supported = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext_supported = mlx5e_ptys_ext_supported(mdev);
 	ext = ext_requested(autoneg, adver, ext_supported);
 	if (!ext_supported && ext)
 		return -EOPNOTSUPP;
-- 
2.26.2

