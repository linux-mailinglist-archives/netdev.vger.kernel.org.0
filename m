Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E49DDF8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfD2Ifz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfD2Ifw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:52 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC4D20578;
        Mon, 29 Apr 2019 08:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526951;
        bh=oytWg4y6lENL2SglViMxfGxf3kbh8jtcSzLuDtAaKsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsXjjzLOG8K0nZ8QK4rxQohHe1M3cl7t8jS0vVsnqGqexro5PxsBaynmSMhixx49Q
         +MzRl6+q6ID/j2HLWVkf/Wfbgu36+Wq8p/YDUeA779+RCvz+KFf7+1d33JtYgCi9ee
         Tsb//cRiRqIIVaRCdXIaNCvf1w0IlieO6j4qvq9Y=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 12/17] IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
Date:   Mon, 29 Apr 2019 11:34:48 +0300
Message-Id: <20190429083453.16654-13-leon@kernel.org>
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

Add support for ib callback counter_alloc_stats() and
counter_update_stats().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 18a3e855d45b..d69cfe511c37 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5450,6 +5450,27 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static struct rdma_hw_stats *
+mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_port *port = &dev->port[counter->port - 1];
+
+	/* Q counters are in the beginning of all counters */
+	return rdma_alloc_hw_stats_struct(port->cnts.names,
+					  port->cnts.num_q_counters,
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_port *port = &dev->port[counter->port - 1];
+
+	return mlx5_ib_query_q_counters(dev->mdev, port,
+					counter->stats, counter->id);
+}
+
 static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp)
 {
@@ -6361,6 +6382,8 @@ static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.get_hw_stats = mlx5_ib_get_hw_stats,
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
+	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
+	.counter_update_stats = mlx5_ib_counter_update_stats,
 };
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1

