Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F920C447
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgF0VTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:19 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:8866
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgF0VTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNNk628PR9z3yAU8n5RcbfX0USPs3I9Eow4RcolMiOgUMhB7ys50R5DN2K4jLnq4NrJZXzxxW3RJ4X/bpcb/dtJsWU8n7OUxi0+xeHZ/kRcaVa7vZwcSN+Wqs/BspzpnmN9wlNLBwYQSQO5FBQmJGHDN0eGyiuxEiF1CQ7+xFAQV5qgQs6QpsgTwNgofACw8ssuu0EDIln0YngPin4AhEQVzfwIX9KCHJNPxD2udhxLOTZPzw7pabFBq1lUNa7pHjm22ieRRWP/CMDx5XD7+LliYqZIZL0+IvGiAmHZkQD8dp5lQwfwc0BJdToUOaFNz99HgF1s2tDXrrtretcblPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksGnwQzB7AtUN+czh2bnPhfWOLjn21UA5oXIu1ZHAcU=;
 b=IIMpYA9p/gPiqZL4hyLjGQqOYHaF/20W9QpuK98x/WOZ82dqmKRx1db45caJ5LJ+bH1ptGJM60Hlgr9Thi76BBCFmAXQLCxtVk/BolR+RFtyQPtOlVwkBp3yxhTxLjeDHdFzfIUT1PoB6WTbpyQS6gGL/CvyTIIVikIAk5eHMoRf85B7KtTnUNSFyQInPugWtzIOiNmFoxq6b6U1UNMP9tyHKbTtCMFAz8oPL0jdudPaCII6oZsBR+NZuUF9l7u5lzJb3eDGS6NqXqvzYZJn5cDWv+I0HHT3ibCKIinVY8Z1ONQvHOA+Z7OCFVyNwTOlcTkD9QMPl8/bj3LBDpfvDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksGnwQzB7AtUN+czh2bnPhfWOLjn21UA5oXIu1ZHAcU=;
 b=eRNrMvrlvZsqQKMYkCxzRAolF8kQxt2dnSoPQseJt6YV2kJEb76fpi8VZ8stiMykXsWMKRflc6xUQqkQblZBRCg5KGqwr1neor6oyMirKaOVs1LY40PgvBtiOpYUw0cRzVNQBMl9/QHUx50kEm/N5xh/B1ws7QVAqFZ5H+2vNWI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/15] net/mlx5e: kTLS, Add kTLS RX HW offload support
Date:   Sat, 27 Jun 2020 14:17:20 -0700
Message-Id: <20200627211727.259569-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f13677e9-fa10-482e-6914-08d81adfb190
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134FE82777ADE52153F7DBABE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXTF7X2eHVBFyUtC+vw0Jm536KtzbI95G2NxXnUmmqea+H3FXp97jXGxKVXQFVWmAveHZ1+Nwc0j3cQU6wpMfn+Um8aokQ67g/a1ETWPXUVLKiXJcCu5UDXnub5hMLknI8HzUZ9h2DpWu4LtDalZQT0zkDgrFwcVGvQ47GIbFyH4t6z/XpybR6ZSzUlRllYUeg7TzI4f3u1DL4QEk80gqn9IchfICldSPgW+sp0qgksAQLDHWBAid+qqSrnnNE4VqrVFfCctKbhQu6KkUU2chFWWy7bbpQgkdanTGgBcZmDDdFFvlTOPWAp8uxGRTatpOWQrqscUrj7YiXNAotAeQjb2rFw6MPNuuLHAwBpVVppcmPoA4DiE5UyqU6wTH/GBp1TnZLWFbHkZ/W+jQTewaO+jkTvb4Cd/RtSh0Xr15hE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(30864003)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ygAyvYbIGd4vLAynaQZd2Xu2OB8reTpHgjlQRAFIcNdwCcF3cF1zh54ppLdENaOtA+kCWpLFnQ8QGnqUfu9ub4GkSWkSyFAA0LxUedtxQjn7dDakD8BDUtlcD79d2N0azCyMGRnumNt5YrQwGaVarJyEVtFj0RBe+LbEcH9DYO48/z+yYsVlrFgYGJfzh79B+TVuKKdJXEeBebvzkzugHnnj9VvgZh0D54uhkS+1/oioXHVWJAghTflybYvp2PPqRdJe4g19a8Ip6qCQF4PTomzE90vgS1WEEOphqh1q6B/hLcifiTPCe8zDGP8Gfch7GycPjtzxcRS0vqzUO6uttLuipD1aNK7eNTTYVTwCgyqenNLsF7an5O5tz9xfWYR5HETdVdEYXfHhuBTc2eNjPnbHN4J0cmAV/7Ru38TFuJt+LbkiEEie3RWln/6yTFyBkSUdHeJHrrAoqszyRQtm1CHPJfScDPxOhewnzFj6+dM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13677e9-fa10-482e-6914-08d81adfb190
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:53.5203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ku6IYlubGlgMoJbwm7DZ7o2xPWDrSYOl73hmYR+SkFK9r+Z3ola5YJ7HLSmvslG5R7oJU7W86ADzKfYvGg7HzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
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
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   1 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/accel/tls.h   |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  11 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  20 ++
 .../mellanox/mlx5/core/en_accel/ktls.c        |  66 +++-
 .../mellanox/mlx5/core/en_accel/ktls.h        |  19 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 311 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   2 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |  20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |   4 +
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   4 +
 .../mellanox/mlx5/core/en_accel/tls.c         |  12 +-
 .../mellanox/mlx5/core/en_accel/tls.h         |   1 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  20 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   3 +-
 19 files changed, 529 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 4dfdbb82ea9d..76b39659c39b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -173,6 +173,7 @@ config MLX5_TLS
 config MLX5_EN_TLS
 	bool "TLS cryptography-offload accelaration"
 	depends on MLX5_CORE_EN
+	depends on XPS
 	depends on MLX5_FPGA_TLS || MLX5_TLS
 	default y
 	help
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 70ad24fff2e2..1e7c7f10db6e 100644
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
index aefea467f7b3..fd874f0c380a 100644
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
index 31cac239563d..7f55bd3229f1 100644
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
+#ifdef CONFIG_MLX5_EN_TLS
+		struct {
+			struct mlx5e_ktls_offload_context_rx *priv_rx;
+		} tls_set_params;
+#endif
 	};
 };
 
+void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq);
+
 static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index fac145dcf2ce..7b6abea850d4 100644
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
index 8970ea68d005..d4ef016ab444 100644
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
@@ -29,26 +30,71 @@ static void mlx5e_ktls_del(struct net_device *netdev,
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
 
-	mlx5e_ktls_del_tx(netdev, tls_ctx);
+static int mlx5e_ktls_resync(struct net_device *netdev,
+			     struct sock *sk, u32 seq, u8 *rcd_sn,
+			     enum tls_offload_ctx_dir direction)
+{
+	return -EOPNOTSUPP;
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
index 69d736954977..baa58b62e8df 100644
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
index 000000000000..aae4245d0c91
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -0,0 +1,311 @@
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
+	struct sock *sk;
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
+	rule = mlx5e_accel_fs_add_sk(accel_rule->priv, priv_rx->sk,
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
+}
+
+static void icosq_fill_wi(struct mlx5e_icosq *sq, u16 pi,
+			  struct mlx5e_icosq_wqe_info *wi)
+{
+	sq->db.wqe_info[pi] = *wi;
+}
+
+static struct mlx5_wqe_ctrl_seg *
+post_static_params(struct mlx5e_icosq *sq,
+		   struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_set_tls_static_params_wqe *wqe;
+	struct mlx5e_icosq_wqe_info wi;
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
+	wi = (struct mlx5e_icosq_wqe_info) {
+		.wqe_type = MLX5E_ICOSQ_WQE_UMR_TLS,
+		.num_wqebbs = num_wqebbs,
+		.tls_set_params.priv_rx = priv_rx,
+	};
+	icosq_fill_wi(sq, pi, &wi);
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
+	struct mlx5e_icosq_wqe_info wi;
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
+	wi = (struct mlx5e_icosq_wqe_info) {
+		.wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_TLS,
+		.num_wqebbs = num_wqebbs,
+		.tls_set_params.priv_rx = priv_rx,
+	};
+
+	icosq_fill_wi(sq, pi, &wi);
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
+	if (IS_ERR(cseg))
+		goto err_out;
+	cseg = post_progress_params(sq, priv_rx, next_record_tcp_sn);
+	if (IS_ERR(cseg))
+		goto err_out;
+
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+unlock:
+	spin_unlock(&c->async_icosq_lock);
+
+	return err;
+
+err_out:
+	err = PTR_ERR(cseg);
+	complete(&priv_rx->add_ctx);
+	goto unlock;
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
+	struct mlx5e_ktls_offload_context_rx *priv_rx = wi->tls_set_params.priv_rx;
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
+	priv_rx->sk = sk;
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
index 5a980f93c326..9c34ffa55b32 100644
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
index edf404eaa275..c1f1ad32ca4c 100644
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
index 7ce6b1c41d9b..7bdd6ec6c981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -19,6 +19,10 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq);
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
index d1d747cb2dcb..566cf24eb0fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -23,6 +23,9 @@ enum {
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
 void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx);
+int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
+		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
+void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx);
 
 struct mlx5e_set_tls_static_params_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
@@ -64,6 +67,7 @@ void
 mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
 				 u16 pc, u32 sqn,
 				 u32 tis_tir_num, bool fence,
+				 u32 next_record_tcp_sn,
 				 enum tls_offload_ctx_dir direction);
 
 #endif /* __MLX5E_TLS_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index c01c17a5c6de..99beb928feff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -197,6 +197,7 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 		return;
 	}
 
+	/* FPGA */
 	if (!mlx5_accel_is_tls_device(priv->mdev))
 		return;
 
@@ -221,11 +222,19 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 
 int mlx5e_tls_init(struct mlx5e_priv *priv)
 {
-	struct mlx5e_tls *tls = kzalloc(sizeof(*tls), GFP_KERNEL);
+	struct mlx5e_tls *tls;
 
+	if (!mlx5_accel_is_tls_device(priv->mdev))
+		return 0;
+
+	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
 	if (!tls)
 		return -ENOMEM;
 
+	tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
+	if (!tls->rx_wq)
+		return -ENOMEM;
+
 	priv->tls = tls;
 	return 0;
 }
@@ -237,6 +246,7 @@ void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
 	if (!tls)
 		return;
 
+	destroy_workqueue(tls->rx_wq);
 	kfree(tls);
 	priv->tls = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 9015f3f7792d..ca0c2ebb41a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -53,6 +53,7 @@ struct mlx5e_tls_sw_stats {
 
 struct mlx5e_tls {
 	struct mlx5e_tls_sw_stats sw_stats;
+	struct workqueue_struct *rx_wq;
 };
 
 struct mlx5e_tls_offload_context_tx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 4d796fea906d..182841322ce4 100644
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
index 2a7b98531539..8bb790674042 100644
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
index 11997c23dfb5..0f1578a5e538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1441,6 +1441,7 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 	struct mlx5e_channel *c = sq->channel;
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
+	mlx5e_free_icosq_descs(sq);
 	mlx5e_free_icosq(sq);
 }
 
@@ -3853,6 +3854,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 #ifdef CONFIG_MLX5_EN_ARFS
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
 
 	if (err) {
 		netdev->features = oper_features;
@@ -5143,8 +5145,14 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
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
@@ -5168,6 +5176,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index dbb1c6323967..9a6958acf87d 100644
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
index a5fbe7343508..c3095863372c 100644
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

