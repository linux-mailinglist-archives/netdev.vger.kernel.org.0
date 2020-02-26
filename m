Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC3A16F4D9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgBZBNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:39 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729908AbgBZBNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mhp4np2hglQCtprwMqER4vdi48BYYfZLJXBO2kYnqG+AKXVjI7WRkZh3BJZoxC4OiYsbMCP79SyAKZz0FAXd8p/BDilChTx3S+vEQLRdhyLzvErdcb4A3kvuqiB8jcC/uz/iZsVLc+i1rQHxFSsUtMqldG2qrYIfdJjAqDX0IsnUxaUVlk0OgCsgqU2xoPI7oqBNorKLdBDuAZ8WRYNCofnIxbiIc3bO3U1ot9x8ofnTNxwdAnm9HPUNkSSiwKuFU+GFFWA3nLhz1H5cS0hfHLpNf+E+0S+RE6WLhbcLURg/ubqxlcDQf5jy244IXrFxajRrqKgQVlA9rEaNEtpBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2096awN5o0qev9DzEgQkurdFZKvy6klKbRPxvuTRbM=;
 b=Y7xmAIH6ByH5YGDNONWG11mL/yMTqrdE+P6wWpxFmdIwYrsnKZ7ZE7k70ybvq5LLPKQo1i2t1RQrBLCsiiENO/RRZu9g7XQwHlG2jIf8uZ8WFuz2pLW3Vwts7S9XJrnAjlkFmnNcngH1RGhOfwyvCtfhKZ5EDuiyv1zEB6pmCOFtz//vxriVRVkkyDiZxQ1N0cTSMoVsVz0XXpjc3AsIFURDYtiG45koKIyAzRK2AHJpZ/SngO52Tn7YTzzEcarPsLqrKndjGtJecGH7yeOlPgFFN5KzDQsEELSFj8zNfcQYjGloKo/7qcZg7grkeaunZ3n2ZEiWQzEqR0KzHCHsDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2096awN5o0qev9DzEgQkurdFZKvy6klKbRPxvuTRbM=;
 b=VAq1JHe1P8cPxavF+zGQ7IhxJ/Epz0xqsl/EsC2R1yDpa1TtftzN/IqXHaAAS+RCCSUlLtgoVgOGcV0Dm4smA8FJFpAw/LNELkp0FY4DWltVzW8b6Go/wYYcD/0fzCClZHaAUiA//HiJtTI3gTnhT+0IHrekVAZJMHtO6rpFc4o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/16] net/mlx5e: Add context to the preactivate hook
Date:   Tue, 25 Feb 2020 17:12:39 -0800
Message-Id: <20200226011246.70129-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:29 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d49b8e78-1e05-415b-45c5-08d7ba5917e2
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038CF950B827075D82BF122BEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(30864003)(6512007)(2906002)(2616005)(86362001)(956004)(26005)(52116002)(498600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWJSDYmYXiYSDvk64D4o2ic67QMjbmyX8GDieoxAwlkYCIwNolKRMv/+VkFYv5asH3vle6XdmkFV0ofi0t5yEVBVnIk7PmuDrE8OCF5COala/f7UhJB9zVMAnj66D3BMK2GvM3SJBlplfjmDNBLc5IyJIpTUwhYcjYw9/Q7XcQ3m/Y5R/wPdrcKAGv3dv2QJhfT8k9r4L9mX6Qe4XPXAG4IpDAExHHG1osPlFivwq6ZnL5Mnx/Mt7Xg9bZ3Gw4+j0NuEtFu4HEQIkhRnhbEgTI+iEvXvSXES0wI0WwYhG2RZdYEtDZFBd15uHv34o+XcRBRL+douXxiJ/RYi5/Rxod4vAmZ5jebkH2Tj1j0QG5I78i9ZFUvxB1diLMUUIZKfN/ruDCAEjSGtqJXSzVHroTHWRuFgaXoHWAM5DJck8tnrTtPw+DbjFj7BHp8S9nU8hmRB52fT70ud/Q4SfhQlnIozoUqKswBuuKDE/BDZJGzcyggho9ecC9+nwzPHHZZnSPi6QXiOS07zs6InKe6hR3s3NFm7Io6X+EU6L8tQhX8=
X-MS-Exchange-AntiSpam-MessageData: GlfE1fnzceBMU4eqE066g0XWUF+RSCV+ggqyiVcmUi53qaDTVfLehgV1Kg/GLHq+HPGhgqbnWNL7uXyqvCJ/eHWLZoiRa3Zorgl6NutxOmIxNt+1PxwkqEl+THHqO7gVSOYzcnlFhTnkSzLPGvZHfQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49b8e78-1e05-415b-45c5-08d7ba5917e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:31.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmrXPyUpzaAfb+p3l2kwAL2R8ew3Ynls+21Joa0yVCsl8/FlabljQ7SSW8sgKHS+hYQrzPvxbK4YZEOlSMPWuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Sometimes the preactivate hook of mlx5e_safe_switch_channels needs more
parameters than just struct mlx5e_priv *. For such cases, a new
parameter (void *context) is added to preactivate hooks.

Some of the existing normal functions are currently used as preactivate
callbacks. To avoid adding an extra unused parameter, they are wrapped
in an automatic way using the MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX
macro.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 15 +++++---
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 15 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 6 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6d725d2acd3d..3cc439ab3253 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1047,12 +1047,19 @@ void mlx5e_close_channels(struct mlx5e_channels *chs);
 /* Function pointer to be used to modify HW or kernel settings while
  * switching channels
  */
-typedef int (*mlx5e_fp_preactivate)(struct mlx5e_priv *priv);
+typedef int (*mlx5e_fp_preactivate)(struct mlx5e_priv *priv, void *context);
+#define MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(fn) \
+int fn##_ctx(struct mlx5e_priv *priv, void *context) \
+{ \
+	return fn(priv); \
+}
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_preactivate preactivate);
+			       mlx5e_fp_preactivate preactivate,
+			       void *context);
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
+int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
@@ -1132,10 +1139,10 @@ void mlx5e_update_ndo_stats(struct mlx5e_priv *priv);
 void mlx5e_queue_update_stats(struct mlx5e_priv *priv);
 int mlx5e_bits_invert(unsigned long a, int size);
 
-typedef int (*change_hw_mtu_cb)(struct mlx5e_priv *priv);
 int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv);
+int mlx5e_set_dev_port_mtu_ctx(struct mlx5e_priv *priv, void *context);
 int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
-		     change_hw_mtu_cb set_mtu_cb);
+		     mlx5e_fp_preactivate preactivate);
 
 /* ethtool helpers */
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 01f2918063af..1375f6483a13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1126,7 +1126,7 @@ static void mlx5e_trust_update_sq_inline_mode(struct mlx5e_priv *priv)
 	    priv->channels.params.tx_min_inline_mode)
 		goto out;
 
-	mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 out:
 	mutex_unlock(&priv->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ff7f5a931520..06f6f08ff5eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -357,7 +357,7 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 		goto unlock;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 unlock:
 	mutex_unlock(&priv->state_lock);
@@ -441,7 +441,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		mlx5e_arfs_disable(priv);
 
 	/* Switch to new channels, set new parameters and close old ones */
-	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
+	err = mlx5e_safe_switch_channels(priv, &new_channels,
+					 mlx5e_num_channels_changed_ctx, NULL);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
@@ -574,7 +575,7 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 out:
 	mutex_unlock(&priv->state_lock);
@@ -1742,7 +1743,7 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 		return 0;
 	}
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
 static int set_pflag_tx_cqe_based_moder(struct net_device *netdev, bool enable)
@@ -1775,7 +1776,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 		return 0;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 	if (err)
 		return err;
 
@@ -1832,7 +1833,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 		return 0;
 	}
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
 static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
@@ -1876,7 +1877,7 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
 		return 0;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0a71fe85d21e..d29e53c023f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2753,6 +2753,8 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 	return err;
 }
 
+static MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(mlx5e_modify_tirs_lro);
+
 static int mlx5e_set_mtu(struct mlx5_core_dev *mdev,
 			 struct mlx5e_params *params, u16 mtu)
 {
@@ -2802,6 +2804,8 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv)
 	return 0;
 }
 
+MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(mlx5e_set_dev_port_mtu);
+
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv)
 {
 	struct mlx5e_params *params = &priv->channels.params;
@@ -2884,6 +2888,8 @@ int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 	return 0;
 }
 
+MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(mlx5e_num_channels_changed);
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -2939,7 +2945,8 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 
 static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				      struct mlx5e_channels *new_chs,
-				      mlx5e_fp_preactivate preactivate)
+				      mlx5e_fp_preactivate preactivate,
+				      void *context)
 {
 	struct net_device *netdev = priv->netdev;
 	struct mlx5e_channels old_chs;
@@ -2958,7 +2965,7 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	 * to modify HW settings or update kernel parameters.
 	 */
 	if (preactivate) {
-		err = preactivate(priv);
+		err = preactivate(priv, context);
 		if (err) {
 			priv->channels = old_chs;
 			goto out;
@@ -2980,7 +2987,8 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_preactivate preactivate)
+			       mlx5e_fp_preactivate preactivate,
+			       void *context)
 {
 	int err;
 
@@ -2988,7 +2996,7 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate);
+	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
 	if (err)
 		goto err_close;
 
@@ -3005,7 +3013,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv)
 	struct mlx5e_channels new_channels = {};
 
 	new_channels.params = priv->channels.params;
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
 void mlx5e_timestamp_init(struct mlx5e_priv *priv)
@@ -3454,7 +3462,8 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
+	err = mlx5e_safe_switch_channels(priv, &new_channels,
+					 mlx5e_num_channels_changed_ctx, NULL);
 	if (err)
 		goto out;
 
@@ -3667,7 +3676,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_modify_tirs_lro);
+	err = mlx5e_safe_switch_channels(priv, &new_channels,
+					 mlx5e_modify_tirs_lro_ctx, NULL);
 out:
 	mutex_unlock(&priv->state_lock);
 	return err;
@@ -3886,7 +3896,7 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 }
 
 int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
-		     change_hw_mtu_cb set_mtu_cb)
+		     mlx5e_fp_preactivate preactivate)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels new_channels = {};
@@ -3935,13 +3945,13 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 
 	if (!reset) {
 		params->sw_mtu = new_mtu;
-		if (set_mtu_cb)
-			set_mtu_cb(priv);
+		if (preactivate)
+			preactivate(priv, NULL);
 		netdev->mtu = params->sw_mtu;
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, set_mtu_cb);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, preactivate, NULL);
 	if (err)
 		goto out;
 
@@ -3954,7 +3964,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 
 static int mlx5e_change_nic_mtu(struct net_device *netdev, int new_mtu)
 {
-	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu);
+	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu_ctx);
 }
 
 int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
@@ -4415,7 +4425,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
 		old_prog = priv->channels.params.xdp_prog;
 
-		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 		if (err)
 			goto unlock;
 	} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7b48ccacebe2..6be85a6b11d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1396,7 +1396,7 @@ static int mlx5e_rep_change_mtu(struct net_device *netdev, int new_mtu)
 
 static int mlx5e_uplink_rep_change_mtu(struct net_device *netdev, int new_mtu)
 {
-	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu);
+	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu_ctx);
 }
 
 static int mlx5e_uplink_rep_set_mac(struct net_device *netdev, void *addr)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 56078b23f1a0..673aaa815f57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -483,7 +483,7 @@ static int mlx5i_change_mtu(struct net_device *netdev, int new_mtu)
 	new_channels.params = *params;
 	new_channels.params.sw_mtu = new_mtu;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 	if (err)
 		goto out;
 
-- 
2.24.1

