Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C72FB8E1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406244AbhASN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:57:49 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35121 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390697AbhASMJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 07:09:22 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 19 Jan 2021 14:08:15 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10JC8FR6021916;
        Tue, 19 Jan 2021 14:08:15 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 5/5] net/mlx5e: Support HTB offload
Date:   Tue, 19 Jan 2021 14:08:15 +0200
Message-Id: <20210119120815.463334-6-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119120815.463334-1-maximmi@mellanox.com>
References: <20210119120815.463334-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for HTB offload in the mlx5e driver.

Performance:

  NIC: Mellanox ConnectX-6 Dx
  CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (24 cores with HT)

  100 Gbit/s line rate, 500 UDP streams @ ~200 Mbit/s each
  48 traffic classes, flower used for steering
  No shaping (rate limits set to 4 Gbit/s per TC) - checking for max
  throughput.

  Baseline: 98.7 Gbps, 8.25 Mpps
  HTB: 6.7 Gbps, 0.56 Mpps
  HTB offload: 95.6 Gbps, 8.00 Mpps

Limitations:

1. 256 leaf nodes, 3 levels of depth.

2. Granularity for ceil is 1 Mbit/s. Rates are converted to weights, and
the bandwidth is split among the siblings according to these weights.
Other parameters for classes are not supported.

Ethtool statistics support for QoS SQs are also added. The counters are
called qos_txN_*, where N is the QoS queue number (starting from 0, the
numeration is separate from the normal SQs), and * is the counter name
(the counters are the same as for the normal SQs).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 984 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  44 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 176 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 100 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  47 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  26 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c |  85 ++
 drivers/net/ethernet/mellanox/mlx5/core/qos.h |  30 +
 include/linux/mlx5/mlx5_ifc.h                 |  13 +-
 15 files changed, 1516 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 134bd038ae8a..fcfc0b114985 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -16,7 +16,8 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
-		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o fw_reset.o
+		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
+		fw_reset.o qos.o
 
 #
 # Netdev basic
@@ -25,7 +26,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
+		en/qos.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 055baf3b6cb1..26e578a973e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -55,6 +55,7 @@
 #include "en_stats.h"
 #include "en/dcbnl.h"
 #include "en/fs.h"
+#include "en/qos.h"
 #include "lib/hv_vhca.h"
 
 extern const struct net_device_ops mlx5e_netdev_ops;
@@ -161,6 +162,9 @@ do {                                                            \
 			    ##__VA_ARGS__);                     \
 } while (0)
 
+#define mlx5e_state_dereference(priv, p) \
+	rcu_dereference_protected((p), lockdep_is_held(&(priv)->state_lock))
+
 enum mlx5e_rq_group {
 	MLX5E_RQ_GROUP_REGULAR,
 	MLX5E_RQ_GROUP_XSK,
@@ -663,11 +667,13 @@ struct mlx5e_channel {
 	struct mlx5e_xdpsq         rq_xdpsq;
 	struct mlx5e_txqsq         sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_icosq         icosq;   /* internal control operations */
+	struct mlx5e_txqsq __rcu * __rcu *qos_sqs;
 	bool                       xdp;
 	struct napi_struct         napi;
 	struct device             *pdev;
 	struct net_device         *netdev;
 	__be32                     mkey_be;
+	u16                        qos_sqs_size;
 	u8                         num_tc;
 	u8                         lag_port;
 
@@ -756,6 +762,8 @@ struct mlx5e_modify_sq_param {
 	int next_state;
 	int rl_update;
 	int rl_index;
+	bool qos_update;
+	u16 qos_queue_group_id;
 };
 
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
@@ -788,10 +796,20 @@ struct mlx5e_scratchpad {
 	cpumask_var_t cpumask;
 };
 
+struct mlx5e_htb {
+	DECLARE_HASHTABLE(qos_tc2node, order_base_2(MLX5E_QOS_MAX_LEAF_NODES));
+	DECLARE_BITMAP(qos_used_qids, MLX5E_QOS_MAX_LEAF_NODES);
+	struct mlx5e_sq_stats **qos_sq_stats;
+	u16 max_qos_sqs;
+	u16 maj_id;
+	u16 defcls;
+};
+
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	/* +1 for port ptp ts */
-	struct mlx5e_txqsq *txq2sq[(MLX5E_MAX_NUM_CHANNELS + 1) * MLX5E_MAX_NUM_TC];
+	struct mlx5e_txqsq *txq2sq[(MLX5E_MAX_NUM_CHANNELS + 1) * MLX5E_MAX_NUM_TC +
+				   MLX5E_QOS_MAX_LEAF_NODES];
 	int channel_tc2realtxq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
 	int port_ptp_tc2realtxq[MLX5E_MAX_NUM_TC];
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -859,6 +877,7 @@ struct mlx5e_priv {
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
 #endif
 	struct mlx5e_scratchpad    scratchpad;
+	struct mlx5e_htb           htb;
 };
 
 struct mlx5e_rx_handlers {
@@ -986,6 +1005,7 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate,
 			       void *context);
+int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
@@ -1010,6 +1030,9 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
+int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
+		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
+		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id, u16 qos_qid);
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
@@ -1020,8 +1043,10 @@ struct mlx5e_create_sq_param;
 int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
 			struct mlx5e_sq_param *param,
 			struct mlx5e_create_sq_param *csp,
+			u16 qos_queue_group_id,
 			u32 *sqn);
 void mlx5e_tx_err_cqe_work(struct work_struct *recover_work);
+void mlx5e_close_txqsq(struct mlx5e_txqsq *sq);
 
 static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 807147d97a0f..ea2cfb04b31a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -118,6 +118,8 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_rq_param *param);
 void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 				 struct mlx5e_sq_param *param);
+void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
+			  struct mlx5e_sq_param *param);
 void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_params *params,
 			     struct mlx5e_xsk_param *xsk,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 2a2bac30daaa..eeddd1137dda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -261,7 +261,7 @@ static int mlx5e_ptp_open_txqsq(struct mlx5e_port_ptp *c, u32 tisn,
 	csp.min_inline_mode = txqsq->min_inline_mode;
 	csp.ts_cqe_to_dest_cqn = ptpsq->ts_cq.mcq.cqn;
 
-	err = mlx5e_create_sq_rdy(c->mdev, sqp, &csp, &txqsq->sqn);
+	err = mlx5e_create_sq_rdy(c->mdev, sqp, &csp, 0, &txqsq->sqn);
 	if (err)
 		goto err_free_txqsq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
new file mode 100644
index 000000000000..12d7ad061237
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -0,0 +1,984 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include "en.h"
+#include "params.h"
+#include "../qos.h"
+
+#define BYTES_IN_MBIT 125000
+
+int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev)
+{
+	return min(MLX5E_QOS_MAX_LEAF_NODES, mlx5_qos_max_leaf_nodes(mdev));
+}
+
+int mlx5e_qos_cur_leaf_nodes(struct mlx5e_priv *priv)
+{
+	int last = find_last_bit(priv->htb.qos_used_qids, mlx5e_qos_max_leaf_nodes(priv->mdev));
+
+	return last == mlx5e_qos_max_leaf_nodes(priv->mdev) ? 0 : last + 1;
+}
+
+/* Software representation of the QoS tree (internal to this file) */
+
+static int mlx5e_find_unused_qos_qid(struct mlx5e_priv *priv)
+{
+	int size = mlx5e_qos_max_leaf_nodes(priv->mdev);
+	int res;
+
+	WARN_ONCE(!mutex_is_locked(&priv->state_lock), "%s: state_lock is not held\n", __func__);
+	res = find_first_zero_bit(priv->htb.qos_used_qids, size);
+
+	return res == size ? -ENOSPC : res;
+}
+
+struct mlx5e_qos_node {
+	struct hlist_node hnode;
+	struct rcu_head rcu;
+	struct mlx5e_qos_node *parent;
+	u64 rate;
+	u32 bw_share;
+	u32 max_average_bw;
+	u32 hw_id;
+	u32 classid; /* 16-bit, except root. */
+	u16 qid;
+};
+
+#define MLX5E_QOS_QID_INNER 0xffff
+#define MLX5E_HTB_CLASSID_ROOT 0xffffffff
+
+static struct mlx5e_qos_node *
+mlx5e_sw_node_create_leaf(struct mlx5e_priv *priv, u16 classid, u16 qid,
+			  struct mlx5e_qos_node *parent)
+{
+	struct mlx5e_qos_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->parent = parent;
+
+	node->qid = qid;
+	__set_bit(qid, priv->htb.qos_used_qids);
+
+	node->classid = classid;
+	hash_add_rcu(priv->htb.qos_tc2node, &node->hnode, classid);
+
+	mlx5e_update_tx_netdev_queues(priv);
+
+	return node;
+}
+
+static struct mlx5e_qos_node *mlx5e_sw_node_create_root(struct mlx5e_priv *priv)
+{
+	struct mlx5e_qos_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->qid = MLX5E_QOS_QID_INNER;
+	node->classid = MLX5E_HTB_CLASSID_ROOT;
+	hash_add_rcu(priv->htb.qos_tc2node, &node->hnode, node->classid);
+
+	return node;
+}
+
+static struct mlx5e_qos_node *mlx5e_sw_node_find(struct mlx5e_priv *priv, u32 classid)
+{
+	struct mlx5e_qos_node *node = NULL;
+
+	hash_for_each_possible(priv->htb.qos_tc2node, node, hnode, classid) {
+		if (node->classid == classid)
+			break;
+	}
+
+	return node;
+}
+
+static struct mlx5e_qos_node *mlx5e_sw_node_find_rcu(struct mlx5e_priv *priv, u32 classid)
+{
+	struct mlx5e_qos_node *node = NULL;
+
+	hash_for_each_possible_rcu(priv->htb.qos_tc2node, node, hnode, classid) {
+		if (node->classid == classid)
+			break;
+	}
+
+	return node;
+}
+
+static void mlx5e_sw_node_delete(struct mlx5e_priv *priv, struct mlx5e_qos_node *node)
+{
+	hash_del_rcu(&node->hnode);
+	if (node->qid != MLX5E_QOS_QID_INNER) {
+		__clear_bit(node->qid, priv->htb.qos_used_qids);
+		mlx5e_update_tx_netdev_queues(priv);
+	}
+	kfree_rcu(node, rcu);
+}
+
+/* TX datapath API */
+
+static u16 mlx5e_qid_from_qos(struct mlx5e_channels *chs, u16 qid)
+{
+	/* These channel params are safe to access from the datapath, because:
+	 * 1. This function is called only after checking priv->htb.maj_id != 0,
+	 *    and the number of queues can't change while HTB offload is active.
+	 * 2. When priv->htb.maj_id becomes 0, synchronize_rcu waits for
+	 *    mlx5e_select_queue to finish while holding priv->state_lock,
+	 *    preventing other code from changing the number of queues.
+	 */
+	bool is_ptp = MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS);
+
+	return (chs->params.num_channels + is_ptp) * chs->params.num_tc + qid;
+}
+
+int mlx5e_get_txq_by_classid(struct mlx5e_priv *priv, u16 classid)
+{
+	struct mlx5e_qos_node *node;
+	u16 qid;
+	int res;
+
+	rcu_read_lock();
+
+	node = mlx5e_sw_node_find_rcu(priv, classid);
+	if (!node) {
+		res = -ENOENT;
+		goto out;
+	}
+	qid = READ_ONCE(node->qid);
+	if (qid == MLX5E_QOS_QID_INNER) {
+		res = -EINVAL;
+		goto out;
+	}
+	res = mlx5e_qid_from_qos(&priv->channels, qid);
+
+out:
+	rcu_read_unlock();
+	return res;
+}
+
+static struct mlx5e_txqsq *mlx5e_get_qos_sq(struct mlx5e_priv *priv, int qid)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	struct mlx5e_channel *c;
+	int ix;
+
+	ix = qid % params->num_channels;
+	qid /= params->num_channels;
+	c = priv->channels.c[ix];
+
+	qos_sqs = mlx5e_state_dereference(priv, c->qos_sqs);
+	return mlx5e_state_dereference(priv, qos_sqs[qid]);
+}
+
+/* SQ lifecycle */
+
+static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs,
+			     struct mlx5e_qos_node *node)
+{
+	struct mlx5e_create_cq_param ccp = {};
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	struct mlx5e_sq_param param_sq;
+	struct mlx5e_cq_param param_cq;
+	int txq_ix, ix, qid, err = 0;
+	struct mlx5e_params *params;
+	struct mlx5e_channel *c;
+	struct mlx5e_txqsq *sq;
+
+	params = &chs->params;
+
+	txq_ix = mlx5e_qid_from_qos(chs, node->qid);
+
+	WARN_ON(node->qid > priv->htb.max_qos_sqs);
+	if (node->qid == priv->htb.max_qos_sqs) {
+		struct mlx5e_sq_stats *stats, **stats_list = NULL;
+
+		if (priv->htb.max_qos_sqs == 0) {
+			stats_list = kvcalloc(mlx5e_qos_max_leaf_nodes(priv->mdev),
+					      sizeof(*stats_list),
+					      GFP_KERNEL);
+			if (!stats_list)
+				return -ENOMEM;
+		}
+		stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+		if (!stats) {
+			kvfree(stats_list);
+			return -ENOMEM;
+		}
+		if (stats_list)
+			WRITE_ONCE(priv->htb.qos_sq_stats, stats_list);
+		WRITE_ONCE(priv->htb.qos_sq_stats[node->qid], stats);
+		/* Order max_qos_sqs increment after writing the array pointer.
+		 * Pairs with smp_load_acquire in en_stats.c.
+		 */
+		smp_store_release(&priv->htb.max_qos_sqs, priv->htb.max_qos_sqs + 1);
+	}
+
+	ix = node->qid % params->num_channels;
+	qid = node->qid / params->num_channels;
+	c = chs->c[ix];
+
+	qos_sqs = mlx5e_state_dereference(priv, c->qos_sqs);
+	sq = kzalloc(sizeof(*sq), GFP_KERNEL);
+
+	if (!sq)
+		return -ENOMEM;
+
+	mlx5e_build_create_cq_param(&ccp, c);
+
+	memset(&param_sq, 0, sizeof(param_sq));
+	memset(&param_cq, 0, sizeof(param_cq));
+	mlx5e_build_sq_param(priv, params, &param_sq);
+	mlx5e_build_tx_cq_param(priv, params, &param_cq);
+	err = mlx5e_open_cq(priv, params->tx_cq_moderation, &param_cq, &ccp, &sq->cq);
+	if (err)
+		goto err_free_sq;
+	err = mlx5e_open_txqsq(c, priv->tisn[c->lag_port][0], txq_ix, params,
+			       &param_sq, sq, 0, node->hw_id, node->qid);
+	if (err)
+		goto err_close_cq;
+
+	rcu_assign_pointer(qos_sqs[qid], sq);
+
+	return 0;
+
+err_close_cq:
+	mlx5e_close_cq(&sq->cq);
+err_free_sq:
+	kfree(sq);
+	return err;
+}
+
+static void mlx5e_activate_qos_sq(struct mlx5e_priv *priv, struct mlx5e_qos_node *node)
+{
+	struct mlx5e_txqsq *sq;
+
+	sq = mlx5e_get_qos_sq(priv, node->qid);
+
+	WRITE_ONCE(priv->txq2sq[mlx5e_qid_from_qos(&priv->channels, node->qid)], sq);
+
+	/* Make the change to txq2sq visible before the queue is started.
+	 * As mlx5e_xmit runs under a spinlock, there is an implicit ACQUIRE,
+	 * which pairs with this barrier.
+	 */
+	smp_wmb();
+
+	qos_dbg(priv->mdev, "Activate QoS SQ qid %u\n", node->qid);
+	mlx5e_activate_txqsq(sq);
+}
+
+static void mlx5e_deactivate_qos_sq(struct mlx5e_priv *priv, u16 qid)
+{
+	struct mlx5e_txqsq *sq;
+
+	sq = mlx5e_get_qos_sq(priv, qid);
+	if (!sq) /* Handle the case when the SQ failed to open. */
+		return;
+
+	qos_dbg(priv->mdev, "Deactivate QoS SQ qid %u\n", qid);
+	mlx5e_deactivate_txqsq(sq);
+
+	/* The queue is disabled, no synchronization with datapath is needed. */
+	priv->txq2sq[mlx5e_qid_from_qos(&priv->channels, qid)] = NULL;
+}
+
+static void mlx5e_close_qos_sq(struct mlx5e_priv *priv, u16 qid)
+{
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	struct mlx5e_params *params;
+	struct mlx5e_channel *c;
+	struct mlx5e_txqsq *sq;
+	int ix;
+
+	params = &priv->channels.params;
+
+	ix = qid % params->num_channels;
+	qid /= params->num_channels;
+	c = priv->channels.c[ix];
+	qos_sqs = mlx5e_state_dereference(priv, c->qos_sqs);
+	sq = rcu_replace_pointer(qos_sqs[qid], NULL, lockdep_is_held(&priv->state_lock));
+	if (!sq) /* Handle the case when the SQ failed to open. */
+		return;
+
+	synchronize_rcu(); /* Sync with NAPI. */
+
+	mlx5e_close_txqsq(sq);
+	mlx5e_close_cq(&sq->cq);
+	kfree(sq);
+}
+
+void mlx5e_qos_close_queues(struct mlx5e_channel *c)
+{
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	int i;
+
+	qos_sqs = rcu_replace_pointer(c->qos_sqs, NULL, lockdep_is_held(&c->priv->state_lock));
+	if (!qos_sqs)
+		return;
+	synchronize_rcu(); /* Sync with NAPI. */
+
+	for (i = 0; i < c->qos_sqs_size; i++) {
+		struct mlx5e_txqsq *sq;
+
+		sq = mlx5e_state_dereference(c->priv, qos_sqs[i]);
+		if (!sq) /* Handle the case when the SQ failed to open. */
+			continue;
+
+		mlx5e_close_txqsq(sq);
+		mlx5e_close_cq(&sq->cq);
+		kfree(sq);
+	}
+
+	kvfree(qos_sqs);
+}
+
+static void mlx5e_qos_close_all_queues(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_qos_close_queues(chs->c[i]);
+}
+
+static int mlx5e_qos_alloc_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
+{
+	u16 qos_sqs_size;
+	int i;
+
+	qos_sqs_size = DIV_ROUND_UP(mlx5e_qos_max_leaf_nodes(priv->mdev), chs->num);
+
+	for (i = 0; i < chs->num; i++) {
+		struct mlx5e_txqsq **sqs;
+
+		sqs = kvcalloc(qos_sqs_size, sizeof(struct mlx5e_txqsq *), GFP_KERNEL);
+		if (!sqs)
+			goto err_free;
+
+		WRITE_ONCE(chs->c[i]->qos_sqs_size, qos_sqs_size);
+		smp_wmb(); /* Pairs with mlx5e_napi_poll. */
+		rcu_assign_pointer(chs->c[i]->qos_sqs, sqs);
+	}
+
+	return 0;
+
+err_free:
+	while (--i >= 0) {
+		struct mlx5e_txqsq **sqs;
+
+		sqs = rcu_replace_pointer(chs->c[i]->qos_sqs, NULL,
+					  lockdep_is_held(&priv->state_lock));
+
+		synchronize_rcu(); /* Sync with NAPI. */
+		kvfree(sqs);
+	}
+	return -ENOMEM;
+}
+
+int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
+{
+	struct mlx5e_qos_node *node = NULL;
+	int bkt, err;
+
+	if (!priv->htb.maj_id)
+		return 0;
+
+	err = mlx5e_qos_alloc_queues(priv, chs);
+	if (err)
+		return err;
+
+	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode) {
+		if (node->qid == MLX5E_QOS_QID_INNER)
+			continue;
+		err = mlx5e_open_qos_sq(priv, chs, node);
+		if (err) {
+			mlx5e_qos_close_all_queues(chs);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+void mlx5e_qos_activate_queues(struct mlx5e_priv *priv)
+{
+	struct mlx5e_qos_node *node = NULL;
+	int bkt;
+
+	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode) {
+		if (node->qid == MLX5E_QOS_QID_INNER)
+			continue;
+		mlx5e_activate_qos_sq(priv, node);
+	}
+}
+
+void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
+{
+	struct mlx5e_params *params = &c->priv->channels.params;
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	int i;
+
+	qos_sqs = mlx5e_state_dereference(c->priv, c->qos_sqs);
+	if (!qos_sqs)
+		return;
+
+	for (i = 0; i < c->qos_sqs_size; i++) {
+		u16 qid = params->num_channels * i + c->ix;
+		struct mlx5e_txqsq *sq;
+
+		sq = mlx5e_state_dereference(c->priv, qos_sqs[i]);
+		if (!sq) /* Handle the case when the SQ failed to open. */
+			continue;
+
+		qos_dbg(c->mdev, "Deactivate QoS SQ qid %u\n", qid);
+		mlx5e_deactivate_txqsq(sq);
+
+		/* The queue is disabled, no synchronization with datapath is needed. */
+		c->priv->txq2sq[mlx5e_qid_from_qos(&c->priv->channels, qid)] = NULL;
+	}
+}
+
+static void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_qos_deactivate_queues(chs->c[i]);
+}
+
+/* HTB API */
+
+int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
+		       struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *root;
+	bool opened;
+	int err;
+
+	qos_dbg(priv->mdev, "TC_HTB_CREATE handle %04x:, default :%04x\n", htb_maj_id, htb_defcls);
+
+	if (!mlx5_qos_is_supported(priv->mdev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing QoS capabilities. Try disabling SRIOV or use a supported device.");
+		return -EOPNOTSUPP;
+	}
+
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (opened) {
+		err = mlx5e_qos_alloc_queues(priv, &priv->channels);
+		if (err)
+			return err;
+	}
+
+	root = mlx5e_sw_node_create_root(priv);
+	if (IS_ERR(root)) {
+		err = PTR_ERR(root);
+		goto err_free_queues;
+	}
+
+	err = mlx5_qos_create_root_node(priv->mdev, &root->hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error. Try upgrading firmware.");
+		goto err_sw_node_delete;
+	}
+
+	WRITE_ONCE(priv->htb.defcls, htb_defcls);
+	/* Order maj_id after defcls - pairs with
+	 * mlx5e_select_queue/mlx5e_select_htb_queues.
+	 */
+	smp_store_release(&priv->htb.maj_id, htb_maj_id);
+
+	return 0;
+
+err_sw_node_delete:
+	mlx5e_sw_node_delete(priv, root);
+
+err_free_queues:
+	if (opened)
+		mlx5e_qos_close_all_queues(&priv->channels);
+	return err;
+}
+
+int mlx5e_htb_root_del(struct mlx5e_priv *priv)
+{
+	struct mlx5e_qos_node *root;
+	int err;
+
+	qos_dbg(priv->mdev, "TC_HTB_DESTROY\n");
+
+	WRITE_ONCE(priv->htb.maj_id, 0);
+	synchronize_rcu(); /* Sync with mlx5e_select_htb_queue and TX data path. */
+
+	root = mlx5e_sw_node_find(priv, MLX5E_HTB_CLASSID_ROOT);
+	if (!root) {
+		qos_err(priv->mdev, "Failed to find the root node in the QoS tree\n");
+		return -ENOENT;
+	}
+	err = mlx5_qos_destroy_node(priv->mdev, root->hw_id);
+	if (err)
+		qos_err(priv->mdev, "Failed to destroy root node %u, err = %d\n",
+			root->hw_id, err);
+	mlx5e_sw_node_delete(priv, root);
+
+	mlx5e_qos_deactivate_all_queues(&priv->channels);
+	mlx5e_qos_close_all_queues(&priv->channels);
+
+	return err;
+}
+
+static int mlx5e_htb_convert_rate(struct mlx5e_priv *priv, u64 rate,
+				  struct mlx5e_qos_node *parent, u32 *bw_share)
+{
+	u64 share = 0;
+
+	while (parent->classid != MLX5E_HTB_CLASSID_ROOT && !parent->max_average_bw)
+		parent = parent->parent;
+
+	if (parent->max_average_bw)
+		share = div64_u64(div_u64(rate * 100, BYTES_IN_MBIT),
+				  parent->max_average_bw);
+	else
+		share = 101;
+
+	*bw_share = share == 0 ? 1 : share > 100 ? 0 : share;
+
+	qos_dbg(priv->mdev, "Convert: rate %llu, parent ceil %llu -> bw_share %u\n",
+		rate, (u64)parent->max_average_bw * BYTES_IN_MBIT, *bw_share);
+
+	return 0;
+}
+
+static void mlx5e_htb_convert_ceil(struct mlx5e_priv *priv, u64 ceil, u32 *max_average_bw)
+{
+	*max_average_bw = div_u64(ceil, BYTES_IN_MBIT);
+
+	qos_dbg(priv->mdev, "Convert: ceil %llu -> max_average_bw %u\n",
+		ceil, *max_average_bw);
+}
+
+int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
+			       u32 parent_classid, u64 rate, u64 ceil,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *node, *parent;
+	int qid;
+	int err;
+
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_ALLOC_QUEUE classid %04x, parent %04x, rate %llu, ceil %llu\n",
+		classid, parent_classid, rate, ceil);
+
+	qid = mlx5e_find_unused_qos_qid(priv);
+	if (qid < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Maximum amount of leaf classes is reached.");
+		return qid;
+	}
+
+	parent = mlx5e_sw_node_find(priv, parent_classid);
+	if (!parent)
+		return -EINVAL;
+
+	node = mlx5e_sw_node_create_leaf(priv, classid, qid, parent);
+	if (IS_ERR(node))
+		return PTR_ERR(node);
+
+	node->rate = rate;
+	mlx5e_htb_convert_rate(priv, rate, node->parent, &node->bw_share);
+	mlx5e_htb_convert_ceil(priv, ceil, &node->max_average_bw);
+
+	err = mlx5_qos_create_leaf_node(priv->mdev, node->parent->hw_id,
+					node->bw_share, node->max_average_bw,
+					&node->hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error when creating a leaf node.");
+		qos_err(priv->mdev, "Failed to create a leaf node (class %04x), err = %d\n",
+			classid, err);
+		mlx5e_sw_node_delete(priv, node);
+		return err;
+	}
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		err = mlx5e_open_qos_sq(priv, &priv->channels, node);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Error creating an SQ.");
+			qos_warn(priv->mdev, "Failed to create a QoS SQ (class %04x), err = %d\n",
+				 classid, err);
+		} else {
+			mlx5e_activate_qos_sq(priv, node);
+		}
+	}
+
+	return mlx5e_qid_from_qos(&priv->channels, node->qid);
+}
+
+int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
+			    u64 rate, u64 ceil, struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *node, *child;
+	int err, tmp_err;
+	u32 new_hw_id;
+	u16 qid;
+
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_TO_INNER classid %04x, upcoming child %04x, rate %llu, ceil %llu\n",
+		classid, child_classid, rate, ceil);
+
+	node = mlx5e_sw_node_find(priv, classid);
+	if (!node)
+		return -ENOENT;
+
+	err = mlx5_qos_create_inner_node(priv->mdev, node->parent->hw_id,
+					 node->bw_share, node->max_average_bw,
+					 &new_hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error when creating an inner node.");
+		qos_err(priv->mdev, "Failed to create an inner node (class %04x), err = %d\n",
+			classid, err);
+		return err;
+	}
+
+	/* Intentionally reuse the qid for the upcoming first child. */
+	child = mlx5e_sw_node_create_leaf(priv, child_classid, node->qid, node);
+	if (IS_ERR(child)) {
+		err = PTR_ERR(child);
+		goto err_destroy_hw_node;
+	}
+
+	child->rate = rate;
+	mlx5e_htb_convert_rate(priv, rate, node, &child->bw_share);
+	mlx5e_htb_convert_ceil(priv, ceil, &child->max_average_bw);
+
+	err = mlx5_qos_create_leaf_node(priv->mdev, new_hw_id, child->bw_share,
+					child->max_average_bw, &child->hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error when creating a leaf node.");
+		qos_err(priv->mdev, "Failed to create a leaf node (class %04x), err = %d\n",
+			classid, err);
+		goto err_delete_sw_node;
+	}
+
+	/* No fail point. */
+
+	qid = node->qid;
+	/* Pairs with mlx5e_get_txq_by_classid. */
+	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		mlx5e_deactivate_qos_sq(priv, qid);
+		mlx5e_close_qos_sq(priv, qid);
+	}
+
+	err = mlx5_qos_destroy_node(priv->mdev, node->hw_id);
+	if (err) /* Not fatal. */
+		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
+			 node->hw_id, classid, err);
+
+	node->hw_id = new_hw_id;
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		err = mlx5e_open_qos_sq(priv, &priv->channels, child);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Error creating an SQ.");
+			qos_warn(priv->mdev, "Failed to create a QoS SQ (class %04x), err = %d\n",
+				 classid, err);
+		} else {
+			mlx5e_activate_qos_sq(priv, child);
+		}
+	}
+
+	return 0;
+
+err_delete_sw_node:
+	child->qid = MLX5E_QOS_QID_INNER;
+	mlx5e_sw_node_delete(priv, child);
+
+err_destroy_hw_node:
+	tmp_err = mlx5_qos_destroy_node(priv->mdev, new_hw_id);
+	if (tmp_err) /* Not fatal. */
+		qos_warn(priv->mdev, "Failed to roll back creation of an inner node %u (class %04x), err = %d\n",
+			 new_hw_id, classid, tmp_err);
+	return err;
+}
+
+static struct mlx5e_qos_node *mlx5e_sw_node_find_by_qid(struct mlx5e_priv *priv, u16 qid)
+{
+	struct mlx5e_qos_node *node = NULL;
+	int bkt;
+
+	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode)
+		if (node->qid == qid)
+			break;
+
+	return node;
+}
+
+static void mlx5e_reactivate_qos_sq(struct mlx5e_priv *priv, u16 qid, struct netdev_queue *txq)
+{
+	qos_dbg(priv->mdev, "Reactivate QoS SQ qid %u\n", qid);
+	netdev_tx_reset_queue(txq);
+	netif_tx_start_queue(txq);
+}
+
+static void mlx5e_reset_qdisc(struct net_device *dev, u16 qid)
+{
+	struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, qid);
+	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+
+	if (!qdisc)
+		return;
+
+	spin_lock_bh(qdisc_lock(qdisc));
+	qdisc_reset(qdisc);
+	spin_unlock_bh(qdisc_lock(qdisc));
+}
+
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
+		       u16 *new_qid, struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *node;
+	struct netdev_queue *txq;
+	u16 qid, moved_qid;
+	bool opened;
+	int err;
+
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL classid %04x\n", classid);
+
+	*old_qid = *new_qid = 0;
+
+	node = mlx5e_sw_node_find(priv, classid);
+	if (!node)
+		return -ENOENT;
+
+	/* Store qid for reuse. */
+	qid = node->qid;
+
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (opened) {
+		txq = netdev_get_tx_queue(priv->netdev,
+					  mlx5e_qid_from_qos(&priv->channels, qid));
+		mlx5e_deactivate_qos_sq(priv, qid);
+		mlx5e_close_qos_sq(priv, qid);
+	}
+
+	err = mlx5_qos_destroy_node(priv->mdev, node->hw_id);
+	if (err) /* Not fatal. */
+		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
+			 node->hw_id, classid, err);
+
+	mlx5e_sw_node_delete(priv, node);
+
+	moved_qid = mlx5e_qos_cur_leaf_nodes(priv);
+
+	if (moved_qid == 0) {
+		/* The last QoS SQ was just destroyed. */
+		if (opened)
+			mlx5e_reactivate_qos_sq(priv, qid, txq);
+		return 0;
+	}
+	moved_qid--;
+
+	if (moved_qid < qid) {
+		/* The highest QoS SQ was just destroyed. */
+		WARN(moved_qid != qid - 1, "Gaps in queue numeration: destroyed queue %u, the highest queue is %u",
+		     qid, moved_qid);
+		if (opened)
+			mlx5e_reactivate_qos_sq(priv, qid, txq);
+		return 0;
+	}
+
+	WARN(moved_qid == qid, "Can't move node with qid %u to itself", qid);
+	qos_dbg(priv->mdev, "Moving QoS SQ %u to %u\n", moved_qid, qid);
+
+	node = mlx5e_sw_node_find_by_qid(priv, moved_qid);
+	WARN(!node, "Could not find a node with qid %u to move to queue %u",
+	     moved_qid, qid);
+
+	/* Stop traffic to the old queue. */
+	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
+	__clear_bit(moved_qid, priv->htb.qos_used_qids);
+
+	if (opened) {
+		txq = netdev_get_tx_queue(priv->netdev,
+					  mlx5e_qid_from_qos(&priv->channels, moved_qid));
+		mlx5e_deactivate_qos_sq(priv, moved_qid);
+		mlx5e_close_qos_sq(priv, moved_qid);
+	}
+
+	/* Prevent packets from the old class from getting into the new one. */
+	mlx5e_reset_qdisc(priv->netdev, moved_qid);
+
+	__set_bit(qid, priv->htb.qos_used_qids);
+	WRITE_ONCE(node->qid, qid);
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		err = mlx5e_open_qos_sq(priv, &priv->channels, node);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Error creating an SQ.");
+			qos_warn(priv->mdev, "Failed to create a QoS SQ (class %04x) while moving qid %u to %u, err = %d\n",
+				 node->classid, moved_qid, qid, err);
+		} else {
+			mlx5e_activate_qos_sq(priv, node);
+		}
+	}
+
+	mlx5e_update_tx_netdev_queues(priv);
+	if (opened)
+		mlx5e_reactivate_qos_sq(priv, moved_qid, txq);
+
+	*old_qid = mlx5e_qid_from_qos(&priv->channels, moved_qid);
+	*new_qid = mlx5e_qid_from_qos(&priv->channels, qid);
+	return 0;
+}
+
+int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
+			    struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *node, *parent;
+	u32 old_hw_id, new_hw_id;
+	int err, saved_err = 0;
+	u16 qid;
+
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL_LAST%s classid %04x\n",
+		force ? "_FORCE" : "", classid);
+
+	node = mlx5e_sw_node_find(priv, classid);
+	if (!node)
+		return -ENOENT;
+
+	err = mlx5_qos_create_leaf_node(priv->mdev, node->parent->parent->hw_id,
+					node->parent->bw_share,
+					node->parent->max_average_bw,
+					&new_hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error when creating a leaf node.");
+		qos_err(priv->mdev, "Failed to create a leaf node (class %04x), err = %d\n",
+			classid, err);
+		if (!force)
+			return err;
+		saved_err = err;
+	}
+
+	/* Store qid for reuse and prevent clearing the bit. */
+	qid = node->qid;
+	/* Pairs with mlx5e_get_txq_by_classid. */
+	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		mlx5e_deactivate_qos_sq(priv, qid);
+		mlx5e_close_qos_sq(priv, qid);
+	}
+
+	/* Prevent packets from the old class from getting into the new one. */
+	mlx5e_reset_qdisc(priv->netdev, qid);
+
+	err = mlx5_qos_destroy_node(priv->mdev, node->hw_id);
+	if (err) /* Not fatal. */
+		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
+			 node->hw_id, classid, err);
+
+	parent = node->parent;
+	mlx5e_sw_node_delete(priv, node);
+
+	node = parent;
+	WRITE_ONCE(node->qid, qid);
+
+	/* Early return on error in force mode. Parent will still be an inner
+	 * node to be deleted by a following delete operation.
+	 */
+	if (saved_err)
+		return saved_err;
+
+	old_hw_id = node->hw_id;
+	node->hw_id = new_hw_id;
+
+	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		err = mlx5e_open_qos_sq(priv, &priv->channels, node);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Error creating an SQ.");
+			qos_warn(priv->mdev, "Failed to create a QoS SQ (class %04x), err = %d\n",
+				 classid, err);
+		} else {
+			mlx5e_activate_qos_sq(priv, node);
+		}
+	}
+
+	err = mlx5_qos_destroy_node(priv->mdev, old_hw_id);
+	if (err) /* Not fatal. */
+		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
+			 node->hw_id, classid, err);
+
+	return 0;
+}
+
+static int mlx5e_qos_update_children(struct mlx5e_priv *priv, struct mlx5e_qos_node *node,
+				     struct netlink_ext_ack *extack)
+{
+	struct mlx5e_qos_node *child;
+	int err = 0;
+	int bkt;
+
+	hash_for_each(priv->htb.qos_tc2node, bkt, child, hnode) {
+		u32 old_bw_share = child->bw_share;
+		int err_one;
+
+		if (child->parent != node)
+			continue;
+
+		mlx5e_htb_convert_rate(priv, child->rate, node, &child->bw_share);
+		if (child->bw_share == old_bw_share)
+			continue;
+
+		err_one = mlx5_qos_update_node(priv->mdev, child->hw_id, child->bw_share,
+					       child->max_average_bw, child->hw_id);
+		if (!err && err_one) {
+			err = err_one;
+
+			NL_SET_ERR_MSG_MOD(extack, "Firmware error when modifying a child node.");
+			qos_err(priv->mdev, "Failed to modify a child node (class %04x), err = %d\n",
+				node->classid, err);
+		}
+	}
+
+	return err;
+}
+
+int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
+			  struct netlink_ext_ack *extack)
+{
+	u32 bw_share, max_average_bw;
+	struct mlx5e_qos_node *node;
+	bool ceil_changed = false;
+	int err;
+
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_MODIFY classid %04x, rate %llu, ceil %llu\n",
+		classid, rate, ceil);
+
+	node = mlx5e_sw_node_find(priv, classid);
+	if (!node)
+		return -ENOENT;
+
+	node->rate = rate;
+	mlx5e_htb_convert_rate(priv, rate, node->parent, &bw_share);
+	mlx5e_htb_convert_ceil(priv, ceil, &max_average_bw);
+
+	err = mlx5_qos_update_node(priv->mdev, node->parent->hw_id, bw_share,
+				   max_average_bw, node->hw_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware error when modifying a node.");
+		qos_err(priv->mdev, "Failed to modify a node (class %04x), err = %d\n",
+			classid, err);
+		return err;
+	}
+
+	if (max_average_bw != node->max_average_bw)
+		ceil_changed = true;
+
+	node->bw_share = bw_share;
+	node->max_average_bw = max_average_bw;
+
+	if (ceil_changed)
+		err = mlx5e_qos_update_children(priv, node, extack);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
new file mode 100644
index 000000000000..5af7991fcd19
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5E_EN_QOS_H
+#define __MLX5E_EN_QOS_H
+
+#include <linux/mlx5/driver.h>
+
+#define MLX5E_QOS_MAX_LEAF_NODES 256
+
+struct mlx5e_priv;
+struct mlx5e_channels;
+struct mlx5e_channel;
+
+int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev);
+int mlx5e_qos_cur_leaf_nodes(struct mlx5e_priv *priv);
+
+/* TX datapath API */
+int mlx5e_get_txq_by_classid(struct mlx5e_priv *priv, u16 classid);
+struct mlx5e_txqsq *mlx5e_get_sq(struct mlx5e_priv *priv, int qid);
+
+/* SQ lifecycle */
+int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
+void mlx5e_qos_activate_queues(struct mlx5e_priv *priv);
+void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
+void mlx5e_qos_close_queues(struct mlx5e_channel *c);
+
+/* HTB API */
+int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
+		       struct netlink_ext_ack *extack);
+int mlx5e_htb_root_del(struct mlx5e_priv *priv);
+int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
+			       u32 parent_classid, u64 rate, u64 ceil,
+			       struct netlink_ext_ack *extack);
+int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
+			    u64 rate, u64 ceil, struct netlink_ext_ack *extack);
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
+		       u16 *new_qid, struct netlink_ext_ack *extack);
+int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
+			    struct netlink_ext_ack *extack);
+int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
+			  struct netlink_ext_ack *extack);
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2d37742a888c..2e5a0696374a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -447,6 +447,17 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		goto out;
 	}
 
+	/* Don't allow changing the number of channels if HTB offload is active,
+	 * because the numeration of the QoS SQs will change, while per-queue
+	 * qdiscs are attached.
+	 */
+	if (priv->htb.maj_id) {
+		err = -EINVAL;
+		netdev_err(priv->netdev, "%s: HTB offload is active, cannot change the number of channels\n",
+			   __func__);
+		goto out;
+	}
+
 	new_channels.params = priv->channels.params;
 	new_channels.params.num_channels = count;
 
@@ -1966,6 +1977,16 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	if (!MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
 		return -EOPNOTSUPP;
 
+	/* Don't allow changing the PTP state if HTB offload is active, because
+	 * the numeration of the QoS SQs will change, while per-queue qdiscs are
+	 * attached.
+	 */
+	if (priv->htb.maj_id) {
+		netdev_err(priv->netdev, "%s: HTB offload is active, cannot change the PTP state\n",
+			   __func__);
+		return -EINVAL;
+	}
+
 	new_channels.params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_TX_PORT_TS, enable);
 	/* No need to verify SQ stop room as
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f33c38629886..b9a175982801 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -65,6 +65,7 @@
 #include "en/devlink.h"
 #include "lib/mlx5.h"
 #include "en/ptp.h"
+#include "qos.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -1143,7 +1144,6 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->stats     = &c->priv->channel_stats[c->ix].sq[tc];
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
@@ -1233,6 +1233,7 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p)
 {
+	u64 bitmask = 0;
 	void *in;
 	void *sqc;
 	int inlen;
@@ -1248,9 +1249,14 @@ int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 	MLX5_SET(modify_sq_in, in, sq_state, p->curr_state);
 	MLX5_SET(sqc, sqc, state, p->next_state);
 	if (p->rl_update && p->next_state == MLX5_SQC_STATE_RDY) {
-		MLX5_SET64(modify_sq_in, in, modify_bitmask, 1);
-		MLX5_SET(sqc,  sqc, packet_pacing_rate_limit_index, p->rl_index);
+		bitmask |= 1;
+		MLX5_SET(sqc, sqc, packet_pacing_rate_limit_index, p->rl_index);
 	}
+	if (p->qos_update && p->next_state == MLX5_SQC_STATE_RDY) {
+		bitmask |= 1 << 2;
+		MLX5_SET(sqc, sqc, qos_queue_group_id, p->qos_queue_group_id);
+	}
+	MLX5_SET64(modify_sq_in, in, modify_bitmask, bitmask);
 
 	err = mlx5_core_modify_sq(mdev, sqn, in);
 
@@ -1267,6 +1273,7 @@ static void mlx5e_destroy_sq(struct mlx5_core_dev *mdev, u32 sqn)
 int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
 			struct mlx5e_sq_param *param,
 			struct mlx5e_create_sq_param *csp,
+			u16 qos_queue_group_id,
 			u32 *sqn)
 {
 	struct mlx5e_modify_sq_param msp = {0};
@@ -1278,6 +1285,10 @@ int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
 
 	msp.curr_state = MLX5_SQC_STATE_RST;
 	msp.next_state = MLX5_SQC_STATE_RDY;
+	if (qos_queue_group_id) {
+		msp.qos_update = true;
+		msp.qos_queue_group_id = qos_queue_group_id;
+	}
 	err = mlx5e_modify_sq(mdev, *sqn, &msp);
 	if (err)
 		mlx5e_destroy_sq(mdev, *sqn);
@@ -1288,13 +1299,9 @@ int mlx5e_create_sq_rdy(struct mlx5_core_dev *mdev,
 static int mlx5e_set_sq_maxrate(struct net_device *dev,
 				struct mlx5e_txqsq *sq, u32 rate);
 
-static int mlx5e_open_txqsq(struct mlx5e_channel *c,
-			    u32 tisn,
-			    int txq_ix,
-			    struct mlx5e_params *params,
-			    struct mlx5e_sq_param *param,
-			    struct mlx5e_txqsq *sq,
-			    int tc)
+int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
+		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
+		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id, u16 qos_qid)
 {
 	struct mlx5e_create_sq_param csp = {};
 	u32 tx_rate;
@@ -1304,12 +1311,17 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
+	if (qos_queue_group_id)
+		sq->stats = c->priv->htb.qos_sq_stats[qos_qid];
+	else
+		sq->stats = &c->priv->channel_stats[c->ix].sq[tc];
+
 	csp.tisn            = tisn;
 	csp.tis_lst_sz      = 1;
 	csp.cqn             = sq->cq.mcq.cqn;
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = sq->min_inline_mode;
-	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
+	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, qos_queue_group_id, &sq->sqn);
 	if (err)
 		goto err_free_txqsq;
 
@@ -1366,7 +1378,7 @@ void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	}
 }
 
-static void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 {
 	struct mlx5_core_dev *mdev = sq->mdev;
 	struct mlx5_rate_limit rl = {0};
@@ -1403,7 +1415,7 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.cqn             = sq->cq.mcq.cqn;
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = params->tx_min_inline_mode;
-	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
+	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
 	if (err)
 		goto err_free_icosq;
 
@@ -1452,7 +1464,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = sq->min_inline_mode;
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
+	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
 	if (err)
 		goto err_free_xdpsq;
 
@@ -1703,7 +1715,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
-				       params, &cparam->txq_sq, &c->sq[tc], tc);
+				       params, &cparam->txq_sq, &c->sq[tc], tc, 0, 0);
 		if (err)
 			goto err_close_sqs;
 	}
@@ -2044,6 +2056,8 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
+
+	mlx5e_qos_deactivate_queues(c);
 }
 
 static void mlx5e_close_channel(struct mlx5e_channel *c)
@@ -2051,6 +2065,7 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_close_xsk(c);
 	mlx5e_close_queues(c);
+	mlx5e_qos_close_queues(c);
 	netif_napi_del(&c->napi);
 
 	kvfree(c);
@@ -2198,9 +2213,8 @@ void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
 }
 
-static void mlx5e_build_sq_param(struct mlx5e_priv *priv,
-				 struct mlx5e_params *params,
-				 struct mlx5e_sq_param *param)
+void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
+			  struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
@@ -2379,10 +2393,18 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
 
+	err = mlx5e_qos_open_queues(priv, chs);
+	if (err)
+		goto err_close_ptp;
+
 	mlx5e_health_channels_update(priv);
 	kvfree(cparam);
 	return 0;
 
+err_close_ptp:
+	if (chs->port_ptp)
+		mlx5e_port_ptp_close(chs->port_ptp);
+
 err_close_channels:
 	for (i--; i >= 0; i--)
 		mlx5e_close_channel(chs->c[i]);
@@ -2915,11 +2937,31 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
+int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
+{
+	int qos_queues, nch, ntc, num_txqs, err;
+
+	qos_queues = mlx5e_qos_cur_leaf_nodes(priv);
+
+	nch = priv->channels.params.num_channels;
+	ntc = priv->channels.params.num_tc;
+	num_txqs = nch * ntc + qos_queues;
+	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS))
+		num_txqs += ntc;
+
+	mlx5e_dbg(DRV, priv, "Setting num_txqs %d\n", num_txqs);
+	err = netif_set_real_num_tx_queues(priv->netdev, num_txqs);
+	if (err)
+		netdev_warn(priv->netdev, "netif_set_real_num_tx_queues failed, %d\n", err);
+
+	return err;
+}
+
 static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
-	int num_txqs, num_rxqs, nch, ntc;
 	int old_num_txqs, old_ntc;
+	int num_rxqs, nch, ntc;
 	int err;
 
 	old_num_txqs = netdev->real_num_tx_queues;
@@ -2927,18 +2969,13 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;
-	num_txqs = nch * ntc;
-	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS))
-		num_txqs += ntc;
 	num_rxqs = nch * priv->profile->rq_groups;
 
 	mlx5e_netdev_set_tcs(netdev, nch, ntc);
 
-	err = netif_set_real_num_tx_queues(netdev, num_txqs);
-	if (err) {
-		netdev_warn(netdev, "netif_set_real_num_tx_queues failed, %d\n", err);
+	err = mlx5e_update_tx_netdev_queues(priv);
+	if (err)
 		goto err_tcs;
-	}
 	err = netif_set_real_num_rx_queues(netdev, num_rxqs);
 	if (err) {
 		netdev_warn(netdev, "netif_set_real_num_rx_queues failed, %d\n", err);
@@ -3042,6 +3079,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_update_num_tc_x_num_ch(priv);
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
+	mlx5e_qos_activate_queues(priv);
 	mlx5e_xdp_tx_enable(priv);
 	netif_tx_start_all_queues(priv->netdev);
 
@@ -3608,6 +3646,14 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 
 	mutex_lock(&priv->state_lock);
 
+	/* MQPRIO is another toplevel qdisc that can't be attached
+	 * simultaneously with the offloaded HTB.
+	 */
+	if (WARN_ON(priv->htb.maj_id)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	new_channels.params = priv->channels.params;
 	new_channels.params.num_tc = tc ? tc : 1;
 
@@ -3628,12 +3674,55 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
+{
+	int res;
+
+	switch (htb->command) {
+	case TC_HTB_CREATE:
+		return mlx5e_htb_root_add(priv, htb->parent_classid, htb->classid,
+					  htb->extack);
+	case TC_HTB_DESTROY:
+		return mlx5e_htb_root_del(priv);
+	case TC_HTB_LEAF_ALLOC_QUEUE:
+		res = mlx5e_htb_leaf_alloc_queue(priv, htb->classid, htb->parent_classid,
+						 htb->rate, htb->ceil, htb->extack);
+		if (res < 0)
+			return res;
+		htb->qid = res;
+		return 0;
+	case TC_HTB_LEAF_TO_INNER:
+		return mlx5e_htb_leaf_to_inner(priv, htb->parent_classid, htb->classid,
+					       htb->rate, htb->ceil, htb->extack);
+	case TC_HTB_LEAF_DEL:
+		return mlx5e_htb_leaf_del(priv, htb->classid, &htb->moved_qid, &htb->qid,
+					  htb->extack);
+	case TC_HTB_LEAF_DEL_LAST:
+	case TC_HTB_LEAF_DEL_LAST_FORCE:
+		return mlx5e_htb_leaf_del_last(priv, htb->classid,
+					       htb->command == TC_HTB_LEAF_DEL_LAST_FORCE,
+					       htb->extack);
+	case TC_HTB_NODE_MODIFY:
+		return mlx5e_htb_node_modify(priv, htb->classid, htb->rate, htb->ceil,
+					     htb->extack);
+	case TC_HTB_LEAF_QUERY_QUEUE:
+		res = mlx5e_get_txq_by_classid(priv, htb->classid);
+		if (res < 0)
+			return res;
+		htb->qid = res;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	int err;
 
 	switch (type) {
 	case TC_SETUP_BLOCK: {
@@ -3647,6 +3736,11 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(priv, type_data);
+	case TC_SETUP_QDISC_HTB:
+		mutex_lock(&priv->state_lock);
+		err = mlx5e_setup_tc_htb(priv, type_data);
+		mutex_unlock(&priv->state_lock);
+		return err;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3811,20 +3905,25 @@ static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-static int set_feature_tc_num_filters(struct net_device *netdev, bool enable)
+static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
 		netdev_err(netdev,
 			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 		return -EINVAL;
 	}
+#endif
+
+	if (!enable && priv->htb.maj_id) {
+		netdev_err(netdev, "Active HTB offload, can't turn hw_tc_offload off\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-#endif
 
 static int set_feature_rx_all(struct net_device *netdev, bool enable)
 {
@@ -3922,9 +4021,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
 				    set_feature_cvlan_filter);
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_tc_num_filters);
-#endif
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_hw_tc);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL, set_feature_rx_all);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS, set_feature_rx_fcs);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX, set_feature_rx_vlan);
@@ -5028,6 +5125,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_features	 |= NETIF_F_NTUPLE;
 #endif
 	}
+	if (mlx5_qos_is_supported(mdev))
+		netdev->features |= NETIF_F_HW_TC;
 
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
@@ -5333,6 +5432,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 		return -ENOMEM;
 
 	mutex_init(&priv->state_lock);
+	hash_init(priv->htb.qos_tc2node);
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
 	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
@@ -5355,8 +5455,14 @@ int mlx5e_netdev_init(struct net_device *netdev,
 
 void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv)
 {
+	int i;
+
 	destroy_workqueue(priv->wq);
 	free_cpumask_var(priv->scratchpad.cpumask);
+
+	for (i = 0; i < priv->htb.max_qos_sqs; i++)
+		kfree(priv->htb.qos_sq_stats[i]);
+	kvfree(priv->htb.qos_sq_stats);
 }
 
 struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
@@ -5366,13 +5472,17 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 {
 	struct net_device *netdev;
 	unsigned int ptp_txqs = 0;
+	int qos_sqs = 0;
 	int err;
 
 	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
 		ptp_txqs = profile->max_tc;
 
+	if (mlx5_qos_is_supported(mdev))
+		qos_sqs = mlx5e_qos_max_leaf_nodes(mdev);
+
 	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
-				    nch * profile->max_tc + ptp_txqs,
+				    nch * profile->max_tc + ptp_txqs + qos_sqs,
 				    nch * profile->rq_groups);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 2cf2042b37c7..92c5b81427b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -420,6 +420,25 @@ static void mlx5e_stats_grp_sw_update_stats_ptp(struct mlx5e_priv *priv,
 	}
 }
 
+static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
+						struct mlx5e_sw_stats *s)
+{
+	struct mlx5e_sq_stats **stats;
+	u16 max_qos_sqs;
+	int i;
+
+	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
+	max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
+	stats = READ_ONCE(priv->htb.qos_sq_stats);
+
+	for (i = 0; i < max_qos_sqs; i++) {
+		mlx5e_stats_grp_sw_update_stats_sq(s, READ_ONCE(stats[i]));
+
+		/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
+		barrier();
+	}
+}
+
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s = &priv->stats.sw;
@@ -449,6 +468,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		}
 	}
 	mlx5e_stats_grp_sw_update_stats_ptp(priv, s);
+	mlx5e_stats_grp_sw_update_stats_qos(priv, s);
 }
 
 static const struct counter_desc q_stats_desc[] = {
@@ -1740,6 +1760,41 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 };
 
+static const struct counter_desc qos_sq_stats_desc[] = {
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tso_packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tso_bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tso_inner_packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tso_inner_bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, csum_partial) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, nop) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, mpwqe_blks) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, mpwqe_pkts) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_resync_bytes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sync_data) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
+#endif
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, csum_none) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, stopped) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, dropped) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, xmit_more) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, recover) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, cqes) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, wake) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, cqe_err) },
+};
+
 #define NUM_RQ_STATS			ARRAY_SIZE(rq_stats_desc)
 #define NUM_SQ_STATS			ARRAY_SIZE(sq_stats_desc)
 #define NUM_XDPSQ_STATS			ARRAY_SIZE(xdpsq_stats_desc)
@@ -1750,6 +1805,49 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 #define NUM_PTP_SQ_STATS		ARRAY_SIZE(ptp_sq_stats_desc)
 #define NUM_PTP_CH_STATS		ARRAY_SIZE(ptp_ch_stats_desc)
 #define NUM_PTP_CQ_STATS		ARRAY_SIZE(ptp_cq_stats_desc)
+#define NUM_QOS_SQ_STATS		ARRAY_SIZE(qos_sq_stats_desc)
+
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(qos)
+{
+	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
+	return NUM_QOS_SQ_STATS * smp_load_acquire(&priv->htb.max_qos_sqs);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(qos)
+{
+	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
+	u16 max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
+	int i, qid;
+
+	for (qid = 0; qid < max_qos_sqs; qid++)
+		for (i = 0; i < NUM_QOS_SQ_STATS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				qos_sq_stats_desc[i].format, qid);
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(qos)
+{
+	struct mlx5e_sq_stats **stats;
+	u16 max_qos_sqs;
+	int i, qid;
+
+	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
+	max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
+	stats = READ_ONCE(priv->htb.qos_sq_stats);
+
+	for (qid = 0; qid < max_qos_sqs; qid++) {
+		struct mlx5e_sq_stats *s = READ_ONCE(stats[qid]);
+
+		for (i = 0; i < NUM_QOS_SQ_STATS; i++)
+			data[idx++] = MLX5E_READ_CTR64_CPU(s, qos_sq_stats_desc, i);
+	}
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(qos) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ptp)
 {
@@ -1932,6 +2030,7 @@ MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
 static MLX5E_DEFINE_STATS_GRP(ptp, 0);
+static MLX5E_DEFINE_STATS_GRP(qos, 0);
 
 /* The stats groups order is opposite to the update_stats() order calls */
 mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
@@ -1955,6 +2054,7 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
 	&MLX5E_STATS_GRP(ptp),
+	&MLX5E_STATS_GRP(qos),
 };
 
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index e41fc11f2ce7..93c41312fb03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -55,6 +55,8 @@
 #define MLX5E_DECLARE_PTP_CH_STAT(type, fld) "ptp_ch_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_PTP_CQ_STAT(type, fld) "ptp_cq%d_"#fld, offsetof(type, fld)
 
+#define MLX5E_DECLARE_QOS_TX_STAT(type, fld) "qos_tx%d_"#fld, offsetof(type, fld)
+
 struct counter_desc {
 	char		format[ETH_GSTRING_LEN];
 	size_t		offset; /* Byte offset */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 74f233eece54..da6a358a8a10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -106,28 +106,53 @@ static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
 	return priv->port_ptp_tc2realtxq[up];
 }
 
+static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
+				  u16 htb_maj_id)
+{
+	u16 classid;
+
+	if ((TC_H_MAJ(skb->priority) >> 16) == htb_maj_id)
+		classid = TC_H_MIN(skb->priority);
+	else
+		classid = READ_ONCE(priv->htb.defcls);
+
+	if (!classid)
+		return 0;
+
+	return mlx5e_get_txq_by_classid(priv, classid);
+}
+
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	int num_tc_x_num_ch;
 	int txq_ix;
 	int up = 0;
 	int ch_ix;
 
-	if (unlikely(priv->channels.port_ptp)) {
-		int num_tc_x_num_ch;
+	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
+	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
+	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
+		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
+		u16 htb_maj_id = smp_load_acquire(&priv->htb.maj_id);
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-		    mlx5e_use_ptpsq(skb))
-			return mlx5e_select_ptpsq(dev, skb);
+		if (unlikely(htb_maj_id)) {
+			txq_ix = mlx5e_select_htb_queue(priv, skb, htb_maj_id);
+			if (txq_ix > 0)
+				return txq_ix;
+		}
 
-		/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
-		num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
+		if (unlikely(priv->channels.port_ptp))
+			if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+			    mlx5e_use_ptpsq(skb))
+				return mlx5e_select_ptpsq(dev, skb);
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
-		/* Fix netdev_pick_tx() not to choose ptp_channel txqs.
+		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
 		 * If they are selected, switch to regular queues.
-		 * Driver to select these queues only at mlx5e_select_ptpsq().
+		 * Driver to select these queues only at mlx5e_select_ptpsq()
+		 * and mlx5e_select_htb_queue().
 		 */
 		if (unlikely(txq_ix >= num_tc_x_num_ch))
 			txq_ix %= num_tc_x_num_ch;
@@ -702,6 +727,10 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 pi;
 
 	sq = priv->txq2sq[skb_get_queue_mapping(skb)];
+	if (unlikely(!sq)) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
 
 	/* May send SKBs and WQEs. */
 	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index a3cfe06d5116..d54da3797c30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -115,17 +115,21 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 					       napi);
 	struct mlx5e_ch_stats *ch_stats = c->stats;
 	struct mlx5e_xdpsq *xsksq = &c->xsksq;
+	struct mlx5e_txqsq __rcu **qos_sqs;
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
 	int work_done = 0;
+	u16 qos_sqs_size;
 	bool xsk_open;
 	int i;
 
 	rcu_read_lock();
 
+	qos_sqs = rcu_dereference(c->qos_sqs);
+
 	xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 
 	ch_stats->poll++;
@@ -133,6 +137,18 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	for (i = 0; i < c->num_tc; i++)
 		busy |= mlx5e_poll_tx_cq(&c->sq[i].cq, budget);
 
+	if (unlikely(qos_sqs)) {
+		smp_rmb(); /* Pairs with mlx5e_qos_alloc_queues. */
+		qos_sqs_size = READ_ONCE(c->qos_sqs_size);
+
+		for (i = 0; i < qos_sqs_size; i++) {
+			struct mlx5e_txqsq *sq = rcu_dereference(qos_sqs[i]);
+
+			if (sq)
+				busy |= mlx5e_poll_tx_cq(&sq->cq, budget);
+		}
+	}
+
 	busy |= mlx5e_poll_xdpsq_cq(&c->xdpsq.cq);
 
 	if (c->xdp)
@@ -186,6 +202,16 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		mlx5e_handle_tx_dim(&c->sq[i]);
 		mlx5e_cq_arm(&c->sq[i].cq);
 	}
+	if (unlikely(qos_sqs)) {
+		for (i = 0; i < qos_sqs_size; i++) {
+			struct mlx5e_txqsq *sq = rcu_dereference(qos_sqs[i]);
+
+			if (sq) {
+				mlx5e_handle_tx_dim(sq);
+				mlx5e_cq_arm(&sq->cq);
+			}
+		}
+	}
 
 	mlx5e_handle_rx_dim(rq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
new file mode 100644
index 000000000000..0777be24a307
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include "qos.h"
+
+#define MLX5_QOS_DEFAULT_DWRR_UID 0
+
+bool mlx5_qos_is_supported(struct mlx5_core_dev *mdev)
+{
+	if (!MLX5_CAP_GEN(mdev, qos))
+		return false;
+	if (!MLX5_CAP_QOS(mdev, nic_sq_scheduling))
+		return false;
+	if (!MLX5_CAP_QOS(mdev, nic_bw_share))
+		return false;
+	if (!MLX5_CAP_QOS(mdev, nic_rate_limit))
+		return false;
+	return true;
+}
+
+int mlx5_qos_max_leaf_nodes(struct mlx5_core_dev *mdev)
+{
+	return 1 << MLX5_CAP_QOS(mdev, log_max_qos_nic_queue_group);
+}
+
+int mlx5_qos_create_leaf_node(struct mlx5_core_dev *mdev, u32 parent_id,
+			      u32 bw_share, u32 max_avg_bw, u32 *id)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
+
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_QUEUE_GROUP);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_avg_bw);
+
+	return mlx5_create_scheduling_element_cmd(mdev, SCHEDULING_HIERARCHY_NIC,
+						  sched_ctx, id);
+}
+
+int mlx5_qos_create_inner_node(struct mlx5_core_dev *mdev, u32 parent_id,
+			       u32 bw_share, u32 max_avg_bw, u32 *id)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
+	void *attr;
+
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_avg_bw);
+
+	attr = MLX5_ADDR_OF(scheduling_context, sched_ctx, element_attributes);
+	MLX5_SET(tsar_element, attr, tsar_type, TSAR_ELEMENT_TSAR_TYPE_DWRR);
+
+	return mlx5_create_scheduling_element_cmd(mdev, SCHEDULING_HIERARCHY_NIC,
+						  sched_ctx, id);
+}
+
+int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id)
+{
+	return mlx5_qos_create_inner_node(mdev, MLX5_QOS_DEFAULT_DWRR_UID, 0, 0, id);
+}
+
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id,
+			 u32 bw_share, u32 max_avg_bw, u32 id)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
+	u32 bitmask = 0;
+
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_avg_bw);
+
+	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_BW_SHARE;
+	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
+
+	return mlx5_modify_scheduling_element_cmd(mdev, SCHEDULING_HIERARCHY_NIC,
+						  sched_ctx, id, bitmask);
+}
+
+int mlx5_qos_destroy_node(struct mlx5_core_dev *mdev, u32 id)
+{
+	return mlx5_destroy_scheduling_element_cmd(mdev, SCHEDULING_HIERARCHY_NIC, id);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
new file mode 100644
index 000000000000..125e4e47e6f7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_QOS_H
+#define __MLX5_QOS_H
+
+#include "mlx5_core.h"
+
+#define MLX5_DEBUG_QOS_MASK BIT(4)
+
+#define qos_err(mdev, fmt, ...) \
+	mlx5_core_err(mdev, "QoS: " fmt, ##__VA_ARGS__)
+#define qos_warn(mdev, fmt, ...) \
+	mlx5_core_warn(mdev, "QoS: " fmt, ##__VA_ARGS__)
+#define qos_dbg(mdev, fmt, ...) \
+	mlx5_core_dbg_mask(mdev, MLX5_DEBUG_QOS_MASK, "QoS: " fmt, ##__VA_ARGS__)
+
+bool mlx5_qos_is_supported(struct mlx5_core_dev *mdev);
+int mlx5_qos_max_leaf_nodes(struct mlx5_core_dev *mdev);
+
+int mlx5_qos_create_leaf_node(struct mlx5_core_dev *mdev, u32 parent_id,
+			      u32 bw_share, u32 max_avg_bw, u32 *id);
+int mlx5_qos_create_inner_node(struct mlx5_core_dev *mdev, u32 parent_id,
+			       u32 bw_share, u32 max_avg_bw, u32 *id);
+int mlx5_qos_create_root_node(struct mlx5_core_dev *mdev, u32 *id);
+int mlx5_qos_update_node(struct mlx5_core_dev *mdev, u32 parent_id, u32 bw_share,
+			 u32 max_avg_bw, u32 id);
+int mlx5_qos_destroy_node(struct mlx5_core_dev *mdev, u32 id);
+
+#endif
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 823411e288c0..71ae6aac3410 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -842,11 +842,16 @@ struct mlx5_ifc_qos_cap_bits {
 	u8         reserved_at_4[0x1];
 	u8         packet_pacing_burst_bound[0x1];
 	u8         packet_pacing_typical_size[0x1];
-	u8         reserved_at_7[0x4];
+	u8         reserved_at_7[0x1];
+	u8         nic_sq_scheduling[0x1];
+	u8         nic_bw_share[0x1];
+	u8         nic_rate_limit[0x1];
 	u8         packet_pacing_uid[0x1];
 	u8         reserved_at_c[0x14];
 
-	u8         reserved_at_20[0x20];
+	u8         reserved_at_20[0xb];
+	u8         log_max_qos_nic_queue_group[0x5];
+	u8         reserved_at_30[0x10];
 
 	u8         packet_pacing_max_rate[0x20];
 
@@ -3347,7 +3352,7 @@ struct mlx5_ifc_sqc_bits {
 	u8         reserved_at_e0[0x10];
 	u8         packet_pacing_rate_limit_index[0x10];
 	u8         tis_lst_sz[0x10];
-	u8         reserved_at_110[0x10];
+	u8         qos_queue_group_id[0x10];
 
 	u8         reserved_at_120[0x40];
 
@@ -3362,6 +3367,7 @@ enum {
 	SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT = 0x1,
 	SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC = 0x2,
 	SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC = 0x3,
+	SCHEDULING_CONTEXT_ELEMENT_TYPE_QUEUE_GROUP = 0x4,
 };
 
 enum {
@@ -4805,6 +4811,7 @@ struct mlx5_ifc_query_scheduling_element_out_bits {
 
 enum {
 	SCHEDULING_HIERARCHY_E_SWITCH = 0x2,
+	SCHEDULING_HIERARCHY_NIC = 0x3,
 };
 
 struct mlx5_ifc_query_scheduling_element_in_bits {
-- 
2.25.1

