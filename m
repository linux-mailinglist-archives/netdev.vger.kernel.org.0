Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E94F6E477F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjDQMVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDQMVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB7A46AC
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzaEr77JdpQiXjyxBEcpB1JNLCYf4sP7s2pDP4aEYq5gSaU7sNnVHovLajTOwbW/oW0svXNv5JswSLac0bgFwMSD900aGQ/x/uSgTPlLSSJfPb5jFg5axREjuXTnW8FpB6uJCuUzxCvX1IqowZiU+ZK3rwiRLliXTYVl6f+PKrAgKVuAlihyWspHWao5DTgFrO9HbwXwON8eu9dz4/qhIuMf+UBpHaHFpt3u1K8puJBM3p1jbZmmpuYHL4kCtjmWTPJ9AAK64AjekjeAfFfhLxt2JI+EKRpipELkF6ZQnbaS6krkGYGBPaTdXRaNDILsW3rcZIxevmEZw6XbRuOLyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6q5Qj5Wfvs+ye9i5ZP2QNXqH11aMhbsuVV7ojUhc28=;
 b=WMAoaRdoUEfohKKtsuGRG9LvhmWLfcnL7qo7KsZLrAej3ojPp7xrL7HnmTzGHG3R0utmVndyvajvRTFDkh5WKqVkGEkXHldJHZqdUBRhLlci76bAaq1rltt3oh8PAx4m/jgNir9uk/yKZtxj6hSZIAUNCMV4kw0Q7ACfy9J+8tez4pE8BzZvlNMoFXCTv4dL44RM4GEowLtptWSMkjaRIAXJwWthAMUgctbKInDpOjbQbjnHcI7N6D4EHC+PoFzg7AqvvXAJ2AtElhkVQEj6argGe5QEF+3ESJm2Rqs3gps85G1LwvjHLBo2bQuj9LPO1DuvjPFacUM1So4Aei/rKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6q5Qj5Wfvs+ye9i5ZP2QNXqH11aMhbsuVV7ojUhc28=;
 b=VeHy7+LtwLkmXQptt5A8kCRkm7t+sHzN9uimCbzSIAUlLLeiGXDVGmkYtXlugOJmuDYfexQ+ZwYJGQNiIn8jLwKkcEcNjbzQu2kD+JvcPoxwbonaPvCBZKUZuPBz6/X0bAkYgfPnk8qyCTCBrNW3ZWvUtsLTdUm4fnoeQkIPWcmMcoOkMDZJQQwlpq35E9G54B3UvACZdOIwrMN0WSb+PH6rPLzNzmPDYfEk0UqHADKkUA500G6OX0sC+1B1Tq2CJHHaL0ZMQDOjRgTrDSlDEqwSLh5xX41b+EQaMPJKogu7qLG+H7P/o0TsWar1+YHWXsmMPA83uz8OsihnOESwCQ==
Received: from BN0PR10CA0013.namprd10.prod.outlook.com (2603:10b6:408:143::17)
 by DS7PR12MB8252.namprd12.prod.outlook.com (2603:10b6:8:ee::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Mon, 17 Apr 2023 12:20:21 +0000
Received: from BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::b2) by BN0PR10CA0013.outlook.office365.com
 (2603:10b6:408:143::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT108.mail.protection.outlook.com (10.13.176.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:10 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:09 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:06 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 06/15] net/mlx5e: XDP, Add support for multi-buffer XDP redirect-in
Date:   Mon, 17 Apr 2023 15:18:54 +0300
Message-ID: <20230417121903.46218-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT108:EE_|DS7PR12MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cc697e3-cefb-4d12-47e5-08db3f3e1d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwCBUdnD4sJhbWs3csmBe6uqONHFo6KskVfjbhYMP64edLCURnPEU0L4ie4kbv/KdFibfsaGnkbwbSAEW0kX460pf5W76RXUqGq2X8YpMrGDZ4RhPXKSjyrp2ij4VpEXICv+riR3XEMqpw/in8b5R4SoDQlUQUPWUMO/rFV/0dIy4lrZFVfzXVJtBIdGSxEhz/0iYsYq9P9lzdqVlPD+lrwH0mQ7Hv0oRd4Pva6EQJC0TEPyu7/7NYyY6x4N+gEmcfEgiNUtHjLh5UVyBg5Qnl5C6hvVCZkmEDd0Tx08x4x7Ky0pzdJ4CpDc33cRMVSaQa2KEPOhYZ24AXXGxZKcBP9yr56WTS96BIkfr+NSrLumBMU6PlY77DuB/vwr+abJHXKHRwC6Wjw0ocgs3pHqSxHaDwHYiHkHFbb5BsCV0JEuYcrC5ZZ8L26YqDorzWzxeJglJEkBfHnOISJQJ2o4ccGb5hImWuBm6NV1FJz/QczN/HaTeGFPr3S16GRB8iThpgvuuetEE0hA7uafdd9++e/svDsyC+Zsj6nqI90nmWZQ0G5W2tmpkF4WpnuZ+oXL72MmM1FGD27fpUbg0sFlNvsGIDsylYrPNKoCuVviIxFElU5xrlppvG4CkJONWwFN3RnijZDI+l8I3WjmHvDcHVNUUbEZxEcGqG7Z56oigsCJm5TberbWiWBTt21YzsCwD3LoXCow0rd3mkRgnQqxBCRnukV4ksccQkLi5quIeykDFUXeQlRGiCJb9DkiZB75E+OR6RK726rgten3GeGQ1A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(34020700004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(40480700001)(70206006)(54906003)(7636003)(110136005)(356005)(40460700003)(186003)(107886003)(2906002)(36756003)(1076003)(26005)(426003)(336012)(86362001)(83380400001)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(7696005)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:20.9441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc697e3-cefb-4d12-47e5-08db3f3e1d12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8252
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle multi-buffer XDP redirect-in requests coming through
mlx5e_xdp_xmit.

Extend struct mlx5e_xmit_data_frags with an additional dma_arr field, to
point to the fragments dma mapping, as they cannot be retrieved via the
page_pool_get_dma_addr() function.

Push a dma_addr xdpi instance per each fragment, and use them in the
completion flow to dma_unmap the frags.

Finally, remove the restriction in mlx5e_open_xdpsq, and set the flag in
xdp_features.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 82 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +-
 3 files changed, 75 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 1302f52db883..47381e949f1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -87,6 +87,7 @@ struct mlx5e_xmit_data {
 struct mlx5e_xmit_data_frags {
 	struct mlx5e_xmit_data xd;
 	struct skb_shared_info *sinfo;
+	dma_addr_t *dma_arr;
 };
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 5dab9012dc2a..c266d073e2f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -126,6 +126,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 	if (xdptxd->has_frags) {
 		xdptxdf.sinfo = xdp_get_shared_info_from_frame(xdpf);
+		xdptxdf.dma_arr = NULL;
 
 		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
 			skb_frag_t *frag = &xdptxdf.sinfo->frags[i];
@@ -548,7 +549,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 			skb_frag_t *frag = &xdptxdf->sinfo->frags[i];
 			dma_addr_t addr;
 
-			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
+			addr = xdptxdf->dma_arr ? xdptxdf->dma_arr[i] :
+				page_pool_get_dma_addr(skb_frag_page(frag)) +
 				skb_frag_off(frag);
 
 			dseg++;
@@ -601,6 +603,21 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 
 			dma_unmap_single(sq->pdev, dma_addr,
 					 xdpf->len, DMA_TO_DEVICE);
+			if (xdp_frame_has_frags(xdpf)) {
+				struct skb_shared_info *sinfo;
+				int j;
+
+				sinfo = xdp_get_shared_info_from_frame(xdpf);
+				for (j = 0; j < sinfo->nr_frags; j++) {
+					skb_frag_t *frag = &sinfo->frags[j];
+
+					xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
+					dma_addr = xdpi.frame.dma_addr;
+
+					dma_unmap_single(sq->pdev, dma_addr,
+							 skb_frag_size(frag), DMA_TO_DEVICE);
+				}
+			}
 			xdp_return_frame_bulk(xdpf, bq);
 			break;
 		}
@@ -759,23 +776,57 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	sq = &priv->channels.c[sq_num]->xdpsq;
 
 	for (i = 0; i < n; i++) {
+		struct mlx5e_xmit_data_frags xdptxdf = {};
 		struct xdp_frame *xdpf = frames[i];
-		struct mlx5e_xmit_data xdptxd = {};
+		dma_addr_t dma_arr[MAX_SKB_FRAGS];
+		struct mlx5e_xmit_data *xdptxd;
 		bool ret;
 
-		xdptxd.data = xdpf->data;
-		xdptxd.len = xdpf->len;
-		xdptxd.dma_addr = dma_map_single(sq->pdev, xdptxd.data,
-						 xdptxd.len, DMA_TO_DEVICE);
+		xdptxd = &xdptxdf.xd;
+		xdptxd->data = xdpf->data;
+		xdptxd->len = xdpf->len;
+		xdptxd->has_frags = xdp_frame_has_frags(xdpf);
+		xdptxd->dma_addr = dma_map_single(sq->pdev, xdptxd->data,
+						  xdptxd->len, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr)))
+		if (unlikely(dma_mapping_error(sq->pdev, xdptxd->dma_addr)))
 			break;
 
+		if (xdptxd->has_frags) {
+			int j;
+
+			xdptxdf.sinfo = xdp_get_shared_info_from_frame(xdpf);
+			xdptxdf.dma_arr = dma_arr;
+			for (j = 0; j < xdptxdf.sinfo->nr_frags; j++) {
+				skb_frag_t *frag = &xdptxdf.sinfo->frags[j];
+
+				dma_arr[j] = dma_map_single(sq->pdev, skb_frag_address(frag),
+							    skb_frag_size(frag), DMA_TO_DEVICE);
+
+				if (!dma_mapping_error(sq->pdev, dma_arr[j]))
+					continue;
+				/* mapping error */
+				while (--j >= 0)
+					dma_unmap_single(sq->pdev, dma_arr[j],
+							 skb_frag_size(&xdptxdf.sinfo->frags[j]),
+							 DMA_TO_DEVICE);
+				goto out;
+			}
+		}
+
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0);
+				      mlx5e_xmit_xdp_frame, sq, xdptxd, 0);
 		if (unlikely(!ret)) {
-			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
-					 xdptxd.len, DMA_TO_DEVICE);
+			int j;
+
+			dma_unmap_single(sq->pdev, xdptxd->dma_addr,
+					 xdptxd->len, DMA_TO_DEVICE);
+			if (!xdptxd->has_frags)
+				break;
+			for (j = 0; j < xdptxdf.sinfo->nr_frags; j++)
+				dma_unmap_single(sq->pdev, dma_arr[j],
+						 skb_frag_size(&xdptxdf.sinfo->frags[j]),
+						 DMA_TO_DEVICE);
 			break;
 		}
 
@@ -785,10 +836,19 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
 				     (union mlx5e_xdp_info) { .frame.xdpf = xdpf });
 		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
-				     (union mlx5e_xdp_info) { .frame.dma_addr = xdptxd.dma_addr });
+				     (union mlx5e_xdp_info) { .frame.dma_addr = xdptxd->dma_addr });
+		if (xdptxd->has_frags) {
+			int j;
+
+			for (j = 0; j < xdptxdf.sinfo->nr_frags; j++)
+				mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
+						     (union mlx5e_xdp_info)
+						     { .frame.dma_addr = dma_arr[j] });
+		}
 		nxmit++;
 	}
 
+out:
 	if (flags & XDP_XMIT_FLUSH) {
 		if (sq->mpwqe.wqe)
 			mlx5e_xdp_mpwqe_complete(sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0b5aafaefe4c..ccf7bb136f50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1862,11 +1862,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.min_inline_mode = sq->min_inline_mode;
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 
-	/* Don't enable multi buffer on XDP_REDIRECT SQ, as it's not yet
-	 * supported by upstream, and there is no defined trigger to allow
-	 * transmitting redirected multi-buffer frames.
-	 */
-	if (param->is_xdp_mb && !is_redirect)
+	if (param->is_xdp_mb)
 		set_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state);
 
 	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
@@ -4068,7 +4064,8 @@ void mlx5e_set_xdp_feature(struct net_device *netdev)
 
 	val = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 	      NETDEV_XDP_ACT_XSK_ZEROCOPY |
-	      NETDEV_XDP_ACT_NDO_XMIT;
+	      NETDEV_XDP_ACT_NDO_XMIT |
+	      NETDEV_XDP_ACT_NDO_XMIT_SG;
 	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC)
 		val |= NETDEV_XDP_ACT_RX_SG;
 	xdp_set_features_flag(netdev, val);
-- 
2.34.1

