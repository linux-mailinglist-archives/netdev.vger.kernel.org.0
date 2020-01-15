Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989EF13C6AC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOOzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgAOOzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 09:55:07 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972E0214AF;
        Wed, 15 Jan 2020 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100107;
        bh=tHX+6rIYUFB4Wa31jN0d0j/bavquR82rDixYNbTHwEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yem2lwjw2JfYnGCqPbPP/2+T4Qro42cDhJ8JIz+kXZ2DL3Vu5ivFzWjla/tV2FGDl
         QF/w1QXZsOnPkRszpauGWl+qbctbR0PPqfEA7a6Ydn3tedSXzoSdX9DEWlbyTmYVuQ
         +cwEzDth5FkHl7kDN8HAFHelyWOi4KYngH0Zcvb0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Expose RoCE accelerator counters
Date:   Wed, 15 Jan 2020 16:54:59 +0200
Message-Id: <20200115145459.83280-3-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115145459.83280-1-leon@kernel.org>
References: <20200115145459.83280-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@mellanox.com>

Introduce the following RoCE accelerator counters:
* roce_adp_retrans - number of adaptive retransmission for RoCE traffic.
* roce_adp_retrans_to - number of times RoCE traffic reached time out
due to adaptive retransmission.
* roce_slow_restart - number of times RoCE slow restart was used.
* roce_slow_restart_cnps - number of times RoCE slow restart
generate CNP packets.
* roce_slow_restart_trans - number of times RoCE slow restart change
state to slow restart.

Signed-off-by: Avihai Horon <avihaih@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 97bcf01960ae..5d41a2c69400 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5370,6 +5370,14 @@ static const struct mlx5_ib_counter extended_err_cnts[] = {
 	INIT_Q_COUNTER(req_cqe_flush_error),
 };
 
+static const struct mlx5_ib_counter roce_accl_cnts[] = {
+	INIT_Q_COUNTER(roce_adp_retrans),
+	INIT_Q_COUNTER(roce_adp_retrans_to),
+	INIT_Q_COUNTER(roce_slow_restart),
+	INIT_Q_COUNTER(roce_slow_restart_cnps),
+	INIT_Q_COUNTER(roce_slow_restart_trans),
+};
+
 #define INIT_EXT_PPCNT_COUNTER(_name)		\
 	{ .name = #_name, .offset =	\
 	MLX5_BYTE_OFF(ppcnt_reg, \
@@ -5418,6 +5426,9 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 	if (MLX5_CAP_GEN(dev->mdev, enhanced_error_q_counters))
 		num_counters += ARRAY_SIZE(extended_err_cnts);
 
+	if (MLX5_CAP_GEN(dev->mdev, roce_accl))
+		num_counters += ARRAY_SIZE(roce_accl_cnts);
+
 	cnts->num_q_counters = num_counters;
 
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
@@ -5478,6 +5489,13 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		}
 	}
 
+	if (MLX5_CAP_GEN(dev->mdev, roce_accl)) {
+		for (i = 0; i < ARRAY_SIZE(roce_accl_cnts); i++, j++) {
+			names[j] = roce_accl_cnts[i].name;
+			offsets[j] = roce_accl_cnts[i].offset;
+		}
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
 		for (i = 0; i < ARRAY_SIZE(cong_cnts); i++, j++) {
 			names[j] = cong_cnts[i].name;
-- 
2.20.1

