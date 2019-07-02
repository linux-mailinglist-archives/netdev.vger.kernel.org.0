Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D515CD37
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGBKDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfGBKDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:03:34 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46502064A;
        Tue,  2 Jul 2019 10:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562061813;
        bh=gLKgVxKlBz0DWpIiDavlQdCB5GhzjNfmsEl38f1zZkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSnFV8m0kuOboSEocGrK/2llwcAv8GB0f0yE+Fk8oogpacyAIYfcpTbb448ubvVAS
         coRj3fwXVv6EF7TjSRa6HspOZF9I+Ppjh1dkS1xaJDSYj+dHsgMmvAYwTPvHv1vT7b
         cFMnkjw+qz0g1wSQUbXE2kgmRV7Apc9QABvsrMkA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v5 12/17] IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
Date:   Tue,  2 Jul 2019 13:02:41 +0300
Message-Id: <20190702100246.17382-13-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
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
index ffd6f16d3c37..d6751b2cfa1c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5552,6 +5552,27 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
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
@@ -6519,6 +6540,8 @@ static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
 	.counter_dealloc = mlx5_ib_counter_dealloc,
+	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
+	.counter_update_stats = mlx5_ib_counter_update_stats,
 };
 
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
-- 
2.20.1

