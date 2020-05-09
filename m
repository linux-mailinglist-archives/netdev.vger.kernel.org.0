Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1818B1CBF00
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgEII32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:28 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4/YnSPMR4j2764GvJNLIaqTCcuJjBytV5/zJcQJH/W4ZtJ4l3lJDsvrKeobmuffrGF6/VLU5HCUMxfUmkKecvL+4wPLuvoVqT0k4qYFyDb27ce/tgY3TwPt8nsmBNUbHS5R1wjtLx4k5kCT1TrJcPr0m+F/A4BIFR/zK1TrwkP1vyaHoIPgYhb3o7F898T1YDE5kL6peIbv8LUONmtrh4rwDZ8ky4oyXI/5XoQFGEPoK7oJTBiL1jT/gzJfDXJv65YXCuvBNzXyfswsfvJ9vY2EoiSKLJQidwH+eywiRPvD99NZiQg9Ov1oC/ClHsS3SKykU9+z3SurDT97lsfSaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM1yx8ezrVNvlLpnBv3b5sfl8R99sK+XHhhARqGN/io=;
 b=GQdAIgs4Kq1t+OCh8InInyab61nNx9DkgMGqTx6iWqMetsH/+KtVhHQB3hf1FjC84Fc94tMiURg/IYgKUFb30nXOElDC9iBCEcykoNbBhNHfC08R6LWJXDtjXmYVGUek8bwvKWqx425LS8gZEjmr7Dz3V1jUHZqkFhvFUWiFRTItZp+EGrBpctrdO4jSZjn90raz5ooPfDX29CeakSh6Wv7xn4ppGaiD3lIILVyga9KT12T76hUsbcmqen7uGvDYhk1qL18lPWU4iG+cdXmOI4Lu1GEHQ1kREkIXLsXxIhyO8N/5mAySPo9WPPkTTunkh3vAOQjqujxPdQK4lp++Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM1yx8ezrVNvlLpnBv3b5sfl8R99sK+XHhhARqGN/io=;
 b=sL8RbYrGzbqswD3bC8kCmTscgD7Ci6YQgbZd6DtaFl38yBJO21luSypR9bcyHB2JbMouk5MmnGKx8EVAA35VOazVwgFl2Bk9NUEL5427pjZHFp/pQ8qIRMCm6p/U1jS5yAi+hEFsbrDVNFCwFvrl0jewdlUc2qtjeb1jv0mB/Ns=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/13] net/mlx5e: Unify checks of TLS offloads
Date:   Sat,  9 May 2020 01:28:45 -0700
Message-Id: <20200509082856.97337-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:17 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cdbb1d9c-871d-4ace-4f6c-08d7f3f31164
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB48138E31069F47CEEDFCEBA8BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jl2JvySZsaK5/gkmtOBQK94OdhwPk846vzREz7Y25GqCVvmXJCMR0jY558k2CqAjJYPTgSVUg1VpxWA4AcFJJY8jgqvrIhrRLKvbvUqaQgB3CiEVXEtZT74sYpObN/c3vpK81ZtJDtFyFKyyJuMYdQyfjMAziHIbIjPVebdyj8/DqxYJeNwKSXoAVpvASh18pWGknTtRaGgQr2RnL7MpTuQFLkh1DKSepWXMi+WQxjZ2kSzURIc617HmfaXBwu6626RPcxHbAP/jvWxTY7qBOpVpmq74P/42bAfrKFLLWNZ7llnZED4dmN+sTYTeh0wUxcKuRmKTeJnOkgkNYmCoycZ1jpoo706XNRWrIquAD9IrZj4+IfvwniqqVt+eiqSy2vQHNwUJGjGNqVw7B/UMJ/bgXpb7T4QJSCCE8lvlJPlpLKBt1suIHoj+SM8GerCe9rM1sPA40fE74au2gUcnkuNfmb9R9Sglpve0OCIOy5VzFCDcYFJNOjXgrXQse5gvl3Kn5IhOmoJUqe+kQX3P3yil0UT9uR6ggzkRIxcLiKLV2VBhnmNdDJfgqu9SYsp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(4326008)(6512007)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(54906003)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C/gptVcj7VXlp72Y9eqhcKyrjqLoxwTyxN9r6u+le7ysoMFehflSDUNbglKJ4lTrqg9VAzjepLBEPZuDieeGYX/JsCN4lKRWhrr2uY0k6Cxh0fONYd/7Nc809nAhQHZhpBGd3pZwtUBj6f7uj+NOqkoRr8ujB38ewRBs0ZXkt3l7/Ycq4wPi+8253Gm9I/HcBtd5bya+7WBs0o46s6/CoeFPKEgoRkcXMWFdXWKyBMDpp/kppzwPJYbtx3pDZasCws+QCZfFBX8H5aRi2k5VzjaOploqV6RDAW4UUXO3isyYsWnZWPtg1W75b8EZRXnnByJ9AqvIh0LUzTOerJMuUiQU3PLfTSjAPB9HeQmA+QhDTj6TWhE9knOsZuKMV0BIBVXYCqwQ5wq25AqNtfsBMQOdIUK3Jw0aVmYRWOH1+8y4Hj1oPvD0ULhA40bW4x9aK26VMlyT5GG+ayI7uIlMGaN9v/A74EM6DyBufeMKnLk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdbb1d9c-871d-4ace-4f6c-08d7f3f31164
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:19.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8uMiuolr2IGKUtpdhkvcgsXSVX2hX4z8YA0pBbYd6GKc8tGECxr0H3KFxMoKN/vQqYA/NqO9cFsnvYlQbltiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Both INNOVA and ConnectX TLS offloads perform the same checks in the
beginning. Unify them to reduce repeating code. Do WARN_ON_ONCE on
netdev mismatch and finish with an error in both offloads, not only in
the ConnectX one.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h |  4 ++--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c       | 17 ++---------------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c      | 14 +++++++++-----
 3 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 742aca8782d6..81f8b7467569 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -95,9 +95,9 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
 
-bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			      u16 *pi);
+			      u16 *pi, int datalen);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 8fcd14803558..c61604f3722c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -413,28 +413,15 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	return MLX5E_KTLS_SYNC_FAIL;
 }
 
-bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb, struct mlx5e_tx_wqe **wqe,
-			      u16 *pi)
+			      u16 *pi, int datalen)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
 	struct mlx5_wqe_ctrl_seg *cseg;
-	struct tls_context *tls_ctx;
-	int datalen;
 	u32 seq;
 
-	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
-		goto out;
-
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
-	if (!datalen)
-		goto out;
-
-	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
-		goto err_out;
-
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
 	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index e8f2c214a8de..26c59cfbec9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -266,9 +266,6 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	int datalen;
 	u32 skb_seq;
 
-	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
-		return mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
-
 	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
 		return true;
 
@@ -277,8 +274,11 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		return true;
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (unlikely(tls_ctx->netdev != netdev))
-		return true;
+	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+		goto err_out;
+
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
+		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, wqe, pi, datalen);
 
 	skb_seq = ntohl(tcp_hdr(skb)->seq);
 	context = mlx5e_get_tls_tx_context(tls_ctx);
@@ -295,6 +295,10 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	context->expected_seq = skb_seq + datalen;
 	return true;
+
+err_out:
+	dev_kfree_skb_any(skb);
+	return false;
 }
 
 static int tls_update_resync_sn(struct net_device *netdev,
-- 
2.25.4

