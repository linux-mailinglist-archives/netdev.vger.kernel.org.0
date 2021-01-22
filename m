Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AD230108B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbhAVXAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730850AbhAVTk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:40:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7808823B1C;
        Fri, 22 Jan 2021 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344234;
        bh=A7KEFmxN3DVmc8kkZcblDlmaJu5jjoRnmTnpEgGbV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neKHU+ETHevgBgzCqwfbtPaIZuRKJO5ybXfvd4xoqdPjMpHktUUMCuYMw4sstg7m+
         y/cELY157ucLayvHnZUA3K4X1TqA0wWBxh7klcJ1rXSkM7ZRQerivsVwnLKzV8L+UF
         roQdUPgmfUK7i5umZeo5NE2TpDLC6W+Kh/vZivyvgqOk2Wjg74nEwbRhdMeLKxYno7
         hlengNG5YZrbppxQyIcZ7L27KA6IxzS25jT1wdTdYh/0fjzNZ16ulDG+xtRcKp+9gN
         kyZY5BZ/D464tqGfv/o92AIqQvb2YuOKNu3He0YdquqxSTFQ1oUwr6KQQAz60em0/z
         tpnYj+7sl0Esw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V10 11/14] net/mlx5: SF, Port function state change support
Date:   Fri, 22 Jan 2021 11:36:55 -0800
Message-Id: <20210122193658.282884-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Support changing the state of the SF port's function through devlink.
When activating the SF port's function, enable the hca in the device
followed by adding its auxiliary device.
When deactivating the SF port's function, delete its auxiliary device
followed by disabling the vHCA.

Port function attributes get/set callbacks are invoked with devlink
instance lock held. Such callbacks need to synchronize with sf port
table getting disabled either via sriov sysfs callback. Such callbacks
synchronize with table disable context holding table refcount.

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port show ens2f0npf0sf88
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88 state active

$ devlink port show ens2f0npf0sf88 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "ens2f0npf0sf88",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 88,
            "external": false,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:88:88",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

On port function activation, an auxiliary device is created in below
example.

$ devlink dev show
devlink dev show auxiliary/mlx5_core.sf.4

$ devlink port show auxiliary/mlx5_core.sf.4/1
auxiliary/mlx5_core.sf.4/1: type eth netdev p0sf88 flavour virtual port 0 splittable false

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  10 +
 .../net/ethernet/mellanox/mlx5/core/sf/cmd.c  |  22 ++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 284 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 116 ++++++-
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |   4 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  20 +-
 7 files changed, 431 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d4c0cdf5edd9..7712311e8684 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -195,6 +195,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
 	.port_del = mlx5_devlink_sf_port_del,
+	.port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
+	.port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d6bd09dd7490..604ac8bdebe0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -75,6 +75,7 @@
 #include "diag/rsc_dump.h"
 #include "sf/vhca_event.h"
 #include "sf/dev/dev.h"
+#include "sf/sf.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
@@ -1161,6 +1162,12 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	mlx5_vhca_event_start(dev);
 
+	err = mlx5_sf_hw_table_create(dev);
+	if (err) {
+		mlx5_core_err(dev, "sf table create failed %d\n", err);
+		goto err_vhca;
+	}
+
 	err = mlx5_ec_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to init embedded CPU\n");
@@ -1180,6 +1187,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_sriov:
 	mlx5_ec_cleanup(dev);
 err_ec:
+	mlx5_sf_hw_table_destroy(dev);
+err_vhca:
 	mlx5_vhca_event_stop(dev);
 	mlx5_cleanup_fs(dev);
 err_fs:
@@ -1209,6 +1218,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_ec_cleanup(dev);
+	mlx5_sf_hw_table_destroy(dev);
 	mlx5_vhca_event_stop(dev);
 	mlx5_cleanup_fs(dev);
 	mlx5_accel_ipsec_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
index 0bc3075f34fa..a8d75c2f0275 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
@@ -25,3 +25,25 @@ int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id)
 
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
+{
+	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] = {};
+
+	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
+	MLX5_SET(enable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+}
+
+int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
+{
+	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] = {};
+
+	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
+	MLX5_SET(disable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 7ad0d210ec30..c2ba41bb7a70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -4,11 +4,17 @@
 #include <linux/mlx5/driver.h>
 #include "eswitch.h"
 #include "priv.h"
+#include "sf/dev/dev.h"
+#include "mlx5_ifc_vhca_event.h"
+#include "vhca_event.h"
+#include "ecpf.h"
 
 struct mlx5_sf {
 	struct devlink_port dl_port;
 	unsigned int port_index;
 	u16 id;
+	u16 hw_fn_id;
+	u16 hw_state;
 };
 
 struct mlx5_sf_table {
@@ -16,7 +22,10 @@ struct mlx5_sf_table {
 	struct xarray port_indices; /* port index based lookup. */
 	refcount_t refcount;
 	struct completion disable_complete;
+	struct mutex sf_state_lock; /* Serializes sf state among user cmds & vhca event handler. */
 	struct notifier_block esw_nb;
+	struct notifier_block vhca_nb;
+	u8 ecpu: 1;
 };
 
 static struct mlx5_sf *
@@ -25,6 +34,19 @@ mlx5_sf_lookup_by_index(struct mlx5_sf_table *table, unsigned int port_index)
 	return xa_load(&table->port_indices, port_index);
 }
 
+static struct mlx5_sf *
+mlx5_sf_lookup_by_function_id(struct mlx5_sf_table *table, unsigned int fn_id)
+{
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	xa_for_each(&table->port_indices, index, sf) {
+		if (sf->hw_fn_id == fn_id)
+			return sf;
+	}
+	return NULL;
+}
+
 static int mlx5_sf_id_insert(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
 	return xa_insert(&table->port_indices, sf->port_index, sf, GFP_KERNEL);
@@ -59,6 +81,8 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *ex
 	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sf->id);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(table->dev, hw_fn_id);
 	sf->port_index = dl_port_index;
+	sf->hw_fn_id = hw_fn_id;
+	sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;
 
 	err = mlx5_sf_id_insert(table, sf);
 	if (err)
@@ -99,6 +123,146 @@ static void mlx5_sf_table_put(struct mlx5_sf_table *table)
 		complete(&table->disable_complete);
 }
 
+static enum devlink_port_fn_state mlx5_sf_to_devlink_state(u8 hw_state)
+{
+	switch (hw_state) {
+	case MLX5_VHCA_STATE_ACTIVE:
+	case MLX5_VHCA_STATE_IN_USE:
+	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
+		return DEVLINK_PORT_FN_STATE_ACTIVE;
+	case MLX5_VHCA_STATE_INVALID:
+	case MLX5_VHCA_STATE_ALLOCATED:
+	default:
+		return DEVLINK_PORT_FN_STATE_INACTIVE;
+	}
+}
+
+static enum devlink_port_fn_opstate mlx5_sf_to_devlink_opstate(u8 hw_state)
+{
+	switch (hw_state) {
+	case MLX5_VHCA_STATE_IN_USE:
+	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
+		return DEVLINK_PORT_FN_OPSTATE_ATTACHED;
+	case MLX5_VHCA_STATE_INVALID:
+	case MLX5_VHCA_STATE_ALLOCATED:
+	case MLX5_VHCA_STATE_ACTIVE:
+	default:
+		return DEVLINK_PORT_FN_OPSTATE_DETACHED;
+	}
+}
+
+static bool mlx5_sf_is_active(const struct mlx5_sf *sf)
+{
+	return sf->hw_state == MLX5_VHCA_STATE_ACTIVE || sf->hw_state == MLX5_VHCA_STATE_IN_USE;
+}
+
+int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devlink_port *dl_port,
+				      enum devlink_port_fn_state *state,
+				      enum devlink_port_fn_opstate *opstate,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	struct mlx5_sf *sf;
+	int err = 0;
+
+	table = mlx5_sf_table_try_get(dev);
+	if (!table)
+		return -EOPNOTSUPP;
+
+	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
+	if (!sf) {
+		err = -EOPNOTSUPP;
+		goto sf_err;
+	}
+	mutex_lock(&table->sf_state_lock);
+	*state = mlx5_sf_to_devlink_state(sf->hw_state);
+	*opstate = mlx5_sf_to_devlink_opstate(sf->hw_state);
+	mutex_unlock(&table->sf_state_lock);
+sf_err:
+	mlx5_sf_table_put(table);
+	return err;
+}
+
+static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
+{
+	int err;
+
+	if (mlx5_sf_is_active(sf))
+		return 0;
+	if (sf->hw_state != MLX5_VHCA_STATE_ALLOCATED)
+		return -EINVAL;
+
+	err = mlx5_cmd_sf_enable_hca(dev, sf->hw_fn_id);
+	if (err)
+		return err;
+
+	sf->hw_state = MLX5_VHCA_STATE_ACTIVE;
+	return 0;
+}
+
+static int mlx5_sf_deactivate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
+{
+	int err;
+
+	if (!mlx5_sf_is_active(sf))
+		return 0;
+
+	err = mlx5_cmd_sf_disable_hca(dev, sf->hw_fn_id);
+	if (err)
+		return err;
+
+	sf->hw_state = MLX5_VHCA_STATE_TEARDOWN_REQUEST;
+	return 0;
+}
+
+static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
+			     struct mlx5_sf *sf,
+			     enum devlink_port_fn_state state)
+{
+	int err = 0;
+
+	mutex_lock(&table->sf_state_lock);
+	if (state == mlx5_sf_to_devlink_state(sf->hw_state))
+		goto out;
+	if (state == DEVLINK_PORT_FN_STATE_ACTIVE)
+		err = mlx5_sf_activate(dev, sf);
+	else if (state == DEVLINK_PORT_FN_STATE_INACTIVE)
+		err = mlx5_sf_deactivate(dev, sf);
+	else
+		err = -EINVAL;
+out:
+	mutex_unlock(&table->sf_state_lock);
+	return err;
+}
+
+int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_port *dl_port,
+				      enum devlink_port_fn_state state,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	struct mlx5_sf *sf;
+	int err;
+
+	table = mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port state set is only supported in eswitch switchdev mode or SF ports are disabled.");
+		return -EOPNOTSUPP;
+	}
+	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
+	if (!sf) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = mlx5_sf_state_set(dev, table, sf, state);
+out:
+	mlx5_sf_table_put(table);
+	return err;
+}
+
 static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 		       const struct devlink_port_new_attrs *new_attr,
 		       struct netlink_ext_ack *extack,
@@ -125,16 +289,6 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	return err;
 }
 
-static void mlx5_sf_del(struct mlx5_core_dev *dev, struct mlx5_sf_table *table, struct mlx5_sf *sf)
-{
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
-	u16 hw_fn_id;
-
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sf->id);
-	mlx5_esw_offloads_sf_vport_disable(esw, hw_fn_id);
-	mlx5_sf_free(table, sf);
-}
-
 static int
 mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_attrs *new_attr,
 		       struct netlink_ext_ack *extack)
@@ -188,10 +342,30 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 	return err;
 }
 
+static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	if (sf->hw_state == MLX5_VHCA_STATE_ALLOCATED) {
+		mlx5_sf_free(table, sf);
+	} else if (mlx5_sf_is_active(sf)) {
+		/* Even if its active, it is treated as in_use because by the time,
+		 * it is disabled here, it may getting used. So it is safe to
+		 * always look for the event to ensure that it is recycled only after
+		 * firmware gives confirmation that it is detached by the driver.
+		 */
+		mlx5_cmd_sf_disable_hca(table->dev, sf->hw_fn_id);
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->id);
+		kfree(sf);
+	} else {
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->id);
+		kfree(sf);
+	}
+}
+
 int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 			     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf_table *table;
 	struct mlx5_sf *sf;
 	int err = 0;
@@ -208,20 +382,58 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 		goto sf_err;
 	}
 
-	mlx5_sf_del(dev, table, sf);
+	mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
+	mlx5_sf_id_erase(table, sf);
+
+	mutex_lock(&table->sf_state_lock);
+	mlx5_sf_dealloc(table, sf);
+	mutex_unlock(&table->sf_state_lock);
 sf_err:
 	mlx5_sf_table_put(table);
 	return err;
 }
 
-static void mlx5_sf_destroy_all(struct mlx5_sf_table *table)
+static bool mlx5_sf_state_update_check(const struct mlx5_sf *sf, u8 new_state)
 {
-	struct mlx5_core_dev *dev = table->dev;
-	unsigned long index;
+	if (sf->hw_state == MLX5_VHCA_STATE_ACTIVE && new_state == MLX5_VHCA_STATE_IN_USE)
+		return true;
+
+	if (sf->hw_state == MLX5_VHCA_STATE_IN_USE && new_state == MLX5_VHCA_STATE_ACTIVE)
+		return true;
+
+	if (sf->hw_state == MLX5_VHCA_STATE_TEARDOWN_REQUEST &&
+	    new_state == MLX5_VHCA_STATE_ALLOCATED)
+		return true;
+
+	return false;
+}
+
+static int mlx5_sf_vhca_event(struct notifier_block *nb, unsigned long opcode, void *data)
+{
+	struct mlx5_sf_table *table = container_of(nb, struct mlx5_sf_table, vhca_nb);
+	const struct mlx5_vhca_state_event *event = data;
+	bool update = false;
 	struct mlx5_sf *sf;
 
-	xa_for_each(&table->port_indices, index, sf)
-		mlx5_sf_del(dev, table, sf);
+	table = mlx5_sf_table_try_get(table->dev);
+	if (!table)
+		return 0;
+
+	mutex_lock(&table->sf_state_lock);
+	sf = mlx5_sf_lookup_by_function_id(table, event->function_id);
+	if (!sf)
+		goto sf_err;
+
+	/* When driver is attached or detached to a function, an event
+	 * notifies such state change.
+	 */
+	update = mlx5_sf_state_update_check(sf, event->new_vhca_state);
+	if (update)
+		sf->hw_state = event->new_vhca_state;
+sf_err:
+	mutex_unlock(&table->sf_state_lock);
+	mlx5_sf_table_put(table);
+	return 0;
 }
 
 static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
@@ -233,6 +445,22 @@ static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
 	refcount_set(&table->refcount, 1);
 }
 
+static void mlx5_sf_deactivate_all(struct mlx5_sf_table *table)
+{
+	struct mlx5_eswitch *esw = table->dev->priv.eswitch;
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	/* At this point, no new user commands can start and no vhca event can
+	 * arrive. It is safe to destroy all user created SFs.
+	 */
+	xa_for_each(&table->port_indices, index, sf) {
+		mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
+		mlx5_sf_id_erase(table, sf);
+		mlx5_sf_dealloc(table, sf);
+	}
+}
+
 static void mlx5_sf_table_disable(struct mlx5_sf_table *table)
 {
 	if (!mlx5_sf_max_functions(table->dev))
@@ -241,14 +469,13 @@ static void mlx5_sf_table_disable(struct mlx5_sf_table *table)
 	if (!refcount_read(&table->refcount))
 		return;
 
-	/* Balances with refcount_set; drop the reference so that new user cmd cannot start. */
+	/* Balances with refcount_set; drop the reference so that new user cmd cannot start
+	 * and new vhca event handler cannnot run.
+	 */
 	mlx5_sf_table_put(table);
 	wait_for_completion(&table->disable_complete);
 
-	/* At this point, no new user commands can start.
-	 * It is safe to destroy all user created SFs.
-	 */
-	mlx5_sf_destroy_all(table);
+	mlx5_sf_deactivate_all(table);
 }
 
 static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long event, void *data)
@@ -280,23 +507,34 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev)
 	struct mlx5_sf_table *table;
 	int err;
 
-	if (!mlx5_sf_table_supported(dev))
+	if (!mlx5_sf_table_supported(dev) || !mlx5_vhca_event_supported(dev))
 		return 0;
 
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
+	mutex_init(&table->sf_state_lock);
 	table->dev = dev;
 	xa_init(&table->port_indices);
 	dev->priv.sf_table = table;
+	refcount_set(&table->refcount, 0);
 	table->esw_nb.notifier_call = mlx5_sf_esw_event;
 	err = mlx5_esw_event_notifier_register(dev->priv.eswitch, &table->esw_nb);
 	if (err)
 		goto reg_err;
+
+	table->vhca_nb.notifier_call = mlx5_sf_vhca_event;
+	err = mlx5_vhca_event_notifier_register(table->dev, &table->vhca_nb);
+	if (err)
+		goto vhca_err;
+
 	return 0;
 
+vhca_err:
+	mlx5_esw_event_notifier_unregister(dev->priv.eswitch, &table->esw_nb);
 reg_err:
+	mutex_destroy(&table->sf_state_lock);
 	kfree(table);
 	dev->priv.sf_table = NULL;
 	return err;
@@ -309,8 +547,10 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
+	mlx5_vhca_event_notifier_unregister(table->dev, &table->vhca_nb);
 	mlx5_esw_event_notifier_unregister(dev->priv.eswitch, &table->esw_nb);
 	WARN_ON(refcount_read(&table->refcount));
+	mutex_destroy(&table->sf_state_lock);
 	WARN_ON(!xa_empty(&table->port_indices));
 	kfree(table);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index c7757f399e8a..58b6be0b03d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -4,11 +4,14 @@
 #include "vhca_event.h"
 #include "priv.h"
 #include "sf.h"
+#include "mlx5_ifc_vhca_event.h"
+#include "vhca_event.h"
 #include "ecpf.h"
 
 struct mlx5_sf_hw {
 	u32 usr_sfnum;
 	u8 allocated: 1;
+	u8 pending_delete: 1;
 };
 
 struct mlx5_sf_hw_table {
@@ -16,6 +19,8 @@ struct mlx5_sf_hw_table {
 	struct mlx5_sf_hw *sfs;
 	int max_local_functions;
 	u8 ecpu: 1;
+	struct mutex table_lock; /* Serializes sf deletion and vhca state change handler. */
+	struct notifier_block vhca_nb;
 };
 
 u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
@@ -23,6 +28,11 @@ u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
 	return sw_id + mlx5_sf_start_function_id(dev);
 }
 
+static u16 mlx5_sf_hw_to_sw_id(const struct mlx5_core_dev *dev, u16 hw_id)
+{
+	return hw_id - mlx5_sf_start_function_id(dev);
+}
+
 int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
@@ -34,10 +44,13 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	if (!table->max_local_functions)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&table->table_lock);
 	/* Check if sf with same sfnum already exists or not. */
 	for (i = 0; i < table->max_local_functions; i++) {
-		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum)
-			return -EEXIST;
+		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum) {
+			err = -EEXIST;
+			goto exist_err;
+		}
 	}
 
 	/* Find the free entry and allocate the entry from the array */
@@ -63,16 +76,19 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	if (err)
 		goto vhca_err;
 
+	mutex_unlock(&table->table_lock);
 	return sw_id;
 
 vhca_err:
 	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
 err:
 	table->sfs[i].allocated = false;
+exist_err:
+	mutex_unlock(&table->table_lock);
 	return err;
 }
 
-void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
+static void _mlx5_sf_hw_id_free(struct mlx5_core_dev *dev, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
@@ -80,6 +96,50 @@ void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
 	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, id);
 	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
 	table->sfs[id].allocated = false;
+	table->sfs[id].pending_delete = false;
+}
+
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	mutex_lock(&table->table_lock);
+	_mlx5_sf_hw_id_free(dev, id);
+	mutex_unlock(&table->table_lock);
+}
+
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
+	u16 hw_fn_id;
+	u8 state;
+	int err;
+
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
+	mutex_lock(&table->table_lock);
+	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, table->ecpu, out, sizeof(out));
+	if (err)
+		goto err;
+	state = MLX5_GET(query_vhca_state_out, out, vhca_state_context.vhca_state);
+	if (state == MLX5_VHCA_STATE_ALLOCATED) {
+		mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+		table->sfs[id].allocated = false;
+	} else {
+		table->sfs[id].pending_delete = true;
+	}
+err:
+	mutex_unlock(&table->table_lock);
+}
+
+static void mlx5_sf_hw_dealloc_all(struct mlx5_sf_hw_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->max_local_functions; i++) {
+		if (table->sfs[i].allocated)
+			_mlx5_sf_hw_id_free(table->dev, i);
+	}
 }
 
 int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
@@ -88,7 +148,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	struct mlx5_sf_hw *sfs;
 	int max_functions;
 
-	if (!mlx5_sf_supported(dev))
+	if (!mlx5_sf_supported(dev) || !mlx5_vhca_event_supported(dev))
 		return 0;
 
 	max_functions = mlx5_sf_max_functions(dev);
@@ -100,6 +160,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	if (!sfs)
 		goto table_err;
 
+	mutex_init(&table->table_lock);
 	table->dev = dev;
 	table->sfs = sfs;
 	table->max_local_functions = max_functions;
@@ -120,6 +181,53 @@ void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
+	mutex_destroy(&table->table_lock);
 	kfree(table->sfs);
 	kfree(table);
 }
+
+static int mlx5_sf_hw_vhca_event(struct notifier_block *nb, unsigned long opcode, void *data)
+{
+	struct mlx5_sf_hw_table *table = container_of(nb, struct mlx5_sf_hw_table, vhca_nb);
+	const struct mlx5_vhca_state_event *event = data;
+	struct mlx5_sf_hw *sf_hw;
+	u16 sw_id;
+
+	if (event->new_vhca_state != MLX5_VHCA_STATE_ALLOCATED)
+		return 0;
+
+	sw_id = mlx5_sf_hw_to_sw_id(table->dev, event->function_id);
+	sf_hw = &table->sfs[sw_id];
+
+	mutex_lock(&table->table_lock);
+	/* SF driver notified through firmware that SF is finally detached.
+	 * Hence recycle the sf hardware id for reuse.
+	 */
+	if (sf_hw->allocated && sf_hw->pending_delete)
+		_mlx5_sf_hw_id_free(table->dev, sw_id);
+	mutex_unlock(&table->table_lock);
+	return 0;
+}
+
+int mlx5_sf_hw_table_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	if (!table)
+		return 0;
+
+	table->vhca_nb.notifier_call = mlx5_sf_hw_vhca_event;
+	return mlx5_vhca_event_notifier_register(table->dev, &table->vhca_nb);
+}
+
+void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	if (!table)
+		return;
+
+	mlx5_vhca_event_notifier_unregister(table->dev, &table->vhca_nb);
+	/* Dealloc SFs whose firmware event has been missed. */
+	mlx5_sf_hw_dealloc_all(table);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
index 7f3622375a9c..cb02a51d0986 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -9,9 +9,13 @@
 int mlx5_cmd_alloc_sf(struct mlx5_core_dev *dev, u16 function_id);
 int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id);
 
+int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
+int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
+
 u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id);
 
 int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum);
 void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id);
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 31278dc42e72..0b6aea1e6a94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -47,6 +47,9 @@ static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
 int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev);
 void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev);
 
+int mlx5_sf_hw_table_create(struct mlx5_core_dev *dev);
+void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev);
+
 int mlx5_sf_table_init(struct mlx5_core_dev *dev);
 void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 
@@ -56,7 +59,13 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     unsigned int *new_port_index);
 int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 			     struct netlink_ext_ack *extack);
-
+int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devlink_port *dl_port,
+				      enum devlink_port_fn_state *state,
+				      enum devlink_port_fn_opstate *opstate,
+				      struct netlink_ext_ack *extack);
+int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_port *dl_port,
+				      enum devlink_port_fn_state state,
+				      struct netlink_ext_ack *extack);
 #else
 
 static inline int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
@@ -68,6 +77,15 @@ static inline void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
 {
 }
 
+static inline int mlx5_sf_hw_table_create(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
+{
+}
+
 static inline int mlx5_sf_table_init(struct mlx5_core_dev *dev)
 {
 	return 0;
-- 
2.26.2

