Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDF92220F8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgGPKxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgGPKxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:53:03 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656682074B;
        Thu, 16 Jul 2020 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594896782;
        bh=FxkVyDBr6F6Fb3mcpJvhc3x3m73mGxYuqPRFYAQXSTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxQ1hJfSOEbN5N7RWhvVT0IJbJvlPs0P/Q0EF8QsyQrwONhiFZyp/PRRhxft2NVcl
         liIwaChVe92VRTJ49DdtbK+yyHJHbNdp+Wyfmuw/yO+njX93Utc5lSlMMJqtMyPt9G
         JFPgKReeqOb+DQDd3tK7O4mqhB1dO6VNVUEIDmHo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Use MLX5_SET macro instead of local structure
Date:   Thu, 16 Jul 2020 13:52:47 +0300
Message-Id: <20200716105248.1423452-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716105248.1423452-1-leon@kernel.org>
References: <20200716105248.1423452-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Use generic mlx5 structure defined in mlx5_ifc.h to represent
ConnectX device data structures instead of using structure
defined specifically for mlx5_ib module

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 ---------
 drivers/infiniband/hw/mlx5/wr.c      | 26 ++++++++++++++++----------
 include/linux/mlx5/device.h          |  1 -
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 13a2d1f3f14d..52c384214f26 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1361,15 +1361,6 @@ static inline void init_query_mad(struct ib_smp *mad)
 	mad->method	   = IB_MGMT_METHOD_GET;
 }

-static inline u8 convert_access(int acc)
-{
-	return (acc & IB_ACCESS_REMOTE_ATOMIC ? MLX5_PERM_ATOMIC       : 0) |
-	       (acc & IB_ACCESS_REMOTE_WRITE  ? MLX5_PERM_REMOTE_WRITE : 0) |
-	       (acc & IB_ACCESS_REMOTE_READ   ? MLX5_PERM_REMOTE_READ  : 0) |
-	       (acc & IB_ACCESS_LOCAL_WRITE   ? MLX5_PERM_LOCAL_WRITE  : 0) |
-	       MLX5_PERM_LOCAL_READ;
-}
-
 static inline int is_qp1(enum ib_qp_type qp_type)
 {
 	return qp_type == MLX5_IB_QPT_HW_GSI;
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 2c6df1c43b55..e58ecb46f8e3 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -383,20 +383,26 @@ static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg,

 	memset(seg, 0, sizeof(*seg));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_DISABLE_MR)
-		seg->status = MLX5_MKEY_STATUS_FREE;
-
-	seg->flags = convert_access(umrwr->access_flags);
+		MLX5_SET(mkc, seg, free, 1);
+
+	MLX5_SET(mkc, seg, a,
+		 !!(umrwr->access_flags & IB_ACCESS_REMOTE_ATOMIC));
+	MLX5_SET(mkc, seg, rw,
+		 !!(umrwr->access_flags & IB_ACCESS_REMOTE_WRITE));
+	MLX5_SET(mkc, seg, rr, !!(umrwr->access_flags & IB_ACCESS_REMOTE_READ));
+	MLX5_SET(mkc, seg, lw, !!(umrwr->access_flags & IB_ACCESS_LOCAL_WRITE));
+	MLX5_SET(mkc, seg, lr, 1);
 	if (umrwr->pd)
-		seg->flags_pd = cpu_to_be32(to_mpd(umrwr->pd)->pdn);
+		MLX5_SET(mkc, seg, pd, to_mpd(umrwr->pd)->pdn);
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_TRANSLATION &&
 	    !umrwr->length)
-		seg->flags_pd |= cpu_to_be32(MLX5_MKEY_LEN64);
+		MLX5_SET(mkc, seg, length64, 1);

-	seg->start_addr = cpu_to_be64(umrwr->virt_addr);
-	seg->len = cpu_to_be64(umrwr->length);
-	seg->log2_page_size = umrwr->page_shift;
-	seg->qpn_mkey7_0 = cpu_to_be32(0xffffff00 |
-				       mlx5_mkey_variant(umrwr->mkey));
+	MLX5_SET64(mkc, seg, start_addr, umrwr->virt_addr);
+	MLX5_SET64(mkc, seg, len, umrwr->length);
+	MLX5_SET(mkc, seg, log_page_size, umrwr->page_shift);
+	MLX5_SET(mkc, seg, qpn, 0xffffff);
+	MLX5_SET(mkc, seg, mkey_7_0, mlx5_mkey_variant(umrwr->mkey));
 }

 static void set_reg_data_seg(struct mlx5_wqe_data_seg *dseg,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 57db125e5802..7940a574a618 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1007,7 +1007,6 @@ enum {
 	MLX5_MKEY_REMOTE_INVAL	= 1 << 24,
 	MLX5_MKEY_FLAG_SYNC_UMR = 1 << 29,
 	MLX5_MKEY_BSF_EN	= 1 << 30,
-	MLX5_MKEY_LEN64		= 1 << 31,
 };

 struct mlx5_mkey_seg {
--
2.26.2

