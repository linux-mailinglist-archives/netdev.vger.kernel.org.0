Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCA9F3428
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbfKGQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:08:49 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53423 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727401AbfKGQIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:08:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:08:42 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4B007213;
        Thu, 7 Nov 2019 18:08:39 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 01/19] net/mlx5: E-switch, Move devlink port close to eswitch port
Date:   Thu,  7 Nov 2019 10:08:16 -0600
Message-Id: <20191107160834.21087-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160448.20962-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently devlink ports are tied to netdev representor.

mlx5_vport structure is better container of e-switch vport
compare to mlx5e_rep_priv.
This enables to extend mlx5_vport easily for mdev flavour.

Hence, move devlink_port from netdev representor to mlx5_vport.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 63 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  8 ++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 94 +++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 5 files changed, 88 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 381925c90d94..ce4278dfc101 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -226,3 +226,66 @@ void mlx5_devlink_unregister(struct devlink *devlink)
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
 }
+
+bool
+mlx5_devlink_port_supported(const struct mlx5_core_dev *dev,
+			    const struct mlx5_vport *vport)
+{
+	return vport->vport == MLX5_VPORT_UPLINK ||
+	       vport->vport == MLX5_VPORT_PF ||
+	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, vport->vport);
+}
+
+static unsigned int
+vport_to_devlink_port_index(const struct mlx5_core_dev *dev, u16 vport_num)
+{
+	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
+}
+
+static void get_port_switch_id(struct mlx5_core_dev *dev,
+			       struct netdev_phys_item_id *ppid)
+{
+	u64 parent_id;
+
+	parent_id = mlx5_query_nic_system_image_guid(dev);
+	ppid->id_len = sizeof(parent_id);
+	memcpy(ppid->id, &parent_id, sizeof(parent_id));
+}
+
+int mlx5_devlink_port_register(struct mlx5_core_dev *dev,
+			       struct mlx5_vport *vport)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	struct netdev_phys_item_id ppid = {};
+	unsigned int dl_port_index = 0;
+
+	if (!mlx5_devlink_port_supported(dev, vport))
+		return 0;
+
+	get_port_switch_id(dev, &ppid);
+	memset(&vport->dl_port, 0, sizeof(vport->dl_port));
+
+	dl_port_index = vport_to_devlink_port_index(dev, vport->vport);
+	if (vport->vport == MLX5_VPORT_UPLINK)
+		devlink_port_attrs_set(&vport->dl_port,
+				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				       PCI_FUNC(dev->pdev->devfn), false, 0,
+				       &ppid.id[0], ppid.id_len);
+	else if (vport->vport == MLX5_VPORT_PF)
+		devlink_port_attrs_pci_pf_set(&vport->dl_port,
+					      &ppid.id[0], ppid.id_len,
+					      dev->pdev->devfn);
+	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, vport->vport))
+		devlink_port_attrs_pci_vf_set(&vport->dl_port,
+					      &ppid.id[0], ppid.id_len,
+					      dev->pdev->devfn,
+					      vport->vport - 1);
+	return devlink_port_register(devlink, &vport->dl_port, dl_port_index);
+}
+
+void mlx5_devlink_port_unregister(struct mlx5_core_dev *dev,
+				  struct mlx5_vport *vport)
+{
+	if (mlx5_devlink_port_supported(dev, vport))
+		devlink_port_unregister(&vport->dl_port);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index d0ba03774ddf..b30ea3ca612b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -5,10 +5,18 @@
 #define __MLX5_DEVLINK_H__
 
 #include <net/devlink.h>
+#include "eswitch.h"
 
 struct devlink *mlx5_devlink_alloc(void);
 void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev);
 void mlx5_devlink_unregister(struct devlink *devlink);
 
+bool
+mlx5_devlink_port_supported(const struct mlx5_core_dev *dev,
+			    const struct mlx5_vport *vport);
+int mlx5_devlink_port_register(struct mlx5_core_dev *dev,
+			       struct mlx5_vport *vport);
+void mlx5_devlink_port_unregister(struct mlx5_core_dev *dev,
+				  struct mlx5_vport *vport);
 #endif /* __MLX5_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 95892a3b63a1..55f2a707c703 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -392,19 +392,6 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
 	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
 };
 
-static void mlx5e_rep_get_port_parent_id(struct net_device *dev,
-					 struct netdev_phys_item_id *ppid)
-{
-	struct mlx5e_priv *priv;
-	u64 parent_id;
-
-	priv = netdev_priv(dev);
-
-	parent_id = mlx5_query_nic_system_image_guid(priv->mdev);
-	ppid->id_len = sizeof(parent_id);
-	memcpy(ppid->id, &parent_id, sizeof(parent_id));
-}
-
 static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep)
 {
@@ -1356,8 +1343,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_vport *vport;
 
-	return &rpriv->dl_port;
+	vport = mlx5_eswitch_get_vport(mdev->priv.eswitch, rpriv->rep->vport);
+	return &vport->dl_port;
 }
 
 static const struct net_device_ops mlx5e_netdev_ops_rep = {
@@ -1792,64 +1782,6 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
 
-static bool
-is_devlink_port_supported(const struct mlx5_core_dev *dev,
-			  const struct mlx5e_rep_priv *rpriv)
-{
-	return rpriv->rep->vport == MLX5_VPORT_UPLINK ||
-	       rpriv->rep->vport == MLX5_VPORT_PF ||
-	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport);
-}
-
-static unsigned int
-vport_to_devlink_port_index(const struct mlx5_core_dev *dev, u16 vport_num)
-{
-	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
-}
-
-static int register_devlink_port(struct mlx5_core_dev *dev,
-				 struct mlx5e_rep_priv *rpriv)
-{
-	struct devlink *devlink = priv_to_devlink(dev);
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct netdev_phys_item_id ppid = {};
-	unsigned int dl_port_index = 0;
-
-	if (!is_devlink_port_supported(dev, rpriv))
-		return 0;
-
-	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
-
-	if (rep->vport == MLX5_VPORT_UPLINK) {
-		devlink_port_attrs_set(&rpriv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(dev->pdev->devfn), false, 0,
-				       &ppid.id[0], ppid.id_len);
-		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
-	} else if (rep->vport == MLX5_VPORT_PF) {
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn);
-		dl_port_index = rep->vport;
-	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
-					    rpriv->rep->vport)) {
-		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn,
-					      rep->vport - 1);
-		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
-	}
-
-	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
-}
-
-static void unregister_devlink_port(struct mlx5_core_dev *dev,
-				    struct mlx5e_rep_priv *rpriv)
-{
-	if (is_devlink_port_supported(dev, rpriv))
-		devlink_port_unregister(&rpriv->dl_port);
-}
-
 /* e-Switch vport representors */
 static int
 mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
@@ -1857,6 +1789,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	const struct mlx5e_profile *profile;
 	struct mlx5e_rep_priv *rpriv;
 	struct net_device *netdev;
+	struct mlx5_vport *vport;
 	int nch, err;
 
 	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
@@ -1901,7 +1834,8 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	err = register_devlink_port(dev, rpriv);
+	vport = mlx5_eswitch_get_vport(dev->priv.eswitch, rep->vport);
+	err = mlx5_devlink_port_register(dev, vport);
 	if (err) {
 		esw_warn(dev, "Failed to register devlink port %d\n",
 			 rep->vport);
@@ -1915,12 +1849,12 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_devlink_cleanup;
 	}
 
-	if (is_devlink_port_supported(dev, rpriv))
-		devlink_port_type_eth_set(&rpriv->dl_port, netdev);
+	if (mlx5_devlink_port_supported(dev, vport))
+		devlink_port_type_eth_set(&vport->dl_port, netdev);
 	return 0;
 
 err_devlink_cleanup:
-	unregister_devlink_port(dev, rpriv);
+	mlx5_devlink_port_unregister(dev, vport);
 
 err_neigh_cleanup:
 	mlx5e_rep_neigh_cleanup(rpriv);
@@ -1946,11 +1880,13 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *dev = priv->mdev;
 	void *ppriv = priv->ppriv;
+	struct mlx5_vport *vport;
 
-	if (is_devlink_port_supported(dev, rpriv))
-		devlink_port_type_clear(&rpriv->dl_port);
+	vport = mlx5_eswitch_get_vport(dev->priv.eswitch, rep->vport);
+	if (mlx5_devlink_port_supported(dev, vport))
+		devlink_port_type_clear(&vport->dl_port);
 	unregister_netdev(netdev);
-	unregister_devlink_port(dev, rpriv);
+	mlx5_devlink_port_unregister(dev, vport);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
 	if (rep->vport == MLX5_VPORT_UPLINK)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 31f83c8adcc9..bc15801ebefd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -39,6 +39,7 @@
 #include "eswitch.h"
 #include "en.h"
 #include "lib/port_tun.h"
+#include "devlink.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
 struct mlx5e_neigh_update_table {
@@ -90,7 +91,6 @@ struct mlx5e_rep_priv {
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
 	struct rtnl_link_stats64 prev_vf_vport_stats;
-	struct devlink_port dl_port;
 };
 
 static inline
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 920d8f529fb9..e27d372e1c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -138,6 +138,7 @@ struct mlx5_vport {
 
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
+	struct devlink_port dl_port;
 };
 
 enum offloads_fdb_flags {
-- 
2.19.2

