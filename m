Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D174A859
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfFRR1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfFRR1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:11 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 311B02147A;
        Tue, 18 Jun 2019 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878830;
        bh=pCx3Rf+ufA9agK7NIA4OwUjOyAB7j5gx/6DogWbm0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWlH4AlsBm6EfT8yaGyNYEfVweMVBHAmK2oMRafkbmpMTYzYE07ogpztORGN5kcLg
         q06fY6dV3GSI56GXdat3+jzYqZPKyBRReWndWHgfZIt+4dG3ldkA8mWKIzeVa6OMpT
         PHqqcZKitKEswqpSn8I2lCgKcdixFejaBvsOFJkk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 12/17] IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
Date:   Tue, 18 Jun 2019 20:26:20 +0300
Message-Id: <20190618172625.13432-13-leon@kernel.org>
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

Add support for ib callback counter_alloc_stats() and
counter_update_stats().

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ec2bf52634e8..e8a4dedff10b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5550,6 +5550,27 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
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
@@ -6515,6 +6536,8 @@ static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.counter_bind_qp = mlx5_ib_counter_bind_qp,
 	.counter_unbind_qp = mlx5_ib_counter_unbind_qp,
 	.counter_dealloc = mlx5_ib_counter_dealloc,
+	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
+	.counter_update_stats = mlx5_ib_counter_update_stats,
 };

 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
--
2.20.1

