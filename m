Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB622EA8D5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbhAEKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:33:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14018 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbhAEKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:33:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff440380000>; Tue, 05 Jan 2021 02:32:24 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 10:32:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v3 2/6] vdpa: Extend routine to accept vdpa device name
Date:   Tue, 5 Jan 2021 12:31:59 +0200
Message-ID: <20210105103203.82508-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105103203.82508-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609842744; bh=TBsOFXoY6iVyK/iq+Z/G+N9WbnVsX6zyFORkWC3JR20=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=eb2S/yDa4g5ujSCvv0QMu+mySk0Z9OTTo9tl85wmZmuqgCtjPtSAs9Q/Ewla1AShV
         sOJS4VHqkm9olvb3+SV/y7ZZYPXIPYuMh3grI5YqX4b9aRUHX/ej/3nzvBdq0dO7oq
         BgyE/gFCAbf2NhaDXY93aulPP4ZkFt9yWVC2F8oRkwgPy1CG1CXVTqY8/wU57aLr+U
         reC2xQRA1LsqnvhsEyghevFrlhti+RGQMA9YvKFl/KSxdzTPUD88TmRDMJEFXlZ43a
         JNvl4QyRgdQOZQs0EVszgobpbKxQVUdwl2G6VV2kiBdxsGK45V0w4740n02gvKB/Qz
         Az6wZfYsaC9Ag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a subsequent patch, when user initiated command creates a vdpa device,
the user chooses the name of the vdpa device.
To support it, extend the device allocation API to consider this name
specified by the caller driver.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
Changelog:
v1->v2:
 - rebased
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
 drivers/vdpa/vdpa.c               | 36 +++++++++++++++++++++++++++----
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
 include/linux/vdpa.h              |  7 +++---
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_mai=
n.c
index fa1af301cf55..7c8bbfcf6c3e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -432,7 +432,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
=20
 	adapter =3D vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops,
-				    IFCVF_MAX_QUEUE_PAIRS * 2);
+				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
 	if (adapter =3D=3D NULL) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index 81b932f72e10..5920290521cf 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1946,7 +1946,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 	max_vqs =3D min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
=20
 	ndev =3D vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device=
, &mlx5_vdpa_ops,
-				 2 * mlx5_vdpa_max_qps(max_vqs));
+				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
 	if (IS_ERR(ndev))
 		return ndev;
=20
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c0825650c055..7414bbd9057c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/vdpa.h>
=20
+/* A global mutex that protects vdpa management device and device level op=
erations. */
+static DEFINE_MUTEX(vdpa_dev_mutex);
 static DEFINE_IDA(vdpa_index_ida);
=20
 static int vdpa_dev_probe(struct device *d)
@@ -63,6 +65,7 @@ static void vdpa_release_dev(struct device *d)
  * @config: the bus operations that is supported by this device
  * @nvqs: number of virtqueues supported by this device
  * @size: size of the parent structure that contains private data
+ * @name: name of the vdpa device; optional.
  *
  * Driver should use vdpa_alloc_device() wrapper macro instead of
  * using this directly.
@@ -72,8 +75,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs,
-					size_t size)
+					int nvqs, size_t size, const char *name)
 {
 	struct vdpa_device *vdev;
 	int err =3D -EINVAL;
@@ -101,7 +103,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device =
*parent,
 	vdev->features_valid =3D false;
 	vdev->nvqs =3D nvqs;
=20
-	err =3D dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
+	if (name)
+		err =3D dev_set_name(&vdev->dev, "%s", name);
+	else
+		err =3D dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
 	if (err)
 		goto err_name;
=20
@@ -118,6 +123,13 @@ struct vdpa_device *__vdpa_alloc_device(struct device =
*parent,
 }
 EXPORT_SYMBOL_GPL(__vdpa_alloc_device);
=20
+static int vdpa_name_match(struct device *dev, const void *data)
+{
+	struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device, dev);
+
+	return (strcmp(dev_name(&vdev->dev), data) =3D=3D 0);
+}
+
 /**
  * vdpa_register_device - register a vDPA device
  * Callers must have a succeed call of vdpa_alloc_device() before.
@@ -127,7 +139,21 @@ EXPORT_SYMBOL_GPL(__vdpa_alloc_device);
  */
 int vdpa_register_device(struct vdpa_device *vdev)
 {
-	return device_add(&vdev->dev);
+	struct device *dev;
+	int err;
+
+	mutex_lock(&vdpa_dev_mutex);
+	dev =3D bus_find_device(&vdpa_bus, NULL, dev_name(&vdev->dev), vdpa_name_=
match);
+	if (dev) {
+		put_device(dev);
+		err =3D -EEXIST;
+		goto name_err;
+	}
+
+	err =3D device_add(&vdev->dev);
+name_err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vdpa_register_device);
=20
@@ -137,7 +163,9 @@ EXPORT_SYMBOL_GPL(vdpa_register_device);
  */
 void vdpa_unregister_device(struct vdpa_device *vdev)
 {
+	mutex_lock(&vdpa_dev_mutex);
 	device_unregister(&vdev->dev);
+	mutex_unlock(&vdpa_dev_mutex);
 }
 EXPORT_SYMBOL_GPL(vdpa_unregister_device);
=20
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_=
sim.c
index b3fcc67bfdf0..db1636a99ba4 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr =
*dev_attr)
 		ops =3D &vdpasim_config_ops;
=20
 	vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    dev_attr->nvqs);
+				    dev_attr->nvqs, NULL);
 	if (!vdpasim)
 		goto err_alloc;
=20
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 0fefeb976877..5700baa22356 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -245,15 +245,14 @@ struct vdpa_config_ops {
=20
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs,
-					size_t size);
+					int nvqs, size_t size, const char *name);
=20
-#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, name) =
  \
 			  container_of(__vdpa_alloc_device( \
 				       parent, config, nvqs, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member))), \
+				       dev_struct, member)), name), \
 				       dev_struct, member)
=20
 int vdpa_register_device(struct vdpa_device *vdev);
--=20
2.26.2

