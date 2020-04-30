Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D131BFA58
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgD3NxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbgD3Nw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B370E2137B;
        Thu, 30 Apr 2020 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254778;
        bh=ClO+aYxsbCXzhxSryV9axVy2inPbv6/YGVUuML2J0YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBQ08xwESY2CN8SNLRQyUFen1a0eunL0+OgkSAwEH7uVt/m2Eq+MRJ0SWeog/6LNO
         fKfD+rqOAC4TKHDANT/f2jj8de2AHVaLiYDD42QPcecXXJ5wYU7IVDtoUPgBWLGFsc
         eJkUjd/qDXQFUnnWZ8j5XFJn1AA017cy4FXFtD+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/57] net/mlx5e: Don't trigger IRQ multiple times on XSK wakeup to avoid WQ overruns
Date:   Thu, 30 Apr 2020 09:51:56 -0400
Message-Id: <20200430135218.20372-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit e7e0004abdd6f83ae4be5613b29ed396beff576c ]

XSK wakeup function triggers NAPI by posting a NOP WQE to a special XSK
ICOSQ. When the application floods the driver with wakeup requests by
calling sendto() in a certain pattern that ends up in mlx5e_trigger_irq,
the XSK ICOSQ may overflow.

Multiple NOPs are not required and won't accelerate the process, so
avoid posting a second NOP if there is one already on the way. This way
we also avoid increasing the queue size (which might not help anyway).

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   | 6 +++++-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 11426f94c90c6..38aa55638bbed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -367,6 +367,7 @@ enum {
 	MLX5E_SQ_STATE_AM,
 	MLX5E_SQ_STATE_TLS,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
+	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
 struct mlx5e_sq_wqe_info {
@@ -948,7 +949,7 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
 void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix);
 void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index fe2d596cb361f..3bcdb5b2fc203 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -33,6 +33,9 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->xskicosq.state)))
 			return 0;
 
+		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state))
+			return 0;
+
 		spin_lock(&c->xskicosq_lock);
 		mlx5e_trigger_irq(&c->xskicosq);
 		spin_unlock(&c->xskicosq_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1d295a7afc8ce..c4eed5bbcd454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -587,7 +587,7 @@ bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	return !!err;
 }
 
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
@@ -595,11 +595,11 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 	int i;
 
 	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
-		return;
+		return 0;
 
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
 	if (likely(!cqe))
-		return;
+		return 0;
 
 	/* sq->cc must be updated only after mlx5_cqwq_update_db_record(),
 	 * otherwise a cq overrun may occur
@@ -646,6 +646,8 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 	sq->cc = sqcc;
 
 	mlx5_cqwq_update_db_record(&cq->wq);
+
+	return i;
 }
 
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 800d34ed8a96c..76efa9579215c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -145,7 +145,11 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 
 	busy |= rq->post_wqes(rq);
 	if (xsk_open) {
-		mlx5e_poll_ico_cq(&c->xskicosq.cq);
+		if (mlx5e_poll_ico_cq(&c->xskicosq.cq))
+			/* Don't clear the flag if nothing was polled to prevent
+			 * queueing more WQEs and overflowing XSKICOSQ.
+			 */
+			clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
 		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
 	}
-- 
2.20.1

