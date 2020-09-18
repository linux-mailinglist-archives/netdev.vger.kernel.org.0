Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75867270349
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIRR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgIRR2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:52 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A93A22208;
        Fri, 18 Sep 2020 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450131;
        bh=GfhLaSun/K/njtj0BDp1ts4HZCash8EndXvWvWKLfMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB5kAK0c3tlV0WEQ5VZpjHiBbbam51v2w+Z/VQhFs8Zf5/vXzfuwA36dDO+E8Cww2
         GIbciVP0NgG0EQwrne8ygnuQls5fZm5sVEbpn81Y1DiQSMHqALlBJVg51MQt96Bhgb
         LKhtyHXoqc2ZeCYUaYTFei8QYyUrABMxf5ewMwxE=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/15] net/mlx5e: Use RCU to protect rq->xdp_prog
Date:   Fri, 18 Sep 2020 10:28:26 -0700
Message-Id: <20200918172839.310037-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Currently, the RQs are temporarily deactivated while hot-replacing the
XDP program, and napi_synchronize is used to make sure rq->xdp_prog is
not in use. However, napi_synchronize is not ideal: instead of waiting
till the end of a NAPI cycle, it polls and waits until NAPI is not
running, sleeping for 1ms between the periodic checks. Under heavy
workloads, this loop will never end, which may even lead to a kernel
panic if the kernel detects the hangup. Such workloads include XSK TX
and possibly also heavy RX (XSK or normal).

The fix is inspired by commit 326fe02d1ed6 ("net/mlx4_en: protect
ring->xdp_prog with rcu_read_lock"). As mlx5e_xdp_handle is already
protected by rcu_read_lock, and bpf_prog_put uses call_rcu to free the
program, there is no need for additional synchronization if proper RCU
functions are used to access the pointer. This patch converts all
accesses to rq->xdp_prog to use RCU functions.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 53 +++++++++----------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0cc2080fd847..5d7b79518449 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -600,7 +600,7 @@ struct mlx5e_rq {
 	struct dim         dim; /* Dynamic Interrupt Moderation */
 
 	/* XDP */
-	struct bpf_prog       *xdp_prog;
+	struct bpf_prog __rcu *xdp_prog;
 	struct mlx5e_xdpsq    *xdpsq;
 	DECLARE_BITMAP(flags, 8);
 	struct page_pool      *page_pool;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 0e6946fc121f..b28df21981a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -122,7 +122,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      u32 *len, struct xdp_buff *xdp)
 {
-	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
+	struct bpf_prog *prog = rcu_dereference(rq->xdp_prog);
 	u32 act;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index aebcf73f8546..bde97b108db5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -399,7 +399,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 	if (params->xdp_prog)
 		bpf_prog_inc(params->xdp_prog);
-	rq->xdp_prog = params->xdp_prog;
+	RCU_INIT_POINTER(rq->xdp_prog, params->xdp_prog);
 
 	rq_xdp_ix = rq->ix;
 	if (xsk)
@@ -408,7 +408,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (err < 0)
 		goto err_rq_wq_destroy;
 
-	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+	rq->buff.map_dir = params->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
 	pool_size = 1 << params->log_rq_mtu_frames;
 
@@ -564,8 +564,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 
 err_rq_wq_destroy:
-	if (rq->xdp_prog)
-		bpf_prog_put(rq->xdp_prog);
+	if (params->xdp_prog)
+		bpf_prog_put(params->xdp_prog);
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
 	page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
@@ -575,10 +575,16 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 static void mlx5e_free_rq(struct mlx5e_rq *rq)
 {
+	struct mlx5e_channel *c = rq->channel;
+	struct bpf_prog *old_prog = NULL;
 	int i;
 
-	if (rq->xdp_prog)
-		bpf_prog_put(rq->xdp_prog);
+	/* drop_rq has neither channel nor xdp_prog. */
+	if (c)
+		old_prog = rcu_dereference_protected(rq->xdp_prog,
+						     lockdep_is_held(&c->priv->state_lock));
+	if (old_prog)
+		bpf_prog_put(old_prog);
 
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
@@ -4330,6 +4336,16 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	return 0;
 }
 
+static void mlx5e_rq_replace_xdp_prog(struct mlx5e_rq *rq, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
+
+	old_prog = rcu_replace_pointer(rq->xdp_prog, prog,
+				       lockdep_is_held(&rq->channel->priv->state_lock));
+	if (old_prog)
+		bpf_prog_put(old_prog);
+}
+
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4388,29 +4404,10 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	 */
 	for (i = 0; i < priv->channels.num; i++) {
 		struct mlx5e_channel *c = priv->channels.c[i];
-		bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-
-		clear_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
-		if (xsk_open)
-			clear_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
-		napi_synchronize(&c->napi);
-		/* prevent mlx5e_poll_rx_cq from accessing rq->xdp_prog */
-
-		old_prog = xchg(&c->rq.xdp_prog, prog);
-		if (old_prog)
-			bpf_prog_put(old_prog);
-
-		if (xsk_open) {
-			old_prog = xchg(&c->xskrq.xdp_prog, prog);
-			if (old_prog)
-				bpf_prog_put(old_prog);
-		}
 
-		set_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
-		if (xsk_open)
-			set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
-		/* napi_schedule in case we have missed anything */
-		napi_schedule(&c->napi);
+		mlx5e_rq_replace_xdp_prog(&c->rq, prog);
+		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+			mlx5e_rq_replace_xdp_prog(&c->xskrq, prog);
 	}
 
 unlock:
-- 
2.26.2

