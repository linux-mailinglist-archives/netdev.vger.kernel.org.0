Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B635CD2F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfGBKDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfGBKDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:03:18 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D6C92054F;
        Tue,  2 Jul 2019 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562061797;
        bh=+HcSrDV8P7+g991j7XStyeWPs8qd4nPlke2TJxnQ+2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI5N5M4LtTptrzThjFUnwrtGyfiWv706xGtPCA1wwoiyDEudReHFXMm5W36CPxXqT
         PTm1OdJQKxGBRyJtB3kTesSLmy7MKN93HFZ5umYQ3jN29m9atg/kU96gl68MuOIKZP
         UAm4//aSqvhBJ4R05dzHAWyq4ZkBaplxTQTpdSkg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v5 08/17] IB/mlx5: Add counter set id as a parameter for mlx5_ib_query_q_counters()
Date:   Tue,  2 Jul 2019 13:02:37 +0300
Message-Id: <20190702100246.17382-9-leon@kernel.org>
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

Add counter set id as a parameter so that this API can be used for
querying any q counter.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 05d2bfcb3d60..4740cfda5b17 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5443,7 +5443,8 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 
 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct mlx5_ib_port *port,
-				    struct rdma_hw_stats *stats)
+				    struct rdma_hw_stats *stats,
+				    u16 set_id)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_q_counter_out);
 	void *out;
@@ -5454,9 +5455,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_core_query_q_counter(mdev,
-					port->cnts.set_id, 0,
-					out, outlen);
+	ret = mlx5_core_query_q_counter(mdev, set_id, 0, out, outlen);
 	if (ret)
 		goto free;
 
@@ -5516,7 +5515,8 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 		       port->cnts.num_ext_ppcnt_counters;
 
 	/* q_counters are per IB device, query the master mdev */
-	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats);
+	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats,
+				       port->cnts.set_id);
 	if (ret)
 		return ret;
 
-- 
2.20.1

