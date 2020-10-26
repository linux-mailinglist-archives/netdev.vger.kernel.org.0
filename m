Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67510298BC1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773460AbgJZLTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773367AbgJZLT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D7A22404;
        Mon, 26 Oct 2020 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711164;
        bh=YoIInuVZMU0f9wZ3dm8bjwJ8ecun+q/T6FFd0CNhOO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvk8CzXaLUH5E98Tbhz67ut0Paq1emZZoSsXXG3ZQ+hoi7FX0Fpah6RVpj5qM5NyE
         nRADLGL1IJ7gtVgNnqRXnwJrE0iuGjVH6stAl91fHIv/coU4aOzizJSSmLVXICf49Y
         Np3UaaZdaRSAB5Fmj1UVXf3Cq3pF26kAGMzOgQMA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 08/11] RDMA/mlx5: Convert mlx5_ib to use auxiliary bus
Date:   Mon, 26 Oct 2020 13:18:46 +0200
Message-Id: <20201026111849.1035786-9-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The conversion to auxiliary bus solves long standing issue with
existing mlx5_ib<->mlx5_core coupling. It required to have both
modules in initramfs if one of them needed for the boot.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           |  77 ++++++---
 drivers/infiniband/hw/mlx5/ib_rep.h           |   8 +-
 drivers/infiniband/hw/mlx5/main.c             | 148 +++++++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  66 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  38 +++--
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 8 files changed, 251 insertions(+), 104 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 5c3d052ac30b..0dc15757cc66 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -33,6 +33,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
 	int vport_index;
+	int ret;

 	if (rep->vport == MLX5_VPORT_UPLINK)
 		profile = &raw_eth_profile;
@@ -46,8 +47,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->port = kcalloc(num_ports, sizeof(*ibdev->port),
 			      GFP_KERNEL);
 	if (!ibdev->port) {
-		ib_dealloc_device(&ibdev->ib_dev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fail_port;
 	}

 	ibdev->is_rep = true;
@@ -58,12 +59,19 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->mdev = dev;
 	ibdev->num_ports = num_ports;

-	if (!__mlx5_ib_add(ibdev, profile))
-		return -EINVAL;
+	ret = __mlx5_ib_add(ibdev, profile);
+	if (ret)
+		goto fail_add;

 	rep->rep_data[REP_IB].priv = ibdev;

 	return 0;
+
+fail_add:
+	kfree(ibdev->port);
+fail_port:
+	ib_dealloc_device(&ibdev->ib_dev);
+	return ret;
 }

 static void
@@ -94,20 +102,6 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.get_proto_dev = mlx5_ib_vport_get_proto_dev,
 };

-void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev)
-{
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-
-	mlx5_eswitch_register_vport_reps(esw, &rep_ops, REP_IB);
-}
-
-void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev)
-{
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-
-	mlx5_eswitch_unregister_vport_reps(esw, REP_IB);
-}
-
 u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw)
 {
 	return mlx5_eswitch_mode(esw);
@@ -154,3 +148,50 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 	return mlx5_eswitch_add_send_to_vport_rule(esw, rep->vport,
 						   sq->base.mqp.qpn);
 }
+
+static int mlx5r_rep_probe(struct auxiliary_device *adev,
+			   const struct auxiliary_device_id *id)
+{
+	struct mlx5_adev *idev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = idev->mdev;
+	struct mlx5_eswitch *esw;
+
+	esw = mdev->priv.eswitch;
+	mlx5_eswitch_register_vport_reps(esw, &rep_ops, REP_IB);
+	return 0;
+}
+
+static int mlx5r_rep_remove(struct auxiliary_device *adev)
+{
+	struct mlx5_adev *idev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = idev->mdev;
+	struct mlx5_eswitch *esw;
+
+	esw = mdev->priv.eswitch;
+	mlx5_eswitch_unregister_vport_reps(esw, REP_IB);
+	return 0;
+}
+
+static const struct auxiliary_device_id mlx5r_rep_id_table[] = {
+	{ .name = MLX5_ADEV_NAME ".rdma-rep", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5r_rep_id_table);
+
+static struct auxiliary_driver mlx5r_rep_driver = {
+	.name = "rep",
+	.probe = mlx5r_rep_probe,
+	.remove = mlx5r_rep_remove,
+	.id_table = mlx5r_rep_id_table,
+};
+
+int mlx5r_rep_init(void)
+{
+	return auxiliary_driver_register(&mlx5r_rep_driver);
+}
+
+void mlx5r_rep_cleanup(void)
+{
+	auxiliary_driver_unregister(&mlx5r_rep_driver);
+}
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index 5b30d3fa8f8d..94bf51ddd422 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -18,8 +18,8 @@ struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
 struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw);
 struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 					   u16 vport_num);
-void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev);
-void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev);
+int mlx5r_rep_init(void);
+void mlx5r_rep_cleanup(void);
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
 						   u16 port);
@@ -51,8 +51,8 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 	return NULL;
 }

-static inline void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev) {}
-static inline void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev) {}
+static inline int mlx5r_rep_init(void) { return 0; }
+static inline void mlx5r_rep_cleanup(void) {}
 static inline
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0b9829e63308..bcee10c9d9a8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4611,8 +4611,8 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 	ib_dealloc_device(&dev->ib_dev);
 }

-void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
-		    const struct mlx5_ib_profile *profile)
+int __mlx5_ib_add(struct mlx5_ib_dev *dev,
+		  const struct mlx5_ib_profile *profile)
 {
 	int err;
 	int i;
@@ -4628,13 +4628,11 @@ void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
 	}

 	dev->ib_active = true;
-
-	return dev;
+	return 0;

 err_out:
 	__mlx5_ib_remove(dev, profile, i);
-
-	return NULL;
+	return -ENOMEM;
 }

 static const struct mlx5_ib_profile pf_profile = {
@@ -4757,8 +4755,11 @@ const struct mlx5_ib_profile raw_eth_profile = {
 		     NULL),
 };

-static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
+static int mlx5r_mp_probe(struct auxiliary_device *adev,
+			  const struct auxiliary_device_id *id)
 {
+	struct mlx5_adev *idev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = idev->mdev;
 	struct mlx5_ib_multiport_info *mpi;
 	struct mlx5_ib_dev *dev;
 	bool bound = false;
@@ -4766,15 +4767,14 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)

 	mpi = kzalloc(sizeof(*mpi), GFP_KERNEL);
 	if (!mpi)
-		return NULL;
+		return -ENOMEM;

 	mpi->mdev = mdev;
-
 	err = mlx5_query_nic_vport_system_image_guid(mdev,
 						     &mpi->sys_image_guid);
 	if (err) {
 		kfree(mpi);
-		return NULL;
+		return err;
 	}

 	mutex_lock(&mlx5_ib_multiport_mutex);
@@ -4795,40 +4795,47 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
 	}
 	mutex_unlock(&mlx5_ib_multiport_mutex);

-	return mpi;
+	dev_set_drvdata(&adev->dev, mpi);
+	return 0;
 }

-static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
+static int mlx5r_mp_remove(struct auxiliary_device *adev)
 {
+	struct mlx5_ib_multiport_info *mpi;
+
+	mpi = dev_get_drvdata(&adev->dev);
+	mutex_lock(&mlx5_ib_multiport_mutex);
+	if (mpi->ibdev)
+		mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
+	list_del(&mpi->list);
+	mutex_unlock(&mlx5_ib_multiport_mutex);
+	kfree(mpi);
+	return 0;
+}
+
+static int mlx5r_probe(struct auxiliary_device *adev,
+		       const struct auxiliary_device_id *id)
+{
+	struct mlx5_adev *idev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = idev->mdev;
 	const struct mlx5_ib_profile *profile;
+	int port_type_cap, num_ports, ret;
 	enum rdma_link_layer ll;
 	struct mlx5_ib_dev *dev;
-	int port_type_cap;
-	int num_ports;
-
-	if (MLX5_ESWITCH_MANAGER(mdev) &&
-	    mlx5_ib_eswitch_mode(mdev->priv.eswitch) == MLX5_ESWITCH_OFFLOADS) {
-		if (!mlx5_core_mp_enabled(mdev))
-			mlx5_ib_register_vport_reps(mdev);
-		return mdev;
-	}

 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);

-	if (mlx5_core_is_mp_slave(mdev) && ll == IB_LINK_LAYER_ETHERNET)
-		return mlx5_ib_add_slave_port(mdev);
-
 	num_ports = max(MLX5_CAP_GEN(mdev, num_ports),
 			MLX5_CAP_GEN(mdev, num_vhca_ports));
 	dev = ib_alloc_device(mlx5_ib_dev, ib_dev);
 	if (!dev)
-		return NULL;
+		return -ENOMEM;
 	dev->port = kcalloc(num_ports, sizeof(*dev->port),
 			     GFP_KERNEL);
 	if (!dev->port) {
 		ib_dealloc_device(&dev->ib_dev);
-		return NULL;
+		return -ENOMEM;
 	}

 	dev->mdev = mdev;
@@ -4839,43 +4846,56 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	else
 		profile = &pf_profile;

-	return __mlx5_ib_add(dev, profile);
+	ret = __mlx5_ib_add(dev, profile);
+	if (ret) {
+		kfree(dev->port);
+		ib_dealloc_device(&dev->ib_dev);
+		return ret;
+	}
+
+	dev_set_drvdata(&adev->dev, dev);
+	return 0;
 }

-static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
+static int mlx5r_remove(struct auxiliary_device *adev)
 {
-	struct mlx5_ib_multiport_info *mpi;
 	struct mlx5_ib_dev *dev;

-	if (MLX5_ESWITCH_MANAGER(mdev) && context == mdev) {
-		mlx5_ib_unregister_vport_reps(mdev);
-		return;
-	}
-
-	if (mlx5_core_is_mp_slave(mdev)) {
-		mpi = context;
-		mutex_lock(&mlx5_ib_multiport_mutex);
-		if (mpi->ibdev)
-			mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
-		list_del(&mpi->list);
-		mutex_unlock(&mlx5_ib_multiport_mutex);
-		kfree(mpi);
-		return;
-	}
-
-	dev = context;
+	dev = dev_get_drvdata(&adev->dev);
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
+	return 0;
 }

-static struct mlx5_interface mlx5_ib_interface = {
-	.add            = mlx5_ib_add,
-	.remove         = mlx5_ib_remove,
-	.protocol	= MLX5_INTERFACE_PROTOCOL_IB,
+static const struct auxiliary_device_id mlx5r_mp_id_table[] = {
+	{ .name = MLX5_ADEV_NAME ".multiport", },
+	{},
+};
+
+static const struct auxiliary_device_id mlx5r_id_table[] = {
+	{ .name = MLX5_ADEV_NAME ".rdma", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5r_mp_id_table);
+MODULE_DEVICE_TABLE(auxiliary, mlx5r_id_table);
+
+static struct auxiliary_driver mlx5r_mp_driver = {
+	.name = "multiport",
+	.probe = mlx5r_mp_probe,
+	.remove = mlx5r_mp_remove,
+	.id_table = mlx5r_mp_id_table,
+};
+
+static struct auxiliary_driver mlx5r_driver = {
+	.name = "rdma",
+	.probe = mlx5r_probe,
+	.remove = mlx5r_remove,
+	.id_table = mlx5r_id_table,
 };

 static int __init mlx5_ib_init(void)
 {
-	int err;
+	int ret;

 	xlt_emergency_page = (void *)__get_free_page(GFP_KERNEL);
 	if (!xlt_emergency_page)
@@ -4888,15 +4908,33 @@ static int __init mlx5_ib_init(void)
 	}

 	mlx5_ib_odp_init();
+	ret = mlx5r_rep_init();
+	if (ret)
+		goto rep_err;
+	ret = auxiliary_driver_register(&mlx5r_mp_driver);
+	if (ret)
+		goto mp_err;
+	ret = auxiliary_driver_register(&mlx5r_driver);
+	if (ret)
+		goto drv_err;
+	return 0;

-	err = mlx5_register_interface(&mlx5_ib_interface);
-
-	return err;
+drv_err:
+	auxiliary_driver_unregister(&mlx5r_mp_driver);
+mp_err:
+	mlx5r_rep_cleanup();
+rep_err:
+	destroy_workqueue(mlx5_ib_event_wq);
+	free_page((unsigned long)xlt_emergency_page);
+	return ret;
 }

 static void __exit mlx5_ib_cleanup(void)
 {
-	mlx5_unregister_interface(&mlx5_ib_interface);
+	auxiliary_driver_unregister(&mlx5r_driver);
+	auxiliary_driver_unregister(&mlx5r_mp_driver);
+	mlx5r_rep_cleanup();
+
 	destroy_workqueue(mlx5_ib_event_wq);
 	free_page((unsigned long)xlt_emergency_page);
 }
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 254668d31988..200df80393de 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1383,8 +1383,8 @@ extern const struct mmu_interval_notifier_ops mlx5_mn_ops;
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage);
-void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
-		    const struct mlx5_ib_profile *profile);
+int __mlx5_ib_add(struct mlx5_ib_dev *dev,
+		  const struct mlx5_ib_profile *profile);

 int mlx5_ib_get_vf_config(struct ib_device *device, int vf,
 			  u8 port, struct ifla_vf_info *info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index bfc7df23ed7b..466e4a35a0c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -144,16 +144,82 @@ static bool is_vnet_supported(struct mlx5_core_dev *dev)
 	return true;
 }

+static bool is_ib_rep_supported(struct mlx5_core_dev *dev)
+{
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
+		return false;
+
+	if (dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV)
+		return false;
+
+	if (!is_eth_rep_supported(dev))
+		return false;
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return false;
+
+	if (mlx5_eswitch_mode(dev->priv.eswitch) != MLX5_ESWITCH_OFFLOADS)
+		return false;
+
+	if (mlx5_core_mp_enabled(dev))
+		return false;
+
+	return true;
+}
+
+static bool is_mp_supported(struct mlx5_core_dev *dev)
+{
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
+		return false;
+
+	if (dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV)
+		return false;
+
+	if (is_ib_rep_supported(dev))
+		return false;
+
+	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
+		return false;
+
+	if (!mlx5_core_is_mp_slave(dev))
+		return false;
+
+	return true;
+}
+
+static bool is_ib_supported(struct mlx5_core_dev *dev)
+{
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
+		return false;
+
+	if (dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV)
+		return false;
+
+	if (is_ib_rep_supported(dev))
+		return false;
+
+	if (is_mp_supported(dev))
+		return false;
+
+	return true;
+}
+
 static const struct mlx5_adev_device {
 	const char *suffix;
 	bool (*is_supported)(struct mlx5_core_dev *dev);
 } mlx5_adev_devices[] = {
 	[MLX5_INTERFACE_PROTOCOL_VDPA] = { .suffix = "vnet",
 					   .is_supported = &is_vnet_supported },
+	[MLX5_INTERFACE_PROTOCOL_IB] = { .suffix = "rdma",
+					 .is_supported = &is_ib_supported },
 	[MLX5_INTERFACE_PROTOCOL_ETH] = { .suffix = "eth",
 					  .is_supported = &is_eth_supported },
 	[MLX5_INTERFACE_PROTOCOL_ETH_REP] = { .suffix = "eth-rep",
 					   .is_supported = &is_eth_rep_supported },
+	[MLX5_INTERFACE_PROTOCOL_IB_REP] = { .suffix = "rdma-rep",
+					   .is_supported = &is_ib_rep_supported },
+	[MLX5_INTERFACE_PROTOCOL_MPIB] = { .suffix = "multiport",
+					   .is_supported = &is_mp_supported },
 };

 int mlx5_adev_init(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 78a854926b00..b652b4bde733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1617,7 +1617,6 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		err = esw_legacy_enable(esw);
 	} else {
 		mlx5_rescan_drivers(esw->dev);
-		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		err = esw_offloads_enable(esw);
 	}

@@ -1635,10 +1634,9 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 abort:
 	esw->mode = MLX5_ESWITCH_NONE;

-	if (mode == MLX5_ESWITCH_OFFLOADS) {
-		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
+	if (mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
-	}
+
 	esw_destroy_tsar(esw);
 	return err;
 }
@@ -1699,10 +1697,9 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)

 	mlx5_lag_update(esw->dev);

-	if (old_mode == MLX5_ESWITCH_OFFLOADS) {
-		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
+	if (old_mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
-	}
+
 	esw_destroy_tsar(esw);

 	if (clear_vf)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index e4d4de1719bd..7bc7f5e3dcbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -243,24 +243,30 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 #endif
 }

-static void mlx5_lag_add_ib_devices(struct mlx5_lag *ldev)
+static void mlx5_lag_add_devices(struct mlx5_lag *ldev)
 {
 	int i;

-	for (i = 0; i < MLX5_MAX_PORTS; i++)
-		if (ldev->pf[i].dev)
-			mlx5_add_dev_by_protocol(ldev->pf[i].dev,
-						 MLX5_INTERFACE_PROTOCOL_IB);
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (!ldev->pf[i].dev)
+			continue;
+
+		ldev->pf[i].dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+		_mlx5_rescan_drivers(ldev->pf[i].dev);
+	}
 }

-static void mlx5_lag_remove_ib_devices(struct mlx5_lag *ldev)
+static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 {
 	int i;

-	for (i = 0; i < MLX5_MAX_PORTS; i++)
-		if (ldev->pf[i].dev)
-			mlx5_remove_dev_by_protocol(ldev->pf[i].dev,
-						    MLX5_INTERFACE_PROTOCOL_IB);
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (!ldev->pf[i].dev)
+			continue;
+
+		ldev->pf[i].dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+		_mlx5_rescan_drivers(ldev->pf[i].dev);
+	}
 }

 static void mlx5_do_bond(struct mlx5_lag *ldev)
@@ -290,20 +296,21 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 #endif

 		if (roce_lag)
-			mlx5_lag_remove_ib_devices(ldev);
+			mlx5_lag_remove_devices(ldev);

 		err = mlx5_activate_lag(ldev, &tracker,
 					roce_lag ? MLX5_LAG_FLAG_ROCE :
 					MLX5_LAG_FLAG_SRIOV);
 		if (err) {
 			if (roce_lag)
-				mlx5_lag_add_ib_devices(ldev);
+				mlx5_lag_add_devices(ldev);

 			return;
 		}

 		if (roce_lag) {
-			mlx5_add_dev_by_protocol(dev0, MLX5_INTERFACE_PROTOCOL_IB);
+			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+			_mlx5_rescan_drivers(dev0);
 			mlx5_nic_vport_enable_roce(dev1);
 		}
 	} else if (do_bond && __mlx5_lag_is_active(ldev)) {
@@ -312,7 +319,8 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		roce_lag = __mlx5_lag_is_roce(ldev);

 		if (roce_lag) {
-			mlx5_remove_dev_by_protocol(dev0, MLX5_INTERFACE_PROTOCOL_IB);
+			dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+			_mlx5_rescan_drivers(dev0);
 			mlx5_nic_vport_disable_roce(dev1);
 		}

@@ -321,7 +329,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 			return;

 		if (roce_lag)
-			mlx5_lag_add_ib_devices(ldev);
+			mlx5_lag_add_devices(ldev);
 	}
 }

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8f99428583c3..a6034acb2ac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1345,7 +1345,6 @@ static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&dev->intf_state_mutex);
 }

-#define MLX5_IB_MOD "mlx5_ib"
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct mlx5_core_dev *dev;
@@ -1383,8 +1382,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_load_one;
 	}

-	request_module_nowait(MLX5_IB_MOD);
-
 	err = mlx5_crdump_enable(dev);
 	if (err)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
--
2.26.2

