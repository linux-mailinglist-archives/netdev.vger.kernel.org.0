Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522E8F50E8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKHQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:21 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60379 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727221AbfKHQTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:21 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:15 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GJD8G005720;
        Fri, 8 Nov 2019 18:19:14 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GJDnS030109;
        Fri, 8 Nov 2019 18:19:13 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GJDUH030108;
        Fri, 8 Nov 2019 18:19:13 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 10/10] net/mlx5e: Add support for devlink subdev and subdev hw_addr set/show
Date:   Fri,  8 Nov 2019 18:18:46 +0200
Message-Id: <1573229926-30040-11-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add subdev creation and implement get/set ops for subdev hw_addr.
Add subdev linkage to devlink port registration.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 92 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  5 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 19 +++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  8 ++
 7 files changed, 136 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 381925c90d94..c1615a5feed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -226,3 +226,95 @@ void mlx5_devlink_unregister(struct devlink *devlink)
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
 }
+
+static int
+mlx5_devlink_mac_set(struct devlink_subdev *devlink_subdev, u8 *mac,
+		     struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_subdev_priv(devlink_subdev);
+
+	return mlx5_eswitch_set_vport_mac(vport->dev->priv.eswitch,
+					 vport->vport, mac, extack);
+}
+
+static int
+mlx5_devlink_mac_get(struct devlink_subdev *devlink_subdev, u8 *mac,
+		     struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_subdev_priv(devlink_subdev);
+	struct ifla_vf_info ivi;
+	int err;
+
+	vport = devlink_subdev_priv(devlink_subdev);
+
+	err = mlx5_eswitch_get_vport_config(vport->dev->priv.eswitch,
+					    vport->vport, &ivi, extack);
+	if (!err)
+		ether_addr_copy(mac, ivi.mac);
+
+	return err;
+}
+
+static struct devlink_subdev_ops subdev_ops = {
+	.hw_addr_set = mlx5_devlink_mac_set,
+	.hw_addr_get = mlx5_devlink_mac_get,
+	.hw_addr_len = ETH_ALEN,
+};
+
+int mlx5_devlink_subdevs_create(struct mlx5_eswitch *esw)
+{
+	struct devlink *devlink = priv_to_devlink(esw->dev);
+	struct mlx5_vport *vport;
+	int err;
+	int i;
+
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		struct devlink_subdev *devlink_subdev;
+		struct devlink_subdev_attrs attrs;
+		int subdev_idx;
+
+		if (IS_ERR(vport)) {
+			err = PTR_ERR(vport);
+			goto err_dl_destroy;
+		}
+
+		if (vport->vport == MLX5_VPORT_UPLINK)
+			continue;
+		if (vport->vport == mlx5_eswitch_manager_vport(esw->dev))
+			continue;
+
+		subdev_idx = vport->vport;
+		if (mlx5_eswitch_is_vf_vport(esw, subdev_idx))
+			devlink_subdev_attrs_pci_vf_init(&attrs, 0,
+							 subdev_idx - 1);
+		else
+			devlink_subdev_attrs_pci_pf_init(&attrs, subdev_idx);
+
+		devlink_subdev = devlink_subdev_create(devlink, subdev_idx,
+						       &subdev_ops, &attrs,
+						       vport);
+		if (IS_ERR(devlink_subdev)) {
+			err = PTR_ERR(devlink_subdev);
+			goto err_dl_destroy;
+		}
+		vport->devlink_subdev = devlink_subdev;
+	}
+
+	return 0;
+
+err_dl_destroy:
+	mlx5_devlink_subdevs_destroy(esw);
+	return err;
+}
+
+void mlx5_devlink_subdevs_destroy(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	int i;
+
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		if (vport->devlink_subdev)
+			devlink_subdev_destroy(vport->devlink_subdev);
+	}
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index d0ba03774ddf..d0be2ad5e34b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -6,9 +6,14 @@
 
 #include <net/devlink.h>
 
+struct mlx5_eswitch;
+
 struct devlink *mlx5_devlink_alloc(void);
 void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev);
 void mlx5_devlink_unregister(struct devlink *devlink);
 
+int mlx5_devlink_subdevs_create(struct mlx5_eswitch *esw);
+void mlx5_devlink_subdevs_destroy(struct mlx5_eswitch *esw);
+
 #endif /* __MLX5_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 772bfdbdeb9c..429672f69b6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4054,7 +4054,8 @@ int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	return mlx5_eswitch_set_vport_mac(mdev->priv.eswitch, vf + 1, mac);
+	return mlx5_eswitch_set_vport_mac(mdev->priv.eswitch, vf + 1,
+					  mac, NULL);
 }
 
 static int mlx5e_set_vf_vlan(struct net_device *dev, int vf, u16 vlan, u8 qos,
@@ -4135,7 +4136,8 @@ int mlx5e_get_vf_config(struct net_device *dev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	err = mlx5_eswitch_get_vport_config(mdev->priv.eswitch, vf + 1, ivi);
+	err = mlx5_eswitch_get_vport_config(mdev->priv.eswitch, vf + 1,
+					    ivi, NULL);
 	if (err)
 		return err;
 	ivi->linkstate = mlx5_vport_link2ifla(ivi->linkstate);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index cd9bb7c7b341..eefb38dd3c79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1812,8 +1812,10 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct devlink_subdev *devlink_subdev = NULL;
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	struct mlx5_vport *vport;
 
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
@@ -1831,6 +1833,8 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 					      &ppid.id[0], ppid.id_len,
 					      dev->pdev->devfn);
 		dl_port_index = rep->vport;
+		vport = mlx5_eswitch_get_vport(dev->priv.eswitch, rep->vport);
+		devlink_subdev = vport->devlink_subdev;
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
 					    rpriv->rep->vport)) {
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
@@ -1838,9 +1842,12 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 					      dev->pdev->devfn,
 					      rep->vport - 1);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
+		vport = mlx5_eswitch_get_vport(dev->priv.eswitch, rep->vport);
+		devlink_subdev = vport->devlink_subdev;
 	}
 
-	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
+	return devlink_port_register_with_subdev(devlink, &rpriv->dl_port,
+					       dl_port_index, devlink_subdev);
 }
 
 static void unregister_devlink_port(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7baade9e62b7..19c4020dc5df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2175,7 +2175,8 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 /* Vport Administration */
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
-			       u16 vport, u8 mac[ETH_ALEN])
+			       u16 vport, u8 mac[ETH_ALEN],
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 	u64 node_guid;
@@ -2188,25 +2189,30 @@ int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 
 	mutex_lock(&esw->state_lock);
 
-	if (evport->info.spoofchk && !is_valid_ether_addr(mac))
+	if (evport->info.spoofchk && !is_valid_ether_addr(mac)) {
 		mlx5_core_warn(esw->dev,
 			       "Set invalid MAC while spoofchk is on, vport(%d)\n",
 			       vport);
+		NL_SET_ERR_MSG_MOD(extack, "Set invalid MAC while spoofchk is on");
+	}
 
 	err = mlx5_modify_nic_vport_mac_address(esw->dev, vport, mac);
 	if (err) {
 		mlx5_core_warn(esw->dev,
 			       "Failed to mlx5_modify_nic_vport_mac vport(%d) err=(%d)\n",
 			       vport, err);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to modify NIC vport");
 		goto unlock;
 	}
 
 	node_guid_gen_from_mac(&node_guid, mac);
 	err = mlx5_modify_nic_vport_node_guid(esw->dev, vport, node_guid);
-	if (err)
+	if (err) {
 		mlx5_core_warn(esw->dev,
 			       "Failed to set vport %d node guid, err = %d. RDMA_CM will not function properly for this VF.\n",
 			       vport, err);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set node guid, RDMA_CM will not function properly for this vport");
+	}
 
 	ether_addr_copy(evport->info.mac, mac);
 	evport->info.node_guid = node_guid;
@@ -2249,12 +2255,15 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 }
 
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
-				  u16 vport, struct ifla_vf_info *ivi)
+				  u16 vport, struct ifla_vf_info *ivi,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 
-	if (IS_ERR(evport))
+	if (IS_ERR(evport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Vport does not exist");
 		return PTR_ERR(evport);
+	}
 
 	memset(ivi, 0, sizeof(*ivi));
 	ivi->vf = vport - 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 920d8f529fb9..56dbcc480053 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -138,6 +138,7 @@ struct mlx5_vport {
 
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
+	struct devlink_subdev     *devlink_subdev;
 };
 
 enum offloads_fdb_flags {
@@ -277,7 +278,8 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode);
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
-			       u16 vport, u8 mac[ETH_ALEN]);
+			       u16 vport, u8 mac[ETH_ALEN],
+			       struct netlink_ext_ack *extack);
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state);
 int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
@@ -291,7 +293,8 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw, u8 setting);
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting);
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
-				  u16 vport, struct ifla_vf_info *ivi);
+				  u16 vport, struct ifla_vf_info *ivi,
+				  struct netlink_ext_ack *extack);
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport,
 				 struct ifla_vf_stats *vf_stats);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5e28a35dfb0a..282ead8eba10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -42,6 +42,7 @@
 #include "fs_core.h"
 #include "lib/devcom.h"
 #include "lib/eq.h"
+#include "devlink.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -2193,6 +2194,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vports;
 
+	err = mlx5_devlink_subdevs_create(esw);
+	if (err)
+		goto err_subdevs;
+
 	err = esw_offloads_load_all_reps(esw);
 	if (err)
 		goto err_reps;
@@ -2203,6 +2208,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	return 0;
 
 err_reps:
+	mlx5_devlink_subdevs_destroy(esw);
+err_subdevs:
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 err_vports:
 	esw_set_passing_vport_metadata(esw, false);
@@ -2236,6 +2243,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
+	mlx5_devlink_subdevs_destroy(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
-- 
2.17.1

