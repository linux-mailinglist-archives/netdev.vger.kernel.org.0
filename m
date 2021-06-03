Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B232239A213
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFCNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhFCNV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5093F613DE;
        Thu,  3 Jun 2021 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622726384;
        bh=9j9GzF6Q4GCPDZyS0DeXwr8ujEBp1dwwTd9/15ra8Ec=;
        h=From:To:Cc:Subject:Date:From;
        b=IUlZ6k3LO6iPZrSQEm1FScmy3raZxzW8XKhcKQiLsul9VHyCYWlIqghtf0naxo0wc
         kQN1IX0fevw8YEfWECpEscXST2IGBQ9SpuRB+A6av1Z6NQnEha25t/41skQq7Qi8do
         nOLHN/Xs0D5b/GWrCzwXvPKjOVA1KIlMY/TVKFFoDtv4Pke6mpjb5MXlplJg+91FXC
         EDwamJF0prRI9KQM4ZRQiphKioYJoUQj8a8PMw5p9b5MYdvc5TaL47FU3d9+lvjYjr
         Hthks5wdXEY+TqRI4yGqJn/OfLvMZkGvfEZ/7FSSK/I2IB80TvxnkGyJW/g2+SN5UL
         LtP/g7Cf5WyXw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shay Drory <shayd@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-rc] RDMA/mlx4: Map core_clock page to user space only when allowed
Date:   Thu,  3 Jun 2021 16:19:39 +0300
Message-Id: <9632304e0d6790af84b3b706d8c18732bc0d5e27.1622726305.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently when we map the hca_core_clock page to the user space,
there are vulnerable registers, one of which is semaphore, on
this page as well. If user read the wrong offset, it can modify the
above semaphore and hang the device.

Hence, mapping the hca_core_clock page to the user space only when
user required it specifically.

After this patch, mlx4 core_clock won't be mapped to user space by
default. Oppose to current state, where mlx4 core_clock is always mapped
to user space.

Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx4/main.c         | 5 +----
 drivers/net/ethernet/mellanox/mlx4/fw.c   | 3 +++
 drivers/net/ethernet/mellanox/mlx4/fw.h   | 1 +
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++++
 include/linux/mlx4/device.h               | 1 +
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 22898d97ecbd..16704262fc3a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -581,12 +581,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->cq_caps.max_cq_moderation_count = MLX4_MAX_CQ_COUNT;
 	props->cq_caps.max_cq_moderation_period = MLX4_MAX_CQ_PERIOD;
 
-	if (!mlx4_is_slave(dev->dev))
-		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-
 	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
 		resp.response_length += sizeof(resp.hca_core_clock_offset);
-		if (!err && !mlx4_is_slave(dev->dev)) {
+		if (!mlx4_get_internal_clock_params(dev->dev, &clock_params)) {
 			resp.comp_mask |= MLX4_IB_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET;
 			resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index f6cfec81ccc3..dc4ac1a2b6b6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -823,6 +823,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAD_DEMUX_OFFSET		0xb0
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_BASE_OFFSET	0xa8
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_RANGE_OFFSET	0xac
+#define QUERY_DEV_CAP_MAP_CLOCK_TO_USER 0xc1
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_NUM_OFFSET	0xcc
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MAX_OFFSET	0xd0
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MIN_OFFSET	0xd2
@@ -841,6 +842,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 
 	if (mlx4_is_mfunc(dev))
 		disable_unsupported_roce_caps(outbox);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAP_CLOCK_TO_USER);
+	dev_cap->map_clock_to_user = field & 0x80;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_QP_OFFSET);
 	dev_cap->reserved_qps = 1 << (field & 0xf);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index 8f020f26ebf5..cf64e54eecb0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -131,6 +131,7 @@ struct mlx4_dev_cap {
 	u32 health_buffer_addrs;
 	struct mlx4_port_cap port_cap[MLX4_MAX_PORTS + 1];
 	bool wol_port[MLX4_MAX_PORTS + 1];
+	bool map_clock_to_user;
 };
 
 struct mlx4_func_cap {
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index c326b434734e..00c84656b2e7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -498,6 +498,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		}
 	}
 
+	dev->caps.map_clock_to_user  = dev_cap->map_clock_to_user;
 	dev->caps.uar_page_size	     = PAGE_SIZE;
 	dev->caps.num_uars	     = dev_cap->uar_size / PAGE_SIZE;
 	dev->caps.local_ca_ack_delay = dev_cap->local_ca_ack_delay;
@@ -1948,6 +1949,11 @@ int mlx4_get_internal_clock_params(struct mlx4_dev *dev,
 	if (mlx4_is_slave(dev))
 		return -EOPNOTSUPP;
 
+	if (!dev->caps.map_clock_to_user) {
+		mlx4_dbg(dev, "Map clock to user is not supported.\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!params)
 		return -EINVAL;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 236a7d04f891..30bb59fe970c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -630,6 +630,7 @@ struct mlx4_caps {
 	bool			wol_port[MLX4_MAX_PORTS + 1];
 	struct mlx4_rate_limit_caps rl_caps;
 	u32			health_buffer_addrs;
+	bool			map_clock_to_user;
 };
 
 struct mlx4_buf_list {
-- 
2.31.1

