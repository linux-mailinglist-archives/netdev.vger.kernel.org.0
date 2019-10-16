Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C158EDA1C0
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfJPWvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:51:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50350 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393616AbfJPWu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMomCa025365
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:57 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vp84a97p9-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:57 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id DDB844A2BD64; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 09/10 net-next] net/mlx5: Add page_pool stats to the Mellanox driver
Date:   Wed, 16 Oct 2019 15:50:27 -0700
Message-ID: <20191016225028.2100206-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1034 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the now deprecated inernal cache stats with the page pool stats.

# ethtool -S eth0 | grep rx_pool
     rx_pool_cache_hit: 1646798
     rx_pool_cache_full: 0
     rx_pool_cache_empty: 15723566
     rx_pool_ring_produce: 474958
     rx_pool_ring_consume: 0
     rx_pool_ring_return: 474958
     rx_pool_flush: 144
     rx_pool_node_change: 0

Showing about a 10% hit rate for the page pool.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 39 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 19 +++++----
 4 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2e281c755b65..b34519061d12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -50,6 +50,7 @@
 #include <net/xdp.h>
 #include <linux/dim.h>
 #include <linux/bits.h>
+#include <net/page_pool.h>
 #include "wq.h"
 #include "mlx5_core.h"
 #include "en_stats.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2b828de1adf0..f10b5838fb17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -551,6 +551,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		pp_params.nid       = cpu_to_node(c->cpu);
 		pp_params.dev       = c->pdev;
 		pp_params.dma_dir   = rq->buff.map_dir;
+		pp_params.stats     = &rq->stats->pool;
 
 		/* page_pool can be used even when there is no rq->xdp_prog,
 		 * given page_pool does not handle DMA mapping there is no
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index ac6fdcda7019..ad42d965d786 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -102,11 +102,14 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_buff_alloc_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_blks) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_pkts) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_reuse) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_full) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_empty) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_busy) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_waive) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_hit) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_empty) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_produce) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_consume) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_return) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_flush) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_node_change) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
@@ -214,11 +217,14 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->rx_buff_alloc_err += rq_stats->buff_alloc_err;
 		s->rx_cqe_compress_blks += rq_stats->cqe_compress_blks;
 		s->rx_cqe_compress_pkts += rq_stats->cqe_compress_pkts;
-		s->rx_cache_reuse += rq_stats->cache_reuse;
-		s->rx_cache_full  += rq_stats->cache_full;
-		s->rx_cache_empty += rq_stats->cache_empty;
-		s->rx_cache_busy  += rq_stats->cache_busy;
-		s->rx_cache_waive += rq_stats->cache_waive;
+		s->rx_pool_cache_hit += rq_stats->pool.cache_hit;
+		s->rx_pool_cache_full += rq_stats->pool.cache_full;
+		s->rx_pool_cache_empty += rq_stats->pool.cache_empty;
+		s->rx_pool_ring_produce += rq_stats->pool.ring_produce;
+		s->rx_pool_ring_consume += rq_stats->pool.ring_consume;
+		s->rx_pool_ring_return += rq_stats->pool.ring_return;
+		s->rx_pool_flush += rq_stats->pool.flush;
+		s->rx_pool_node_change += rq_stats->pool.node_change;
 		s->rx_congst_umr  += rq_stats->congst_umr;
 		s->rx_arfs_err    += rq_stats->arfs_err;
 		s->rx_recover     += rq_stats->recover;
@@ -1446,11 +1452,14 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_blks) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_reuse) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_full) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_empty) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_busy) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_waive) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_hit) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_full) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_empty) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_produce) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_consume) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_return) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.flush) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.node_change) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 79f261bf86ac..7d6001969400 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -109,11 +109,14 @@ struct mlx5e_sw_stats {
 	u64 rx_buff_alloc_err;
 	u64 rx_cqe_compress_blks;
 	u64 rx_cqe_compress_pkts;
-	u64 rx_cache_reuse;
-	u64 rx_cache_full;
-	u64 rx_cache_empty;
-	u64 rx_cache_busy;
-	u64 rx_cache_waive;
+	u64 rx_pool_cache_hit;
+	u64 rx_pool_cache_full;
+	u64 rx_pool_cache_empty;
+	u64 rx_pool_ring_produce;
+	u64 rx_pool_ring_consume;
+	u64 rx_pool_ring_return;
+	u64 rx_pool_flush;
+	u64 rx_pool_node_change;
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
@@ -245,14 +248,10 @@ struct mlx5e_rq_stats {
 	u64 buff_alloc_err;
 	u64 cqe_compress_blks;
 	u64 cqe_compress_pkts;
-	u64 cache_reuse;
-	u64 cache_full;
-	u64 cache_empty;
-	u64 cache_busy;
-	u64 cache_waive;
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
+	struct page_pool_stats pool;
 };
 
 struct mlx5e_sq_stats {
-- 
2.17.1

