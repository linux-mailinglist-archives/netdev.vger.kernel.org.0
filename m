Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAD431E717
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhBRHrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:47:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2172 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhBRHn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 02:43:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602e1a960004>; Wed, 17 Feb 2021 23:43:18 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 07:43:18 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Feb 2021 07:43:16 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>
Subject: [PATCH v1] vdpa/mlx5: Fix suspend/resume index restoration
Date:   Thu, 18 Feb 2021 09:43:11 +0200
Message-ID: <20210218074311.43349-1-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613634198; bh=xS8bj/G1yMWPByDr4eY7YM5G0bjVAWEiw9WYar3h77E=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=SQ11Ch1ozF2uFFiSDEODxbeCYpRdlwhDzHikythb3jepLvvecy4C/hcOeTXQM3oif
         jytlSG86NLKVIfCXB/VW0Pa8V9NqcDC3BoemjWhOrO45fNIUcVFuIj8XJxeVvbG6rV
         dMe/BAsAtnzzlB72b/qhbsPhTG4Uiww26kcbjYE1hsTB/kfMXdzncagQzWfO6HbpzK
         NUwJt2ug8oEbrIzmbiH7keznLTEYSnoB1EzL6B0EfrGoj7Q4sbv8p9vqRhcH+Msmpv
         amatiR7/e4rt3fta7nkNkCsv66WmQfNVwI590h8mxvwQ+c00cKYMruK/DJ1mnMMrF0
         OQGBdHgwkOfkw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we suspend the VM, the VDPA interface will be reset. When the VM is
resumed again, clear_virtqueues() will clear the available and used
indices resulting in hardware virqtqueue objects becoming out of sync.
We can avoid this function alltogether since qemu will clear them if
required, e.g. when the VM went through a reboot.

Moreover, since the hw available and used indices should always be
identical on query and should be restored to the same value same value
for virtqueues that complete in order, we set the single value provided
by set_vq_state(). In get_vq_state() we return the value of hardware
used index.

Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after chan=
ge map")
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices=
")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
v0->v1:
Fix subject prefix

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index b8e9d525d66c..a51b0f86afe2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, st=
ruct mlx5_vdpa_virtqueue *m
 		return;
 	}
 	mvq->avail_idx =3D attr.available_index;
+	mvq->used_idx =3D attr.used_index;
 }
=20
 static void suspend_vqs(struct mlx5_vdpa_net *ndev)
@@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device =
*vdev, u16 idx,
 		return -EINVAL;
 	}
=20
+	mvq->used_idx =3D state->avail_index;
 	mvq->avail_idx =3D state->avail_index;
 	return 0;
 }
@@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device =
*vdev, u16 idx, struct vdpa
 	 * that cares about emulating the index after vq is stopped.
 	 */
 	if (!mvq->initialized) {
-		state->avail_index =3D mvq->avail_idx;
+		state->avail_index =3D mvq->used_idx;
 		return 0;
 	}
=20
@@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device =
*vdev, u16 idx, struct vdpa
 		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
 		return err;
 	}
-	state->avail_index =3D attr.available_index;
+	state->avail_index =3D attr.used_index;
 	return 0;
 }
=20
@@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net=
 *ndev)
 	}
 }
=20
-static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
-{
-	int i;
-
-	for (i =3D ndev->mvdev.max_vqs - 1; i >=3D 0; i--) {
-		ndev->vqs[i].avail_idx =3D 0;
-		ndev->vqs[i].used_idx =3D 0;
-	}
-}
-
 /* TODO: cross-endian support */
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
@@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *=
vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
-		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status =3D 0;
 		++mvdev->generation;
--=20
2.29.2

