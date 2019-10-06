Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A94CD348
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfJFQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 12:00:14 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 971C42084B;
        Sun,  6 Oct 2019 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570377613;
        bh=CJx7f+FNEmjE8DUtf1fUmTY+NGFr8JWXDzKQxCBCc3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OX7BHEH/x/db9pun0htLPpJ/c5Ik8cXg3Ah2Ib5l2nyQHLKPR/K54duPXD6c6FF+n
         BQYndqwLRbuUfJF50VkbXILM9+fRdsB2oB3z5qzDBDZuYRJFo7AYFEsCeTp0ruPyp6
         OG+FYkb5vX6QY+iqRTexQlLkhh8+C54UpmgKT15M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Add capability for max sge to get optimized performance
Date:   Sun,  6 Oct 2019 18:59:54 +0300
Message-Id: <20191006155955.31445-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006155955.31445-1-leon@kernel.org>
References: <20191006155955.31445-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

Allows the IB device to provide a value of maximum scatter gather entries
per RDMA READ.

In certain cases it may be preferable for a device to perform UMR memory
registration rather than have many scatter entries in a single RDMA READ.
This provides a significant performance increase in devices capable of
using different memory registration schemes based on the number of scatter
gather entries. This general capability allows each device vendor to fine
tune when it is better to use memory registration.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 include/rdma/ib_verbs.h           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fa23c8e7043b..39d54e285ae9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1012,6 +1012,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
 	props->max_pi_fast_reg_page_list_len =
 		props->max_fast_reg_page_list_len / 2;
+	props->max_sgl_rd =
+		MLX5_CAP_GEN(mdev, max_sgl_for_optimized_performance);
 	get_atomic_caps_qp(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4f671378dbfc..60fd98a9b7e8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -445,6 +445,8 @@ struct ib_device_attr {
 	struct ib_tm_caps	tm_caps;
 	struct ib_cq_caps       cq_caps;
 	u64			max_dm_size;
+	/* Max entries for sgl for optimized performance per READ */
+	u32			max_sgl_rd;
 };
 
 enum ib_mtu {
-- 
2.20.1

