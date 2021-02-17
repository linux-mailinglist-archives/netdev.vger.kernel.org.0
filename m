Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61931D880
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhBQLgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:36:44 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1547 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhBQLcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:32:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602cfea00000>; Wed, 17 Feb 2021 03:31:44 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 11:31:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Feb 2021 11:31:41 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH 2/2 v1] vdpa/mlx5: Enable user to add/delete vdpa device
Date:   Wed, 17 Feb 2021 13:31:36 +0200
Message-ID: <20210217113136.10215-1-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613561504; bh=unIW7Wif70ezYpZSKFhSrHKcyNgOKUR99rWXKNmgXio=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=VONAh0bk//sE0yUbpMmULiksBrz1JRJ17f7A8h7HecllALmPvTrE/nobgGJj3hTCl
         6GSOrIYHNlWS38kV6eRBeFmz6teBJkCH7lAwFBQFzXARU5/bS3aDy16EYTFszkU0gu
         4zCiS99l1pPufK8hzI0NH2HozazROftGSvWZufQ3K/Jg1hrPnJYkn70uUz/HKEAnTo
         2/PDrcPP69+pkBSvsH2fSo7Gjp3jchROidXTSlMZ7t9nuu79lbaL/LbGU8F9AWFdPK
         2wXcI6MzzBunonwSVYMA1SZTspX/eKMgo7NmxRhYGr6FV/VaXHwldHTqOaSZVuEKE2
         JoJtLvDcYLA8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to control vdpa device creation and destruction using the vdpa
management tool.

Examples:
1. List the management devices
$ vdpa mgmtdev show
pci/0000:3b:00.1:
  supported_classes net

2. Create vdpa instance
$ vdpa dev add mgmtdev pci/0000:3b:00.1 name vdpa0

3. Show vdpa devices
$ vdpa dev show
vdpa0: type network mgmtdev pci/0000:3b:00.1 vendor_id 5555 max_vqs 16 \
max_vq_size 256

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
v0->v1:
set mgtdev->ndev NULL on dev delete=20

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 79 +++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index a51b0f86afe2..08fb481ddc4f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1974,23 +1974,32 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
 	}
 }
=20
-static int mlx5v_probe(struct auxiliary_device *adev,
-		       const struct auxiliary_device_id *id)
+struct mlx5_vdpa_mgmtdev {
+	struct vdpa_mgmt_dev mgtdev;
+	struct mlx5_adev *madev;
+	struct mlx5_vdpa_net *ndev;
+};
+
+static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *nam=
e)
 {
-	struct mlx5_adev *madev =3D container_of(adev, struct mlx5_adev, adev);
-	struct mlx5_core_dev *mdev =3D madev->mdev;
+	struct mlx5_vdpa_mgmtdev *mgtdev =3D container_of(v_mdev, struct mlx5_vdp=
a_mgmtdev, mgtdev);
 	struct virtio_net_config *config;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
+	struct mlx5_core_dev *mdev;
 	u32 max_vqs;
 	int err;
=20
+	if (mgtdev->ndev)
+		return -ENOSPC;
+
+	mdev =3D mgtdev->madev->mdev;
 	/* we save one virtqueue for control virtqueue should we require it */
 	max_vqs =3D MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
 	max_vqs =3D min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
=20
 	ndev =3D vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device=
, &mlx5_vdpa_ops,
-				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
+				 2 * mlx5_vdpa_max_qps(max_vqs), name);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
=20
@@ -2018,11 +2027,12 @@ static int mlx5v_probe(struct auxiliary_device *ade=
v,
 	if (err)
 		goto err_res;
=20
-	err =3D vdpa_register_device(&mvdev->vdev);
+	mvdev->vdev.mdev =3D &mgtdev->mgtdev;
+	err =3D _vdpa_register_device(&mvdev->vdev);
 	if (err)
 		goto err_reg;
=20
-	dev_set_drvdata(&adev->dev, ndev);
+	mgtdev->ndev =3D ndev;
 	return 0;
=20
 err_reg:
@@ -2035,11 +2045,62 @@ static int mlx5v_probe(struct auxiliary_device *ade=
v,
 	return err;
 }
=20
+static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_de=
vice *dev)
+{
+	struct mlx5_vdpa_mgmtdev *mgtdev =3D container_of(v_mdev, struct mlx5_vdp=
a_mgmtdev, mgtdev);
+
+	_vdpa_unregister_device(dev);
+	mgtdev->ndev =3D NULL;
+}
+
+static const struct vdpa_mgmtdev_ops mdev_ops =3D {
+	.dev_add =3D mlx5_vdpa_dev_add,
+	.dev_del =3D mlx5_vdpa_dev_del,
+};
+
+static struct virtio_device_id id_table[] =3D {
+	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static int mlx5v_probe(struct auxiliary_device *adev,
+		       const struct auxiliary_device_id *id)
+
+{
+	struct mlx5_adev *madev =3D container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev =3D madev->mdev;
+	struct mlx5_vdpa_mgmtdev *mgtdev;
+	int err;
+
+	mgtdev =3D kzalloc(sizeof(*mgtdev), GFP_KERNEL);
+	if (!mgtdev)
+		return -ENOMEM;
+
+	mgtdev->mgtdev.ops =3D &mdev_ops;
+	mgtdev->mgtdev.device =3D mdev->device;
+	mgtdev->mgtdev.id_table =3D id_table;
+	mgtdev->madev =3D madev;
+
+	err =3D vdpa_mgmtdev_register(&mgtdev->mgtdev);
+	if (err)
+		goto reg_err;
+
+	dev_set_drvdata(&adev->dev, mgtdev);
+
+	return 0;
+
+reg_err:
+	kfree(mdev);
+	return err;
+}
+
 static void mlx5v_remove(struct auxiliary_device *adev)
 {
-	struct mlx5_vdpa_dev *mvdev =3D dev_get_drvdata(&adev->dev);
+	struct mlx5_vdpa_mgmtdev *mgtdev;
=20
-	vdpa_unregister_device(&mvdev->vdev);
+	mgtdev =3D dev_get_drvdata(&adev->dev);
+	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
+	kfree(mgtdev);
 }
=20
 static const struct auxiliary_device_id mlx5v_id_table[] =3D {
--=20
2.29.2

