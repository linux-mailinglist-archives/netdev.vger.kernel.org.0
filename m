Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604CC362813
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbhDPSzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236178AbhDPSzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2974613BB;
        Fri, 16 Apr 2021 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599281;
        bh=NTzpoCAzvT8BV+P/g14gVaOEP08MbBwbfGkog2J8px4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoHxNxUut6YSljXcIf4SMNjDkmjE/tG7ZDh+c1ZpiVETXHyTlnN2GOTolur1u1nQF
         sl4R4CpLaSE9x1Y7IIeRrdQu38oplghxqALDOs9RdFddLhJJZpNabTceMgJDt79Fke
         bxezCooW0idikhoZgeufxzFSVPCCNSzwjcTh5aMUlfwUWEhVaDm/RmuzR19jeRCThf
         UWP5Yg9HofNdLFs/ux+liGt5KORhaYwFbynGRpbprmnkXQmPifFH1O9viatMJnbh2B
         brKy45IvhiQpqTRurO0e8jGhz1Q+CbD9gT9KJcCkG5c4FgEiA6XE2iWgZOFPmmjt1W
         G4Az9JcdLH+3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5e: TX, Inline function mlx5e_tls_handle_tx_wqe()
Date:   Fri, 16 Apr 2021 11:54:20 -0700
Message-Id: <20210416185430.62584-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

When TLS is supported, WQE ctrl segment of every transmitted packet
is updated with the (possibly empty, for non-TLS packets) TISN field.

Take this one-liner function into the header file and inline it,
to save the overhead of a function call per packet.

While here, remove unused function parameter.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c   | 6 ------
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h   | 8 ++++++--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 043c86c52798..00af0b831a28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -185,7 +185,7 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 					 struct mlx5_wqe_inline_seg *inlseg)
 {
 #ifdef CONFIG_MLX5_EN_TLS
-	mlx5e_tls_handle_tx_wqe(sq, &wqe->ctrl, &state->tls);
+	mlx5e_tls_handle_tx_wqe(&wqe->ctrl, &state->tls);
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 97cbea7ed048..82dc09aaa7fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -298,12 +298,6 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	return false;
 }
 
-void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
-			     struct mlx5e_accel_tx_tls_state *state)
-{
-	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
-}
-
 static int tls_update_resync_sn(struct net_device *netdev,
 				struct sk_buff *skb,
 				struct mlx5e_tls_metadata *mdata)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 5c3443200fd6..0ca0a023fb8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -53,8 +53,12 @@ static inline bool mlx5e_tls_skb_offloaded(struct sk_buff *skb)
 	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
 }
 
-void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
-			     struct mlx5e_accel_tx_tls_state *state);
+static inline void
+mlx5e_tls_handle_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg,
+			struct mlx5e_accel_tx_tls_state *state)
+{
+	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
+}
 
 void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
 				      u32 *cqe_bcnt);
-- 
2.30.2

