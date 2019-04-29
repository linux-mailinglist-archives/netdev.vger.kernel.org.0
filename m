Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F12DDE8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfD2If2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfD2If2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:28 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D554220578;
        Mon, 29 Apr 2019 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526927;
        bh=PLsAJ0z1CCFZ7RLY1ETKnM8Jmmh6v9BTe7dbPkB/oDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcGgFEdDTRtAgSn5z1lac+m9mvbA7V5xPQe2cUMoQeGySeqSI5IjBHEBz3fmLv5l4
         DtGnTB7oaxxIfQ/kbld0xAv2QVx2AXDdC5/rhU6PD9WzTLHet2zQzYH6KUJuew4wRS
         1D9F5S7xGkDj1TvK9RJ7z2av86C8O9iZgTbVdBao=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 09/17] IB/mlx5: Support statistic q counter configuration
Date:   Mon, 29 Apr 2019 11:34:45 +0300
Message-Id: <20190429083453.16654-10-leon@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
References: <20190429083453.16654-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add support for ib callbacks counter_bind_qp() and counter_unbind_qp().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 06da76df4aa1..18a3e855d45b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5450,6 +5450,59 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
+				   struct ib_qp *qp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	u16 cnt_set_id = 0;
+	int err;
+
+	if (counter->id == 0) {
+		err = mlx5_cmd_alloc_q_counter(dev->mdev,
+					       &cnt_set_id,
+					       MLX5_SHARED_RESOURCE_UID);
+		if (err)
+			return err;
+		counter->id = cnt_set_id;
+	}
+
+	err = mlx5_ib_qp_set_counter(qp, counter);
+	if (err)
+		goto fail_set_counter;
+
+	return 0;
+
+fail_set_counter:
+	if (cnt_set_id != 0) {
+		mlx5_core_dealloc_q_counter(dev->mdev, cnt_set_id);
+		counter->id = 0;
+	}
+
+	return err;
+}
+
+static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp, bool force)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct rdma_counter *counter = qp->counter;
+	int err;
+
+	err = mlx5_ib_qp_set_counter(qp, NULL);
+	if (err && !force)
+		return err;
+
+	/*
+	 * Deallocate the counter if this is the last QP bound on it;
+	 * If @force is set then we still deallocate the q counter
+	 * no matter if there's any error in previous. used for cases
+	 * like qp destroy.
+	 */
+	if (atomic_read(&counter->usecnt) == 1)
+		return mlx5_core_dealloc_q_counter(dev->mdev, counter->id);
+
+	return 0;
+}
+
 static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
@@ -6306,6 +6359,8 @@ static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
 static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.alloc_hw_stats = mlx5_ib_alloc_hw_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
+	.counter_bind_qp = mlx5_ib_counter_bind_qp,
+	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
 };
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1

