Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC04211CBEC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfLLLJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbfLLLJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 06:09:48 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25AE2464B;
        Thu, 12 Dec 2019 11:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148988;
        bh=K0OHM1apI/1aRyyNvhqVG/F9HzYrAWuhoWs6bqrHGf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmU0NCLIyXpbIYBirbxn+VF8JNI6rv/Q9eUgv0FZtNw4umVr4q826y3O3E9jBHoaB
         lmE3O66FTI1YPJx+R12Mx0Oclt4BGOaDvp3rQF4J/Z2rgJ0NKF7xm5rK6cdWSILvqC
         ICy0PcEvdwCqOaZffmbYhhcemeVUibzUCxjSHryc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Expose vDPA emulation device capabilities
Date:   Thu, 12 Dec 2019 13:09:25 +0200
Message-Id: <20191212110928.334995-3-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212110928.334995-1-leon@kernel.org>
References: <20191212110928.334995-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose vDPA emulation device capabilities from the core layer.
It includes reading the capabilities from the firmware and exposing
helper functions to access the data.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Shahaf Shuler <shahafs@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 7 +++++++
 include/linux/mlx5/device.h                  | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index a19790dee7b2..c375edfe528c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -245,6 +245,13 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
+		MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_VDPA_EMULATION);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index cc1c230f10ee..1a1c53f0262d 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1105,6 +1105,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_MEM,
 	MLX5_CAP_RESERVED_16,
 	MLX5_CAP_TLS,
+	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
@@ -1297,6 +1298,14 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_DEV_EVENT(mdev, cap)\
 	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca_cur[MLX5_CAP_DEV_EVENT], cap)
 
+#define MLX5_CAP_DEV_VDPA_EMULATION(mdev, cap)\
+	MLX5_GET(device_virtio_emulation_cap, \
+		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
+
+#define MLX5_CAP64_DEV_VDPA_EMULATION(mdev, cap)\
+	MLX5_GET64(device_virtio_emulation_cap, \
+		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
-- 
2.20.1

