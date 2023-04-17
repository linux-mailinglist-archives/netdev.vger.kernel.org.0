Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B36E4784
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjDQMVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjDQMVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7921D7D91
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQJMLM76DWNg0rjfOo85joBKYUVDeWXmD01wqtVGIoTKg/4MK6Odkep+eCsDioLigCnVgyCmi6OdG1PjKNSz6MMN/dbOFYA7/+Y/gh8yRAUFvw3i+ARxTFVKjjed420uTfDiSg21IUvla8BaPqhLrQ1xfccPAJaPIbSz7GB6u18Y5RgRsMrUuB0ELUvZ+WqbUDEJ2jutaZjR6Ts4uqM2WIXkuZMGyKqIkRPMpj6g6J1Ag9ed+MpC7fnYf/GMD813bORVfeaemZEyEd9cCibJibkf02V02bqGgepwdTRl72gbjScwxamfYh9bg4zyj6BbMttzNN5IrnIH12LXkHkKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwT0MMsRIomJoBM5ssorK67E1JZYgozP9H/1n9CM3x8=;
 b=DO6xcSmt7TNzkq239AdT4wtr9YO2QlHXdT9yGkX3AZB3f7Se2w5c5X/xOBCpcS221ATS86BudLUFv6AXc34QfkUVCx9ndCfPUCtKBnsVQ+F8+5b17h/C0yJ2L3XGVR26lPcqxUk19IlmU14wtU5MdsNgY0WaUyND4okKUBFgkwB9ZjXT3Phcg6LpyFMm42b0h4u2UXNlsijs73W1MRuIbuRqyIzEEAUIAFdW2guu8Yt6yOgdc+i8/Y213agoMkv5AkjjTD6VdDfruSMr3x8lXPdV/x7gwUAa+EoXQlBuxsTV/5LZjVdPfoSkn6VYIpjZTlzMGSDkwoFrXD82DDqt/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwT0MMsRIomJoBM5ssorK67E1JZYgozP9H/1n9CM3x8=;
 b=D0/ZH0E+3zHQ2q3RXGyAYWZHlZgrOXk6MypguTBZ82O4ywi7aS56hGt5Jb9ms9F3vJ8za8xSq+4d1aft7AoGRT05llsmGZxl7OtSS2KlHTQw7fBirmJCrcZjTa/cW6OHo8rYDADgODbmxOfGfQEYcRIG1rCKtdJWOFu1QUvy5zrUhbuUe+Jjwi8HZBOujNuF2Sg296YvMCL1HbcMTexVfhxDhITO/cpmEivC7noQQv3oPh8vak9vToRD4SVlSxnNbekwl9plkHvzmKrnhX/cHwleCkXLDhU9jg7qvnZijJA1G4/WpURspbkZFUXqBgYIibUaPOGZLrbXdkXhiYmVYQ==
Received: from DS7PR03CA0098.namprd03.prod.outlook.com (2603:10b6:5:3b7::13)
 by SJ1PR12MB6076.namprd12.prod.outlook.com (2603:10b6:a03:45d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:37 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::fb) by DS7PR03CA0098.outlook.office365.com
 (2603:10b6:5:3b7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Mon, 17 Apr 2023 12:20:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:24 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:20 -0700
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
Subject: [PATCH net-next 10/15] net/mlx5e: XDP, Remove un-established assumptions on XDP buffer
Date:   Mon, 17 Apr 2023 15:18:58 +0300
Message-ID: <20230417121903.46218-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|SJ1PR12MB6076:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b4dfb0-abf3-47de-661d-08db3f3e262e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcsSbfaG0kUx2dF5ynU+Dt3BBv2pamKFBedHShWAx6nnA5IVjD+6lxqbcipRJgDq2G6H4IzKJAjtBHSf4MLvwmboAvDPJObeqnFzqky4HPQCZHleAskhnz9u1ADz50SjN/7IeFzI68gQxj5PLtwELj/4zTU7RqTDFMXNcTnt2fOeOmWoR5K4MpPaBfoe96YKBnh5wO81hlHqtiR/rudVlbQtF8+uZ/wgYytC0cAJfHhr6xfM9+ZVBJnEP7EB8MPSX43OSXlmpXHC5/yc/V2lJ/90cxfabwYPIxfa5A+g2mKfY7oJDssPQQCKoEdB79Ny953Ckeyl8HzoQModkYdp7U1/my84dS+OsjrOIPvFarHSGhfVdE3sb5jrM3mHNztcOs8P1WcTBROU3SIYCJyhdbcEkmj80NNZ6K2k0YNRNCUTLwLX92qyoI6H8Z+dCMo1m9YS9yH48NN2DEu3ff5No6momWrEl5+OclDuXhXlpAh5BtERevZyaphG+ruYtbJO7P7Hi8aqXE5AhJY/xns9guPS5V+NL7RQGTCin+3BfNSrSDbUszo71w4xaR1tZyyhYZoH52g7mCIzxp5udLE7hz9oucgkIa28bozjA5OrNoqlBTn3o9XY21czj7VkrpkB1BWSIZEOJU5cpdjDqdh+INpsq9KopV5mHia+tsXAt3aul/8xFsmvNoxKCzi6pVdET9wtG9KYrC3js9CYSqd8T6tiCwtYKnc480DyXI7fb3HhtWD4qtr2Uk0161iiiUoYLMLonkXiT/rss690RIRJITfNYSpOV/6SnyZPIK6r50nW3eKlJFAJsTxnIOUP2v1i
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(7696005)(6666004)(86362001)(478600001)(110136005)(34020700004)(36860700001)(36756003)(2616005)(47076005)(426003)(336012)(83380400001)(107886003)(26005)(40480700001)(186003)(1076003)(40460700003)(82740400003)(82310400005)(7636003)(356005)(316002)(4326008)(70206006)(70586007)(2906002)(8676002)(8936002)(5660300002)(7416002)(41300700001)(54906003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:36.2748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b4dfb0-abf3-47de-661d-08db3f3e262e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6076
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the assumption of non-zero linear length in the XDP xmit
function, used to serve both internal XDP_TX operations as well as
redirected-in requests.

Do not apply the MLX5E_XDP_MIN_INLINE check unless necessary.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 36 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 ---
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c266d073e2f2..d89f934570ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -477,18 +477,26 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	u16 ds_cnt, inline_hdr_sz;
 	u8 num_wqebbs = 1;
 	int num_frags = 0;
+	bool inline_ok;
+	bool linear;
 	u16 pi;
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	if (unlikely(dma_len < MLX5E_XDP_MIN_INLINE || sq->hw_mtu < dma_len)) {
+	inline_ok = sq->min_inline_mode == MLX5_INLINE_MODE_NONE ||
+		dma_len >= MLX5E_XDP_MIN_INLINE;
+
+	if (unlikely(!inline_ok || sq->hw_mtu < dma_len)) {
 		stats->err++;
 		return false;
 	}
 
-	ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
+	inline_hdr_sz = 0;
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE)
-		ds_cnt++;
+		inline_hdr_sz = MLX5E_XDP_MIN_INLINE;
+
+	linear = !!(dma_len - inline_hdr_sz);
+	ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + linear + !!inline_hdr_sz;
 
 	/* check_result must be 0 if sinfo is passed. */
 	if (!check_result) {
@@ -517,22 +525,23 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	eseg = &wqe->eth;
 	dseg = wqe->data;
 
-	inline_hdr_sz = 0;
-
 	/* copy the inline part if required */
-	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
+	if (inline_hdr_sz) {
 		memcpy(eseg->inline_hdr.start, xdptxd->data, sizeof(eseg->inline_hdr.start));
 		memcpy(dseg, xdptxd->data + sizeof(eseg->inline_hdr.start),
-		       MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
-		dma_len  -= MLX5E_XDP_MIN_INLINE;
-		dma_addr += MLX5E_XDP_MIN_INLINE;
-		inline_hdr_sz = MLX5E_XDP_MIN_INLINE;
+		       inline_hdr_sz - sizeof(eseg->inline_hdr.start));
+		dma_len  -= inline_hdr_sz;
+		dma_addr += inline_hdr_sz;
 		dseg++;
 	}
 
 	/* write the dma part */
-	dseg->addr       = cpu_to_be64(dma_addr);
-	dseg->byte_count = cpu_to_be32(dma_len);
+	if (linear) {
+		dseg->addr       = cpu_to_be64(dma_addr);
+		dseg->byte_count = cpu_to_be32(dma_len);
+		dseg->lkey       = sq->mkey_be;
+		dseg++;
+	}
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
@@ -543,7 +552,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
 
 		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
-		dseg->lkey = sq->mkey_be;
 
 		for (i = 0; i < num_frags; i++) {
 			skb_frag_t *frag = &xdptxdf->sinfo->frags[i];
@@ -553,10 +561,10 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 				page_pool_get_dma_addr(skb_frag_page(frag)) +
 				skb_frag_off(frag);
 
-			dseg++;
 			dseg->addr = cpu_to_be64(addr);
 			dseg->byte_count = cpu_to_be32(skb_frag_size(frag));
 			dseg->lkey = sq->mkey_be;
+			dseg++;
 		}
 
 		cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6a278901b40b..a95ce206391b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1886,7 +1886,6 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 			struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(&sq->wq, i);
 			struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
 			struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
-			struct mlx5_wqe_data_seg *dseg;
 
 			sq->db.wqe_info[i] = (struct mlx5e_xdp_wqe_info) {
 				.num_wqebbs = 1,
@@ -1895,9 +1894,6 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 
 			cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 			eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
-
-			dseg = (struct mlx5_wqe_data_seg *)cseg + (ds_cnt - 1);
-			dseg->lkey = sq->mkey_be;
 		}
 	}
 
-- 
2.34.1

