Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412CBE0AEA
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbfJVRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:34 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55908 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732300AbfJVRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:33 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:25 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhP06005596;
        Tue, 22 Oct 2019 20:43:25 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhOuD023997;
        Tue, 22 Oct 2019 20:43:24 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhOUw023996;
        Tue, 22 Oct 2019 20:43:24 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 9/9] net/mlx5e: Add support for devlink vdev and vdev hw_addr set/show
Date:   Tue, 22 Oct 2019 20:43:10 +0300
Message-Id: <1571766190-23943-10-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add vdev creation and implement get/set ops for vdev hw_addr.
Add vdev linkage to devlink port registration.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 91 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  5 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 19 +++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  8 ++
 7 files changed, 135 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 381925c90d94..45166f7016c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -226,3 +226,94 @@ void mlx5_devlink_unregister(struct devlink *devlink)
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
 }
+
+static int
+mlx5_devlink_mac_set(struct devlink_vdev *devlink_vdev, u8 *mac,
+		     struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_vdev_priv(devlink_vdev);
+
+	return mlx5_eswitch_set_vport_mac(vport->dev->priv.eswitch,
+					 vport->vport, mac, extack);
+}
+
+static int
+mlx5_devlink_mac_get(struct devlink_vdev *devlink_vdev, u8 *mac,
+		     struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_vdev_priv(devlink_vdev);
+	struct ifla_vf_info ivi;
+	int err;
+
+	vport = devlink_vdev_priv(devlink_vdev);
+
+	err = mlx5_eswitch_get_vport_config(vport->dev->priv.eswitch,
+					    vport->vport, &ivi, extack);
+	if (!err)
+		ether_addr_copy(mac, ivi.mac);
+
+	return err;
+}
+
+static struct devlink_vdev_ops vdev_ops = {
+	.hw_addr_set = mlx5_devlink_mac_set,
+	.hw_addr_get = mlx5_devlink_mac_get,
+	.hw_addr_len = ETH_ALEN,
+};
+
+int mlx5_devlink_vdevs_create(struct mlx5_eswitch *esw)
+{
+	struct devlink *devlink = priv_to_devlink(esw->dev);
+	struct mlx5_vport *vport;
+	int err;
+	int i;
+
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		struct devlink_vdev *devlink_vdev;
+		struct devlink_vdev_attrs attrs;
+		int vdev_idx;
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
+		vdev_idx = vport->vport;
+		if (mlx5_eswitch_is_vf_vport(esw, vdev_idx))
+			devlink_vdev_attrs_pci_vf_init(&attrs, 0, vdev_idx - 1);
+		else
+			devlink_vdev_attrs_pci_pf_init(&attrs, vdev_idx);
+
+		devlink_vdev = devlink_vdev_create(devlink, vdev_idx,
+						   &vdev_ops, &attrs,
+						   vport);
+		if (IS_ERR(devlink_vdev)) {
+			err = PTR_ERR(devlink_vdev);
+			goto err_dl_destroy;
+		}
+		vport->devlink_vdev = devlink_vdev;
+	}
+
+	return 0;
+
+err_dl_destroy:
+	mlx5_devlink_vdevs_destroy(esw);
+	return err;
+}
+
+void mlx5_devlink_vdevs_destroy(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	int i;
+
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		if (vport->devlink_vdev)
+			devlink_vdev_destroy(vport->devlink_vdev);
+	}
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index d0ba03774ddf..652190480dbf 100644
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
 
+int mlx5_devlink_vdevs_create(struct mlx5_eswitch *esw);
+void mlx5_devlink_vdevs_destroy(struct mlx5_eswitch *esw);
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
index cd9bb7c7b341..165b28349cc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1812,8 +1812,10 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct devlink_vdev *devlink_vdev = NULL;
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
+		devlink_vdev = vport->devlink_vdev;
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
 					    rpriv->rep->vport)) {
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
@@ -1838,9 +1842,12 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 					      dev->pdev->devfn,
 					      rep->vport - 1);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
+		vport = mlx5_eswitch_get_vport(dev->priv.eswitch, rep->vport);
+		devlink_vdev = vport->devlink_vdev;
 	}
 
-	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
+	return devlink_port_register_with_vdev(devlink, &rpriv->dl_port,
+					       dl_port_index, devlink_vdev);
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
index 920d8f529fb9..b43fc9194f39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -138,6 +138,7 @@ struct mlx5_vport {
 
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
+	struct devlink_vdev     *devlink_vdev;
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
index bd9fd59d8233..9f1024048f8b 100644
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
 
+	err = mlx5_devlink_vdevs_create(esw);
+	if (err)
+		goto err_vdevs;
+
 	err = esw_offloads_load_all_reps(esw);
 	if (err)
 		goto err_reps;
@@ -2203,6 +2208,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	return 0;
 
 err_reps:
+	mlx5_devlink_vdevs_destroy(esw);
+err_vdevs:
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 err_vports:
 	esw_set_passing_vport_metadata(esw, false);
@@ -2236,6 +2243,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
+	mlx5_devlink_vdevs_destroy(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
-- 
2.17.1

