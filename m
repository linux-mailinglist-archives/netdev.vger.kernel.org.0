Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD35A273778
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgIVAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgIVAbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:20 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B209023A9B;
        Tue, 22 Sep 2020 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734680;
        bh=wXa/X0SK7f6N4jfbbw946eV/BCU1qCdpuEvNaMxmtZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH6zuieYJFBSpjnfd/KGQvQh6rJ0XPxfQ1Q528lWpJE6DO6JB3wfxDUwP7tl7Cd7D
         wpVnuI6XI8j8NtUyAmM2jva7udbAZmh/JKKGHcL2ygg7NEfHIvVvGdjf6g+xgJBRLx
         XnIMw48+T1VRtmNBK3ukBI1Vfv+dXHdLYgnweUvc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net V2 14/15] net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL) under spinlock
Date:   Mon, 21 Sep 2020 17:31:00 -0700
Message-Id: <20200922003101.529117-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The spinlock only needed when accessing the channel's icosq, grab the lock
after the buf allocation in resync_post_get_progress_params() to avoid
kzalloc(GFP_KERNEL) in atomic context.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Reported-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index e85411bd1fed..6bbfcf18107d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -234,7 +234,7 @@ mlx5e_get_ktls_rx_priv_ctx(struct tls_context *tls_ctx)
 
 /* Re-sync */
 /* Runs in work context */
-static struct mlx5_wqe_ctrl_seg *
+static int
 resync_post_get_progress_params(struct mlx5e_icosq *sq,
 				struct mlx5e_ktls_offload_context_rx *priv_rx)
 {
@@ -264,7 +264,11 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	buf->priv_rx = priv_rx;
 
 	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
+
+	spin_lock(&sq->channel->async_icosq_lock);
+
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
+		spin_unlock(&sq->channel->async_icosq_lock);
 		err = -ENOSPC;
 		goto err_dma_unmap;
 	}
@@ -294,8 +298,10 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	};
 	icosq_fill_wi(sq, pi, &wi);
 	sq->pc++;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+	spin_unlock(&sq->channel->async_icosq_lock);
 
-	return cseg;
+	return 0;
 
 err_dma_unmap:
 	dma_unmap_single(pdev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
@@ -303,7 +309,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	kfree(buf);
 err_out:
 	priv_rx->stats->tls_resync_req_skip++;
-	return ERR_PTR(err);
+	return err;
 }
 
 /* Function is called with elevated refcount.
@@ -313,10 +319,8 @@ static void resync_handle_work(struct work_struct *work)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
 	struct mlx5e_ktls_rx_resync_ctx *resync;
-	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5e_channel *c;
 	struct mlx5e_icosq *sq;
-	struct mlx5_wq_cyc *wq;
 
 	resync = container_of(work, struct mlx5e_ktls_rx_resync_ctx, work);
 	priv_rx = container_of(resync, struct mlx5e_ktls_offload_context_rx, resync);
@@ -328,18 +332,9 @@ static void resync_handle_work(struct work_struct *work)
 
 	c = resync->priv->channels.c[priv_rx->rxq];
 	sq = &c->async_icosq;
-	wq = &sq->wq;
 
-	spin_lock(&c->async_icosq_lock);
-
-	cseg = resync_post_get_progress_params(sq, priv_rx);
-	if (IS_ERR(cseg)) {
+	if (resync_post_get_progress_params(sq, priv_rx))
 		refcount_dec(&resync->refcnt);
-		goto unlock;
-	}
-	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
-unlock:
-	spin_unlock(&c->async_icosq_lock);
 }
 
 static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync,
-- 
2.26.2

