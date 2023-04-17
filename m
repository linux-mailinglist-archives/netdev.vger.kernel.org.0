Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593CE6E4775
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDQMUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjDQMUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761428A74
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/X8CToPTA5FjfyU0f13JnNx5Ewf7DAI2+qMQZVNbzZppvkLdFbgwJEs/fTu9qMbRx1qJ4HeGywWf2HntwsU1HYSwxSwKP6QVz7RIp30DGl9PE40nPgrULZWXpUrp5ibhjng1U9xOGvDhc1nSjPdTQUeBqUtq8knMCNYD3blrRf4tM8NUnDpCqVZcBb1PdUnE1J+7vBsSc6XebKdmI8NYopjhGBr5VuLQEa4/hy1qb2lj9NUSVyTblSzw1QloRjput8EPS8Ssk++8vCOS5U4V3ZQVf1DO3eTcF6ChIyFqCoreE+T5X6Snua9QvZhO1W3HuNLUsA6kn8V6Jj8DT5Mww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1nHro+SIGGfK26WM+xW3wCwE1L5olwZQ6ctdD+gLOQ=;
 b=QGOvn6MhlKZMJ4kkrcVoMYbxNPX9ayErRlnr5ZsgMmuJAWEefWXE4uN4g+PNfS5Va3svsQWBazQPwo0wHo2i9ZldU8NA4RIDogLzw4SH1VYmAAr2DIwQpcDG8g1Jjn96s8/GBnKQt6IgRRv9cNsElj1TKzrcpvvTqm30t6NMmnoeSEnEKnNaV3IEmTYUq5LUGqSokwyIErLAxWbRk9D99fX7DoZw/k7oSyZJkXo2qXxomwHOv4F9Tcr6uK6aci8OdeXQZCR1JxTEok4KIP/6zu8wveJsJok/zm10VGAsdi0KVrcKL25gsgQEmaKqrjgrryMvGwOdC+8b3HyHApS7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1nHro+SIGGfK26WM+xW3wCwE1L5olwZQ6ctdD+gLOQ=;
 b=Qdg7FdxEpbGcs7uC78FD8LM+INiT0vg3pMQujLReovZOirtD2Md/znxEkRzPAOQa31ywPMfu8FQxbdvhGt8TmorhK5hPzeT98b4f3GizTDx0+jVCkrF8sOW16qR1ieOrVVmgjSVZfSc0gJHnwAsQ4xOpg89pJ7gpZbyuGc771/SQDSSizoKycJcWluzEDuNMn/tJkheVU/eWe9Q2R5gS+BNxf++DapPBIP1nGIoGfGTQQbqeXTA4IbqwUXH73kpl5jmh+lL+BEVWUuf0GUBVJ0k57r7BXcD2ITpsnx0+IWVZbEMOJkIFD6Yo46KMmRml0+66GxoQu/VLqHMoOwwR6w==
Received: from BN9PR03CA0878.namprd03.prod.outlook.com (2603:10b6:408:13c::13)
 by DM6PR12MB4332.namprd12.prod.outlook.com (2603:10b6:5:21e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:07 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::ce) by BN9PR03CA0878.outlook.office365.com
 (2603:10b6:408:13c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:19:51 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:19:50 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:19:47 -0700
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
Subject: [PATCH net-next 01/15] net/mlx5e: Move XDP struct and enum to XDP header
Date:   Mon, 17 Apr 2023 15:18:49 +0300
Message-ID: <20230417121903.46218-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|DM6PR12MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8435ef-7813-4c9e-f702-08db3f3e1469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HDY32wRGMah5B/CMw08TmBLQICoY7AQshKUhy3D+h+NUFVVwETk5CgfPcpoFjXfRxgm5s3uoGaqHq56hph+tG2MLWTt1p+Jf+Xurp6JnyajdNCfxStd16Z6xUOVIb6554oKNBQXYr7oUT0i6Z/17AOZeNs0U1VR2glbt45VZW5zVkD/kdA8bgVDwYyJyLSsB+NxCAN+6ctw3SJPXj3TCv/PtNoS8fL6Dh4VgawQDOELYpW2lqOyP3zLwkT/qpzdilBln4n1ThE05l8vGzSHsRjMPkEQ8cQNIq9M8voisAnLDTesApziUXYdZWPSTNzkdVNhPYsdqn1NXWh5enuvFOyf9UpogfERgOjdmW7WWgHqYeLV26CgtjkcGZpItz9jMptgge0Cxjp4OP3n9pC4HCNJasQhHAIEaCws3apkNTTrVFIJA66WVKPBXlLIwxe54bgm1XLucbOpXXU50Nlv1F/S6VLhKnqkudn0UKezRi0C01zCI9FLiVvETFCGD1T1cvJKZDVfk0/pLAnexalQFV2TQNDSjqGYsvKcu+ZvfuUSb9TgMAgrvVtD3nYIu12eGMzBjzt/AaVaLudCEjmFhfOTXs9Zw0Rhntu+cmUfNKqMkZYDw4hG1qmAT3kfmPWbat9W1TZSE4q9e5GWa5aiZLup/t1UOBBoSptsueIHg0vvVjN8dvTsRCmPCilC2+qKlhghFY4AJuIbz7rfIhGhPmd606PuXsJ9uPOpEvm0Bqy1FS8xxs/364SHYyMTxdPImowGmNM5c6EtX6Shf0osPxVfPSU/hQ3m2n1xt57JC70=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(36756003)(7416002)(40460700003)(82310400005)(2906002)(5660300002)(7636003)(8936002)(8676002)(356005)(41300700001)(40480700001)(86362001)(478600001)(34020700004)(54906003)(2616005)(110136005)(36860700001)(26005)(1076003)(107886003)(186003)(7696005)(336012)(4326008)(426003)(70206006)(70586007)(82740400003)(316002)(83380400001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:06.3412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8435ef-7813-4c9e-f702-08db3f3e1469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4332
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move struct mlx5e_xdp_info and enum mlx5e_xdp_xmit_mode from the generic
en.h to the XDP header, where they belong.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 35 -------------------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 35 +++++++++++++++++++
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ba615b74bb8e..3f5463d42a1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -475,41 +475,6 @@ struct mlx5e_txqsq {
 	cqe_ts_to_ns               ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
-/* XDP packets can be transmitted in different ways. On completion, we need to
- * distinguish between them to clean up things in a proper way.
- */
-enum mlx5e_xdp_xmit_mode {
-	/* An xdp_frame was transmitted due to either XDP_REDIRECT from another
-	 * device or XDP_TX from an XSK RQ. The frame has to be unmapped and
-	 * returned.
-	 */
-	MLX5E_XDP_XMIT_MODE_FRAME,
-
-	/* The xdp_frame was created in place as a result of XDP_TX from a
-	 * regular RQ. No DMA remapping happened, and the page belongs to us.
-	 */
-	MLX5E_XDP_XMIT_MODE_PAGE,
-
-	/* No xdp_frame was created at all, the transmit happened from a UMEM
-	 * page. The UMEM Completion Ring producer pointer has to be increased.
-	 */
-	MLX5E_XDP_XMIT_MODE_XSK,
-};
-
-struct mlx5e_xdp_info {
-	enum mlx5e_xdp_xmit_mode mode;
-	union {
-		struct {
-			struct xdp_frame *xdpf;
-			dma_addr_t dma_addr;
-		} frame;
-		struct {
-			struct mlx5e_rq *rq;
-			struct page *page;
-		} page;
-	};
-};
-
 struct mlx5e_xmit_data {
 	dma_addr_t  dma_addr;
 	void       *data;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 10bcfa6f88c1..8208692035f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -50,6 +50,41 @@ struct mlx5e_xdp_buff {
 	struct mlx5e_rq *rq;
 };
 
+/* XDP packets can be transmitted in different ways. On completion, we need to
+ * distinguish between them to clean up things in a proper way.
+ */
+enum mlx5e_xdp_xmit_mode {
+	/* An xdp_frame was transmitted due to either XDP_REDIRECT from another
+	 * device or XDP_TX from an XSK RQ. The frame has to be unmapped and
+	 * returned.
+	 */
+	MLX5E_XDP_XMIT_MODE_FRAME,
+
+	/* The xdp_frame was created in place as a result of XDP_TX from a
+	 * regular RQ. No DMA remapping happened, and the page belongs to us.
+	 */
+	MLX5E_XDP_XMIT_MODE_PAGE,
+
+	/* No xdp_frame was created at all, the transmit happened from a UMEM
+	 * page. The UMEM Completion Ring producer pointer has to be increased.
+	 */
+	MLX5E_XDP_XMIT_MODE_XSK,
+};
+
+struct mlx5e_xdp_info {
+	enum mlx5e_xdp_xmit_mode mode;
+	union {
+		struct {
+			struct xdp_frame *xdpf;
+			dma_addr_t dma_addr;
+		} frame;
+		struct {
+			struct mlx5e_rq *rq;
+			struct page *page;
+		} page;
+	};
+};
+
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
-- 
2.34.1

