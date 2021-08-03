Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5033DF857
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhHCXUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhHCXUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B787D60F94;
        Tue,  3 Aug 2021 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032819;
        bh=Eyax6avRleEjEtCaI7hHY+JEdQxmSBAv/5kk0G0HAZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwqN/2Gi+Qws5up0hgcenvrscmPvifdYiu/IH7ZuUDwawT+8iW7IA0Y1sfzF8LZX/
         PVk8ldm3fEJPkL7h+u3il98CEydzCSR+mOcEdNXE70MxZlSMF+siK+k550ScGC3jhA
         WT5VwEFy68iR8L7H/VGwaBiLyRe3jarrzXm/fdCoTWReONyU2qUbGIF9eBVodkfcvR
         8N+4CNko2BPlZbIqcyE2SRppC225kB83M6KGY9GrpPjH0DDOxyVMxRk2pCJzmj4hgt
         /uiEPnFvjyPVBYvPh2hfA9z+xYHG6wJxIh/5f7/F05zYnwC4Q6WWjsdhTk8ASIfvJe
         FYlwJvcQUtSlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 03/14] RDMA/mlx5: Fill port info based on the relevant eswitch
Date:   Tue,  3 Aug 2021 16:19:48 -0700
Message-Id: <20210803231959.26513-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

In shared FDB a single RDMA device can have representors that are
connected to two different eswitches. Use the right eswitch when
preparing the response to userspace.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/std_types.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index c0ddf7b3c6e2..bbfcce3bdc84 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -114,14 +114,18 @@ static int fill_vport_vhca_id(struct mlx5_core_dev *mdev, u16 vport,
 static int fill_switchdev_info(struct mlx5_ib_dev *dev, u32 port_num,
 			       struct mlx5_ib_uapi_query_port *info)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_eswitch_rep *rep;
+	struct mlx5_core_dev *mdev;
 	int err;
 
 	rep = dev->port[port_num - 1].rep;
 	if (!rep)
 		return -EOPNOTSUPP;
 
+	mdev = mlx5_eswitch_get_core_dev(rep->esw);
+	if (!mdev)
+		return -EINVAL;
+
 	info->vport = rep->vport;
 	info->flags |= MLX5_IB_UAPI_QUERY_PORT_VPORT;
 
@@ -138,9 +142,9 @@ static int fill_switchdev_info(struct mlx5_ib_dev *dev, u32 port_num,
 	if (err)
 		return err;
 
-	if (mlx5_eswitch_vport_match_metadata_enabled(mdev->priv.eswitch)) {
+	if (mlx5_eswitch_vport_match_metadata_enabled(rep->esw)) {
 		info->reg_c0.value = mlx5_eswitch_get_vport_metadata_for_match(
-			mdev->priv.eswitch, rep->vport);
+			rep->esw, rep->vport);
 		info->reg_c0.mask = mlx5_eswitch_get_vport_metadata_mask();
 		info->flags |= MLX5_IB_UAPI_QUERY_PORT_VPORT_REG_C0;
 	}
-- 
2.31.1

