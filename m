Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D701E8826
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgE2Trh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:37 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbgE2Tre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvVZ/GR4G3fZDZJG+TQBv1fzsA8SxAqncQ+KOWBITheKIGA8l+zxoUVPYVXNEHtn14V8zlwUVbBRLb47Jkp5xpizInb3TlO4l3DYlRsrqwRxmo/odhAGilJ0KdPW+bEDkIuCr0tMEuP+qAL5xG0+HvGMfrtcHn73mnfqZrROPa0T5BvzO6F2ZXAoe1038scLliOQP2QL8OhMlYA6XPOwFU00tGmqO6klTi1Vg+/MOoUPJgoI8JgP8R+cyHMrv6TU4rjDpzYIvvX+a+shAM3E1hckjNs0bnXsfciBSwY7VN6FnqnTPkTU7KDjlMAr+vMQx0xhKGKa8oA6YAnDaw8pQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iefC6ydIU3prT7Kxb3KuWKA2Ehvbe5zoDdgIg1fQ+I=;
 b=N/zmMrZ5cmHqJlXXe/EzqWwsXhS6KwF6Hwtda1io8HdEZPLhVP4GMOBDbBJMDGle5UPQdpJwEVWeEmHs3qvl7185zbDURq1fP+mbIg8JaRfl+IrqtZLgnoCe5GvweANdt/atbvoexOArNN3Dg/ydOtcvX3lBGKyB7h/UeEIXcQpt3w60nV06v8Xf9nkMfjjwBtA4Ih3pMI4uAKKvv7ClCIxD90ykq0Q3pmHOwrEaI8MRnf0h2XiUcodayvFbcQergSaoBTmwPqBBqWwLq7iiaOLBF0uvx93nD/iHifpr+b9G7o7U/cPLBYVzfbiQx19yAZF51pm6t0nmxYuUHnpwTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iefC6ydIU3prT7Kxb3KuWKA2Ehvbe5zoDdgIg1fQ+I=;
 b=S5AiMPOS6XaQzO0WwIk4hOh+1A3oZhbCre4LGDhewN9EtS/+NBQmuGfXKUmr254hHUfrgVNxyB5SWkpgPkSb0HJZJgQuHATRX3OwR+M1nYE+iEUgGvWbz6l513H0bRt3bui1ZWF8UeI0bcsM51TerLYfnxn0kPd3eThtpRz1Ck8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/11] net/mlx5e: kTLS, Improve TLS feature modularity
Date:   Fri, 29 May 2020 12:46:36 -0700
Message-Id: <20200529194641.243989-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60daae00-e030-4a12-6dc6-08d8040916d2
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB658943A595E1B3F9B39F10ABBE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nMKp0sIhRrO6Q6v8Y2R67nDVrJml2NP8NloL9nSIFnhnI5B5sGepFnPaO/aAV53HYwext4aBSrQYjG3ejOFdi44HbWIEvND7IALGRl8OIbAqvPSsJsmX281lL/DkhvRcAPkJIHsVOUkohyOyGQVreW3ICDiYwtwvOSxiQFNM0mmMYx0tDzuUE7Te6MBDv1M34AXW3gdkmXKyshxHTu8G/mRM6EbA7swsSr6TphLJ54YmNLdugPfFG8yD0wXSSo087hbyx6iY1U+aSsbKNEXKoM2iSaAy/k3llvb1mplS3Ao0pOPeo1xpwM9H2GtkTd8lEzefwJp7D0YsNjEx5589/HCCHU09Sqdl/TVggiJwEdTZN3mxX0t56MkXjaieNhF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(30864003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KzInpNmM+sKJhrXfEP2SBnyEdwN2rUgMzUB4N1s2KI+cCtWspTwlvHIH0WBlZgxh7jkeMumiJey3CR7WrRBml/DYP/yQff7fAoidpuWQdG5hVUgJyIcWX5ifZQ5w0x4X6mkmycit0TC8AecVn2INMRcEBZCvpL2w5v5vmjU+97x5Yq30eQA3V3i+OjMxW6UYgAqOOzi+ZD+plV6vg1lFNLL8rMUltJcY4XOZHGR8xGB7E8x80vR2wtXfV099kwffL6ZPzV5VR1H3fq+MW7kbFBL5aNEfe+sU9aMakQISolFcqm97vl027dC+Sb/cJ26dw3SoonINhJRaESrUj//M0veu4r7MYIWXUbYX4msCryRhtdyO8qpUUg7IPVnoydtOfZM5hV8l76ZCSR1Zdqm5SheVhCUMdSlPCuixZdhOmc1XbBR1mtMi7oD+xeazF9pZCiA3KSZbWzr9V5kSwv4pK4Td+u011j9/CnsbcVGdCm8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60daae00-e030-4a12-6dc6-08d8040916d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:16.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRzloXLwFzFy0pEXTxBIRw6htbs5DXh13oHemp2Po2nZ1HoW+gjj9tF00yUkNA+AbtwfKXyXoqbz6IuJUHBh/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Better separate the code into c/h files, so that kTLS internals
are exposed to the corresponding non-accel flow as follows:
- Necessary datapath functions are exposed via ktls_txrx.h.
- Necessary caps and configuration functions are exposed via ktls.h,
  which became very small.

In addition, kTLS internal code sharing is done via ktls_utils.h,
which is not exposed to any non-accel file.

Add explicit WQE structures for the TLS static and progress
params, breaking the union of the static with UMR, and the progress
with PSV.

Generalize the API as a preparation for TLS RX offload support.

Move kTLS TX-specific code to the proper file.
Remove the inline tag for function in C files, let the compiler decide.
Use kzalloc/kfree for the priv_tx context.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  62 +----
 .../mellanox/mlx5/core/en_accel/ktls.h        | 107 ---------
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 214 +++++++++++-------
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   | 110 +++++++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  38 ++++
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  69 ++++++
 .../mellanox/mlx5/core/en_accel/tls.c         |  14 --
 .../mellanox/mlx5/core/en_accel/tls.h         |   7 -
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  14 ++
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   1 -
 13 files changed, 378 insertions(+), 288 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8ffa1325a18f9..70ad24fff2e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -74,7 +74,8 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
-				   en_accel/ktls.o en_accel/ktls_tx.o en_accel/fs_tcp.o
+				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
+				   en_accel/ktls_tx.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6937aaf24235b..55b89d3900f21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -191,13 +191,8 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
-	union {
-		struct {
-			struct mlx5_wqe_eth_seg  eth;
-			struct mlx5_wqe_data_seg data[0];
-		};
-		u8 tls_progress_params_ctx[0];
-	};
+	struct mlx5_wqe_eth_seg  eth;
+	struct mlx5_wqe_data_seg data[0];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -213,10 +208,7 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	union {
-		struct mlx5_mtt        inline_mtts[0];
-		u8                     tls_static_params_ctx[0];
-	};
+	struct mlx5_mtt                inline_mtts[0];
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 452fcf59c36bf..8970ea68d005c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -3,31 +3,7 @@
 
 #include "en.h"
 #include "en_accel/ktls.h"
-
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq)
-{
-	u16 num_dumps, stop_room = 0;
-
-	num_dumps = mlx5e_ktls_dumps_num_wqes(sq, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
-
-	stop_room += mlx5e_stop_room_for_wqe(MLX5E_KTLS_STATIC_WQEBBS);
-	stop_room += mlx5e_stop_room_for_wqe(MLX5E_KTLS_PROGRESS_WQEBBS);
-	stop_room += num_dumps * mlx5e_stop_room_for_wqe(MLX5E_KTLS_DUMP_WQEBBS);
-
-	return stop_room;
-}
-
-static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
-{
-	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
-	void *tisc;
-
-	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
-
-	MLX5_SET(tisc, tisc, tls_en, 1);
-
-	return mlx5e_create_tis(mdev, in, tisn);
-}
+#include "en_accel/ktls_utils.h"
 
 static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 			  enum tls_offload_ctx_dir direction,
@@ -35,8 +11,6 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 			  u32 start_offload_tcp_sn)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_ktls_offload_context_tx *tx_priv;
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
@@ -46,31 +20,8 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
 		return -EOPNOTSUPP;
 
-	tx_priv = kvzalloc(sizeof(*tx_priv), GFP_KERNEL);
-	if (!tx_priv)
-		return -ENOMEM;
-
-	tx_priv->expected_seq = start_offload_tcp_sn;
-	tx_priv->crypto_info  = *(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
-	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, tx_priv);
-
-	/* tc and underlay_qpn values are not in use for tls tis */
-	err = mlx5e_ktls_create_tis(mdev, &tx_priv->tisn);
-	if (err)
-		goto create_tis_fail;
-
-	err = mlx5_ktls_create_key(mdev, crypto_info, &tx_priv->key_id);
-	if (err)
-		goto encryption_key_create_fail;
+	err = mlx5e_ktls_add_tx(netdev, sk, crypto_info, start_offload_tcp_sn);
 
-	mlx5e_ktls_tx_offload_set_pending(tx_priv);
-
-	return 0;
-
-encryption_key_create_fail:
-	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
-create_tis_fail:
-	kvfree(tx_priv);
 	return err;
 }
 
@@ -78,13 +29,10 @@ static void mlx5e_ktls_del(struct net_device *netdev,
 			   struct tls_context *tls_ctx,
 			   enum tls_offload_ctx_dir direction)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_ktls_offload_context_tx *tx_priv =
-		mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
+		return;
 
-	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
-	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
-	kvfree(tx_priv);
+	mlx5e_ktls_del_tx(netdev, tls_ctx);
 }
 
 static const struct tlsdev_ops mlx5e_ktls_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 806ed185dd4cf..69d736954977c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -7,122 +7,15 @@
 #include "en.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
-#include <net/tls.h>
-#include "accel/tls.h"
-#include "en_accel/tls_rxtx.h"
-
-#define MLX5E_KTLS_STATIC_UMR_WQE_SZ \
-	(offsetof(struct mlx5e_umr_wqe, tls_static_params_ctx) + \
-	 MLX5_ST_SZ_BYTES(tls_static_params))
-#define MLX5E_KTLS_STATIC_WQEBBS \
-	(DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_BB))
-
-#define MLX5E_KTLS_PROGRESS_WQE_SZ \
-	(offsetof(struct mlx5e_tx_wqe, tls_progress_params_ctx) + \
-	 sizeof(struct mlx5_wqe_tls_progress_params_seg))
-#define MLX5E_KTLS_PROGRESS_WQEBBS \
-	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
-
-struct mlx5e_dump_wqe {
-	struct mlx5_wqe_ctrl_seg ctrl;
-	struct mlx5_wqe_data_seg data;
-};
-
-#define MLX5E_TLS_FETCH_UMR_WQE(sq, pi) \
-	((struct mlx5e_umr_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, MLX5E_KTLS_STATIC_UMR_WQE_SZ))
-#define MLX5E_TLS_FETCH_PROGRESS_WQE(sq, pi) \
-	((struct mlx5e_tx_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, MLX5E_KTLS_PROGRESS_WQE_SZ))
-#define MLX5E_TLS_FETCH_DUMP_WQE(sq, pi) \
-	((struct mlx5e_dump_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, \
-						  sizeof(struct mlx5e_dump_wqe)))
-
-#define MLX5E_KTLS_DUMP_WQEBBS \
-	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
-
-enum {
-	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     = 0,
-	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_OFFLOAD        = 1,
-	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_AUTHENTICATION = 2,
-};
-
-enum {
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 1,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 2,
-};
-
-struct mlx5e_ktls_offload_context_tx {
-	struct tls_offload_context_tx *tx_ctx;
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
-	u32 expected_seq;
-	u32 tisn;
-	u32 key_id;
-	bool ctx_post_pending;
-};
-
-struct mlx5e_ktls_offload_context_tx_shadow {
-	struct tls_offload_context_tx         tx_ctx;
-	struct mlx5e_ktls_offload_context_tx *priv_tx;
-};
-
-static inline void
-mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
-			   struct mlx5e_ktls_offload_context_tx *priv_tx)
-{
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
-
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
-
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
-
-	shadow->priv_tx = priv_tx;
-	priv_tx->tx_ctx = tx_ctx;
-}
-
-static inline struct mlx5e_ktls_offload_context_tx *
-mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
-{
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
-
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
-
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
-
-	return shadow->priv_tx;
-}
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
-void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx);
 
-bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, int datalen,
-			      struct mlx5e_accel_tx_tls_state *state);
-void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
-					   struct mlx5e_tx_wqe_info *wi,
-					   u32 *dma_fifo_cc);
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq);
-
-static inline u8
-mlx5e_ktls_dumps_num_wqes(struct mlx5e_txqsq *sq, unsigned int nfrags,
-			  unsigned int sync_len)
-{
-	/* Given the MTU and sync_len, calculates an upper bound for the
-	 * number of DUMP WQEs needed for the TX resync of a record.
-	 */
-	return nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu);
-}
 #else
 
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
-static inline void
-mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe_info *wi,
-				      u32 *dma_fifo_cc) {}
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index ad7300f198157..349e29214b928 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -1,109 +1,149 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
-#include <linux/tls.h>
-#include "en.h"
-#include "en/txrx.h"
-#include "en_accel/ktls.h"
+#include "en_accel/ktls_txrx.h"
+#include "en_accel/ktls_utils.h"
 
-enum {
-	MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2 = 0x2,
+struct mlx5e_dump_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_data_seg data;
 };
 
-enum {
-	MLX5E_ENCRYPTION_STANDARD_TLS = 0x1,
-};
+#define MLX5E_KTLS_DUMP_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
 
-#define EXTRACT_INFO_FIELDS do { \
-	salt    = info->salt;    \
-	rec_seq = info->rec_seq; \
-	salt_sz    = sizeof(info->salt);    \
-	rec_seq_sz = sizeof(info->rec_seq); \
-} while (0)
+static u8
+mlx5e_ktls_dumps_num_wqes(struct mlx5e_txqsq *sq, unsigned int nfrags,
+			  unsigned int sync_len)
+{
+	/* Given the MTU and sync_len, calculates an upper bound for the
+	 * number of DUMP WQEs needed for the TX resync of a record.
+	 */
+	return nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu);
+}
 
-static void
-fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq)
 {
-	struct tls12_crypto_info_aes_gcm_128 *info = &priv_tx->crypto_info;
-	char *initial_rn, *gcm_iv;
-	u16 salt_sz, rec_seq_sz;
-	char *salt, *rec_seq;
-	u8 tls_version;
+	u16 num_dumps, stop_room = 0;
 
-	EXTRACT_INFO_FIELDS;
+	num_dumps = mlx5e_ktls_dumps_num_wqes(sq, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
 
-	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
-	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
+	stop_room += mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
+	stop_room += num_dumps * mlx5e_stop_room_for_wqe(MLX5E_KTLS_DUMP_WQEBBS);
 
-	memcpy(gcm_iv,      salt,    salt_sz);
-	memcpy(initial_rn,  rec_seq, rec_seq_sz);
+	return stop_room;
+}
+
+static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+	void *tisc;
 
-	tls_version = MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2;
+	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
-	MLX5_SET(tls_static_params, ctx, tls_version, tls_version);
-	MLX5_SET(tls_static_params, ctx, const_1, 1);
-	MLX5_SET(tls_static_params, ctx, const_2, 2);
-	MLX5_SET(tls_static_params, ctx, encryption_standard,
-		 MLX5E_ENCRYPTION_STANDARD_TLS);
-	MLX5_SET(tls_static_params, ctx, dek_index, priv_tx->key_id);
+	MLX5_SET(tisc, tisc, tls_en, 1);
+
+	return mlx5e_create_tis(mdev, in, tisn);
 }
 
+struct mlx5e_ktls_offload_context_tx {
+	struct tls_offload_context_tx *tx_ctx;
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	u32 expected_seq;
+	u32 tisn;
+	u32 key_id;
+	bool ctx_post_pending;
+};
+
+struct mlx5e_ktls_offload_context_tx_shadow {
+	struct tls_offload_context_tx         tx_ctx;
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+};
+
 static void
-build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u32 sqn,
-		    struct mlx5e_ktls_offload_context_tx *priv_tx,
-		    bool fence)
+mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
+			   struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
-	struct mlx5_wqe_ctrl_seg     *cseg  = &wqe->ctrl;
-	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
-
-#define STATIC_PARAMS_DS_CNT \
-	DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_DS)
+	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
 
-	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR |
-					     (MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS << 24));
-	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
-					     STATIC_PARAMS_DS_CNT);
-	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
-	cseg->tis_tir_num      = cpu_to_be32(priv_tx->tisn << 8);
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
 
-	ucseg->flags = MLX5_UMR_INLINE;
-	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
+	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
 
-	fill_static_params_ctx(wqe->tls_static_params_ctx, priv_tx);
+	shadow->priv_tx = priv_tx;
+	priv_tx->tx_ctx = tx_ctx;
 }
 
-static void
-fill_progress_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
+static struct mlx5e_ktls_offload_context_tx *
+mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 {
-	struct mlx5_wqe_tls_progress_params_seg *params;
+	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
 
-	params = ctx;
+	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
 
-	params->tis_tir_num = cpu_to_be32(priv_tx->tisn);
-	MLX5_SET(tls_progress_params, params->ctx, record_tracker_state,
-		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
-	MLX5_SET(tls_progress_params, params->ctx, auth_state,
-		 MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD);
+	return shadow->priv_tx;
 }
 
-static void
-build_progress_params(struct mlx5e_tx_wqe *wqe, u16 pc, u32 sqn,
-		      struct mlx5e_ktls_offload_context_tx *priv_tx,
-		      bool fence)
+int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
+		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn)
 {
-	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct tls_context *tls_ctx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_priv *priv;
+	int err;
 
-#define PROGRESS_PARAMS_DS_CNT \
-	DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_DS)
+	tls_ctx = tls_get_ctx(sk);
+	priv = netdev_priv(netdev);
+	mdev = priv->mdev;
 
-	cseg->opmod_idx_opcode =
-		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV |
-			    (MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS << 24));
-	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
-					     PROGRESS_PARAMS_DS_CNT);
-	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+	priv_tx = kzalloc(sizeof(*priv_tx), GFP_KERNEL);
+	if (!priv_tx)
+		return -ENOMEM;
+
+	err = mlx5_ktls_create_key(mdev, crypto_info, &priv_tx->key_id);
+	if (err)
+		goto err_create_key;
+
+	priv_tx->expected_seq = start_offload_tcp_sn;
+	priv_tx->crypto_info  =
+		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
+
+	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
+	if (err)
+		goto err_create_tis;
+
+	priv_tx->ctx_post_pending = true;
+
+	return 0;
+
+err_create_tis:
+	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
+err_create_key:
+	kfree(priv_tx);
+	return err;
+}
+
+void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_priv *priv;
+
+	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+	priv = netdev_priv(netdev);
+	mdev = priv->mdev;
 
-	fill_progress_params_ctx(wqe->tls_progress_params_ctx, priv_tx);
+	mlx5e_destroy_tis(mdev, priv_tx->tisn);
+	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
+	kfree(priv_tx);
 }
 
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
@@ -119,11 +159,6 @@ static void tx_fill_wi(struct mlx5e_txqsq *sq,
 	};
 }
 
-void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
-{
-	priv_tx->ctx_post_pending = true;
-}
-
 static bool
 mlx5e_ktls_tx_offload_test_and_clear_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
@@ -139,12 +174,15 @@ post_static_params(struct mlx5e_txqsq *sq,
 		   struct mlx5e_ktls_offload_context_tx *priv_tx,
 		   bool fence)
 {
-	u16 pi, num_wqebbs = MLX5E_KTLS_STATIC_WQEBBS;
-	struct mlx5e_umr_wqe *umr_wqe;
+	struct mlx5e_set_tls_static_params_wqe *wqe;
+	u16 pi, num_wqebbs;
 
+	num_wqebbs = MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS;
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-	umr_wqe = MLX5E_TLS_FETCH_UMR_WQE(sq, pi);
-	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
+	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
+	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_tx->crypto_info,
+				       priv_tx->tisn, priv_tx->key_id, fence,
+				       TLS_OFFLOAD_CTX_DIR_TX);
 	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
 	sq->pc += num_wqebbs;
 }
@@ -154,12 +192,14 @@ post_progress_params(struct mlx5e_txqsq *sq,
 		     struct mlx5e_ktls_offload_context_tx *priv_tx,
 		     bool fence)
 {
-	u16 pi, num_wqebbs = MLX5E_KTLS_PROGRESS_WQEBBS;
-	struct mlx5e_tx_wqe *wqe;
+	struct mlx5e_set_tls_progress_params_wqe *wqe;
+	u16 pi, num_wqebbs;
 
+	num_wqebbs = MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS;
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-	wqe = MLX5E_TLS_FETCH_PROGRESS_WQE(sq, pi);
-	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
+	wqe = MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi);
+	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn, priv_tx->tisn, fence,
+					 TLS_OFFLOAD_CTX_DIR_TX);
 	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
 	sq->pc += num_wqebbs;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
new file mode 100644
index 0000000000000..edf404eaa2752
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include "en_accel/ktls_txrx.h"
+#include "en_accel/ktls_utils.h"
+
+enum {
+	MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2 = 0x2,
+};
+
+enum {
+	MLX5E_ENCRYPTION_STANDARD_TLS = 0x1,
+};
+
+#define EXTRACT_INFO_FIELDS do { \
+	salt    = info->salt;    \
+	rec_seq = info->rec_seq; \
+	salt_sz    = sizeof(info->salt);    \
+	rec_seq_sz = sizeof(info->rec_seq); \
+} while (0)
+
+static void
+fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
+		   struct tls12_crypto_info_aes_gcm_128 *info,
+		   u32 key_id)
+{
+	char *initial_rn, *gcm_iv;
+	u16 salt_sz, rec_seq_sz;
+	char *salt, *rec_seq;
+	u8 tls_version;
+	u8 *ctx;
+
+	ctx = params->ctx;
+
+	EXTRACT_INFO_FIELDS;
+
+	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
+	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
+
+	memcpy(gcm_iv,      salt,    salt_sz);
+	memcpy(initial_rn,  rec_seq, rec_seq_sz);
+
+	tls_version = MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2;
+
+	MLX5_SET(tls_static_params, ctx, tls_version, tls_version);
+	MLX5_SET(tls_static_params, ctx, const_1, 1);
+	MLX5_SET(tls_static_params, ctx, const_2, 2);
+	MLX5_SET(tls_static_params, ctx, encryption_standard,
+		 MLX5E_ENCRYPTION_STANDARD_TLS);
+	MLX5_SET(tls_static_params, ctx, dek_index, key_id);
+}
+
+void
+mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
+			       u16 pc, u32 sqn,
+			       struct tls12_crypto_info_aes_gcm_128 *info,
+			       u32 tis_tir_num, u32 key_id,
+			       bool fence, enum tls_offload_ctx_dir direction)
+{
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg     *cseg  = &wqe->ctrl;
+
+#define STATIC_PARAMS_DS_CNT DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR |
+					     (MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS << 24));
+	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     STATIC_PARAMS_DS_CNT);
+	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+	cseg->tis_tir_num      = cpu_to_be32(tis_tir_num << 8);
+
+	ucseg->flags = MLX5_UMR_INLINE;
+	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
+
+	fill_static_params(&wqe->params, info, key_id);
+}
+
+static void
+fill_progress_params(struct mlx5_wqe_tls_progress_params_seg *params, u32 tis_tir_num)
+{
+	u8 *ctx = params->ctx;
+
+	params->tis_tir_num = cpu_to_be32(tis_tir_num);
+
+	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
+	MLX5_SET(tls_progress_params, ctx, auth_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD);
+}
+
+void
+mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
+				 u16 pc, u32 sqn,
+				 u32 tis_tir_num, bool fence,
+				 enum tls_offload_ctx_dir direction)
+{
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+
+#define PROGRESS_PARAMS_DS_CNT DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode =
+		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV |
+			    (MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS << 24));
+	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     PROGRESS_PARAMS_DS_CNT);
+	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	fill_progress_params(&wqe->params, tis_tir_num);
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
new file mode 100644
index 0000000000000..a325f34831176
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5E_KTLS_TXRX_H__
+#define __MLX5E_KTLS_TXRX_H__
+
+#ifdef CONFIG_MLX5_EN_TLS
+
+#include <net/tls.h>
+#include "en.h"
+#include "en/txrx.h"
+
+struct mlx5e_accel_tx_tls_state {
+	u32 tls_tisn;
+};
+
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq);
+u8 mlx5e_ktls_dumps_num_wqebbs(struct mlx5e_txqsq *sq, unsigned int nfrags,
+			       unsigned int sync_len);
+
+bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
+			      struct sk_buff *skb, int datalen,
+			      struct mlx5e_accel_tx_tls_state *state);
+
+void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					   struct mlx5e_tx_wqe_info *wi,
+					   u32 *dma_fifo_cc);
+#else
+static inline void
+mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+				      struct mlx5e_tx_wqe_info *wi,
+				      u32 *dma_fifo_cc)
+{
+}
+
+#endif /* CONFIG_MLX5_EN_TLS */
+
+#endif /* __MLX5E_TLS_TXRX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
new file mode 100644
index 0000000000000..d1d747cb2dcb6
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5E_KTLS_UTILS_H__
+#define __MLX5E_KTLS_UTILS_H__
+
+#include <net/tls.h>
+#include "en.h"
+#include "accel/tls.h"
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     = 0,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_OFFLOAD        = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_AUTHENTICATION = 2,
+};
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 2,
+};
+
+int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
+		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
+void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx);
+
+struct mlx5e_set_tls_static_params_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_umr_ctrl_seg uctrl;
+	struct mlx5_mkey_seg mkc;
+	struct mlx5_wqe_tls_static_params_seg params;
+};
+
+struct mlx5e_set_tls_progress_params_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_tls_progress_params_seg params;
+};
+
+#define MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_static_params_wqe), MLX5_SEND_WQE_BB))
+
+#define MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_progress_params_wqe), MLX5_SEND_WQE_BB))
+
+#define MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_tls_static_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_static_params_wqe)))
+
+#define MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_tls_progress_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_progress_params_wqe)))
+
+#define MLX5E_TLS_FETCH_DUMP_WQE(sq, pi) \
+	((struct mlx5e_dump_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_dump_wqe)))
+
+void
+mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
+			       u16 pc, u32 sqn,
+			       struct tls12_crypto_info_aes_gcm_128 *info,
+			       u32 tis_tir_num, u32 key_id,
+			       bool fence, enum tls_offload_ctx_dir direction);
+void
+mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
+				 u16 pc, u32 sqn,
+				 u32 tis_tir_num, bool fence,
+				 enum tls_offload_ctx_dir direction);
+
+#endif /* __MLX5E_TLS_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index c27e9a609d519..fba561ffe1d4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -240,17 +240,3 @@ void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
 	kfree(tls);
 	priv->tls = NULL;
 }
-
-u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
-{
-	struct mlx5_core_dev *mdev = sq->channel->mdev;
-
-	if (!mlx5_accel_is_tls_device(mdev))
-		return 0;
-
-	if (MLX5_CAP_GEN(mdev, tls_tx))
-		return mlx5e_ktls_get_stop_room(sq);
-
-	/* Resync SKB. */
-	return mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 9219bdb2786e2..9015f3f7792d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -94,8 +94,6 @@ int mlx5e_tls_get_count(struct mlx5e_priv *priv);
 int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
 int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data);
 
-u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq);
-
 #else
 
 static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
@@ -110,11 +108,6 @@ static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
 static inline int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data) { return 0; }
 static inline int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
 
-static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
-{
-	return 0;
-}
-
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 72d26fbc8d5bf..4d796fea906d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -387,3 +387,17 @@ void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 	remove_metadata_hdr(skb);
 	*cqe_bcnt -= MLX5E_METADATA_ETHER_LEN;
 }
+
+u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_core_dev *mdev = sq->channel->mdev;
+
+	if (!mlx5_accel_is_tls_device(mdev))
+		return 0;
+
+	if (MLX5_CAP_GEN(mdev, tls_tx))
+		return mlx5e_ktls_get_stop_room(sq);
+
+	/* Resync SKB. */
+	return mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index a50d0394df0ae..2a7b98531539f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -34,15 +34,15 @@
 #ifndef __MLX5E_TLS_RXTX_H__
 #define __MLX5E_TLS_RXTX_H__
 
+#include "en_accel/ktls_txrx.h"
+
 #ifdef CONFIG_MLX5_EN_TLS
 
 #include <linux/skbuff.h>
 #include "en.h"
 #include "en/txrx.h"
 
-struct mlx5e_accel_tx_tls_state {
-	u32 tls_tisn;
-};
+u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq);
 
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state);
@@ -52,6 +52,13 @@ void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *c
 void mlx5e_tls_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 			     u32 *cqe_bcnt);
 
+#else
+
+static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MLX5_EN_TLS */
 
 #endif /* __MLX5E_TLS_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 6d406063aca42..da596de3abba2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,7 +38,6 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
-#include "en_accel/ktls.h"
 #include "lib/clock.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
-- 
2.26.2

