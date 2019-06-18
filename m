Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6164A1A1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfFRNFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbfFRNFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:05:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79B0DC004BEE;
        Tue, 18 Jun 2019 13:05:46 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B36685C231;
        Tue, 18 Jun 2019 13:05:43 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D7EBA31256FCB;
        Tue, 18 Jun 2019 15:05:42 +0200 (CEST)
Subject: [PATCH net-next v2 07/12] mlx5: more strict use of page_pool API
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:05:42 +0200
Message-ID: <156086314281.27760.5243191391899223440.stgit@firesoul>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 18 Jun 2019 13:05:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5 driver is using page_pool, but not for DMA-mapping (currently), and
is a little too relaxed about returning or releasing page resources, as it
is not strictly necessary, when not using DMA-mappings.

As this patchset is working towards tracking page_pool resources, to know
about in-flight frames on shutdown. Then fix places where mlx5 leak
page_pool resource.

In case of dma_mapping_error, then recycle into page_pool.

In mlx5e_free_rq() moved the page_pool_destroy() call to after the
mlx5e_page_release() calls, as it is more correct.

In mlx5e_page_release() when no recycle was requested, then release page
from the page_pool, via page_pool_release_page().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 07de9ca4c53c..2f647be292b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -625,10 +625,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	if (rq->xdp_prog)
 		bpf_prog_put(rq->xdp_prog);
 
-	xdp_rxq_info_unreg(&rq->xdp_rxq);
-	if (rq->page_pool)
-		page_pool_destroy(rq->page_pool);
-
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
@@ -645,6 +641,11 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 
 		mlx5e_page_release(rq, dma_info, false);
 	}
+
+	xdp_rxq_info_unreg(&rq->xdp_rxq);
+	if (rq->page_pool)
+		page_pool_destroy(rq->page_pool);
+
 	mlx5_wq_destroy(&rq->wq_ctrl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 13133e7f088e..8331ff2ffdc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -247,7 +247,7 @@ static inline int mlx5e_page_alloc_mapped(struct mlx5e_rq *rq,
 	dma_info->addr = dma_map_page(rq->pdev, dma_info->page, 0,
 				      PAGE_SIZE, rq->buff.map_dir);
 	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
-		put_page(dma_info->page);
+		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 		dma_info->page = NULL;
 		return -ENOMEM;
 	}
@@ -271,6 +271,7 @@ void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
 		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 	} else {
 		mlx5e_page_dma_unmap(rq, dma_info);
+		page_pool_release_page(rq->page_pool, dma_info->page);
 		put_page(dma_info->page);
 	}
 }

