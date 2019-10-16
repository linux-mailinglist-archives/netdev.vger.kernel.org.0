Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3151DDA1BA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393470AbfJPWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:50:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393116AbfJPWuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:54 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9GMop7E001592
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vp8eph3ut-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:52 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 15:50:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id C004B4A2BD56; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 02/10 net-next] net/mlx5e: RX, Manage RX pages only via page pool API
Date:   Wed, 16 Oct 2019 15:50:20 -0700
Message-ID: <20191016225028.2100206-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 suspectscore=2 adultscore=0 clxscore=1034 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Do not directly call page allocator functions, but use
page pool API only.

Obsolete the recycle param.

Issue: 1487631
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  9 ++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 46 +++++++------------
 3 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0595cdcff594..a1ab5c76177d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -928,8 +928,8 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-				struct mlx5e_dma_info *dma_info,
-				bool recycle);
+				struct mlx5e_dma_info *dma_info);
+void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0ac308a..1b26061cb959 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -354,8 +354,7 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 
 static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  struct mlx5e_xdp_wqe_info *wi,
-				  u32 *xsk_frames,
-				  bool recycle)
+				  u32 *xsk_frames)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
 	u16 i;
@@ -372,7 +371,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
-			mlx5e_page_release_dynamic(xdpi.page.rq, &xdpi.page.di, recycle);
+			mlx5e_page_release_dynamic(xdpi.page.rq, &xdpi.page.di);
 			break;
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
@@ -430,7 +429,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 			sqcc += wi->num_wqebbs;
 
-			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true);
+			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames);
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
@@ -461,7 +460,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 
 		sq->cc += wi->num_wqebbs;
 
-		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, false);
+		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames);
 	}
 
 	if (xsk_frames)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a3773f8a4931..033b8264a4e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -217,31 +217,20 @@ void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
 }
 
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-				struct mlx5e_dma_info *dma_info,
-				bool recycle)
+				struct mlx5e_dma_info *dma_info)
 {
 	mlx5e_page_dma_unmap(rq, dma_info);
 
-	if (likely(recycle)) {
-		page_pool_recycle_direct(rq->page_pool, dma_info->page);
-	} else {
-		page_pool_release_page(rq->page_pool, dma_info->page);
-		put_page(dma_info->page);
-	}
+	page_pool_recycle_direct(rq->page_pool, dma_info->page);
 }
 
 static inline void mlx5e_page_release(struct mlx5e_rq *rq,
-				      struct mlx5e_dma_info *dma_info,
-				      bool recycle)
+				      struct mlx5e_dma_info *dma_info)
 {
 	if (rq->umem)
-		/* The `recycle` parameter is ignored, and the page is always
-		 * put into the Reuse Ring, because there is no way to return
-		 * the page to the userspace when the interface goes down.
-		 */
 		mlx5e_xsk_page_release(rq, dma_info);
 	else
-		mlx5e_page_release_dynamic(rq, dma_info, recycle);
+		mlx5e_page_release_dynamic(rq, dma_info);
 }
 
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
@@ -261,11 +250,10 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 }
 
 static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
-				     struct mlx5e_wqe_frag_info *frag,
-				     bool recycle)
+				     struct mlx5e_wqe_frag_info *frag)
 {
 	if (frag->last_in_page)
-		mlx5e_page_release(rq, frag->di, recycle);
+		mlx5e_page_release(rq, frag->di);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -293,26 +281,25 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 
 free_frags:
 	while (--i >= 0)
-		mlx5e_put_rx_frag(rq, --frag, true);
+		mlx5e_put_rx_frag(rq, --frag);
 
 	return err;
 }
 
 static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
-				     struct mlx5e_wqe_frag_info *wi,
-				     bool recycle)
+				     struct mlx5e_wqe_frag_info *wi)
 {
 	int i;
 
 	for (i = 0; i < rq->wqe.info.num_frags; i++, wi++)
-		mlx5e_put_rx_frag(rq, wi, recycle);
+		mlx5e_put_rx_frag(rq, wi);
 }
 
 void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_wqe_frag_info *wi = get_frag(rq, ix);
 
-	mlx5e_free_rx_wqe(rq, wi, false);
+	mlx5e_free_rx_wqe(rq, wi);
 }
 
 static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
@@ -388,7 +375,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++)
 		if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-			mlx5e_page_release(rq, &dma_info[i], recycle);
+			mlx5e_page_release(rq, &dma_info[i]);
 }
 
 static void mlx5e_post_rx_mpwqe(struct mlx5e_rq *rq, u8 n)
@@ -476,7 +463,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 err_unmap:
 	while (--i >= 0) {
 		dma_info--;
-		mlx5e_page_release(rq, dma_info, true);
+		mlx5e_page_release(rq, dma_info);
 	}
 
 err:
@@ -1120,7 +1107,7 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	napi_gro_receive(rq->cq.napi, skb);
 
 free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
+	mlx5e_free_rx_wqe(rq, wi);
 wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
@@ -1167,7 +1154,7 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	napi_gro_receive(rq->cq.napi, skb);
 
 free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
+	mlx5e_free_rx_wqe(rq, wi);
 wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
@@ -1478,7 +1465,7 @@ void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	napi_gro_receive(rq->cq.napi, skb);
 
 wq_free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
+	mlx5e_free_rx_wqe(rq, wi);
 	mlx5_wq_cyc_pop(wq);
 }
 
@@ -1518,7 +1505,8 @@ void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	napi_gro_receive(rq->cq.napi, skb);
 
 wq_free_wqe:
-	mlx5e_free_rx_wqe(rq, wi, true);
+	mlx5e_free_rx_wqe(rq, wi);
+wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
 
-- 
2.17.1

