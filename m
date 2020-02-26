Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DC516F4D2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgBZBNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:25 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:44516
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729795AbgBZBNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN8jBBsN1oEM6R5Pr12UFlcn1obg5HoUW5RFRe0XI99dd53Nr/4hs1JlboiXV8h9DSRRTYE+L88gOzCeDNIbuSeDxx/R5J4/1fLczGJlqKTaRt6zrU966whUZ8DXSvLhLBXmufrVzytKoV0vZp6Hvzvxd1LWwf4JAh2CMCxVMvJNDclYkaujbBgXflfrJutp1geC1g8YtuvCAZl8nSZ4Vs3UbpbpokRPdYMjBiqfnM2ibPOVhwx0eEFI2dYs3SXkvtwJ4o0xK0BEpoyFz0TaRKzWgis28k9DTqFS3RdcInWrQDn1sNZ92o8O9WFTSQkGz+7hsDKUtG1yjCEAcPWD1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ejO8GvRsYa/8UbCjryHJ9OrxRfR4mwKgA5JcQ2ztYA=;
 b=oVII7AP0Ak3PhFfuq5B58FD463pU0zyrFET1ZXR3wv6CoPfMbyYSom486jxHSSsJBj0YueV6zC0N8PChBC8YIhSTkJJ6UhAdGvXDydYeApmbXrGRYEcNxmehjEo8Sv5AP9W6GYfCmhTOQsOMqMfOKdeETdbS9jwfkhcyvp3T2oam7/QoeOzlVxUHkn/zgMUUwUQrqDTiCe57YgogdtFETFzGaoQphc4deaFD5/4yAPZpOB0Ijz6rDNZ7yI6zajiRZ3sUVa26BtoS9tEO4cNSfiYLvn0nk2n215hZm73GrnovTAUxWCI+2xgss2PLkhdJ4UkT8O1ewdz9x7FkhDZ+wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ejO8GvRsYa/8UbCjryHJ9OrxRfR4mwKgA5JcQ2ztYA=;
 b=Rr+XqC6grY+njsyLSo5v+lf7V4u2OoqamWofvrka712sApNyLJaQED8BuQURA0lElG+RnU2V1YYoYeIykzzAncWv+2EMd5f3xR4itrSv01xLz56Ug2ytcfPYmfFEOFYuZHQbQgvd/1JvJZudas2GOQ5J6n2quq3xW2IO907rPpw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/16] net/mlx5e: Use preactivate hook to set the indirection table
Date:   Tue, 25 Feb 2020 17:12:35 -0800
Message-Id: <20200226011246.70129-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:19 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2101eed9-d497-47d1-beba-08d7ba591238
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB586905608BF005D68D806289BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(6666004)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HyqbbSHMOF2JBy5OxVJfcU6os/TK/gxd9XOZowDdXMQ2lEMkhiYcWHBWaC01YIWyDoyHQv0vh6V9mLnEhGgNak8DeQdMeRnlwbum1CGwZeTF6KJHMnzgxx2dokRQwUvfZqkJ4pvhta+/kX0aCCL4AmaVUo5dZMhDfBRMy5fT/9b0OFdRUfP2EEZSYH8cagh5R3p1XSxELzQ0t6EQ4pX/60nGetqZUtwpkjicjFuSqT6gKCLiuArRqnD8Uu7cLLL6ZruogICw5n4jYJ0ILLrzXe5q1Wax0K1mPbFEnCzRSvGd2FDyDaJ/Y0H9l9u33WB7gdbmEIVTjJRZnUjLQs0ATRuxO+aqoEgTQB9l8jk5fV9RTuQpDqj77X0D1Xj4j9NQ+g2QdHcAVtKq3x3b/bIdXTNs3R5ZNcOJJNzKwkk4/p/kx6cEBnR0jERtH+/F8kHPB1qPt97iYsntmHN7d+hTsw7J4vOSNhpwdvL2g353J0vnxfVLnlZCFbMdY9gwA9mi/Fh11W0shFkwySCgo3taIfZcMNz9exmy67xtERVUKSM=
X-MS-Exchange-AntiSpam-MessageData: rzzWY1Cz+v9NgUTy2xs6S+gUNHr1xr/QneZ4U9RoogOcxzmazecRqIbAfXBbpb02Bjk1BS4c7yq2nYvwVPfJUvM+vWUBVJpx1hcfS2MMStwG9v7qmj4RA1xEVhx+bwIDNOPAZTl6uL1WffgMluOHUg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2101eed9-d497-47d1-beba-08d7ba591238
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:21.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOhNFRw3YOE5eIELm0fId19CeqqQoJUoJ7/2UE0jputXyBRVNR09l/mDSp7uva9XSJm/mlq7Lt6wkctkuNAGhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_ethtool_set_channels updates the indirection table before
switching to the new channels. If the switch fails, the indirection
table is new, but the channels are old, which is wrong. Fix it by using
the preactivate hook of mlx5e_safe_switch_channels to update the
indirection table at the stage when nothing can fail anymore.

As the code that updates the indirection table is now encapsulated into
a new function, use that function in the attach flow when the driver has
to reduce the number of channels, and prepare the code for the next
commit.

Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table when changing number of channels")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c | 10 ++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index bc2c96b34de1..4ddccab02a4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1043,6 +1043,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate);
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 68b520df07e4..ff7f5a931520 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -432,9 +432,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		*cur_params = new_channels.params;
-		if (!netif_is_rxfh_configured(priv->netdev))
-			mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-						      MLX5E_INDIR_RQT_SIZE, count);
+		mlx5e_num_channels_changed(priv);
 		goto out;
 	}
 
@@ -442,12 +440,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv);
 
-	if (!netif_is_rxfh_configured(priv->netdev))
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, count);
-
 	/* Switch to new channels, set new parameters and close old ones */
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 152aa5d7df79..bbe8c32fb423 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2880,6 +2880,17 @@ static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
 }
 
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
+{
+	u16 count = priv->channels.params.num_channels;
+
+	if (!netif_is_rxfh_configured(priv->netdev))
+		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
+					      MLX5E_INDIR_RQT_SIZE, count);
+
+	return 0;
+}
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -5288,9 +5299,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	max_nch = mlx5e_get_max_num_channels(priv->mdev);
 	if (priv->channels.params.num_channels > max_nch) {
 		mlx5_core_warn(priv->mdev, "MLX5E: Reducing number of channels to %d\n", max_nch);
+		/* Reducing the number of channels - RXFH has to be reset. */
+		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, max_nch);
+		mlx5e_num_channels_changed(priv);
 	}
 
 	err = profile->init_tx(priv);
-- 
2.24.1

