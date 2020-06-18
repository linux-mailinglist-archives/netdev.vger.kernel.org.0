Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908181FF8CE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731978AbgFRQKH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731620AbgFRQJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9ju8029958
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:51 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q644n0tx-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:51 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 36B6C3D44E136; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 04/21] mlx5: add definitions for header split and netgpu
Date:   Thu, 18 Jun 2020 09:09:24 -0700
Message-ID: <20200618160941.879717-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=949 phishscore=0 spamscore=0 clxscore=1034 bulkscore=0
 cotscore=-2147483648 suspectscore=1 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for fixed-length header splitting at TOTAL_HEADERS,
and pointers for the upcoming netdma work.  This reuses the same
structures as xsk, so both cannot be run simultaneously.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 22 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  3 +++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 842db20493df..0483cc815340 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -58,6 +58,12 @@
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
+#define TCP_HDRS_LEN (20 + 20)  /* headers + options */
+#define IP6_HDRS_LEN (40)
+#define MAC_HDR_LEN (14)
+#define TOTAL_HEADERS (TCP_HDRS_LEN + IP6_HDRS_LEN + MAC_HDR_LEN)
+#define HD_SPLIT_DEFAULT_FRAG_SIZE (4096)
+#define MLX5E_HD_SPLIT(params) (params->hd_split)
 
 #define MLX5E_METADATA_ETHER_TYPE (0x8CE4)
 #define MLX5E_METADATA_ETHER_LEN 8
@@ -228,6 +234,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_STRIDING_RQ,
 	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
 	MLX5E_PFLAG_XDP_TX_MPWQE,
+	MLX5E_PFLAG_RX_HD_SPLIT,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
 
@@ -263,6 +270,7 @@ struct mlx5e_params {
 	struct mlx5e_xsk *xsk;
 	unsigned int sw_mtu;
 	int hard_mtu;
+	bool hd_split;
 };
 
 enum {
@@ -299,7 +307,8 @@ struct mlx5e_cq_decomp {
 
 enum mlx5e_dma_map_type {
 	MLX5E_DMA_MAP_SINGLE,
-	MLX5E_DMA_MAP_PAGE
+	MLX5E_DMA_MAP_PAGE,
+	MLX5E_DMA_MAP_FIXED
 };
 
 struct mlx5e_sq_dma {
@@ -367,6 +376,7 @@ struct mlx5e_dma_info {
 		struct page *page;
 		struct xdp_buff *xsk;
 	};
+	bool netgpu_source;
 };
 
 /* XDP packets can be transmitted in different ways. On completion, we need to
@@ -545,6 +555,7 @@ enum mlx5e_rq_flag {
 struct mlx5e_rq_frag_info {
 	int frag_size;
 	int frag_stride;
+	int frag_source;
 };
 
 struct mlx5e_rq_frags_info {
@@ -554,6 +565,7 @@ struct mlx5e_rq_frags_info {
 	u8 wqe_bulk;
 };
 
+struct netgpu_ctx;
 struct mlx5e_rq {
 	/* data path */
 	union {
@@ -611,6 +623,7 @@ struct mlx5e_rq {
 
 	/* AF_XDP zero-copy */
 	struct xdp_umem       *umem;
+	struct netgpu_ctx     *netgpu;
 
 	struct work_struct     recover_work;
 
@@ -628,6 +641,7 @@ struct mlx5e_rq {
 
 enum mlx5e_channel_state {
 	MLX5E_CHANNEL_STATE_XSK,
+	MLX5E_CHANNEL_STATE_NETGPU,
 	MLX5E_CHANNEL_NUM_STATES
 };
 
@@ -736,9 +750,13 @@ struct mlx5e_xsk {
 	 * but it doesn't distinguish between zero-copy and non-zero-copy UMEMs,
 	 * so rely on our mechanism.
 	 */
-	struct xdp_umem **umems;
+	union {
+		struct xdp_umem **umems;
+		struct netgpu_ctx **ctx_tbl;
+	};
 	u16 refcnt;
 	bool ever_used;
+	bool is_netgpu;
 };
 
 /* Temporary storage for variables that are allocated when struct mlx5e_priv is
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index bfd3e1161bc6..dfd20c30de02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -238,6 +238,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 	case MLX5E_DMA_MAP_PAGE:
 		dma_unmap_page(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
 		break;
+	case MLX5E_DMA_MAP_FIXED:
+		/* DMA mappings are fixed, or managed elsewhere. */
+		break;
 	default:
 		WARN_ONCE(true, "mlx5e_tx_dma_unmap unknown DMA type!\n");
 	}
-- 
2.24.1

