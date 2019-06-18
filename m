Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483BA4A852
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfFRR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfFRR1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:01 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85286214AF;
        Tue, 18 Jun 2019 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878820;
        bh=NrsqX8aBYkQD8KUdKGZPVZ1EoarimW8Byo34FyAi85I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9vLsO9SsLvWwcc9DAddUdI0Bx1mNci/L4Go6nJGkiX6sZd5FoDLr0YzUen+2rjS0
         XVQpZ8TU9IZ5fDOIT/P6/dlaQksigpiNe8pr6ALmfBtMn8bk9eSaYSNMqySnr4Gsx0
         idB/UpeEaL5VMnuDuQbc13qAVlLqMoP6ghaw0eBM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 09/17] IB/mlx5: Support statistic q counter configuration
Date:   Tue, 18 Jun 2019 20:26:17 +0300
Message-Id: <20190618172625.13432-10-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618172625.13432-1-leon@kernel.org>
References: <20190618172625.13432-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add support for ib callbacks counter_bind_qp(), counter_unbind_qp()
and counter_dealloc().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4493700099d4..ec2bf52634e8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5550,6 +5550,47 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }

+static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
+				   struct ib_qp *qp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	u16 cnt_set_id = 0;
+	int err;
+
+	if (!counter->id) {
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
+	mlx5_core_dealloc_q_counter(dev->mdev, cnt_set_id);
+	counter->id = 0;
+
+	return err;
+}
+
+static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp)
+{
+	return mlx5_ib_qp_set_counter(qp, NULL);
+}
+
+static int mlx5_ib_counter_dealloc(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+
+	return mlx5_core_dealloc_q_counter(dev->mdev, counter->id);
+}
+
 static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
@@ -6471,6 +6512,9 @@ static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
 static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.alloc_hw_stats = mlx5_ib_alloc_hw_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
+	.counter_bind_qp = mlx5_ib_counter_bind_qp,
+	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
+	.counter_dealloc = mlx5_ib_counter_dealloc,
 };

 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
--
2.20.1

