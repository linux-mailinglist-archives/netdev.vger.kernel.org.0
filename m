Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1BB212F71
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGBWVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:21:04 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726148AbgGBWVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:21:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGh+2StCitUyq24M5ckwmN32pGsn137SRfMdH2riJOU94n/NS89vKPFWTFBGYxJ/fH4vuC030X60Xtx7yz8ELUTYspFZNBftKlmZ6e/nfW071WVRALdCZ6jCtJiOiSQziugMeHFtKwxzD/ogCQ4M1rwO6fmizIoxjhRWIZ9MmuRc+RAA2t83X/yJY7XbYLuxsYaT4Uhcjdzvaixv1gZIHa8egBEc8hUsvysC47w+2cx9c2XtO9y+cSrObC2/b53ySCXLz0v+e4zw+/QtB1B9a4GDLzEOxj4D1IylbKXKcTu4qDdw30KHCZzcb2GmC9IsZi/crTASQaRcJcDFocTnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkHj7dzH23a0FGt1Op2WBt8Gd2NSZ4UN3UoS6tI9sI8=;
 b=X7rwjbFguUJtgGWFsL7NJTZEpqTvvXAktekSqSbb+jIDNyrmuM2xujmbLWDYE3C836KXDSsru9QnDYyKJRLM6m7BtNKosZPn/OhZf7d0Dd65bX2AF5pUkiOiXmaPH5d8xVTC2UGNosBMStunTONIFoN+5bH4VQFhGza9WN5jQELc7xcEShf1a6OLFQFUHUpr4hg5zlW0tnwz6dBI3XGU7PgWtMOk1585jwyCmdCIBSzKy8h0+ezUnf5fRZ8sBv1p7RPz6OpXIz3pNwQoz24v6cQuVHobPd5/de3KK44vRsPycCw0wKzE/v94szOAmBz7ek6MWIl00NcKAhlbtGJMmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkHj7dzH23a0FGt1Op2WBt8Gd2NSZ4UN3UoS6tI9sI8=;
 b=HDWssZHEegtEVJEAWiVOfx8Eko5a2m4QU1uZjr/HNl8LO8/MxtOpEJ7thqMoeeWYdb/xYvCc1wVGLmAxjHIn8lGUi7bKA7FvXBwUbSOcuctYGilOvsGnFhxL8K+T3a1su0snkdynZISYI/NoYc8kb9KZH7SlXet81keavMPkWfA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/11] net/mlx5e: Fix 50G per lane indication
Date:   Thu,  2 Jul 2020 15:19:21 -0700
Message-Id: <20200702221923.650779-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 693e4a57-3a76-4641-dfa5-08d81ed62d20
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109D2A65D02F9EBB8904F85BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Y4zmuF6eJS2uU/cWcBnETnCKoJM81mzNrtqLkOHNgnpuqrCwAvZOucmnXv2H6YSBDSAc6fNLXKox1X25Lmd9d6J8jvAt0oENwgtpTRlrYXwK0uEQ36CozQv8NqZLAEVMuqONkmkrgdpRD1Ef19QxIAx1jdxeCQ8oGZeSCAjeuo2RLcjKiNLrnUBzan2SrKYhSBpR49YNa4qADBJOGn5Ti2ArFinbsdov27Aht5pE+UBHUm84JgAUnWjFn0j2IGdv47kj6LMELlzEGA0SEvbKX+5+ZPiL78d0KZ1EVqV6V+A5Hw1smP/mM/VIijk+kOlwRc1HrqvHzXXPS4j2tDSLwd2LW3bj6xlyZKiy9Vac+x1RfP0MT56q30L5p8TL2IBPc1arsptg3RTJcikMsTqMW0vMSDGY3RvygJexVvgrUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uPkjDO/HRHOsmhBRDZgJq+pHkv5uKZpOr9nw8vctFZMqizODFvuPgQJe8gOwdTF0vaIXZsXvU0p6udIXPUq1YNSAP+pNsGxELFJ3vz3NH6CE3uymcFAz61wG3Q8JSwTbd+8uBheJ7JWApP907P3MUjkyBWUnd4QaA7BkRa4Yxr8ubXuQID/JcgWMxxCsRNeJ2NB/lPbnk2GKf18gfhnHwn4TFJxtpocYv6EbkqF2zGGeZUf+yUSJXcPV0VcIRndIW7+I3RF7wDFWXxLMd9fgbz0w3h8MStREEgKTC+lz4hXCLPIirvvHkU7KdmtNP82FXqrBT25AGZLMGDs+Zn1pbErqE3zrBB07iBHceCrYC21wEwSwwXqW9AZ5qxvhLADEeGSGk7YzwrZDzv3lh/RareVtXW4m4RlZ9AMSuITAckExcrVvoEIkgjxvkShqxzBh+9vlZKVrfYDx1IcSPKSSahVw9hnl94JjgkLC9dBED00=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 693e4a57-3a76-4641-dfa5-08d81ed62d20
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:50.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4AIQLbC32q10/loHJSRBIP7hk+gemry+cJvoHt+Ea7BrQ6GkR1d9ppQTic/DAW4m1Qrk33uAj9kfD6rkcNS0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
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

