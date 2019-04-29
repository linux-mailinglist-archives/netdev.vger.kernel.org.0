Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07356DDF0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfD2Ifj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfD2Ifi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:38 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5B1214AF;
        Mon, 29 Apr 2019 08:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526937;
        bh=/oVxWMsW+vnkUmw1TuWWblLifhEGBpiFPqo3tQb53/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+lcZmUNelwN/uzqynuIWozTCQezozblVDFhg241UgDT2eYsFK61YRTSEhqRLhXic
         eXQ+vSN+M85P3YRODyTcSVH+JtSK7VM2stWUd6EVrDbFxZopwfXgxGJoVEgQfg6sgE
         IY8IX4Q42fTFbh80iQV29pN3ztHLWsdhyG8r09rg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 08/17] IB/mlx5: Add counter set id as a parameter for mlx5_ib_query_q_counters()
Date:   Mon, 29 Apr 2019 11:34:44 +0300
Message-Id: <20190429083453.16654-9-leon@kernel.org>
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

Add counter set id as a parameter so that this API can be used for
querying any q counter.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6135a0b285de..06da76df4aa1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5341,7 +5341,8 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 
 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct mlx5_ib_port *port,
-				    struct rdma_hw_stats *stats)
+				    struct rdma_hw_stats *stats,
+				    u16 set_id)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_q_counter_out);
 	void *out;
@@ -5352,9 +5353,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_core_query_q_counter(mdev,
-					port->cnts.set_id, 0,
-					out, outlen);
+	ret = mlx5_core_query_q_counter(mdev, set_id, 0, out, outlen);
 	if (ret)
 		goto free;
 
@@ -5414,7 +5413,8 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 		       port->cnts.num_ext_ppcnt_counters;
 
 	/* q_counters are per IB device, query the master mdev */
-	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats);
+	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats,
+				       port->cnts.set_id);
 	if (ret)
 		return ret;
 
-- 
2.20.1

