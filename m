Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD227F8BA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgJAEdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgJAEdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:20 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 087D422204;
        Thu,  1 Oct 2020 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526798;
        bh=+7M8zJyGSjaB3SGzI07UURGjCKjPkUw5kUtZGfHrm4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1m0amzHDrLMM8JnVvNDFSgNyFz1bNyCvEc2FcwBLkw9hOUJERA3LfeNfdz2Y3WEv
         96/3feJgOoj1uvQ3gbxw1riiWYBjxxHHFaBd5cGGUt5DXMb2pfzbtO2leztTBLoOJ4
         meF1z8ixkaQzrL3Er9u45bsziIlp2Imj28nlbX/A=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: E-switch, Move devlink eswitch ports closer to eswitch
Date:   Wed, 30 Sep 2020 21:32:57 -0700
Message-Id: <20201001043302.48113-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently devlink eswitch ports are registered and unregistered by the
representor layer.
However it is better to register them at eswitch layer so that in future
user initiated command port add and delete commands can also
register/unregister devlink ports without depending on representor layer.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 103 ++-------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 -
 .../mellanox/mlx5/core/esw/devlink_port.c     | 124 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  11 ++
 6 files changed, 154 insertions(+), 92 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9826a041e407..b24aeee1db8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -49,7 +49,8 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offlo
 				      ecpf.o rdma.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
-				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o
+				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
+				      esw/devlink_port.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9f5c97d22af4..67247c33b9fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -374,19 +374,6 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
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
@@ -611,12 +598,13 @@ static int mlx5e_uplink_rep_set_vf_vlan(struct net_device *dev, int vf, u16 vlan
 	return 0;
 }
 
-static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *dev)
+static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *netdev)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_core_dev *dev = priv->mdev;
 
-	return &rpriv->dl_port;
+	return mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
 }
 
 static int mlx5e_rep_change_carrier(struct net_device *dev, bool new_carrier)
@@ -1206,70 +1194,13 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.stats_grps_num		= mlx5e_ul_rep_stats_grps_num,
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
-static int register_devlink_port(struct mlx5_core_dev *dev,
-				 struct mlx5e_rep_priv *rpriv)
-{
-	struct mlx5_esw_offload *offloads = &dev->priv.eswitch->offloads;
-	struct devlink *devlink = priv_to_devlink(dev);
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct devlink_port_attrs attrs = {};
-	struct netdev_phys_item_id ppid = {};
-	unsigned int dl_port_index = 0;
-	u32 controller_num = 0;
-	bool external;
-	u16 pfnum;
-
-	if (!is_devlink_port_supported(dev, rpriv))
-		return 0;
-
-	external = mlx5_core_is_ecpf_esw_manager(dev);
-	if (external)
-		controller_num = offloads->host_number + 1;
-	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
-	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
-	pfnum = PCI_FUNC(dev->pdev->devfn);
-	if (rep->vport == MLX5_VPORT_UPLINK) {
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		attrs.phys.port_number = pfnum;
-		memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
-		attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_set(&rpriv->dl_port, &attrs);
-	} else if (rep->vport == MLX5_VPORT_PF) {
-		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
-		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, controller_num,
-					      pfnum, external);
-	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
-		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
-		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_vf_set(&rpriv->dl_port, controller_num,
-					      pfnum, rep->vport - 1, external);
-	}
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
 {
 	const struct mlx5e_profile *profile;
 	struct mlx5e_rep_priv *rpriv;
+	struct devlink_port *dl_port;
 	struct net_device *netdev;
 	int nch, err;
 
@@ -1319,28 +1250,19 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	err = register_devlink_port(dev, rpriv);
-	if (err) {
-		netdev_warn(netdev, "Failed to register devlink port %d\n",
-			    rep->vport);
-		goto err_neigh_cleanup;
-	}
-
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_warn(netdev,
 			    "Failed to register representor netdev for vport %d\n",
 			    rep->vport);
-		goto err_devlink_cleanup;
+		goto err_neigh_cleanup;
 	}
 
-	if (is_devlink_port_supported(dev, rpriv))
-		devlink_port_type_eth_set(&rpriv->dl_port, netdev);
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		devlink_port_type_eth_set(dl_port, netdev);
 	return 0;
 
-err_devlink_cleanup:
-	unregister_devlink_port(dev, rpriv);
-
 err_neigh_cleanup:
 	mlx5e_rep_neigh_cleanup(rpriv);
 
@@ -1364,12 +1286,13 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *dev = priv->mdev;
+	struct devlink_port *dl_port;
 	void *ppriv = priv->ppriv;
 
-	if (is_devlink_port_supported(dev, rpriv))
-		devlink_port_type_clear(&rpriv->dl_port);
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		devlink_port_type_clear(dl_port);
 	unregister_netdev(netdev);
-	unregister_devlink_port(dev, rpriv);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
 	if (rep->vport == MLX5_VPORT_UPLINK)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 622c27ae4ac7..8054d92ae37e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -101,7 +101,6 @@ struct mlx5e_rep_priv {
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
 	struct rtnl_link_stats64 prev_vf_vport_stats;
-	struct devlink_port dl_port;
 };
 
 static inline
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
new file mode 100644
index 000000000000..ffff11baa3d0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd. */
+
+#include <linux/mlx5/driver.h>
+#include "eswitch.h"
+
+static void
+mlx5_esw_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
+{
+	u64 parent_id;
+
+	parent_id = mlx5_query_nic_system_image_guid(dev);
+	ppid->id_len = sizeof(parent_id);
+	memcpy(ppid->id, &parent_id, sizeof(parent_id));
+}
+
+static bool
+mlx5_esw_devlink_port_supported(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return vport_num == MLX5_VPORT_UPLINK ||
+	       (mlx5_core_is_ecpf(esw->dev) && vport_num == MLX5_VPORT_PF) ||
+	       mlx5_eswitch_is_vf_vport(esw, vport_num);
+}
+
+static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct devlink_port_attrs attrs = {};
+	struct netdev_phys_item_id ppid = {};
+	struct devlink_port *dl_port;
+	u32 controller_num = 0;
+	bool external;
+	u16 pfnum;
+
+	dl_port = kzalloc(sizeof(*dl_port), GFP_KERNEL);
+	if (!dl_port)
+		return NULL;
+
+	mlx5_esw_get_port_parent_id(dev, &ppid);
+	pfnum = PCI_FUNC(dev->pdev->devfn);
+	external = mlx5_core_is_ecpf_esw_manager(dev);
+	if (external)
+		controller_num = dev->priv.eswitch->offloads.host_number + 1;
+
+	if (vport_num == MLX5_VPORT_UPLINK) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = pfnum;
+		memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
+		attrs.switch_id.id_len = ppid.id_len;
+		devlink_port_attrs_set(dl_port, &attrs);
+	} else if (vport_num == MLX5_VPORT_PF) {
+		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
+		dl_port->attrs.switch_id.id_len = ppid.id_len;
+		devlink_port_attrs_pci_pf_set(dl_port, controller_num, pfnum, external);
+	} else if (mlx5_eswitch_is_vf_vport(esw, vport_num)) {
+		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
+		dl_port->attrs.switch_id.id_len = ppid.id_len;
+		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
+					      vport_num - 1, external);
+	}
+	return dl_port;
+}
+
+static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
+{
+	kfree(dl_port);
+}
+
+int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct devlink_port *dl_port;
+	unsigned int dl_port_index;
+	struct mlx5_vport *vport;
+	struct devlink *devlink;
+	int err;
+
+	if (!mlx5_esw_devlink_port_supported(esw, vport_num))
+		return 0;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	dl_port = mlx5_esw_dl_port_alloc(esw, vport_num);
+	if (!dl_port)
+		return -ENOMEM;
+
+	devlink = priv_to_devlink(dev);
+	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
+	err = devlink_port_register(devlink, dl_port, dl_port_index);
+	if (err)
+		goto reg_err;
+
+	vport->dl_port = dl_port;
+	return 0;
+
+reg_err:
+	mlx5_esw_dl_port_free(dl_port);
+	return err;
+}
+
+void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport;
+
+	if (!mlx5_esw_devlink_port_supported(esw, vport_num))
+		return;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return;
+	devlink_port_unregister(vport->dl_port);
+	mlx5_esw_dl_port_free(vport->dl_port);
+	vport->dl_port = NULL;
+}
+
+struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	return vport->dl_port;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 66393fbdcd94..cf87de94418f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -156,6 +156,7 @@ struct mlx5_vport {
 
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
+	struct devlink_port *dl_port;
 };
 
 struct mlx5_eswitch_fdb {
@@ -663,6 +664,9 @@ int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
 				enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs);
 
+int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
+struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num);
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f021cb8e6ad4..e977d857f969 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1861,7 +1861,17 @@ int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return 0;
 
+	err = mlx5_esw_offloads_devlink_port_register(esw, vport_num);
+	if (err)
+		return err;
+
 	err = mlx5_esw_offloads_rep_load(esw, vport_num);
+	if (err)
+		goto load_err;
+	return err;
+
+load_err:
+	mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
 	return err;
 }
 
@@ -1871,6 +1881,7 @@ void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 		return;
 
 	mlx5_esw_offloads_rep_unload(esw, vport_num);
+	mlx5_esw_offloads_devlink_port_unregister(esw, vport_num);
 }
 
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
-- 
2.26.2

