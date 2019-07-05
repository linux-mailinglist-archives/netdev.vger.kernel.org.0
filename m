Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6ED960192
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfGEHhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 03:37:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54374 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727839AbfGEHhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 03:37:32 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 10:37:28 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x657bMue009352;
        Fri, 5 Jul 2019 10:37:27 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v2 3/3] net/mlx5e: Register devlink ports for physical link, PCI PF, VFs
Date:   Fri,  5 Jul 2019 02:37:11 -0500
Message-Id: <20190705073711.37854-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190705073711.37854-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190705073711.37854-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register devlink port of physical port, PCI PF and PCI VF flavour
for each PF, VF when a given devlink instance is in switchdev mode.

Implement ndo_get_devlink_port callback API to make use of registered
devlink ports.
This eliminates ndo_get_phys_port_name() and ndo_get_port_parent_id()
callbacks. Hence, remove them.

An example output with 2 VFs, without a PF and single uplink port is
below.

$devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0 flavour physical
pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1

Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
Changelog:
v1->v2:
 - Updated to use simpler API without port_number
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 108 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 2 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6a013a8c1150..ce50d8c9df03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -37,6 +37,7 @@
 #include <net/act_api.h>
 #include <net/netevent.h>
 #include <net/arp.h>
+#include <net/devlink.h>
 
 #include "eswitch.h"
 #include "en.h"
@@ -1119,32 +1120,6 @@ static int mlx5e_rep_close(struct net_device *dev)
 	return ret;
 }
 
-static int mlx5e_rep_get_phys_port_name(struct net_device *dev,
-					char *buf, size_t len)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	unsigned int fn;
-	int ret;
-
-	fn = PCI_FUNC(priv->mdev->pdev->devfn);
-	if (fn >= MLX5_MAX_PORTS)
-		return -EOPNOTSUPP;
-
-	if (rep->vport == MLX5_VPORT_UPLINK)
-		ret = snprintf(buf, len, "p%d", fn);
-	else if (rep->vport == MLX5_VPORT_PF)
-		ret = snprintf(buf, len, "pf%d", fn);
-	else
-		ret = snprintf(buf, len, "pf%dvf%d", fn, rep->vport - 1);
-
-	if (ret >= len)
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
 static int
 mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *priv,
 			      struct tc_cls_flower_offload *cls_flower, int flags)
@@ -1298,17 +1273,24 @@ static int mlx5e_uplink_rep_set_vf_vlan(struct net_device *dev, int vf, u16 vlan
 	return 0;
 }
 
+static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	return &rpriv->dl_port;
+}
+
 static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_open                = mlx5e_rep_open,
 	.ndo_stop                = mlx5e_rep_close,
 	.ndo_start_xmit          = mlx5e_xmit,
-	.ndo_get_phys_port_name  = mlx5e_rep_get_phys_port_name,
 	.ndo_setup_tc            = mlx5e_rep_setup_tc,
+	.ndo_get_devlink_port = mlx5e_get_devlink_port,
 	.ndo_get_stats64         = mlx5e_rep_get_stats,
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_rep_change_mtu,
-	.ndo_get_port_parent_id	 = mlx5e_rep_get_port_parent_id,
 };
 
 static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
@@ -1316,8 +1298,8 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_stop                = mlx5e_close,
 	.ndo_start_xmit          = mlx5e_xmit,
 	.ndo_set_mac_address     = mlx5e_uplink_rep_set_mac,
-	.ndo_get_phys_port_name  = mlx5e_rep_get_phys_port_name,
 	.ndo_setup_tc            = mlx5e_rep_setup_tc,
+	.ndo_get_devlink_port = mlx5e_get_devlink_port,
 	.ndo_get_stats64         = mlx5e_get_stats,
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
@@ -1330,7 +1312,6 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_get_vf_config       = mlx5e_get_vf_config,
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 	.ndo_set_vf_vlan         = mlx5e_uplink_rep_set_vf_vlan,
-	.ndo_get_port_parent_id	 = mlx5e_rep_get_port_parent_id,
 	.ndo_set_features        = mlx5e_set_features,
 };
 
@@ -1731,6 +1712,55 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.max_tc			= MLX5E_MAX_NUM_TC,
 };
 
+static bool
+is_devlink_port_supported(const struct mlx5_core_dev *dev,
+			  const struct mlx5e_rep_priv *rpriv)
+{
+	return rpriv->rep->vport == MLX5_VPORT_UPLINK ||
+	       rpriv->rep->vport == MLX5_VPORT_PF ||
+	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport);
+}
+
+static int register_devlink_port(struct mlx5_core_dev *dev,
+				 struct mlx5e_rep_priv *rpriv)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct netdev_phys_item_id ppid = {};
+	int ret;
+
+	if (!is_devlink_port_supported(dev, rpriv))
+		return 0;
+
+	ret = mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
+	if (ret)
+		return ret;
+
+	if (rep->vport == MLX5_VPORT_UPLINK)
+		devlink_port_attrs_set(&rpriv->dl_port,
+				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				       PCI_FUNC(dev->pdev->devfn), false, 0,
+				       &ppid.id[0], ppid.id_len);
+	else if (rep->vport == MLX5_VPORT_PF)
+		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
+					      &ppid.id[0], ppid.id_len,
+					      dev->pdev->devfn);
+	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
+		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
+					      &ppid.id[0], ppid.id_len,
+					      dev->pdev->devfn,
+					      rep->vport - 1);
+
+	return devlink_port_register(devlink, &rpriv->dl_port, rep->vport);
+}
+
+static void unregister_devlink_port(struct mlx5_core_dev *dev,
+				    struct mlx5e_rep_priv *rpriv)
+{
+	if (is_devlink_port_supported(dev, rpriv))
+		devlink_port_unregister(&rpriv->dl_port);
+}
+
 /* e-Switch vport representors */
 static int
 mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
@@ -1782,15 +1812,27 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
+	err = register_devlink_port(dev, rpriv);
+	if (err) {
+		esw_warn(dev, "Failed to register devlink port %d\n",
+			 rep->vport);
+		goto err_neigh_cleanup;
+	}
+
 	err = register_netdev(netdev);
 	if (err) {
 		pr_warn("Failed to register representor netdev for vport %d\n",
 			rep->vport);
-		goto err_neigh_cleanup;
+		goto err_devlink_cleanup;
 	}
 
+	if (is_devlink_port_supported(dev, rpriv))
+		devlink_port_type_eth_set(&rpriv->dl_port, netdev);
 	return 0;
 
+err_devlink_cleanup:
+	unregister_devlink_port(dev, rpriv);
+
 err_neigh_cleanup:
 	mlx5e_rep_neigh_cleanup(rpriv);
 
@@ -1813,9 +1855,13 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *dev = priv->mdev;
 	void *ppriv = priv->ppriv;
 
+	if (is_devlink_port_supported(dev, rpriv))
+		devlink_port_type_clear(&rpriv->dl_port);
 	unregister_netdev(netdev);
+	unregister_devlink_port(dev, rpriv);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
 	if (rep->vport == MLX5_VPORT_UPLINK)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index d4585f3b8cb2..c56e6ee4350c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -86,6 +86,7 @@ struct mlx5e_rep_priv {
 	struct mlx5_flow_handle *vport_rx_rule;
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
+	struct devlink_port dl_port;
 };
 
 static inline
-- 
2.19.2

