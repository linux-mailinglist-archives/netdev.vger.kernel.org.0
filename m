Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC44D5B84AD
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiINJPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiINJOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:14:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35AE78BD1
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRHbEynEWRnCl/lSJwOv5yFeVbe0aNeGg9O2AWQ+60bB5SukFvFMUCLgfpSJX3eUsFwHKrAjvm6I66xDU6gXs8lJq6FHdtdThMWeYiCeGp0zjimj8rkoOlZWZlZxGf1TNPZn/fVIesCA3e7/do9jqQ7uFkkIhIto5yUmiWi1dEXykp2pYOjnppk0GddhRcXKGkDBI/ntNNc05Xp2JP0T3kGTvz0d85D5+Ef6ElMClScyxgsU83kmEWCquCn5uss1HxDYI2UETRfzXlXBJPH30idRDQKfOUg7k3Qwffid34Xijl/uQL2NFPwIz92Sg2InAOCyk+2Z+i49s0XhH0ITug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjtLOhhRy1HTVEl7QIybVGgFTc+Popk3PmxyzdvotSs=;
 b=hWoyd7UQGslbqQ2cKM/VeQye3UzaomKM53CIq/brHYRlfxpcYNPLTAaWRuU1BZ+2yp+fUWC3ytdzE1dtgwqfpsxzYOLbh+HVcXr+mi/5IoK4x1c9cJJxsBT16f9D9eMxi5zfdIxY+NyRad9rSOQk2CkebSOZzGjvFVJ95+0E5+xb8zgVPzY5RTvfDrYUkdauI8XT1TypZ3BHUmQi1tnZ4K334ooNIRYN+/9/RlfpADZX0WBMMgvvqk4+zPHAyRupCQ8H+MNaIoYhEgP8JjxyiyTtTVHLCjkhf37UbsGeDl8BobZYOk1lhJoR+d22K/ERPkZa7A1907KYdAMB0GxUOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjtLOhhRy1HTVEl7QIybVGgFTc+Popk3PmxyzdvotSs=;
 b=MKKXOkMgpQU6TFdwDGtYF6x7pvpbPPKh8tMiJ7tfv6c4PLyqJWe+Zv9FvvAGALycTux8wdhaRFiELXvI81kdyhohyuktJs6XoIkgxRMslRdWBU6mZZZD7MvBDG3H2Ee6TBpBHIuYwLb8fzr0rXghDPwmT1sCgetVFz9ThpKHDx/PN7uCgQJpJztZGjoa1+WzJi0autk/TX74mlqgpnQ/RphqPSOfgAB3117Ga/0npVDZGXuda5LBiaI6AImBz3rFu8bfQnAraMmze3JxYOMz3re1kEWxUZAXlvZ/TgAxKHO2UC06oYH1qdm0G+tyBFjSEM6p4MCb+goAwswGcCJcuw==
Received: from BN9P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::24)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Wed, 14 Sep
 2022 09:05:51 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::b6) by BN9P220CA0019.outlook.office365.com
 (2603:10b6:408:13e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 09:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 09:05:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 02:05:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:35 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:34 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 02:05:32 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 4/4] net/mlx5e: Support 256 bit keys with kTLS device offload
Date:   Wed, 14 Sep 2022 12:05:20 +0300
Message-ID: <20220914090520.4170-5-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914090520.4170-1-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT049:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: ee032f7a-0507-41ec-01d5-08da9630522d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCZqK30b+f8s8NycXktzOkxL0PB1CLQy/9kAzmMvVzlzRvV02ewrWxwTjj0GPy0Gwjn0Lq6EBI+T0LcfxHhl4B9c93G2XEilzH269wtxW6zdqMjS/Xx9ykXb5nrd19yPtb7BDIaU26thZzVYY/lskmnYQ6RYBhmMr8kBSd1uV0DrXP3i0wagKBPW0ytTMtmvF7NsTzBl0OdVPOVl51sL3ht7FUvQ+qWxz4sRwJlSTTN0fkcWx6JPm3wmjqitEzzXvqSgw/aL17N4n03DDGeOEvewVJdcjwIyWFXAnJGNI3kVqrY1Qw9KzIfKsH7W8bp/snb/XvEikzWSRL9Tfb4WSYnmWP2l1m197MQPnMKy0v2RzSn/p+QvwgBv4pRUERnRZ+Y9b/+MKoNouOCWhnxKlSGewbkjds1RBPT7zSDzyAWl8NzZWn776fOC3bO4ygaQlwkNneiBjBCnu97YgIJuMV3dfAyRq3pFeeL3CFE9zfHhceT/vHZ1e/hDBWk00Lt0QWUeTPOZQ9xZwpD7RFX19o//Fd8KM7H0V6uKcBmmGfSRPji2BddZfgvAn95j1PITh5AXEof+UuXXogbaKcNeaTxUlyKpNqqJ1DY5QQyyUAuszuveFH77d48Bp7tmU5l24tJ8UKP4zCESGrZaosbIrdTsMw6B4GK39tsMtnO0vb8aiuKEBOQNlYhUjtImy0yz5I88H4MvyeOoMvgEtbhfQMYLGomKWeeXsln8ieeKLcqP7gLZ00Wikqhqrv9XvF7ACAmG2ccRQtgOBfXvVr6mUA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(70206006)(107886003)(41300700001)(26005)(4326008)(356005)(2906002)(36756003)(82310400005)(186003)(47076005)(40480700001)(54906003)(82740400003)(7636003)(2616005)(40460700003)(8676002)(6666004)(36860700001)(316002)(70586007)(336012)(1076003)(86362001)(110136005)(83380400001)(8936002)(426003)(7696005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 09:05:50.5437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee032f7a-0507-41ec-01d5-08da9630522d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 256 bit TLS keys using device offload.

Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 ++-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 43 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 41 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   | 27 ++++++++++--
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  8 +++-
 5 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 948400dee525..299334b2f935 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -25,7 +25,8 @@ static inline bool mlx5e_is_ktls_device(struct mlx5_core_dev *mdev)
 	if (!MLX5_CAP_GEN(mdev, log_max_dek))
 		return false;
 
-	return MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_128);
+	return (MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_128) ||
+		MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_256));
 }
 
 static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
@@ -36,6 +37,10 @@ static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
 		if (crypto_info->version == TLS_1_2_VERSION)
 			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_128);
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		if (crypto_info->version == TLS_1_2_VERSION)
+			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_256);
+		break;
 	}
 
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 13145ecaf839..25b8d82b9d69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -43,7 +43,7 @@ struct mlx5e_ktls_rx_resync_ctx {
 };
 
 struct mlx5e_ktls_offload_context_rx {
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	union mlx5e_crypto_info crypto_info;
 	struct accel_rule rule;
 	struct sock *sk;
 	struct mlx5e_rq_stats *rq_stats;
@@ -362,7 +362,6 @@ static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync,
 static void resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx,
 				    struct mlx5e_channel *c)
 {
-	struct tls12_crypto_info_aes_gcm_128 *info = &priv_rx->crypto_info;
 	struct mlx5e_ktls_resync_resp *ktls_resync;
 	struct mlx5e_icosq *sq;
 	bool trigger_poll;
@@ -373,7 +372,29 @@ static void resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_r
 
 	spin_lock_bh(&ktls_resync->lock);
 	spin_lock_bh(&priv_rx->lock);
-	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
+	switch (priv_rx->crypto_info.crypto_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =
+			&priv_rx->crypto_info.crypto_info_128;
+
+		memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be,
+		       sizeof(info->rec_seq));
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *info =
+			&priv_rx->crypto_info.crypto_info_256;
+
+		memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be,
+		       sizeof(info->rec_seq));
+		break;
+	}
+	default:
+		WARN_ONCE(1, "Unsupported cipher type %u\n",
+			  priv_rx->crypto_info.crypto_info.cipher_type);
+		return;
+	}
+
 	if (list_empty(&priv_rx->list)) {
 		list_add_tail(&priv_rx->list, &ktls_resync->list);
 		trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
@@ -603,8 +624,20 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 
 	INIT_LIST_HEAD(&priv_rx->list);
 	spin_lock_init(&priv_rx->lock);
-	priv_rx->crypto_info  =
-		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		priv_rx->crypto_info.crypto_info_128 =
+			*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+		break;
+	case TLS_CIPHER_AES_GCM_256:
+		priv_rx->crypto_info.crypto_info_256 =
+			*(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
+		break;
+	default:
+		WARN_ONCE(1, "Unsupported cipher type %u\n",
+			  crypto_info->cipher_type);
+		return -EOPNOTSUPP;
+	}
 
 	rxq = mlx5e_ktls_sk_get_rxq(sk);
 	priv_rx->rxq = rxq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3a1f76eac542..2e0335246967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -93,7 +93,7 @@ struct mlx5e_ktls_offload_context_tx {
 	bool ctx_post_pending;
 	/* control / resync */
 	struct list_head list_node; /* member of the pool */
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	union mlx5e_crypto_info crypto_info;
 	struct tls_offload_context_tx *tx_ctx;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_tls_sw_stats *sw_stats;
@@ -485,8 +485,20 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		goto err_create_key;
 
 	priv_tx->expected_seq = start_offload_tcp_sn;
-	priv_tx->crypto_info  =
-		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		priv_tx->crypto_info.crypto_info_128 =
+			*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+		break;
+	case TLS_CIPHER_AES_GCM_256:
+		priv_tx->crypto_info.crypto_info_256 =
+			*(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
+		break;
+	default:
+		WARN_ONCE(1, "Unsupported cipher type %u\n",
+			  crypto_info->cipher_type);
+		return -EOPNOTSUPP;
+	}
 	priv_tx->tx_ctx = tls_offload_ctx_tx(tls_ctx);
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
@@ -671,14 +683,31 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 		      struct mlx5e_ktls_offload_context_tx *priv_tx,
 		      u64 rcd_sn)
 {
-	struct tls12_crypto_info_aes_gcm_128 *info = &priv_tx->crypto_info;
 	__be64 rn_be = cpu_to_be64(rcd_sn);
 	bool skip_static_post;
 	u16 rec_seq_sz;
 	char *rec_seq;
 
-	rec_seq = info->rec_seq;
-	rec_seq_sz = sizeof(info->rec_seq);
+	switch (priv_tx->crypto_info.crypto_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info = &priv_tx->crypto_info.crypto_info_128;
+
+		rec_seq = info->rec_seq;
+		rec_seq_sz = sizeof(info->rec_seq);
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *info = &priv_tx->crypto_info.crypto_info_256;
+
+		rec_seq = info->rec_seq;
+		rec_seq_sz = sizeof(info->rec_seq);
+		break;
+	}
+	default:
+		WARN_ONCE(1, "Unsupported cipher type %u\n",
+			  priv_tx->crypto_info.crypto_info.cipher_type);
+		return;
+	}
 
 	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
 	if (!skip_static_post)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
index ac29aeb8af49..570a912dd6fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
@@ -21,7 +21,7 @@ enum {
 
 static void
 fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
-		   struct tls12_crypto_info_aes_gcm_128 *info,
+		   union mlx5e_crypto_info *crypto_info,
 		   u32 key_id, u32 resync_tcp_sn)
 {
 	char *initial_rn, *gcm_iv;
@@ -32,7 +32,26 @@ fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
 
 	ctx = params->ctx;
 
-	EXTRACT_INFO_FIELDS;
+	switch (crypto_info->crypto_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =
+			&crypto_info->crypto_info_128;
+
+		EXTRACT_INFO_FIELDS;
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *info =
+			&crypto_info->crypto_info_256;
+
+		EXTRACT_INFO_FIELDS;
+		break;
+	}
+	default:
+		WARN_ONCE(1, "Unsupported cipher type %u\n",
+			  crypto_info->crypto_info.cipher_type);
+		return;
+	}
 
 	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
 	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
@@ -54,7 +73,7 @@ fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
 void
 mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
-			       struct tls12_crypto_info_aes_gcm_128 *info,
+			       union mlx5e_crypto_info *crypto_info,
 			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
 			       bool fence, enum tls_offload_ctx_dir direction)
 {
@@ -75,7 +94,7 @@ mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 	ucseg->flags = MLX5_UMR_INLINE;
 	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
 
-	fill_static_params(&wqe->params, info, key_id, resync_tcp_sn);
+	fill_static_params(&wqe->params, crypto_info, key_id, resync_tcp_sn);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index 0dc715c4c10d..3d79cd379890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -27,6 +27,12 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx);
 void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk, u32 seq, u8 *rcd_sn);
 
+union mlx5e_crypto_info {
+	struct tls_crypto_info crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 crypto_info_128;
+	struct tls12_crypto_info_aes_gcm_256 crypto_info_256;
+};
+
 struct mlx5e_set_tls_static_params_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_umr_ctrl_seg uctrl;
@@ -72,7 +78,7 @@ struct mlx5e_get_tls_progress_params_wqe {
 void
 mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
-			       struct tls12_crypto_info_aes_gcm_128 *info,
+			       union mlx5e_crypto_info *crypto_info,
 			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
 			       bool fence, enum tls_offload_ctx_dir direction);
 void
-- 
2.25.1

