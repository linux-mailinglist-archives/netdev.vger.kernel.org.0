Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4208F3449
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfKGQJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:33 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53622 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389602AbfKGQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:24 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:21 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4N007213;
        Thu, 7 Nov 2019 18:09:19 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 13/19] net/mlx5: Register SF devlink port
Date:   Thu,  7 Nov 2019 10:08:28 -0600
Message-Id: <20191107160834.21087-13-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register devlink port for mdev's SF eswitch port.

Make use of mdev's alias to construct devlink eswitch port's phys_port_name
as agreed in discussion [1].

[1] https://patchwork.kernel.org/cover/11084231

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c     |  8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h     |  4 +++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c    |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c | 11 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c   |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h   |  2 +-
 6 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ce4278dfc101..aff98c4e1ae7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -233,7 +233,8 @@ mlx5_devlink_port_supported(const struct mlx5_core_dev *dev,
 {
 	return vport->vport == MLX5_VPORT_UPLINK ||
 	       vport->vport == MLX5_VPORT_PF ||
-	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, vport->vport);
+	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, vport->vport) ||
+	       mlx5_eswitch_is_sf_vport(dev->priv.eswitch, vport->vport);
 }
 
 static unsigned int
@@ -280,6 +281,11 @@ int mlx5_devlink_port_register(struct mlx5_core_dev *dev,
 					      &ppid.id[0], ppid.id_len,
 					      dev->pdev->devfn,
 					      vport->vport - 1);
+	else if (mlx5_eswitch_is_sf_vport(dev->priv.eswitch, vport->vport))
+		devlink_port_attrs_mdev_set(&vport->dl_port,
+					    &ppid.id[0], ppid.id_len,
+					    vport->port_alias);
+
 	return devlink_port_register(devlink, &vport->dl_port, dl_port_index);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ca7bf362a192..206a32c5a0af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -141,6 +141,7 @@ struct mlx5_vport {
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
 	struct devlink_port dl_port;
+	const char *port_alias; /* Applicable Only for SF vport */
 };
 
 enum offloads_fdb_flags {
@@ -308,7 +309,8 @@ int mlx5_eswitch_vport_enable_qos(struct mlx5_eswitch *esw,
 				  u32 initial_max_rate, u32 initial_bw_share);
 void mlx5_eswitch_vport_disable_qos(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport);
-int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
+int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num,
+				const char *port_alias);
 void mlx5_eswitch_cleanup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
 void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 503cefac300b..5dcaa4831b49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1706,7 +1706,8 @@ esw_disable_sf_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
-int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
+int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num,
+				const char *port_alias)
 {
 	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
 	int ret;
@@ -1718,6 +1719,8 @@ int mlx5_eswitch_setup_sf_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	if (ret)
 		return ret;
 
+	vport->port_alias = port_alias;
+
 	ret = esw_offloads_load_vport_reps(esw, vport_num);
 	if (ret)
 		esw_disable_sf_vport(esw, vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
index 295932110eff..0cf3b87f6b21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
@@ -9,6 +9,8 @@
 #include "meddev/sf.h"
 #include "eswitch.h"
 
+#define MLX5_MEDDEV_ALIAS_LEN 12
+
 struct mlx5_mdev_table {
 	struct mlx5_sf_table sf_table;
 	/* Synchronizes with mdev table cleanup check and mdev creation. */
@@ -87,7 +89,8 @@ static int mlx5_meddev_create(struct kobject *kobj, struct mdev_device *meddev)
 		return -ENODEV;
 	}
 
-	sf = mlx5_sf_alloc(parent_coredev, &table->sf_table, mdev_dev(meddev));
+	sf = mlx5_sf_alloc(parent_coredev, &table->sf_table, mdev_dev(meddev),
+			   mdev_alias(meddev));
 	if (IS_ERR(sf)) {
 		ret = PTR_ERR(sf);
 		goto sf_err;
@@ -111,9 +114,15 @@ static int mlx5_meddev_remove(struct mdev_device *meddev)
 	return 0;
 }
 
+static unsigned int mlx5_meddev_get_alias_length(void)
+{
+	return MLX5_MEDDEV_ALIAS_LEN;
+}
+
 static const struct mdev_parent_ops mlx5_meddev_ops = {
 	.create = mlx5_meddev_create,
 	.remove = mlx5_meddev_remove,
+	.get_alias_length = mlx5_meddev_get_alias_length,
 	.supported_type_groups = mlx5_meddev_groups,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index 99eb54d345a8..d496046daed8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -126,7 +126,7 @@ static u16 mlx5_sf_hw_id(const struct mlx5_core_dev *coredev, u16 sf_id)
 /* Perform SF allocation using parent device BAR. */
 struct mlx5_sf *
 mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
-	      struct device *dev)
+	      struct device *dev, const char *port_alias)
 {
 	struct mlx5_sf *sf;
 	u16 hw_function_id;
@@ -150,7 +150,8 @@ mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 	if (ret)
 		goto enable_err;
 
-	ret = mlx5_eswitch_setup_sf_vport(coredev->priv.eswitch, hw_function_id);
+	ret = mlx5_eswitch_setup_sf_vport(coredev->priv.eswitch,
+					  hw_function_id, port_alias);
 	if (ret)
 		goto vport_err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
index 526a6795e984..8ac032fdbb0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -42,7 +42,7 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev,
 
 struct mlx5_sf *
 mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
-	      struct device *dev);
+	      struct device *dev, const char *port_alias);
 void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 		  struct mlx5_sf *sf);
 u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
-- 
2.19.2

