Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152AB712B9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfGWHW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbfGWHW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:22:58 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AFA022AEC;
        Tue, 23 Jul 2019 07:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563866578;
        bh=2wCOdkv1QVEljfytLXurbz7k13DxGQJACMWzN7KzzUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqC3JdH3STt0UbR6p2jnTydaqj52Vpoz0Lwc59nibpIZf5fkWBC5okHsoacTrDZ5m
         nxwRISMn1fvPyTvmzXDJ21Is8+IesH3NvKfVf8y8L5SKFCTMg/4FwvRiUTrtkxNFu5
         +pemst2K3aZjJucDRcWxCQbvvekJ5ZTqSHSA9jeo=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net 1/2] linux/dim: Fix overflow in dim calculation
Date:   Tue, 23 Jul 2019 10:22:47 +0300
Message-Id: <20190723072248.6844-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723072248.6844-1-leon@kernel.org>
References: <20190723072248.6844-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

While using net_dim, a dim_sample was used without ever initializing the
comps value. Added use of DIV_ROUND_DOWN_ULL() to prevent potential
overflow, it should not be a problem to save the final result in an int
because after the division by epms the value should not be larger than a
few thousand.

[ 1040.127124] UBSAN: Undefined behaviour in lib/dim/dim.c:78:23
[ 1040.130118] signed integer overflow:
[ 1040.131643] 134718714 * 100 cannot be represented in type 'int'

Fixes: 398c2b05bbee ("linux/dim: Add completions count to dim_sample")
Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c        | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 4 ++--
 lib/dim/dim.c                                     | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b9c5cea8db16..9483553ce444 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -992,7 +992,7 @@ static int bcm_sysport_poll(struct napi_struct *napi, int budget)
 {
 	struct bcm_sysport_priv *priv =
 		container_of(napi, struct bcm_sysport_priv, napi);
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};
 	unsigned int work_done = 0;

 	work_done = bcm_sysport_desc_rx(priv, budget);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7134d2c3eb1c..7070349915bc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2136,7 +2136,7 @@ static int bnxt_poll(struct napi_struct *napi, int budget)
 		}
 	}
 	if (bp->flags & BNXT_FLAG_DIM) {
-		struct dim_sample dim_sample;
+		struct dim_sample dim_sample = {};

 		dim_update_sample(cpr->event_ctr,
 				  cpr->rx_packets,
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a2b57807453b..d3a0b614dbfa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1895,7 +1895,7 @@ static int bcmgenet_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct bcmgenet_rx_ring *ring = container_of(napi,
 			struct bcmgenet_rx_ring, napi);
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};
 	unsigned int work_done;

 	work_done = bcmgenet_desc_rx(ring, budget);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index c50b6f0769c8..49b06b256c92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -49,7 +49,7 @@ static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 static void mlx5e_handle_tx_dim(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_sq_stats *stats = sq->stats;
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};

 	if (unlikely(!test_bit(MLX5E_SQ_STATE_AM, &sq->state)))
 		return;
@@ -61,7 +61,7 @@ static void mlx5e_handle_tx_dim(struct mlx5e_txqsq *sq)
 static void mlx5e_handle_rx_dim(struct mlx5e_rq *rq)
 {
 	struct mlx5e_rq_stats *stats = rq->stats;
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};

 	if (unlikely(!test_bit(MLX5E_RQ_STATE_AM, &rq->state)))
 		return;
diff --git a/lib/dim/dim.c b/lib/dim/dim.c
index 439d641ec796..38045d6d0538 100644
--- a/lib/dim/dim.c
+++ b/lib/dim/dim.c
@@ -74,8 +74,8 @@ void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 					delta_us);
 	curr_stats->cpms = DIV_ROUND_UP(ncomps * USEC_PER_MSEC, delta_us);
 	if (curr_stats->epms != 0)
-		curr_stats->cpe_ratio =
-				(curr_stats->cpms * 100) / curr_stats->epms;
+		curr_stats->cpe_ratio = DIV_ROUND_DOWN_ULL(
+			curr_stats->cpms * 100, curr_stats->epms);
 	else
 		curr_stats->cpe_ratio = 0;

--
2.20.1

