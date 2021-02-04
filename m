Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B756C30ED7B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhBDHhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:37:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12000 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbhBDHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:37:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601ba3f90001>; Wed, 03 Feb 2021 23:36:25 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 07:36:25 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 4 Feb 2021 07:36:23 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <lulu@redhat.com>, <elic@nvidia.com>
Subject: [PATCH v1] vdpa/mlx5: Restore the hardware used index after change map
Date:   Thu, 4 Feb 2021 09:36:18 +0200
Message-ID: <20210204073618.36336-1-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612424185; bh=SQJLeoiHUDk7V48beRRwq4hOUrhyW2x2dXNvzrQW7Hs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=mtLFjXzEdtPhOYfQyQLLAHTISl53x6edyTxNUdEHBw5bCaJpoRKXyxmoIGptWGxL+
         TOkvy0/6t/VrmaD7vXI+Fk3AID0zbUW/BbQOioHfE3iek3MtTflCrRmy9T3gv8aOr7
         MuxxFsOeV6IGu03iX7Q1CoXZoDyF2q6rHDGJbqwCnZNNtCFHKuOllwoGTSY7+LCINv
         wOHUSkXfEc1tRql4d9KT/VoUoeQ943NI63UVzWMvZbaqHjzoLfsKwZQKODKxVbJjqB
         LLpjjgCFZB2ZECqXPOFZKU+iLMCh7B9K+Vx/yASURHIZXZneek3y3/SxWeGBBaLBtC
         vEanq4vG/LXFA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a change of memory map occurs, the hardware resources are destroyed
and then re-created again with the new memory map. In such case, we need
to restore the hardware available and used indices. The driver failed to
restore the used index which is added here.

Also, since the driver also fails to reset the available and used
indices upon device reset, fix this here to avoid regression caused by
the fact that used index may not be zero upon device reset.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices=
")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
v0 -> v1:
Clear indices upon device reset

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index 88dde3455bfd..b5fe6d2ad22f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
 	u64 device_addr;
 	u64 driver_addr;
 	u16 avail_index;
+	u16 used_index;
 	bool ready;
 	struct vdpa_callback cb;
 	bool restore;
@@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
 	u32 virtq_id;
 	struct mlx5_vdpa_net *ndev;
 	u16 avail_idx;
+	u16 used_idx;
 	int fw_state;
=20
 	/* keep last in the struct */
@@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev,=
 struct mlx5_vdpa_virtque
=20
 	obj_context =3D MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
 	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail=
_idx);
+	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
 	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
 		 get_features_12_3(ndev->mvdev.actual_features));
 	vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_contex=
t);
@@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, st=
ruct mlx5_vdpa_virtqueue *m
 struct mlx5_virtq_attr {
 	u8 state;
 	u16 available_index;
+	u16 used_index;
 };
=20
 static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_vi=
rtqueue *mvq,
@@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev=
, struct mlx5_vdpa_virtqueu
 	memset(attr, 0, sizeof(*attr));
 	attr->state =3D MLX5_GET(virtio_net_q_object, obj_context, state);
 	attr->available_index =3D MLX5_GET(virtio_net_q_object, obj_context, hw_a=
vailable_index);
+	attr->used_index =3D MLX5_GET(virtio_net_q_object, obj_context, hw_used_i=
ndex);
 	kfree(out);
 	return 0;
=20
@@ -1535,6 +1540,16 @@ static void teardown_virtqueues(struct mlx5_vdpa_net=
 *ndev)
 	}
 }
=20
+static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
+{
+	int i;
+
+	for (i =3D ndev->mvdev.max_vqs - 1; i >=3D 0; i--) {
+		ndev->vqs[i].avail_idx =3D 0;
+		ndev->vqs[i].used_idx =3D 0;
+	}
+}
+
 /* TODO: cross-endian support */
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
@@ -1610,6 +1625,7 @@ static int save_channel_info(struct mlx5_vdpa_net *nd=
ev, struct mlx5_vdpa_virtqu
 		return err;
=20
 	ri->avail_index =3D attr.available_index;
+	ri->used_index =3D attr.used_index;
 	ri->ready =3D mvq->ready;
 	ri->num_ent =3D mvq->num_ent;
 	ri->desc_addr =3D mvq->desc_addr;
@@ -1654,6 +1670,7 @@ static void restore_channels_info(struct mlx5_vdpa_ne=
t *ndev)
 			continue;
=20
 		mvq->avail_idx =3D ri->avail_index;
+		mvq->used_idx =3D ri->used_index;
 		mvq->ready =3D ri->ready;
 		mvq->num_ent =3D ri->num_ent;
 		mvq->desc_addr =3D ri->desc_addr;
@@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *=
vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
+		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status =3D 0;
 		ndev->mvdev.mlx_features =3D 0;
--=20
2.29.2

