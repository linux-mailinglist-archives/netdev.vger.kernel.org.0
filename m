Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90B6E477C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjDQMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQMUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604993EB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THRyRkUXONXnO4VG5DjWE/lRp0YSk9eG2I3Nyb9xA87jJOMQFYP15DFz+tdeLXCbWs8OKGiXkOiRUQqTgFIFY0qPoJxp3wAMQr+6B+mG+yd9H1qinEbWGoyweewWURZ8bwCVFSs0qdB5zV2HxrRzAbY8YlLSVUZKp8Opb9aVQHzrerhCoJkSlwFPM91ijuDMzK/37jGh+46cZsLLXYcOSfXKa+HRKaE/SFsgvBXXX18p9rQYpxexg+UQaCzhLfrFhsJ47DqZUV3dpFDbGc/Q1wbvmklqavVq60rY80k++cucpz/Lrs8/1DOIL1O298lZoZLC5tcy7GkOYIv2Pfv63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0T9zXb+L5ev63wZRt8khhfP9tUMO9bILmoVpjSD6YgI=;
 b=H5YupG+qEmzQl9c5824M33GA1fRZMLqasABQogRKpQlk2MIJEevS+NXLjn4mCHyR9piCsVQssieIfQs+r3al7XpJY+53HR0Br9F6E6OREjj70JX/HT/qQZU8tK8FRjbg6PXYVpL+NK60bBi1N5XCQnkvS6GnxwR0tsV8xmLGGfeKiioZ+yRlhnU7zDbipxDOenKsmQg+O290t5rqg0ttJ6GqpCnlenEWkSRrJpkxg6JEewVotsn1/HHQsAnUduJJQyzXIsCxW5hvamw5qX+m+hvboV/Vl1XJskO6tbxwQ4b+BRlYjqVTi8OF0v28ceyfry3KEclXJfRy7NDFD7iGyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T9zXb+L5ev63wZRt8khhfP9tUMO9bILmoVpjSD6YgI=;
 b=Qv7l2tBUgaWEO18nzkH2BMb3pqphVHKItd/YT0t9ZI2X/X7JXbyT8LjYrs05Q5CYnBirFmQBfR9fPZjYutCXdJh+imfXytDQemRJGG2lcra0t2qvWIfdBbPp6AKFf9y+SOBFXmuK68kT+qL8lzbKVoR+rnJtihoZw7hwGoHjraRcl7wM6akPX3wx8uLYX4VXcn6ZYi533Ep/r4kN/qVP+k3h4P5YhILQogg1lgICYtmQoO3Yitc5NIQsdktX8SVoH93VvMUZaH/2oNOLyZ1QF3wQWEyQJkdOnunyat43CHoq8t72g83MBpqe0tqTT1XIrdcx7RfXCqc/H1v3QaxslQ==
Received: from DS0PR17CA0009.namprd17.prod.outlook.com (2603:10b6:8:191::9) by
 CH3PR12MB9022.namprd12.prod.outlook.com (2603:10b6:610:171::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.49; Mon, 17 Apr 2023 12:20:13 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:191:cafe::6b) by DS0PR17CA0009.outlook.office365.com
 (2603:10b6:8:191::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:03 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:02 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:19:59 -0700
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
Subject: [PATCH net-next 04/15] net/mlx5e: XDP, Remove doubtful unlikely calls
Date:   Mon, 17 Apr 2023 15:18:52 +0300
Message-ID: <20230417121903.46218-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|CH3PR12MB9022:EE_
X-MS-Office365-Filtering-Correlation-Id: 761a7c7b-fa01-41d3-5cb3-08db3f3e1871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HsTBF3z4i43MnGeOXWXEvUWEwNCaYV1t3hMp4/8ACW+3naua11LjHwG8jSs+nI30BQu8eXxIqR7Q/i1A5OmK5TpZXT+4yT/FjBrq+G1nuCQrGoblqlVK1u/V2lgxbWk+j4s8VjWHaAmDXgioZsbGPpXaVir3fSY29jcnJR31appLO19BG329NPjOH0BbHRJKX53qg1tQyYVQQT/fR1l3SwN/u2a6dRoJl70CcnFa/xrd4WC0kvDQPKBunCfOmBUFjuK2GYTrhYxnfHDfesyNRT5ZIJxanSpWsVIKa5ZuTLUmZhhgK68Ittvifk1wUNnUhScB1PAvcbzd38nRtBlYLBCZRtOHOvPdIEN+QxE9unenQeNiN9BGJOJTTwArq2V97qU+91Lt1hpRDwceRXR7hxurQkfe3kLjFnHPrZ8Q69WrJNLA+bnqAEHblAzpbE40dSpdR9lZFUFcJUPTvCKNKmm4FhkkyXvdqO+Kdv+lqZAgLnksdjh/hB3uTwjtsB6ep5Da35lZBT+qu/5p3dMVoLXkj10WSB3pajaQCKUYrcTQwt9FHtvQRxNnfFEiBpYgnCk6FTF01NuM02hlOWggFu0Vlqs3hdohK73S2MzItRYXsPMt1lHlHibg0fVAKdGHpZkmiZTN+ftYR78QRLPO/VtC1JQVChZKlJZF0f04Bws16vPO3yc3ZE3fAv4c4gnuWrGFfydKS3N3jllwJTR90OOwQ9xAsTl6QgZKWtFZDuZHJJpMnxkLZzy0jLSoIsRygvz8LU6ObwcdXl1oPXRJSPe0naVriOnsoLyji5mjSiU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(41300700001)(356005)(7636003)(82740400003)(8676002)(70586007)(70206006)(4326008)(5660300002)(86362001)(40480700001)(36756003)(8936002)(7416002)(82310400005)(40460700003)(110136005)(186003)(7696005)(336012)(426003)(47076005)(83380400001)(316002)(2616005)(478600001)(2906002)(54906003)(26005)(1076003)(6666004)(107886003)(36860700001)(34020700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:13.2099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 761a7c7b-fa01-41d3-5cb3-08db3f3e1871
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9022
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not likely nor unlikely that the xdp buff has fragments, it
depends on the program loaded and size of the packet received.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 3e7ebf0f0f01..dcae2d4e2c03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -126,7 +126,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
 	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd->len, DMA_BIDIRECTIONAL);
 
-	if (unlikely(xdptxd->has_frags)) {
+	if (xdptxd->has_frags) {
 		xdptxdf.sinfo = xdp_get_shared_info_from_frame(xdpf);
 
 		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
@@ -151,7 +151,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	xdpi.page.page = page;
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 
-	if (unlikely(xdptxd->has_frags)) {
+	if (xdptxd->has_frags) {
 		for (i = 0; i < xdptxdf.sinfo->nr_frags; i++) {
 			skb_frag_t *frag = &xdptxdf.sinfo->frags[i];
 
@@ -395,7 +395,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	if (unlikely(xdptxd->has_frags)) {
+	if (xdptxd->has_frags) {
 		/* MPWQE is enabled, but a multi-buffer packet is queued for
 		 * transmission. MPWQE can't send fragmented packets, so close
 		 * the current session and fall back to a regular WQE.
@@ -483,7 +483,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	if (!check_result) {
 		int stop_room = 1;
 
-		if (unlikely(xdptxd->has_frags)) {
+		if (xdptxd->has_frags) {
 			ds_cnt += xdptxdf->sinfo->nr_frags;
 			num_frags = xdptxdf->sinfo->nr_frags;
 			num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
@@ -525,7 +525,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
-	if (unlikely(test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state))) {
+	if (test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
 		u8 num_pkts = 1 + num_frags;
 		int i;
 
-- 
2.34.1

