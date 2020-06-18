Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978C1FF8DE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgFRQKb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729101AbgFRQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG1wHN013692
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q660vyhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:49 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 3E4C23D44E13A; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 06/21] mlx5: add header_split flag
Date:   Thu, 18 Jun 2020 09:09:26 -0700
Message-ID: <20200618160941.879717-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 clxscore=1034 mlxscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0
 cotscore=-2147483648 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a "rx_hd_split" private flag parameter to ethtool.

This enables header splitting, and sets up the fragment mappings.
The feature is currently only enabled for netgpu channels.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 15 +++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 +++++++++++++++----
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ec5658bbe3c5..a1b5d8b33b0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1905,6 +1905,20 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_pflag_rx_hd_split(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err;
+
+	priv->channels.params.hd_split = enable;
+	err = mlx5e_safe_reopen_channels(priv);
+	if (err)
+		netdev_err(priv->netdev,
+			   "%s failed to reopen channels, err(%d).\n",
+				__func__, err);
+	return err;
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -1912,6 +1926,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_striding_rq",      set_pflag_rx_striding_rq },
 	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
+	{ "rx_hd_split",	 set_pflag_rx_hd_split },
 };
 
 static int mlx5e_handle_pflag(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a836a02a2116..cc8d30aa8a33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -123,7 +123,8 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
-	params->rq_wq_type = mlx5e_striding_rq_possible(mdev, params) &&
+	params->rq_wq_type = MLX5E_HD_SPLIT(params) ? MLX5_WQ_TYPE_CYCLIC :
+		mlx5e_striding_rq_possible(mdev, params) &&
 		MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
 		MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ :
 		MLX5_WQ_TYPE_CYCLIC;
@@ -323,6 +324,8 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 				if (prev)
 					prev->last_in_page = true;
 			}
+			next_frag.di->netgpu_source =
+						!!frag_info[f].frag_source;
 			*frag = next_frag;
 
 			/* prepare next */
@@ -373,6 +376,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	struct mlx5_core_dev *mdev = c->mdev;
 	void *rqc = rqp->rqc;
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	bool hd_split = MLX5E_HD_SPLIT(params) && (umem == (void *)0x1);
+	u32 num_xsk_frames = 0;
 	u32 rq_xdp_ix;
 	u32 pool_size;
 	int wq_sz;
@@ -391,9 +396,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq   = &c->rq_xdpsq;
-	rq->umem    = umem;
+	if (xsk)
+		rq->umem    = umem;
 
-	if (rq->umem)
+	if (umem)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
@@ -404,14 +410,18 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->xdp_prog = params->xdp_prog;
 
 	rq_xdp_ix = rq->ix;
-	if (xsk)
+	if (umem)
 		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
 	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix);
 	if (err < 0)
 		goto err_rq_wq_destroy;
 
+	if (umem == (void *)0x1)
+		rq->buff.headroom = 0;
+	else
+		rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
+
 	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
 	pool_size = 1 << params->log_rq_mtu_frames;
 
 	switch (rq->wq_type) {
@@ -509,6 +519,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		rq->wqe.skb_from_cqe = xsk ?
 			mlx5e_xsk_skb_from_cqe_linear :
+			hd_split ? mlx5e_skb_from_cqe_nonlinear :
 			mlx5e_rx_is_linear_skb(params, NULL) ?
 				mlx5e_skb_from_cqe_linear :
 				mlx5e_skb_from_cqe_nonlinear;
@@ -2035,13 +2046,19 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	int frag_size_max = DEFAULT_FRAG_SIZE;
 	u32 buf_size = 0;
 	int i;
+	bool hd_split = MLX5E_HD_SPLIT(params) && xsk;
+
+	if (hd_split)
+		frag_size_max = HD_SPLIT_DEFAULT_FRAG_SIZE;
+	else
+		frag_size_max = DEFAULT_FRAG_SIZE;
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (MLX5_IPSEC_DEV(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 #endif
 
-	if (mlx5e_rx_is_linear_skb(params, xsk)) {
+	if (!hd_split && mlx5e_rx_is_linear_skb(params, xsk)) {
 		int frag_stride;
 
 		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
@@ -2059,6 +2076,16 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
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
 
@@ -2066,8 +2093,10 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
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
-- 
2.24.1

