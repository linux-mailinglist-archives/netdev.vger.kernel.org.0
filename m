Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1356270351
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgIRR3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgIRR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F32F02376F;
        Fri, 18 Sep 2020 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450137;
        bh=rmpoijAsw6Z2GV9/yxCies3+hBFsK7uJdPIB4EX/R1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6+mUKtXAUbENFY0ZeZF9wHFSincM7GHsTqkKw0CxoXXkwFmpKVMnxs6G3XVn/s5S
         HtRG0/Rs7q4GVRnd6Pk22kDWpJyO3CiexO9B4i/mrSIC0dfr3kc1jY/MqFhj3m/INS
         bx8qoYxY98td/v1Y6ktcuOHq4Guq7pQcPAK9T2HE=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 13/15] net/mlx5e: kTLS, Fix leak on resync error flow
Date:   Fri, 18 Sep 2020 10:28:37 -0700
Message-Id: <20200918172839.310037-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Resync progress params buffer and dma weren't released on error,
Add missing error unwinding for resync_post_get_progress_params().

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c    | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index fb4e4f2ebe02..e85411bd1fed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -258,7 +258,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
 		err = -ENOMEM;
-		goto err_out;
+		goto err_free;
 	}
 
 	buf->priv_rx = priv_rx;
@@ -266,7 +266,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
 		err = -ENOSPC;
-		goto err_out;
+		goto err_dma_unmap;
 	}
 
 	pi = mlx5e_icosq_get_next_pi(sq, 1);
@@ -297,6 +297,10 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 
 	return cseg;
 
+err_dma_unmap:
+	dma_unmap_single(pdev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
+err_free:
+	kfree(buf);
 err_out:
 	priv_rx->stats->tls_resync_req_skip++;
 	return ERR_PTR(err);
-- 
2.26.2

