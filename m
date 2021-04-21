Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2369E3671C5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbhDURsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244932AbhDURsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C52461409;
        Wed, 21 Apr 2021 17:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027263;
        bh=+OCLveJFgFLRu/0LTZNA0ujJRXZ/ehylZ8O7uhzqSGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edZPO6lRqf6O9Ji3bSz4yMg5gKagce1zr9oXIk/IucWPMuF1gZ7mLJAfnJ/fO7onW
         fhZyZydEjcwnsH1ucu4pwtqYFcJgjHOTNm8w0lP45YaNMBymJWIfIfaYwBkFbKrKFv
         huntDHHQLmr/hqgZKZOon2MTC9dvFnTVjZ0GDhHVGkm5VsfFZUYaeJFgTkzVHLH1Lp
         Ra0+qTKG9s3zyYyPEIo9JU57IyVYx0XLEz0Qn5wWelTuqZcvi57/c/pdRyOkIWx1lx
         XLxa51CLCTeuJMVnNAvdwY18bShUha6dGMHkbRPNGen/R50ISdf9j4RQqS4Srdyg4O
         vztlZBNp993rg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/11] net/mlx5: SF, Extend SF table for additional SF id range
Date:   Wed, 21 Apr 2021 10:47:23 -0700
Message-Id: <20210421174723.159428-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Extended the SF table to cover additioanl SF id range of external
controller.

A user optionallly provides the external controller number when user
wants to create SF on the external controller.

An example on eswitch system:
$ devlink dev eswitch set pci/0033:01:00.0 mode switchdev

$ devlink port show
pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  17 ++-
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  29 ++--
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 129 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |   8 +-
 6 files changed, 140 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 183f782b940f..1703384eca95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -123,7 +123,7 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 }
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
-				      u16 vport_num, u32 sfnum)
+				      u16 vport_num, u32 controller, u32 sfnum)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 	struct netdev_phys_item_id ppid = {};
@@ -141,7 +141,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	mlx5_esw_get_port_parent_id(dev, &ppid);
 	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 	dl_port->attrs.switch_id.id_len = ppid.id_len;
-	devlink_port_attrs_pci_sf_set(dl_port, 0, pfnum, sfnum, false);
+	devlink_port_attrs_pci_sf_set(dl_port, controller, pfnum, sfnum, !!controller);
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
 	err = devlink_port_register(devlink, dl_port, dl_port_index);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 0812cee8f603..64ccb2bc0b58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -662,11 +662,11 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num);
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
-				      u16 vport_num, u32 sfnum);
+				      u16 vport_num, u32 controller, u32 sfnum);
 void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
 
 int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
-				      u16 vport_num, u32 sfnum);
+				      u16 vport_num, u32 controller, u32 sfnum);
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
 int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *sf_base_id);
 
@@ -695,6 +695,8 @@ void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
 
+bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 controller);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a1dd66540ba0..db1e74280e57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2747,6 +2747,19 @@ static int mlx5_esw_host_number_init(struct mlx5_eswitch *esw)
 	return 0;
 }
 
+bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 controller)
+{
+	/* Local controller is always valid */
+	if (controller == 0)
+		return true;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return false;
+
+	/* External host number starts with zero in device */
+	return (controller == esw->offloads.host_number + 1);
+}
+
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	struct mapping_ctx *reg_c0_obj_pool;
@@ -3295,7 +3308,7 @@ u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
 
 int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
-				      u16 vport_num, u32 sfnum)
+				      u16 vport_num, u32 controller, u32 sfnum)
 {
 	int err;
 
@@ -3303,7 +3316,7 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		return err;
 
-	err = mlx5_esw_devlink_sf_port_register(esw, dl_port, vport_num, sfnum);
+	err = mlx5_esw_devlink_sf_port_register(esw, dl_port, vport_num, controller, sfnum);
 	if (err)
 		goto devlink_err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 5fa261334cd0..a8e73c9ed1ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -12,6 +12,7 @@
 struct mlx5_sf {
 	struct devlink_port dl_port;
 	unsigned int port_index;
+	u32 controller;
 	u16 id;
 	u16 hw_fn_id;
 	u16 hw_state;
@@ -58,7 +59,8 @@ static void mlx5_sf_id_erase(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 }
 
 static struct mlx5_sf *
-mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *extack)
+mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
+	      u32 controller, u32 sfnum, struct netlink_ext_ack *extack)
 {
 	unsigned int dl_port_index;
 	struct mlx5_sf *sf;
@@ -66,7 +68,12 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *ex
 	int id_err;
 	int err;
 
-	id_err = mlx5_sf_hw_table_sf_alloc(table->dev, sfnum);
+	if (!mlx5_esw_offloads_controller_valid(esw, controller)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid controller number");
+		return ERR_PTR(-EINVAL);
+	}
+
+	id_err = mlx5_sf_hw_table_sf_alloc(table->dev, controller, sfnum);
 	if (id_err < 0) {
 		err = id_err;
 		goto id_err;
@@ -78,11 +85,12 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *ex
 		goto alloc_err;
 	}
 	sf->id = id_err;
-	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sf->id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, controller, sf->id);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(table->dev, hw_fn_id);
 	sf->port_index = dl_port_index;
 	sf->hw_fn_id = hw_fn_id;
 	sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;
+	sf->controller = controller;
 
 	err = mlx5_sf_id_insert(table, sf);
 	if (err)
@@ -93,7 +101,7 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *ex
 insert_err:
 	kfree(sf);
 alloc_err:
-	mlx5_sf_hw_table_sf_free(table->dev, id_err);
+	mlx5_sf_hw_table_sf_free(table->dev, controller, id_err);
 id_err:
 	if (err == -EEXIST)
 		NL_SET_ERR_MSG_MOD(extack, "SF already exist. Choose different sfnum");
@@ -103,7 +111,7 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_ack *ex
 static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
 	mlx5_sf_id_erase(table, sf);
-	mlx5_sf_hw_table_sf_free(table->dev, sf->id);
+	mlx5_sf_hw_table_sf_free(table->dev, sf->controller, sf->id);
 	kfree(sf);
 }
 
@@ -272,12 +280,12 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	struct mlx5_sf *sf;
 	int err;
 
-	sf = mlx5_sf_alloc(table, new_attr->sfnum, extack);
+	sf = mlx5_sf_alloc(table, esw, new_attr->controller, new_attr->sfnum, extack);
 	if (IS_ERR(sf))
 		return PTR_ERR(sf);
 
 	err = mlx5_esw_offloads_sf_vport_enable(esw, &sf->dl_port, sf->hw_fn_id,
-						new_attr->sfnum);
+						new_attr->controller, new_attr->sfnum);
 	if (err)
 		goto esw_err;
 	*new_port_index = sf->port_index;
@@ -306,7 +314,8 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_
 				   "User must provide unique sfnum. Driver does not support auto assignment");
 		return -EOPNOTSUPP;
 	}
-	if (new_attr->controller_valid && new_attr->controller) {
+	if (new_attr->controller_valid && new_attr->controller &&
+	    !mlx5_core_is_ecpf_esw_manager(dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported");
 		return -EOPNOTSUPP;
 	}
@@ -352,10 +361,10 @@ static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 		 * firmware gives confirmation that it is detached by the driver.
 		 */
 		mlx5_cmd_sf_disable_hca(table->dev, sf->hw_fn_id);
-		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->id);
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller, sf->id);
 		kfree(sf);
 	} else {
-		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->id);
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller, sf->id);
 		kfree(sf);
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index b5eab48bbe08..ef5f892aafad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -8,6 +8,7 @@
 #include "ecpf.h"
 #include "vhca_event.h"
 #include "mlx5_core.h"
+#include "eswitch.h"
 
 struct mlx5_sf_hw {
 	u32 usr_sfnum;
@@ -23,6 +24,7 @@ struct mlx5_sf_hwc_table {
 
 enum mlx5_sf_hwc_index {
 	MLX5_SF_HWC_LOCAL,
+	MLX5_SF_HWC_EXTERNAL,
 	MLX5_SF_HWC_MAX,
 };
 
@@ -33,26 +35,50 @@ struct mlx5_sf_hw_table {
 	struct mlx5_sf_hwc_table hwc[MLX5_SF_HWC_MAX];
 };
 
-u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
+static struct mlx5_sf_hwc_table *
+mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller)
 {
-	struct mlx5_sf_hwc_table *hwc = &dev->priv.sf_hw_table->hwc[MLX5_SF_HWC_LOCAL];
+	int idx = !!controller;
 
-	return hwc->start_fn_id + sw_id;
+	return &dev->priv.sf_hw_table->hwc[idx];
 }
 
-static u16 mlx5_sf_hw_to_sw_id(const struct mlx5_core_dev *dev, u16 hw_id)
+u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u16 sw_id)
 {
-	struct mlx5_sf_hwc_table *hwc = &dev->priv.sf_hw_table->hwc[MLX5_SF_HWC_LOCAL];
+	struct mlx5_sf_hwc_table *hwc;
+
+	hwc = mlx5_sf_controller_to_hwc(dev, controller);
+	return hwc->start_fn_id + sw_id;
+}
 
+static u16 mlx5_sf_hw_to_sw_id(struct mlx5_sf_hwc_table *hwc, u16 hw_id)
+{
 	return hw_id - hwc->start_fn_id;
 }
 
-static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 usr_sfnum)
+static struct mlx5_sf_hwc_table *
+mlx5_sf_table_fn_to_hwc(struct mlx5_sf_hw_table *table, u16 fn_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(table->hwc); i++) {
+		if (table->hwc[i].max_fn &&
+		    fn_id >= table->hwc[i].start_fn_id &&
+		    fn_id < (table->hwc[i].start_fn_id + table->hwc[i].max_fn))
+			return &table->hwc[i];
+	}
+	return NULL;
+}
+
+static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 controller,
+				     u32 usr_sfnum)
 {
 	struct mlx5_sf_hwc_table *hwc;
 	int i;
 
-	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
+	hwc = mlx5_sf_controller_to_hwc(table->dev, controller);
+	if (!hwc->sfs)
+		return -ENOSPC;
 
 	/* Check if sf with same sfnum already exists or not. */
 	for (i = 0; i < hwc->max_fn; i++) {
@@ -70,15 +96,16 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 usr_sfn
 	return -ENOSPC;
 }
 
-static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, int id)
+static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, u32 controller, int id)
 {
-	struct mlx5_sf_hwc_table *hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
+	struct mlx5_sf_hwc_table *hwc;
 
+	hwc = mlx5_sf_controller_to_hwc(table->dev, controller);
 	hwc->sfs[id].allocated = false;
 	hwc->sfs[id].pending_delete = false;
 }
 
-int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr_sfnum)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
@@ -89,13 +116,13 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&table->table_lock);
-	sw_id = mlx5_sf_hw_table_id_alloc(table, usr_sfnum);
+	sw_id = mlx5_sf_hw_table_id_alloc(table, controller, usr_sfnum);
 	if (sw_id < 0) {
 		err = sw_id;
 		goto exist_err;
 	}
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sw_id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, sw_id);
 	err = mlx5_cmd_alloc_sf(dev, hw_fn_id);
 	if (err)
 		goto err;
@@ -104,38 +131,48 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	if (err)
 		goto vhca_err;
 
+	if (controller) {
+		/* If this SF is for external controller, SF manager
+		 * needs to arm firmware to receive the events.
+		 */
+		err = mlx5_vhca_event_arm(dev, hw_fn_id);
+		if (err)
+			goto vhca_err;
+	}
+
 	mutex_unlock(&table->table_lock);
 	return sw_id;
 
 vhca_err:
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 err:
-	mlx5_sf_hw_table_id_free(table, sw_id);
+	mlx5_sf_hw_table_id_free(table, controller, sw_id);
 exist_err:
 	mutex_unlock(&table->table_lock);
 	return err;
 }
 
-static void _mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
+	mutex_lock(&table->table_lock);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, id);
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
-	mlx5_sf_hw_table_id_free(table, id);
+	mlx5_sf_hw_table_id_free(table, controller, id);
+	mutex_unlock(&table->table_lock);
 }
 
-void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
+static void mlx5_sf_hw_table_hwc_sf_free(struct mlx5_core_dev *dev,
+					 struct mlx5_sf_hwc_table *hwc, int idx)
 {
-	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
-
-	mutex_lock(&table->table_lock);
-	_mlx5_sf_hw_table_sf_free(dev, id);
-	mutex_unlock(&table->table_lock);
+	mlx5_cmd_dealloc_sf(dev, hwc->start_fn_id + idx);
+	hwc->sfs[idx].allocated = false;
+	hwc->sfs[idx].pending_delete = false;
 }
 
-void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
@@ -144,8 +181,8 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
 	u8 state;
 	int err;
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
-	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, id);
+	hwc = mlx5_sf_controller_to_hwc(dev, controller);
 	mutex_lock(&table->table_lock);
 	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, out, sizeof(out));
 	if (err)
@@ -168,12 +205,13 @@ static void mlx5_sf_hw_table_hwc_dealloc_all(struct mlx5_core_dev *dev,
 
 	for (i = 0; i < hwc->max_fn; i++) {
 		if (hwc->sfs[i].allocated)
-			_mlx5_sf_hw_table_sf_free(dev, i);
+			mlx5_sf_hw_table_hwc_sf_free(dev, hwc, i);
 	}
 }
 
 static void mlx5_sf_hw_table_dealloc_all(struct mlx5_sf_hw_table *table)
 {
+	mlx5_sf_hw_table_hwc_dealloc_all(table->dev, &table->hwc[MLX5_SF_HWC_EXTERNAL]);
 	mlx5_sf_hw_table_hwc_dealloc_all(table->dev, &table->hwc[MLX5_SF_HWC_LOCAL]);
 }
 
@@ -181,6 +219,9 @@ static int mlx5_sf_hw_table_hwc_init(struct mlx5_sf_hwc_table *hwc, u16 max_fn,
 {
 	struct mlx5_sf_hw *sfs;
 
+	if (!max_fn)
+		return 0;
+
 	sfs = kcalloc(max_fn, sizeof(*sfs), GFP_KERNEL);
 	if (!sfs)
 		return -ENOMEM;
@@ -199,14 +240,25 @@ static void mlx5_sf_hw_table_hwc_cleanup(struct mlx5_sf_hwc_table *hwc)
 int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_hw_table *table;
+	u16 max_ext_fn = 0;
+	u16 ext_base_id;
+	u16 max_fn = 0;
 	u16 base_id;
-	u16 max_fn;
 	int err;
 
-	if (!mlx5_sf_supported(dev) || !mlx5_vhca_event_supported(dev))
+	if (!mlx5_vhca_event_supported(dev))
+		return 0;
+
+	if (mlx5_sf_supported(dev))
+		max_fn = mlx5_sf_max_functions(dev);
+
+	err = mlx5_esw_sf_max_hpf_functions(dev, &max_ext_fn, &ext_base_id);
+	if (err)
+		return err;
+
+	if (!max_fn && !max_ext_fn)
 		return 0;
 
-	max_fn = mlx5_sf_max_functions(dev);
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
@@ -220,9 +272,16 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto table_err;
 
-	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_fn);
+	err = mlx5_sf_hw_table_hwc_init(&table->hwc[MLX5_SF_HWC_EXTERNAL],
+					max_ext_fn, ext_base_id);
+	if (err)
+		goto ext_err;
+
+	mlx5_core_dbg(dev, "SF HW table: max sfs = %d, ext sfs = %d\n", max_fn, max_ext_fn);
 	return 0;
 
+ext_err:
+	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_LOCAL]);
 table_err:
 	mutex_destroy(&table->table_lock);
 	kfree(table);
@@ -237,6 +296,7 @@ void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
 		return;
 
 	mutex_destroy(&table->table_lock);
+	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_EXTERNAL]);
 	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_LOCAL]);
 	kfree(table);
 }
@@ -252,8 +312,11 @@ static int mlx5_sf_hw_vhca_event(struct notifier_block *nb, unsigned long opcode
 	if (event->new_vhca_state != MLX5_VHCA_STATE_ALLOCATED)
 		return 0;
 
-	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
-	sw_id = mlx5_sf_hw_to_sw_id(table->dev, event->function_id);
+	hwc = mlx5_sf_table_fn_to_hwc(table, event->function_id);
+	if (!hwc)
+		return 0;
+
+	sw_id = mlx5_sf_hw_to_sw_id(hwc, event->function_id);
 	sf_hw = &hwc->sfs[sw_id];
 
 	mutex_lock(&table->table_lock);
@@ -261,7 +324,7 @@ static int mlx5_sf_hw_vhca_event(struct notifier_block *nb, unsigned long opcode
 	 * Hence recycle the sf hardware id for reuse.
 	 */
 	if (sf_hw->allocated && sf_hw->pending_delete)
-		_mlx5_sf_hw_table_sf_free(table->dev, sw_id);
+		mlx5_sf_hw_table_hwc_sf_free(table->dev, hwc, sw_id);
 	mutex_unlock(&table->table_lock);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
index b36be5ecb496..7114f3fc335f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -12,11 +12,11 @@ int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id);
 int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
 
-u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id);
+u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u16 sw_id);
 
-int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum);
-void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id);
-void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id);
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr_sfnum);
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller, u16 id);
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id);
 bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev);
 
 #endif
-- 
2.30.2

