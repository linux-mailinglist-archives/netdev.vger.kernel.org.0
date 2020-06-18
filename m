Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752001FF8D8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgFRQJv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:09:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729046AbgFRQJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9l4t004725
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q653msay-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:47 -0700
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:46 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 576593D44E146; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 12/21] mlx5: hook up the netgpu channel functions
Date:   Thu, 18 Jun 2020 09:09:32 -0700
Message-ID: <20200618160941.879717-13-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 impostorscore=0 cotscore=-2147483648 suspectscore=3
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hook up all the netgpu plumbing, except the enable/disable calls.
Those will be added after the netgpu module itself.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../mellanox/mlx5/core/en/netgpu/setup.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 35 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 52 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 15 +++++-
 4 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
index f0578c41951d..76df316611fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
@@ -78,7 +78,7 @@ mlx5e_netgpu_avail(struct mlx5e_rq *rq, u8 count)
 	 * doesn't consider any_cache_count.
 	 */
 	return ctx->napi_cache_count >= count ||
-		sq_cons_ready(&ctx->fill) >= (count - ctx->napi_cache_count);
+		sq_cons_avail(&ctx->fill, count - ctx->napi_cache_count);
 }
 
 void mlx5e_netgpu_taken(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 01d234369df6..c791578be5ea 100644
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
@@ -1955,6 +1956,24 @@ mlx5e_xsk_optional_open(struct mlx5e_priv *priv, int ix,
 	return err;
 }
 
+static int
+mlx5e_netgpu_optional_open(struct mlx5e_priv *priv, int ix,
+			   struct mlx5e_params *params,
+			   struct mlx5e_channel_param *cparam,
+			   struct mlx5e_channel *c)
+{
+	struct netgpu_ctx *ctx;
+	int err = 0;
+
+	ctx = mlx5e_netgpu_get_ctx(params, params->xsk, ix);
+
+	if (ctx)
+		err = mlx5e_open_netgpu(priv, params, ctx, c);
+
+	return err;
+}
+
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2002,6 +2021,13 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			goto err_close_queues;
 	}
 
+	/* This opens a second set of shadow queues for netgpu */
+	if (params->hd_split) {
+		err = mlx5e_netgpu_optional_open(priv, ix, params, cparam, c);
+		if (unlikely(err))
+			goto err_close_queues;
+	}
+
 	*cp = c;
 
 	return 0;
@@ -2037,6 +2063,9 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_deactivate_xsk(c);
 
+	if (test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state))
+		mlx5e_deactivate_netgpu(c);
+
 	mlx5e_deactivate_rq(&c->rq);
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
@@ -2047,6 +2076,10 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 {
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_close_xsk(c);
+
+	if (test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state))
+		mlx5e_close_netgpu(c);
+
 	mlx5e_close_queues(c);
 	netif_napi_del(&c->napi);
 
@@ -3012,11 +3045,13 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_redirect_rqts_to_channels(priv, &priv->channels);
 
 	mlx5e_xsk_redirect_rqts_to_channels(priv, &priv->channels);
+	mlx5e_netgpu_redirect_rqts_to_channels(priv, &priv->channels);
 }
 
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 {
 	mlx5e_xsk_redirect_rqts_to_drop(priv, &priv->channels);
+	mlx5e_netgpu_redirect_rqts_to_drop(priv, &priv->channels);
 
 	mlx5e_redirect_rqts_to_drop(priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index dbb1c6323967..1edc157696f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -50,6 +50,9 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
+#include "en/netgpu/setup.h"
+
+#include <net/netgpu.h>
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -266,8 +269,11 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
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
@@ -279,6 +285,9 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info,
 				bool recycle)
 {
+	if (dma_info->netgpu_source)
+		return mlx5e_netgpu_put_page(rq, dma_info, recycle);
+
 	if (likely(recycle)) {
 		if (mlx5e_rx_cache_put(rq, dma_info))
 			return;
@@ -394,6 +403,9 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 			return -ENOMEM;
 	}
 
+	if (rq->netgpu && !mlx5e_netgpu_avail(rq, wqe_bulk))
+		return -ENOMEM;
+
 	for (i = 0; i < wqe_bulk; i++) {
 		struct mlx5e_rx_wqe_cyc *wqe = mlx5_wq_cyc_get_wqe(wq, ix + i);
 
@@ -402,6 +414,9 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 			goto free_wqes;
 	}
 
+	if (rq->netgpu)
+		mlx5e_netgpu_taken(rq);
+
 	return 0;
 
 free_wqes:
@@ -416,12 +431,17 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   struct mlx5e_dma_info *di, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
+	/* XXX skip this if netgpu_source... */
 	dma_sync_single_for_cpu(rq->pdev,
 				di->addr + frag_offset,
 				len, DMA_FROM_DEVICE);
-	page_ref_inc(di->page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 			di->page, frag_offset, len, truesize);
+
+	if (skb->zc_netgpu)
+		di->page = NULL;
+	else
+		page_ref_inc(di->page);
 }
 
 static inline void
@@ -1109,16 +1129,26 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
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
@@ -1126,6 +1156,18 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
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
+	}
+
 	while (byte_cnt) {
 		u16 frag_consumed_bytes =
 			min_t(u16, frag_info->frag_size - frag_headlen, byte_cnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 8480278f2ee2..1c646a6dc29a 100644
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
@@ -154,6 +155,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 				mlx5e_post_rx_mpwqes,
 				mlx5e_post_rx_wqes,
 				rq);
+
+	if (netgpu_open) {
+		mlx5e_poll_ico_cq(&c->xskicosq.cq);
+		busy_xsk |= xskrq->post_wqes(xskrq);
+	}
+
 	if (xsk_open) {
 		if (mlx5e_poll_ico_cq(&c->xskicosq.cq))
 			/* Don't clear the flag if nothing was polled to prevent
@@ -191,6 +198,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&c->icosq.cq);
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
+	if (netgpu_open) {
+		mlx5e_handle_rx_dim(xskrq);
+		mlx5e_cq_arm(&c->xskicosq.cq);
+		mlx5e_cq_arm(&xskrq->cq);
+	}
+
 	if (xsk_open) {
 		mlx5e_handle_rx_dim(xskrq);
 		mlx5e_cq_arm(&c->xskicosq.cq);
-- 
2.24.1

