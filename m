Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2213520C448
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgF0VTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:23 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbgF0VTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRNpiqDz8uzOzYIdwFYw+fmGgStFh5PZvdQ+ziiXsB4HqkYxgBCuDIM9VbHaQpswzCPthCdHhv9M/Dp8TJcONKOeho4FnsX7iE+je44ssHuYoEvnPny3NEsFOB4mMWbsQEuaPRAMksEHra3UPoB/up3DCtn1r8piYP6wsrPTjjbf/S+d4F+bRCEBnq0qmNMK4FeeU1TEQ75AU9HF2rhcNM2RslPx6XB9JlglE7t86NN2rfaRlOI8QNNwAMXkWwpK48teYLH/j9NE+wnDYALcX7//0LaHedTgIp7SaJKR4QNf3AXH9xpXdUITuRejP1tGDKs8Bvt4G1NAFb7g70/ryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWBEd55I4QEfPJ8CTgkVwElrEOHRbNTZdNKNdPQL/fo=;
 b=QRl9/LtX4dY4J/BNbYgXMHVX2RVciQQIhNymbPbl96iDMWtC/hZb5RN1jqqGu/H/frGUIsQc5CqHdF3Jbb/SHSUQ/Jt/jjD6EY6RCrjQv1SE8kAfcjTVpV1RjREllG2ytLkaY8bx7E3mSMgZnSmy+aIhDDSrF/JQevryyA2SLjWsuhwe+2Eb8sdPisdETmUL45pAMBg/++S3/4aRRiZjuM7kxY6hBA0zjBIa8O3XHU6oHFt2eAvRAOLetPTwZwHYxo2BzAHlH4Fzw/4AFR/gyfPmhtoaPeyPO3zGaFqt/tJpYVB2lI9EtU5e8LLpFzYQQI15CpE9bzItuicOJi9dNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWBEd55I4QEfPJ8CTgkVwElrEOHRbNTZdNKNdPQL/fo=;
 b=aD4JvN+OBJtQ3gKMx6ciGFWFDGthlLMFgVb8SoFeU/wEfDBZWty1hUjL7RV079Lxh3eHKD28nMrOKQlpOt2AM7d2wXwL/0Q+2Pk1UJ2/wFpZ94d6eH5hjcVIeJKFH9Zv/5Ev84tWZNVsB+tGfZjNCnL2oNtrsqAE0+H0XU+wEBE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:19:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:19:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: kTLS, Add kTLS RX resync support
Date:   Sat, 27 Jun 2020 14:17:23 -0700
Message-Id: <20200627211727.259569-12-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f25aff19-93ed-43d0-4e58-08d81adfb5bd
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51346C219D6CF6154329CD92BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUOVMGt9tzdJA6M/Kjwd0KjtGv7oHa2ayCsa/lAO55TEv16oRmfdjnFbSzjEfUTyW97QnDeBhUnrWeYbUxOg9IWpTVwJpSZYfLCyDIFgEUtle1bsossj+Fzin4mr1WoO1HXXXY1snHBixOxc3kyyNcbrY6dar4l0dmwCucmZcAxae8yawRoSza7FHwmAdPYH1A/9OZghLbbzEMO3YWi5ixeb0Z2Zhg9JQhsfrSvZq1gCYcM8iK+W/+JkJB4BhAbFgwT/hOaL913iL+ErBvfXkanOvzSnq9o+Gl1b5M148ucl76lCqRRukOCcRkh3RX2s4lI10g3tfljGA25qfc3NpYVXLH6VCxKGv7Ct7QVx1HHdWDaiF9xPLm9sHUMeIR//
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(30864003)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Pl88nVc6b3CY4Ls6lS7vq1TaftgP5VSovCTXsWAgE8QuthF2EbnWup0Dn0ZCQIImn4O5QSqLRuq2yASY83kh8Z7OOhn+mQaclgWPIpCR3mkP8FsFtCZX8BCRP8ieLbw8BfgJ5ZXj6F7A0NE+8pWvLbj1UZ+OOlYYsShUHY1PEYZ4YvJyWgfmIBq5dKNOXh0e5l+qz0qO7oRm2opBxcUdyT5eBCVo7e146hLpJXarMUYOHyewU5mRUZN+OOKOK8HsWkLGMM+yBkDiwgtg0l8X4QvqfAp72w5C2SJL/7VG1o5ktQwgWe2WyRLRsQ9jhuV/DxwI6kCriZK+ygm4CQaaNRPfljBcM4rV2lWmr20wo0mF3ZBPqIUZUB+IhVd2HAHs0HS5EEQikWX1zskKzHtzH7RkPBtt7qF0zOFcvDToz4FKcvxvk+WG5bASuaeAiyVPg3uoq8aILhDve93eZFDYZgTjBbWlH8GPCj8xy8jnjGo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25aff19-93ed-43d0-4e58-08d81adfb5bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:19:00.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ok1z95YzHrFOX4zinCKYqDFbOKbZ57T0M/MP2qsdA8YngDd4Qw08N8ftCYlp//ucvEzkiV+bmv6mCEA2L+P7kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Implement the RX resync procedure, using the TLS async resync API.

The HW offload of TLS decryption in RX side might get out-of-sync
due to out-of-order reception of packets.
This requires SW intervention to update the HW context and get it
back in-sync.

Performance:
CPU: Intel(R) Xeon(R) CPU E5-2687W v4 @ 3.00GHz, 24 cores, HT off
NIC: ConnectX-6 Dx 100GbE dual port

Goodput (app-layer throughput) comparison:
+---------------+-------+-------+---------+
| # connections |   1   |   4   |    8    |
+---------------+-------+-------+---------+
| SW (Gbps)     |  7.26 | 24.70 |   50.30 |
+---------------+-------+-------+---------+
| HW (Gbps)     | 18.50 | 64.30 |   92.90 |
+---------------+-------+-------+---------+
| Speedup       | 2.55x | 2.56x | 1.85x * |
+---------------+-------+-------+---------+

* After linerate is reached, diff is observed in CPU util.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +
 .../mellanox/mlx5/core/en_accel/ktls.c        |   6 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 346 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   2 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |   7 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   6 +
 8 files changed, 381 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7f55bd3229f1..e9d4a61b6bbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -14,6 +14,7 @@ enum mlx5e_icosq_wqe_type {
 #ifdef CONFIG_MLX5_EN_TLS
 	MLX5E_ICOSQ_WQE_UMR_TLS,
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
+	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
 };
 
@@ -122,6 +123,9 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_ktls_offload_context_rx *priv_rx;
 		} tls_set_params;
+		struct {
+			struct mlx5e_ktls_rx_resync_buf *buf;
+		} tls_get_params;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index d4ef016ab444..deec17af5a69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -40,7 +40,11 @@ static int mlx5e_ktls_resync(struct net_device *netdev,
 			     struct sock *sk, u32 seq, u8 *rcd_sn,
 			     enum tls_offload_ctx_dir direction)
 {
-	return -EOPNOTSUPP;
+	if (unlikely(direction != TLS_OFFLOAD_CTX_DIR_RX))
+		return -EOPNOTSUPP;
+
+	mlx5e_ktls_rx_resync(netdev, sk, seq, rcd_sn);
+	return 0;
 }
 
 static const struct tlsdev_ops mlx5e_ktls_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index aae4245d0c91..b26dad909ef5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
+#include <net/inet6_hashtables.h>
 #include "en_accel/en_accel.h"
+#include "en_accel/tls.h"
 #include "en_accel/ktls_txrx.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -12,11 +14,34 @@ struct accel_rule {
 	struct mlx5_flow_handle *rule;
 };
 
+#define PROGRESS_PARAMS_WRITE_UNIT	64
+#define PROGRESS_PARAMS_PADDED_SIZE	\
+		(ALIGN(sizeof(struct mlx5_wqe_tls_progress_params_seg), \
+		       PROGRESS_PARAMS_WRITE_UNIT))
+
+struct mlx5e_ktls_rx_resync_buf {
+	union {
+		struct mlx5_wqe_tls_progress_params_seg progress;
+		u8 pad[PROGRESS_PARAMS_PADDED_SIZE];
+	} ____cacheline_aligned_in_smp;
+	dma_addr_t dma_addr;
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+};
+
 enum {
 	MLX5E_PRIV_RX_FLAG_DELETING,
 	MLX5E_NUM_PRIV_RX_FLAGS,
 };
 
+struct mlx5e_ktls_rx_resync_ctx {
+	struct tls_offload_resync_async core;
+	struct work_struct work;
+	struct mlx5e_priv *priv;
+	refcount_t refcnt;
+	__be64 sw_rcd_sn_be;
+	u32 seq;
+};
+
 struct mlx5e_ktls_offload_context_rx {
 	struct tls12_crypto_info_aes_gcm_128 crypto_info;
 	struct accel_rule rule;
@@ -26,6 +51,9 @@ struct mlx5e_ktls_offload_context_rx {
 	u32 key_id;
 	u32 rxq;
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
+
+	/* resync */
+	struct mlx5e_ktls_rx_resync_ctx resync;
 };
 
 static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
@@ -104,7 +132,8 @@ post_static_params(struct mlx5e_icosq *sq,
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
-				       priv_rx->tirn, priv_rx->key_id, false,
+				       priv_rx->tirn, priv_rx->key_id,
+				       priv_rx->resync.seq, false,
 				       TLS_OFFLOAD_CTX_DIR_RX);
 	wi = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type = MLX5E_ICOSQ_WQE_UMR_TLS,
@@ -201,6 +230,281 @@ mlx5e_get_ktls_rx_priv_ctx(struct tls_context *tls_ctx)
 	return *ctx;
 }
 
+/* Re-sync */
+/* Runs in work context */
+static struct mlx5_wqe_ctrl_seg *
+resync_post_get_progress_params(struct mlx5e_icosq *sq,
+				struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_get_tls_progress_params_wqe *wqe;
+	struct mlx5e_ktls_rx_resync_buf *buf;
+	struct mlx5e_icosq_wqe_info wi;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_seg_get_psv *psv;
+	struct device *pdev;
+	int err;
+	u16 pi;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (unlikely(!buf)) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	pdev = sq->channel->priv->mdev->device;
+	buf->dma_addr = dma_map_single(pdev, &buf->progress,
+				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	buf->priv_rx = priv_rx;
+
+	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
+		err = -ENOSPC;
+		goto err_out;
+	}
+
+	pi = mlx5e_icosq_get_next_pi(sq, 1);
+	wqe = MLX5E_TLS_FETCH_GET_PROGRESS_PARAMS_WQE(sq, pi);
+
+#define GET_PSV_DS_CNT (DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS))
+
+	cseg = &wqe->ctrl;
+	cseg->opmod_idx_opcode =
+		cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_GET_PSV |
+			    (MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS << 24));
+	cseg->qpn_ds =
+		cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) | GET_PSV_DS_CNT);
+
+	psv = &wqe->psv;
+	psv->num_psv      = 1 << 4;
+	psv->l_key        = sq->channel->mkey_be;
+	psv->psv_index[0] = cpu_to_be32(priv_rx->tirn);
+	psv->va           = cpu_to_be64(buf->dma_addr);
+
+	wi = (struct mlx5e_icosq_wqe_info) {
+		.wqe_type = MLX5E_ICOSQ_WQE_GET_PSV_TLS,
+		.num_wqebbs = 1,
+		.tls_get_params.buf = buf,
+	};
+	icosq_fill_wi(sq, pi, &wi);
+	sq->pc++;
+
+	return cseg;
+
+err_out:
+	return ERR_PTR(err);
+}
+
+/* Function is called with elevated refcount.
+ * It decreases it only if no WQE is posted.
+ */
+static void resync_handle_work(struct work_struct *work)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_channel *c;
+	struct mlx5e_icosq *sq;
+	struct mlx5_wq_cyc *wq;
+
+	resync = container_of(work, struct mlx5e_ktls_rx_resync_ctx, work);
+	priv_rx = container_of(resync, struct mlx5e_ktls_offload_context_rx, resync);
+
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags))) {
+		refcount_dec(&resync->refcnt);
+		return;
+	}
+
+	c = resync->priv->channels.c[priv_rx->rxq];
+	sq = &c->async_icosq;
+	wq = &sq->wq;
+
+	spin_lock(&c->async_icosq_lock);
+
+	cseg = resync_post_get_progress_params(sq, priv_rx);
+	if (IS_ERR(cseg)) {
+		refcount_dec(&resync->refcnt);
+		goto unlock;
+	}
+	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
+unlock:
+	spin_unlock(&c->async_icosq_lock);
+}
+
+static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync,
+			struct mlx5e_priv *priv)
+{
+	INIT_WORK(&resync->work, resync_handle_work);
+	resync->priv = priv;
+	refcount_set(&resync->refcnt, 1);
+}
+
+/* Function can be called with the refcount being either elevated or not.
+ * It does not affect the refcount.
+ */
+static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx,
+				   struct mlx5e_channel *c)
+{
+	struct tls12_crypto_info_aes_gcm_128 *info = &priv_rx->crypto_info;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_icosq *sq;
+	int err;
+
+	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
+	err = 0;
+
+	sq = &c->async_icosq;
+	spin_lock(&c->async_icosq_lock);
+
+	cseg = post_static_params(sq, priv_rx);
+	if (IS_ERR(cseg)) {
+		err = PTR_ERR(cseg);
+		goto unlock;
+	}
+	/* Do not increment priv_rx refcnt, CQE handling is empty */
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+unlock:
+	spin_unlock(&c->async_icosq_lock);
+
+	return err;
+}
+
+/* Function is called with elevated refcount, it decreases it. */
+void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
+					  struct mlx5e_icosq *sq)
+{
+	struct mlx5e_ktls_rx_resync_buf *buf = wi->tls_get_params.buf;
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
+	u8 tracker_state, auth_state, *ctx;
+	u32 hw_seq;
+
+	priv_rx = buf->priv_rx;
+	resync = &priv_rx->resync;
+
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
+		goto out;
+
+	dma_sync_single_for_cpu(resync->priv->mdev->device, buf->dma_addr,
+				PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+
+	ctx = buf->progress.ctx;
+	tracker_state = MLX5_GET(tls_progress_params, ctx, record_tracker_state);
+	auth_state = MLX5_GET(tls_progress_params, ctx, auth_state);
+	if (tracker_state != MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING ||
+	    auth_state != MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD)
+		goto out;
+
+	hw_seq = MLX5_GET(tls_progress_params, ctx, hw_resync_tcp_sn);
+	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
+out:
+	refcount_dec(&resync->refcnt);
+	kfree(buf);
+}
+
+/* Runs in NAPI.
+ * Function elevates the refcount, unless no work is queued.
+ */
+static bool resync_queue_get_psv(struct sock *sk)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
+
+	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_get_ctx(sk));
+	if (unlikely(!priv_rx))
+		return false;
+
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
+		return false;
+
+	resync = &priv_rx->resync;
+	refcount_inc(&resync->refcnt);
+	if (unlikely(!queue_work(resync->priv->tls->rx_wq, &resync->work)))
+		refcount_dec(&resync->refcnt);
+
+	return true;
+}
+
+/* Runs in NAPI */
+static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
+{
+	struct ethhdr *eth = (struct ethhdr *)(skb->data);
+	struct net_device *netdev = rq->netdev;
+	struct sock *sk = NULL;
+	unsigned int datalen;
+	struct iphdr *iph;
+	struct tcphdr *th;
+	__be32 seq;
+	int depth = 0;
+
+	__vlan_get_protocol(skb, eth->h_proto, &depth);
+	iph = (struct iphdr *)(skb->data + depth);
+
+	if (iph->version == 4) {
+		depth += sizeof(struct iphdr);
+		th = (void *)iph + sizeof(struct iphdr);
+
+		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
+					     iph->saddr, th->source, iph->daddr,
+					     th->dest, netdev->ifindex);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		struct ipv6hdr *ipv6h = (struct ipv6hdr *)iph;
+
+		depth += sizeof(struct ipv6hdr);
+		th = (void *)ipv6h + sizeof(struct ipv6hdr);
+
+		sk = __inet6_lookup_established(dev_net(netdev), &tcp_hashinfo,
+						&ipv6h->saddr, th->source,
+						&ipv6h->daddr, ntohs(th->dest),
+						netdev->ifindex, 0);
+#endif
+	}
+
+	depth += sizeof(struct tcphdr);
+
+	if (unlikely(!sk || sk->sk_state == TCP_TIME_WAIT))
+		return;
+
+	if (unlikely(!resync_queue_get_psv(sk)))
+		return;
+
+	skb->sk = sk;
+	skb->destructor = sock_edemux;
+
+	seq = th->seq;
+	datalen = skb->len - depth;
+	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
+}
+
+void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
+			  u32 seq, u8 *rcd_sn)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
+	struct mlx5e_priv *priv;
+	struct mlx5e_channel *c;
+
+	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_get_ctx(sk));
+	if (unlikely(!priv_rx))
+		return;
+
+	resync = &priv_rx->resync;
+	resync->sw_rcd_sn_be = *(__be64 *)rcd_sn;
+	resync->seq = seq;
+
+	priv = netdev_priv(netdev);
+	c = priv->channels.c[priv_rx->rxq];
+
+	resync_handle_seq_match(priv_rx, c);
+}
+
+/* End of resync section */
+
 void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
 {
@@ -214,6 +518,7 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 		skb->decrypted = 1;
 		break;
 	case CQE_TLS_OFFLOAD_RESYNC:
+		resync_update_sn(rq, skb);
 		break;
 	default: /* CQE_TLS_OFFLOAD_ERROR: */
 		break;
@@ -237,6 +542,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		      u32 start_offload_tcp_sn)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
 	struct tls_context *tls_ctx;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
@@ -269,7 +575,13 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		goto err_create_tir;
 
 	init_completion(&priv_rx->add_ctx);
+
 	accel_rule_init(&priv_rx->rule, priv, sk);
+	resync = &priv_rx->resync;
+	resync_init(resync, priv);
+	tls_offload_ctx_rx(tls_ctx)->resync_async = &resync->core;
+	tls_offload_rx_resync_set_type(sk, TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ_ASYNC);
+
 	err = post_rx_param_wqes(priv->channels.c[rxq], priv_rx, start_offload_tcp_sn);
 	if (err)
 		goto err_post_wqes;
@@ -285,9 +597,35 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	return err;
 }
 
+/* Elevated refcount on the resync object means there are
+ * outstanding operations (uncompleted GET_PSV WQEs) that
+ * will read the resync / priv_rx objects once completed.
+ * Wait for them to avoid use-after-free.
+ */
+static void wait_for_resync(struct net_device *netdev,
+			    struct mlx5e_ktls_rx_resync_ctx *resync)
+{
+#define MLX5E_KTLS_RX_RESYNC_TIMEOUT 20000 /* msecs */
+	unsigned long exp_time = jiffies + msecs_to_jiffies(MLX5E_KTLS_RX_RESYNC_TIMEOUT);
+	unsigned int refcnt;
+
+	do {
+		refcnt = refcount_read(&resync->refcnt);
+		if (refcnt == 1)
+			return;
+
+		msleep(20);
+	} while (time_before(jiffies, exp_time));
+
+	netdev_warn(netdev,
+		    "Failed waiting for kTLS RX resync refcnt to be released (%u).\n",
+		    refcnt);
+}
+
 void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 
@@ -296,11 +634,17 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 
 	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
 	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
+	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, NULL);
+	napi_synchronize(&priv->channels.c[priv_rx->rxq]->napi);
 	if (!cancel_work_sync(&priv_rx->rule.work))
 		/* completion is needed, as the priv_rx in the add flow
 		 * is maintained on the wqe info (wi), not on the socket.
 		 */
 		wait_for_completion(&priv_rx->add_ctx);
+	resync = &priv_rx->resync;
+	if (cancel_work_sync(&resync->work))
+		refcount_dec(&resync->refcnt);
+	wait_for_resync(netdev, resync);
 
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9c34ffa55b32..0e6698d1b4ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -171,7 +171,7 @@ post_static_params(struct mlx5e_txqsq *sq,
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_tx->crypto_info,
-				       priv_tx->tisn, priv_tx->key_id, fence,
+				       priv_tx->tisn, priv_tx->key_id, 0, fence,
 				       TLS_OFFLOAD_CTX_DIR_TX);
 	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
 	sq->pc += num_wqebbs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
index c1f1ad32ca4c..ac29aeb8af49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
@@ -22,7 +22,7 @@ enum {
 static void
 fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
 		   struct tls12_crypto_info_aes_gcm_128 *info,
-		   u32 key_id)
+		   u32 key_id, u32 resync_tcp_sn)
 {
 	char *initial_rn, *gcm_iv;
 	u16 salt_sz, rec_seq_sz;
@@ -47,6 +47,7 @@ fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
 	MLX5_SET(tls_static_params, ctx, const_2, 2);
 	MLX5_SET(tls_static_params, ctx, encryption_standard,
 		 MLX5E_ENCRYPTION_STANDARD_TLS);
+	MLX5_SET(tls_static_params, ctx, resync_tcp_sn, resync_tcp_sn);
 	MLX5_SET(tls_static_params, ctx, dek_index, key_id);
 }
 
@@ -54,7 +55,7 @@ void
 mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
 			       struct tls12_crypto_info_aes_gcm_128 *info,
-			       u32 tis_tir_num, u32 key_id,
+			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
 			       bool fence, enum tls_offload_ctx_dir direction)
 {
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
@@ -74,7 +75,7 @@ mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 	ucseg->flags = MLX5_UMR_INLINE;
 	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
 
-	fill_static_params(&wqe->params, info, key_id);
+	fill_static_params(&wqe->params, info, key_id, resync_tcp_sn);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 7bdd6ec6c981..ff4c740af10b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -23,6 +23,8 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
 
 void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi);
+void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
+					  struct mlx5e_icosq *sq);
 
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index 566cf24eb0fe..e5c180f2403b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -26,6 +26,7 @@ void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx);
 int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn);
 void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx);
+void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk, u32 seq, u8 *rcd_sn);
 
 struct mlx5e_set_tls_static_params_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
@@ -39,12 +40,20 @@ struct mlx5e_set_tls_progress_params_wqe {
 	struct mlx5_wqe_tls_progress_params_seg params;
 };
 
+struct mlx5e_get_tls_progress_params_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_seg_get_psv  psv;
+};
+
 #define MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS \
 	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_static_params_wqe), MLX5_SEND_WQE_BB))
 
 #define MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS \
 	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_progress_params_wqe), MLX5_SEND_WQE_BB))
 
+#define MLX5E_KTLS_GET_PROGRESS_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_get_tls_progress_params_wqe), MLX5_SEND_WQE_BB))
+
 #define MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi) \
 	((struct mlx5e_set_tls_static_params_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_static_params_wqe)))
@@ -53,6 +62,10 @@ struct mlx5e_set_tls_progress_params_wqe {
 	((struct mlx5e_set_tls_progress_params_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_progress_params_wqe)))
 
+#define MLX5E_TLS_FETCH_GET_PROGRESS_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_get_tls_progress_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_get_tls_progress_params_wqe)))
+
 #define MLX5E_TLS_FETCH_DUMP_WQE(sq, pi) \
 	((struct mlx5e_dump_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_dump_wqe)))
@@ -61,7 +74,7 @@ void
 mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
 			       struct tls12_crypto_info_aes_gcm_128 *info,
-			       u32 tis_tir_num, u32 key_id,
+			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
 			       bool fence, enum tls_offload_ctx_dir direction);
 void
 mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9a6958acf87d..4b7c119c8946 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -596,6 +596,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 		case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
 			mlx5e_ktls_handle_ctx_completion(wi);
 			break;
+		case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
+			mlx5e_ktls_handle_get_psv_completion(wi, sq);
+			break;
 		}
 #endif
 	}
@@ -663,6 +666,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
 				mlx5e_ktls_handle_ctx_completion(wi);
 				break;
+			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
+				mlx5e_ktls_handle_get_psv_completion(wi, sq);
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->channel->netdev,
-- 
2.26.2

