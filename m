Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80D1E8925
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgE2Uq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:58 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbgE2Uq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2SmfXCux93pNrYsoMkQ+9bh5MSJhg2PJsO9kuznGHJ5WWVVTY8wCDWt/1c/NS8BZecXVwVLmF1MJDPK7T/53GG4dOkSqtad6fZNN/vHIB/gMmTTPO+3S/7jw+82Z/EUC3AclfNNthvkq2U1tA3bbwKhssXaTNmEZoiEcHi9uzujO4gvOSIM/7vCyGMHYs7PkYfoSUWwWeF5kzdq+KA7ARiOXjwWKKOBHS9V/grNHzbXWqEUo2Ie6BOzULNr8Soug6iK+LXV+/z/0LWlcCeT55VQh52hjBvk0x8wQMSIokn95odXK7hNEvQl2MPwYMLsk63s5QD5U45rfY2fZrtGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNYup6IqR+8EFxGFwAD+vQ0GtSjNnvUmtzCmn1aSd1s=;
 b=UOwntRIYA//YITJPIOXizxBTYpAeUUjjfzOpY+h24/Php/lYY2ybjZVTXFh+ZYsp/Cikrvzdgxcp6x07H0RdkZhDKzw9QO2YV+myAFW6Qwlz1+ILc8ggLkpECYEntXAq+DqIRPtScL5AXJ54Igdz2buZBy0Rdldtcm49s0+YcBtQK8zz/As9LVgZpc1/zL9oE+FHza8r04iC8harcTvjLWnXiaoD7vcPJQ7EIUglt7alPiCtTBJWc2KGCc67mBqoVw+aLMTEdDqOHpPQfMLjI0qiHDAzj+OobxeSXSNITo95Gd7ufw92/DqPxDsHIKD/hSLoocqXchgTyn4E6zCUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNYup6IqR+8EFxGFwAD+vQ0GtSjNnvUmtzCmn1aSd1s=;
 b=XrcWOYWIj78ycG8otAm80RUejs7Z9MJoBzNZjroHg/tzzFN/K8fH0FEAcwCazLqPlhA9sNV3ewSSrR3JdLV9OFRbAlOUfo18y8EGxSCKv9Y43B7ftgTHBGUGh+ntQLDdot1RyJpEWQg+tFwwBA47fiiQypuDrIHFYIrxdMJdK2c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tal Gilboa <talgi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 5/7] net/mlx5e: Properly set default values when disabling adaptive moderation
Date:   Fri, 29 May 2020 13:46:08 -0700
Message-Id: <20200529204610.253456-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8d75146-67c5-46f4-cc7a-08d804116a2b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB33590449970F162C8ACAFE25BE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TT7fL7TqHM9GMSplATI/vO2wEvwjwewHcn23eCL9hBCKoHjvuA2w/JYa3MeihoRfaJ8VGeIm4ABxOEIkI/G9lY9p4w4DNlgGkHPv/Bp6QXTOYObuTotsXZpYFmLR4R1D5ziN4k7f+j96jby7WX5Di13UKoY+hez5B93D2gEW8/y5nI+MugqJ5IXSQ8RY2HeVbRK5uX0UFHlSLSb4eDJ6ASoQ2glx6U+w2Wr/vXAQKJBmR3kxIDim6Xx6CffVI/WXEKaZopRXO5a4TPNpc5CN3ie0cF9MOKu/ERqUDpi/chr2cKnzphdu4rXePc40ghQ6i4YaiVDsEcegJJUZjlqVGtEBwCQwnVTGvF7YujOzcSOjPE/LMJU6L879W4lnIb+/MEEuZXIVF7yeJQNoGXgyT36nNoZcDWd2Azio7HiLwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G/Hsm3+aztcYBF6o+bHtDiLxoRTy9pSuGJH71r+ZFsd4iAm/2aWJi9LosjpnSbgyBbJNf9NIaFoeMRGrKDGsE86In65t6sRwfvOyVULcm5/+Y6Ex2y7zacXqVU46UvAoFzZoF2enQK+utVfWMLYaJO1fcXfcQGTwiuKRKb7SsTd/5Eb4FASpvjxyC86Srs9wUr8IeZXGyESe6bVcYl/9km/8n0cu0qJFkxc5l63R2XUlhxBmoIvl70XjJlhXqfEo/pQZ8n4bDZDz72Sf1LScVrvTpVL8X+iwK/pMExAjmJIKNvy4oxu3HBQq7NjLLSYtSYYGvE8QQqoS49uDi2h6O4H6HomELJGC9v0VA0r9dchiFgAr5VQHPVm0Ihz0aiAqQ+SgX2sXKji4YfAV+KDZ+uhpKfBTSXiltA774JaffuGp7ZDcox010k7EzwA4wn0v9LacqXt+MiqdoszecRgynllnH4YivBmGVXGg6dPymF4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d75146-67c5-46f4-cc7a-08d804116a2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:51.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXZHG9BQDkWW4k0Bn/IHPM18rHERLlYxjToLDGVcxgJedb/05mwqu55itgvMaUjiNlv5e0VNzs8DaRf0tjRclg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
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

