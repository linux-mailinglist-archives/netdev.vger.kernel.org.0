Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D087D1C054D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgD3Svx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:51:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54092 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726875AbgD3Svx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:51:53 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Apr 2020 21:50:38 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03UIoaNh028837;
        Thu, 30 Apr 2020 21:50:37 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V7 rdma-next 16/16] RDMA/mlx5: Set lag tx affinity according to slave
Date:   Thu, 30 Apr 2020 21:50:33 +0300
Message-Id: <20200430185033.11476-17-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200430185033.11476-1-maorg@mellanox.com>
References: <20200430185033.11476-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch sets the lag tx affinity of the data QPs and the
GSI QPs according to the LAG xmit slave.

For GSI QPs, in case that the link layer is Ethenet (RoCE) we create
two GSI QPs, one for each physical port. When the driver selects the
GSI QP, it will consider the port affinity result.
For connected QPs, the driver sets the affinity of the xmit slave.

The above, ensure that RC QP and it's corresponding GSI QP will
transmit from the same physical port.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ah.c      |  9 +++--
 drivers/infiniband/hw/mlx5/gsi.c     | 33 ++++++++++++++----
 drivers/infiniband/hw/mlx5/main.c    |  2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 52 +++++++++++++++++++---------
 include/linux/mlx5/mlx5_ifc.h        |  4 ++-
 include/linux/mlx5/qp.h              |  2 ++
 7 files changed, 76 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 9b59348d51b5..cc858f658567 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -33,8 +33,9 @@
 #include "mlx5_ib.h"
 
 static void create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
-			 struct rdma_ah_attr *ah_attr)
+			 struct rdma_ah_init_attr *init_attr)
 {
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	enum ib_gid_type gid_type;
 
 	if (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) {
@@ -51,6 +52,10 @@ static void create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
 	ah->av.stat_rate_sl = (rdma_ah_get_static_rate(ah_attr) << 4);
 
 	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
+		if (init_attr->xmit_slave)
+			ah->xmit_port =
+				mlx5_lag_get_slave_port(dev->mdev,
+							init_attr->xmit_slave);
 		gid_type = ah_attr->grh.sgid_attr->gid_type;
 
 		memcpy(ah->av.rmac, ah_attr->roce.dmac,
@@ -98,7 +103,7 @@ int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 			return err;
 	}
 
-	create_ib_ah(dev, ah, ah_attr);
+	create_ib_ah(dev, ah, init_attr);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 1afbf03d1a98..40d418153891 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -119,10 +119,17 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 	struct mlx5_ib_gsi_qp *gsi;
 	struct ib_qp_init_attr hw_init_attr = *init_attr;
 	const u8 port_num = init_attr->port_num;
-	const int num_pkeys = pd->device->attrs.max_pkeys;
-	const int num_qps = mlx5_ib_deth_sqpn_cap(dev) ? num_pkeys : 0;
+	int num_qps = 0;
 	int ret;
 
+	if (mlx5_ib_deth_sqpn_cap(dev)) {
+		if (MLX5_CAP_GEN(dev->mdev,
+				 port_type) == MLX5_CAP_PORT_TYPE_IB)
+			num_qps = pd->device->attrs.max_pkeys;
+		else if (dev->lag_active)
+			num_qps = MLX5_MAX_PORTS;
+	}
+
 	gsi = kzalloc(sizeof(*gsi), GFP_KERNEL);
 	if (!gsi)
 		return ERR_PTR(-ENOMEM);
@@ -261,7 +268,7 @@ static struct ib_qp *create_gsi_ud_qp(struct mlx5_ib_gsi_qp *gsi)
 }
 
 static int modify_to_rts(struct mlx5_ib_gsi_qp *gsi, struct ib_qp *qp,
-			 u16 qp_index)
+			 u16 pkey_index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct ib_qp_attr attr;
@@ -270,7 +277,7 @@ static int modify_to_rts(struct mlx5_ib_gsi_qp *gsi, struct ib_qp *qp,
 
 	mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_QKEY | IB_QP_PORT;
 	attr.qp_state = IB_QPS_INIT;
-	attr.pkey_index = qp_index;
+	attr.pkey_index = pkey_index;
 	attr.qkey = IB_QP1_QKEY;
 	attr.port_num = gsi->port_num;
 	ret = ib_modify_qp(qp, &attr, mask);
@@ -304,12 +311,17 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 {
 	struct ib_device *device = gsi->rx_qp->device;
 	struct mlx5_ib_dev *dev = to_mdev(device);
+	int pkey_index = qp_index;
+	struct mlx5_ib_qp *mqp;
 	struct ib_qp *qp;
 	unsigned long flags;
 	u16 pkey;
 	int ret;
 
-	ret = ib_query_pkey(device, gsi->port_num, qp_index, &pkey);
+	if (MLX5_CAP_GEN(dev->mdev,  port_type) != MLX5_CAP_PORT_TYPE_IB)
+		pkey_index = 0;
+
+	ret = ib_query_pkey(device, gsi->port_num, pkey_index, &pkey);
 	if (ret) {
 		mlx5_ib_warn(dev, "unable to read P_Key at port %d, index %d\n",
 			     gsi->port_num, qp_index);
@@ -338,7 +350,10 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 		return;
 	}
 
-	ret = modify_to_rts(gsi, qp, qp_index);
+	mqp = to_mqp(qp);
+	if (dev->lag_active)
+		mqp->gsi_lag_port = qp_index + 1;
+	ret = modify_to_rts(gsi, qp, pkey_index);
 	if (ret)
 		goto err_destroy_qp;
 
@@ -457,11 +472,15 @@ static int mlx5_ib_gsi_silent_drop(struct mlx5_ib_gsi_qp *gsi,
 static struct ib_qp *get_tx_qp(struct mlx5_ib_gsi_qp *gsi, struct ib_ud_wr *wr)
 {
 	struct mlx5_ib_dev *dev = to_mdev(gsi->rx_qp->device);
+	struct mlx5_ib_ah *ah = to_mah(wr->ah);
 	int qp_index = wr->pkey_index;
 
-	if (!mlx5_ib_deth_sqpn_cap(dev))
+	if (!gsi->num_qps)
 		return gsi->rx_qp;
 
+	if (dev->lag_active && ah->xmit_port)
+		qp_index = ah->xmit_port - 1;
+
 	if (qp_index >= gsi->num_qps)
 		return NULL;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 80ae8f04bfd5..e7fb290c9d8d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -53,6 +53,7 @@
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
+#include <rdma/lag.h>
 #include <linux/in.h>
 #include <linux/etherdevice.h>
 #include "mlx5_ib.h"
@@ -6567,6 +6568,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.phys_port_cnt	= dev->num_ports;
 	dev->ib_dev.num_comp_vectors    = mlx5_comp_vectors_count(mdev);
 	dev->ib_dev.dev.parent		= mdev->device;
+	dev->ib_dev.lag_flags		= RDMA_LAG_FLAGS_HASH_ALL_SLAVES;
 
 	mutex_init(&dev->cap_mask_mutex);
 	INIT_LIST_HEAD(&dev->qp_list);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 3a1977ab899b..bbe86c6dd5a3 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -471,6 +471,7 @@ struct mlx5_ib_qp {
 	 * but not take effective
 	 */
 	u32                     counter_pending;
+	u16			gsi_lag_port;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 518abbda33c0..9314aaabe43d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3045,10 +3045,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RAE		|
 					  MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_PKEY_INDEX	|
-					  MLX5_QP_OPTPAR_PRI_PORT,
+					  MLX5_QP_OPTPAR_PRI_PORT	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 			[MLX5_QP_ST_UC] = MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_PKEY_INDEX	|
-					  MLX5_QP_OPTPAR_PRI_PORT,
+					  MLX5_QP_OPTPAR_PRI_PORT	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_PKEY_INDEX	|
 					  MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_PRI_PORT,
@@ -3056,17 +3058,20 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RAE		|
 					  MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_PKEY_INDEX	|
-					  MLX5_QP_OPTPAR_PRI_PORT,
+					  MLX5_QP_OPTPAR_PRI_PORT	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 		},
 		[MLX5_QP_STATE_RTR] = {
 			[MLX5_QP_ST_RC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH  |
 					  MLX5_QP_OPTPAR_RRE            |
 					  MLX5_QP_OPTPAR_RAE            |
 					  MLX5_QP_OPTPAR_RWE            |
-					  MLX5_QP_OPTPAR_PKEY_INDEX,
+					  MLX5_QP_OPTPAR_PKEY_INDEX	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 			[MLX5_QP_ST_UC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH  |
 					  MLX5_QP_OPTPAR_RWE            |
-					  MLX5_QP_OPTPAR_PKEY_INDEX,
+					  MLX5_QP_OPTPAR_PKEY_INDEX	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_PKEY_INDEX     |
 					  MLX5_QP_OPTPAR_Q_KEY,
 			[MLX5_QP_ST_MLX] = MLX5_QP_OPTPAR_PKEY_INDEX	|
@@ -3075,7 +3080,8 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RRE            |
 					  MLX5_QP_OPTPAR_RAE            |
 					  MLX5_QP_OPTPAR_RWE            |
-					  MLX5_QP_OPTPAR_PKEY_INDEX,
+					  MLX5_QP_OPTPAR_PKEY_INDEX	|
+					  MLX5_QP_OPTPAR_LAG_TX_AFF,
 		},
 	},
 	[MLX5_QP_STATE_RTR] = {
@@ -3428,11 +3434,8 @@ static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
 
 static bool qp_supports_affinity(struct ib_qp *qp)
 {
-	struct mlx5_ib_qp *mqp = to_mqp(qp);
-
 	if ((qp->qp_type == IB_QPT_RC) ||
-	    (qp->qp_type == IB_QPT_UD &&
-	     !(mqp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)) ||
+	    (qp->qp_type == IB_QPT_UD) ||
 	    (qp->qp_type == IB_QPT_UC) ||
 	    (qp->qp_type == IB_QPT_RAW_PACKET) ||
 	    (qp->qp_type == IB_QPT_XRC_INI) ||
@@ -3441,7 +3444,9 @@ static bool qp_supports_affinity(struct ib_qp *qp)
 	return false;
 }
 
-static unsigned int get_tx_affinity(struct ib_qp *qp, u8 init,
+static unsigned int get_tx_affinity(struct ib_qp *qp,
+				    const struct ib_qp_attr *attr,
+				    int attr_mask, u8 init,
 				    struct ib_udata *udata)
 {
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
@@ -3451,10 +3456,18 @@ static unsigned int get_tx_affinity(struct ib_qp *qp, u8 init,
 	struct mlx5_ib_qp_base *qp_base;
 	unsigned int tx_affinity;
 
-	if (!(dev->lag_active && init && qp_supports_affinity(qp)))
+	if (!(dev->lag_active && qp_supports_affinity(qp)))
 		return 0;
 
-	tx_affinity = get_tx_affinity_rr(dev, udata);
+	if (mqp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)
+		tx_affinity = mqp->gsi_lag_port;
+	else if (init)
+		tx_affinity = get_tx_affinity_rr(dev, udata);
+	else if ((attr_mask & IB_QP_AV) && attr->xmit_slave)
+		tx_affinity =
+			mlx5_lag_get_slave_port(dev->mdev, attr->xmit_slave);
+	else
+		return 0;
 
 	qp_base = &mqp->trans_qp.base;
 	if (ucontext)
@@ -3539,7 +3552,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	struct mlx5_qp_context *context;
 	struct mlx5_ib_pd *pd;
 	enum mlx5_qp_state mlx5_cur, mlx5_new;
-	enum mlx5_qp_optpar optpar;
+	enum mlx5_qp_optpar optpar = 0;
 	u32 set_id = 0;
 	int mlx5_st;
 	int err;
@@ -3574,10 +3587,15 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	tx_affinity = get_tx_affinity(ibqp,
+	tx_affinity = get_tx_affinity(ibqp, attr, attr_mask,
 				      cur_state == IB_QPS_RESET &&
 				      new_state == IB_QPS_INIT, udata);
-	context->flags |= cpu_to_be32(tx_affinity << 24);
+	if (tx_affinity) {
+		context->flags |= cpu_to_be32(tx_affinity << 24);
+		if (new_state == IB_QPS_RTR &&
+		    MLX5_CAP_GEN(dev->mdev, init2_lag_tx_port_affinity))
+			optpar |= MLX5_QP_OPTPAR_LAG_TX_AFF;
+	}
 
 	if (is_sqp(ibqp->qp_type)) {
 		context->mtu_msgmax = (IB_MTU_256 << 5) | 8;
@@ -3714,7 +3732,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	op = optab[mlx5_cur][mlx5_new];
-	optpar = ib_mask_to_mlx5_opt(attr_mask);
+	optpar |= ib_mask_to_mlx5_opt(attr_mask);
 	optpar &= opt_mask[mlx5_cur][mlx5_new][mlx5_st];
 
 	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET ||
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fb243848132d..c1ba89198335 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1321,7 +1321,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         stat_rate_support[0x10];
 	u8         reserved_at_1f0[0x1];
 	u8         pci_sync_for_fw_update_event[0x1];
-	u8         reserved_at_1f2[0xa];
+	u8         reserved_at_1f2[0x6];
+	u8         init2_lag_tx_port_affinity[0x1];
+	u8         reserved_at_1fa[0x3];
 	u8         cqe_version[0x4];
 
 	u8         compact_address_vector[0x1];
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index f23eb18526fe..b9facdb9b9bd 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -66,6 +66,7 @@ enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_RETRY_COUNT		= 1 << 12,
 	MLX5_QP_OPTPAR_RNR_RETRY		= 1 << 13,
 	MLX5_QP_OPTPAR_ACK_TIMEOUT		= 1 << 14,
+	MLX5_QP_OPTPAR_LAG_TX_AFF		= 1 << 15,
 	MLX5_QP_OPTPAR_PRI_PORT			= 1 << 16,
 	MLX5_QP_OPTPAR_SRQN			= 1 << 18,
 	MLX5_QP_OPTPAR_CQN_RCV			= 1 << 19,
@@ -321,6 +322,7 @@ struct mlx5_av {
 struct mlx5_ib_ah {
 	struct ib_ah		ibah;
 	struct mlx5_av		av;
+	u8			xmit_port;
 };
 
 static inline struct mlx5_ib_ah *to_mah(struct ib_ah *ibah)
-- 
2.17.2

