Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A923A2278
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFJDAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhFJDAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49C2A61420;
        Thu, 10 Jun 2021 02:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293903;
        bh=X1yP98FkjY1UA1MMqDjt+ZFRe7HpJdSo5xpU6bj76W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrSNVDhrPpr25Z4QWYgbSg53I+mFjuja7+MEmLfdS9Qxwaxl/0JpTzEAfZHvhkWxU
         8Na6vbnH8uy+0krQ1YbnhYikN+kCLyOg9MsBr7bXNAUosZItVUAMEmIrJWXypMCp8e
         vxILqA+TCpPhMZQJ0KgS6864iDwwKnxPgBvX3JBE01Ptg3lEHCFG5wM/5q6Zk7FbzZ
         68aLNn0uijKsdt2BWl3XrlFcAZH0yuL1A4E1M5hrBOhgR09ga6gmbIro6Bi5tN8a3X
         MZ4fdsdOJ4uX3l3D3giiXAcCxtYZN7Os1AE7mZ/8eGhAB2RbQzc6TpRpvONVwc76i2
         PsVSUbkAD7k3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5: Bridge, handle FDB events
Date:   Wed,  9 Jun 2021 19:58:08 -0700
Message-Id: <20210610025814.274607-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Hardware supported by mlx5 driver doesn't provide learning and requires the
driver to emulate all switch-like behavior in software. As such, all
packets by default go through miss path, appear on representor and get to
software bridge, if it is the upper device of the representor. This causes
bridge to process packet in software, learn the MAC address to FDB and send
SWITCHDEV_FDB_ADD_TO_DEVICE event to all subscribers.

In order to offload FDB entries in mlx5, register switchdev notifier
callback and implement support for both 'added_by_user' and dynamic FDB
entry SWITCHDEV_FDB_ADD_TO_DEVICE events asynchronously using new
mlx5_esw_bridge_offloads->wq ordered workqueue. In workqueue callback
offload the ingress rule (matching FDB entry MAC as packet source MAC) and
egress table rule (matching FDB entry MAC as destination MAC). For ingress
table rule also match source vport to ensure that only traffic coming from
expected bridge port is matched by offloaded rule. Save all the relevant
FDB entry data in struct mlx5_esw_bridge_fdb_entry instance and insert the
instance in new mlx5_esw_bridge->fdb_list list (for traversing all entries
by software ageing implementation in following patch) and in new
mlx5_esw_bridge->fdb_ht hash table for fast retrieval. Notify the bridge
that FDB entry has been offloaded by sending SWITCHDEV_FDB_OFFLOADED
notification.

Delete FDB entry on reception of SWITCHDEV_FDB_DEL_TO_DEVICE event.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  15 ++
 .../mellanox/mlx5/core/en/rep/bridge.c        | 150 ++++++++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 254 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   9 +
 4 files changed, 424 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 936a10f1942c..ea32136b30e7 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -12,6 +12,7 @@ Contents
 - `Enabling the driver and kconfig options`_
 - `Devlink info`_
 - `Devlink parameters`_
+- `Bridge offload`_
 - `mlx5 subfunction`_
 - `mlx5 function attributes`_
 - `Devlink health reporters`_
@@ -217,6 +218,20 @@ users try to enable them.
 
     $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
 
+Bridge offload
+==============
+The mlx5 driver implements support for offloading bridge rules when in switchdev
+mode. Linux bridge FDBs are automatically offloaded when mlx5 switchdev
+representor is attached to bridge.
+
+- Change device to switchdev mode::
+
+    $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
+
+- Attach mlx5 switchdev representor 'enp8s0f0' to bridge netdev 'bridge1'::
+
+    $ ip link set enp8s0f0 master bridge1
+
 mlx5 subfunction
 ================
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index de7a68488a9d..b34e9cb686e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -8,6 +8,13 @@
 #include "esw/bridge.h"
 #include "en_rep.h"
 
+struct mlx5_bridge_switchdev_fdb_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	bool add;
+};
+
 static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = container_of(nb,
@@ -65,6 +72,124 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+static void
+mlx5_esw_bridge_cleanup_switchdev_fdb_work(struct mlx5_bridge_switchdev_fdb_work *fdb_work)
+{
+	dev_put(fdb_work->dev);
+	kfree(fdb_work->fdb_info.addr);
+	kfree(fdb_work);
+}
+
+static void mlx5_esw_bridge_switchdev_fdb_event_work(struct work_struct *work)
+{
+	struct mlx5_bridge_switchdev_fdb_work *fdb_work =
+		container_of(work, struct mlx5_bridge_switchdev_fdb_work, work);
+	struct switchdev_notifier_fdb_info *fdb_info =
+		&fdb_work->fdb_info;
+	struct net_device *dev = fdb_work->dev;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	struct mlx5e_priv *priv;
+	u16 vport_num;
+
+	rtnl_lock();
+
+	priv = netdev_priv(dev);
+	rpriv = priv->ppriv;
+	vport_num = rpriv->rep->vport;
+	esw = priv->mdev->priv.eswitch;
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		goto out;
+
+	if (fdb_work->add)
+		mlx5_esw_bridge_fdb_create(dev, esw, vport, fdb_info);
+	else
+		mlx5_esw_bridge_fdb_remove(dev, esw, vport, fdb_info);
+
+out:
+	rtnl_unlock();
+	mlx5_esw_bridge_cleanup_switchdev_fdb_work(fdb_work);
+}
+
+static struct mlx5_bridge_switchdev_fdb_work *
+mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
+					struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct mlx5_bridge_switchdev_fdb_work *work;
+	u8 *addr;
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&work->work, mlx5_esw_bridge_switchdev_fdb_event_work);
+	memcpy(&work->fdb_info, fdb_info, sizeof(work->fdb_info));
+
+	addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!addr) {
+		kfree(work);
+		return ERR_PTR(-ENOMEM);
+	}
+	ether_addr_copy(addr, fdb_info->addr);
+	work->fdb_info.addr = addr;
+
+	dev_hold(dev);
+	work->dev = dev;
+	work->add = add;
+	return work;
+}
+
+static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
+					   unsigned long event, void *ptr)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = container_of(nb,
+								    struct mlx5_esw_bridge_offloads,
+								    nb);
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct mlx5_bridge_switchdev_fdb_work *work;
+	struct switchdev_notifier_info *info = ptr;
+	struct net_device *upper;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5e_eswitch_rep(dev))
+		return NOTIFY_DONE;
+	priv = netdev_priv(dev);
+	if (priv->mdev->priv.eswitch != br_offloads->esw)
+		return NOTIFY_DONE;
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		return NOTIFY_DONE;
+	if (!netif_is_bridge_master(upper))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+
+		work = mlx5_esw_bridge_init_switchdev_fdb_work(dev,
+							       event == SWITCHDEV_FDB_ADD_TO_DEVICE,
+							       fdb_info);
+		if (IS_ERR(work)) {
+			WARN_ONCE(1, "Failed to init switchdev work, err=%ld",
+				  PTR_ERR(work));
+			return notifier_from_errno(PTR_ERR(work));
+		}
+
+		queue_work(br_offloads->wq, &work->work);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads;
@@ -81,13 +206,34 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 		return;
 	}
 
+	br_offloads->wq = alloc_ordered_workqueue("mlx5_bridge_wq", 0);
+	if (!br_offloads->wq) {
+		esw_warn(mdev, "Failed to allocate bridge offloads workqueue\n");
+		goto err_alloc_wq;
+	}
+
+	br_offloads->nb.notifier_call = mlx5_esw_bridge_switchdev_event;
+	err = register_switchdev_notifier(&br_offloads->nb);
+	if (err) {
+		esw_warn(mdev, "Failed to register switchdev notifier (err=%d)\n", err);
+		goto err_register_swdev;
+	}
+
 	br_offloads->netdev_nb.notifier_call = mlx5_esw_bridge_switchdev_port_event;
 	err = register_netdevice_notifier(&br_offloads->netdev_nb);
 	if (err) {
 		esw_warn(mdev, "Failed to register bridge offloads netdevice notifier (err=%d)\n",
 			 err);
-		mlx5_esw_bridge_cleanup(esw);
+		goto err_register_netdev;
 	}
+	return;
+
+err_register_netdev:
+	unregister_switchdev_notifier(&br_offloads->nb);
+err_register_swdev:
+	destroy_workqueue(br_offloads->wq);
+err_alloc_wq:
+	mlx5_esw_bridge_cleanup(esw);
 }
 
 void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
@@ -102,6 +248,8 @@ void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_switchdev_notifier(&br_offloads->nb);
+	destroy_workqueue(br_offloads->wq);
 	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b503562f97d0..6dd47891189c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -3,6 +3,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/list.h>
+#include <linux/rhashtable.h>
 #include <net/switchdev.h>
 #include "bridge.h"
 #include "eswitch.h"
@@ -21,15 +22,53 @@ enum {
 	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
 };
 
+struct mlx5_esw_bridge_fdb_key {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+struct mlx5_esw_bridge_fdb_entry {
+	struct mlx5_esw_bridge_fdb_key key;
+	struct rhash_head ht_node;
+	struct list_head list;
+	u16 vport_num;
+
+	struct mlx5_flow_handle *ingress_handle;
+	struct mlx5_flow_handle *egress_handle;
+};
+
+static const struct rhashtable_params fdb_ht_params = {
+	.key_offset = offsetof(struct mlx5_esw_bridge_fdb_entry, key),
+	.key_len = sizeof(struct mlx5_esw_bridge_fdb_key),
+	.head_offset = offsetof(struct mlx5_esw_bridge_fdb_entry, ht_node),
+	.automatic_shrinking = true,
+};
+
 struct mlx5_esw_bridge {
 	int ifindex;
 	int refcnt;
 	struct list_head list;
+	struct mlx5_esw_bridge_offloads *br_offloads;
+
+	struct list_head fdb_list;
+	struct rhashtable fdb_ht;
 
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_mac_fg;
 };
 
+static void
+mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *addr, u16 vid,
+				   unsigned long val)
+{
+	struct switchdev_notifier_fdb_info send_info;
+
+	send_info.addr = addr;
+	send_info.vid = vid;
+	send_info.offloaded = true;
+	call_switchdev_notifiers(val, dev, &send_info.info, NULL);
+}
+
 static struct mlx5_flow_table *
 mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 {
@@ -128,6 +167,9 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	struct mlx5_flow_group *mac_fg;
 	int err;
 
+	if (!mlx5_eswitch_vport_match_metadata_enabled(br_offloads->esw))
+		return -EOPNOTSUPP;
+
 	ingress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE,
 						  MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
 						  br_offloads->esw);
@@ -194,6 +236,82 @@ mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 	mlx5_destroy_flow_table(bridge->egress_ft);
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u16 vid,
+				    struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+		.ft = bridge->egress_ft,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+	u8 *smac_v, *smac_c;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_2;
+
+	smac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
+			      outer_headers.smac_47_16);
+	ether_addr_copy(smac_v, addr);
+	smac_c = MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
+			      outer_headers.smac_47_16);
+	eth_broadcast_addr(smac_c);
+
+	MLX5_SET(fte_match_param, rule_spec->match_criteria,
+		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
+
+	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr, u16 vid,
+				   struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_VPORT,
+		.vport.num = vport_num,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+	u8 *dmac_v, *dmac_c;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	dmac_v = MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
+			      outer_headers.dmac_47_16);
+	ether_addr_copy(dmac_v, addr);
+	dmac_c = MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
+			      outer_headers.dmac_47_16);
+	eth_broadcast_addr(dmac_c);
+
+	handle = mlx5_add_flow_rules(bridge->egress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
 static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 						      struct mlx5_esw_bridge_offloads *br_offloads)
 {
@@ -204,16 +322,24 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 	if (!bridge)
 		return ERR_PTR(-ENOMEM);
 
+	bridge->br_offloads = br_offloads;
 	err = mlx5_esw_bridge_egress_table_init(br_offloads, bridge);
 	if (err)
 		goto err_egress_tbl;
 
+	err = rhashtable_init(&bridge->fdb_ht, &fdb_ht_params);
+	if (err)
+		goto err_fdb_ht;
+
+	INIT_LIST_HEAD(&bridge->fdb_list);
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
 	list_add(&bridge->list, &br_offloads->bridges);
 
 	return bridge;
 
+err_fdb_ht:
+	mlx5_esw_bridge_egress_table_cleanup(bridge);
 err_egress_tbl:
 	kvfree(bridge);
 	return ERR_PTR(err);
@@ -232,6 +358,7 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
 	list_del(&bridge->list);
+	rhashtable_destroy(&bridge->fdb_ht);
 	kvfree(bridge);
 
 	if (list_empty(&br_offloads->bridges))
@@ -265,6 +392,69 @@ mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads
 	return bridge;
 }
 
+static void
+mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
+				  struct mlx5_esw_bridge *bridge)
+{
+	rhashtable_remove_fast(&bridge->fdb_ht, &entry->ht_node, fdb_ht_params);
+	mlx5_del_flow_rules(entry->egress_handle);
+	mlx5_del_flow_rules(entry->ingress_handle);
+	list_del(&entry->list);
+	kvfree(entry);
+}
+
+static struct mlx5_esw_bridge_fdb_entry *
+mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsigned char *addr,
+			       u16 vid, struct mlx5_eswitch *esw, struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry;
+	struct mlx5_flow_handle *handle;
+	int err;
+
+	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	ether_addr_copy(entry->key.addr, addr);
+	entry->key.vid = vid;
+	entry->vport_num = vport_num;
+
+	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vid, bridge);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		esw_warn(esw->dev, "Failed to create ingress flow(vport=%u,err=%d)\n",
+			 vport_num, err);
+		goto err_ingress_flow_create;
+	}
+	entry->ingress_handle = handle;
+
+	handle = mlx5_esw_bridge_egress_flow_create(vport_num, addr, vid, bridge);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		esw_warn(esw->dev, "Failed to create egress flow(vport=%u,err=%d)\n",
+			 vport_num, err);
+		goto err_egress_flow_create;
+	}
+	entry->egress_handle = handle;
+
+	err = rhashtable_insert_fast(&bridge->fdb_ht, &entry->ht_node, fdb_ht_params);
+	if (err) {
+		esw_warn(esw->dev, "Failed to insert FDB flow(vport=%u,err=%d)\n", vport_num, err);
+		goto err_ht_init;
+	}
+
+	list_add(&entry->list, &bridge->fdb_list);
+	return entry;
+
+err_ht_init:
+	mlx5_del_flow_rules(entry->egress_handle);
+err_egress_flow_create:
+	mlx5_del_flow_rules(entry->ingress_handle);
+err_ingress_flow_create:
+	kvfree(entry);
+	return ERR_PTR(err);
+}
+
 static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge *bridge,
 				      struct mlx5_vport *vport)
 {
@@ -275,7 +465,14 @@ static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge *bridge,
 static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_offloads,
 					 struct mlx5_vport *vport)
 {
-	mlx5_esw_bridge_put(br_offloads, vport->bridge);
+	struct mlx5_esw_bridge *bridge = vport->bridge;
+	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list)
+		if (entry->vport_num == vport->vport)
+			mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+
+	mlx5_esw_bridge_put(br_offloads, bridge);
 	vport->bridge = NULL;
 	return 0;
 }
@@ -299,11 +496,13 @@ int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_
 int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct mlx5_vport *vport, struct netlink_ext_ack *extack)
 {
-	if (!vport->bridge) {
+	struct mlx5_esw_bridge *bridge = vport->bridge;
+
+	if (!bridge) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
 		return -EINVAL;
 	}
-	if (vport->bridge->ifindex != ifindex) {
+	if (bridge->ifindex != ifindex) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is attached to another bridge");
 		return -EINVAL;
 	}
@@ -311,6 +510,55 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *b
 	return mlx5_esw_bridge_vport_cleanup(br_offloads, vport);
 }
 
+void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw,
+				struct mlx5_vport *vport,
+				struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct mlx5_esw_bridge *bridge = vport->bridge;
+	struct mlx5_esw_bridge_fdb_entry *entry;
+	u16 vport_num = vport->vport;
+
+	if (!bridge) {
+		esw_info(esw->dev, "Vport is not assigned to bridge (vport=%u)\n", vport_num);
+		return;
+	}
+
+	entry = mlx5_esw_bridge_fdb_entry_init(dev, vport_num, fdb_info->addr, fdb_info->vid,
+					       esw, bridge);
+	if (IS_ERR(entry))
+		return;
+
+	mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
+					   SWITCHDEV_FDB_OFFLOADED);
+}
+
+void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw,
+				struct mlx5_vport *vport,
+				struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct mlx5_esw_bridge *bridge = vport->bridge;
+	struct mlx5_esw_bridge_fdb_entry *entry;
+	struct mlx5_esw_bridge_fdb_key key;
+	u16 vport_num = vport->vport;
+
+	if (!bridge) {
+		esw_warn(esw->dev, "Vport is not assigned to bridge (vport=%u)\n", vport_num);
+		return;
+	}
+
+	ether_addr_copy(key.addr, fdb_info->addr);
+	key.vid = fdb_info->vid;
+	entry = rhashtable_lookup_fast(&bridge->fdb_ht, &key, fdb_ht_params);
+	if (!entry) {
+		esw_warn(esw->dev,
+			 "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
+			 key.addr, key.vid, vport_num);
+		return;
+	}
+
+	mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+}
+
 static void mlx5_esw_bridge_flush(struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_eswitch *esw = br_offloads->esw;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 319b6f1db0ba..cec118c0b733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -10,11 +10,14 @@
 
 struct mlx5_flow_table;
 struct mlx5_flow_group;
+struct workqueue_struct;
 
 struct mlx5_esw_bridge_offloads {
 	struct mlx5_eswitch *esw;
 	struct list_head bridges;
 	struct notifier_block netdev_nb;
+	struct notifier_block nb;
+	struct workqueue_struct *wq;
 
 	struct mlx5_flow_table *ingress_ft;
 	struct mlx5_flow_group *ingress_mac_fg;
@@ -26,5 +29,11 @@ int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_
 			       struct mlx5_vport *vport, struct netlink_ext_ack *extack);
 int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct mlx5_vport *vport, struct netlink_ext_ack *extack);
+void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw,
+				struct mlx5_vport *vport,
+				struct switchdev_notifier_fdb_info *fdb_info);
+void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw,
+				struct mlx5_vport *vport,
+				struct switchdev_notifier_fdb_info *fdb_info);
 
 #endif /* __MLX5_ESW_BRIDGE_H__ */
-- 
2.31.1

