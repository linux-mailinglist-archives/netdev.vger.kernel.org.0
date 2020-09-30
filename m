Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BD027EEF1
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgI3QUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:47 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50545 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731308AbgI3QUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:43 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:28 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2K032498;
        Wed, 30 Sep 2020 19:20:28 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 09/10] net/mlx5e: Add NVMEoTCP offload
Date:   Wed, 30 Sep 2020 19:20:09 +0300
Message-Id: <20200930162010.21610-10-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NVMEoTCP offload to mlx5.

This patch implements the NVME-TCP offload added by previous commits.
Similarly to other layer-5 offload, the offload is mapped to a TIR, and
updated using WQEs.

- Use 128B CQEs when NVME-TCP offload is enabled
- Implement asynchronous ddp invalidaation by completing the nvme-tcp
  request only when the invalidate UMR is done
- Use KLM UMRs to implement ddp
- Use a dedicated icosq for all NVME-TCP work. This SQ is unique in the
  sense that it is driven directly by the NVME-TCP layer to submit and
  invalidate ddp requests.
- Add statistics for offload packets/bytes, ddp setup/teardown, and
  queue init/teardown

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  13 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   9 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |  10 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 894 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 116 +++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  79 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  73 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  25 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  26 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  16 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 include/linux/mlx5/device.h                   |   8 +
 include/linux/mlx5/mlx5_ifc.h                 | 121 ++-
 include/linux/mlx5/qp.h                       |   1 +
 19 files changed, 1419 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 99f1ec3b2575..20fc7795f7c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -201,3 +201,14 @@ config MLX5_SW_STEERING
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
index 9826a041e407..9dd6b41c2486 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -84,3 +84,5 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
+
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5368e06cd71c..a8c0fc98b394 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -209,7 +209,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt        inline_mtts[0];
+		struct mlx5_klm        inline_klms[0];
+	};
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
@@ -642,6 +645,9 @@ struct mlx5e_channel {
 	struct mlx5e_xdpsq         rq_xdpsq;
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_icosq         nvmeotcpsq;   /* nvmeotcp umrs  */
+#endif
 	bool                       xdp;
 	struct napi_struct         napi;
 	struct device             *pdev;
@@ -815,6 +821,9 @@ struct mlx5e_priv {
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
index a87273e801b2..7d280c35f538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -16,6 +16,7 @@ struct mlx5e_cq_param {
 	struct mlx5_wq_param       wq;
 	u16                        eq_ix;
 	u8                         cq_period_mode;
+	bool                       force_cqe128;
 };
 
 struct mlx5e_rq_param {
@@ -38,6 +39,9 @@ struct mlx5e_channel_param {
 	struct mlx5e_sq_param      xdp_sq;
 	struct mlx5e_sq_param      icosq;
 	struct mlx5e_sq_param      async_icosq;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_sq_param      nvmeotcpsq;
+#endif
 };
 
 static inline bool mlx5e_qid_get_ch_if_in_group(struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 07ee1d236ab3..1aec1900bee9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -32,6 +32,11 @@ enum mlx5e_icosq_wqe_type {
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
@@ -173,6 +178,14 @@ struct mlx5e_icosq_wqe_info {
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
index 2ea1cdc1ca54..2fa6f9286ed9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -39,6 +39,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls.h"
 #include "en_accel/tls_rxtx.h"
+#include "en_accel/nvmeotcp.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -162,11 +163,17 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 97f1594cee11..feded6c8cca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t		ref_count;
 };
 
 static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -335,6 +336,7 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 			return err;
 		}
 	}
+	refcount_set(&priv->fs.accel_tcp->ref_count, 1);
 	return 0;
 }
 
@@ -358,6 +360,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
 	if (!priv->fs.accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&priv->fs.accel_tcp->ref_count))
+		return;
+
 	accel_fs_tcp_disable(priv);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -374,6 +379,11 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (priv->fs.accel_tcp) {
+		refcount_inc(&priv->fs.accel_tcp->ref_count);
+		return 0;
+	}
+
 	priv->fs.accel_tcp = kzalloc(sizeof(*priv->fs.accel_tcp), GFP_KERNEL);
 	if (!priv->fs.accel_tcp)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
new file mode 100644
index 000000000000..2dc7d3ad093c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -0,0 +1,894 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#include <linux/netdevice.h>
+#include <linux/blkdev.h>
+#include <linux/blk-mq.h>
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
+				     struct nvme_tcp_config *config,
+				     struct mlx5e_nvmeotcp_queue *queue)
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
+	MLX5_SET(tirc, tirc, nvmeotcp_zero_copy_en, 1);
+	MLX5_SET(tirc, tirc, nvmeotcp_tag_buffer_table_id,
+		 queue->tag_buf_table_id);
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
+#define KLM_ALIGNMENT 4
+#define MLX5E_NVMEOTCP_KLM_UMR_WQE_SZ(sgl_len)\
+	(sizeof(struct mlx5e_umr_wqe) +\
+	(sizeof(struct mlx5_klm) * (sgl_len)))
+
+#define MLX5E_NVMEOTCP_KLM_UMR_WQEBBS(sgl_len)\
+	(DIV_ROUND_UP(MLX5E_NVMEOTCP_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_BB))
+
+#define NVMEOTCP_KLM_UMR_DS_CNT(sgl_len)\
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_DS)
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+
+#define MAX_KLM_ENTRIES_PER_WQE(wqe_size)\
+	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
+
+#define KLM_ENTRIES_PER_WQE(wqe_size)\
+	(MAX_KLM_ENTRIES_PER_WQE(wqe_size) -\
+			(MAX_KLM_ENTRIES_PER_WQE(wqe_size) % KLM_ALIGNMENT))
+#define STATIC_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_STATIC_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
+#define PROGRESS_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
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
+			wqe->inline_klms[i].bcount =
+					cpu_to_be32(sgl_mkey->length);
+			wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
+			wqe->inline_klms[i].va	   =
+					cpu_to_be64(sgl_mkey->dma_address);
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
+	struct mlx5_mkey_seg          *mkc  = &wqe->mkc;
+	u32 sqn = queue->sq->sqn;
+	u16 pc = queue->sq->pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   NVMEOTCP_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
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
+		wqe->mkc.xlt_oct_size = cpu_to_be32(ALIGN(len, KLM_ALIGNMENT));
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries,
+			      klm_offset, klm_type);
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
+	u32 sqn = queue->sq->sqn;
+	u16 pc = queue->sq->pc;
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
+			    u32 resync_seq)
+{
+	struct mlx5_core_dev *mdev = queue->priv->mdev;
+	void *ctx = params->ctx;
+
+	MLX5_SET(transport_static_params, ctx, const_1, 1);
+	MLX5_SET(transport_static_params, ctx, const_2, 2);
+	MLX5_SET(transport_static_params, ctx, acc_type,
+		 MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP);
+	MLX5_SET(transport_static_params, ctx, nvme_resync_tcp_sn, resync_seq);
+	MLX5_SET(transport_static_params, ctx, pda, queue->pda);
+	MLX5_SET(transport_static_params, ctx, ddgst_en, queue->dgst);
+	MLX5_SET(transport_static_params, ctx, ddgst_offload_en,
+		 queue->dgst && MLX5_CAP_DEV_NVMEOTCP(mdev, crc_rx));
+	MLX5_SET(transport_static_params, ctx, hddgst_en, 0);
+	MLX5_SET(transport_static_params, ctx, hdgst_offload_en, 0);
+	MLX5_SET(transport_static_params, ctx, ti,
+		 MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR);
+	MLX5_SET(transport_static_params, ctx, zero_copy_en, 1);
+}
+
+void
+build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5e_set_nvmeotcp_static_params_wqe *wqe,
+			     u32 resync_seq)
+{
+	u8 opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_STATIC_PARAMS;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	u32 sqn = queue->sq->sqn;
+	u16 pc = queue->sq->pc;
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
+	fill_nvmeotcp_static_params(queue, &wqe->params, resync_seq);
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
+
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
+
+}
+
+static void
+mlx5e_nvmeotcp_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
+				      u32 resync_seq)
+{
+	struct mlx5e_set_nvmeotcp_static_params_wqe *wqe;
+	struct mlx5e_icosq *sq = queue->sq;
+	u16 pi, wqe_bbs;
+
+	wqe_bbs = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_STATIC_PARAMS_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqe_bbs, pi, 0, BSF_UMR);
+	build_nvmeotcp_static_params(queue, wqe, resync_seq);
+	sq->pc += wqe_bbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
+static void
+mlx5e_nvmeotcp_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue,
+					u32 seq)
+{
+	struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe;
+	struct mlx5e_icosq *sq = queue->sq;
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
+	struct mlx5e_icosq *sq = queue->sq;
+	u32 wqe_bbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe,
+				klm_length - *klm_offset);
+	wqe_sz = MLX5E_NVMEOTCP_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, KLM_ALIGNMENT));
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
+	struct mlx5e_icosq *sq = queue->sq;
+
+	/* TODO: set stricter wqe_sz; using max for now */
+	if (klm_length == 0) {
+		wqes = 1;
+		wqe_sz = MLX5E_NVMEOTCP_STATIC_PARAMS_WQEBBS;
+	} else {
+		wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+		wqe_sz = MLX5E_NVMEOTCP_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
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
+#define OCTWORD_SHIFT 4
+#define MAX_DS_VALUE 63
+static int
+mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
+			  struct sock *sk,
+			  struct tcp_ddp_config *tconfig)
+{
+	struct nvme_tcp_config *config = (struct nvme_tcp_config *)tconfig;
+	u8 log_queue_size = order_base_2(config->queue_size);
+	int max_sgls, max_wqe_sz_cap, queue_id, tirn, i, err;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_rq_stats *stats;
+
+	if (tconfig->type != TCP_DDP_NVME) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (config->queue_size >
+	    BIT(MLX5_CAP_DEV_NVMEOTCP(mdev, log_max_nvmeotcp_tag_buffer_size))) {
+		err = -EINVAL;
+		goto out;
+	}
+
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
+	err = mlx5e_create_nvmeotcp_tag_buf_table(mdev, queue, log_queue_size);
+	if (err)
+		goto remove_queue_id;
+
+	queue->tcp_ddp_ctx.type = TCP_DDP_NVME;
+	queue->sk = sk;
+	queue->id = queue_id;
+	queue->dgst = config->dgst;
+	queue->pda = config->cpda;
+	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv,
+							     config->io_cpu);
+	queue->sq = &priv->channels.c[queue->channel_ix]->nvmeotcpsq;
+	queue->size = config->queue_size;
+	max_wqe_sz_cap  = min_t(int, MAX_DS_VALUE * MLX5_SEND_WQE_DS,
+				MLX5_CAP_GEN(mdev, max_wqe_sz_sq) << OCTWORD_SHIFT);
+	queue->max_klms_per_wqe = KLM_ENTRIES_PER_WQE(max_wqe_sz_cap);
+	queue->priv = priv;
+	init_completion(&queue->done);
+	queue->context_ready = false;
+
+	/* initializes queue->tirn */
+	err = mlx5e_nvmeotcp_create_tir(priv, sk, config, queue);
+	if (err)
+		goto destroy_tag_buffer_table;
+
+	queue->ccid_table = kcalloc(queue->size,
+				    sizeof(struct nvmeotcp_queue_entry),
+				    GFP_KERNEL);
+	if (!queue->ccid_table) {
+		err = -ENOMEM;
+		goto destroy_tir;
+	}
+
+	err = rhashtable_insert_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+				     rhash_queues);
+	if (err)
+		goto free_ccid_table;
+
+	mlx5e_nvmeotcp_post_static_params_wqe(queue, 0);
+	mlx5e_nvmeotcp_post_progress_params_wqe(queue, tcp_sk(sk)->copied_seq);
+	max_sgls = mlx5e_get_max_sgl(mdev);
+	for (i = 0; i < config->queue_size; i++) {
+		err = mlx5e_create_nvmeotcp_mkey(mdev,
+						 MLX5_MKC_ACCESS_MODE_KLMS,
+						 max_sgls,
+						 &queue->ccid_table[i].klm_mkey);
+		if (err)
+			goto free_sgl;
+	}
+
+	err = mlx5e_nvmeotcp_post_klm_wqe(queue, BSF_KLM_UMR, 0, queue->size);
+	if (err)
+		goto free_sgl;
+
+	WARN_ON(!wait_for_completion_timeout(&queue->done, 1800));
+
+	tirn = queue->tirn;
+	if (queue->context_ready)
+		queue->fh = mlx5e_accel_fs_add_sk(priv, sk, tirn, queue_id);
+
+	if (IS_ERR_OR_NULL(queue->fh)) {
+		err = -EINVAL;
+		goto free_sgl;
+	}
+
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_queue_init++;
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(inet_csk(sk)->icsk_ulp_ddp_data, queue);
+	write_unlock_bh(&sk->sk_callback_lock);
+	refcount_set(&queue->ref_count, 1);
+	static_branch_inc(&skip_copy_enabled);
+	return err;
+
+free_sgl:
+	while (i--)
+		mlx5_core_destroy_mkey(mdev, &queue->ccid_table[i].klm_mkey);
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash,
+			       &queue->hash, rhash_queues);
+free_ccid_table:
+	kfree(queue->ccid_table);
+destroy_tir:
+	mlx5e_nvmeotcp_destroy_tir(priv, queue->tirn);
+destroy_tag_buffer_table:
+	mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+remove_queue_id:
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue_id);
+free_queue:
+	kfree(queue);
+out:
+	stats->nvmeotcp_queue_init_fail++;
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
+	struct mlx5e_rq_stats *stats;
+	int i;
+
+	queue = (struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_queue_teardown++;
+
+	WARN_ON(refcount_read(&queue->ref_count) != 1);
+	mlx5e_accel_fs_del_sk(queue->fh);
+
+	for (i = 0; i < queue->size; i++)
+		mlx5_core_destroy_mkey(mdev, &queue->ccid_table[i].klm_mkey);
+
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+			       rhash_queues);
+	kfree(queue->ccid_table);
+	mlx5e_nvmeotcp_destroy_tir(priv, queue->tirn);
+	mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue->id);
+	static_branch_dec(&skip_copy_enabled);
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
+	struct mlx5e_rq_stats *stats;
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
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_setup++;
+	if (unlikely(mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count)))
+		stats->nvmeotcp_ddp_setup_fail++;
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
+	if (ulp_ops && ulp_ops->resync_request)
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
+	queue->context_ready = true;
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
+	struct mlx5e_rq_stats *stats;
+
+	q_entry  = &queue->ccid_table[ddp->command_id];
+	WARN_ON(q_entry->sgl_length == 0);
+
+	q_entry->ddp_ctx = ddp_ctx;
+	q_entry->queue = queue;
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_teardown++;
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
+	mlx5e_nvmeotcp_post_static_params_wqe(queue, seq);
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
+		netdev->features |= NETIF_F_HW_TCP_DDP_CRC;
+		netdev->hw_features |= NETIF_F_HW_TCP_DDP_CRC;
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
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP_CRC)
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
+	if (priv->netdev->features & NETIF_F_HW_TCP_DDP_CRC)
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
index 000000000000..3b84dd9f49f6
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
+#include "linux/nvme-tcp.h"
+#include "en.h"
+
+struct nvmeotcp_queue_entry {
+	struct mlx5e_nvmeotcp_queue 	*queue;
+	u32				sgl_length;
+	struct mlx5_core_mkey		klm_mkey;
+	struct scatterlist		*sgl;
+	u32				ccid_gen;
+
+	/* for the ddp invalidate done callback */
+	void	 		*ddp_ctx;
+	struct tcp_ddp_io	*ddp;
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
+	struct mlx5e_icosq		*sq;
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
+	bool				context_ready;
+};
+
+struct mlx5e_nvmeotcp {
+	struct ida				queue_ids;
+	struct rhashtable			queue_hash;
+	bool 					enable;
+};
+
+void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
+int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
+int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable);
+void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data);
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
+void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi);
+
+int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
+void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+#else
+
+static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) { }
+static inline int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) { }
+
+static inline int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv) { return 0; }
+static inline int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data) { return 0; }
+static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
+static inline int set_feature_nvme_tcp_crc(struct net_device *netdev, bool enable) { return 0; }
+
+static inline int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) { }
+
+#endif
+#endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..e76bea9fd8c8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,79 @@
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
+			     u32 resync_seq);
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 961cdce37cc4..9813ef699fab 100644
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
@@ -1800,9 +1801,15 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_async_icosq_cq;
 
-	err = mlx5e_open_tx_cqs(c, params, cparam);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->nvmeotcpsq.cqp, &c->nvmeotcpsq.cq);
 	if (err)
 		goto err_close_icosq_cq;
+#endif
+
+	err = mlx5e_open_tx_cqs(c, params, cparam);
+	if (err)
+		goto err_close_nvmeotcpsq_cq;
 
 	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->xdp_sq.cqp, &c->xdpsq.cq);
 	if (err)
@@ -1829,9 +1836,15 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_async_icosq;
 
-	err = mlx5e_open_sqs(c, params, cparam);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err = mlx5e_open_icosq(c, params, &cparam->nvmeotcpsq, &c->nvmeotcpsq);
 	if (err)
 		goto err_close_icosq;
+#endif
+
+	err = mlx5e_open_sqs(c, params, cparam);
+	if (err)
+		goto err_close_nvmeotcpsq;
 
 	if (c->xdp) {
 		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL,
@@ -1860,7 +1873,12 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 err_close_sqs:
 	mlx5e_close_sqs(c);
 
+err_close_nvmeotcpsq:
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_close_icosq(&c->nvmeotcpsq);
+
 err_close_icosq:
+#endif
 	mlx5e_close_icosq(&c->icosq);
 
 err_close_async_icosq:
@@ -1881,12 +1899,16 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 err_close_tx_cqs:
 	mlx5e_close_tx_cqs(c);
 
+err_close_nvmeotcpsq_cq:
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_close_cq(&c->nvmeotcpsq.cq);
+
 err_close_icosq_cq:
+#endif
 	mlx5e_close_cq(&c->icosq.cq);
 
 err_close_async_icosq_cq:
 	mlx5e_close_cq(&c->async_icosq.cq);
-
 	return err;
 }
 
@@ -1897,6 +1919,9 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
 	mlx5e_close_sqs(c);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_close_icosq(&c->nvmeotcpsq);
+#endif
 	mlx5e_close_icosq(&c->icosq);
 	mlx5e_close_icosq(&c->async_icosq);
 	napi_disable(&c->napi);
@@ -1905,6 +1930,9 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	mlx5e_close_cq(&c->rq.cq);
 	mlx5e_close_cq(&c->xdpsq.cq);
 	mlx5e_close_tx_cqs(c);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_close_cq(&c->nvmeotcpsq.cq);
+#endif
 	mlx5e_close_cq(&c->icosq.cq);
 	mlx5e_close_cq(&c->async_icosq.cq);
 }
@@ -1988,6 +2016,9 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_icosq(&c->async_icosq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_activate_icosq(&c->nvmeotcpsq);
+#endif
 	mlx5e_activate_rq(&c->rq);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
@@ -2002,6 +2033,9 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 		mlx5e_deactivate_xsk(c);
 
 	mlx5e_deactivate_rq(&c->rq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_deactivate_icosq(&c->nvmeotcpsq);
+#endif
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
@@ -2185,7 +2219,8 @@ static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
 	void *cqc = param->cqc;
 
 	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
+	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) &&
+	    (cache_line_size() >= 128 || param->force_cqe128))
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
@@ -2199,6 +2234,11 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 	void *cqc = param->cqc;
 	u8 log_cq_size;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	/* nvme-tcp offload mandates 128 byte cqes */
+	param->force_cqe128 |= priv->nvmeotcp->enable;
+#endif
+
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
@@ -2307,6 +2347,9 @@ static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
 	mlx5e_build_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_build_icosq_param(priv, params->log_sq_size, &cparam->nvmeotcpsq);
+#endif
 }
 
 int mlx5e_open_channels(struct mlx5e_priv *priv,
@@ -3851,6 +3894,10 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP, set_feature_nvme_tcp);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP_CRC, set_feature_nvme_tcp_crc);
+#endif
 
 	if (err) {
 		netdev->features = oper_features;
@@ -3887,6 +3934,19 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
+
+		features &= ~NETIF_F_HW_TCP_DDP;
+		if (netdev->features & NETIF_F_HW_TCP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when CQE compress is active\n");
+	}
+
+	if (netdev->features & NETIF_F_LRO) {
+		features &= ~NETIF_F_HW_TCP_DDP;
+		if (netdev->features & NETIF_F_HW_TCP_DDP)
+			netdev_warn(netdev, "Disabling tcp-ddp offload, not supported when LRO is active\n");
+		features &= ~NETIF_F_HW_TCP_DDP_CRC;
+		if (netdev->features & NETIF_F_HW_TCP_DDP_CRC)
+			netdev_warn(netdev, "Disabling tcp-ddp-crc offload, not supported when LRO is active\n");
 	}
 
 	mutex_unlock(&priv->state_lock);
@@ -4940,6 +5000,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
+	mlx5e_nvmeotcp_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -5004,6 +5065,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	err = mlx5e_tls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
+	err = mlx5e_nvmeotcp_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "NVMEoTCP initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
 	err = mlx5e_devlink_port_register(priv);
 	if (err)
@@ -5017,6 +5081,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_devlink_port_unregister(priv);
+	mlx5e_nvmeotcp_cleanup(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 599f5b5ebc97..ac99dbb3573a 100644
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
 				netdev_WARN_ONCE(cq->channel->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 78f6a6f0a7e0..25d203d64bb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -34,6 +34,7 @@
 #include "en.h"
 #include "en_accel/tls.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/nvmeotcp.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -189,6 +190,14 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_ok) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_teardown) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -314,6 +323,14 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		s->rx_tls_resync_res_ok     += rq_stats->tls_resync_res_ok;
 		s->rx_tls_resync_res_skip   += rq_stats->tls_resync_res_skip;
 		s->rx_tls_err               += rq_stats->tls_err;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		s->rx_nvmeotcp_queue_init      += rq_stats->nvmeotcp_queue_init;
+		s->rx_nvmeotcp_queue_init_fail += rq_stats->nvmeotcp_queue_init_fail;
+		s->rx_nvmeotcp_queue_teardown  += rq_stats->nvmeotcp_queue_teardown;
+		s->rx_nvmeotcp_ddp_setup       += rq_stats->nvmeotcp_ddp_setup;
+		s->rx_nvmeotcp_ddp_setup_fail  += rq_stats->nvmeotcp_ddp_setup_fail;
+		s->rx_nvmeotcp_ddp_teardown    += rq_stats->nvmeotcp_ddp_teardown;
 #endif
 		s->ch_events      += ch_stats->events;
 		s->ch_poll        += ch_stats->poll;
@@ -390,6 +407,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 			s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
 			s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
 #endif
+
 			s->tx_cqes		+= sq_stats->cqes;
 
 			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
@@ -1559,6 +1577,14 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_teardown) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 162daaadb0d8..5c1c0ad88ff4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -175,6 +175,14 @@ struct mlx5e_sw_stats {
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 rx_nvmeotcp_queue_init;
+	u64 rx_nvmeotcp_queue_init_fail;
+	u64 rx_nvmeotcp_queue_teardown;
+	u64 rx_nvmeotcp_ddp_setup;
+	u64 rx_nvmeotcp_ddp_setup_fail;
+	u64 rx_nvmeotcp_ddp_teardown;
+#endif
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -338,6 +346,14 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_queue_init;
+	u64 nvmeotcp_queue_init_fail;
+	u64 nvmeotcp_queue_teardown;
+	u64 nvmeotcp_ddp_setup;
+	u64 nvmeotcp_ddp_setup_fail;
+	u64 nvmeotcp_ddp_teardown;
+#endif
 };
 
 struct mlx5e_sq_stats {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index d5868670f8a5..c2bd2e8d5508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -158,6 +158,9 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		 * queueing more WQEs and overflowing the async ICOSQ.
 		 */
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_poll_ico_cq(&c->nvmeotcpsq.cq);
+#endif
 
 	busy |= INDIRECT_CALL_2(rq->post_wqes,
 				mlx5e_post_rx_mpwqes,
@@ -196,6 +199,9 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&rq->cq);
 	mlx5e_cq_arm(&c->icosq.cq);
 	mlx5e_cq_arm(&c->async_icosq.cq);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_cq_arm(&c->nvmeotcpsq.cq);
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
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 81ca5989009b..afadf4cf6d7a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -263,6 +263,7 @@ enum {
 enum {
 	MLX5_MKEY_MASK_LEN		= 1ull << 0,
 	MLX5_MKEY_MASK_PAGE_SIZE	= 1ull << 1,
+	MLX5_MKEY_MASK_XLT_OCT_SIZE	= 1ull << 2,
 	MLX5_MKEY_MASK_START_ADDR	= 1ull << 6,
 	MLX5_MKEY_MASK_PD		= 1ull << 7,
 	MLX5_MKEY_MASK_EN_RINVAL	= 1ull << 8,
@@ -1153,6 +1154,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_NVMEOTCP = 0x19,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1373,6 +1375,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_IPSEC(mdev, cap)\
 	MLX5_GET(ipsec_cap, (mdev)->caps.hca_cur[MLX5_CAP_IPSEC], cap)
 
+#define MLX5_CAP_DEV_NVMEOTCP(mdev, cap)\
+	MLX5_GET(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
+#define MLX5_CAP64_NVMEOTCP(mdev, cap)\
+	MLX5_GET64(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index de1ffb4804d6..a85d1c4b3ff0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1231,7 +1231,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_srq_sz[0x8];
 	u8         log_max_qp_sz[0x8];
 	u8         event_cap[0x1];
-	u8         reserved_at_91[0x7];
+	u8         reserved_at_91[0x5];
+	u8         nvmeotcp[0x1];
+	u8         reserved_at_97[0x1];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
@@ -1519,7 +1521,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         general_obj_types[0x40];
 
-	u8         reserved_at_440[0x20];
+	u8         reserved_at_440[0x8];
+	u8         create_qp_start_hint[0x18];
 
 	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
@@ -2969,6 +2972,21 @@ struct mlx5_ifc_roce_addr_layout_bits {
 	u8         reserved_at_e0[0x20];
 };
 
+struct mlx5_ifc_nvmeotcp_cap_bits {
+	u8    zerocopy[0x1];
+	u8    crc_rx[0x1];
+	u8    crc_tx[0x1];
+	u8    reserved_at_3[0x15];
+	u8    version[0x8];
+
+	u8    reserved_at_20[0x13];
+	u8    log_max_nvmeotcp_tag_buffer_table[0x5];
+	u8    reserved_at_38[0x3];
+	u8    log_max_nvmeotcp_tag_buffer_size[0x5];
+
+	u8    reserved_at_40[0x7c0];
+};
+
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
 	struct mlx5_ifc_odp_cap_bits odp_cap;
@@ -2985,6 +3003,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3179,7 +3198,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3210,7 +3231,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -10655,11 +10677,13 @@ struct mlx5_ifc_affiliated_event_header_bits {
 enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT(0x21),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21
 };
 
 enum {
@@ -10734,6 +10758,20 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
 
+struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits {
+	u8    modify_field_select[0x40];
+
+	u8    reserved_at_20[0x20];
+
+	u8    reserved_at_40[0x1b];
+	u8    log_tag_buffer_table_size[0x5];
+};
+
+struct mlx5_ifc_create_nvmeotcp_tag_buf_table_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits nvmeotcp_tag_buf_table_obj;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 = 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 = 0x1,
@@ -10744,6 +10782,18 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
 };
 
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_XTS               = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               = 0x1,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP           = 0x2,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP_WITH_TLS  = 0x3,
+};
+
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR  = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_TARGET     = 0x1,
+};
+
 struct mlx5_ifc_tls_static_params_bits {
 	u8         const_2[0x2];
 	u8         tls_version[0x4];
@@ -10784,4 +10834,67 @@ enum {
 	MLX5_MTT_PERM_RW	= MLX5_MTT_PERM_READ | MLX5_MTT_PERM_WRITE,
 };
 
+struct mlx5_ifc_nvmeotcp_progress_params_bits {
+	u8    valid[0x1];
+	u8    reserved_at_1[0x7];
+	u8    pd[0x18];
+
+	u8    next_pdu_tcp_sn[0x20];
+
+	u8    hw_resync_tcp_sn[0x20];
+
+	u8    pdu_tracker_state[0x2];
+	u8    offloading_state[0x2];
+	u8    reserved_at_64[0xc];
+	u8    cccid_ttag[0x10];
+};
+
+struct mlx5_ifc_transport_static_params_bits {
+	u8    const_2[0x2];
+	u8    tls_version[0x4];
+	u8    const_1[0x2];
+	u8    reserved_at_8[0x14];
+	u8    acc_type[0x4];
+
+	u8    reserved_at_20[0x20];
+
+	u8    initial_record_number[0x40];
+
+	u8    resync_tcp_sn[0x20];
+
+	u8    gcm_iv[0x20];
+
+	u8    implicit_iv[0x40];
+
+	u8    reserved_at_100[0x8];
+	u8    dek_index[0x18];
+
+	u8    reserved_at_120[0x15];
+	u8    ti[0x1];
+	u8    zero_copy_en[0x1];
+	u8    ddgst_offload_en[0x1];
+	u8    hdgst_offload_en[0x1];
+	u8    ddgst_en[0x1];
+	u8    hddgst_en[0x1];
+	u8    pda[0x5];
+
+	u8    nvme_resync_tcp_sn[0x20];
+
+	u8    reserved_at_160[0xa0];
+};
+
+struct mlx5_ifc_nvmeotcp_sgl_entry_bits {
+	u8    address[0x40];
+
+	u8    byte_count[0x20];
+};
+
+struct mlx5_ifc_nvmeotcp_umr_params_bits {
+	u8    ccid[0x20];
+
+	u8    reserved_at_20[0x10];
+	u8    sgl_length[0x10];
+
+	struct mlx5_ifc_nvmeotcp_sgl_entry_bits sgl[0];
+};
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 36492a1342cf..8b62d3f4a868 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -220,6 +220,7 @@ struct mlx5_wqe_ctrl_seg {
 #define MLX5_WQE_CTRL_OPCODE_MASK 0xff
 #define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
 #define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
+#define MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT 8
 
 enum {
 	MLX5_ETH_WQE_L3_INNER_CSUM      = 1 << 4,
-- 
2.24.1

