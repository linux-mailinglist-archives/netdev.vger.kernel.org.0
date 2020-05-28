Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F234C1E5FAE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389583AbgE1MD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388984AbgE1L5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE98921582;
        Thu, 28 May 2020 11:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667039;
        bh=9K5IVEossD+P7zam9iI7ve6ASDUozKdpdIxQ9soJNaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EE07rXlFaUukZDW7rOD5EdSvfmzo21nbMEZ52x/4tV3/Ht9iX7ZfslYi8My6CH07g
         U6MfxPbQfdlpzBQ7DCNLlIZdNZUrYsRAE2JqzlWVtuNEm10p0OI6uxnja104MjXg10
         2EZheuKYEYobSNSacdrUabT69pvT2LXptEYsKSoo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/26] net/mlx5e: Update netdev txq on completions during closure
Date:   Thu, 28 May 2020 07:56:50 -0400
Message-Id: <20200528115654.1406165-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115654.1406165-1-sashal@kernel.org>
References: <20200528115654.1406165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 5e911e2c06bd8c17df29147a5e2d4b17fafda024 ]

On sq closure when we free its descriptors, we should also update netdev
txq on completions which would not arrive. Otherwise if we reopen sqs
and attach them back, for example on fw fatal recovery flow, we may get
tx timeout.

Fixes: 29429f3300a3 ("net/mlx5e: Timeout if SQ doesn't flush during close")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index dee12f17f9c2..d9e0fc146741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -537,10 +537,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
+	u32 dma_fifo_cc, nbytes = 0;
+	u16 ci, sqcc, npkts = 0;
 	struct sk_buff *skb;
-	u32 dma_fifo_cc;
-	u16 sqcc;
-	u16 ci;
 	int i;
 
 	sqcc = sq->cc;
@@ -565,11 +564,15 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		}
 
 		dev_kfree_skb_any(skb);
+		npkts++;
+		nbytes += wi->num_bytes;
 		sqcc += wi->num_wqebbs;
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
 	sq->cc = sqcc;
+
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 }
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
-- 
2.25.1

