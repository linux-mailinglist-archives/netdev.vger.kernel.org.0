Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0278301088
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbhAVXBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbhAVTk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:40:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E7B23B09;
        Fri, 22 Jan 2021 19:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344233;
        bh=M/djDEFwBZe9jMipP+hLYVq21L52vVIVxAJ3xsIw/FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8er6sxM95QXt/JACloewDrcZ2migpZOtT18C3FseqLwg4cEerOsfzAb1JYLEBSgj
         R+B4takIRjuwJy2vS+QaYGZ3leulEyYJEw0h3inASPEFq2TdbLit4BJT+ASdrX9tBC
         IgBFvQkNJIWrLYSAXSNjjJAXEPtlvZ7aVhiauspHyHdryrS8Fd5qUXIh0BgOfNqSIg
         9BdGxm9e7hU6o01mcfw677BsXijhgw3fP8roZ7kS/KPOMUPqbsIDRl0nY+97DbnUL0
         +cT2KZIRD1GfWepPYwhUg7bf8+mktWBYFVCmdEy6KOeMH3lJ0XqQYNZ7N2aTnin/65
         8oQd6crGsY7IQ==
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
Subject: [net-next V10 10/14] net/mlx5: SF, Add port add delete functionality
Date:   Fri, 22 Jan 2021 11:36:54 -0800
Message-Id: <20210122193658.282884-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

To handle SF port management outside of the eswitch as independent
software layer, introduce eswitch notifier APIs so that mlx5 upper
layer who wish to support sf port management in switchdev mode can
perform its task whenever eswitch mode is set to switchdev or before
eswitch is disabled.

Initialize sf port table on such eswitch event.

Add SF port add and delete functionality in switchdev mode.
Destroy all SF ports when eswitch is disabled.
Expose SF port add and delete to user via devlink commands.

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
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

or by its unique port index:
$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

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
                "hw_addr": "00:00:00:00:00:00",
                "state": "inactive",
                "opstate": "detached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  10 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   5 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  25 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  12 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  18 +
 .../net/ethernet/mellanox/mlx5/core/sf/cmd.c  |  27 ++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 316 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 125 +++++++
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |  17 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  37 ++
 include/linux/mlx5/driver.h                   |   6 +
 13 files changed, 607 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index d6c48582e7a8..ad45d20f9d44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -212,3 +212,13 @@ config MLX5_SF
 	Build support for subfuction device in the NIC. A Mellanox subfunction
 	device can support RDMA, netdevice and vdpa device.
 	It is similar to a SRIOV VF but it doesn't require SRIOV support.
+
+config MLX5_SF_MANAGER
+	bool
+	depends on MLX5_SF && MLX5_ESWITCH
+	default y
+	help
+	Build support for subfuction port in the NIC. A Mellanox subfunction
+	port is managed through devlink.  A subfunction supports RDMA, netdevice
+	and vdpa device. It is similar to a SRIOV VF but it doesn't require
+	SRIOV support.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 43fa5efd403c..40ed31574c80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -90,3 +90,8 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 # SF device
 #
 mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
+
+#
+# SF manager
+#
+mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 47dcc3ac2cf0..e8cecd50558d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -333,6 +333,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_MEMIC:
 	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 	case MLX5_CMD_OP_QUERY_ESW_FUNCTIONS:
+	case MLX5_CMD_OP_DEALLOC_SF:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -466,6 +467,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
 	case MLX5_CMD_OP_QUERY_VHCA_STATE:
 	case MLX5_CMD_OP_MODIFY_VHCA_STATE:
+	case MLX5_CMD_OP_ALLOC_SF:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -661,6 +663,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(MODIFY_XRQ);
 	MLX5_COMMAND_STR_CASE(QUERY_VHCA_STATE);
 	MLX5_COMMAND_STR_CASE(MODIFY_VHCA_STATE);
+	MLX5_COMMAND_STR_CASE(ALLOC_SF);
+	MLX5_COMMAND_STR_CASE(DEALLOC_SF);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 9afe918c5827..d4c0cdf5edd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -8,6 +8,7 @@
 #include "fs_core.h"
 #include "eswitch.h"
 #include "sf/dev/dev.h"
+#include "sf/sf.h"
 
 static int mlx5_devlink_flash_update(struct devlink *devlink,
 				     struct devlink_flash_update_params *params,
@@ -190,6 +191,10 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
+#endif
+#ifdef CONFIG_MLX5_SF_MANAGER
+	.port_new = mlx5_devlink_sf_port_new,
+	.port_del = mlx5_devlink_sf_port_del,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 538d2e44a589..820305b1664e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1599,6 +1599,15 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
 	kvfree(out);
 }
 
+static void mlx5_esw_mode_change_notify(struct mlx5_eswitch *esw, u16 mode)
+{
+	struct mlx5_esw_event_info info = {};
+
+	info.new_mode = mode;
+
+	blocking_notifier_call_chain(&esw->n_head, 0, &info);
+}
+
 /**
  * mlx5_eswitch_enable_locked - Enable eswitch
  * @esw:	Pointer to eswitch
@@ -1659,6 +1668,8 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		 mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
+	mlx5_esw_mode_change_notify(esw, mode);
+
 	return 0;
 
 abort:
@@ -1715,6 +1726,11 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
+	/* Notify eswitch users that it is exiting from current mode.
+	 * So that it can do necessary cleanup before the eswitch is disabled.
+	 */
+	mlx5_esw_mode_change_notify(esw, MLX5_ESWITCH_NONE);
+
 	mlx5_eswitch_event_handlers_unregister(esw);
 
 	if (esw->mode == MLX5_ESWITCH_LEGACY)
@@ -1815,6 +1831,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
 
 	dev->priv.eswitch = esw;
+	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
 	return 0;
 abort:
 	if (esw->work_queue)
@@ -2506,4 +2523,12 @@ bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 		dev1->priv.eswitch->mode == MLX5_ESWITCH_OFFLOADS);
 }
 
+int mlx5_esw_event_notifier_register(struct mlx5_eswitch *esw, struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&esw->n_head, nb);
+}
 
+void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&esw->n_head, nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 54514b04808d..479d2ac2cd85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -278,6 +278,7 @@ struct mlx5_eswitch {
 	struct {
 		u32             large_group_num;
 	}  params;
+	struct blocking_notifier_head n_head;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -733,6 +734,17 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_p
 				      u16 vport_num, u32 sfnum);
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
 
+/**
+ * mlx5_esw_event_info - Indicates eswitch mode changed/changing.
+ *
+ * @new_mode: New mode of eswitch.
+ */
+struct mlx5_esw_event_info {
+	u16 new_mode;
+};
+
+int mlx5_esw_event_notifier_register(struct mlx5_eswitch *esw, struct notifier_block *n);
+void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct notifier_block *n);
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ab68320e5516..d6bd09dd7490 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -893,6 +893,18 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_fpga_cleanup;
 	}
 
+	err = mlx5_sf_hw_table_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init SF HW table %d\n", err);
+		goto err_sf_hw_table_cleanup;
+	}
+
+	err = mlx5_sf_table_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init SF table %d\n", err);
+		goto err_sf_table_cleanup;
+	}
+
 	dev->dm = mlx5_dm_create(dev);
 	if (IS_ERR(dev->dm))
 		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
@@ -903,6 +915,10 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	return 0;
 
+err_sf_table_cleanup:
+	mlx5_sf_hw_table_cleanup(dev);
+err_sf_hw_table_cleanup:
+	mlx5_vhca_event_cleanup(dev);
 err_fpga_cleanup:
 	mlx5_fpga_cleanup(dev);
 err_eswitch_cleanup:
@@ -936,6 +952,8 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
+	mlx5_sf_table_cleanup(dev);
+	mlx5_sf_hw_table_cleanup(dev);
 	mlx5_vhca_event_cleanup(dev);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
new file mode 100644
index 000000000000..0bc3075f34fa
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include "priv.h"
+
+int mlx5_cmd_alloc_sf(struct mlx5_core_dev *dev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_sf_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_sf_in)] = {};
+
+	MLX5_SET(alloc_sf_in, in, opcode, MLX5_CMD_OP_ALLOC_SF);
+	MLX5_SET(alloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_sf_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(dealloc_sf_in)] = {};
+
+	MLX5_SET(dealloc_sf_in, in, opcode, MLX5_CMD_OP_DEALLOC_SF);
+	MLX5_SET(dealloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
new file mode 100644
index 000000000000..7ad0d210ec30
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include "eswitch.h"
+#include "priv.h"
+
+struct mlx5_sf {
+	struct devlink_port dl_port;
+	unsigned int port_index;
+	u16 id;
+};
+
+struct mlx5_sf_table {
+	struct mlx5_core_dev *dev; /* To refer from notifier context. */
+	struct xarray port_indices; /* port index based lookup. */
+	refcount_t refcount;
+	struct completion disable_complete;
+	struct notifier_block esw_nb;
+};
+
+static struct mlx5_sf *
+mlx5_sf_lookup_by_index(struct mlx5_sf_table *table, unsigned int port_index)
+{
+	return xa_load(&table->port_indices, port_index);
+}
+
+static int mlx5_sf_id_insert(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	return xa_insert(&table->port_indices, sf->port_index, sf, GFP_KERNEL);
+}
+
+static void mlx5_sf_id_erase(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	xa_erase(&table->port_indices, sf->port_index);
+}
+
+static struct mlx5_sf *
+mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *extack)
+{
+	unsigned int dl_port_index;
+	struct mlx5_sf *sf;
+	u16 hw_fn_id;
+	int id_err;
+	int err;
+
+	id_err = mlx5_sf_hw_table_sf_alloc(table->dev, sfnum);
+	if (id_err < 0) {
+		err = id_err;
+		goto id_err;
+	}
+
+	sf = kzalloc(sizeof(*sf), GFP_KERNEL);
+	if (!sf) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
+	sf->id = id_err;
+	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sf->id);
+	dl_port_index = mlx5_esw_vport_to_devlink_port_index(table->dev, hw_fn_id);
+	sf->port_index = dl_port_index;
+
+	err = mlx5_sf_id_insert(table, sf);
+	if (err)
+		goto insert_err;
+
+	return sf;
+
+insert_err:
+	kfree(sf);
+alloc_err:
+	mlx5_sf_hw_table_sf_free(table->dev, id_err);
+id_err:
+	if (err == -EEXIST)
+		NL_SET_ERR_MSG_MOD(extack, "SF already exist. Choose different sfnum");
+	return ERR_PTR(err);
+}
+
+static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	mlx5_sf_id_erase(table, sf);
+	mlx5_sf_hw_table_sf_free(table->dev, sf->id);
+	kfree(sf);
+}
+
+static struct mlx5_sf_table *mlx5_sf_table_try_get(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table = dev->priv.sf_table;
+
+	if (!table)
+		return NULL;
+
+	return refcount_inc_not_zero(&table->refcount) ? table : NULL;
+}
+
+static void mlx5_sf_table_put(struct mlx5_sf_table *table)
+{
+	if (refcount_dec_and_test(&table->refcount))
+		complete(&table->disable_complete);
+}
+
+static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
+		       const struct devlink_port_new_attrs *new_attr,
+		       struct netlink_ext_ack *extack,
+		       unsigned int *new_port_index)
+{
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_sf *sf;
+	u16 hw_fn_id;
+	int err;
+
+	sf = mlx5_sf_alloc(table, new_attr->sfnum, extack);
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sf->id);
+	err = mlx5_esw_offloads_sf_vport_enable(esw, &sf->dl_port, hw_fn_id, new_attr->sfnum);
+	if (err)
+		goto esw_err;
+	*new_port_index = sf->port_index;
+	return 0;
+
+esw_err:
+	mlx5_sf_free(table, sf);
+	return err;
+}
+
+static void mlx5_sf_del(struct mlx5_core_dev *dev, struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	u16 hw_fn_id;
+
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sf->id);
+	mlx5_esw_offloads_sf_vport_disable(esw, hw_fn_id);
+	mlx5_sf_free(table, sf);
+}
+
+static int
+mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_attrs *new_attr,
+		       struct netlink_ext_ack *extack)
+{
+	if (new_attr->flavour != DEVLINK_PORT_FLAVOUR_PCI_SF) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver supports only SF port addition");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->port_index_valid) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Driver does not support user defined port index assignment");
+		return -EOPNOTSUPP;
+	}
+	if (!new_attr->sfnum_valid) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "User must provide unique sfnum. Driver does not support auto assignment");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->controller_valid && new_attr->controller) {
+		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->pfnum != PCI_FUNC(dev->pdev->devfn)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid pfnum supplied");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+int mlx5_devlink_sf_port_new(struct devlink *devlink,
+			     const struct devlink_port_new_attrs *new_attr,
+			     struct netlink_ext_ack *extack,
+			     unsigned int *new_port_index)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	int err;
+
+	err = mlx5_sf_new_check_attr(dev, new_attr, extack);
+	if (err)
+		return err;
+
+	table = mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port add is only supported in eswitch switchdev mode or SF ports are disabled.");
+		return -EOPNOTSUPP;
+	}
+	err = mlx5_sf_add(dev, table, new_attr, extack, new_port_index);
+	mlx5_sf_table_put(table);
+	return err;
+}
+
+int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
+			     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	struct mlx5_sf *sf;
+	int err = 0;
+
+	table = mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port del is only supported in eswitch switchdev mode or SF ports are disabled.");
+		return -EOPNOTSUPP;
+	}
+	sf = mlx5_sf_lookup_by_index(table, port_index);
+	if (!sf) {
+		err = -ENODEV;
+		goto sf_err;
+	}
+
+	mlx5_sf_del(dev, table, sf);
+sf_err:
+	mlx5_sf_table_put(table);
+	return err;
+}
+
+static void mlx5_sf_destroy_all(struct mlx5_sf_table *table)
+{
+	struct mlx5_core_dev *dev = table->dev;
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	xa_for_each(&table->port_indices, index, sf)
+		mlx5_sf_del(dev, table, sf);
+}
+
+static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
+{
+	if (!mlx5_sf_max_functions(table->dev))
+		return;
+
+	init_completion(&table->disable_complete);
+	refcount_set(&table->refcount, 1);
+}
+
+static void mlx5_sf_table_disable(struct mlx5_sf_table *table)
+{
+	if (!mlx5_sf_max_functions(table->dev))
+		return;
+
+	if (!refcount_read(&table->refcount))
+		return;
+
+	/* Balances with refcount_set; drop the reference so that new user cmd cannot start. */
+	mlx5_sf_table_put(table);
+	wait_for_completion(&table->disable_complete);
+
+	/* At this point, no new user commands can start.
+	 * It is safe to destroy all user created SFs.
+	 */
+	mlx5_sf_destroy_all(table);
+}
+
+static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long event, void *data)
+{
+	struct mlx5_sf_table *table = container_of(nb, struct mlx5_sf_table, esw_nb);
+	const struct mlx5_esw_event_info *mode = data;
+
+	switch (mode->new_mode) {
+	case MLX5_ESWITCH_OFFLOADS:
+		mlx5_sf_table_enable(table);
+		break;
+	case MLX5_ESWITCH_NONE:
+		mlx5_sf_table_disable(table);
+		break;
+	default:
+		break;
+	};
+
+	return 0;
+}
+
+static bool mlx5_sf_table_supported(const struct mlx5_core_dev *dev)
+{
+	return dev->priv.eswitch && MLX5_ESWITCH_MANAGER(dev) && mlx5_sf_supported(dev);
+}
+
+int mlx5_sf_table_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table;
+	int err;
+
+	if (!mlx5_sf_table_supported(dev))
+		return 0;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	table->dev = dev;
+	xa_init(&table->port_indices);
+	dev->priv.sf_table = table;
+	table->esw_nb.notifier_call = mlx5_sf_esw_event;
+	err = mlx5_esw_event_notifier_register(dev->priv.eswitch, &table->esw_nb);
+	if (err)
+		goto reg_err;
+	return 0;
+
+reg_err:
+	kfree(table);
+	dev->priv.sf_table = NULL;
+	return err;
+}
+
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table = dev->priv.sf_table;
+
+	if (!table)
+		return;
+
+	mlx5_esw_event_notifier_unregister(dev->priv.eswitch, &table->esw_nb);
+	WARN_ON(refcount_read(&table->refcount));
+	WARN_ON(!xa_empty(&table->port_indices));
+	kfree(table);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
new file mode 100644
index 000000000000..c7757f399e8a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+#include <linux/mlx5/driver.h>
+#include "vhca_event.h"
+#include "priv.h"
+#include "sf.h"
+#include "ecpf.h"
+
+struct mlx5_sf_hw {
+	u32 usr_sfnum;
+	u8 allocated: 1;
+};
+
+struct mlx5_sf_hw_table {
+	struct mlx5_core_dev *dev;
+	struct mlx5_sf_hw *sfs;
+	int max_local_functions;
+	u8 ecpu: 1;
+};
+
+u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
+{
+	return sw_id + mlx5_sf_start_function_id(dev);
+}
+
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	int sw_id = -ENOSPC;
+	u16 hw_fn_id;
+	int err;
+	int i;
+
+	if (!table->max_local_functions)
+		return -EOPNOTSUPP;
+
+	/* Check if sf with same sfnum already exists or not. */
+	for (i = 0; i < table->max_local_functions; i++) {
+		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum)
+			return -EEXIST;
+	}
+
+	/* Find the free entry and allocate the entry from the array */
+	for (i = 0; i < table->max_local_functions; i++) {
+		if (!table->sfs[i].allocated) {
+			table->sfs[i].usr_sfnum = usr_sfnum;
+			table->sfs[i].allocated = true;
+			sw_id = i;
+			break;
+		}
+	}
+	if (sw_id == -ENOSPC) {
+		err = -ENOSPC;
+		goto err;
+	}
+
+	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sw_id);
+	err = mlx5_cmd_alloc_sf(table->dev, hw_fn_id);
+	if (err)
+		goto err;
+
+	err = mlx5_modify_vhca_sw_id(dev, hw_fn_id, table->ecpu, usr_sfnum);
+	if (err)
+		goto vhca_err;
+
+	return sw_id;
+
+vhca_err:
+	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+err:
+	table->sfs[i].allocated = false;
+	return err;
+}
+
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	u16 hw_fn_id;
+
+	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, id);
+	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+	table->sfs[id].allocated = false;
+}
+
+int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_hw_table *table;
+	struct mlx5_sf_hw *sfs;
+	int max_functions;
+
+	if (!mlx5_sf_supported(dev))
+		return 0;
+
+	max_functions = mlx5_sf_max_functions(dev);
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	sfs = kcalloc(max_functions, sizeof(*sfs), GFP_KERNEL);
+	if (!sfs)
+		goto table_err;
+
+	table->dev = dev;
+	table->sfs = sfs;
+	table->max_local_functions = max_functions;
+	table->ecpu = mlx5_read_embedded_cpu(dev);
+	dev->priv.sf_hw_table = table;
+	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_functions);
+	return 0;
+
+table_err:
+	kfree(table);
+	return -ENOMEM;
+}
+
+void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	if (!table)
+		return;
+
+	kfree(table->sfs);
+	kfree(table);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
new file mode 100644
index 000000000000..7f3622375a9c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_SF_PRIV_H__
+#define __MLX5_SF_PRIV_H__
+
+#include <linux/mlx5/driver.h>
+
+int mlx5_cmd_alloc_sf(struct mlx5_core_dev *dev, u16 function_id);
+int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id);
+
+u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id);
+
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum);
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id);
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 623191679b49..31278dc42e72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -42,4 +42,41 @@ static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
 
 #endif
 
+#ifdef CONFIG_MLX5_SF_MANAGER
+
+int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev);
+void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev);
+
+int mlx5_sf_table_init(struct mlx5_core_dev *dev);
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
+
+int mlx5_devlink_sf_port_new(struct devlink *devlink,
+			     const struct devlink_port_new_attrs *add_attr,
+			     struct netlink_ext_ack *extack,
+			     unsigned int *new_port_index);
+int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
+			     struct netlink_ext_ack *extack);
+
+#else
+
+static inline int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
+static inline int mlx5_sf_table_init(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
+#endif
+
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 48e3638b1185..7e357c7f0d5e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -510,6 +510,8 @@ struct mlx5_eq_table;
 struct mlx5_irq_table;
 struct mlx5_vhca_state_notifier;
 struct mlx5_sf_dev_table;
+struct mlx5_sf_hw_table;
+struct mlx5_sf_table;
 
 struct mlx5_rate_limit {
 	u32			rate;
@@ -611,6 +613,10 @@ struct mlx5_priv {
 	struct mlx5_sf_dev_table *sf_dev_table;
 	struct mlx5_core_dev *parent_mdev;
 #endif
+#ifdef CONFIG_MLX5_SF_MANAGER
+	struct mlx5_sf_hw_table *sf_hw_table;
+	struct mlx5_sf_table *sf_table;
+#endif
 };
 
 enum mlx5_device_state {
-- 
2.26.2

