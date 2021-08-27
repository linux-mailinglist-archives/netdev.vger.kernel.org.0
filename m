Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40AE3F91B3
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbhH0A7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244086AbhH0A7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E8B6109E;
        Fri, 27 Aug 2021 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025898;
        bh=mgd9pjmlj7g25TscaPQKDmwgqozET9K+xFb9mYG4uRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTdT+ZqBjYNYCb/pxIlZDBPbdiH8enSDndHrtt6xRFP0Cl8p6zojY3z+Of2YCdla9
         lq769Gb9blc6O9kbOV2NzXRH0QF1UgHVdCWrzMrg9poPEDb/JNB/ByjVckKz4j9xD0
         CEG/Jz/ZoR1QQr9rUGp6ww9FD3OIr6MWVcsQiaUNbDxRJcy9vzURwDdDiY7sz9TiI0
         /fsXqwS5LfhW69tkDBOzSLNllh375Cq6B0olEh1fRFKSHW947EFo8/WTk84GvoMuMB
         rSTFKy4NZ91faYdbFy1uS+6jSiCc4M+P5mSTqH/lfb5XBS0GpTvWKce3P9JkvbamGI
         8s7j+xqFO1ltQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/17] net/mlx5: DR, Warn and ignore SW steering rule insertion on QP err
Date:   Thu, 26 Aug 2021 17:57:51 -0700
Message-Id: <20210827005802.236119-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In the event of SW steering QP entering error state, SW steering
cannot insert more rules, and will silently ignore the insertion
after issuing a warning.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c        | 16 ++++++++++++++--
 .../mellanox/mlx5/core/steering/dr_types.h       |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 24f40e17f176..bfb14b4b1906 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -325,10 +325,14 @@ static int dr_handle_pending_wc(struct mlx5dr_domain *dmn,
 
 	do {
 		ne = dr_poll_cq(send_ring->cq, 1);
-		if (ne < 0)
+		if (unlikely(ne < 0)) {
+			mlx5_core_warn_once(dmn->mdev, "SMFS QPN 0x%x is disabled/limited",
+					    send_ring->qp->qpn);
+			send_ring->err_state = true;
 			return ne;
-		else if (ne == 1)
+		} else if (ne == 1) {
 			send_ring->pending_wqe -= send_ring->signal_th;
+		}
 	} while (is_drain && send_ring->pending_wqe);
 
 	return 0;
@@ -361,6 +365,14 @@ static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 	u32 buff_offset;
 	int ret;
 
+	if (unlikely(dmn->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+		     send_ring->err_state)) {
+		mlx5_core_dbg_once(dmn->mdev,
+				   "Skipping post send: QP err state: %d, device state: %d\n",
+				   send_ring->err_state, dmn->mdev->state);
+		return 0;
+	}
+
 	spin_lock(&send_ring->lock);
 
 	ret = dr_handle_pending_wc(dmn, send_ring);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 474cf32a67c4..4fd14e9b7e1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1285,6 +1285,7 @@ struct mlx5dr_send_ring {
 	u8 sync_buff[MIN_READ_SYNC];
 	struct mlx5dr_mr *sync_mr;
 	spinlock_t lock; /* Protect the data path of the send ring */
+	bool err_state; /* send_ring is not usable in err state */
 };
 
 int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn);
-- 
2.31.1

