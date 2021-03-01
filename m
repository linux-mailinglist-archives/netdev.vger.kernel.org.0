Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB183277A4
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhCAGb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:31:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17469 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhCAG3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:29:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603c898c0004>; Sun, 28 Feb 2021 22:28:28 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 06:28:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Mar 2021 06:28:26 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>
Subject: [PATCH] vdpa/mlx5: Fix wrong use of bit numbers
Date:   Mon, 1 Mar 2021 08:28:17 +0200
Message-ID: <20210301062817.39331-1-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614580108; bh=nZ8RikqyTlTHqW01K1zLOKFk/xXep/HRaVtF/ixnczo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=dD0mP5OQNqww5n1J5woUoxNMK5ZP21bFHXrrGuX3hqcDczgPIFQKJyLWtsikqNyEj
         /9X6FVM4cTe/SyEGn4arCHyExJYJc/VAGSphSMj+UQa+tuiwXGIAB1D0B4hisWKqc6
         O9wCSQY3gY0cvg266vuODv/NF6iW0uDFEaC7bZWHW98OMjhUDJ8c20Dxi15cbdvL23
         HHWxv7UD4MF9fZ0+iVq6YEYb/PmM0HayWHkYt10qOJs+0qA/xw9In/zTRlwgBz7SW1
         Bd//cdAdJDAvL3heRntTp8b58NSpFv7qhok8niDoU08GVqaGvGa2gr+7p5RlcFN6N9
         XkPjn3+Crm6lA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
conditionals.

Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
the rest of the code.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices=
")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index dc7031132fff..7d21b857a94a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -821,7 +821,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev,=
 struct mlx5_vdpa_virtque
 	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
 	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
 	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
-		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
+		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
@@ -1578,7 +1578,7 @@ static void teardown_virtqueues(struct mlx5_vdpa_net =
*ndev)
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
 	return virtio_legacy_is_little_endian() ||
-		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
+		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
 }
=20
 static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
--=20
2.30.1

