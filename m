Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A003A6E477A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjDQMUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjDQMUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCA81738
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST5lj9TRF592er8Q27YlRLr3AYqZvAvo4ULpeQC7ctGgMvjV65J1svjejskDZFYCeP0u8qDNvIcloRIlnzt0aJnplpF01kUt+YqrerL0RXRFpk6c2hEZkcONRC9z1nUqT6ih9y1ICzVyGU1mcQ/wokeX0EATYGZxuqeP6jX0dJUer19DKhGqoZXfCOFUU4grAe3aZ8t71PmeXK+CLeg+UIXia41p25NcBdKuJMW4pNQxDsZGF+KTeK8nMvi3kUSXUueBPAwXZMLbS94e1nGrA6UBRlAxHoSNWiyi0mjrzosyGZsEZPrUe7oK0G8JPYBWm+74ayGBT+7YcsmZjkvlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fb1elEc6l/NPPJRJRXhLVmQRxgCtv67g8vqnsCNF62c=;
 b=UNeXJIG/9kBlNT0WDoVQM/ErGRksUtZXrMNOTpSZSBcLyI3XhM3zV4kvUemYR90NRTXyYlCd/cXnEmekHnSLkigwrN05Lwp9knAENcEXW5D6yAGQY8gRpmdNckOuzQ3DyyZswtJmW8mKiN8InmUxihe8rwlWyQuiSU57gL/UrU4hHZ1NA+gN3v5VdLeS04hsgHzGOWPHQC4myw2CWZ8sts97Srl0El1/V9qlWF1sjY+SK9lWmeIG44akME/siGFqzWf0b0meyPPK0acOnFpzncN4d/g0ziIrCBga0r71EsPEesxumwbrwEt7yadFibrsgX00QiDfqiLgiKZy4Bpcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fb1elEc6l/NPPJRJRXhLVmQRxgCtv67g8vqnsCNF62c=;
 b=rFcJZWt4sUJjBOlcKa5oj7yYzt3Arn/6QikexXSBnWoFn5r1e28/i8Q/navmLHRgXXOUfpR+dZLrfAbi4LEjZXukDAjw4N2aPl9nLiuZfiCTTmKuOHboGVlhErjBmLg2eZ67lKr8Q9KgUw0aZ1tkwdlebpPRa/vUOzsFFWCbWd1GXVWfury+GGL4AkwDZgtYxXP5i7h72KkmJGqULrwWqRCPRwItgFNna//pNtjWJRUQl4zpHSmPZG7zTtogMwnxybhxUMPdeB8/b4IxVPEXZFnZcszwwCcV20AYgwJEwAtTEcCbxn7CL+j1o5fg8rHD5r9Er3YLvS9USmvVUvHc6A==
Received: from BN0PR04CA0160.namprd04.prod.outlook.com (2603:10b6:408:eb::15)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:10 +0000
Received: from BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::f1) by BN0PR04CA0160.outlook.office365.com
 (2603:10b6:408:eb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT102.mail.protection.outlook.com (10.13.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:19:58 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:19:58 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:19:55 -0700
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
Subject: [PATCH net-next 03/15] net/mlx5e: Introduce extended version for mlx5e_xmit_data
Date:   Mon, 17 Apr 2023 15:18:51 +0300
Message-ID: <20230417121903.46218-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT102:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: e8617ea4-f253-4901-d440-08db3f3e1648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7qPkaVFxetmajS3xC3OsjaEMTpXULDUdpaayNekYYocBTk228YDrHbr+u66PrDGfjLFU1o3X/FlBaB8z7l3NvGZ8pEfc19w933VKpVUem6CI++iGIXyDWosgxUoqN+JJaczIPwhPaX6XPavvpLzG4ZwhbOQN7wVfIQbcQ828skcPrkgzuCCxuJGxBECQx5lDCuXlJ+gjodRb3zy6mbiaJNcz6LMASZVEZruDrRZOMvDhRZFmLOhgvRP3LYI+InkCSIz6hWRNXk0Wlm+tj8ynGdDOdCm8DlilYSJHHES3sTJ/V7VbJXAllqrhr+3JeCSZhTKo75C0zi0QlbG+MuxhuvipQo0iNCozd8lp205FbnsICbse16oS8cXsFE0sB1vFypi3/11R3UTc1hO5Hjyi2cU/7XplN6/wi8UF0v9Xd2JxrA6tNBNUs5yu7nnwxzveqGFpNqebndbfMcHPSg3hA4O9wEkuAFy+h53j1ca5Z3Xctm+8z91e24+mwdAe4vrQF2MaS6xGtaAFm+mMnQ499iorRObmbq7StdW4Gv0LltU9NRWV8iwHtx1XDVImsNNvpFkCgXJK4mqShiYKlzZk1NJDxLHYikJmZuom9H6jnScnavaJaR2rokvF2cQHHkgApydM4MUVQeV81IbfewWPdAiIXE/ulUIDluOCNmIiCMK//g1ipYfGOQPTrhsj2duC1FVtlGScBwH1fcVk+Fc+zOzt2Ajk/+u+ZtQpVcEdbUrgBJP2rFRyz0WbJ0IDHXH
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199021)(46966006)(36840700001)(356005)(7636003)(82740400003)(7696005)(34020700004)(6666004)(110136005)(54906003)(2906002)(478600001)(40480700001)(83380400001)(336012)(426003)(47076005)(107886003)(186003)(2616005)(1076003)(26005)(82310400005)(36860700001)(30864003)(4326008)(5660300002)(316002)(7416002)(70586007)(70206006)(86362001)(41300700001)(36756003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:09.5419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8617ea4-f253-4901-d440-08db3f3e1648
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce struct mlx5e_xmit_data_frags to be used for non-linear xmit
buffers. Let it include sinfo pointer.

Take one bit from the len field to indicate if the descriptor has
fragments and can be casted-up into the extended version.

Zero-init to make sure has_frags, and potentially future fields, are
zero when not explicitly assigned.

Another field will be added in a downstream patch to indicate and point
to dma addresses of the different frags, for redirect-in requests.

This simplifies the mlx5e_xmit_xdp_frame/mlx5e_xmit_xdp_frame_mpwqe
functions params.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  8 ++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 63 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  2 -
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  4 +-
 5 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 479979318c50..386f5a498e52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -487,7 +487,6 @@ struct mlx5e_xmit_data;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
-					struct skb_shared_info *,
 					int);
 
 struct mlx5e_xdpsq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 6f7ebedda279..1302f52db883 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -80,7 +80,13 @@ static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 struct mlx5e_xmit_data {
 	dma_addr_t  dma_addr;
 	void       *data;
-	u32         len;
+	u32         len : 31;
+	u32         has_frags : 1;
+};
+
+struct mlx5e_xmit_data_frags {
+	struct mlx5e_xmit_data xd;
+	struct skb_shared_info *sinfo;
 };
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c8b532cea7d1..3e7ebf0f0f01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -61,8 +61,8 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		    struct xdp_buff *xdp)
 {
 	struct page *page = virt_to_page(xdp->data);
-	struct skb_shared_info *sinfo = NULL;
-	struct mlx5e_xmit_data xdptxd;
+	struct mlx5e_xmit_data_frags xdptxdf = {};
+	struct mlx5e_xmit_data *xdptxd;
 	struct mlx5e_xdp_info xdpi;
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
@@ -72,8 +72,10 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	if (unlikely(!xdpf))
 		return false;
 
-	xdptxd.data = xdpf->data;
-	xdptxd.len  = xdpf->len;
+	xdptxd = &xdptxdf.xd;
+	xdptxd->data = xdpf->data;
+	xdptxd->len  = xdpf->len;
+	xdptxd->has_frags = xdp_frame_has_frags(xdpf);
 
 	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
 		/* The xdp_buff was in the UMEM and was copied into a newly
@@ -90,19 +92,22 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 		xdpi.mode = MLX5E_XDP_XMIT_MODE_FRAME;
 
-		dma_addr = dma_map_single(sq->pdev, xdptxd.data, xdptxd.len,
+		if (unlikely(xdptxd->has_frags))
+			return false;
+
+		dma_addr = dma_map_single(sq->pdev, xdptxd->data, xdptxd->len,
 					  DMA_TO_DEVICE);
 		if (dma_mapping_error(sq->pdev, dma_addr)) {
 			xdp_return_frame(xdpf);
 			return false;
 		}
 
-		xdptxd.dma_addr     = dma_addr;
+		xdptxd->dma_addr = dma_addr;
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = dma_addr;
 
 		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-					      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
+					      mlx5e_xmit_xdp_frame, sq, xdptxd, 0)))
 			return false;
 
 		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
@@ -119,13 +124,13 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	xdpi.page.rq = rq;
 
 	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
-	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_BIDIRECTIONAL);
+	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd->len, DMA_BIDIRECTIONAL);
 
-	if (unlikely(xdp_frame_has_frags(xdpf))) {
-		sinfo = xdp_get_shared_info_from_frame(xdpf);
+	if (unlikely(xdptxd->has_frags)) {
+		xdptxdf.sinfo = xdp_get_shared_info_from_frame(xdpf);
 
-		for (i = 0; i < sinfo->nr_frags; i++) {
-			skb_frag_t *frag = &sinfo->frags[i];
+		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &xdptxdf.sinfo->frags[i];
 			dma_addr_t addr;
 			u32 len;
 
@@ -137,18 +142,18 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		}
 	}
 
-	xdptxd.dma_addr = dma_addr;
+	xdptxd->dma_addr = dma_addr;
 
 	if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, sinfo, 0)))
+				      mlx5e_xmit_xdp_frame, sq, xdptxd, 0)))
 		return false;
 
 	xdpi.page.page = page;
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 
-	if (unlikely(xdp_frame_has_frags(xdpf))) {
-		for (i = 0; i < sinfo->nr_frags; i++) {
-			skb_frag_t *frag = &sinfo->frags[i];
+	if (unlikely(xdptxd->has_frags)) {
+		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &xdptxdf.sinfo->frags[i];
 
 			xdpi.page.page = skb_frag_page(frag);
 			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
@@ -381,23 +386,23 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     struct skb_shared_info *sinfo, int check_result);
+		     int check_result);
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-			   struct skb_shared_info *sinfo, int check_result)
+			   int check_result)
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	if (unlikely(sinfo)) {
+	if (unlikely(xdptxd->has_frags)) {
 		/* MPWQE is enabled, but a multi-buffer packet is queued for
 		 * transmission. MPWQE can't send fragmented packets, so close
 		 * the current session and fall back to a regular WQE.
 		 */
 		if (unlikely(sq->mpwqe.wqe))
 			mlx5e_xdp_mpwqe_complete(sq);
-		return mlx5e_xmit_xdp_frame(sq, xdptxd, sinfo, 0);
+		return mlx5e_xmit_xdp_frame(sq, xdptxd, 0);
 	}
 
 	if (unlikely(xdptxd->len > sq->hw_mtu)) {
@@ -446,8 +451,10 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     struct skb_shared_info *sinfo, int check_result)
+		     int check_result)
 {
+	struct mlx5e_xmit_data_frags *xdptxdf =
+		container_of(xdptxd, struct mlx5e_xmit_data_frags, xd);
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_data_seg *dseg;
@@ -476,9 +483,9 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	if (!check_result) {
 		int stop_room = 1;
 
-		if (unlikely(sinfo)) {
-			ds_cnt += sinfo->nr_frags;
-			num_frags = sinfo->nr_frags;
+		if (unlikely(xdptxd->has_frags)) {
+			ds_cnt += xdptxdf->sinfo->nr_frags;
+			num_frags = xdptxdf->sinfo->nr_frags;
 			num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
 			/* Assuming MLX5_CAP_GEN(mdev, max_wqe_sz_sq) is big
 			 * enough to hold all fragments.
@@ -529,7 +536,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		dseg->lkey = sq->mkey_be;
 
 		for (i = 0; i < num_frags; i++) {
-			skb_frag_t *frag = &sinfo->frags[i];
+			skb_frag_t *frag = &xdptxdf->sinfo->frags[i];
 			dma_addr_t addr;
 
 			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
@@ -718,7 +725,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
-		struct mlx5e_xmit_data xdptxd;
+		struct mlx5e_xmit_data xdptxd = {};
 		struct mlx5e_xdp_info xdpi;
 		bool ret;
 
@@ -735,7 +742,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0);
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0);
 		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 8208692035f8..8e97c68d11f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -101,11 +101,9 @@ extern const struct xdp_metadata_ops mlx5e_xdp_metadata_ops;
 
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
-							  struct skb_shared_info *sinfo,
 							  int check_result));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 						    struct mlx5e_xmit_data *xdptxd,
-						    struct skb_shared_info *sinfo,
 						    int check_result));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 367a9505ca4f..b370a4daddfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -61,7 +61,6 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
 	struct xsk_buff_pool *pool = sq->xsk_pool;
-	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
 	bool work_done = true;
 	bool flush = false;
@@ -73,6 +72,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 						   mlx5e_xmit_xdp_frame_check_mpwqe,
 						   mlx5e_xmit_xdp_frame_check,
 						   sq);
+		struct mlx5e_xmit_data xdptxd = {};
 		struct xdp_desc desc;
 		bool ret;
 
@@ -97,7 +97,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd,
 				      check_result);
 		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
-- 
2.34.1

