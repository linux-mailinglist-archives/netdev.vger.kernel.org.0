Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3771E882A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgE2Tru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:50 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:61282
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727924AbgE2Trq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9xESx4XQnEjbtsvLEU14U6l/sUsF5K5OPxLPqSzelAdOYILWzETqngz2su5uo1NAmwei+zLAcIN4j4q71gdrbYLRJMRhj3f9fZ/X5oWwlkLgLsHc4ObC8hJUkVraPzqP5hkz3qHKjfh3lH3LVoEIomvmTtcKUV8sa3ZA8E5l8kTRBu56WWip/S1uJ66ePjKFRQPLtDxfQZpoV+Yr32BHtYwf2KJP2qWGimekhGF3Bg+VlfO+08J6LxLo2RFGksC8aN8DHvKKMgVbsD8d6ZH1c7D831tS1wVtcVY8cOxLULIjJt/FPTwQ1TKTfVgKhjpasrDd8WIrimSIEbNivivGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctHVGnwXnKx638MpOqbDA+yEW/75N1sWwf3etT/0fEc=;
 b=amXHLpJ0z+RnKJkO/H6ry+/kLQ79YzmsXaGtKauZYgFomooZrl9L+8GeZOVBxXMzzDKxRfUhJyXdeG5fYeX6whhF3KK/TUDrilPppbG3DAa5ACAt8jYLAkbdHsmUPoeIgkViPaaDmMj2/Grs9UnjoVv2sFnFh1whpBS7Qh4waB16Oqr2nR9fV/bCPpIF+WpexmXcp8MeYZcnU09pvDhjV2JKWleyW8f5cGTTeQBOJ63zOgnJmgRs057qEeU37Mc0CADvV/gSs8yrHaPPMg1LiApyQfDaaq18gZRQciRT/P/BAv4XEdhnY8iEuGarW/P1o7d1/Ltgt3bRsMwURydOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctHVGnwXnKx638MpOqbDA+yEW/75N1sWwf3etT/0fEc=;
 b=RCaqdKSgpwK5OFglOczckiAwj5uMdmaYb5Th4Wx2/WGbZZvqqfsduB5Zy4f27gWN9b3NYunCi8qKon6A1CWjEYDxXl9fPcLfaJUJFfLxef3Hj15BurbO2I/IyoB755RfeX4EyLEC/bdGGCBZjVCZiOPCkrSZyNMc3201xFgLBEU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Date:   Fri, 29 May 2020 12:46:40 -0700
Message-Id: <20200529194641.243989-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:24 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5016677d-3b55-42a3-3a3d-08d804091ca2
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB658928F213726256BE0A4B40BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHUA9waIHcnxUa5eFHYndZqI72hU5dVFWWGdTZSYlLNa4O0GZC/s/zhrwog70vYTbDHxR6xpSbzSXNT/z84tRf1dnzeLFHM1euKN1AG0YH4MhXiqP2e+a2OvYYwDmFmTuAmMMjsx7Q+KhKGnark6t22lObfFTprsZhL5XI5n97+0feu+1E8f6VnbNr7NBPrXXnjS3PfPmkBWb0BXZ4p49N/PLfJu0bcli/c2BGMiL3dfTTjQamo5nQNnJtfLlYfNe8zROmyLCKWM1wf6IQVuCeOB4Z1qIKtu9W3OOUNtk8DOvhZBE+in+qYrG2SzDMEezeEFkCDqcWdQFFIQOy08MRtXA1FrpsfCSTxJnoISo4EmE2rzpCL/SRJnVhqbL8WA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(30864003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: icv5eIkTbdz0tG7q9F0EbAkaHZx2K887JKftxdBZBeTu7KiK8Z1N5KtOdqRoWA51BBqx7iDds5D+05elXEclVFYGPT4nhLctztomvmIZ3Q2gsQpVZnD2FQ+YteKHOiOzOIrGoVhkTFdmg82wGdrXoXWf3ZOx5qf9jEoOp60uJojUEtU9mYpLAsWgCCIeCvN2QFc1g+AbQkVvTSFfnw0J1YUNnhy8BSTsBZpqHd4lzzNF+Q2j501hqQn12geoRtydaGEKc4pQ7TlF3qlEW5V3jLrRU0nkcmV12fx0i72SkkL94XnEPcoqGirX6Qtsg+5RIBMoi3W9CFLU2TllMr4tleeqkU2waCMlfl0Yt+cCRkbPII/WQdhVsvM5qOWNKtZyyWrRH8waiGNHL15YYtUeJ6x+cu4IBEzX1mmkAV9QIPThZIn1f+6GEzz3Ys91LeN9idKde4R+KlePS1SZNJg7JJ+0YNmJoSglOtQep3AEEvU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5016677d-3b55-42a3-3a3d-08d804091ca2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:25.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzU/Yvroq+2wAXjxol6LqgrVErUnZnrAV540N3U12SRinPm7Bt5ImQX7JAJHAqhZX6rtBf194KuRk1vKSRekUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Implement the RX resync procedure.

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
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   1 +
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 322 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   2 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |   7 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   6 +
 7 files changed, 347 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index ad1525aa5670b..934c18263de9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -14,6 +14,7 @@ enum mlx5e_icosq_wqe_type {
 #ifdef CONFIG_MLX5_EN_TLS
 	MLX5E_ICOSQ_WQE_UMR_TLS,
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
+	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 13e666403a5df..703ce78d54043 100644
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
@@ -16,6 +18,26 @@ struct accel_rule {
 	struct sock *sk;
 };
 
+#define PROGRESS_PARAMS_WRITE_UNIT	64
+#define PROGRESS_PARAMS_PADDED_SIZE	\
+		(ALIGN(sizeof(struct mlx5_wqe_tls_progress_params_seg), \
+		       PROGRESS_PARAMS_WRITE_UNIT))
+
+struct mlx5e_ktls_rx_resync_ctx {
+	struct work_struct work;
+	struct mlx5e_priv *priv;
+	dma_addr_t dma_addr;
+	refcount_t refcnt;
+	u32 hw_seq;
+	u32 sw_seq;
+	__be64 sw_rcd_sn_be;
+
+	union {
+		struct mlx5_wqe_tls_progress_params_seg progress;
+		u8 pad[PROGRESS_PARAMS_PADDED_SIZE];
+	} ____cacheline_aligned_in_smp;
+};
+
 enum {
 	MLX5E_PRIV_RX_FLAG_DELETING,
 	MLX5E_NUM_PRIV_RX_FLAGS,
@@ -30,6 +52,9 @@ struct mlx5e_ktls_offload_context_rx {
 	u32 key_id;
 	u32 rxq;
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
+
+	/* resync */
+	struct mlx5e_ktls_rx_resync_ctx resync;
 };
 
 static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
@@ -115,7 +140,8 @@ post_static_params(struct mlx5e_icosq *sq,
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
-				       priv_rx->tirn, priv_rx->key_id, false,
+				       priv_rx->tirn, priv_rx->key_id,
+				       priv_rx->resync.hw_seq, false,
 				       TLS_OFFLOAD_CTX_DIR_RX);
 	icosq_fill_wi(sq, pi, MLX5E_ICOSQ_WQE_UMR_TLS, num_wqebbs, priv_rx);
 	sq->pc += num_wqebbs;
@@ -202,10 +228,252 @@ mlx5e_get_ktls_rx_priv_ctx(struct tls_context *tls_ctx)
 }
 
 /* Re-sync */
+static struct mlx5_wqe_ctrl_seg *
+resync_post_get_progress_params(struct mlx5e_icosq *sq,
+				struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	struct mlx5e_ktls_rx_resync_ctx *resync = &priv_rx->resync;
+	struct mlx5e_get_tls_progress_params_wqe *wqe;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_seg_get_psv *psv;
+	u16 pi;
+
+	dma_sync_single_for_device(resync->priv->mdev->device,
+				   resync->dma_addr,
+				   PROGRESS_PARAMS_PADDED_SIZE,
+				   DMA_FROM_DEVICE);
+	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1)))
+		return ERR_PTR(-ENOSPC);
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
+	psv->va           = cpu_to_be64(priv_rx->resync.dma_addr);
+
+	icosq_fill_wi(sq, pi, MLX5E_ICOSQ_WQE_GET_PSV_TLS, 1, priv_rx);
+	sq->pc++;
+
+	return cseg;
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
+static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync, struct mlx5e_priv *priv)
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
+	u8 tracker_state, auth_state, *ctx;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_icosq *sq;
+	int err;
+
+	ctx = priv_rx->resync.progress.ctx;
+	tracker_state = MLX5_GET(tls_progress_params, ctx, record_tracker_state);
+	auth_state = MLX5_GET(tls_progress_params, ctx, auth_state);
+
+	if (tracker_state != MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING ||
+	    auth_state != MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD)
+		return 0;
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
+	struct mlx5e_ktls_offload_context_rx *priv_rx = wi->accel.priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync = &priv_rx->resync;
+
+	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
+		goto out;
+
+	dma_sync_single_for_cpu(resync->priv->mdev->device,
+				resync->dma_addr,
+				PROGRESS_PARAMS_PADDED_SIZE,
+				DMA_FROM_DEVICE);
+
+	resync->hw_seq = MLX5_GET(tls_progress_params, resync->progress.ctx, hw_resync_tcp_sn);
+	if (resync->hw_seq == resync->sw_seq) {
+		struct mlx5e_channel *c =
+			container_of(sq, struct mlx5e_channel, async_icosq);
+
+		resync_handle_seq_match(priv_rx, c);
+	}
+out:
+	refcount_dec(&resync->refcnt);
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
+	if (unlikely(!queue_work(resync->priv->tls->rx_wq, &resync->work))) {
+		refcount_dec(&resync->refcnt);
+		return false;
+	}
+
+	return true;
+}
+
+/* Runs in NAPI */
+static void resync_update_sn(struct net_device *netdev, struct sk_buff *skb)
+{
+	struct ethhdr *eth = (struct ethhdr *)(skb->data);
+	struct sock *sk = NULL;
+	int network_depth = 0;
+	struct iphdr *iph;
+	struct tcphdr *th;
+
+	__vlan_get_protocol(skb, eth->h_proto, &network_depth);
+	iph = (struct iphdr *)(skb->data + network_depth);
+
+	if (iph->version == 4) {
+		th = (void *)iph + sizeof(struct iphdr);
+
+		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
+					     iph->saddr, th->source, iph->daddr,
+					     th->dest, netdev->ifindex);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		struct ipv6hdr *ipv6h = (struct ipv6hdr *)iph;
+
+		th = (void *)ipv6h + sizeof(struct ipv6hdr);
+
+		sk = __inet6_lookup_established(dev_net(netdev), &tcp_hashinfo,
+						&ipv6h->saddr, th->source,
+						&ipv6h->daddr, ntohs(th->dest),
+						netdev->ifindex, 0);
+#endif
+	}
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
+	tls_offload_rx_force_resync_request(sk);
+}
+
 int mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
 			 u32 seq, u8 *rcd_sn)
 {
-	return -EOPNOTSUPP;
+	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
+
+	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_get_ctx(sk));
+	if (unlikely(!priv_rx))
+		return 0;
+
+	resync = &priv_rx->resync;
+	resync->sw_rcd_sn_be = *(__be64 *)rcd_sn;
+	resync->sw_seq = seq - (TLS_HEADER_SIZE - 1);
+
+	if (resync->hw_seq == resync->sw_seq) {
+		struct mlx5e_priv *priv;
+		struct mlx5e_channel *c;
+
+		priv = netdev_priv(netdev);
+		c = priv->channels.c[priv_rx->rxq];
+
+		if (!resync_handle_seq_match(priv_rx, c))
+			return 0;
+	}
+
+	tls_offload_rx_force_resync_request(sk);
+
+	return 0;
 }
 
 /* End of resync section */
@@ -225,6 +493,7 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 		rq->stats->tls_decrypted_bytes += *cqe_bcnt;
 		break;
 	case CQE_TLS_OFFLOAD_RESYNC:
+		resync_update_sn(rq->netdev, skb);
 		rq->stats->tls_ooo++;
 		break;
 	default: /* CQE_TLS_OFFLOAD_ERROR: */
@@ -250,15 +519,18 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		      u32 start_offload_tcp_sn)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct mlx5e_ktls_rx_resync_ctx *resync;
 	struct tls_context *tls_ctx;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
+	struct device *pdev;
 	int rxq, err;
 	u32 rqtn;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
 	mdev = priv->mdev;
+	pdev = mdev->device;
 	priv_rx = kzalloc(sizeof(*priv_rx), GFP_KERNEL);
 	if (unlikely(!priv_rx))
 		return -ENOMEM;
@@ -282,7 +554,14 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		goto err_create_tir;
 
 	init_completion(&priv_rx->add_ctx);
+	resync = &priv_rx->resync;
+	resync->dma_addr = dma_map_single(pdev, &resync->progress,
+					  PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(pdev, resync->dma_addr)))
+		goto err_map_resync;
+
 	accel_rule_init(&priv_rx->rule, priv, sk);
+	resync_init(resync, priv);
 	err = post_rx_param_wqes(priv->channels.c[rxq], priv_rx, start_offload_tcp_sn);
 	if (err)
 		goto err_post_wqes;
@@ -292,6 +571,9 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	return 0;
 
 err_post_wqes:
+	dma_unmap_single(pdev, resync->dma_addr,
+			 PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+err_map_resync:
 	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
 err_create_tir:
 	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
@@ -300,27 +582,63 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
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
+	struct device *pdev;
 
 	priv = netdev_priv(netdev);
 	mdev = priv->mdev;
+	pdev = mdev->device;
 
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
 
 	KTLS_STATS_INC(priv, priv_rx->rxq, tls_del);
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
+	dma_unmap_single(pdev, resync->dma_addr, PROGRESS_PARAMS_PADDED_SIZE,
+			 DMA_FROM_DEVICE);
 	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
 	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
 	kfree(priv_rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9c34ffa55b328..0e6698d1b4ca9 100644
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
index c1f1ad32ca4c2..ac29aeb8af492 100644
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
index 7d7b63ae5c350..66e5063a22ce4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -25,6 +25,8 @@ void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
 
 void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi);
+void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
+					  struct mlx5e_icosq *sq);
 
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index af8117d4bf884..3dbc45e29828b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -41,12 +41,20 @@ struct mlx5e_set_tls_progress_params_wqe {
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
@@ -55,6 +63,10 @@ struct mlx5e_set_tls_progress_params_wqe {
 	((struct mlx5e_set_tls_progress_params_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_progress_params_wqe)))
 
+#define MLX5E_TLS_FETCH_GET_PROGRESS_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_get_tls_progress_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_get_tls_progress_params_wqe)))
+
 #define MLX5E_TLS_FETCH_DUMP_WQE(sq, pi) \
 	((struct mlx5e_dump_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_dump_wqe)))
@@ -63,7 +75,7 @@ void
 mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
 			       struct tls12_crypto_info_aes_gcm_128 *info,
-			       u32 tis_tir_num, u32 key_id,
+			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
 			       bool fence, enum tls_offload_ctx_dir direction);
 void
 mlx5e_ktls_build_progress_params(struct mlx5e_set_tls_progress_params_wqe *wqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d5cce529190d5..19bcd49224526 100644
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

