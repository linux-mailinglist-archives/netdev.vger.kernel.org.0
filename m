Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5022FC75
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgG0WqN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:46:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20886 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgG0WqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:46:11 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMiuLb008876
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gjjes9fj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:09 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:53 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 0B08C3FAB6F81; Mon, 27 Jul 2020 15:44:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 20/21] mlx5e: hook up the netgpu functions
Date:   Mon, 27 Jul 2020 15:44:43 -0700
Message-ID: <20200727224444.2987641-21-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=3
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Hook up all the netgpu functions to the mlx5e driver.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 19 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 16 ++++-
 6 files changed, 125 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ae555c6be847..f6d63e99a6b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -297,7 +297,8 @@ struct mlx5e_cq_decomp {
 
 enum mlx5e_dma_map_type {
 	MLX5E_DMA_MAP_SINGLE,
-	MLX5E_DMA_MAP_PAGE
+	MLX5E_DMA_MAP_PAGE,
+	MLX5E_DMA_MAP_FIXED
 };
 
 struct mlx5e_sq_dma {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index cf425a60cddc..eb5dbcbc0f58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -253,6 +253,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 	case MLX5E_DMA_MAP_PAGE:
 		dma_unmap_page(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
 		break;
+	case MLX5E_DMA_MAP_FIXED:
+		/* DMA mappings are fixed, or managed elsewhere. */
+		break;
 	default:
 		WARN_ONCE(true, "mlx5e_tx_dma_unmap unknown DMA type!\n");
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d75f22471357..36afe73faa0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -62,6 +62,7 @@
 #include "en/xsk/setup.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
+#include "en/netgpu/setup.h"
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
@@ -1970,6 +1971,24 @@ mlx5e_xsk_optional_open(struct mlx5e_priv *priv, int ix,
 	return err;
 }
 
+static int
+mlx5e_netgpu_optional_open(struct mlx5e_priv *priv, int ix,
+			   struct mlx5e_params *params,
+			   struct mlx5e_channel_param *cparam,
+			   struct mlx5e_channel *c)
+{
+	struct netgpu_ifq *ifq;
+	int err = 0;
+
+	ifq = mlx5e_netgpu_get_ifq(params, params->xsk, ix);
+
+	if (ifq)
+		err = mlx5e_open_netgpu(priv, params, ifq, c);
+
+	return err;
+}
+
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2017,6 +2036,11 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			goto err_close_queues;
 	}
 
+	/* This opens a second set of shadow queues for netgpu */
+	err = mlx5e_netgpu_optional_open(priv, ix, params, cparam, c);
+	if (unlikely(err))
+		goto err_close_queues;
+
 	*cp = c;
 
 	return 0;
@@ -2053,6 +2077,9 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_deactivate_xsk(c);
 
+	if (test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state))
+		mlx5e_deactivate_netgpu(c);
+
 	mlx5e_deactivate_rq(&c->rq);
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
@@ -2064,6 +2091,10 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 {
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_close_xsk(c);
+
+	if (test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state))
+		mlx5e_close_netgpu(c);
+
 	mlx5e_close_queues(c);
 	netif_napi_del(&c->napi);
 
@@ -3042,11 +3073,13 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_redirect_rqts_to_channels(priv, &priv->channels);
 
 	mlx5e_xsk_redirect_rqts_to_channels(priv, &priv->channels);
+	mlx5e_netgpu_redirect_rqts_to_channels(priv, &priv->channels);
 }
 
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 {
 	mlx5e_xsk_redirect_rqts_to_drop(priv, &priv->channels);
+	mlx5e_netgpu_redirect_rqts_to_drop(priv, &priv->channels);
 
 	mlx5e_redirect_rqts_to_drop(priv);
 
@@ -4581,6 +4614,9 @@ static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_XSK_UMEM:
 		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
 					    xdp->xsk.queue_id);
+	case XDP_SETUP_NETGPU:
+		return mlx5e_netgpu_setup_ifq(dev, xdp->netgpu.ifq,
+					      &xdp->netgpu.queue_id);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 74860f3827b1..746fbb417c3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -50,6 +50,7 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
+#include "en/netgpu/setup.h"
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -266,8 +267,11 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 {
 	if (rq->umem)
 		return mlx5e_xsk_page_alloc_umem(rq, dma_info);
-	else
-		return mlx5e_page_alloc_pool(rq, dma_info);
+
+	if (dma_info->netgpu_source)
+		return mlx5e_netgpu_get_page(rq, dma_info);
+
+	return mlx5e_page_alloc_pool(rq, dma_info);
 }
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
@@ -279,6 +283,9 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info,
 				bool recycle)
 {
+	if (dma_info->netgpu_source)
+		return mlx5e_netgpu_put_page(rq, dma_info, recycle);
+
 	if (likely(recycle)) {
 		if (mlx5e_rx_cache_put(rq, dma_info))
 			return;
@@ -394,6 +401,9 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 			return -ENOMEM;
 	}
 
+	if (rq->netgpu && !mlx5e_netgpu_avail(rq, wqe_bulk))
+		return -ENOMEM;
+
 	for (i = 0; i < wqe_bulk; i++) {
 		struct mlx5e_rx_wqe_cyc *wqe = mlx5_wq_cyc_get_wqe(wq, ix + i);
 
@@ -402,6 +412,9 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 			goto free_wqes;
 	}
 
+	if (rq->netgpu)
+		mlx5e_netgpu_taken(rq);
+
 	return 0;
 
 free_wqes:
@@ -416,12 +429,18 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   struct mlx5e_dma_info *di, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
-	dma_sync_single_for_cpu(rq->pdev,
-				di->addr + frag_offset,
-				len, DMA_FROM_DEVICE);
-	page_ref_inc(di->page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 			di->page, frag_offset, len, truesize);
+
+	if (skb->zc_netgpu) {
+		di->page = NULL;
+	} else {
+		page_ref_inc(di->page);
+
+		dma_sync_single_for_cpu(rq->pdev,
+					di->addr + frag_offset,
+					len, DMA_FROM_DEVICE);
+	}
 }
 
 static inline void
@@ -1152,16 +1171,26 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	u16 headlen      = min_t(u32, MLX5E_RX_MAX_HEAD, cqe_bcnt);
+	bool hd_split	 = rq->netgpu;
+	u16 header_len	 = hd_split ? TOTAL_HEADERS : MLX5E_RX_MAX_HEAD;
+	u16 headlen      = min_t(u32, header_len, cqe_bcnt);
 	u16 frag_headlen = headlen;
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
 
+	/* RST packets may have short headers (74) and no payload */
+	if (hd_split && headlen != TOTAL_HEADERS && byte_cnt) {
+		/* XXX add drop counter */
+		pr_warn_once("BAD hd_split: headlen %d != %d\n",
+			     headlen, TOTAL_HEADERS);
+		return NULL;
+	}
+
 	/* XDP is not supported in this configuration, as incoming packets
 	 * might spread among multiple pages.
 	 */
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(header_len, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1169,6 +1198,19 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	prefetchw(skb->data);
 
+	if (hd_split) {
+		/* first frag is only headers, should skip this frag and
+		 * assume that all of the headers already copied to the skb
+		 * inline data.
+		 */
+		frag_info++;
+		frag_headlen = 0;
+		wi++;
+
+		skb->zc_netgpu = 1;
+		skb_shinfo(skb)->destructor_arg = rq->netgpu;
+	}
+
 	while (byte_cnt) {
 		u16 frag_consumed_bytes =
 			min_t(u16, frag_info->frag_size - frag_headlen, byte_cnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index da596de3abba..4a5f884771e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -39,6 +39,7 @@
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
 #include "lib/clock.h"
+#include "en/netgpu/setup.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -207,6 +208,24 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		dseg++;
 	}
 
+	if (skb_netdma(skb)) {
+		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+			int fsz = skb_frag_size(frag);
+
+			dma_addr = mlx5e_netgpu_get_dma(skb, frag);
+
+			dseg->addr       = cpu_to_be64(dma_addr);
+			dseg->lkey       = sq->mkey_be;
+			dseg->byte_count = cpu_to_be32(fsz);
+
+			mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_FIXED);
+			num_dma++;
+			dseg++;
+		}
+		return num_dma;
+	}
+
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int fsz = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index e3dbab2a294c..383289e85b01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -122,6 +122,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
 	bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+	bool netgpu_open = test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state);
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
@@ -139,7 +140,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		busy |= mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
 
 	if (likely(budget)) { /* budget=0 means: don't poll rx rings */
-		if (xsk_open)
+		if (xsk_open || netgpu_open)
 			work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
 
 		if (likely(budget - work_done))
@@ -159,6 +160,14 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 				mlx5e_post_rx_mpwqes,
 				mlx5e_post_rx_wqes,
 				rq);
+
+	if (netgpu_open) {
+		busy_xsk |= INDIRECT_CALL_2(xskrq->post_wqes,
+					    mlx5e_post_rx_mpwqes,
+					    mlx5e_post_rx_wqes,
+					    xskrq);
+	}
+
 	if (xsk_open) {
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
 		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
@@ -192,6 +201,11 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&c->async_icosq.cq);
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
+	if (netgpu_open) {
+		mlx5e_handle_rx_dim(xskrq);
+		mlx5e_cq_arm(&xskrq->cq);
+	}
+
 	if (xsk_open) {
 		mlx5e_handle_rx_dim(xskrq);
 		mlx5e_cq_arm(&xsksq->cq);
-- 
2.24.1

