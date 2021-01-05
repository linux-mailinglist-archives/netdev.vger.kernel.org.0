Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0501A2EA8DA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbhAEKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:33:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14052 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbhAEKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:33:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff4403b0000>; Tue, 05 Jan 2021 02:32:27 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 10:32:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user supported devices
Date:   Tue, 5 Jan 2021 12:32:03 +0200
Message-ID: <20210105103203.82508-7-parav@nvidia.com>
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
        t=1609842747; bh=gn4F5SBfLOXMNlS33LbbkCqbPTCq/zzd2GtZSjD/Gys=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=IFp+maZRSDItiNDDArjf2W1BOhCq+Q1/tqKe+xpGExR01jMuz/FfBgPhlfCcsLgT6
         SOkRxbnx5y31qArVV6YiacQ01T4vL48U7G5WAVRKgS51PN+E6CleZ27E9VazcsGXtE
         dinFxoJv+4BNX2n9SrrJZbosPY8nB5aBUZSI1GaVSFG7l4PnP7dAVfOU+hjac2xy2H
         7mBj5CbEAMqoV19ACRNLI03cj6DJcgfOVfi0vV0AVWAk/eBPxX2jx9bVZt/QKnaLkd
         kPfX0msImkBgxhYyaWTsyQLxX8WoTfkdBCbDAzfWNyWciQwe0EaVDbpgcUINqEF07x
         YtTeGSoN74yXg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to create vdpasim net simulate devices.

Show vdpa management device that supports creating, deleting vdpa devices.

$ vdpa mgmtdev show
vdpasim_net:
  supported_classes
    net

$ vdpa mgmtdev show -jp
{
    "show": {
        "vdpasim_net": {
            "supported_classes": {
              "net"
        }
    }
}

Create a vdpa device of type networking named as "foo2" from
the management device vdpasim:

$ vdpa dev add mgmtdev vdpasim_net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 25=
6

$ vdpa dev show foo2 -jp
{
    "dev": {
        "foo2": {
            "type": "network",
            "mgmtdev": "vdpasim_net",
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
Changelog:
v2->v3:
 - removed code branches due to default device removal patch
v1->v2:
 - rebased
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     |  3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 96 ++++++++++++++++++++--------
 3 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_=
sim.c
index db1636a99ba4..d5942842432d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr =
*dev_attr)
 		ops =3D &vdpasim_config_ops;
=20
 	vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    dev_attr->nvqs, NULL);
+				    dev_attr->nvqs, dev_attr->name);
 	if (!vdpasim)
 		goto err_alloc;
=20
@@ -249,6 +249,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr =
*dev_attr)
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
+	vdpasim->vdpa.mdev =3D dev_attr->mgmt_dev;
=20
 	vdpasim->config =3D kzalloc(dev_attr->config_size, GFP_KERNEL);
 	if (!vdpasim->config)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_=
sim.h
index b02142293d5b..6d75444f9948 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -33,6 +33,8 @@ struct vdpasim_virtqueue {
 };
=20
 struct vdpasim_dev_attr {
+	struct vdpa_mgmt_dev *mgmt_dev;
+	const char *name;
 	u64 supported_features;
 	size_t config_size;
 	size_t buffer_size;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim_net.c
index f0482427186b..d344c5b7c914 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -35,8 +35,6 @@ MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
=20
 static u8 macaddr_buf[ETH_ALEN];
=20
-static struct vdpasim *vdpasim_net_dev;
-
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, work);
@@ -120,21 +118,23 @@ static void vdpasim_net_get_config(struct vdpasim *vd=
pasim, void *config)
 	memcpy(net_config->mac, macaddr_buf, ETH_ALEN);
 }
=20
-static int __init vdpasim_net_init(void)
+static void vdpasim_net_mgmtdev_release(struct device *dev)
+{
+}
+
+static struct device vdpasim_net_mgmtdev =3D {
+	.init_name =3D "vdpasim_net",
+	.release =3D vdpasim_net_mgmtdev_release,
+};
+
+static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *nam=
e)
 {
 	struct vdpasim_dev_attr dev_attr =3D {};
+	struct vdpasim *simdev;
 	int ret;
=20
-	if (macaddr) {
-		mac_pton(macaddr, macaddr_buf);
-		if (!is_valid_ether_addr(macaddr_buf)) {
-			ret =3D -EADDRNOTAVAIL;
-			goto out;
-		}
-	} else {
-		eth_random_addr(macaddr_buf);
-	}
-
+	dev_attr.mgmt_dev =3D mdev;
+	dev_attr.name =3D name;
 	dev_attr.id =3D VIRTIO_ID_NET;
 	dev_attr.supported_features =3D VDPASIM_NET_FEATURES;
 	dev_attr.nvqs =3D VDPASIM_NET_VQ_NUM;
@@ -143,29 +143,75 @@ static int __init vdpasim_net_init(void)
 	dev_attr.work_fn =3D vdpasim_net_work;
 	dev_attr.buffer_size =3D PAGE_SIZE;
=20
-	vdpasim_net_dev =3D vdpasim_create(&dev_attr);
-	if (IS_ERR(vdpasim_net_dev)) {
-		ret =3D PTR_ERR(vdpasim_net_dev);
-		goto out;
+	simdev =3D vdpasim_create(&dev_attr);
+	if (IS_ERR(simdev))
+		return PTR_ERR(simdev);
+
+	ret =3D _vdpa_register_device(&simdev->vdpa);
+	if (ret)
+		goto reg_err;
+
+	return 0;
+
+reg_err:
+	put_device(&simdev->vdpa.dev);
+	return ret;
+}
+
+static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
+				struct vdpa_device *dev)
+{
+	struct vdpasim *simdev =3D container_of(dev, struct vdpasim, vdpa);
+
+	_vdpa_unregister_device(&simdev->vdpa);
+}
+
+static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops =3D {
+	.dev_add =3D vdpasim_net_dev_add,
+	.dev_del =3D vdpasim_net_dev_del
+};
+
+static struct virtio_device_id id_table[] =3D {
+	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct vdpa_mgmt_dev mgmt_dev =3D {
+	.device =3D &vdpasim_net_mgmtdev,
+	.id_table =3D id_table,
+	.ops =3D &vdpasim_net_mgmtdev_ops,
+};
+
+static int __init vdpasim_net_init(void)
+{
+	int ret;
+
+	if (macaddr) {
+		mac_pton(macaddr, macaddr_buf);
+		if (!is_valid_ether_addr(macaddr_buf))
+			return -EADDRNOTAVAIL;
+	} else {
+		eth_random_addr(macaddr_buf);
 	}
=20
-	ret =3D vdpa_register_device(&vdpasim_net_dev->vdpa);
+	ret =3D device_register(&vdpasim_net_mgmtdev);
 	if (ret)
-		goto put_dev;
+		return ret;
=20
+	ret =3D vdpa_mgmtdev_register(&mgmt_dev);
+	if (ret)
+		goto parent_err;
 	return 0;
=20
-put_dev:
-	put_device(&vdpasim_net_dev->vdpa.dev);
-out:
+parent_err:
+	device_unregister(&vdpasim_net_mgmtdev);
 	return ret;
 }
=20
 static void __exit vdpasim_net_exit(void)
 {
-	struct vdpa_device *vdpa =3D &vdpasim_net_dev->vdpa;
-
-	vdpa_unregister_device(vdpa);
+	vdpa_mgmtdev_unregister(&mgmt_dev);
+	device_unregister(&vdpasim_net_mgmtdev);
 }
=20
 module_init(vdpasim_net_init);
--=20
2.26.2

