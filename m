Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3AB307756
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhA1Nmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:42:31 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3770 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbhA1NmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:42:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012bf160000>; Thu, 28 Jan 2021 05:41:42 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 13:41:42 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 28 Jan 2021 13:41:40 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <elic@nvidia.com>
Subject: [PATCH 2/2] vdpa/mlx5: Restore the hardware used index after change map
Date:   Thu, 28 Jan 2021 15:41:30 +0200
Message-ID: <20210128134130.3051-3-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210128134130.3051-1-elic@nvidia.com>
References: <20210128134130.3051-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611841302; bh=IFlMDEIxvzjHdYWrKcoi8vXYhv/8Yu71KrZqCZIncug=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=BvxHkqofYHLBx3nnZ/Il4gN/fHXyqJqrCB7fd0ksfLgQAp5P2lqsyCtngdXnRlxNM
         E5KXQ+W8AoA5DifxVlYN3Bp6aa+HBduqvJc2F7oLVQBzJvS6b+xwyuVLoP6ctHolrf
         nbzVGTjLRw6i9GQKh7uHCxK/XWKUteYu+bReucImwwp/G2mBLg9SW8M0RLhxRv16Dq
         tQjhu0Zswd4YkyPhgLdmsUMtTPs3GD8/LF76qpgI+TrBtJPJISriJKwJr1iLOpJUHT
         PcCQzBMCuF4UhHQwm5oCOmrhXKELhvBOEEvPKd5p4CVTM1mAtKniRbrD7trJbgiryv
         EyL5rVxFgSIxw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a change of memory map occurs, the hardware resources are destroyed
and then re-created again with the new memory map. In such case, we need
to restore the hardware available and used indices. The driver failed to
restore the used index which is added here.

Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices"=
)
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index 549ded074ff3..3fc8588cecae 100644
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
@@ -1602,6 +1607,7 @@ static int save_channel_info(struct mlx5_vdpa_net *nd=
ev, struct mlx5_vdpa_virtqu
 		return err;
=20
 	ri->avail_index =3D attr.available_index;
+	ri->used_index =3D attr.used_index;
 	ri->ready =3D mvq->ready;
 	ri->num_ent =3D mvq->num_ent;
 	ri->desc_addr =3D mvq->desc_addr;
@@ -1646,6 +1652,7 @@ static void restore_channels_info(struct mlx5_vdpa_ne=
t *ndev)
 			continue;
=20
 		mvq->avail_idx =3D ri->avail_index;
+		mvq->used_idx =3D ri->used_index;
 		mvq->ready =3D ri->ready;
 		mvq->num_ent =3D ri->num_ent;
 		mvq->desc_addr =3D ri->desc_addr;
--=20
2.29.2

