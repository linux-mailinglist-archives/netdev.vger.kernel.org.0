Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC082D18
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbfHFHsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfHFHsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 03:48:22 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAF1206A2;
        Tue,  6 Aug 2019 07:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565077701;
        bh=mr1mypDDs4Ad4WE/fiyJ3l8cfS/rbaQiAQKIFkYEtPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4Tk9XAxosRkUXOL8iRDmr5sClXAi2xjqmS/YbUml6Y02RmhtSxaGtskzCxLWX00K
         TmUOfjClzO+6etzfCYePBh1NrGe109BjryQ8Wqz8dMps/Xsx7xAw1o2rw+SY1j9T5f
         127HZd+NMfnzMO3Lxer/SgFvg4iumPq4jYK/+mpQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 2/4] IB/mlx5: Query ODP capabilities for DC
Date:   Tue,  6 Aug 2019 10:48:05 +0300
Message-Id: <20190806074807.9111-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806074807.9111-1-leon@kernel.org>
References: <20190806074807.9111-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Cache current ODP capabilities for DC in mlx5_ib device.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/odp.c     | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

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
-- 
2.20.1

