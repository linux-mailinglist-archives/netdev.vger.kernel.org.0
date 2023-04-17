Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368CE6E4787
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjDQMVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjDQMV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACD793EB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8KuqWJjYKeC584zTfbIvbTDRZ042UxflZXkDLucJOb/re2zgUhYizcQ63FLZ5VlIJw64mkn+zAeI4DYPu59KGBf7XgEoB+FCpk5Jpj7VP0C24EbU4E8fMqfijOqLAe8xg0e1kkqowhP5YpiXnp5Whv4n25dMwLF6ngzbQigRBEZKZ7ku82XZPMt0dojY43bDN1nAmPosJKxPbCtwNahglIHDxl2HUTW9CR7EtKJE876IttcfxiYzoZrAT7s2YBtMi5uhsZqztqVQ3sjzjrEeCdDnu26Ovr0Wl5Jni/fZNCQ6dQK6Cnpq95qiZjjStOinpahq9riTn89HhMFesfG0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LrxrrSUppEW5BR6DvZ5UaYfEY/F6nRauGTQYep4c9w=;
 b=MhWC5j6B0tVNNJBbStJfaBn/rHAV0puk2sE8XX5G3f1O0YC8Q0LtPq5JiNvjwrGmaaY15wBxWxGu9iKnrR2b3H4iYYLbWbbbla/Np5QmGSGvlknr6i+2qJwa97YcNaqFxH+FsKXXSuRPim3AsOhHp+aem6pUKuXAUfKSsPWV/3RmX81Rnnl6ZuqFyoaQwS1g3xXtJMD77cBrVO+y2zExlpZ32v7n0LsG1n7CXjkCFApQDUZCNIJMK//XYYJIDUztR+k3qUMgW4+AUfIIq/8tna70J+AFbKZJOuKaJc3OszpjvlGSe6Bm72TMCHdyazUPlCqn4rvdXa+jqAAZPZSN7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LrxrrSUppEW5BR6DvZ5UaYfEY/F6nRauGTQYep4c9w=;
 b=lVBygfOzNLExqCc9z9ENQMyyfygSgZ+tbnw0JdpDmEM/zLpJeq9HLkMw5YSky5GSG6l59XIaKYGbg12V589NfC8qmKJObvVyd4NrrcFMgAcFHyLeZJpIPyBG3FNOZ/a8W05h3b4vi0mWUa1TPW171uVy3lICVxDMvfF++C4a9Cf/MlV30tlAwlxOOxW92bJz7UQABOFPWWe2PYgFXNmLkpan+zP7Wd3S7Enx3VFWvQQawN9a3GwOdirW2OfH1n2nrVKf0CGW6wg4gsD2xeRWMr0LVlMsE5JlKmihQaantYv0S5dEx3WnVednYUeTNcgpWP7q3eH1aJjrmsTeOs/bsg==
Received: from BN0PR04CA0208.namprd04.prod.outlook.com (2603:10b6:408:e9::33)
 by SN7PR12MB8147.namprd12.prod.outlook.com (2603:10b6:806:32e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 12:20:49 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::81) by BN0PR04CA0208.outlook.office365.com
 (2603:10b6:408:e9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:31 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:28 -0700
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
Subject: [PATCH net-next 12/15] net/mlx5e: RX, Take shared info fragment addition into a function
Date:   Mon, 17 Apr 2023 15:19:00 +0300
Message-ID: <20230417121903.46218-13-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT019:EE_|SN7PR12MB8147:EE_
X-MS-Office365-Filtering-Correlation-Id: f0454229-d6ea-4d8c-17ff-08db3f3e2df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYWieRwPWl0daoqHhFRfixD2W2LOfSFHbI7j1hZ50iFSOgUWx260p6DsBR/a3vSA0O7kQU+Rja1pvfcGpXJ0VMlG7T3kSI3dttdnBG3t0o0tZL3HECfBWVgS5ITwmJLpVDaH67lYmBYWlEz7g7eSIrafD3C2ghVEaXH+3eZZjMLTu+aHy5RAhbRGwSwVFrplkNRXdgwJrYs4ZjwIhD8qIjyJSc+X89qE/60IOh49SqmMVxDoJ0wxW67LawAqFQ6CKd1L5/+tXEdwNCCp78t0nE8TQN0VWQ4RgEg0HRlQfPUsQO9yKwUH1hSoc3ZYJF6arBwMyocmAKoksGuQC/cVkcrmowV+kaq+QK02G4E36vvNKugnjZrpNbBiNa1AVQz6sfPktAcR+WENquAA9j9aumNVEfJr2UPxWalnkfGhvolyghwAzF3VCw5HchN2+iSw6cAYGjpq175fj4LCc/D2FBGZRSC1mmWR4DwRBwxeBGIOe+8X/33pk7Veaq+l6NPoJPLpNnFCqvGkHmAoUEi8eNTr4nGh473ciMGzwrQul4IhKFMDQpZ2NR8/lbKh444kaYMQri77hnTxkoMOrErmgXcwZSatNXetLpFXCoXtaJFKTQOvJlLGH2eUXlKHcKJcu67GC4tZ6vzXAdjJjFjrKwIE9gRDleYFoJkA6fMW8AHe/hTGBDPIJgWB0t0407j+V6rEEvGNAyDMKbJLgSYvcKtKR8X+JXmAAB66QQAplxTQ67QMUOkYKFhg7crqI9CEJ32gE1tukADcKxYEoe+WFQPJ/lf7vnC2GkJHe4Q4ioU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199021)(40470700004)(36840700001)(46966006)(316002)(4326008)(82740400003)(70206006)(70586007)(34020700004)(5660300002)(2616005)(336012)(426003)(47076005)(82310400005)(6666004)(7696005)(36756003)(86362001)(41300700001)(40460700003)(107886003)(54906003)(40480700001)(1076003)(26005)(186003)(2906002)(8676002)(83380400001)(7416002)(8936002)(36860700001)(478600001)(356005)(7636003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:49.2323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0454229-d6ea-4d8c-17ff-08db3f3e2df1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8147
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mlx5e_add_skb_shared_info_frag(), a function dedicated for
adding a fragment into a struct skb_shared_info object.

Use it in the Legacy RQ flow. Similar usage will be added in a
downstream patch by the corresponding Striding RQ flow.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 56 ++++++++++---------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1049805571c6..1118327f6467 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -471,6 +471,35 @@ static int mlx5e_refill_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 	return i;
 }
 
+static void
+mlx5e_add_skb_shared_info_frag(struct mlx5e_rq *rq, struct skb_shared_info *sinfo,
+			       struct xdp_buff *xdp, struct mlx5e_frag_page *frag_page,
+			       u32 frag_offset, u32 len)
+{
+	skb_frag_t *frag;
+
+	dma_addr_t addr = page_pool_get_dma_addr(frag_page->page);
+
+	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len, rq->buff.map_dir);
+	if (!xdp_buff_has_frags(xdp)) {
+		/* Init on the first fragment to avoid cold cache access
+		 * when possible.
+		 */
+		sinfo->nr_frags = 0;
+		sinfo->xdp_frags_size = 0;
+		xdp_buff_set_frags_flag(xdp);
+	}
+
+	frag = &sinfo->frags[sinfo->nr_frags++];
+	__skb_frag_set_page(frag, frag_page->page);
+	skb_frag_off_set(frag, frag_offset);
+	skb_frag_size_set(frag, len);
+
+	if (page_is_pfmemalloc(frag_page->page))
+		xdp_buff_set_frag_pfmemalloc(xdp);
+	sinfo->xdp_frags_size += len;
+}
+
 static inline void
 mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   struct page *page, u32 frag_offset, u32 len,
@@ -1694,35 +1723,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	wi++;
 
 	while (cqe_bcnt) {
-		skb_frag_t *frag;
-
 		frag_page = wi->frag_page;
 
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		addr = page_pool_get_dma_addr(frag_page->page);
-		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
-					frag_consumed_bytes, rq->buff.map_dir);
-
-		if (!xdp_buff_has_frags(&mxbuf.xdp)) {
-			/* Init on the first fragment to avoid cold cache access
-			 * when possible.
-			 */
-			sinfo->nr_frags = 0;
-			sinfo->xdp_frags_size = 0;
-			xdp_buff_set_frags_flag(&mxbuf.xdp);
-		}
-
-		frag = &sinfo->frags[sinfo->nr_frags++];
-
-		__skb_frag_set_page(frag, frag_page->page);
-		skb_frag_off_set(frag, wi->offset);
-		skb_frag_size_set(frag, frag_consumed_bytes);
-
-		if (page_is_pfmemalloc(frag_page->page))
-			xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
-
-		sinfo->xdp_frags_size += frag_consumed_bytes;
+		mlx5e_add_skb_shared_info_frag(rq, sinfo, &mxbuf.xdp, frag_page,
+					       wi->offset, frag_consumed_bytes);
 		truesize += frag_info->frag_stride;
 
 		cqe_bcnt -= frag_consumed_bytes;
-- 
2.34.1

