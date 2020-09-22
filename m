Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D892738D6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgIVCro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbgIVCrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:42 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D35E23A79;
        Tue, 22 Sep 2020 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742861;
        bh=VHSTPLb47k94V2ZJXmQGUUXAmPyqnO6PlAb636KqsE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRKzdw6II01d4uy5W2KYYJx50YBvWaQsdSB8630mViApnt/W9EwNN+n8bEprBcMPi
         i7PqR7lGmgH00QLXpid6po/okJwcTVmYSFUw3p4DLmGQZAF5QYGgQT6GdP8Te6fgQh
         SJZ1Tevac88MPGGlZywhWMuzR6IarDTcpDFomqZg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to en_tx.c
Date:   Mon, 21 Sep 2020 19:46:55 -0700
Message-Id: <20200922024704.544482-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Move mlx5e_tx_wqe_inline_mode from en/txrx.h to en_tx.c as it's only
used there.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 23 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 +++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 9334c9c3e208..6be04a236017 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -223,29 +223,6 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
-static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
-{
-	return cseg && !!cseg->tis_tir_num;
-}
-
-static inline u8
-mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
-			 struct sk_buff *skb)
-{
-	u8 mode;
-
-	if (mlx5e_transport_inline_tx_wqe(cseg))
-		return MLX5_INLINE_MODE_TCP_UDP;
-
-	mode = sq->min_inline_mode;
-
-	if (skb_vlan_tag_present(skb) &&
-	    test_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state))
-		mode = max_t(u8, MLX5_INLINE_MODE_L2, mode);
-
-	return mode;
-}
-
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c064657dde13..69afda1f7bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -232,6 +232,29 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return -ENOMEM;
 }
 
+static bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
+{
+	return cseg && !!cseg->tis_tir_num;
+}
+
+static u8
+mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
+			 struct sk_buff *skb)
+{
+	u8 mode;
+
+	if (mlx5e_transport_inline_tx_wqe(cseg))
+		return MLX5_INLINE_MODE_TCP_UDP;
+
+	mode = sq->min_inline_mode;
+
+	if (skb_vlan_tag_present(skb) &&
+	    test_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state))
+		mode = max_t(u8, MLX5_INLINE_MODE_L2, mode);
+
+	return mode;
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     u8 opcode, u16 ds_cnt, u8 num_wqebbs, u32 num_bytes, u8 num_dma,
-- 
2.26.2

