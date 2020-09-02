Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C76425A6FB
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIBHpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgIBHpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:45:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F0A20826;
        Wed,  2 Sep 2020 07:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032715;
        bh=GIgXMYtPxyeF+td39Ayw/a+MKlrS9lFGK5YHMg0vgRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj+KGky3wPJ+EUmcK6TeyOEd+eT9R8mL46JXEJuEu/Ql5VHKG44mum57zcJfwYeiP
         SAHNe/XRdFvPuYoFcbxxzXLMe6xfL8aM8mZ0JMgBk/ZAbevlE2MUJcprauvoVWXkjS
         U5VDKgsYUAwcQa9T3nzhEEcNOaiYaeN6ywT6yMZo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 2/3] RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
Date:   Wed,  2 Sep 2020 10:45:02 +0300
Message-Id: <20200902074503.743310-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200902074503.743310-1-leon@kernel.org>
References: <20200902074503.743310-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

Combine two same enums to avoid duplication.

Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 20 ++++++-------------
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  8 --------
 include/linux/mlx5/port.h                     |  8 ++++++++
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ca33ff4b1d5e..545f23d27660 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1179,32 +1179,24 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	return 0;
 }
 
-enum mlx5_ib_width {
-	MLX5_IB_WIDTH_1X	= 1 << 0,
-	MLX5_IB_WIDTH_2X	= 1 << 1,
-	MLX5_IB_WIDTH_4X	= 1 << 2,
-	MLX5_IB_WIDTH_8X	= 1 << 3,
-	MLX5_IB_WIDTH_12X	= 1 << 4
-};
-
 static void translate_active_width(struct ib_device *ibdev, u16 active_width,
 				   u8 *ib_width)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 
-	if (active_width & MLX5_IB_WIDTH_1X)
+	if (active_width & MLX5_PTYS_WIDTH_1X)
 		*ib_width = IB_WIDTH_1X;
-	else if (active_width & MLX5_IB_WIDTH_2X)
+	else if (active_width & MLX5_PTYS_WIDTH_2X)
 		*ib_width = IB_WIDTH_2X;
-	else if (active_width & MLX5_IB_WIDTH_4X)
+	else if (active_width & MLX5_PTYS_WIDTH_4X)
 		*ib_width = IB_WIDTH_4X;
-	else if (active_width & MLX5_IB_WIDTH_8X)
+	else if (active_width & MLX5_PTYS_WIDTH_8X)
 		*ib_width = IB_WIDTH_8X;
-	else if (active_width & MLX5_IB_WIDTH_12X)
+	else if (active_width & MLX5_PTYS_WIDTH_12X)
 		*ib_width = IB_WIDTH_12X;
 	else {
 		mlx5_ib_dbg(dev, "Invalid active_width %d, setting width to default value: 4x\n",
-			    (int)active_width);
+			    active_width);
 		*ib_width = IB_WIDTH_4X;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 17f5be801d2f..cac8f085b16d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -130,14 +130,6 @@ static int mlx5i_flash_device(struct net_device *netdev,
 	return mlx5e_ethtool_flash_device(priv, flash);
 }
 
-enum mlx5_ptys_width {
-	MLX5_PTYS_WIDTH_1X	= 1 << 0,
-	MLX5_PTYS_WIDTH_2X	= 1 << 1,
-	MLX5_PTYS_WIDTH_4X	= 1 << 2,
-	MLX5_PTYS_WIDTH_8X	= 1 << 3,
-	MLX5_PTYS_WIDTH_12X	= 1 << 4,
-};
-
 static inline int mlx5_ptys_width_enum_to_int(enum mlx5_ptys_width width)
 {
 	switch (width) {
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 4d33ae0c2d97..23edd2db4803 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -125,6 +125,14 @@ enum mlx5e_connector_type {
 	MLX5E_CONNECTOR_TYPE_NUMBER,
 };
 
+enum mlx5_ptys_width {
+	MLX5_PTYS_WIDTH_1X	= 1 << 0,
+	MLX5_PTYS_WIDTH_2X	= 1 << 1,
+	MLX5_PTYS_WIDTH_4X	= 1 << 2,
+	MLX5_PTYS_WIDTH_8X	= 1 << 3,
+	MLX5_PTYS_WIDTH_12X	= 1 << 4,
+};
+
 #define MLX5E_PROT_MASK(link_mode) (1 << link_mode)
 #define MLX5_GET_ETH_PROTO(reg, out, ext, field)	\
 	(ext ? MLX5_GET(reg, out, ext_##field) :	\
-- 
2.26.2

