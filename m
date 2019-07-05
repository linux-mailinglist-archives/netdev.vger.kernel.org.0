Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E656095C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfGEPbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:31:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52420 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727905AbfGEPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOf029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 06/12] net/mlx5e: Tx, Enforce L4 inline copy when needed
Date:   Fri,  5 Jul 2019 18:30:16 +0300
Message-Id: <1562340622-4423-7-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ctrl->tisn field exists, this indicates an operation (HW offload)
on the TCP payload.
For such WQEs, inline the headers up to L4.

This is in preparation for kTLS HW offload support, added in
a downstream patch.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7fdf69e08d58..bd41f89afef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -77,6 +77,11 @@ static inline void mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
+static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5e_tx_wqe *wqe)
+{
+	return !!wqe->ctrl.tisn;
+}
+
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index dc77fe9ae367..b1a163e66053 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -304,9 +304,12 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
 		stats->packets += skb_shinfo(skb)->gso_segs;
 	} else {
+		u8 mode = mlx5e_transport_inline_tx_wqe(wqe) ?
+			MLX5_INLINE_MODE_TCP_UDP : sq->min_inline_mode;
+
 		opcode    = MLX5_OPCODE_SEND;
 		mss       = 0;
-		ihs       = mlx5e_calc_min_inline(sq->min_inline_mode, skb);
+		ihs       = mlx5e_calc_min_inline(mode, skb);
 		num_bytes = max_t(unsigned int, skb->len, ETH_ZLEN);
 		stats->packets++;
 	}
-- 
1.8.3.1

