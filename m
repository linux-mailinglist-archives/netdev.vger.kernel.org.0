Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEA34B6392
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiBOGdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiBOGcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165E0B152F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B2A6151D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D4C340F2;
        Tue, 15 Feb 2022 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906760;
        bh=K+soSve/jk6Zxaia/UGlD9tboftKPAntwd31h+pIHE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYECIeW4KaDK4vVlLdgLpFYSXEaJWAoVjkV+UIA4aR98e0Or6Zk0jYWRPf+bM0ONQ
         ca53efkqRdgrWcX7cOJVidzlGOYgIqGXjD4nalcuYHn1D136uj7AGf1rMBiiXGlL3K
         +tN6o0lDyggeCOPgVCPZpN4SuBAIrnpwmxGcTXOsZQ68LitDmnf0PlEP7nCC3Uk0Tt
         eGLIdL+jY1s+flyAL4ofp4MwuH5DjXuz4yKIgVJAFq1gQEBnUQu5kpxbQIbGNiDu6Y
         Uncwy5H9qL6ojVKK4iH3ngyds+vsKO2omhFKBLhYKr/+utHEm9tQHE7r+4MAyosWP2
         9YjTYYPrvSe0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Introduce select queue parameters
Date:   Mon, 14 Feb 2022 22:32:22 -0800
Message-Id: <20220215063229.737960-9-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

ndo_select_queue can be called at any time, and there is no way to stop
the kernel from calling it to synchronize with configuration changes
(real_num_tx_queues, num_tc). This commit introduces an internal way in
mlx5e to sync mlx5e_select_queue() with these changes. The configuration
needed by this function is stored in a struct mlx5e_selq_params, which
is modified and accessed in an atomic way using RCU methods. The whole
ndo_select_queue is called under an RCU lock, providing the necessary
guarantees.

The parameters stored in the new struct mlx5e_selq_params should only be
used from inside mlx5e_select_queue. It's the minimal set of parameters
needed for mlx5e_select_queue to do its job efficiently, derived from
parameters stored elsewhere. That means that when the configuration
change, mlx5e_selq_params may need to be updated. In such cases, the
mlx5e_selq_prepare/mlx5e_selq_apply API should be used.

struct mlx5e_selq contains two slots for the params: active and standby.
mlx5e_selq_prepare updates the standby slot, and mlx5e_selq_apply swaps
the slots in a safe atomic way using the RCU API. It integrates well
with the open/activate stages of the configuration change flow.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 12 ++-
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 95 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/selq.h | 26 +++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 33 ++++++-
 6 files changed, 165 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index fcfd38fa9e6c..a7170ab3af97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -28,7 +28,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en/rqt.o en/tir.o en/rss.o en/rx_res.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o en/fs_tt_redirect.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o en/selq.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 99529e238fc4..e1c2f296867a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -59,6 +59,7 @@
 #include "lib/hv_vhca.h"
 #include "lib/clock.h"
 #include "en/rx_res.h"
+#include "en/selq.h"
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
@@ -908,6 +909,7 @@ struct mlx5e_trap;
 
 struct mlx5e_priv {
 	/* priv data path fields - start */
+	struct mlx5e_selq selq;
 	struct mlx5e_txqsq **txq2sq;
 	int **channel_tc2realtxq;
 	int port_ptp_tc2realtxq[MLX5E_MAX_NUM_TC];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index ff45840581e3..ccfc8ae2fa71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -501,9 +501,11 @@ int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 	if (opened) {
+		mlx5e_selq_prepare(&priv->selq, &priv->channels.params, true);
+
 		err = mlx5e_qos_alloc_queues(priv, &priv->channels);
 		if (err)
-			return err;
+			goto err_cancel_selq;
 	}
 
 	root = mlx5e_sw_node_create_root(priv);
@@ -524,6 +526,9 @@ int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 	 */
 	smp_store_release(&priv->htb.maj_id, htb_maj_id);
 
+	if (opened)
+		mlx5e_selq_apply(&priv->selq);
+
 	return 0;
 
 err_sw_node_delete:
@@ -532,6 +537,8 @@ int mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 err_free_queues:
 	if (opened)
 		mlx5e_qos_close_all_queues(&priv->channels);
+err_cancel_selq:
+	mlx5e_selq_cancel(&priv->selq);
 	return err;
 }
 
@@ -542,6 +549,9 @@ int mlx5e_htb_root_del(struct mlx5e_priv *priv)
 
 	qos_dbg(priv->mdev, "TC_HTB_DESTROY\n");
 
+	mlx5e_selq_prepare(&priv->selq, &priv->channels.params, false);
+	mlx5e_selq_apply(&priv->selq);
+
 	WRITE_ONCE(priv->htb.maj_id, 0);
 	synchronize_rcu(); /* Sync with mlx5e_select_htb_queue and TX data path. */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
new file mode 100644
index 000000000000..50ea58a3cc94
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "selq.h"
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include "en.h"
+
+struct mlx5e_selq_params {
+	unsigned int num_regular_queues;
+	unsigned int num_channels;
+	unsigned int num_tcs;
+	bool is_htb;
+	bool is_ptp;
+};
+
+int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock)
+{
+	struct mlx5e_selq_params *init_params;
+
+	selq->state_lock = state_lock;
+
+	selq->standby = kvzalloc(sizeof(*selq->standby), GFP_KERNEL);
+	if (!selq->standby)
+		return -ENOMEM;
+
+	init_params = kvzalloc(sizeof(*selq->active), GFP_KERNEL);
+	if (!init_params) {
+		kvfree(selq->standby);
+		selq->standby = NULL;
+		return -ENOMEM;
+	}
+	/* Assign dummy values, so that mlx5e_select_queue won't crash. */
+	*init_params = (struct mlx5e_selq_params) {
+		.num_regular_queues = 1,
+		.num_channels = 1,
+		.num_tcs = 1,
+		.is_htb = false,
+		.is_ptp = false,
+	};
+	rcu_assign_pointer(selq->active, init_params);
+
+	return 0;
+}
+
+void mlx5e_selq_cleanup(struct mlx5e_selq *selq)
+{
+	WARN_ON_ONCE(selq->is_prepared);
+
+	kvfree(selq->standby);
+	selq->standby = NULL;
+	selq->is_prepared = true;
+
+	mlx5e_selq_apply(selq);
+
+	kvfree(selq->standby);
+	selq->standby = NULL;
+}
+
+void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bool htb)
+{
+	lockdep_assert_held(selq->state_lock);
+	WARN_ON_ONCE(selq->is_prepared);
+
+	selq->is_prepared = true;
+
+	selq->standby->num_channels = params->num_channels;
+	selq->standby->num_tcs = mlx5e_get_dcb_num_tc(params);
+	selq->standby->num_regular_queues =
+		selq->standby->num_channels * selq->standby->num_tcs;
+	selq->standby->is_htb = htb;
+	selq->standby->is_ptp = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_TX_PORT_TS);
+}
+
+void mlx5e_selq_apply(struct mlx5e_selq *selq)
+{
+	struct mlx5e_selq_params *old_params;
+
+	WARN_ON_ONCE(!selq->is_prepared);
+
+	selq->is_prepared = false;
+
+	old_params = rcu_replace_pointer(selq->active, selq->standby,
+					 lockdep_is_held(selq->state_lock));
+	synchronize_net(); /* Wait until ndo_select_queue starts emitting correct values. */
+	selq->standby = old_params;
+}
+
+void mlx5e_selq_cancel(struct mlx5e_selq *selq)
+{
+	lockdep_assert_held(selq->state_lock);
+	WARN_ON_ONCE(!selq->is_prepared);
+
+	selq->is_prepared = false;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
new file mode 100644
index 000000000000..2648c23e8238
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_SELQ_H__
+#define __MLX5_EN_SELQ_H__
+
+#include <linux/kernel.h>
+
+struct mlx5e_selq_params;
+
+struct mlx5e_selq {
+	struct mlx5e_selq_params __rcu *active;
+	struct mlx5e_selq_params *standby;
+	struct mutex *state_lock; /* points to priv->state_lock */
+	bool is_prepared;
+};
+
+struct mlx5e_params;
+
+int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock);
+void mlx5e_selq_cleanup(struct mlx5e_selq *selq);
+void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bool htb);
+void mlx5e_selq_apply(struct mlx5e_selq *selq);
+void mlx5e_selq_cancel(struct mlx5e_selq *selq);
+
+#endif /* __MLX5_EN_SELQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e64c3cb15ef6..02f0ad653ece 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2813,6 +2813,7 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	mlx5e_close_channels(&old_chs);
 	priv->profile->update_rx(priv);
 
+	mlx5e_selq_apply(&priv->selq);
 out:
 	mlx5e_activate_priv_channels(priv);
 
@@ -2836,13 +2837,24 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 		return mlx5e_switch_priv_params(priv, params, preactivate, context);
 
 	new_chs.params = *params;
+
+	mlx5e_selq_prepare(&priv->selq, &new_chs.params, !!priv->htb.maj_id);
+
 	err = mlx5e_open_channels(priv, &new_chs);
 	if (err)
-		return err;
+		goto err_cancel_selq;
+
 	err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
 	if (err)
-		mlx5e_close_channels(&new_chs);
+		goto err_close;
 
+	return 0;
+
+err_close:
+	mlx5e_close_channels(&new_chs);
+
+err_cancel_selq:
+	mlx5e_selq_cancel(&priv->selq);
 	return err;
 }
 
@@ -2882,6 +2894,8 @@ int mlx5e_open_locked(struct net_device *netdev)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
+	mlx5e_selq_prepare(&priv->selq, &priv->channels.params, !!priv->htb.maj_id);
+
 	set_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	err = mlx5e_open_channels(priv, &priv->channels);
@@ -2889,6 +2903,7 @@ int mlx5e_open_locked(struct net_device *netdev)
 		goto err_clear_state_opened_flag;
 
 	priv->profile->update_rx(priv);
+	mlx5e_selq_apply(&priv->selq);
 	mlx5e_activate_priv_channels(priv);
 	mlx5e_apply_traps(priv, true);
 	if (priv->profile->update_carrier)
@@ -2899,6 +2914,7 @@ int mlx5e_open_locked(struct net_device *netdev)
 
 err_clear_state_opened_flag:
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
+	mlx5e_selq_cancel(&priv->selq);
 	return err;
 }
 
@@ -5215,6 +5231,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    struct mlx5_core_dev *mdev)
 {
 	int nch, num_txqs, node, i;
+	int err;
 
 	num_txqs = netdev->num_tx_queues;
 	nch = mlx5e_calc_max_nch(mdev, netdev, profile);
@@ -5231,6 +5248,11 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 		return -ENOMEM;
 
 	mutex_init(&priv->state_lock);
+
+	err = mlx5e_selq_init(&priv->selq, &priv->state_lock);
+	if (err)
+		goto err_free_cpumask;
+
 	hash_init(priv->htb.qos_tc2node);
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
@@ -5239,7 +5261,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 
 	priv->wq = create_singlethread_workqueue("mlx5e");
 	if (!priv->wq)
-		goto err_free_cpumask;
+		goto err_free_selq;
 
 	priv->txq2sq = kcalloc_node(num_txqs, sizeof(*priv->txq2sq), GFP_KERNEL, node);
 	if (!priv->txq2sq)
@@ -5279,6 +5301,8 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	kfree(priv->txq2sq);
 err_destroy_workqueue:
 	destroy_workqueue(priv->wq);
+err_free_selq:
+	mlx5e_selq_cleanup(&priv->selq);
 err_free_cpumask:
 	free_cpumask_var(priv->scratchpad.cpumask);
 	return -ENOMEM;
@@ -5301,6 +5325,9 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	kfree(priv->tx_rates);
 	kfree(priv->txq2sq);
 	destroy_workqueue(priv->wq);
+	mutex_lock(&priv->state_lock);
+	mlx5e_selq_cleanup(&priv->selq);
+	mutex_unlock(&priv->state_lock);
 	free_cpumask_var(priv->scratchpad.cpumask);
 
 	for (i = 0; i < priv->htb.max_qos_sqs; i++)
-- 
2.34.1

