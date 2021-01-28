Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4215D307754
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhA1NmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:42:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15016 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhA1NmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:42:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012bf140000>; Thu, 28 Jan 2021 05:41:40 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 13:41:39 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 28 Jan 2021 13:41:38 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <elic@nvidia.com>
Subject: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
Date:   Thu, 28 Jan 2021 15:41:29 +0200
Message-ID: <20210128134130.3051-2-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210128134130.3051-1-elic@nvidia.com>
References: <20210128134130.3051-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611841300; bh=QzVmpWS/9RpRWjdiIGYNzNFNLuYC8ol4oTlpuimJugI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=r6Wv6IOER0gAyx6PbPPK+DjaXh0YYofNbVhynH9IonUa/f5MI1hvFTSs0E+XJ7eK5
         FsZlV2+CdBvyQ/LbUVnpJx3wr0CkAwlcljueqT5Byzs2YHd8mpN+wSe9NLEsYwLUWx
         04f9LZFWS7d1Jg6OK201DGlI7nA11boU114lfj4L3h82Dwt3LUmN8dexeMZT4yGAVz
         lTT/TAIjmjcHPeOHl/qTg1D+Z5aJt8ijJ2eIyrBsy0aINlbd4WUg2FDwQ8wNjRDECi
         kxMwiW0t5SADMgxtmUZmpDCSA3Wyc7AtRMDSH9tISPFSSO0cEf3f9Z+TatOd9YFcyM
         H3gAZdNDQKq9w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

suspend_vq should only suspend the VQ on not save the current available
index. This is done when a change of map occurs when the driver calls
save_channel_info().

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index 88dde3455bfd..549ded074ff3 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struc=
t mlx5_vdpa_virtqueue *mvq)
=20
 static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu=
eue *mvq)
 {
-	struct mlx5_virtq_attr attr;
-
 	if (!mvq->initialized)
 		return;
=20
@@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, s=
truct mlx5_vdpa_virtqueue *m
=20
 	if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
 		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
-
-	if (query_virtqueue(ndev, mvq, &attr)) {
-		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
-		return;
-	}
-	mvq->avail_idx =3D attr.available_index;
 }
=20
 static void suspend_vqs(struct mlx5_vdpa_net *ndev)
--=20
2.29.2

