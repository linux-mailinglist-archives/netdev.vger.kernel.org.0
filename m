Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7952AFFC6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKLGkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:40:42 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15487 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgKLGke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:40:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5facd8dd0001>; Wed, 11 Nov 2020 22:40:29 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 06:40:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH 7/7] vdpa/vdpa_sim: Enable user to create vdpasim net devices
Date:   Thu, 12 Nov 2020 08:40:05 +0200
Message-ID: <20201112064005.349268-8-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605163229; bh=KJ3AOJWMJTMztY+TXdCv61rtyZGand4171XiGUabLAI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=X3AME2CEGukSsNJizi2DRuLJDHos1YyLKY9cOrHZFFXkoj/mtFQgJ27+8gYsA3DTm
         1W/3RVB7+LaLpNszZOu1MfeP/fVjfpD1NJMqGEeOK/dT2+1xo7SSumUw3X48rdfZQX
         C4XxqO3HVRY/Jhf4sJZeQq0Krqu9HuKq4ddWqlVe91oKkNRwhm/gt1odNlM4uiqiVr
         /u3dIPJpE7f1xq6FGAFIaGE5HukcuhnPr8s/W+VjQnkv3klAJZPUEe2O1kq4IIErCX
         eryY7iuEpfSCkQm/DJRpqbNsMhIJmgEAcg8uWhpzi6MRm+FcVmx9wTisQChP7BeH7S
         hO3dwU1arQYFQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to create vdpasim net simulate devices.

Show vdpa parent device that supports creating, deleting vdpa devices.

$ vdpa parentdev show
vdpasim:
  supported_classes
    net

$ vdpa parentdev show -jp
{
    "show": {
        "vdpasim": {
            "supported_classes": {
              "net"
        }
    }
}

Create a vdpa device of type networking named as "foo2" from
the parent device vdpasim:

$ vdpa dev add parentdev vdpasim type net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network parentdev vdpasim vendor_id 0 max_vqs 2 max_vq_size 256

$ vdpa dev show foo2 -jp
{
    "dev": {
        "foo2": {
            "type": "network",
            "parentdev": "vdpasim",
            "vendor_id": 0,
            "max_vqs": 2,
            "max_vq_size": 256
        }
    }
}

Delete the vdpa device after its use:
$ vdpa dev del foo2

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 81 +++++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_=
sim.c
index aed1bb7770ab..85776e4e6749 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -28,6 +28,7 @@
 #include <linux/vhost_iotlb.h>
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_net.h>
+#include <uapi/linux/vdpa.h>
=20
 #define DRV_VERSION  "0.1"
 #define DRV_AUTHOR   "Jason Wang <jasowang@redhat.com>"
@@ -42,6 +43,17 @@ static char *macaddr;
 module_param(macaddr, charp, 0);
 MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
=20
+static struct vdpa_parent_dev parent_dev;
+
+static void vdpasim_parent_release(struct device *dev)
+{
+}
+
+static struct device vdpasim_parent =3D {
+	.init_name =3D "vdpasim",
+	.release =3D vdpasim_parent_release,
+};
+
 struct vdpasim_virtqueue {
 	struct vringh vring;
 	struct vringh_kiov iov;
@@ -101,8 +113,6 @@ static inline __virtio16 cpu_to_vdpasim16(struct vdpasi=
m *vdpasim, u16 val)
 	return __cpu_to_virtio16(vdpasim_is_little_endian(vdpasim), val);
 }
=20
-static struct vdpasim *vdpasim_dev;
-
 static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
 {
 	return container_of(vdpa, struct vdpasim, vdpa);
@@ -345,7 +355,7 @@ static const struct dma_map_ops vdpasim_dma_ops =3D {
 static const struct vdpa_config_ops vdpasim_net_config_ops;
 static const struct vdpa_config_ops vdpasim_net_batch_config_ops;
=20
-static struct vdpasim *vdpasim_create(void)
+static struct vdpasim *vdpasim_create(const char *name)
 {
 	const struct vdpa_config_ops *ops;
 	struct vdpasim *vdpasim;
@@ -357,7 +367,7 @@ static struct vdpasim *vdpasim_create(void)
 	else
 		ops =3D &vdpasim_net_config_ops;
=20
-	vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ=
_NUM, NULL);
+	vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ=
_NUM, name);
 	if (!vdpasim)
 		goto err_alloc;
=20
@@ -393,7 +403,8 @@ static struct vdpasim *vdpasim_create(void)
 	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
=20
 	vdpasim->vdpa.dma_dev =3D dev;
-	ret =3D vdpa_register_device(&vdpasim->vdpa);
+	vdpasim->vdpa.pdev =3D &parent_dev;
+	ret =3D _vdpa_register_device(&vdpasim->vdpa);
 	if (ret)
 		goto err_iommu;
=20
@@ -714,21 +725,67 @@ static const struct vdpa_config_ops vdpasim_net_batch=
_config_ops =3D {
 	.free                   =3D vdpasim_free,
 };
=20
+static struct vdpa_device *
+vdpa_dev_add(struct vdpa_parent_dev *pdev, const char *name, u32 device_id=
)
+{
+	struct vdpasim *simdev;
+
+	if (device_id !=3D VIRTIO_ID_NET)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	simdev =3D vdpasim_create(name);
+	if (IS_ERR(simdev))
+		return (struct vdpa_device *)simdev;
+
+	return &simdev->vdpa;
+}
+
+static void vdpa_dev_del(struct vdpa_parent_dev *pdev, struct vdpa_device =
*dev)
+{
+	struct vdpasim *simdev =3D container_of(dev, struct vdpasim, vdpa);
+
+	_vdpa_unregister_device(&simdev->vdpa);
+}
+
+static const struct vdpa_dev_ops vdpa_dev_parent_ops =3D {
+	.dev_add =3D vdpa_dev_add,
+	.dev_del =3D vdpa_dev_del
+};
+
+static struct virtio_device_id id_table[] =3D {
+	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct vdpa_parent_dev parent_dev =3D {
+	.device =3D &vdpasim_parent,
+	.id_table =3D id_table,
+	.ops =3D &vdpa_dev_parent_ops,
+};
+
 static int __init vdpasim_dev_init(void)
 {
-	vdpasim_dev =3D vdpasim_create();
+	int ret;
=20
-	if (!IS_ERR(vdpasim_dev))
-		return 0;
+	ret =3D device_register(&vdpasim_parent);
+	if (ret)
+		return ret;
+
+	ret =3D vdpa_parentdev_register(&parent_dev);
+	if (ret)
+		goto parent_err;
=20
-	return PTR_ERR(vdpasim_dev);
+	return 0;
+
+parent_err:
+	device_unregister(&vdpasim_parent);
+	return ret;
 }
=20
 static void __exit vdpasim_dev_exit(void)
 {
-	struct vdpa_device *vdpa =3D &vdpasim_dev->vdpa;
-
-	vdpa_unregister_device(vdpa);
+	vdpa_parentdev_unregister(&parent_dev);
+	device_unregister(&vdpasim_parent);
 }
=20
 module_init(vdpasim_dev_init)
--=20
2.26.2

