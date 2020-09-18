Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5844270358
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIRR3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgIRR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8359B23730;
        Fri, 18 Sep 2020 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450136;
        bh=gWNKbKcC9Ghkys+O1lfXh6Yx0S/5XvybciHyYdX8NkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjm5AJqDxa8gZV3UcQTE2bErwjWaMh3a9FRanXBoBVdp6s0gaJRBDJqcdCfCaG7ZK
         lGq0pyOyOBp7FjB8HR2lv4UrNtPZWIZEnNMoKGos6/JbZI3YDaS9vSYKlWVzal1Jck
         8ZdJG3TADhek6i3tIJT2Ies5DJUkYHTK70UfQqME=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 12/15] net/mlx5e: kTLS, Add missing dma_unmap in RX resync
Date:   Fri, 18 Sep 2020 10:28:36 -0700
Message-Id: <20200918172839.310037-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Progress params dma address is never unmapped, unmap it when completion
handling is over.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c    | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index f95aa50ab51a..fb4e4f2ebe02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -386,16 +386,17 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
 	struct mlx5e_ktls_rx_resync_ctx *resync;
 	u8 tracker_state, auth_state, *ctx;
+	struct device *dev;
 	u32 hw_seq;
 
 	priv_rx = buf->priv_rx;
 	resync = &priv_rx->resync;
-
+	dev = resync->priv->mdev->device;
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
 		goto out;
 
-	dma_sync_single_for_cpu(resync->priv->mdev->device, buf->dma_addr,
-				PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(dev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE,
+				DMA_FROM_DEVICE);
 
 	ctx = buf->progress.ctx;
 	tracker_state = MLX5_GET(tls_progress_params, ctx, record_tracker_state);
@@ -411,6 +412,7 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	priv_rx->stats->tls_resync_req_end++;
 out:
 	refcount_dec(&resync->refcnt);
+	dma_unmap_single(dev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	kfree(buf);
 }
 
-- 
2.26.2

