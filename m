Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0665B1E8827
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgE2Trm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:42 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:61282
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbgE2Trk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMfkJ9Jyn2sj7YGdEmnxLaRy2P7sgcCkXQENNzJhj1lmRePXBjJKIoltWbV696if1LyQMZ3UpZW7dhaHqPZC7CMy3Gk1dtEnzVFYsZOGmja8IV0v5UKs0zcdTXq4CXiuqugJYqX+BJ+ZEL6dcIgfj7+0Y9G67uGwEs0qLXSlIlipTSSumTcanNomPJYdBX1mo3AtxFQbxjhUr51p4LmlQI2ZnXkiYi0II6IiN7df+EatQl2hDJwmXoXC3JYfkUZ8lrOc6wUmtJZkif3zTKatT4ZRTn37Ba3VC5grhlU2aysp0VKNqNyI7q+VeTpVcgWJKRbBNqa/SNyx3U0ZvvHk1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o9wsaSYbwvy+IbsRZUQe5mZhrr1EEDeszo0Pjm07vU=;
 b=Vwl1PIVDgzL+Akmnz6SCxx0U3L1xDXRoBU84j2z/KKawOZvLXV0tWAS0fSYNIImMt49vWnexKuy4qoJTIHl3dFxiFT/5UkFapdLDK//D2Z4isM26pMM8s9vMtWtbiPUkJdMZIcgsJPXsQcH7QKMFEYRBOZ5HsQSq3FHc4TThrQRcmSEGJ/ESVrHp47LuDzoNzvds1N5nl/fXTbgqakKdfXRY6KwOoTttARzfBewaNG3QB3NJ6q+XUAQOwu0s+m1RjpFnsOXBGGLBGlnEKoFF9VnlLIy5uFSy5kA1QmPk/rbUPWl0pzcAaToDkXrfNTKfNgVhAmy8HDbDztaboeKeTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o9wsaSYbwvy+IbsRZUQe5mZhrr1EEDeszo0Pjm07vU=;
 b=fb9EdXiHb7PPzpoZfCkCGqqmRmiMDdcBbvo9QMXoYOfiAEJzQHi6yjb33D59bhBTbB2eqSnONbqYpt6KdMzrlYcz6yi0agai4dalcLjxXWbz+/InobE4epwZ6LzVHv5AZAGqXjwIXlQOmQFTVs/3h7paxTl+WuH4biZq2eX4Qpo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/11] net/mlx5e: kTLS, Add kTLS RX HW offload support
Date:   Fri, 29 May 2020 12:46:38 -0700
Message-Id: <20200529194641.243989-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0bf5b26-5f60-4988-916f-08d8040919b0
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB658935701687D1B819AC67D7BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ub3V7xsxINSkRrNaqbHNl8Ky5dVts0420Hf7GgdU0ffPuB0t+fjsbBebsVHpWwEui4CeLtQa5ErgQc28n6X1pjTvAXnWnFVS8xsbn4e+rr4YoVs2ZtrjiRxSruv+l7k0KkYG/h8cchoMVraQ5v7wqQPiMtHhDdopaSWDTw2sEDOxMlqZnPTcqaJjI4gPgwMZic5AtI5ZQ7cUmnpfYvCi4bSEdeyIGf8QOp3sU1KRGNdz//PzZThACpiOt+GfONI0aTrdazvGJAlvx5bkysHhzuQ8121b2NtDXKRfgjnj4hVuEgEfxeP13LGuqiaF9Zhv4oNzgTyofFXT6H1fSw77Dz3imWhzcJtloo052aHZH6rq9ap9m7LesDqJVUmzoRqpCCGqIw4swmlpE/D3h5rEGvifCQM1bk/cb/T2Y6wEdic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(30864003)(66476007)(66946007)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ecnHYMtlhcCbwYtcLplQMY73CcHhIAiqq8q+4UjZjFxctvRb8RO//WQTpuD4axJ1tOlqexHW0z4GAuNJRM0YpgROT2lLnZdFCOEttveG4lfg44CnDpDs1rowRWyWPSF0Z+mGcyKGD88joWnuYG1YzOKDNz9Q6slb97Hwmw2slVYyfO3C443g2ClyMolzI/z2WeLiClBkXu12JVKdxNkMiWteA1OZgOzOwCUDHlWwitvypMstxFdM0CpLnROiXUaTmWb9gjU55gS6VpE+KLzWKQFABNRKJi4NLe/4UzJwQQJBGgfPGPZrPUb2AsCbZ/YXmLYRrPHOtJFAlvmbfp6RtMUvqPQhSqaORb47yx8htzX50JTjcmWDfbJPwgp17EaqaEsiM+BBXoJnmb2Xy6ikj2SburrW70RTAQ9Gr6fgixwRvx9atJHt94qOkv8/3vap8YsDK/2+cs6ht699YtLCNxOtIqDhAUIdLsWxIqV/D9w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bf5b26-5f60-4988-916f-08d8040919b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:20.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpKo4ebCFRGNi650RT1Fc/A6CTaxLirEek4Uho9r7QNjgu11RHYiqIzy/fUR3cDfb5dAvMMSbqbvw2vSSNg2cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Implement driver support for the kTLS RX HW offload feature.
Resync support is added in a downstream patch.

New offload contexts post their static/progress params WQEs
over the per-channel async ICOSQ, protected under a spin-lock.
The Channel/RQ is selected according to the socket's rxq index.

Feature is OFF by default. Can be turned on by:
$ ethtool -K <if> tls-hw-rx-offload on

A new TLS-RX workqueue is used to allow asynchronous addition of
steering rules, out of the NAPI context.
It will be also used in a downstream patch in the resync procedure.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/accel/tls.h   |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  11 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  20 ++
 .../mellanox/mlx5/core/en_accel/ktls.c        |  69 +++-
 .../mellanox/mlx5/core/en_accel/ktls.h        |  19 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 317 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   2 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |  20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |   4 +
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   6 +
 .../mellanox/mlx5/core/en_accel/tls.c         |   6 +
 .../mellanox/mlx5/core/en_accel/tls.h         |   1 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  20 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   3 +-
 18 files changed, 534 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 70ad24fff2e23..1e7c7f10db6e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -75,7 +75,7 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
-				   en_accel/ktls_tx.o
+				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index e09bc3858d574..9f9247ddcb88d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -43,9 +43,20 @@ int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 			 u32 *p_key_id);
 void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
 
+static inline bool mlx5_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_GEN(mdev, tls_tx);
+}
+
+static inline bool mlx5_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_GEN(mdev, tls_rx);
+}
+
 static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
 {
-	if (!MLX5_CAP_GEN(mdev, tls_tx))
+	if (!mlx5_accel_is_ktls_tx(mdev) &&
+	    !mlx5_accel_is_ktls_rx(mdev))
 		return false;
 
 	if (!MLX5_CAP_GEN(mdev, log_max_dek))
@@ -67,6 +78,12 @@ static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
 	return false;
 }
 #else
+static inline bool mlx5_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
+{ return false; }
+
+static inline bool mlx5_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
+{ return false; }
+
 static inline int
 mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 		     struct tls_crypto_info *crypto_info,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 31cac239563de..ad1525aa5670b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -11,6 +11,10 @@
 enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_NOP,
 	MLX5E_ICOSQ_WQE_UMR_RX,
+#ifdef CONFIG_MLX5_EN_TLS
+	MLX5E_ICOSQ_WQE_UMR_TLS,
+	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
+#endif
 };
 
 static inline bool
@@ -114,9 +118,16 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_rq *rq;
 		} umr;
+		struct {
+#ifdef CONFIG_MLX5_EN_TLS
+			struct mlx5e_ktls_offload_context_rx *priv_rx;
+#endif
+		} accel;
 	};
 };
 
+void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq);
+
 static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index fac145dcf2ceb..7b6abea850d44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -37,6 +37,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include "en_accel/ipsec_rxtx.h"
+#include "en_accel/tls.h"
 #include "en_accel/tls_rxtx.h"
 #include "en.h"
 #include "en/txrx.h"
@@ -147,4 +148,23 @@ static inline bool mlx5e_accel_tx_finish(struct mlx5e_priv *priv,
 	return true;
 }
 
+static inline int mlx5e_accel_sk_get_rxq(struct sock *sk)
+{
+	int rxq = sk_rx_queue_get(sk);
+
+	if (unlikely(rxq == -1))
+		rxq = 0;
+
+	return rxq;
+}
+
+static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
+{
+	return mlx5e_ktls_init_rx(priv);
+}
+
+static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
+{
+	mlx5e_ktls_cleanup_rx(priv);
+}
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 8970ea68d005c..313bdbaaf9d86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -4,6 +4,7 @@
 #include "en.h"
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_utils.h"
+#include "en_accel/fs_tcp.h"
 
 static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 			  enum tls_offload_ctx_dir direction,
@@ -14,13 +15,13 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	if (WARN_ON(direction != TLS_OFFLOAD_CTX_DIR_TX))
-		return -EINVAL;
-
 	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
 		return -EOPNOTSUPP;
 
-	err = mlx5e_ktls_add_tx(netdev, sk, crypto_info, start_offload_tcp_sn);
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+		err = mlx5e_ktls_add_tx(netdev, sk, crypto_info, start_offload_tcp_sn);
+	else
+		err = mlx5e_ktls_add_rx(netdev, sk, crypto_info, start_offload_tcp_sn);
 
 	return err;
 }
@@ -29,26 +30,74 @@ static void mlx5e_ktls_del(struct net_device *netdev,
 			   struct tls_context *tls_ctx,
 			   enum tls_offload_ctx_dir direction)
 {
-	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
-		return;
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+		mlx5e_ktls_del_tx(netdev, tls_ctx);
+	else
+		mlx5e_ktls_del_rx(netdev, tls_ctx);
+}
+
+static int mlx5e_ktls_resync(struct net_device *netdev,
+			     struct sock *sk, u32 seq, u8 *rcd_sn,
+			     enum tls_offload_ctx_dir direction)
+{
+	if (unlikely(direction != TLS_OFFLOAD_CTX_DIR_RX))
+		return -EINVAL;
 
-	mlx5e_ktls_del_tx(netdev, tls_ctx);
+	return mlx5e_ktls_rx_resync(netdev, sk, seq, rcd_sn);
 }
 
 static const struct tlsdev_ops mlx5e_ktls_ops = {
 	.tls_dev_add = mlx5e_ktls_add,
 	.tls_dev_del = mlx5e_ktls_del,
+	.tls_dev_resync = mlx5e_ktls_resync,
 };
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
+	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!mlx5_accel_is_ktls_device(priv->mdev))
+	if (!mlx5_accel_is_ktls_device(mdev))
 		return;
 
-	netdev->hw_features |= NETIF_F_HW_TLS_TX;
-	netdev->features    |= NETIF_F_HW_TLS_TX;
+	if (mlx5_accel_is_ktls_tx(mdev)) {
+		netdev->hw_features |= NETIF_F_HW_TLS_TX;
+		netdev->features    |= NETIF_F_HW_TLS_TX;
+	}
+
+	if (mlx5_accel_is_ktls_rx(mdev))
+		netdev->hw_features |= NETIF_F_HW_TLS_RX;
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
 }
+
+int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err = 0;
+
+	mutex_lock(&priv->state_lock);
+	if (enable)
+		err = mlx5e_accel_fs_tcp_create(priv);
+	else
+		mlx5e_accel_fs_tcp_destroy(priv);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
+{
+	int err = 0;
+
+	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
+		err = mlx5e_accel_fs_tcp_create(priv);
+
+	return err;
+}
+
+void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
+{
+	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
+		mlx5e_accel_fs_tcp_destroy(priv);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 69d736954977c..baa58b62e8df0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -9,13 +9,30 @@
 #ifdef CONFIG_MLX5_EN_TLS
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
-
+int mlx5e_ktls_init_rx(struct mlx5e_priv *priv);
+void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv);
+int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable);
 #else
 
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
+{
+	return 0;
+}
+
+static inline void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
+{
+}
+
+static inline int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
+{
+	netdev_warn(netdev, "kTLS is not supported\n");
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
new file mode 100644
index 0000000000000..83779cbc380a7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "en_accel/en_accel.h"
+#include "en_accel/ktls_txrx.h"
+#include "en_accel/ktls_utils.h"
+#include "en_accel/fs_tcp.h"
+
+struct accel_rule {
+	struct work_struct work;
+	struct mlx5e_priv *priv;
+	struct mlx5_flow_handle *rule;
+	struct sock *sk;
+};
+
+enum {
+	MLX5E_PRIV_RX_FLAG_DELETING,
+	MLX5E_NUM_PRIV_RX_FLAGS,
+};
+
+struct mlx5e_ktls_offload_context_rx {
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	struct accel_rule rule;
+	struct tls_offload_context_rx *rx_ctx;
+	struct completion add_ctx;
+	u32 tirn;
+	u32 key_id;
+	u32 rxq;
+	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
+};
+
+static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
+{
+	int err, inlen;
+	void *tirc;
+	u32 *in;
+
+	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+
+	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
+	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
+	MLX5_SET(tirc, tirc, indirect_table, rqtn);
+	MLX5_SET(tirc, tirc, tls_en, 1);
+	MLX5_SET(tirc, tirc, self_lb_block,
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST |
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST);
+
+	err = mlx5_core_create_tir(mdev, in, tirn);
+
+	kvfree(in);
+	return err;
+}
+
+static void accel_rule_handle_work(struct work_struct *work)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct accel_rule *accel_rule;
+	struct mlx5_flow_handle *rule;
+
+	accel_rule = container_of(work, struct accel_rule, work);
+	priv_rx = container_of(accel_rule, struct mlx5e_ktls_offload_context_rx, rule);
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
+		goto out;
+
+	rule = mlx5e_accel_fs_add_sk(accel_rule->priv, accel_rule->sk,
+				     priv_rx->tirn, MLX5_FS_DEFAULT_FLOW_TAG);
+	if (!IS_ERR_OR_NULL(rule))
+		accel_rule->rule = rule;
+out:
+	complete(&priv_rx->add_ctx);
+}
+
+static void accel_rule_init(struct accel_rule *rule, struct mlx5e_priv *priv,
+			    struct sock *sk)
+{
+	INIT_WORK(&rule->work, accel_rule_handle_work);
+	rule->priv = priv;
+	rule->sk = sk;
+}
+
+static void icosq_fill_wi(struct mlx5e_icosq *sq,
+			  u16 pi, u8 wqe_type, u8 num_wqebbs,
+			  struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	*wi = (struct mlx5e_icosq_wqe_info) {
+		.wqe_type      = wqe_type,
+		.num_wqebbs    = num_wqebbs,
+		.accel.priv_rx = priv_rx,
+	};
+}
+
+static struct mlx5_wqe_ctrl_seg *
+post_static_params(struct mlx5e_icosq *sq,
+		   struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_set_tls_static_params_wqe *wqe;
+	u16 pi, num_wqebbs, room;
+
+	num_wqebbs = MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS;
+	room = mlx5e_stop_room_for_wqe(num_wqebbs);
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+		return ERR_PTR(-ENOSPC);
+
+	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
+	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
+	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
+				       priv_rx->tirn, priv_rx->key_id, false,
+				       TLS_OFFLOAD_CTX_DIR_RX);
+	icosq_fill_wi(sq, pi, MLX5E_ICOSQ_WQE_UMR_TLS, num_wqebbs, priv_rx);
+	sq->pc += num_wqebbs;
+
+	return &wqe->ctrl;
+}
+
+static struct mlx5_wqe_ctrl_seg *
+post_progress_params(struct mlx5e_icosq *sq,
+		     struct mlx5e_ktls_offload_context_rx *priv_rx,
+		     u32 next_record_tcp_sn)
+{
+	struct mlx5e_set_tls_progress_params_wqe *wqe;
+	u16 pi, num_wqebbs, room;
+
+	num_wqebbs = MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS;
+	room = mlx5e_stop_room_for_wqe(num_wqebbs);
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+		return ERR_PTR(-ENOSPC);
+
+	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
+	wqe = MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi);
+	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn, priv_rx->tirn, false,
+					 next_record_tcp_sn,
+					 TLS_OFFLOAD_CTX_DIR_RX);
+	icosq_fill_wi(sq, pi, MLX5E_ICOSQ_WQE_SET_PSV_TLS, num_wqebbs, priv_rx);
+	sq->pc += num_wqebbs;
+
+	return &wqe->ctrl;
+}
+
+static int post_rx_param_wqes(struct mlx5e_channel *c,
+			      struct mlx5e_ktls_offload_context_rx *priv_rx,
+			      u32 next_record_tcp_sn)
+{
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_icosq *sq;
+	int err;
+
+	err = 0;
+	sq = &c->async_icosq;
+	spin_lock(&c->async_icosq_lock);
+
+	cseg = post_static_params(sq, priv_rx);
+	if (IS_ERR(cseg)) {
+		err = PTR_ERR(cseg);
+		complete(&priv_rx->add_ctx);
+		goto unlock;
+	}
+	cseg = post_progress_params(sq, priv_rx, next_record_tcp_sn);
+	if (IS_ERR(cseg)) {
+		err = PTR_ERR(cseg);
+		complete(&priv_rx->add_ctx);
+		goto unlock;
+	}
+
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+unlock:
+	spin_unlock(&c->async_icosq_lock);
+
+	return err;
+}
+
+static void
+mlx5e_set_ktls_rx_priv_ctx(struct tls_context *tls_ctx,
+			   struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_ktls_offload_context_rx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_RX);
+
+	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_rx *) >
+		     TLS_OFFLOAD_CONTEXT_SIZE_RX);
+
+	*ctx = priv_rx;
+}
+
+static struct mlx5e_ktls_offload_context_rx *
+mlx5e_get_ktls_rx_priv_ctx(struct tls_context *tls_ctx)
+{
+	struct mlx5e_ktls_offload_context_rx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_RX);
+
+	return *ctx;
+}
+
+/* Re-sync */
+int mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
+			 u32 seq, u8 *rcd_sn)
+{
+	return -EOPNOTSUPP;
+}
+
+/* End of resync section */
+
+void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
+{
+	u8 tls_offload = get_cqe_tls_offload(cqe);
+
+	if (likely(tls_offload == CQE_TLS_OFFLOAD_NOT_DECRYPTED))
+		return;
+
+	switch (tls_offload) {
+	case CQE_TLS_OFFLOAD_DECRYPTED:
+		skb->decrypted = 1;
+		break;
+	case CQE_TLS_OFFLOAD_RESYNC:
+		break;
+	default: /* CQE_TLS_OFFLOAD_ERROR: */
+		break;
+	}
+}
+
+void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx = wi->accel.priv_rx;
+	struct accel_rule *rule = &priv_rx->rule;
+
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags))) {
+		complete(&priv_rx->add_ctx);
+		return;
+	}
+	queue_work(rule->priv->tls->rx_wq, &rule->work);
+}
+
+int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
+		      struct tls_crypto_info *crypto_info,
+		      u32 start_offload_tcp_sn)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct tls_context *tls_ctx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_priv *priv;
+	int rxq, err;
+	u32 rqtn;
+
+	tls_ctx = tls_get_ctx(sk);
+	priv = netdev_priv(netdev);
+	mdev = priv->mdev;
+	priv_rx = kzalloc(sizeof(*priv_rx), GFP_KERNEL);
+	if (unlikely(!priv_rx))
+		return -ENOMEM;
+
+	err = mlx5_ktls_create_key(mdev, crypto_info, &priv_rx->key_id);
+	if (err)
+		goto err_create_key;
+
+	priv_rx->crypto_info  =
+		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	priv_rx->rx_ctx = tls_offload_ctx_rx(tls_ctx);
+	priv_rx->rxq = mlx5e_accel_sk_get_rxq(sk);
+
+	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
+
+	rxq = priv_rx->rxq;
+	rqtn = priv->direct_tir[rxq].rqt.rqtn;
+
+	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
+	if (err)
+		goto err_create_tir;
+
+	init_completion(&priv_rx->add_ctx);
+	accel_rule_init(&priv_rx->rule, priv, sk);
+	err = post_rx_param_wqes(priv->channels.c[rxq], priv_rx, start_offload_tcp_sn);
+	if (err)
+		goto err_post_wqes;
+
+	return 0;
+
+err_post_wqes:
+	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
+err_create_tir:
+	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
+err_create_key:
+	kfree(priv_rx);
+	return err;
+}
+
+void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_priv *priv;
+
+	priv = netdev_priv(netdev);
+	mdev = priv->mdev;
+
+	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
+	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
+	if (!cancel_work_sync(&priv_rx->rule.work))
+		/* completion is needed, as the priv_rx in the add flow
+		 * is maintained on the wqe info (wi), not on the socket.
+		 */
+		wait_for_completion(&priv_rx->add_ctx);
+
+	if (priv_rx->rule.rule)
+		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
+
+	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
+	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
+	kfree(priv_rx);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 5a980f93c3263..9c34ffa55b328 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -188,7 +188,7 @@ post_progress_params(struct mlx5e_txqsq *sq,
 	num_wqebbs = MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS;
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi);
-	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn, priv_tx->tisn, fence,
+	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn, priv_tx->tisn, fence, 0,
 					 TLS_OFFLOAD_CTX_DIR_TX);
 	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
 	sq->pc += num_wqebbs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
index edf404eaa2752..c1f1ad32ca4c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
@@ -59,11 +59,13 @@ mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 {
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
 	struct mlx5_wqe_ctrl_seg     *cseg  = &wqe->ctrl;
+	u8 opmod = direction == TLS_OFFLOAD_CTX_DIR_TX ?
+		MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS :
+		MLX5_OPC_MOD_TLS_TIR_STATIC_PARAMS;
 
 #define STATIC_PARAMS_DS_CNT DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS)
 
-	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR |
-					     (MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS << 24));
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR | (opmod << 24));
 	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 					     STATIC_PARAMS_DS_CNT);
 	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
@@ -76,12 +78,15 @@ mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 }
 
 static void
-fill_progress_params(struct mlx5_wqe_tls_progress_params_seg *params, u32 tis_tir_num)
+fill_progress_params(struct mlx5_wqe_tls_progress_params_seg *params, u32 tis_tir_num,
+		     u32 next_record_tcp_sn)
 {
 	u8 *ctx = params->ctx;
 
 	params->tis_tir_num = cpu_to_be32(tis_tir_num);
 
+	MLX5_SET(tls_progress_params, ctx, next_record_tcp_sn,
+		 next_record_tcp_sn);
 	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
 		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
 	MLX5_SET(tls_progress_params, ctx, auth_state,
@@ -92,19 +97,22 @@ void
 mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
 				 u16 pc, u32 sqn,
 				 u32 tis_tir_num, bool fence,
+				 u32 next_record_tcp_sn,
 				 enum tls_offload_ctx_dir direction)
 {
 	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	u8 opmod = direction == TLS_OFFLOAD_CTX_DIR_TX ?
+		MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS :
+		MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS;
 
 #define PROGRESS_PARAMS_DS_CNT DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS)
 
 	cseg->opmod_idx_opcode =
-		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV |
-			    (MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS << 24));
+		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV | (opmod << 24));
 	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 					     PROGRESS_PARAMS_DS_CNT);
 	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 
-	fill_progress_params(&wqe->params, tis_tir_num);
+	fill_progress_params(&wqe->params, tis_tir_num, next_record_tcp_sn);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index a325f34831176..7d7b63ae5c350 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -21,6 +21,10 @@ u8 mlx5e_ktls_dumps_num_wqebbs(struct mlx5e_txqsq *sq, unsigned int nfrags,
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb, int datalen,
 			      struct mlx5e_accel_tx_tls_state *state);
+void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
+
+void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi);
 
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index d1d747cb2dcb6..af8117d4bf884 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -23,6 +23,11 @@ enum {
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
 void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx);
+int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
+		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
+void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx);
+int mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
+			 u32 seq, u8 *rcd_sn);
 
 struct mlx5e_set_tls_static_params_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
@@ -64,6 +69,7 @@ void
 mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
 				 u16 pc, u32 sqn,
 				 u32 tis_tir_num, bool fence,
+				 u32 next_record_tcp_sn,
 				 enum tls_offload_ctx_dir direction);
 
 #endif /* __MLX5E_TLS_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index fba561ffe1d4e..dd9bbf3830564 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -197,6 +197,7 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 		return;
 	}
 
+	/* FPGA */
 	if (!mlx5_accel_is_tls_device(priv->mdev))
 		return;
 
@@ -226,6 +227,10 @@ int mlx5e_tls_init(struct mlx5e_priv *priv)
 	if (!tls)
 		return -ENOMEM;
 
+	tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
+	if (!tls->rx_wq)
+		return -ENOMEM;
+
 	priv->tls = tls;
 	return 0;
 }
@@ -237,6 +242,7 @@ void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
 	if (!tls)
 		return;
 
+	destroy_workqueue(tls->rx_wq);
 	kfree(tls);
 	priv->tls = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 9015f3f7792d2..ca0c2ebb41a1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -53,6 +53,7 @@ struct mlx5e_tls_sw_stats {
 
 struct mlx5e_tls {
 	struct mlx5e_tls_sw_stats sw_stats;
+	struct workqueue_struct *rx_wq;
 };
 
 struct mlx5e_tls_offload_context_tx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 4d796fea906d1..182841322ce42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -278,9 +278,10 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
 		goto err_out;
 
-	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx))
+	if (mlx5_accel_is_ktls_tx(sq->channel->mdev))
 		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
 
+	/* FPGA */
 	skb_seq = ntohl(tcp_hdr(skb)->seq);
 	context = mlx5e_get_tls_tx_context(tls_ctx);
 	expected_seq = context->expected_seq;
@@ -354,12 +355,16 @@ static int tls_update_resync_sn(struct net_device *netdev,
 	return 0;
 }
 
-void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
-			     u32 *cqe_bcnt)
+void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
 {
 	struct mlx5e_tls_metadata *mdata;
 	struct mlx5e_priv *priv;
 
+	if (likely(mlx5_accel_is_ktls_rx(rq->mdev)))
+		return mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
+
+	/* FPGA */
 	if (!is_metadata_hdr_valid(skb))
 		return;
 
@@ -370,13 +375,13 @@ void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 		skb->decrypted = 1;
 		break;
 	case SYNDROM_RESYNC_REQUEST:
-		tls_update_resync_sn(netdev, skb, mdata);
-		priv = netdev_priv(netdev);
+		tls_update_resync_sn(rq->netdev, skb, mdata);
+		priv = netdev_priv(rq->netdev);
 		atomic64_inc(&priv->tls->sw_stats.rx_tls_resync_request);
 		break;
 	case SYNDROM_AUTH_FAILED:
 		/* Authentication failure will be observed and verified by kTLS */
-		priv = netdev_priv(netdev);
+		priv = netdev_priv(rq->netdev);
 		atomic64_inc(&priv->tls->sw_stats.rx_tls_auth_fail);
 		break;
 	default:
@@ -395,9 +400,10 @@ u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
 	if (!mlx5_accel_is_tls_device(mdev))
 		return 0;
 
-	if (MLX5_CAP_GEN(mdev, tls_tx))
+	if (mlx5_accel_is_ktls_device(mdev))
 		return mlx5e_ktls_get_stop_room(sq);
 
+	/* FPGA */
 	/* Resync SKB. */
 	return mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 2a7b98531539f..8bb7906740425 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -49,8 +49,8 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 			     struct mlx5e_accel_tx_tls_state *state);
 
-void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
-			     u32 *cqe_bcnt);
+void mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
 
 #else
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index db18f602cdb2f..1b173d0aad1f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1441,6 +1441,7 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 	struct mlx5e_channel *c = sq->channel;
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
+	mlx5e_free_icosq_descs(sq);
 	mlx5e_free_icosq(sq);
 }
 
@@ -3851,6 +3852,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 #ifdef CONFIG_MLX5_EN_ARFS
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
 
 	if (err) {
 		netdev->features = oper_features;
@@ -5133,8 +5135,14 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_flow_steering;
 
+	err = mlx5e_accel_init_rx(priv);
+	if (err)
+		goto err_tc_nic_cleanup;
+
 	return 0;
 
+err_tc_nic_cleanup:
+	mlx5e_tc_nic_cleanup(priv);
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
 err_destroy_xsk_tirs:
@@ -5158,6 +5166,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6b3c82da199ce..d5cce529190d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -578,6 +578,30 @@ bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	return !!err;
 }
 
+void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
+{
+	u16 sqcc;
+
+	sqcc = sq->cc;
+
+	while (sqcc != sq->pc) {
+		struct mlx5e_icosq_wqe_info *wi;
+		u16 ci;
+
+		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
+		wi = &sq->db.wqe_info[ci];
+		sqcc += wi->num_wqebbs;
+#ifdef CONFIG_MLX5_EN_TLS
+		switch (wi->wqe_type) {
+		case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
+			mlx5e_ktls_handle_ctx_completion(wi);
+			break;
+		}
+#endif
+	}
+	sq->cc = sqcc;
+}
+
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
@@ -633,6 +657,13 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 				break;
 			case MLX5E_ICOSQ_WQE_NOP:
 				break;
+#ifdef CONFIG_MLX5_EN_TLS
+			case MLX5E_ICOSQ_WQE_UMR_TLS:
+				break;
+			case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
+				mlx5e_ktls_handle_ctx_completion(wi);
+				break;
+#endif
 			default:
 				netdev_WARN_ONCE(cq->channel->netdev,
 						 "Bad WQE type in ICOSQ WQE info: 0x%x\n",
@@ -983,7 +1014,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	skb->mac_len = ETH_HLEN;
 
 #ifdef CONFIG_MLX5_EN_TLS
-	mlx5e_tls_handle_rx_skb(netdev, skb, &cqe_bcnt);
+	mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
 #endif
 
 	if (lro_num_seg > 1) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index a5fbe73435081..c3095863372cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include "mlx5_core.h"
 #include "../../mlxfw/mlxfw.h"
+#include "accel/tls.h"
 
 enum {
 	MCQS_IDENTIFIER_BOOT_IMG	= 0x1,
@@ -236,7 +237,7 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
-	if (MLX5_CAP_GEN(dev, tls_tx)) {
+	if (mlx5_accel_is_ktls_tx(dev) || mlx5_accel_is_ktls_rx(dev)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_TLS);
 		if (err)
 			return err;
-- 
2.26.2

