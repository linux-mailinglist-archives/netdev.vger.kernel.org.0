Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519A713E3D9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbgAPREb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388408AbgAPRCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A13624653;
        Thu, 16 Jan 2020 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194163;
        bh=qVfgptbKn+ym0tmO3LpA8NV2Q30OIGJxACekGXHTlgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAEYld71RE1ZpKCXO+0MRSuViIdDZkc24mhPz7XU6vKdvwW4xTLBFbNvQ1VHdSxyM
         ozEymgg43W0gPKZeWE11/jbeBTjIlgwhTNGD6PAVxtIHGhl4zt1JqkfTk6aDJFZYWw
         pndGArqm/LlGLvd4dDAfT2QCk+2FA1ZwWGJG8/Aw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 244/671] net/mlx5e: IPoIB, Fix RX checksum statistics update
Date:   Thu, 16 Jan 2020 11:52:33 -0500
Message-Id: <20200116165940.10720-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feras Daoud <ferasda@mellanox.com>

[ Upstream commit 3d6f3cdf9bfe92c430674308db0f1c8655f2c11d ]

Update the RX checksum only if the feature is enabled.

Fixes: 9d6bd752c63c ("net/mlx5e: IPoIB, RX handler")
Signed-off-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9cbc4173973e..044687a1f27c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1364,8 +1364,14 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->protocol = *((__be16 *)(skb->data));
 
-	skb->ip_summed = CHECKSUM_COMPLETE;
-	skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
+	if (netdev->features & NETIF_F_RXCSUM) {
+		skb->ip_summed = CHECKSUM_COMPLETE;
+		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
+		stats->csum_complete++;
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+		stats->csum_none++;
+	}
 
 	if (unlikely(mlx5e_rx_hw_stamp(tstamp)))
 		skb_hwtstamps(skb)->hwtstamp =
@@ -1384,7 +1390,6 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->dev = netdev;
 
-	stats->csum_complete++;
 	stats->packets++;
 	stats->bytes += cqe_bcnt;
 }
-- 
2.20.1

