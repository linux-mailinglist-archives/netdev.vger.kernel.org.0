Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58ED39ABA6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFCUNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFCUNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3EC2611C9;
        Thu,  3 Jun 2021 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751123;
        bh=EOa3iTtxvhjXGx4ODR2TY/R7uplD6+5MoyMctMNZ9i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhOvXi296wqLMk/BkO20XhEb8+iEwdgAyKyPgJPS2HZ5Qln2UiK25Nf1sMvZKziaT
         vGlrQfVQzBiy3tIjNsnCJtaFnLzKWadYXFHgwW1mRXpiFVC4tHEb1XptFPI040sGCA
         1+am10+uxQRQg+sPwxppJ+nS8ShWq3n+F8Ov21b+ZsabQjHBLC3H9s6VziUELw3LpZ
         rhY7tLMtNaPYIMWVm08u2FxlbzTRl8b5ORKsF5HVUhFVajU/GICI2BRrOFYbqb6Ont
         87YnTtVvzyav9VKKKea0Tz2yw8795kf40jVXR93nF8kc2h+KasjEqmxgWCNS56jCK+
         t9tF1V1TMvD/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/10] net/mlx5e: RX, Re-place page pool numa node change logic
Date:   Thu,  3 Jun 2021 13:11:52 -0700
Message-Id: <20210603201155.109184-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Move the logic that updates the page pool upon changes in numa node.
Before this patch, logic was placed in the RX polling function, being
called also when no RX traffic, wasting cpu cycles.  Here we move it to
the RX post_wqes function, to be called only when new RX descriptors are
going to be allocated.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e88429356018..3c65fd0bcf31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -579,6 +579,9 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	if (mlx5_wq_cyc_missing(wq) < wqe_bulk)
 		return false;
 
+	if (rq->page_pool)
+		page_pool_nid_changed(rq->page_pool, numa_mem_id());
+
 	do {
 		u16 head = mlx5_wq_cyc_get_head(wq);
 
@@ -734,6 +737,9 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	if (likely(missing < UMR_WQE_BULK))
 		return false;
 
+	if (rq->page_pool)
+		page_pool_nid_changed(rq->page_pool, numa_mem_id());
+
 	head = rq->mpwqe.actual_wq_head;
 	i = missing;
 	do {
@@ -1555,9 +1561,6 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
 
-	if (rq->page_pool)
-		page_pool_nid_changed(rq->page_pool, numa_mem_id());
-
 	if (rq->cqd.left) {
 		work_done += mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
 		if (work_done >= budget)
-- 
2.31.1

