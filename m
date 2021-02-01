Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC52330A4EE
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhBAKG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:06:27 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59995 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233013AbhBAKGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:14 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C09029353;
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
Subject: [PATCH v3 net-next  16/21] net/mlx5e: NVMEoTCP queue init/teardown
Date:   Mon,  1 Feb 2021 12:05:04 +0200
Message-Id: <20210201100509.27351-17-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

When nvme-tcp establishes new connections, we allocate a hardware
context to offload operations for this queue:
- Use a separate TIR to identify the queue and maintain the HW context
- Use a separate ICOSQ for maintain the HW context
- Use a separate tag buffer for buffer registration
- Maintain static and progress HW contexts by posting the proper
  WQEs at creation time, or upon resync

Queue teardown will free the corresponding contexts.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   6 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 653 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |   4 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  68 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   7 +
 5 files changed, 714 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index e997b7230028..32fa9f1a4a1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -36,6 +36,7 @@ enum mlx5e_icosq_wqe_type {
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 	MLX5E_ICOSQ_WQE_UMR_NVME_TCP,
+	MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP,
 #endif
 };
 
@@ -178,6 +179,11 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_ktls_rx_resync_buf *buf;
 		} tls_get_params;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		struct {
+			struct mlx5e_nvmeotcp_queue *queue;
+		} nvmeotcp_q;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index bbeded08ef01..91125022c0f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -3,6 +3,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/idr.h>
+#include <linux/nvme-tcp.h>
 #include "en_accel/nvmeotcp.h"
 #include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -20,35 +21,180 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NVMEOTCP_QUEUES,
 };
 
+#define MLX5_NVME_TCP_MAX_SEGMENTS 128
+
+static u32 mlx5e_get_max_sgl(struct mlx5_core_dev *mdev)
+{
+	return min_t(u32,
+		     MLX5_NVME_TCP_MAX_SEGMENTS,
+		     1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size));
+}
+
+static void mlx5e_nvmeotcp_destroy_tir(struct mlx5e_priv *priv, int tirn)
+{
+	mlx5_core_destroy_tir(priv->mdev, tirn);
+}
+
+static inline u32
+mlx5e_get_channel_ix_from_io_cpu(struct mlx5e_priv *priv, u32 io_cpu)
+{
+	int num_channels = priv->channels.params.num_channels;
+	u32 channel_ix = io_cpu;
+
+	if (channel_ix >= num_channels)
+		channel_ix = channel_ix % num_channels;
+
+	return channel_ix;
+}
+
+static int mlx5e_nvmeotcp_create_tir(struct mlx5e_priv *priv,
+				     struct sock *sk,
+				     struct nvme_tcp_ddp_config *config,
+				     struct mlx5e_nvmeotcp_queue *queue,
+				     bool zerocopy, bool crc_rx)
+{
+	u32 rqtn = priv->direct_tir[queue->channel_ix].rqt.rqtn;
+	int err, inlen;
+	void *tirc;
+	u32 tirn;
+	u32 *in;
+
+	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
+	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
+	MLX5_SET(tirc, tirc, indirect_table, rqtn);
+	MLX5_SET(tirc, tirc, transport_domain, priv->mdev->mlx5e_res.td.tdn);
+	if (zerocopy) {
+		MLX5_SET(tirc, tirc, nvmeotcp_zero_copy_en, 1);
+		MLX5_SET(tirc, tirc, nvmeotcp_tag_buffer_table_id,
+			 queue->tag_buf_table_id);
+	}
+
+	if (crc_rx)
+		MLX5_SET(tirc, tirc, nvmeotcp_crc_en, 1);
+
+	MLX5_SET(tirc, tirc, self_lb_block,
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST |
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST);
+	err = mlx5_core_create_tir(priv->mdev, in, &tirn);
+
+	if (!err)
+		queue->tirn = tirn;
+
+	kvfree(in);
+	return err;
+}
+
+static
+int mlx5e_create_nvmeotcp_tag_buf_table(struct mlx5_core_dev *mdev,
+					struct mlx5e_nvmeotcp_queue *queue,
+					u8 log_table_size)
+{
+	u32 in[MLX5_ST_SZ_DW(create_nvmeotcp_tag_buf_table_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u64 general_obj_types;
+	void *obj;
+	int err;
+
+	obj = MLX5_ADDR_OF(create_nvmeotcp_tag_buf_table_in, in,
+			   nvmeotcp_tag_buf_table_obj);
+
+	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types &
+	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE))
+		return -EINVAL;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE);
+	MLX5_SET(nvmeotcp_tag_buf_table_obj, obj,
+		 log_tag_buffer_table_size, log_table_size);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		queue->tag_buf_table_id = MLX5_GET(general_obj_out_cmd_hdr,
+						   out, obj_id);
+	return err;
+}
+
+static
+void mlx5_destroy_nvmeotcp_tag_buf_table(struct mlx5_core_dev *mdev, u32 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, uid);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+
+#define STATIC_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
+
+#define PROGRESS_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
+
+enum wqe_type {
+	KLM_UMR = 0,
+	BSF_KLM_UMR = 1,
+	SET_PSV_UMR = 2,
+	BSF_UMR = 3,
+};
+
 static void
 fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 		      struct mlx5e_umr_wqe *wqe, u16 ccid, u32 klm_entries,
-		      u16 klm_offset)
+		      u16 klm_offset, enum wqe_type klm_type)
 {
 	struct scatterlist *sgl_mkey;
 	u32 lkey, i;
 
-	lkey = queue->priv->mdev->mlx5e_res.mkey.key;
-	for (i = 0; i < klm_entries; i++) {
-		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
-		wqe->inline_klms[i].bcount = cpu_to_be32(sgl_mkey->length);
-		wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
-		wqe->inline_klms[i].va	   = cpu_to_be64(sgl_mkey->dma_address);
-	}
-
-	for (; i < ALIGN(klm_entries, KLM_ALIGNMENT); i++) {
-		wqe->inline_klms[i].bcount = 0;
-		wqe->inline_klms[i].key    = 0;
-		wqe->inline_klms[i].va     = 0;
+	if (klm_type == BSF_KLM_UMR) {
+		for (i = 0; i < klm_entries; i++) {
+			lkey = queue->ccid_table[i + klm_offset].klm_mkey.key;
+			wqe->inline_klms[i].bcount = cpu_to_be32(1);
+			wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
+			wqe->inline_klms[i].va	   = 0;
+		}
+	} else {
+		lkey = queue->priv->mdev->mlx5e_res.mkey.key;
+		for (i = 0; i < klm_entries; i++) {
+			sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+			wqe->inline_klms[i].bcount = cpu_to_be32(sgl_mkey->length);
+			wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
+			wqe->inline_klms[i].va	   = cpu_to_be64(sgl_mkey->dma_address);
+		}
+
+		for (; i < ALIGN(klm_entries, KLM_ALIGNMENT); i++) {
+			wqe->inline_klms[i].bcount = 0;
+			wqe->inline_klms[i].key    = 0;
+			wqe->inline_klms[i].va     = 0;
+		}
 	}
 }
 
 static void
 build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
 		       struct mlx5e_umr_wqe *wqe, u16 ccid, int klm_entries,
-		       u32 klm_offset, u32 len)
+		       u32 klm_offset, u32 len, enum wqe_type klm_type)
 {
-	u32 id = queue->ccid_table[ccid].klm_mkey.key;
+	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey.key :
+		(queue->tirn << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS;
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
 	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
 	struct mlx5_mkey_seg	       *mkc = &wqe->mkc;
@@ -57,12 +203,12 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
 	u16 pc = queue->sq->icosq.pc;
 
 	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
-					     MLX5_OPCODE_UMR);
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
 	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				   MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
 	cseg->general_id = cpu_to_be32(id);
 
-	if (!klm_offset) {
+	if (klm_type == KLM_UMR && !klm_offset) {
 		ucseg->mkey_mask |= cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
 						MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
 		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, KLM_ALIGNMENT));
@@ -72,21 +218,152 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
 	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
 	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, KLM_ALIGNMENT));
 	ucseg->xlt_offset = cpu_to_be16(klm_offset);
-	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset, klm_type);
+}
+
+static void
+fill_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			      struct mlx5_seg_nvmeotcp_progress_params *params,
+			      u32 seq)
+{
+	void *ctx = params->ctx;
+
+	params->tir_num = cpu_to_be32(queue->tirn);
+
+	MLX5_SET(nvmeotcp_progress_params, ctx,
+		 next_pdu_tcp_sn, seq);
+	MLX5_SET(nvmeotcp_progress_params, ctx, pdu_tracker_state,
+		 MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_START);
+}
+
+void
+build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
+			       u32 seq)
+{
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	u32 sqn = queue->sq->icosq.sqn;
+	u16 pc = queue->sq->icosq.pc;
+	u8 opc_mod;
+
+	memset(wqe, 0, MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ);
+	opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS;
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_SET_PSV | (opc_mod << 24));
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   PROGRESS_PARAMS_DS_CNT);
+	fill_nvmeotcp_progress_params(queue, &wqe->params, seq);
+}
+
+static void
+fill_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			    struct mlx5_seg_nvmeotcp_static_params *params,
+			    u32 resync_seq, bool zero_copy_en,
+			    bool ddgst_offload_en)
+{
+	void *ctx = params->ctx;
+
+	MLX5_SET(transport_static_params, ctx, const_1, 1);
+	MLX5_SET(transport_static_params, ctx, const_2, 2);
+	MLX5_SET(transport_static_params, ctx, acc_type,
+		 MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP);
+	MLX5_SET(transport_static_params, ctx, nvme_resync_tcp_sn, resync_seq);
+	MLX5_SET(transport_static_params, ctx, pda, queue->pda);
+	MLX5_SET(transport_static_params, ctx, ddgst_en,
+		 queue->dgst & NVME_TCP_DATA_DIGEST_ENABLE);
+	MLX5_SET(transport_static_params, ctx, ddgst_offload_en, ddgst_offload_en);
+	MLX5_SET(transport_static_params, ctx, hddgst_en,
+		 queue->dgst & NVME_TCP_HDR_DIGEST_ENABLE);
+	MLX5_SET(transport_static_params, ctx, hdgst_offload_en, 0);
+	MLX5_SET(transport_static_params, ctx, ti,
+		 MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR);
+	MLX5_SET(transport_static_params, ctx, const1, 1);
+	MLX5_SET(transport_static_params, ctx, zero_copy_en, zero_copy_en);
+}
+
+void
+build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5e_set_nvmeotcp_static_params_wqe *wqe,
+			     u32 resync_seq, bool zerocopy, bool crc_rx)
+{
+	u8 opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	u32 sqn = queue->sq->icosq.sqn;
+	u16 pc = queue->sq->icosq.pc;
+
+	memset(wqe, 0, MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ);
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   STATIC_PARAMS_DS_CNT);
+	cseg->imm = cpu_to_be32(queue->tirn << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+
+	ucseg->flags = MLX5_UMR_INLINE;
+	ucseg->bsf_octowords =
+		cpu_to_be16(MLX5E_NVMEOTCP_STATIC_PARAMS_OCTWORD_SIZE);
+	fill_nvmeotcp_static_params(queue, &wqe->params, resync_seq, zerocopy, crc_rx);
 }
 
 static void
 mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
-		       struct mlx5e_icosq *sq, u32 wqe_bbs, u16 pi)
+		       struct mlx5e_icosq *sq, u32 wqe_bbs, u16 pi,
+		       enum wqe_type type)
 {
 	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
 
 	wi->num_wqebbs = wqe_bbs;
-	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
+	switch (type) {
+	case SET_PSV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP;
+		break;
+	default:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
+		break;
+	}
+
+	if (type == SET_PSV_UMR)
+		wi->nvmeotcp_q.queue = nvmeotcp_queue;
+}
+
+static void
+mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
+					 u32 resync_seq)
+{
+	struct mlx5e_set_nvmeotcp_static_params_wqe *wqe;
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+	u16 pi, wqe_bbs;
+
+	wqe_bbs = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, BSF_UMR);
+	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->zerocopy, queue->crc_rx);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
+static void
+mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
+					   u32 seq)
+{
+	struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe;
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+	u16 pi, wqe_bbs;
+
+	wqe_bbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
+	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, SET_PSV_UMR);
+	build_nvmeotcp_progress_params(queue, wqe, seq);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 }
 
 static void
 post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     enum wqe_type wqe_type,
 	     u16 ccid,
 	     u32 klm_length,
 	     u32 *klm_offset)
@@ -102,9 +379,9 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, wqe_type);
 	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, *klm_offset,
-			       klm_length);
+			       klm_length, wqe_type);
 	*klm_offset += cur_klm_entries;
 	sq->pc += wqe_bbs;
 	sq->doorbell_cseg = &wqe->ctrl;
@@ -112,6 +389,7 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 
 static int
 mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+			    enum wqe_type wqe_type,
 			    u16 ccid,
 			    u32 klm_length)
 {
@@ -129,31 +407,327 @@ mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 		return -ENOSPC;
 
 	for (i = 0; i < wqes; i++)
-		post_klm_wqe(queue, ccid, klm_length, &klm_offset);
+		post_klm_wqe(queue, wqe_type, ccid, klm_length, &klm_offset);
 
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
 	return 0;
 }
 
+static int mlx5e_create_nvmeotcp_mkey(struct mlx5_core_dev *mdev,
+				      u8 access_mode,
+				      u32 translation_octword_size,
+				      struct mlx5_core_mkey *mkey)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	void *mkc;
+	u32 *in;
+	int err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, free, 1);
+	MLX5_SET(mkc, mkc, translations_octword_size, translation_octword_size);
+	MLX5_SET(mkc, mkc, umr_en, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode);
+
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.pdn);
+
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct tcp_ddp_limits *limits)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	limits->max_ddp_sgl_len = mlx5e_get_max_sgl(mdev);
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_destroy_sq(struct mlx5e_nvmeotcp_sq *nvmeotcpsq)
+{
+	mlx5e_deactivate_icosq(&nvmeotcpsq->icosq);
+	mlx5e_close_icosq(&nvmeotcpsq->icosq);
+	mlx5e_close_cq(&nvmeotcpsq->icosq.cq);
+	list_del(&nvmeotcpsq->list);
+	kfree(nvmeotcpsq);
+}
+
+static int
+mlx5e_nvmeotcp_build_icosq(struct mlx5e_nvmeotcp_queue *queue,
+			   struct mlx5e_priv *priv)
+{
+	u16 max_sgl, max_klm_per_wqe, max_umr_per_ccid, sgl_rest, wqebbs_rest;
+	struct mlx5e_channel *c = priv->channels.c[queue->channel_ix];
+	struct mlx5e_sq_param icosq_param = {0};
+	struct dim_cq_moder icocq_moder = {0};
+	struct mlx5e_nvmeotcp_sq *nvmeotcp_sq;
+	struct mlx5e_create_cq_param ccp;
+	struct mlx5e_icosq *icosq;
+	int err = -ENOMEM;
+	u16 log_icosq_sz;
+	u32 max_wqebbs;
+
+	nvmeotcp_sq = kzalloc(sizeof(*nvmeotcp_sq), GFP_KERNEL);
+	if (!nvmeotcp_sq)
+		return err;
+
+	icosq = &nvmeotcp_sq->icosq;
+	max_sgl = mlx5e_get_max_sgl(priv->mdev);
+	max_klm_per_wqe = queue->max_klms_per_wqe;
+	max_umr_per_ccid = max_sgl / max_klm_per_wqe;
+	sgl_rest = max_sgl % max_klm_per_wqe;
+	wqebbs_rest = sgl_rest ? MLX5E_KLM_UMR_WQEBBS(sgl_rest) : 0;
+	max_wqebbs = (MLX5E_KLM_UMR_WQEBBS(max_klm_per_wqe) *
+		     max_umr_per_ccid + wqebbs_rest) * queue->size;
+	log_icosq_sz = order_base_2(max_wqebbs);
+
+	mlx5e_build_icosq_param(priv, log_icosq_sz, &icosq_param);
+	mlx5e_build_create_cq_param(&ccp, c);
+	err = mlx5e_open_cq(priv, icocq_moder, &icosq_param.cqp, &ccp, &icosq->cq);
+	if (err)
+		goto err_nvmeotcp_sq;
+
+	err = mlx5e_open_icosq(c, &priv->channels.params, &icosq_param, icosq);
+	if (err)
+		goto close_cq;
+
+	INIT_LIST_HEAD(&nvmeotcp_sq->list);
+	spin_lock(&c->nvmeotcp_icosq_lock);
+	list_add(&nvmeotcp_sq->list, &c->list_nvmeotcpsq);
+	spin_unlock(&c->nvmeotcp_icosq_lock);
+	queue->sq = nvmeotcp_sq;
+	mlx5e_activate_icosq(icosq);
+	return 0;
+
+close_cq:
+	mlx5e_close_cq(&icosq->cq);
+err_nvmeotcp_sq:
+	kfree(nvmeotcp_sq);
+
+	return err;
+}
+
+static void
+mlx5e_nvmeotcp_destroy_rx(struct mlx5e_nvmeotcp_queue *queue,
+			  struct mlx5_core_dev *mdev, bool zerocopy)
+{
+	int i;
+
+	mlx5e_accel_fs_del_sk(queue->fh);
+	for (i = 0; i < queue->size && zerocopy; i++)
+		mlx5_core_destroy_mkey(mdev, &queue->ccid_table[i].klm_mkey);
+
+	mlx5e_nvmeotcp_destroy_tir(queue->priv, queue->tirn);
+	if (zerocopy) {
+		kfree(queue->ccid_table);
+		mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+	}
+
+	mlx5e_nvmeotcp_destroy_sq(queue->sq);
+}
+
+static int
+mlx5e_nvmeotcp_queue_rx_init(struct mlx5e_nvmeotcp_queue *queue,
+			     struct nvme_tcp_ddp_config *config,
+			     struct net_device *netdev,
+			     bool zerocopy, bool crc)
+{
+	u8 log_queue_size = order_base_2(config->queue_size);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct sock *sk = queue->sk;
+	int err, max_sgls, i;
+
+	if (zerocopy) {
+		if (config->queue_size >
+		    BIT(MLX5_CAP_DEV_NVMEOTCP(mdev, log_max_nvmeotcp_tag_buffer_size))) {
+			return -EINVAL;
+		}
+
+		err = mlx5e_create_nvmeotcp_tag_buf_table(mdev, queue, log_queue_size);
+		if (err)
+			return err;
+	}
+
+	err = mlx5e_nvmeotcp_build_icosq(queue, priv);
+	if (err)
+		goto destroy_tag_buffer_table;
+
+	/* initializes queue->tirn */
+	err = mlx5e_nvmeotcp_create_tir(priv, sk, config, queue, zerocopy, crc);
+	if (err)
+		goto destroy_icosq;
+
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, 0);
+	mlx5e_nvmeotcp_rx_post_progress_params_wqe(queue, tcp_sk(sk)->copied_seq);
+
+	if (zerocopy) {
+		queue->ccid_table = kcalloc(queue->size,
+					    sizeof(struct nvmeotcp_queue_entry),
+					    GFP_KERNEL);
+		if (!queue->ccid_table) {
+			err = -ENOMEM;
+			goto destroy_tir;
+		}
+
+		max_sgls = mlx5e_get_max_sgl(mdev);
+		for (i = 0; i < queue->size; i++) {
+			err = mlx5e_create_nvmeotcp_mkey(mdev,
+							 MLX5_MKC_ACCESS_MODE_KLMS,
+							 max_sgls,
+							 &queue->ccid_table[i].klm_mkey);
+			if (err)
+				goto free_sgl;
+		}
+
+		err = mlx5e_nvmeotcp_post_klm_wqe(queue, BSF_KLM_UMR, 0, queue->size);
+		if (err)
+			goto free_sgl;
+	}
+
+	if (!(WARN_ON(!wait_for_completion_timeout(&queue->done, 0))))
+		queue->fh = mlx5e_accel_fs_add_sk(priv, sk, queue->tirn, queue->id);
+
+	if (IS_ERR_OR_NULL(queue->fh)) {
+		err = -EINVAL;
+		goto free_sgl;
+	}
+
 	return 0;
+
+free_sgl:
+	while ((i--) && zerocopy)
+		mlx5_core_destroy_mkey(mdev, &queue->ccid_table[i].klm_mkey);
+
+	if (zerocopy)
+		kfree(queue->ccid_table);
+destroy_tir:
+	mlx5e_nvmeotcp_destroy_tir(priv, queue->tirn);
+destroy_icosq:
+	mlx5e_nvmeotcp_destroy_sq(queue->sq);
+destroy_tag_buffer_table:
+	if (zerocopy)
+		mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+
+	return err;
 }
 
+#define OCTWORD_SHIFT 4
+#define MAX_DS_VALUE 63
 static int
 mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 			  struct sock *sk,
 			  struct tcp_ddp_config *tconfig)
 {
-	return 0;
+	struct nvme_tcp_ddp_config *config = (struct nvme_tcp_ddp_config *)tconfig;
+	bool crc_rx = ((netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX) &&
+		       (config->dgst & NVME_TCP_DATA_DIGEST_ENABLE));
+	bool zerocopy = (netdev->features & NETIF_F_HW_TCP_DDP);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+	int max_wqe_sz_cap, queue_id, err;
+
+	if (tconfig->type != TCP_DDP_NVME) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	queue_id = ida_simple_get(&priv->nvmeotcp->queue_ids,
+				  MIN_NVMEOTCP_QUEUES, MAX_NVMEOTCP_QUEUES,
+				  GFP_KERNEL);
+	if (queue_id < 0) {
+		err = -ENOSPC;
+		goto free_queue;
+	}
+
+	queue->crc_rx = crc_rx;
+	queue->zerocopy = zerocopy;
+	queue->tcp_ddp_ctx.type = TCP_DDP_NVME;
+	queue->sk = sk;
+	queue->id = queue_id;
+	queue->dgst = config->dgst;
+	queue->pda = config->cpda;
+	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv,
+							     config->io_cpu);
+	queue->size = config->queue_size;
+	max_wqe_sz_cap  = min_t(int, MAX_DS_VALUE * MLX5_SEND_WQE_DS,
+				MLX5_CAP_GEN(mdev, max_wqe_sz_sq) << OCTWORD_SHIFT);
+	queue->max_klms_per_wqe = MLX5E_KLM_ENTRIES_PER_WQE(max_wqe_sz_cap);
+	queue->priv = priv;
+	init_completion(&queue->done);
+
+	if (zerocopy || crc_rx) {
+		err = mlx5e_nvmeotcp_queue_rx_init(queue, config, netdev,
+						   zerocopy, crc_rx);
+		if (err)
+			goto remove_queue_id;
+	}
+
+	err = rhashtable_insert_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+				     rhash_queues);
+	if (err)
+		goto destroy_rx;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	tcp_ddp_set_ctx(sk, queue);
+	write_unlock_bh(&sk->sk_callback_lock);
+	refcount_set(&queue->ref_count, 1);
+	return err;
+
+destroy_rx:
+	if (zerocopy || crc_rx)
+		mlx5e_nvmeotcp_destroy_rx(queue, mdev, zerocopy);
+remove_queue_id:
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue_id);
+free_queue:
+	kfree(queue);
+out:
+	return err;
 }
 
 static void
 mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 			      struct sock *sk)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
+
+	napi_synchronize(&priv->channels.c[queue->channel_ix]->napi);
+
+	WARN_ON(refcount_read(&queue->ref_count) != 1);
+	if (queue->zerocopy | queue->crc_rx)
+		mlx5e_nvmeotcp_destroy_rx(queue, mdev, queue->zerocopy);
+
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+			       rhash_queues);
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue->id);
+	write_lock_bh(&sk->sk_callback_lock);
+	tcp_ddp_set_ctx(sk, NULL);
+	write_unlock_bh(&sk->sk_callback_lock);
+	mlx5e_nvmeotcp_put_queue(queue);
 }
 
 static int
@@ -164,6 +738,16 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	return 0;
 }
 
+void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct mlx5e_nvmeotcp_queue *queue = wi->nvmeotcp_q.queue;
+
+	if (unlikely(!queue))
+		return;
+
+	complete(&queue->done);
+}
+
 static int
 mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 			    struct sock *sk,
@@ -188,6 +772,27 @@ static const struct tcp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
 	.tcp_ddp_resync = mlx5e_nvmeotcp_dev_resync,
 };
 
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id)
+{
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	rcu_read_lock();
+	queue = rhashtable_lookup_fast(&nvmeotcp->queue_hash,
+				       &id, rhash_queues);
+	if (queue && !IS_ERR(queue))
+		if (!refcount_inc_not_zero(&queue->ref_count))
+			queue = NULL;
+	rcu_read_unlock();
+	return queue;
+}
+
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue)
+{
+	if (refcount_dec_and_test(&queue->ref_count))
+		kfree(queue);
+}
+
 int set_feature_nvme_tcp(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 753757fc44a3..d0e515502d6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -100,6 +100,10 @@ int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
 int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
 int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable);
 void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi);
 int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
 #else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
index 329e114d6571..44671e28a9ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -4,9 +4,77 @@
 #define __MLX5E_NVMEOTCP_UTILS_H__
 
 #include "en.h"
+#include "en_accel/nvmeotcp.h"
+
+enum {
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_START     = 0,
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_SEARCHING = 2,
+};
+
+struct mlx5_seg_nvmeotcp_static_params {
+	u8     ctx[MLX5_ST_SZ_BYTES(transport_static_params)];
+};
+
+struct mlx5_seg_nvmeotcp_progress_params {
+	__be32 tir_num;
+	u8     ctx[MLX5_ST_SZ_BYTES(nvmeotcp_progress_params)];
+};
+
+struct mlx5e_set_nvmeotcp_static_params_wqe {
+	struct mlx5_wqe_ctrl_seg          ctrl;
+	struct mlx5_wqe_umr_ctrl_seg      uctrl;
+	struct mlx5_mkey_seg              mkc;
+	struct mlx5_seg_nvmeotcp_static_params params;
+};
+
+struct mlx5e_set_nvmeotcp_progress_params_wqe {
+	struct mlx5_wqe_ctrl_seg            ctrl;
+	struct mlx5_seg_nvmeotcp_progress_params params;
+};
+
+struct mlx5e_get_psv_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_seg_get_psv  psv;
+};
+
+///////////////////////////////////////////
+#define MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ \
+	(sizeof(struct mlx5e_set_nvmeotcp_static_params_wqe))
+
+#define MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ \
+	(sizeof(struct mlx5e_set_nvmeotcp_progress_params_wqe))
+#define MLX5E_NVMEOTCP_STATIC_PARAMS_OCTWORD_SIZE \
+	(MLX5_ST_SZ_BYTES(transport_static_params) / MLX5_SEND_WQE_DS)
+
+#define MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ, MLX5_SEND_WQE_BB))
+#define MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ, MLX5_SEND_WQE_BB))
+
+#define MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_nvmeotcp_static_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_nvmeotcp_static_params_wqe)))
+
+#define MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_nvmeotcp_progress_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_nvmeotcp_progress_params_wqe)))
 
 #define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
 	((struct mlx5e_umr_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
 
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS 0x4
+
+void
+build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
+			       u32 seq);
+
+void
+build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5e_set_nvmeotcp_static_params_wqe *wqe,
+			     u32 resync_seq,
+			     bool zerocopy, bool crc_rx);
+
 #endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 974e34c956ed..c08d8cfdaebe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -47,6 +47,7 @@
 #include "fpga/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
+#include "en_accel/nvmeotcp.h"
 #include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
@@ -629,6 +630,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
 			break;
+		case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
+			mlx5e_nvmeotcp_ctx_comp(wi);
+			break;
 #endif
 		}
 	}
@@ -703,6 +707,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
 				break;
+			case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
+				mlx5e_nvmeotcp_ctx_comp(wi);
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.24.1

