Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7455D2738E1
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgIVCsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgIVCr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:57 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 426F123A9C;
        Tue, 22 Sep 2020 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742870;
        bh=XiYEs0HNvmfiYmjv0xnaqU86N9CdB6o2KHubajJE4gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeLk3nWI63NafSH93DCTUjvh/TRzLplXKi8n88XMaKdbH0eWWAbhoabUbgRr5BcMP
         0KFNmm/uXUyB7+OAtdkva1yzidfCQCqyopac82Rob1ZBCi8QVbbuhbExq9VkpAFXZi
         jX+F6wZA0XaOAYXnPRew75G2x9U5duQjog0C0J1E=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 11/12] net/mlx5e: Move TX code into functions to be used by MPWQE
Date:   Mon, 21 Sep 2020 19:47:03 -0700
Message-Id: <20200922024704.544482-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_txwqe_complete performs some actions that can be taken to separate
functions:

1. Update the flags needed for hardware timestamping.

2. Stop the TX queue if it's full.

Take these actions into separate functions to be reused by the MPWQE
code in the following commit and to maintain clear responsibilities of
functions.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 857d1c0397d7..f5af35c5ecc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -327,6 +327,20 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_at
 	};
 }
 
+static void mlx5e_tx_skb_update_hwts_flags(struct sk_buff *skb)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+}
+
+static void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
+{
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))) {
+		netif_tx_stop_queue(sq->txq);
+		sq->stats->stopped++;
+	}
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -348,14 +362,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | attr->opcode);
 	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt);
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	mlx5e_tx_skb_update_hwts_flags(skb);
 
 	sq->pc += wi->num_wqebbs;
-	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room))) {
-		netif_tx_stop_queue(sq->txq);
-		sq->stats->stopped++;
-	}
+
+	mlx5e_tx_check_stop(sq);
 
 	send_doorbell = __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_more);
 	if (send_doorbell)
-- 
2.26.2

