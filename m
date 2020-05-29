Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F851E7641
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgE2G5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:36 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:29351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgE2G5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be39bVgfUwX2CkCDMIiKhB/xtJUDBOQ5hfI6GhelPuSIgNVoFGQxap/Q7VIrt28NLLuPNt9TYkeFKegfBEx0asGhksofQpwOMcQhyOyMHUGj8yyW54E8ueSx19ltztqBWYckEzmmY3TXMfDF1VJkJEjZ/K+btiR/EL/abt2mE2LbS2tRtHk224oNJqnMN4h8BkuL+Z0esRGZtQYaRXLSJkShR1JWMEQ7G7uEunYuXs1jlZHIANp10kId4FU8zLSMfkzpFD5nqfFSDLYCeB5mbcrp8ZHCS0+9qM3mK3E/O0SZvy3NUxHSR4tJIpCDp/pvuTSbKI88TVYdHeDtJ+VPdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNYup6IqR+8EFxGFwAD+vQ0GtSjNnvUmtzCmn1aSd1s=;
 b=Qo8WBHUZ4Ia+jY/fLksgNifZK8FZ3R88tKdAob15HDkuyHjauSW5GOapcodNZi5bf0+wxvprkiRk94zKymN8JHrFGvbHwqLvycMMmo3rpFwMeM8oOGd15pANY/xWW/kcoWMQj7Az+2TrxLcoK9/NfGdM1WhCedc3XzlkDJjL8u1+y6vbv++N0zPPVSCcMXmuVsIZ0SIKp22srR8/kNAfPW2LurZSOqWupfAfT3VZDhpe8qRxhhmEN0goGZ+5MKWFwEmRskxetlsZTweOVgEckmN9soOjbyA6ACRPbq8+JP61vEVZc3ZtTkIj6FYJp3PcL1YZw5viMPA/rduV9Kt5mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNYup6IqR+8EFxGFwAD+vQ0GtSjNnvUmtzCmn1aSd1s=;
 b=Sc1jsAUeujsfBmRTG2Jmzzx8/qDBhcE7/HanQkEIrKZwo6MO7oNQLbECyaQmiRTshr6qUzmItrPdDmaiGUPfXgKSGzYIyeTQ+ML3dLoH+42lwceyyw7rbjJJSTv6xPH5z3Kqp3CG13JJ/4dAvfFR28WT/kwRfbGhj/ybD27MpwY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4189.eurprd05.prod.outlook.com (2603:10a6:803:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:57:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Tal Gilboa <talgi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/6] net/mlx5e: Properly set default values when disabling adaptive moderation
Date:   Thu, 28 May 2020 23:56:44 -0700
Message-Id: <20200529065645.118386-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529065645.118386-1-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:23 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f02fd082-0292-4281-f50a-08d8039d8b3e
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189FB2D7047842CE5536823BE8F0@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+3CmPX0+Hz8pkElprK1aftqLQGstRWQZYZSZdy9wgyXJ0vurW7xlQ6vjrMdalagYfRxaky4Am0LZ/IyXM38rb6dL/ONMaCE9ZY7jOcfOktGTJCA9M+/OCUWAXcDLSLUJgRH0a1rdMNqGidpHRC5ITkiN6bqYhLkvmKvqlk8rymdlI7VlQg7ba4I1MuBlPGNLHcn3XmNgfKJh3ZZ7/JWlvHDspX93Bn9/XTEIO5s+XinP2kkGvY2dWK17NRdF3loY94VCs8czI6RWDrILQgQn0l+sXqXqJdy9eaRNpSrJllF8FaN3XjDhRjzY55OxrCPE4BcscleQshr5r30z+M0xwrFCJ7XJxCW5MAtFigoIrI7kSPw6bTuf/4PopDn/aGDTOCFBERLl4f638bjywxRDINqeK+cMnevs+jS8P/irCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(26005)(1076003)(66476007)(8676002)(54906003)(8936002)(66946007)(66556008)(2616005)(107886003)(5660300002)(956004)(83380400001)(6486002)(6512007)(186003)(16526019)(52116002)(4326008)(36756003)(6506007)(2906002)(86362001)(6666004)(478600001)(316002)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l8jdVXxxRQ3rnfNBl0rD1KiDvAY9oMUD+H16VXnxoFI233VG5HrLyk2IM9sGPpRTJ3SC1cUr2G43lxUWVAXhOu903JmAMygBGwLIMlRC9P3gMcGxv+883oe2kyRJAZClIWE4jk6E7VPrEL4PI2BDX6DqUhorAHFnbpayPB32XpdXEBnRSSDyLORqUmm4Mt86hTNJBJV3M9+h4PHp68V5lyALE/TY+5CZKqjr3wMJ+wsb8+jPeNtU+913BX91QB0xWyHsN8/e8k58CqFtGPdCxx+uexmh3a48TCpee0SLikxUT5h13PbK2HTChfA0ODUWQlRL8s8TDxy8XKwTK8JQZi2miEjEJG8Gxu+o8mLUuFOOgN39k6+ji/8HnXGs6LQWVGsUbqz9fdvxhKTGGy2T+/u4ZHYzVz2BGU1NdSBF7SIHi9P6jS/ElNG07t6xetPXgNgSHceOFmx95ztqEvAJJcx8hHsinBsa7m0S0Z5h4EU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02fd082-0292-4281-f50a-08d8039d8b3e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:25.5971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xQXEerEqjDQmwa6YmWP/WfKt8oRg6TPOFsnTFOfsk6uyA7vG2NbmL+VJVUfA7i1VMJrOmGVnx91I0INSiKwFGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tal Gilboa <talgi@mellanox.com>

Add a call to mlx5e_reset_rx/tx_moderation() when enabling/disabling
adaptive moderation, in order to select the proper default values.

In order to do so, we separate the logic of selecting the moderation values
and setting moderion mode (CQE/EQE based).

Fixes: 0088cbbc4b66 ("net/mlx5e: Enable CQE based moderation on TX CQ")
Fixes: 9908aa292971 ("net/mlx5e: CQE based moderation")
Signed-off-by: Tal Gilboa <talgi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 +++++----
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 21 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 ++++++++++++------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 59745402747be..0a5aada0f50f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1068,10 +1068,12 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
 void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
 				   int num_channels);
-void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params,
-				 u8 cq_period_mode);
-void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params,
-				 u8 cq_period_mode);
+
+void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
+
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 			       struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6f582eb83e54f..bc290ae80a531 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -527,8 +527,8 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	struct dim_cq_moder *rx_moder, *tx_moder;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
+	bool reset_rx, reset_tx;
 	int err = 0;
-	bool reset;
 
 	if (!MLX5_CAP_GEN(mdev, cq_moderation))
 		return -EOPNOTSUPP;
@@ -566,15 +566,28 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	}
 	/* we are opened */
 
-	reset = (!!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled) ||
-		(!!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled);
+	reset_rx = !!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled;
+	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
-	if (!reset) {
+	if (!reset_rx && !reset_tx) {
 		mlx5e_set_priv_channels_coalesce(priv, coal);
 		priv->channels.params = new_channels.params;
 		goto out;
 	}
 
+	if (reset_rx) {
+		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
+					  MLX5E_PFLAG_RX_CQE_BASED_MODER);
+
+		mlx5e_reset_rx_moderation(&new_channels.params, mode);
+	}
+	if (reset_tx) {
+		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
+					  MLX5E_PFLAG_TX_CQE_BASED_MODER);
+
+		mlx5e_reset_tx_moderation(&new_channels.params, mode);
+	}
+
 	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c6b83042d4318..bd8d0e0960857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4716,7 +4716,7 @@ static u8 mlx5_to_net_dim_cq_period_mode(u8 cq_period_mode)
 		DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 }
 
-void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
 {
 	if (params->tx_dim_enabled) {
 		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
@@ -4725,13 +4725,9 @@ void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
 	} else {
 		params->tx_cq_moderation = mlx5e_get_def_tx_moderation(cq_period_mode);
 	}
-
-	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
-			params->tx_cq_moderation.cq_period_mode ==
-				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
 }
 
-void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
 {
 	if (params->rx_dim_enabled) {
 		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
@@ -4740,7 +4736,19 @@ void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
 	} else {
 		params->rx_cq_moderation = mlx5e_get_def_rx_moderation(cq_period_mode);
 	}
+}
+
+void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	mlx5e_reset_tx_moderation(params, cq_period_mode);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
+			params->tx_cq_moderation.cq_period_mode ==
+				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
+}
 
+void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	mlx5e_reset_rx_moderation(params, cq_period_mode);
 	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
 			params->rx_cq_moderation.cq_period_mode ==
 				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
-- 
2.26.2

