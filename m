Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97530A507
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBAKGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:06:48 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59975 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233016AbhBAKGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:14 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C08029353;
        Mon, 1 Feb 2021 12:05:14 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v3 net-next  15/21] net/mlx5e: NVMEoTCP use KLM UMRs
Date:   Mon,  1 Feb 2021 12:05:03 +0200
Message-Id: <20210201100509.27351-16-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for ddp operation,
every request comprises from SG list that might have elements with size > 4K,
thus the appropriate way to perform buffer registration is with KLM UMRs.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 116 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  12 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  12 +-
 5 files changed, 145 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 13a0d4d5e9f6..f282c0f6cdab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -236,7 +236,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt        inline_mtts[0];
+		struct mlx5_klm	       inline_klms[0];
+	};
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 4880f2179273..e997b7230028 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -34,6 +34,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVME_TCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 0834deb7a3ac..bbeded08ef01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,6 +20,121 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NVMEOTCP_QUEUES,
 };
 
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+		      struct mlx5e_umr_wqe *wqe, u16 ccid, u32 klm_entries,
+		      u16 klm_offset)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
+	lkey = queue->priv->mdev->mlx5e_res.mkey.key;
+	for (i = 0; i < klm_entries; i++) {
+		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+		wqe->inline_klms[i].bcount = cpu_to_be32(sgl_mkey->length);
+		wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va	   = cpu_to_be64(sgl_mkey->dma_address);
+	}
+
+	for (; i < ALIGN(klm_entries, KLM_ALIGNMENT); i++) {
+		wqe->inline_klms[i].bcount = 0;
+		wqe->inline_klms[i].key    = 0;
+		wqe->inline_klms[i].va     = 0;
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
+		       struct mlx5e_umr_wqe *wqe, u16 ccid, int klm_entries,
+		       u32 klm_offset, u32 len)
+{
+	u32 id = queue->ccid_table[ccid].klm_mkey.key;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg	       *mkc = &wqe->mkc;
+
+	u32 sqn = queue->sq->icosq.sqn;
+	u16 pc = queue->sq->icosq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
+	cseg->general_id = cpu_to_be32(id);
+
+	if (!klm_offset) {
+		ucseg->mkey_mask |= cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
+						MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, KLM_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
+		       struct mlx5e_icosq *sq, u32 wqe_bbs, u16 pi)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	wi->num_wqebbs = wqe_bbs;
+	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
+}
+
+static void
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     u16 ccid,
+	     u32 klm_length,
+	     u32 *klm_offset)
+{
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+	u32 wqe_bbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe,
+				klm_length - *klm_offset);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, KLM_ALIGNMENT));
+	wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, *klm_offset,
+			       klm_length);
+	*klm_offset += cur_klm_entries;
+	sq->pc += wqe_bbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+}
+
+static int
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+			    u16 ccid,
+			    u32 klm_length)
+{
+	u32 klm_offset = 0, wqes, wqe_sz, max_wqe_bbs, i, room;
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+
+	/* TODO: set stricter wqe_sz; using max for now */
+	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
+
+	max_wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+
+	room = mlx5e_stop_room_for_wqe(max_wqe_bbs) * wqes;
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+		return -ENOSPC;
+
+	for (i = 0; i < wqes; i++)
+		post_klm_wqe(queue, ccid, klm_length, &klm_offset);
+
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+	return 0;
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct tcp_ddp_limits *limits)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..329e114d6571
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 98b56f495b32..974e34c956ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -617,16 +617,20 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi = &sq->db.wqe_info[ci];
 		sqcc += wi->num_wqebbs;
-#ifdef CONFIG_MLX5_EN_TLS
 		switch (wi->wqe_type) {
+#ifdef CONFIG_MLX5_EN_TLS
 		case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
 			mlx5e_ktls_handle_ctx_completion(wi);
 			break;
 		case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 			mlx5e_ktls_handle_get_psv_completion(wi, sq);
 			break;
-		}
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
+			break;
+#endif
+		}
 	}
 	sq->cc = sqcc;
 }
@@ -695,6 +699,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.24.1

