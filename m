Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139DF30A4EC
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhBAKGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:06:15 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59937 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232994AbhBAKGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:13 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:14 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C06029353;
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
Subject: [PATCH v3 net-next  13/21] net/mlx5e: NVMEoTCP offload initialization
Date:   Mon,  1 Feb 2021 12:05:01 +0200
Message-Id: <20210201100509.27351-14-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This commit introduce the initialization blocks for NVMEoTCP offload:
- Use 128B CQEs when NVME-TCP offload is enabled.
- Use a dedicated icosq for NVME-TCP work. This list of SQ is unique in the
  sense that it is driven directly by the NVME-TCP layer to submit and
  invalidate ddp requests.
- Query nvmeotcp capabilities

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  10 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   7 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   9 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 196 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 115 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  39 +++-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  17 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 10 files changed, 400 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index c38b791e2406..6d91df52bb9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -222,3 +222,13 @@ config MLX5_SF_MANAGER
 	port is managed through devlink.  A subfunction supports RDMA, netdevice
 	and vdpa device. It is similar to a SRIOV VF but it doesn't require
 	SRIOV support.
+
+config MLX5_EN_NVMEOTCP
+	bool "NVMEoTCP accelaration"
+	depends on MLX5_CORE_EN
+	depends on TCP_DDP=y || TCP_DDP_CRC=y
+	default n
+	help
+	Build support for NVMEoTCP accelaration in the NIC.
+	Note: Support for hardware with this capability needs to be selected
+	for this option to become available.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8809dd4de57e..020fe2478fd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -97,3 +97,5 @@ mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
 # SF manager
 #
 mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
+
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e0b102958524..3003bae2c300 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -669,6 +669,10 @@ struct mlx5e_channel {
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
 	struct mlx5e_txqsq __rcu * __rcu *qos_sqs;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct list_head	   list_nvmeotcpsq;   /* nvmeotcp umrs  */
+	spinlock_t                 nvmeotcp_icosq_lock;
+#endif
 	bool                       xdp;
 	struct napi_struct         napi;
 	struct device             *pdev;
@@ -874,6 +878,9 @@ struct mlx5e_priv {
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
index ea2cfb04b31a..855a41893b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -16,6 +16,7 @@ struct mlx5e_cq_param {
 	struct mlx5_wq_param       wq;
 	u16                        eq_ix;
 	u8                         cq_period_mode;
+	bool                       force_cqe128;
 };
 
 struct mlx5e_rq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 959bb6cd7203..eabba2168dd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -39,6 +39,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls.h"
 #include "en_accel/tls_rxtx.h"
+#include "en_accel/nvmeotcp.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -198,11 +199,17 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 
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
index 000000000000..0834deb7a3ac
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include <linux/netdevice.h>
+#include <linux/idr.h>
+#include "en_accel/nvmeotcp.h"
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
+static int
+mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
+			      struct tcp_ddp_limits *limits)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
+			  struct sock *sk,
+			  struct tcp_ddp_config *tconfig)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
+			      struct sock *sk)
+{
+}
+
+static int
+mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
+			 struct sock *sk,
+			 struct tcp_ddp_io *ddp)
+{
+	return 0;
+}
+
+static int
+mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
+			    struct sock *sk,
+			    struct tcp_ddp_io *ddp,
+			    void *ddp_ctx)
+{
+	return 0;
+}
+
+static void
+mlx5e_nvmeotcp_dev_resync(struct net_device *netdev,
+			  struct sock *sk, u32 seq)
+{
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
index 000000000000..753757fc44a3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
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
+	u64				size;
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
+ *	@after_resync_cqe: indicate if resync occurred
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
+	/* for MASK HW resync cqe */
+	bool				after_resync_cqe;
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3ff91247a97c..edda0ff8090b 100644
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
@@ -2022,6 +2023,10 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->aff_mask = irq_get_effective_affinity_mask(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	INIT_LIST_HEAD(&c->list_nvmeotcpsq);
+	spin_lock_init(&c->nvmeotcp_icosq_lock);
+#endif
 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
 	err = mlx5e_open_queues(c, params, cparam);
@@ -2259,7 +2264,8 @@ static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
 	void *cqc = param->cqc;
 
 	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
+	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) &&
+	    (cache_line_size() >= 128 || param->force_cqe128))
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
@@ -2273,6 +2279,11 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
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
@@ -4066,6 +4077,10 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP, set_feature_nvme_tcp);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TCP_DDP_CRC_RX, set_feature_nvme_tcp_crc);
+#endif
 
 	if (err) {
 		netdev->features = oper_features;
@@ -4102,6 +4117,23 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
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
@@ -5180,6 +5212,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
+	mlx5e_nvmeotcp_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -5244,6 +5277,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	err = mlx5e_tls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
+	err = mlx5e_nvmeotcp_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "NVMEoTCP initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
 	err = mlx5e_devlink_port_register(priv);
 	if (err)
@@ -5257,6 +5293,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_devlink_port_unregister(priv);
+	mlx5e_nvmeotcp_cleanup(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index d54da3797c30..2817615f06b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -36,6 +36,7 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
+#include "en_accel/nvmeotcp.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 {
@@ -118,6 +119,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	struct mlx5e_txqsq __rcu **qos_sqs;
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	struct mlx5e_nvmeotcp_sq *nvmeotcp_sq;
+	struct list_head *cur;
+#endif
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
@@ -170,6 +175,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		 * queueing more WQEs and overflowing the async ICOSQ.
 		 */
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	list_for_each(cur, &c->list_nvmeotcpsq) {
+		nvmeotcp_sq = list_entry(cur, struct mlx5e_nvmeotcp_sq, list);
+		mlx5e_poll_ico_cq(&nvmeotcp_sq->icosq.cq);
+	}
+#endif
 
 	busy |= INDIRECT_CALL_2(rq->post_wqes,
 				mlx5e_post_rx_mpwqes,
@@ -218,6 +229,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
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

