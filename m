Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4567DB47
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfHAMVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfHAMVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:21:48 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C3220838;
        Thu,  1 Aug 2019 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564662107;
        bh=Rtk6U7EiDjBgEU7EoLUkbC8qd00Qm2tk1eW9nxTWRiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcVpTKV8KlGtMZ7gZ/a0OF4LRNQoesumTou7Lbk0/7s1HD8QpapUicnPV9cxx8t3D
         r5Hw5h4O0jkWJN1C4M/925F3TDk3zPH75Rv8qKtg1kb0kFj6F0A4CnqDyiH3D6kHwH
         1IRQwtRry79p09zXTVxaOW43lq5YmQaDez/B7ZJQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/3] IB/mlx5: Query ODP capabilities for DC
Date:   Thu,  1 Aug 2019 15:21:37 +0300
Message-Id: <20190801122139.25224-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801122139.25224-1-leon@kernel.org>
References: <20190801122139.25224-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Set current capabilities of ODP for DC to max capabilities and cache
them in mlx5_ib.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  1 +
 drivers/infiniband/hw/mlx5/odp.c               | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  6 ++++++
 include/linux/mlx5/mlx5_ifc.h                  |  4 +++-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index cb41a7e6255a..f99c71b3c876 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -967,6 +967,7 @@ struct mlx5_ib_dev {
 	struct mutex			slow_path_mutex;
 	int				fill_delay;
 	struct ib_odp_caps	odp_caps;
+	uint32_t		dc_odp_caps;
 	u64			odp_max_size;
 	struct mlx5_ib_pf_eq	odp_pf_eq;
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b0c5de39d186..5e87a5e25574 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -353,6 +353,24 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.srq_receive))
 		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
 
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.send))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_SEND;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.receive))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_RECV;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.write))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_WRITE;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.read))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_READ;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.atomic))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
+
+	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.srq_receive))
+		dev->dc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
+
 	if (MLX5_CAP_GEN(dev->mdev, fixed_buffer_size) &&
 	    MLX5_CAP_GEN(dev->mdev, null_mkey) &&
 	    MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b15b27a497fc..3995fc6d4d34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -495,6 +495,12 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.send);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.receive);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.write);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
+	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
 	if (do_set)
 		err = set_caps(dev, set_ctx, set_sz,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ec571fd7fcf8..5eae8d734435 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
 
 	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
 
-	u8         reserved_at_100[0x700];
+	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
+
+	u8         reserved_at_100[0x6E0];
 };
 
 struct mlx5_ifc_calc_op {
-- 
2.20.1

