Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF3327377C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgIVAbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgIVAbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:19 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CA723AAC;
        Tue, 22 Sep 2020 00:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734679;
        bh=gWNKbKcC9Ghkys+O1lfXh6Yx0S/5XvybciHyYdX8NkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhuUM/k+XhcVmnO0bzWrJFp3pWlWixwZ8R5mGs2OtIB3n8hBs9U3q42lL3xq6+Hmw
         eqW6pkSMQFdO00p9XUsxaJkQ2cPRUs2SkwVleQaVG3E/ESW+nOdVfdMdVQhrAczeUI
         mWVS7ODoeKbqcfJxtkVlANxRcHRv6xQBSscgcn5I=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net V2 12/15] net/mlx5e: kTLS, Add missing dma_unmap in RX resync
Date:   Mon, 21 Sep 2020 17:30:58 -0700
Message-Id: <20200922003101.529117-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
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

