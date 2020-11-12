Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30BF2B0DE8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgKLTZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14179 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgKLTZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:25:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c100000>; Thu, 12 Nov 2020 11:25:04 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:59 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 12/13] net/mlx5: SF, Add port add delete functionality
Date:   Thu, 12 Nov 2020 21:24:22 +0200
Message-ID: <20201112192424.2742-13-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209104; bh=5gstZLtO626K6kOP6F234msF+sAiFuprZh30W0/Blzg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=TWi2UBrOXbE4NB/EZ2a5XilrRw8nQ0o5bfaKtOdXOBwnkC4UBcnBfin9E2f99a6qX
         Fh3oHOHVslzQ4H7M9EhLMMVaOdDnR+y9BQJ4QViqz0VttRsgJ//bv27lf2SZttXM/Q
         cpZrQbE9BhEWHWT7nqP6S3CXLKiBIPsPxyZKqsOXOVf4wxRBWEaAoV8NursG7JzVmW
         jX9Bo5zMO3/MMH+gMEFKfLeNQr8AIZCEbTWfWzCjb5lV1cMZDgRfkTVEdIGUAaCnrG
         9Qg/hDLj+TipV11bVC5tRXvjt7nvF027nwj3Q8CI7AFVFieeIjxW/oScH+TfKuZ3DO
         OgUlPIjoTkfwQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To handle SF port management outside of the eswitch as independent
software layer, introduce eswitch notifier APIs so that upper layer who
wish to support sf port management in switchdev mode can perform its
task whenever eswitch mode is set to switchdev or before eswitch is
disabled.

(a) Initialize sf port table on such eswitch event.
(b) Add SF port add and delete functionality in switchdev mode.
(c) Destroy all SF ports when eswitch is disabled.
(d) Expose SF port add and delete to user via devlink commands.

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

$ devlink port show ens2f0npf0sf88
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

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
                "state": "inactive",
                "opstate": "detached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   5 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  25 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  12 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   9 +
 .../net/ethernet/mellanox/mlx5/core/sf/sf.c   | 370 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  17 +
 include/linux/mlx5/driver.h                   |   4 +
 8 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 911e7bb43b23..b1d7f193375a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -93,4 +93,4 @@ mlx5_core-$(CONFIG_MLX5_SF) +=3D sf/dev/dev.o sf/dev/driv=
er.o
 #
 # SF manager
 #
-mlx5_core-$(CONFIG_MLX5_SF_MANAGER) +=3D sf/cmd.o
+mlx5_core-$(CONFIG_MLX5_SF_MANAGER) +=3D sf/cmd.o sf/sf.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index aeffb6b135ee..7ad8dc26cb74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -7,6 +7,7 @@
 #include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
+#include "sf/sf.h"
=20
 static int mlx5_devlink_flash_update(struct devlink *devlink,
 				     struct devlink_flash_update_params *params,
@@ -187,6 +188,10 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.eswitch_encap_mode_get =3D mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get =3D mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set =3D mlx5_devlink_port_function_hw_addr_set,
+#endif
+#ifdef CONFIG_MLX5_SF_MANAGER
+	.port_new =3D mlx5_devlink_sf_port_new,
+	.port_del =3D mlx5_devlink_sf_port_del,
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
 	.info_get =3D mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index d72766b78bd7..25f8c0918fca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1585,6 +1585,15 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *=
esw, int num_vfs)
 	kvfree(out);
 }
=20
+static void mlx5_esw_mode_change_notify(struct mlx5_eswitch *esw, u16 mode=
)
+{
+	struct mlx5_esw_event_info info =3D {};
+
+	info.new_mode =3D mode;
+
+	blocking_notifier_call_chain(&esw->n_head, 0, &info);
+}
+
 /**
  * mlx5_eswitch_enable_locked - Enable eswitch
  * @esw:	Pointer to eswitch
@@ -1645,6 +1654,8 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *e=
sw, int mode, int num_vfs)
 		 mode =3D=3D MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
=20
+	mlx5_esw_mode_change_notify(esw, mode);
+
 	return 0;
=20
 abort:
@@ -1701,6 +1712,11 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch=
 *esw, bool clear_vf)
 		 esw->mode =3D=3D MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
=20
+	/* Notify eswitch users that it is exiting from current mode.
+	 * So that it can do necessary cleanup before the eswitch is disabled.
+	 */
+	mlx5_esw_mode_change_notify(esw, MLX5_ESWITCH_NONE);
+
 	mlx5_eswitch_event_handlers_unregister(esw);
=20
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
@@ -1801,6 +1817,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->offloads.inline_mode =3D MLX5_INLINE_MODE_NONE;
=20
 	dev->priv.eswitch =3D esw;
+	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
 	return 0;
 abort:
 	if (esw->work_queue)
@@ -2493,4 +2510,12 @@ bool mlx5_esw_multipath_prereq(struct mlx5_core_dev =
*dev0,
 		dev1->priv.eswitch->mode =3D=3D MLX5_ESWITCH_OFFLOADS);
 }
=20
+int mlx5_esw_event_notifier_register(struct mlx5_eswitch *esw, struct noti=
fier_block *nb)
+{
+	return blocking_notifier_chain_register(&esw->n_head, nb);
+}
=20
+void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct n=
otifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&esw->n_head, nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 3a373f314a6b..fb26690a0ad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -278,6 +278,7 @@ struct mlx5_eswitch {
 	struct {
 		u32             large_group_num;
 	}  params;
+	struct blocking_notifier_head n_head;
 };
=20
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -737,6 +738,17 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswi=
tch *esw, struct devlink_p
 				      u16 vport_num, u32 sfnum);
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vpor=
t_num);
=20
+/**
+ * mlx5_esw_event_info - Indicates eswitch mode changed/changing.
+ *
+ * @new_mode: New mode of eswitch.
+ */
+struct mlx5_esw_event_info {
+	u16 new_mode;
+};
+
+int mlx5_esw_event_notifier_register(struct mlx5_eswitch *esw, struct noti=
fier_block *n);
+void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct n=
otifier_block *n);
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0=
; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index bd414d93f70e..f6570ce9393f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -889,6 +889,12 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eswitch_cleanup;
 	}
=20
+	err =3D mlx5_sf_table_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init SF table %d\n", err);
+		goto err_sf_table_cleanup;
+	}
+
 	err =3D mlx5_sf_dev_table_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to init SF device table %d\n", err);
@@ -906,6 +912,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	return 0;
=20
 err_sf_dev_cleanup:
+	mlx5_sf_table_cleanup(dev);
+err_sf_table_cleanup:
 	mlx5_fpga_cleanup(dev);
 err_eswitch_cleanup:
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
@@ -939,6 +947,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev=
)
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
 	mlx5_sf_dev_table_cleanup(dev);
+	mlx5_sf_table_cleanup(dev);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 	mlx5_sriov_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sf/sf.c
new file mode 100644
index 000000000000..dff44ab5057d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.c
@@ -0,0 +1,370 @@
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
+	u32 usr_sfnum;
+	u16 sw_id;
+	u16 hw_fn_id;
+};
+
+struct mlx5_sf_table {
+	struct mlx5_core_dev *dev; /* To refer from notifier context. */
+	struct xarray port_indices; /* port index based lookup. */
+	struct ida fn_ida; /* allocator based on firmware limits. */
+	int ida_max_ports;
+	refcount_t refcount;
+	struct completion disable_complete;
+	struct notifier_block esw_nb;
+};
+
+static u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
+{
+	return sw_id + mlx5_esw_sf_start_vport_num(dev);
+}
+
+static int mlx5_sf_id_alloc(struct mlx5_sf_table *table, struct mlx5_sf *s=
f)
+{
+	u16 hw_fn_id;
+	int sw_id;
+	int err;
+
+	if (!table->ida_max_ports)
+		return -EOPNOTSUPP;
+	sw_id =3D ida_alloc_max(&table->fn_ida, table->ida_max_ports - 1, GFP_KER=
NEL);
+	if (sw_id < 0)
+		return sw_id;
+	sf->sw_id =3D sw_id;
+
+	hw_fn_id =3D mlx5_sf_sw_to_hw_id(table->dev, sw_id);
+	err =3D mlx5_cmd_alloc_sf(table->dev, hw_fn_id);
+	if (err)
+		goto cmd_err;
+
+	sf->hw_fn_id =3D hw_fn_id;
+	return 0;
+
+cmd_err:
+	ida_free(&table->fn_ida, sf->sw_id);
+	return err;
+}
+
+static void mlx5_sf_id_free(struct mlx5_sf_table *table, struct mlx5_sf *s=
f)
+{
+	mlx5_cmd_dealloc_sf(table->dev, sf->hw_fn_id);
+	ida_free(&table->fn_ida, sf->sw_id);
+}
+
+static struct mlx5_sf *
+mlx5_sf_lookup_by_index(struct mlx5_sf_table *table, unsigned int port_ind=
ex)
+{
+	return xa_load(&table->port_indices, port_index);
+}
+
+static struct mlx5_sf *
+mlx5_sf_lookup_by_sfnum(struct mlx5_sf_table *table, u32 usr_sfnum)
+{
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	xa_for_each(&table->port_indices, index, sf) {
+		if (sf->usr_sfnum =3D=3D usr_sfnum)
+			return sf;
+	}
+	return NULL;
+}
+
+static int mlx5_sf_id_insert(struct mlx5_sf_table *table, struct mlx5_sf *=
sf)
+{
+	int err;
+
+	err =3D xa_insert(&table->port_indices, sf->port_index, sf, GFP_KERNEL);
+	/* After this stage, SF can be queried by devlink user by it port index. =
*/
+	return err;
+}
+
+static void mlx5_sf_id_erase(struct mlx5_sf_table *table, struct mlx5_sf *=
sf)
+{
+	xa_erase(&table->port_indices, sf->port_index);
+}
+
+static struct mlx5_sf *
+mlx5_sf_alloc(struct mlx5_sf_table *table, u32 sfnum, struct netlink_ext_a=
ck *extack)
+{
+	unsigned int dl_port_index;
+	struct mlx5_sf *sf;
+	int err;
+
+	sf =3D mlx5_sf_lookup_by_sfnum(table, sfnum);
+	if (sf) {
+		NL_SET_ERR_MSG_MOD(extack, "SF already exist. Choose different sfnum");
+		err =3D -EEXIST;
+		goto err;
+	}
+	sf =3D kzalloc(sizeof(*sf), GFP_KERNEL);
+	if (!sf) {
+		err =3D -ENOMEM;
+		goto err;
+	}
+	err =3D mlx5_sf_id_alloc(table, sf);
+	if (err)
+		goto id_err;
+
+	dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(table->dev, sf->hw=
_fn_id);
+	sf->port_index =3D dl_port_index;
+	sf->usr_sfnum =3D sfnum;
+
+	err =3D mlx5_sf_id_insert(table, sf);
+	if (err)
+		goto insert_err;
+
+	return sf;
+
+insert_err:
+	mlx5_sf_id_free(table, sf);
+id_err:
+	kfree(sf);
+err:
+	return ERR_PTR(err);
+}
+
+static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+{
+	mlx5_sf_id_erase(table, sf);
+	mlx5_sf_id_free(table, sf);
+	kfree(sf);
+}
+
+static struct mlx5_sf_table *mlx5_sf_table_try_get(struct mlx5_core_dev *d=
ev)
+{
+	struct mlx5_sf_table *table =3D dev->priv.sf_table;
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
+static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *ta=
ble,
+		       const struct devlink_port_new_attrs *new_attr,
+		       struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
+	struct mlx5_sf *sf;
+	u16 hw_fn_id;
+	int err;
+
+	sf =3D mlx5_sf_alloc(table, new_attr->sfnum, extack);
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+
+	hw_fn_id =3D sf->hw_fn_id;
+	err =3D mlx5_esw_offloads_sf_vport_enable(esw, &sf->dl_port, hw_fn_id, ne=
w_attr->sfnum);
+	if (err)
+		goto esw_err;
+	return 0;
+
+esw_err:
+	mlx5_sf_free(table, sf);
+	return err;
+}
+
+static void mlx5_sf_del(struct mlx5_core_dev *dev, struct mlx5_sf_table *t=
able, struct mlx5_sf *sf)
+{
+	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
+
+	mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
+	mlx5_sf_free(table, sf);
+}
+
+static int
+mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_por=
t_new_attrs *new_attr,
+		       struct netlink_ext_ack *extack)
+{
+	if (new_attr->flavour !=3D DEVLINK_PORT_FLAVOUR_PCI_SF) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver supports only SF port addition.");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->port_index_valid) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Driver does not support user defined port index assignment.");
+		return -EOPNOTSUPP;
+	}
+	if (!new_attr->sfnum_valid) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "User must provide unique sfnum. Driver does not support auto assig=
nment.");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->controller_valid && new_attr->controller) {
+		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported.");
+		return -EOPNOTSUPP;
+	}
+	if (new_attr->pfnum !=3D PCI_FUNC(dev->pdev->devfn)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid pfnum supplied.");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+int mlx5_devlink_sf_port_new(struct devlink *devlink, const struct devlink=
_port_new_attrs *new_attr,
+			     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	int err;
+
+	err =3D mlx5_sf_new_check_attr(dev, new_attr, extack);
+	if (err)
+		return err;
+
+	table =3D mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port add is only supported in eswitch switchdev mode or SF ports a=
re disabled.");
+		return -EOPNOTSUPP;
+	}
+	err =3D mlx5_sf_add(dev, table, new_attr, extack);
+	mlx5_sf_table_put(table);
+	return err;
+}
+
+int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_in=
dex,
+			     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	struct mlx5_sf_table *table;
+	struct mlx5_sf *sf;
+	int err =3D 0;
+
+	table =3D mlx5_sf_table_try_get(dev);
+	if (!table) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port del is only supported in eswitch switchdev mode or SF ports a=
re disabled.");
+		return -EOPNOTSUPP;
+	}
+	sf =3D mlx5_sf_lookup_by_index(table, port_index);
+	if (!sf) {
+		err =3D -ENODEV;
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
+	struct mlx5_core_dev *dev =3D table->dev;
+	unsigned long index;
+	struct mlx5_sf *sf;
+
+	xa_for_each(&table->port_indices, index, sf)
+		mlx5_sf_del(dev, table, sf);
+}
+
+static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
+{
+	if (!mlx5_sf_max_ports(table->dev))
+		return;
+
+	xa_init(&table->port_indices);
+	table->ida_max_ports =3D mlx5_sf_max_ports(table->dev);
+	init_completion(&table->disable_complete);
+	refcount_set(&table->refcount, 1);
+}
+
+void mlx5_sf_table_disable(struct mlx5_sf_table *table)
+{
+	if (!mlx5_sf_max_ports(table->dev))
+		return;
+
+	if (!refcount_read(&table->refcount))
+		return;
+
+	/* Balances with refcount_set; drop the reference so that new user cmd ca=
nnot start. */
+	mlx5_sf_table_put(table);
+	wait_for_completion(&table->disable_complete);
+
+	/* At this point, no new user commands can start.
+	 * It is safe to destroy all user created SFs.
+	 */
+	mlx5_sf_destroy_all(table);
+	WARN_ON(!xa_empty(&table->port_indices));
+}
+
+static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long even=
t, void *data)
+{
+	struct mlx5_sf_table *table =3D container_of(nb, struct mlx5_sf_table, es=
w_nb);
+	const struct mlx5_esw_event_info *mode =3D data;
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
+	return dev->priv.eswitch && MLX5_ESWITCH_MANAGER(dev) && mlx5_sf_supporte=
d(dev);
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
+	table =3D kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	table->dev =3D dev;
+	ida_init(&table->fn_ida);
+	dev->priv.sf_table =3D table;
+	table->esw_nb.notifier_call =3D mlx5_sf_esw_event;
+	err =3D mlx5_esw_event_notifier_register(dev->priv.eswitch, &table->esw_n=
b);
+	if (err)
+		goto reg_err;
+	return 0;
+
+reg_err:
+	kfree(table);
+	dev->priv.sf_table =3D NULL;
+	return err;
+}
+
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table =3D dev->priv.sf_table;
+
+	if (!table)
+		return;
+
+	mlx5_esw_event_notifier_unregister(dev->priv.eswitch, &table->esw_nb);
+	WARN_ON(refcount_read(&table->refcount));
+	WARN_ON(!ida_is_empty(&table->fn_ida));
+	kfree(table);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/=
ethernet/mellanox/mlx5/core/sf/sf.h
index 7b9071a865ce..555b19a5880d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -18,6 +18,14 @@ static inline u16 mlx5_sf_max_ports(const struct mlx5_co=
re_dev *dev)
 	return mlx5_sf_supported(dev) ? 1 << MLX5_CAP_GEN(dev, log_max_sf) : 0;
 }
=20
+int mlx5_sf_table_init(struct mlx5_core_dev *dev);
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
+
+int mlx5_devlink_sf_port_new(struct devlink *devlink, const struct devlink=
_port_new_attrs *add_attr,
+			     struct netlink_ext_ack *extack);
+int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_in=
dex,
+			     struct netlink_ext_ack *extack);
+
 #else
=20
 static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
@@ -30,6 +38,15 @@ static inline u16 mlx5_sf_max_ports(const struct mlx5_co=
re_dev *dev)
 	return 0;
 }
=20
+static inline int mlx5_sf_table_init(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
 #endif
=20
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f3104b50ade5..e625cb20ad76 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -509,6 +509,7 @@ struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
 struct mlx5_sf_dev_table;
+struct mlx5_sf_table;
=20
 struct mlx5_rate_limit {
 	u32			rate;
@@ -609,6 +610,9 @@ struct mlx5_priv {
 	struct mlx5_sf_dev_table *sf_dev_table;
 	struct mlx5_core_dev *parent_mdev;
 #endif
+#ifdef CONFIG_MLX5_SF_MANAGER
+	struct mlx5_sf_table *sf_table;
+#endif
 };
=20
 enum mlx5_device_state {
--=20
2.26.2

