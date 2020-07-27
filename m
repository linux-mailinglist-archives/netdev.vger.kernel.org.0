Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65522FC74
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgG0WqM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:46:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727800AbgG0WqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:46:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RMhEqh012449
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmhknw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:08 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:52 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id F23DE3FAB6F7B; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 17/21] mlx5e: add header split ability
Date:   Mon, 27 Jul 2020 15:44:40 -0700
Message-ID: <20200727224444.2987641-18-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1034 bulkscore=0 lowpriorityscore=0 suspectscore=3
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Header split may be requested for a specific rq via a flag in the
xsk parameter.  If splitting is enabled (defaults to ipv6), set the
wq_type to WQ_TYPE_CYCLIC.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 +++
 .../ethernet/mellanox/mlx5/core/en/params.c   |  3 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 47 ++++++++++++++-----
 5 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c44669102626..24d88e8952ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -58,6 +58,11 @@
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
+#define TCP_HDRS_LEN (20 + 20)  /* headers + options */
+#define IP6_HDRS_LEN (40)
+#define MAC_HDR_LEN (14)
+#define TOTAL_HEADERS (TCP_HDRS_LEN + IP6_HDRS_LEN + MAC_HDR_LEN)
+#define HD_SPLIT_DEFAULT_FRAG_SIZE (4096)
 
 #define MLX5E_METADATA_ETHER_TYPE (0x8CE4)
 #define MLX5E_METADATA_ETHER_LEN 8
@@ -538,6 +543,7 @@ enum mlx5e_rq_flag {
 struct mlx5e_rq_frag_info {
 	int frag_size;
 	int frag_stride;
+	int frag_source;
 };
 
 struct mlx5e_rq_frags_info {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 38e4f19d69f8..a83a7d4d2551 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -146,7 +146,8 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk)
 {
-	bool is_linear_skb = (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
+	bool is_linear_skb = (xsk && xsk->hd_split) ? false :
+		(params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
 		mlx5e_rx_is_linear_skb(params, xsk) :
 		mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index a87273e801b2..eb2d05a7c5b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -9,6 +9,7 @@
 struct mlx5e_xsk_param {
 	u16 headroom;
 	u16 chunk_size;
+	bool hd_split;
 };
 
 struct mlx5e_cq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 331ca2b0f8a4..8ecfbcc3c826 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -72,6 +72,7 @@ void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk)
 {
 	xsk->headroom = xsk_umem_get_headroom(umem);
 	xsk->chunk_size = xsk_umem_get_chunk_size(umem);
+	xsk->hd_split = false;
 }
 
 static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3762d4527afe..5a0b181f92f7 100644
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
@@ -373,6 +374,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	struct mlx5_core_dev *mdev = c->mdev;
 	void *rqc = rqp->rqc;
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	bool hd_split = xsk && xsk->hd_split;
 	u32 rq_xdp_ix;
 	u32 pool_size;
 	int wq_sz;
@@ -381,7 +383,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 	rqp->wq.db_numa_node = cpu_to_node(c->cpu);
 
-	rq->wq_type = params->rq_wq_type;
+	rq->wq_type = hd_split ? MLX5_WQ_TYPE_CYCLIC : params->rq_wq_type;
 	rq->pdev    = c->pdev;
 	rq->netdev  = c->netdev;
 	rq->tstamp  = c->tstamp;
@@ -508,15 +510,16 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_free;
 		}
 
-		rq->wqe.skb_from_cqe = xsk ?
-			mlx5e_xsk_skb_from_cqe_linear :
+		rq->wqe.skb_from_cqe =
+			hd_split ? mlx5e_skb_from_cqe_nonlinear :
+			xsk ? mlx5e_xsk_skb_from_cqe_linear :
 			mlx5e_rx_is_linear_skb(params, NULL) ?
 				mlx5e_skb_from_cqe_linear :
 				mlx5e_skb_from_cqe_nonlinear;
 		rq->mkey_be = c->mkey_be;
 	}
 
-	if (xsk) {
+	if (xsk && !hd_split) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
 		xsk_buff_set_rxq_info(rq->umem, &rq->xdp_rxq);
@@ -2074,16 +2077,20 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				      struct mlx5e_rq_frags_info *info)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	int frag_size_max = DEFAULT_FRAG_SIZE;
+	bool hd_split = xsk && xsk->hd_split;
+	int frag_size_max;
 	u32 buf_size = 0;
 	int i;
 
+	frag_size_max = hd_split ? HD_SPLIT_DEFAULT_FRAG_SIZE :
+			DEFAULT_FRAG_SIZE;
+
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (MLX5_IPSEC_DEV(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 #endif
 
-	if (mlx5e_rx_is_linear_skb(params, xsk)) {
+	if (!hd_split && mlx5e_rx_is_linear_skb(params, xsk)) {
 		int frag_stride;
 
 		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
@@ -2101,6 +2108,16 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		frag_size_max = PAGE_SIZE;
 
 	i = 0;
+
+	if (hd_split) {
+		// Start with one fragment for all headers (implementing HDS)
+		info->arr[0].frag_size = TOTAL_HEADERS;
+		info->arr[0].frag_stride = roundup_pow_of_two(PAGE_SIZE);
+		buf_size += TOTAL_HEADERS;
+		// Now, continue with the payload frags.
+		i = 1;
+	}
+
 	while (buf_size < byte_count) {
 		int frag_size = byte_count - buf_size;
 
@@ -2108,8 +2125,10 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 			frag_size = min(frag_size, frag_size_max);
 
 		info->arr[i].frag_size = frag_size;
-		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
-
+		info->arr[i].frag_stride = roundup_pow_of_two(hd_split ?
+							      PAGE_SIZE :
+							      frag_size);
+		info->arr[i].frag_source = hd_split;
 		buf_size += frag_size;
 		i++;
 	}
@@ -2152,9 +2171,11 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	void *rqc = param->rqc;
 	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	bool hd_split = xsk && xsk->hd_split;
+	u8 wq_type = hd_split ? MLX5_WQ_TYPE_CYCLIC : params->rq_wq_type;
 	int ndsegs = 1;
 
-	switch (params->rq_wq_type) {
+	switch (wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		MLX5_SET(wq, wq, log_wqe_num_of_strides,
 			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
@@ -2170,10 +2191,10 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 		ndsegs = param->frags_info.num_frags;
 	}
 
-	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
+	MLX5_SET(wq, wq, wq_type,          wq_type);
 	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
 	MLX5_SET(wq, wq, log_wq_stride,
-		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
+		 mlx5e_get_rqwq_log_stride(wq_type, ndsegs));
 	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.pdn);
 	MLX5_SET(rqc, rqc, counter_set_id, priv->q_counter);
 	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
@@ -2243,9 +2264,11 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	void *cqc = param->cqc;
+	bool hd_split = xsk && xsk->hd_split;
+	u8 wq_type = hd_split ? MLX5_WQ_TYPE_CYCLIC : params->rq_wq_type;
 	u8 log_cq_size;
 
-	switch (params->rq_wq_type) {
+	switch (wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
 			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
-- 
2.24.1

