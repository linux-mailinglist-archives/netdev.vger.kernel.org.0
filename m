Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220132D1C36
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgLGVeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:34:36 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48065 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725924AbgLGVeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:34:36 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:54 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qIK029788;
        Mon, 7 Dec 2020 23:06:53 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v1 net-next 12/15] net/mlx5e: NVMEoTCP DDP offload control path
Date:   Mon,  7 Dec 2020 23:06:46 +0200
Message-Id: <20201207210649.19194-13-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake
using the tcp_ddp_sk_add/del NDOs.

Additionally, a resynchronization routine is used to assist
hardware recovery from TCP OOO, and continue the offload.
Resynchronization operates as follows:
1. TCP OOO causes the NIC HW to stop the offload
2. NIC HW identifies a PDU header at some TCP sequence number,
and asks NVMe-TCP to confirm it.
This request is delivered from the NIC driver to NVMe-TCP by first
finding the socket for the packet that triggered the request, and
then fiding the nvme_tcp_queue that is used by this routine.
Finally, the request is recorded in the nvme_tcp_queue.
3. When NVMe-TCP observes the requested TCP sequence, it will compare
it with the PDU header TCP sequence, and report the result to the
NIC driver (tcp_ddp_resync), which will update the HW,
and resume offload when all is successful.

Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments via tcp_ddp_limits.

A follow-up patch introduces the data-path changes required for this
offload.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  30 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  13 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   9 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 984 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 116 +++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  80 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  39 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  25 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 13 files changed, 1327 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 485478979b1a..95c8c1980c96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -202,3 +202,14 @@ config MLX5_SW_STEERING
 	default y
 	help
 	Build support for software-managed steering in the NIC.
+
+config MLX5_EN_NVMEOTCP
+	bool "NVMEoTCP accelaration"
+	depends on MLX5_CORE_EN
+	depends on TCP_DDP
+	depends on TCP_DDP_CRC
+	default y
+	help
+	Build support for NVMEoTCP accelaration in the NIC.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index ac7793057658..053655a96db8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -87,3 +87,5 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste_v0.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
+
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0da6ed47a571..8e257749018a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -152,6 +152,24 @@ struct page_pool;
 #define MLX5E_UMR_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_BB))
 
+#define KLM_ALIGNMENT 4
+#define MLX5E_KLM_UMR_WQE_SZ(sgl_len)\
+	(sizeof(struct mlx5e_umr_wqe) +\
+	(sizeof(struct mlx5_klm) * (sgl_len)))
+
+#define MLX5E_KLM_UMR_WQEBBS(sgl_len)\
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_BB))
+
+#define MLX5E_KLM_UMR_DS_CNT(sgl_len)\
+	DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_DS)
+
+#define MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size)\
+	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
+
+#define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
+	(MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size) -\
+			(MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size) % KLM_ALIGNMENT))
+
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
 #define mlx5e_dbg(mlevel, priv, format, ...)                    \
@@ -214,7 +232,10 @@ struct mlx5e_umr_wqe {
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
@@ -664,6 +685,10 @@ struct mlx5e_channel {
 	struct mlx5e_xdpsq         rq_xdpsq;
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct list_head	   list_nvmeotcpsq;   /* nvmeotcp umrs  */
+	spinlock_t                 nvmeotcp_icosq_lock;
+#endif
 	bool                       xdp;
 	struct napi_struct         napi;
 	struct device             *pdev;
@@ -856,6 +881,9 @@ struct mlx5e_priv {
 #endif
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_tls          *tls;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_nvmeotcp      *nvmeotcp;
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 807147d97a0f..20e9e5e81ae7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -16,6 +16,7 @@ struct mlx5e_cq_param {
 	struct mlx5_wq_param       wq;
 	u16                        eq_ix;
 	u8                         cq_period_mode;
+	bool                       force_cqe128;
 };
 
 struct mlx5e_rq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7943eb30b837..eb929edabd6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -34,6 +34,11 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVME_TCP,
+	MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE,
+	MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP,
+#endif
 };
 
 /* General */
@@ -175,6 +180,14 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_ktls_rx_resync_buf *buf;
 		} tls_get_params;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		struct {
+			struct mlx5e_nvmeotcp_queue *queue;
+		} nvmeotcp_q;
+		struct {
+			struct nvmeotcp_queue_entry *entry;
+		} nvmeotcp_qe;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index fb89b24deb2b..98728f7404ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -39,6 +39,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls.h"
 #include "en_accel/tls_rxtx.h"
+#include "en_accel/nvmeotcp.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -196,11 +197,17 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
-	return mlx5e_ktls_init_rx(priv);
+	int tls, nvmeotcp;
+
+	tls = mlx5e_ktls_init_rx(priv);
+	nvmeotcp = mlx5e_nvmeotcp_init_rx(priv);
+
+	return tls && nvmeotcp;
 }
 
 static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_nvmeotcp_cleanup_rx(priv);
 	mlx5e_ktls_cleanup_rx(priv);
 }
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
new file mode 100644
index 000000000000..843e653699e9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -0,0 +1,984 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#include <linux/netdevice.h>
+#include <linux/idr.h>
+#include <linux/nvme-tcp.h>
+#include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
+#include "en_accel/fs_tcp.h"
+#include "en/txrx.h"
+
+#define MAX_NVMEOTCP_QUEUES	(512)
+#define MIN_NVMEOTCP_QUEUES	(1)
+
+static const struct rhashtable_params rhash_queues = {
+	.key_len = sizeof(int),
+	.key_offset = offsetof(struct mlx5e_nvmeotcp_queue, id),
+	.head_offset = offsetof(struct mlx5e_nvmeotcp_queue, hash),
+	.automatic_shrinking = true,
+	.min_size = 1,
+	.max_size = MAX_NVMEOTCP_QUEUES,
+};
+
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
+	KLM_INV_UMR = 4,
+};
+
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+		      struct mlx5e_umr_wqe *wqe, u16 ccid, u32 klm_entries,
+		      u16 klm_offset, enum wqe_type klm_type)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
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
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
+		       struct mlx5e_umr_wqe *wqe, u16 ccid, int klm_entries,
+		       u32 klm_offset, u32 len, enum wqe_type klm_type)
+{
+	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey.key :
+		(queue->tirn << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
+		MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg	       *mkc = &wqe->mkc;
+
+	u32 sqn = queue->sq->icosq.sqn;
+	u16 pc = queue->sq->icosq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
+	cseg->general_id = cpu_to_be32(id);
+
+	if (!klm_entries) { /* this is invalidate */
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_FREE);
+		ucseg->flags = MLX5_UMR_INLINE;
+		mkc->status = MLX5_MKEY_STATUS_FREE;
+		return;
+	}
+
+	if (klm_type == KLM_UMR && !klm_offset) {
+		ucseg->mkey_mask |= cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, KLM_ALIGNMENT));
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
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
+	MLX5_SET(nvmeotcp_progress_params, ctx,
+		 next_pdu_tcp_sn, seq);
+	MLX5_SET(nvmeotcp_progress_params, ctx, valid, 1);
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
+	cseg->general_id = cpu_to_be32(queue->tirn <<
+				       MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
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
+	MLX5_SET(transport_static_params, ctx, ddgst_en, queue->dgst);
+	MLX5_SET(transport_static_params, ctx, ddgst_offload_en, ddgst_offload_en);
+	MLX5_SET(transport_static_params, ctx, hddgst_en, 0);
+	MLX5_SET(transport_static_params, ctx, hdgst_offload_en, 0);
+	MLX5_SET(transport_static_params, ctx, ti,
+		 MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR);
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
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
+		       struct mlx5e_icosq *sq, u32 wqe_bbs,
+		       u16 pi, u16 ccid, enum wqe_type type)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	wi->num_wqebbs = wqe_bbs;
+	switch (type) {
+	case SET_PSV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP;
+		break;
+	case KLM_INV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE;
+		break;
+	default:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
+		break;
+	}
+
+	if (type == KLM_INV_UMR)
+		wi->nvmeotcp_qe.entry = &nvmeotcp_queue->ccid_table[ccid];
+	else if (type == SET_PSV_UMR)
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
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, 0, BSF_UMR);
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
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, 0, SET_PSV_UMR);
+	build_nvmeotcp_progress_params(queue, wqe, seq);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
+static void
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     enum wqe_type wqe_type,
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
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi, ccid,
+			       klm_length ? KLM_UMR : KLM_INV_UMR);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, *klm_offset,
+			       klm_length, wqe_type);
+	*klm_offset += cur_klm_entries;
+	sq->pc += wqe_bbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+}
+
+static int
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+			    enum wqe_type wqe_type,
+			    u16 ccid,
+			    u32 klm_length)
+{
+	u32 klm_offset = 0, wqes, wqe_sz, max_wqe_bbs, i, room;
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+
+	/* TODO: set stricter wqe_sz; using max for now */
+	if (klm_length == 0) {
+		wqes = 1;
+		wqe_sz = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	} else {
+		wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+		wqe_sz = MLX5E_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
+	}
+
+	max_wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+
+	room = mlx5e_stop_room_for_wqe(max_wqe_bbs) * wqes;
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+		return -ENOSPC;
+
+	for (i = 0; i < wqes; i++)
+		post_klm_wqe(queue, wqe_type, ccid, klm_length, &klm_offset);
+
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+	return 0;
+}
+
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
+	MLX5_SET(mkc, mkc, length64, 1);
+
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
+static int
+mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
+			      struct tcp_ddp_limits *limits)
+{
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
+		static_branch_dec(&skip_copy_enabled);
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
+	if (zerocopy)
+		static_branch_inc(&skip_copy_enabled);
+
+	return 0;
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
+}
+
+#define OCTWORD_SHIFT 4
+#define MAX_DS_VALUE 63
+static int
+mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
+			  struct sock *sk,
+			  struct tcp_ddp_config *tconfig)
+{
+	struct nvme_tcp_ddp_config *config = (struct nvme_tcp_ddp_config *)tconfig;
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
+	queue->crc_rx = (config->dgst & NVME_TCP_DATA_DIGEST_ENABLE) &&
+			(netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX);
+	queue->zerocopy = (netdev->features & NETIF_F_HW_TCP_DDP);
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
+	if (queue->zerocopy || queue->crc_rx) {
+		err = mlx5e_nvmeotcp_queue_rx_init(queue, config, netdev,
+						   queue->zerocopy, queue->crc_rx);
+			if (err)
+				goto remove_queue_id;
+	}
+
+	err = rhashtable_insert_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+				     rhash_queues);
+	if (err)
+		goto destroy_rx;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(inet_csk(sk)->icsk_ulp_ddp_data, queue);
+	write_unlock_bh(&sk->sk_callback_lock);
+	refcount_set(&queue->ref_count, 1);
+	return err;
+
+destroy_rx:
+	if (queue->zerocopy || queue->crc_rx)
+		mlx5e_nvmeotcp_destroy_rx(queue, mdev, queue->zerocopy);
+remove_queue_id:
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue_id);
+free_queue:
+	kfree(queue);
+out:
+	return err;
+}
+
+static void
+mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
+			      struct sock *sk)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = (struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+
+	napi_synchronize(&priv->channels.c[queue->channel_ix]->napi);
+
+	WARN_ON(refcount_read(&queue->ref_count) != 1);
+	if (queue->zerocopy | queue->crc_rx)
+		mlx5e_nvmeotcp_destroy_rx(queue, mdev, queue->zerocopy);
+
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+			       rhash_queues);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(inet_csk(sk)->icsk_ulp_ddp_data, NULL);
+	write_unlock_bh(&sk->sk_callback_lock);
+	mlx5e_nvmeotcp_put_queue(queue);
+}
+
+static int
+mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
+			 struct sock *sk,
+			 struct tcp_ddp_io *ddp)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5_core_dev *mdev;
+	int count = 0;
+
+	queue = (struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+
+	mdev = queue->priv->mdev;
+	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
+			   DMA_FROM_DEVICE);
+
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
+		return -ENOSPC;
+
+	queue->ccid_table[ddp->command_id].ddp = ddp;
+	queue->ccid_table[ddp->command_id].sgl = sg;
+	queue->ccid_table[ddp->command_id].ccid_gen++;
+	queue->ccid_table[ddp->command_id].sgl_length = count;
+
+	return 0;
+}
+
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct nvmeotcp_queue_entry *q_entry = wi->nvmeotcp_qe.entry;
+	struct mlx5e_nvmeotcp_queue *queue = q_entry->queue;
+	struct mlx5_core_dev *mdev = queue->priv->mdev;
+	struct tcp_ddp_io *ddp = q_entry->ddp;
+	const struct tcp_ddp_ulp_ops *ulp_ops;
+
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl,
+		     q_entry->sgl_length, DMA_FROM_DEVICE);
+
+	q_entry->sgl_length = 0;
+
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->ddp_teardown_done)
+		ulp_ops->ddp_teardown_done(q_entry->ddp_ctx);
+}
+
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
+static int
+mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
+			    struct sock *sk,
+			    struct tcp_ddp_io *ddp,
+			    void *ddp_ctx)
+{
+	struct mlx5e_nvmeotcp_queue *queue =
+		(struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct nvmeotcp_queue_entry *q_entry;
+
+	q_entry  = &queue->ccid_table[ddp->command_id];
+	WARN_ON(q_entry->sgl_length == 0);
+
+	q_entry->ddp_ctx = ddp_ctx;
+	q_entry->queue = queue;
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
+
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_dev_resync(struct net_device *netdev,
+			  struct sock *sk, u32 seq)
+{
+	struct mlx5e_nvmeotcp_queue *queue =
+				(struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
+}
+
+static const struct tcp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
+	.tcp_ddp_limits = mlx5e_nvmeotcp_offload_limits,
+	.tcp_ddp_sk_add = mlx5e_nvmeotcp_queue_init,
+	.tcp_ddp_sk_del = mlx5e_nvmeotcp_queue_teardown,
+	.tcp_ddp_setup = mlx5e_nvmeotcp_ddp_setup,
+	.tcp_ddp_teardown = mlx5e_nvmeotcp_ddp_teardown,
+	.tcp_ddp_resync = mlx5e_nvmeotcp_dev_resync,
+};
+
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
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable)
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
+	if (err)
+		return err;
+
+	priv->nvmeotcp->enable = enable;
+	err = mlx5e_safe_reopen_channels(priv);
+	return err;
+}
+
+int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable)
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
+	priv->nvmeotcp->crc_rx_enable = enable;
+	err = mlx5e_safe_reopen_channels(priv);
+	if (err)
+		netdev_err(priv->netdev,
+			   "%s failed to reopen channels, err(%d).\n",
+			   __func__, err);
+
+	return err;
+}
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+
+	if (!MLX5_CAP_GEN(priv->mdev, nvmeotcp))
+		return;
+
+	if (MLX5_CAP_DEV_NVMEOTCP(priv->mdev, zerocopy)) {
+		netdev->features |= NETIF_F_HW_TCP_DDP;
+		netdev->hw_features |= NETIF_F_HW_TCP_DDP;
+	}
+
+	if (MLX5_CAP_DEV_NVMEOTCP(priv->mdev, crc_rx)) {
+		netdev->features |= NETIF_F_HW_TCP_DDP_CRC_RX;
+		netdev->hw_features |= NETIF_F_HW_TCP_DDP_CRC_RX;
+	}
+
+	netdev->tcp_ddp_ops = &mlx5e_nvmeotcp_ops;
+	priv->nvmeotcp->enable = true;
+}
+
+int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP) {
+		ret = mlx5e_accel_fs_tcp_create(priv);
+		if (ret)
+			return ret;
+	}
+
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX)
+		ret = mlx5e_accel_fs_tcp_create(priv);
+
+	return ret;
+}
+
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv)
+{
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP)
+		mlx5e_accel_fs_tcp_destroy(priv);
+
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX)
+		mlx5e_accel_fs_tcp_destroy(priv);
+}
+
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = kzalloc(sizeof(*nvmeotcp), GFP_KERNEL);
+	int ret = 0;
+
+	if (!nvmeotcp)
+		return -ENOMEM;
+
+	ida_init(&nvmeotcp->queue_ids);
+	ret = rhashtable_init(&nvmeotcp->queue_hash, &rhash_queues);
+	if (ret)
+		goto err_ida;
+
+	priv->nvmeotcp = nvmeotcp;
+	goto out;
+
+err_ida:
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+out:
+	return ret;
+}
+
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv)
+{
+	struct mlx5e_nvmeotcp *nvmeotcp = priv->nvmeotcp;
+
+	if (!nvmeotcp)
+		return;
+
+	rhashtable_destroy(&nvmeotcp->queue_hash);
+	ida_destroy(&nvmeotcp->queue_ids);
+	kfree(nvmeotcp);
+	priv->nvmeotcp = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
new file mode 100644
index 000000000000..5be300d8299e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+#ifndef __MLX5E_NVMEOTCP_H__
+#define __MLX5E_NVMEOTCP_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include "net/tcp_ddp.h"
+#include "en.h"
+#include "en/params.h"
+
+struct nvmeotcp_queue_entry {
+	struct mlx5e_nvmeotcp_queue	*queue;
+	u32				sgl_length;
+	struct mlx5_core_mkey		klm_mkey;
+	struct scatterlist		*sgl;
+	u32				ccid_gen;
+
+	/* for the ddp invalidate done callback */
+	void				*ddp_ctx;
+	struct tcp_ddp_io		*ddp;
+};
+
+struct mlx5e_nvmeotcp_sq {
+	struct list_head		list;
+	struct mlx5e_icosq		icosq;
+};
+
+/**
+ *	struct mlx5e_nvmeotcp_queue - MLX5 metadata for NVMEoTCP queue
+ *	@fh: Flow handle representing the 5-tuple steering for this flow
+ *	@tirn: Destination TIR number created for NVMEoTCP offload
+ *	@id: Flow tag ID used to identify this queue
+ *	@size: NVMEoTCP queue depth
+ *	@sq: Send queue used for sending control messages
+ *	@ccid_table: Table holding metadata for each CC
+ *	@tag_buf_table_id: Tag buffer table for CCIDs
+ *	@hash: Hash table of queues mapped by @id
+ *	@ref_count: Reference count for this structure
+ *	@ccoff: Offset within the current CC
+ *	@pda: Padding alignment
+ *	@ccid_gen: Generation ID for the CCID, used to avoid conflicts in DDP
+ *	@max_klms_per_wqe: Number of KLMs per DDP operation
+ *	@channel_ix: Channel IX for this nvmeotcp_queue
+ *	@sk: The socket used by the NVMe-TCP queue
+ *	@zerocopy: if this queue is used for zerocopy offload.
+ *	@crc_rx: if this queue is used for CRC Rx offload.
+ *	@ccid: ID of the current CC
+ *	@ccsglidx: Index within the scatter-gather list (SGL) of the current CC
+ *	@ccoff_inner: Current offset within the @ccsglidx element
+ *	@priv: mlx5e netdev priv
+ *	@inv_done: invalidate callback of the nvme tcp driver
+ */
+struct mlx5e_nvmeotcp_queue {
+	struct tcp_ddp_ctx		tcp_ddp_ctx;
+	struct mlx5_flow_handle		*fh;
+	int				tirn;
+	int				id;
+	u32				size;
+	struct mlx5e_nvmeotcp_sq	*sq;
+	struct nvmeotcp_queue_entry	*ccid_table;
+	u32				tag_buf_table_id;
+	struct rhash_head		hash;
+	refcount_t			ref_count;
+	bool				dgst;
+	int				pda;
+	u32				ccid_gen;
+	u32				max_klms_per_wqe;
+	u32				channel_ix;
+	struct sock			*sk;
+	bool				zerocopy;
+	bool				crc_rx;
+
+	/* current ccid fields */
+	off_t				ccoff;
+	int				ccid;
+	int				ccsglidx;
+	int				ccoff_inner;
+
+	/* for ddp invalidate flow */
+	struct mlx5e_priv		*priv;
+
+	/* for flow_steering flow */
+	struct completion		done;
+};
+
+struct mlx5e_nvmeotcp {
+	struct ida			queue_ids;
+	struct rhashtable		queue_hash;
+	bool				enable;
+	bool				crc_rx_enable;
+};
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
+int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable);
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
+void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi);
+int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+#else
+
+static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) { }
+static inline int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) { }
+static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
+static inline int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable) { return 0; }
+static inline int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) { }
+#endif
+#endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..3848fcec59c3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
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
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
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
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 158fc05f0c4c..d58826d93f3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -47,6 +47,7 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/tls.h"
+#include "en_accel/nvmeotcp.h"
 #include "accel/ipsec.h"
 #include "accel/tls.h"
 #include "lib/vxlan.h"
@@ -2015,6 +2016,10 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->irq_desc = irq_to_desc(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	INIT_LIST_HEAD(&c->list_nvmeotcpsq);
+	spin_lock_init(&c->nvmeotcp_icosq_lock);
+#endif
 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
 	err = mlx5e_open_queues(c, params, cparam);
@@ -2247,7 +2252,8 @@ static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
 	void *cqc = param->cqc;
 
 	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
+	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) &&
+	    (cache_line_size() >= 128 || param->force_cqe128))
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
@@ -2261,6 +2267,11 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 	void *cqc = param->cqc;
 	u8 log_cq_size;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	/* nvme-tcp offload mandates 128 byte cqes */
+	param->force_cqe128 |= (priv->nvmeotcp->enable || priv->nvmeotcp->crc_rx_enable);
+#endif
+
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
@@ -3957,6 +3968,10 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP, set_feature_nvme_tcp);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP_CRC_RX, set_feature_nvme_tcp_crc);
+#endif
 
 	if (err) {
 		netdev->features = oper_features;
@@ -3993,6 +4008,23 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
+
+		features &= ~NETIF_F_HW_TCP_DDP;
+		if (netdev->features & NETIF_F_HW_TCP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when CQE compress is active\n");
+
+		features &= ~NETIF_F_HW_TCP_DDP_CRC_RX;
+		if (netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX)
+			netdev_warn(netdev, "Disabling tcp-ddp-crc-rx offload, not supported when CQE compression is active\n");
+	}
+
+	if (netdev->features & NETIF_F_LRO) {
+		features &= ~NETIF_F_HW_TCP_DDP;
+		if (netdev->features & NETIF_F_HW_TCP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when LRO is active\n");
+		features &= ~NETIF_F_HW_TCP_DDP_CRC_RX;
+		if (netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX)
+			netdev_warn(netdev, "Disabling tcp-ddp-crc-rx offload, not supported when LRO is active\n");
 	}
 
 	mutex_unlock(&priv->state_lock);
@@ -5064,6 +5096,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
+	mlx5e_nvmeotcp_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -5128,6 +5161,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	err = mlx5e_tls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
+	err = mlx5e_nvmeotcp_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "NVMEoTCP initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
 	err = mlx5e_devlink_port_register(priv);
 	if (err)
@@ -5141,6 +5177,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_devlink_port_unregister(priv);
+	mlx5e_nvmeotcp_cleanup(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 377e547840f3..598d62366af2 100644
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
@@ -617,16 +618,26 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
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
+		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE:
+			mlx5e_nvmeotcp_ddp_inv_done(wi);
+			break;
+		case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
+			mlx5e_nvmeotcp_ctx_comp(wi);
+			break;
+#endif
+		}
 	}
 	sq->cc = sqcc;
 }
@@ -695,6 +706,16 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
+				break;
+			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP_INVALIDATE:
+				mlx5e_nvmeotcp_ddp_inv_done(wi);
+				break;
+			case MLX5E_ICOSQ_WQE_SET_PSV_NVME_TCP:
+				mlx5e_nvmeotcp_ctx_comp(wi);
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 1ec3d62f026d..cd89d4dd2710 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -36,6 +36,7 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
+#include "en_accel/nvmeotcp.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 {
@@ -158,6 +159,15 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		 * queueing more WQEs and overflowing the async ICOSQ.
 		 */
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct list_head *cur;
+	struct mlx5e_nvmeotcp_sq *nvmeotcp_sq;
+
+	list_for_each(cur, &c->list_nvmeotcpsq) {
+		nvmeotcp_sq = list_entry(cur, struct mlx5e_nvmeotcp_sq, list);
+		mlx5e_poll_ico_cq(&nvmeotcp_sq->icosq.cq);
+	}
+#endif
 
 	busy |= INDIRECT_CALL_2(rq->post_wqes,
 				mlx5e_post_rx_mpwqes,
@@ -196,6 +206,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&rq->cq);
 	mlx5e_cq_arm(&c->icosq.cq);
 	mlx5e_cq_arm(&c->async_icosq.cq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	list_for_each(cur, &c->list_nvmeotcpsq) {
+		nvmeotcp_sq = list_entry(cur, struct mlx5e_nvmeotcp_sq, list);
+		mlx5e_cq_arm(&nvmeotcp_sq->icosq.cq);
+	}
+#endif
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
 	if (xsk_open) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 02558ac2ace6..5e7544ccae91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -256,6 +256,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, nvmeotcp)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_NVMEOTCP);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.24.1

