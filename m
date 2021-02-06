Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7279311B52
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhBFFHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhBFFDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:03:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A958164FBA;
        Sat,  6 Feb 2021 05:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587763;
        bh=QgYM5g0T/ROEeOKrC4Y+5bB4/6F6phLPvYC65H6DSPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfpU5OXk1ka7mUChEAVumsAosZFfCdRwzIx9CPOesA0NxBtewtWrxLp5vD4eGKgJ6
         i7UMrE4xqj651tTpN8GCcQD6KRbuyKLGBhHbp9D1hTborcXWi1Ci5IwWihk94iKLYS
         g/ZB61yUoyOLgogFV8w5pseb4yxpjmAR1HhCHAU0CjWeLJJVe80pwTovGYZyYnAQ1Q
         M6iDEm1Vu9G6okP41yEkLBl7nXd/X51z5punggJKh+Cj9514sDp2qefUrZKODDdlkm
         R3Db2FeZmTJfVSuTFqu2ES/4G61hI3ermvkHQTeEqSb2Nzw5hamvbnrQ6G1wB60FgB
         pt/Vmw4QgOyyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/17] net/mlx5e: E-Switch, Maintain vhca_id to vport_num mapping
Date:   Fri,  5 Feb 2021 21:02:25 -0800
Message-Id: <20210206050240.48410-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in the series need to be able to map VF netdev to vport.
Since it is trivial to obtain vhca_id from netdev, maintain mapping from
vhca_id to vport_num inside eswitch offloads using xarray. Provide function
mlx5_eswitch_vhca_id_to_vport() to be used by TC code in following patches
to obtain the mapping.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 20 +++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 79 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 12 +++
 5 files changed, 119 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 820305b1664e..aba17835465b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1300,6 +1300,13 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 	    (!vport_num && mlx5_core_is_ecpf(esw->dev)))
 		vport->info.trusted = true;
 
+	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
+	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
+		ret = mlx5_esw_vport_vhca_id_set(esw, vport_num);
+		if (ret)
+			goto err_vhca_mapping;
+	}
+
 	esw_vport_change_handle_locked(vport);
 
 	esw->enabled_vports++;
@@ -1307,6 +1314,11 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 done:
 	mutex_unlock(&esw->state_lock);
 	return ret;
+
+err_vhca_mapping:
+	esw_vport_cleanup(esw, vport);
+	mutex_unlock(&esw->state_lock);
+	return ret;
 }
 
 void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
@@ -1325,6 +1337,11 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 
 	/* Disable events from this vport */
 	arm_vport_context_events_cmd(esw->dev, vport->vport, 0);
+
+	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
+	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		mlx5_esw_vport_vhca_id_clear(esw, vport_num);
+
 	/* We don't assume VFs will cleanup after themselves.
 	 * Calling vport change handler while vport is disabled will cleanup
 	 * the vport resources.
@@ -1815,6 +1832,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	mlx5e_mod_hdr_tbl_init(&esw->offloads.mod_hdr);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	ida_init(&esw->offloads.vport_metadata_ida);
+	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
 	mutex_init(&esw->state_lock);
 	mutex_init(&esw->mode_lock);
 
@@ -1854,6 +1872,8 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw_offloads_cleanup_reps(esw);
 	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
+	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
+	xa_destroy(&esw->offloads.vhca_map);
 	ida_destroy(&esw->offloads.vport_metadata_ida);
 	mlx5e_mod_hdr_tbl_destroy(&esw->offloads.mod_hdr);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 479d2ac2cd85..1a045e95bc68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -36,6 +36,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_link.h>
 #include <linux/atomic.h>
+#include <linux/xarray.h>
 #include <net/devlink.h>
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/eswitch.h>
@@ -212,6 +213,7 @@ struct mlx5_esw_offload {
 	struct mod_hdr_tbl mod_hdr;
 	DECLARE_HASHTABLE(termtbl_tbl, 8);
 	struct mutex termtbl_mutex; /* protects termtbl hash */
+	struct xarray vhca_map;
 	const struct mlx5_eswitch_rep_ops *rep_ops[NUM_REP_TYPES];
 	u8 inline_mode;
 	atomic64_t num_flows;
@@ -734,6 +736,10 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_p
 				      u16 vport_num, u32 sfnum);
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
 
+int mlx5_esw_vport_vhca_id_set(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_vport_vhca_id_clear(struct mlx5_eswitch *esw, u16 vport_num);
+int mlx5_eswitch_vhca_id_to_vport(struct mlx5_eswitch *esw, u16 vhca_id, u16 *vport_num);
+
 /**
  * mlx5_esw_event_info - Indicates eswitch mode changed/changing.
  *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 416ede2fe5d7..3085bdd14fbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2872,3 +2872,82 @@ void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
 	mlx5_esw_vport_disable(esw, vport_num);
 }
+
+static int mlx5_esw_query_vport_vhca_id(struct mlx5_eswitch *esw, u16 vport_num, u16 *vhca_id)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_ctx;
+	void *hca_caps;
+	int err;
+
+	*vhca_id = 0;
+	if (mlx5_esw_is_manager_vport(esw, vport_num) ||
+	    !MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return -EPERM;
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx);
+	if (err)
+		goto out_free;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	*vhca_id = MLX5_GET(cmd_hca_cap, hca_caps, vhca_id);
+
+out_free:
+	kfree(query_ctx);
+	return err;
+}
+
+int mlx5_esw_vport_vhca_id_set(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	u16 *old_entry, *vhca_map_entry, vhca_id;
+	int err;
+
+	err = mlx5_esw_query_vport_vhca_id(esw, vport_num, &vhca_id);
+	if (err) {
+		esw_warn(esw->dev, "Getting vhca_id for vport failed (vport=%u,err=%d)\n",
+			 vport_num, err);
+		return err;
+	}
+
+	vhca_map_entry = kmalloc(sizeof(*vhca_map_entry), GFP_KERNEL);
+	if (!vhca_map_entry)
+		return -ENOMEM;
+
+	*vhca_map_entry = vport_num;
+	old_entry = xa_store(&esw->offloads.vhca_map, vhca_id, vhca_map_entry, GFP_KERNEL);
+	if (xa_is_err(old_entry)) {
+		kfree(vhca_map_entry);
+		return xa_err(old_entry);
+	}
+	kfree(old_entry);
+	return 0;
+}
+
+void mlx5_esw_vport_vhca_id_clear(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	u16 *vhca_map_entry, vhca_id;
+	int err;
+
+	err = mlx5_esw_query_vport_vhca_id(esw, vport_num, &vhca_id);
+	if (err)
+		esw_warn(esw->dev, "Getting vhca_id for vport failed (vport=%hu,err=%d)\n",
+			 vport_num, err);
+
+	vhca_map_entry = xa_erase(&esw->offloads.vhca_map, vhca_id);
+	kfree(vhca_map_entry);
+}
+
+int mlx5_eswitch_vhca_id_to_vport(struct mlx5_eswitch *esw, u16 vhca_id, u16 *vport_num)
+{
+	u16 *res = xa_load(&esw->offloads.vhca_map, vhca_id);
+
+	if (!res)
+		return -ENOENT;
+
+	*vport_num = *res;
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 3754ef98554f..efe403c7e354 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -270,5 +270,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
+
 void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index ba78e0660523..e05c5c0f3ae1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1164,3 +1164,15 @@ u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_functions(dev);
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
+
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
+{
+	u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
+	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
+	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
+	MLX5_SET(query_hca_cap_in, in, other_function, true);
+	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
+}
-- 
2.29.2

