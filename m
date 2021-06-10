Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D733A227B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFJDAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhFJDAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650B761422;
        Thu, 10 Jun 2021 02:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293904;
        bh=Hak2/Yyahiz+msqQVo5SZ1TBp7Y6mJblwIbplDLrxcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N35Dlh7NnA0snBmtHahDnbuQMuAZkTJOIYkuHCQq1ccjlkdBEOJHCWgXzz9pVJ69n
         1xhA3cvt92heWGSG1pd5AtxQG8IdZrCXmz2o0thUHgSCH7x8PGCci3reou9sZqh6IV
         m7ap0oM05CZYcfKZVM7KxrQ2FNGFg5TEvlCK+iM5e33OquRe9IN9N8rGBzgxsyfiG2
         dM9F0TnVyNOsVMWvH9e9oECWsAnsd/gmNe+WYmnhggDKHEhSQMfbRwk0SXWkiQj7G8
         s2tdWVHK+AreZZKF4hPOPpby1Bp4ufJD3mUtyYpNYTlug+Dd3e4vKeF+Vm4B3lyo7A
         dd1y1r3KLIQ2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: Bridge, implement infrastructure for vlans
Date:   Wed,  9 Jun 2021 19:58:10 -0700
Message-Id: <20210610025814.274607-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Establish all the necessary infrastructure for implementing vlan matching
and vlan push/pop in following patches:

- Add new per-vport struct mlx5_esw_bridge_port that is used to store
metadata for all port vlans. Initialize and cleanup the instance of the
structure when port representor is linked/unliked to bridge. Use xarray to
allow quick vport metadata lookup by vport number.

- Add new per-port-vlan struct mlx5_esw_bridge_vlan that is used to store
vlan-specific data (vid, flags). Handle SWITCHDEV_PORT_OBJ_{ADD|DEL}
switchdev blocking event for SWITCHDEV_OBJ_ID_PORT_VLAN object by
creating/deleting the vlan structure and saving it in per-vport xarray for
quick lookup.

- Implement support for SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING object
attribute that is used to toggle vlan filtering. Remove all FDB entries
from hardware when vlan filtering state is changed.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  73 ++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 211 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   5 +
 3 files changed, 286 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 14645f24671f..7f5efc1b4392 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -75,6 +75,66 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+static int mlx5_esw_bridge_port_obj_add(struct net_device *dev,
+					const struct switchdev_obj *obj,
+					struct netlink_ext_ack *extack)
+{
+	const struct switchdev_obj_port_vlan *vlan;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	struct mlx5e_priv *priv;
+	u16 vport_num;
+	int err = 0;
+
+	priv = netdev_priv(dev);
+	rpriv = priv->ppriv;
+	vport_num = rpriv->rep->vport;
+	esw = priv->mdev->priv.eswitch;
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		err = mlx5_esw_bridge_port_vlan_add(vlan->vid, vlan->flags, esw, vport, extack);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return err;
+}
+
+static int mlx5_esw_bridge_port_obj_del(struct net_device *dev,
+					const struct switchdev_obj *obj)
+{
+	const struct switchdev_obj_port_vlan *vlan;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	struct mlx5e_priv *priv;
+	u16 vport_num;
+
+	priv = netdev_priv(dev);
+	rpriv = priv->ppriv;
+	vport_num = rpriv->rep->vport;
+	esw = priv->mdev->priv.eswitch;
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		mlx5_esw_bridge_port_vlan_del(vlan->vid, esw, vport);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static int mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 					     const struct switchdev_attr *attr,
 					     struct netlink_ext_ack *extack)
@@ -106,6 +166,9 @@ static int mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		err = mlx5_esw_bridge_ageing_time_set(attr->u.ageing_time, esw, vport);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		err = mlx5_esw_bridge_vlan_filtering_set(attr->u.vlan_filtering, esw, vport);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
@@ -120,6 +183,16 @@ static int mlx5_esw_bridge_event_blocking(struct notifier_block *unused,
 	int err;
 
 	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    mlx5e_eswitch_rep,
+						    mlx5_esw_bridge_port_obj_add);
+		break;
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    mlx5e_eswitch_rep,
+						    mlx5_esw_bridge_port_obj_del);
+		break;
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     mlx5e_eswitch_rep,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 557dac5e9745..eec5897c6b79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/list.h>
 #include <linux/rhashtable.h>
+#include <linux/xarray.h>
 #include <linux/if_bridge.h>
 #include <net/switchdev.h>
 #include "bridge.h"
@@ -53,6 +54,20 @@ static const struct rhashtable_params fdb_ht_params = {
 	.automatic_shrinking = true,
 };
 
+struct mlx5_esw_bridge_vlan {
+	u16 vid;
+	u16 flags;
+};
+
+struct mlx5_esw_bridge_port {
+	u16 vport_num;
+	struct xarray vlans;
+};
+
+enum {
+	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
+};
+
 struct mlx5_esw_bridge {
 	int ifindex;
 	int refcnt;
@@ -61,10 +76,12 @@ struct mlx5_esw_bridge {
 
 	struct list_head fdb_list;
 	struct rhashtable fdb_ht;
+	struct xarray vports;
 
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_mac_fg;
 	unsigned long ageing_time;
+	u32 flags;
 };
 
 static void
@@ -345,6 +362,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 		goto err_fdb_ht;
 
 	INIT_LIST_HEAD(&bridge->fdb_list);
+	xa_init(&bridge->vports);
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
 	bridge->ageing_time = BR_DEFAULT_AGEING_TIME;
@@ -371,6 +389,7 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 		return;
 
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
+	WARN_ON(!xa_empty(&bridge->vports));
 	list_del(&bridge->list);
 	rhashtable_destroy(&bridge->fdb_ht);
 	kvfree(bridge);
@@ -406,6 +425,24 @@ mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads
 	return bridge;
 }
 
+static int mlx5_esw_bridge_port_insert(struct mlx5_esw_bridge_port *port,
+				       struct mlx5_esw_bridge *bridge)
+{
+	return xa_insert(&bridge->vports, port->vport_num, port, GFP_KERNEL);
+}
+
+static struct mlx5_esw_bridge_port *
+mlx5_esw_bridge_port_lookup(u16 vport_num, struct mlx5_esw_bridge *bridge)
+{
+	return xa_load(&bridge->vports, vport_num);
+}
+
+static void mlx5_esw_bridge_port_erase(struct mlx5_esw_bridge_port *port,
+				       struct mlx5_esw_bridge *bridge)
+{
+	xa_erase(&bridge->vports, port->vport_num);
+}
+
 static void
 mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 				  struct mlx5_esw_bridge *bridge)
@@ -418,6 +455,68 @@ mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 	kvfree(entry);
 }
 
+static void mlx5_esw_bridge_fdb_flush(struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list) {
+		if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
+			mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+							   entry->key.vid,
+							   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+	}
+}
+
+static struct mlx5_esw_bridge_vlan *
+mlx5_esw_bridge_vlan_lookup(u16 vid, struct mlx5_esw_bridge_port *port)
+{
+	return xa_load(&port->vlans, vid);
+}
+
+static struct mlx5_esw_bridge_vlan *
+mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_esw_bridge_vlan *vlan;
+	int err;
+
+	vlan = kvzalloc(sizeof(*vlan), GFP_KERNEL);
+	if (!vlan)
+		return ERR_PTR(-ENOMEM);
+
+	vlan->vid = vid;
+	vlan->flags = flags;
+	err = xa_insert(&port->vlans, vid, vlan, GFP_KERNEL);
+	if (err) {
+		kvfree(vlan);
+		return ERR_PTR(err);
+	}
+
+	return vlan;
+}
+
+static void mlx5_esw_bridge_vlan_erase(struct mlx5_esw_bridge_port *port,
+				       struct mlx5_esw_bridge_vlan *vlan)
+{
+	xa_erase(&port->vlans, vlan->vid);
+}
+
+static void mlx5_esw_bridge_vlan_cleanup(struct mlx5_esw_bridge_port *port,
+					 struct mlx5_esw_bridge_vlan *vlan)
+{
+	mlx5_esw_bridge_vlan_erase(port, vlan);
+	kvfree(vlan);
+}
+
+static void mlx5_esw_bridge_port_vlans_flush(struct mlx5_esw_bridge_port *port)
+{
+	struct mlx5_esw_bridge_vlan *vlan;
+	unsigned long index;
+
+	xa_for_each(&port->vlans, index, vlan)
+		mlx5_esw_bridge_vlan_cleanup(port, vlan);
+}
+
 static struct mlx5_esw_bridge_fdb_entry *
 mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsigned char *addr,
 			       u16 vid, bool added_by_user, struct mlx5_eswitch *esw,
@@ -498,11 +597,60 @@ int mlx5_esw_bridge_ageing_time_set(unsigned long ageing_time, struct mlx5_eswit
 	return 0;
 }
 
-static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge *bridge,
+int mlx5_esw_bridge_vlan_filtering_set(bool enable, struct mlx5_eswitch *esw,
+				       struct mlx5_vport *vport)
+{
+	struct mlx5_esw_bridge *bridge;
+	bool filtering;
+
+	if (!vport->bridge)
+		return -EINVAL;
+
+	bridge = vport->bridge;
+	filtering = bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
+	if (filtering == enable)
+		return 0;
+
+	mlx5_esw_bridge_fdb_flush(bridge);
+	if (enable)
+		bridge->flags |= MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
+	else
+		bridge->flags &= ~MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
+
+	return 0;
+}
+
+static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge_offloads *br_offloads,
+				      struct mlx5_esw_bridge *bridge,
 				      struct mlx5_vport *vport)
 {
+	struct mlx5_eswitch *esw = br_offloads->esw;
+	struct mlx5_esw_bridge_port *port;
+	int err;
+
+	port = kvzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port) {
+		err = -ENOMEM;
+		goto err_port_alloc;
+	}
+
+	port->vport_num = vport->vport;
+	xa_init(&port->vlans);
+	err = mlx5_esw_bridge_port_insert(port, bridge);
+	if (err) {
+		esw_warn(esw->dev, "Failed to insert port metadata (vport=%u,err=%d)\n",
+			 vport->vport, err);
+		goto err_port_insert;
+	}
+
 	vport->bridge = bridge;
 	return 0;
+
+err_port_insert:
+	kvfree(port);
+err_port_alloc:
+	mlx5_esw_bridge_put(br_offloads, bridge);
+	return err;
 }
 
 static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_offloads,
@@ -510,11 +658,21 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 {
 	struct mlx5_esw_bridge *bridge = vport->bridge;
 	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
+	struct mlx5_esw_bridge_port *port;
 
 	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list)
 		if (entry->vport_num == vport->vport)
 			mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 
+	port = mlx5_esw_bridge_port_lookup(vport->vport, bridge);
+	if (!port) {
+		WARN(1, "Vport %u metadata not found on bridge", vport->vport);
+		return -EINVAL;
+	}
+
+	mlx5_esw_bridge_port_vlans_flush(port);
+	mlx5_esw_bridge_port_erase(port, bridge);
+	kvfree(port);
 	mlx5_esw_bridge_put(br_offloads, bridge);
 	vport->bridge = NULL;
 	return 0;
@@ -524,6 +682,7 @@ int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_
 			       struct mlx5_vport *vport, struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_bridge *bridge;
+	int err;
 
 	WARN_ON(vport->bridge);
 
@@ -533,13 +692,17 @@ int mlx5_esw_bridge_vport_link(int ifindex, struct mlx5_esw_bridge_offloads *br_
 		return PTR_ERR(bridge);
 	}
 
-	return mlx5_esw_bridge_vport_init(bridge, vport);
+	err = mlx5_esw_bridge_vport_init(br_offloads, bridge, vport);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "Error initializing port");
+	return err;
 }
 
 int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct mlx5_vport *vport, struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_bridge *bridge = vport->bridge;
+	int err;
 
 	if (!bridge) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
@@ -550,7 +713,49 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, struct mlx5_esw_bridge_offloads *b
 		return -EINVAL;
 	}
 
-	return mlx5_esw_bridge_vport_cleanup(br_offloads, vport);
+	err = mlx5_esw_bridge_vport_cleanup(br_offloads, vport);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "Port cleanup failed");
+	return err;
+}
+
+int mlx5_esw_bridge_port_vlan_add(u16 vid, u16 flags, struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport, struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge_vlan *vlan;
+
+	port = mlx5_esw_bridge_port_lookup(vport->vport, vport->bridge);
+	if (!port)
+		return -EINVAL;
+
+	vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
+	if (vlan) {
+		vlan->flags = flags;
+		return 0;
+	}
+
+	vlan = mlx5_esw_bridge_vlan_create(vid, flags, port);
+	if (IS_ERR(vlan)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to create VLAN entry");
+		return PTR_ERR(vlan);
+	}
+	return 0;
+}
+
+void mlx5_esw_bridge_port_vlan_del(u16 vid, struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge_vlan *vlan;
+
+	port = mlx5_esw_bridge_port_lookup(vport->vport, vport->bridge);
+	if (!port)
+		return;
+
+	vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
+	if (!vlan)
+		return;
+	mlx5_esw_bridge_vlan_cleanup(port, vlan);
 }
 
 void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 07726ae55b2b..276ed0392607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -40,5 +40,10 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw
 void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_ageing_time_set(unsigned long ageing_time, struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport);
+int mlx5_esw_bridge_vlan_filtering_set(bool enable, struct mlx5_eswitch *esw,
+				       struct mlx5_vport *vport);
+int mlx5_esw_bridge_port_vlan_add(u16 vid, u16 flags, struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport, struct netlink_ext_ack *extack);
+void mlx5_esw_bridge_port_vlan_del(u16 vid, struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
 #endif /* __MLX5_ESW_BRIDGE_H__ */
-- 
2.31.1

