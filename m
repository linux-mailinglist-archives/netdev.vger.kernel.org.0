Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F315BF3438
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbfKGQJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53502 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389365AbfKGQJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:06 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4F007213;
        Thu, 7 Nov 2019 18:08:58 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 05/19] net/mlx5: E-Switch, Enable/disable SF's vport during SF life cycle
Date:   Thu,  7 Nov 2019 10:08:20 -0600
Message-Id: <20191107160834.21087-5-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Enable/disable SF vport and its representors during SF
allocation/free sequence respectively.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  16 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   7 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 111 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   |   8 ++
 4 files changed, 134 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 87273be44dae..1c763a5c955c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1532,9 +1532,9 @@ static void esw_destroy_tsar(struct mlx5_eswitch *esw)
 	esw->qos.enabled = false;
 }
 
-static int esw_vport_enable_qos(struct mlx5_eswitch *esw,
-				struct mlx5_vport *vport,
-				u32 initial_max_rate, u32 initial_bw_share)
+int mlx5_eswitch_vport_enable_qos(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport,
+				  u32 initial_max_rate, u32 initial_bw_share)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -1573,8 +1573,8 @@ static int esw_vport_enable_qos(struct mlx5_eswitch *esw,
 	return 0;
 }
 
-static void esw_vport_disable_qos(struct mlx5_eswitch *esw,
-				  struct mlx5_vport *vport)
+void mlx5_eswitch_vport_disable_qos(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport)
 {
 	int err;
 
@@ -1795,8 +1795,8 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 		goto done;
 
 	/* Attach vport to the eswitch rate limiter */
-	if (esw_vport_enable_qos(esw, vport, vport->info.max_rate,
-				 vport->qos.bw_share))
+	if (mlx5_eswitch_vport_enable_qos(esw, vport, vport->info.max_rate,
+					  vport->qos.bw_share))
 		esw_warn(esw->dev, "Failed to attach vport %d to eswitch rate limiter", vport_num);
 
 	/* Sync with current vport context */
@@ -1840,7 +1840,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw,
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
-	esw_vport_disable_qos(esw, vport);
+	mlx5_eswitch_vport_disable_qos(esw, vport);
 
 	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
 	    esw->mode == MLX5_ESWITCH_LEGACY)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 21592ef6d05d..6c2ea3bb39cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -298,6 +298,13 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport,
 				 struct ifla_vf_stats *vf_stats);
+int mlx5_eswitch_vport_enable_qos(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport,
+				  u32 initial_max_rate, u32 initial_bw_share);
+void mlx5_eswitch_vport_disable_qos(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport);
+int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_eswitch_cleanup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
 void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule);
 
 int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ff084499d681..a6906bff37a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1624,6 +1624,117 @@ static int esw_offloads_load_all_reps(struct mlx5_eswitch *esw)
 	return err;
 }
 
+static int esw_offloads_load_vport_reps(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_eswitch_rep *rep;
+	u8 rep_type;
+	int err;
+
+	rep = mlx5_eswitch_get_rep(esw, vport_num);
+	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
+		err = __esw_offloads_load_rep(esw, rep, rep_type);
+		if (err) {
+			esw_warn(esw->dev, "Load vport(%d) rep type(%d) err!\n",
+				 vport_num, rep_type);
+			goto err_reps;
+		}
+	}
+
+	return 0;
+
+err_reps:
+	while (rep_type-- > 0)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
+	return err;
+}
+
+static void
+esw_offloads_unload_vport_reps(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_eswitch_rep *rep;
+	u8 rep_type = NUM_REP_TYPES;
+
+	rep = mlx5_eswitch_get_rep(esw, vport_num);
+	while (rep_type-- > 0)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
+}
+
+static int
+esw_enable_sf_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int ret;
+
+	ret = esw_vport_create_offloads_acl_tables(esw, vport);
+	if (ret)
+		return ret;
+
+	mutex_lock(&esw->state_lock);
+
+	mlx5_modify_nic_vport_mac_address(esw->dev, vport->vport, vport->info.mac);
+	mlx5_modify_nic_vport_node_guid(esw->dev, vport->vport,
+					vport->info.node_guid);
+
+	/* Attach vport to the eswitch rate limiter */
+	ret = mlx5_eswitch_vport_enable_qos(esw, vport, vport->info.max_rate,
+					    vport->qos.bw_share);
+	if (ret)
+		goto qos_err;
+
+	vport->enabled = true;
+	esw_debug(esw->dev, "Enabled SF vport(0x%x)\n", vport->vport);
+
+	mutex_unlock(&esw->state_lock);
+	return 0;
+
+qos_err:
+	mutex_unlock(&esw->state_lock);
+	esw_vport_destroy_offloads_acl_tables(esw, vport);
+	return ret;
+}
+
+static void
+esw_disable_sf_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	mutex_lock(&esw->state_lock);
+
+	esw_debug(esw->dev, "Disabling vport(0x%x)\n", vport->vport);
+	vport->enabled = false;
+	mlx5_eswitch_vport_disable_qos(esw, vport);
+
+	mutex_unlock(&esw->state_lock);
+
+	esw_vport_destroy_offloads_acl_tables(esw, vport);
+}
+
+int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+	int ret;
+
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	ret = esw_enable_sf_vport(esw, vport);
+	if (ret)
+		return ret;
+
+	ret = esw_offloads_load_vport_reps(esw, vport_num);
+	if (ret)
+		esw_disable_sf_vport(esw, vport);
+	return ret;
+}
+
+void mlx5_eswitch_cleanup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (IS_ERR(vport))
+		return;
+
+	esw_offloads_unload_vport_reps(esw, vport_num);
+	esw_disable_sf_vport(esw, vport);
+}
+
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
 #define ESW_OFFLOADS_DEVCOM_UNPAIR	(1)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index d57109a9c53b..fb4ba7be0051 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -7,6 +7,7 @@
 #include <linux/bitmap.h>
 #include "sf.h"
 #include "mlx5_core.h"
+#include "eswitch.h"
 
 static int
 mlx5_cmd_query_sf_partitions(struct mlx5_core_dev *mdev, u32 *out, int outlen)
@@ -149,11 +150,17 @@ mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 	if (ret)
 		goto enable_err;
 
+	ret = mlx5_eswitch_setup_sf_vport(coredev->priv.eswitch, hw_function_id);
+	if (ret)
+		goto vport_err;
+
 	sf->idx = sf_id;
 	sf->base_addr = sf_table->base_address +
 				(sf->idx << (sf_table->log_sf_bar_size + 12));
 	return sf;
 
+vport_err:
+	mlx5_core_disable_sf_hca(coredev, hw_function_id);
 enable_err:
 	mlx5_cmd_dealloc_sf(coredev, hw_function_id);
 alloc_sf_err:
@@ -169,6 +176,7 @@ void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 	u16 hw_function_id;
 
 	hw_function_id = mlx5_sf_hw_id(coredev, sf->idx);
+	mlx5_eswitch_cleanup_sf_vport(coredev->priv.eswitch, hw_function_id);
 	mlx5_core_disable_sf_hca(coredev, hw_function_id);
 	mlx5_cmd_dealloc_sf(coredev, hw_function_id);
 	free_sf_id(sf_table, sf->idx);
-- 
2.19.2

