Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE94DA1BC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394789AbfJPWu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:50:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393537AbfJPWu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:56 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMop50031008
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:55 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vp5k0a6tj-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:55 -0700
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 15:50:29 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id C47574A2BD58; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 03/10 net-next] net/mlx5e: RX, Internal DMA mapping in page_pool
Date:   Wed, 16 Oct 2019 15:50:21 -0700
Message-ID: <20191016225028.2100206-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 bulkscore=0 clxscore=1034 mlxscore=0 mlxlogscore=863
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

After RX page-cache is removed in previous patch, let the
page_pool be responsible for the DMA mapping.

Issue: 1487631
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  3 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 16 +---------------
 4 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a1ab5c76177d..2e281c755b65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -926,10 +926,8 @@ bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info);
-void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 1b26061cb959..8376b2789575 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -161,8 +161,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
-		if (!xsk)
-			mlx5e_page_dma_unmap(rq, di);
+		/* xdp maps call xdp_release_frame() if needed */
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 168be1f800a3..2b828de1adf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -546,7 +546,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
-		pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
+		pp_params.flags     = PP_FLAG_DMA_MAP;
 		pp_params.pool_size = pool_size;
 		pp_params.nid       = cpu_to_node(c->cpu);
 		pp_params.dev       = c->pdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 033b8264a4e4..1b74d03fdf06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -190,14 +190,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 	dma_info->page = page_pool_dev_alloc_pages(rq->page_pool);
 	if (unlikely(!dma_info->page))
 		return -ENOMEM;
-
-	dma_info->addr = dma_map_page(rq->pdev, dma_info->page, 0,
-				      PAGE_SIZE, rq->buff.map_dir);
-	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
-		page_pool_recycle_direct(rq->page_pool, dma_info->page);
-		dma_info->page = NULL;
-		return -ENOMEM;
-	}
+	dma_info->addr = page_pool_get_dma_addr(dma_info->page);
 
 	return 0;
 }
@@ -211,16 +204,9 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 		return mlx5e_page_alloc_pool(rq, dma_info);
 }
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
-{
-	dma_unmap_page(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir);
-}
-
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info)
 {
-	mlx5e_page_dma_unmap(rq, dma_info);
-
 	page_pool_recycle_direct(rq->page_pool, dma_info->page);
 }
 
-- 
2.17.1

