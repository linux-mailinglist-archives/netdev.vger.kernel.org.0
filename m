Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A330868A40F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjBCVCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjBCVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:02:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DAFAC20D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:00:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksriJ3g9OkqODCA21ZtazL1bn7H0kx9QIXC9/wvLwraZuwYDhVXuaQIBEK/fT4m0jF7PKxQmftsFAT4H8Xes1ZWpU3N3WPlZbRLc2SXUJagg3sv2LC1NOJsncZCBjcZW+S+2JrLWcx6jNGkopg+NJnOn0B9xiwJcDFDa1rTewQNrrSiDaCGu68Imu4pUC/g+/XpYGqn37tfsSTkyiTDqULMypEDoOx7iVYgUjB5ELs/iJB8cqg59NR9gJFpC5tzfQwhXQvqP3cVJuntX/K5uCXm/wRQ4kksIXXPfh5zFbCTKCeSirnJ58w20ttHR8iVWv6DzPC7qq4Q5/M9/SZRSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tzps48pm44Yc/d991BjcqwVhtbOaIPBDQsshTjjIl9g=;
 b=Q+ZHMSia2KNWxSiAOgq9HoqcBtHy8g2EmVdbcIQW5cmg9ZY5bK4PNyJ3MKLF1qypp+WxCIqmW4FnifAAbsThdvASEgRW9faDZ3pT+hpRxaSIY+lCNEe4V51T/RJbsaqiMFDYR7WQkp17CasId+p+rwW9jusKH8OipwPdI5AlsrU7ds6BqiLdsGjxd7Bz9jBfk7V5OG4BYrN9B3O9h7UPc/Jky6j/gJEkHSAWVWLG4RR/09wycHrErQVGrjUCGj8oCZmozngpoHhgWYmby8lpW8C7dW+g9UnyO6m0sG46xCDTJadexc8/sGSqA5UOkhoaYpdaiZ0u3thrV9DrSVCu4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tzps48pm44Yc/d991BjcqwVhtbOaIPBDQsshTjjIl9g=;
 b=Im4mU1PloftjgTeIlZ6/OMlQ25tSWl5oFVFdg12LEH+dCQHXbyjPRA49uEnfbNrqocsRKVZ2nvjqflVaddzlVBCUpAiI0FQv6WSpdlJj28TUTkvwJ1I61omokhU22gLoPN9jFRrEc6f5cvuhvHFzCeEPYLb5nPe8WGqUAeOKcx0=
Received: from DS7PR05CA0024.namprd05.prod.outlook.com (2603:10b6:5:3b9::29)
 by PH7PR12MB5808.namprd12.prod.outlook.com (2603:10b6:510:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Fri, 3 Feb
 2023 21:00:43 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::17) by DS7PR05CA0024.outlook.office365.com
 (2603:10b6:5:3b9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7 via Frontend
 Transport; Fri, 3 Feb 2023 21:00:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.31 via Frontend Transport; Fri, 3 Feb 2023 21:00:42 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 3 Feb
 2023 15:00:41 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Neel Patel <neel.patel@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 4/4] ionic: page cache for rx buffers
Date:   Fri, 3 Feb 2023 13:00:16 -0800
Message-ID: <20230203210016.36606-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230203210016.36606-1-shannon.nelson@amd.com>
References: <20230203210016.36606-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|PH7PR12MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 1866fc64-4139-44f5-03a0-08db0629b664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLpGl2NO+CCllL8cdqcwDQayXkRBWtX+2oHl+qtacWs2S+VjhDsxScUBkCUMS53d/BLzAsiSQywIs/yWYC0YkU51KeyXhlMackL4tD1JyTqeHEwogO5rrmtyOhzozniQN4IR26n00tBgG4oL30UW3fBzD4FrvF7Dz0NUhM25SGDR98fgp6cupZXmrRSJJkFxZqrlOu0k2G9DY85fVYh07ZZy3+887DV976GtIq5xYdckeq4tJTu9HjMtjcegTfYPccyXYt12ArFyW2IAQG69NK6GT59zZqLhdB+DwNjSBRwfeyZo4RdjHD79j3ONj4u+hYGyyFKheR/aNAhihfbicGH/R4jnKIvKsaU2LtqXaZv//nlJFQcl1DbloCOIQ/nt2fs8DrtNjH69m66PYI5GL4UZypU5/dRWTh8+QforJ9zHLscmZFVsqIgWGl6QZXsxOyx3+X9yphAedAwLasSJAZOCBRDzSB84Dzm66uiie62bV9qHU6N/9PssYUj3yvlTx24TECFRY9pJuhZVXtXMEFnjaK3Y8EJAyp9VgX7d/8kEn3IC04fsXYN7QBiH5/t+bbPIVE0UKBivnDfjGO9JKv3SbCc5/l1LCYBk1XOZSfUntGPk5co4FUxfXETMDACkqBmxYidoiHguyBVlwGeIQQzJYnaCkZBUEwPHM398ago7G+93FMZ8EEDQ2K+yfxIc7dPCO4QUq1a1JkCspv+iXpgcZg3d/b+Zeup5O6xDROM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(30864003)(4326008)(44832011)(5660300002)(8936002)(41300700001)(2906002)(70586007)(70206006)(8676002)(83380400001)(316002)(40460700003)(40480700001)(36756003)(6666004)(478600001)(1076003)(26005)(82310400005)(186003)(16526019)(86362001)(110136005)(81166007)(47076005)(336012)(2616005)(82740400003)(54906003)(356005)(36860700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 21:00:42.5709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1866fc64-4139-44f5-03a0-08db0629b664
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5808
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neel Patel <neel.patel@amd.com>

Use a local page cache to optimize page allocation & dma mapping.

Signed-off-by: Neel Patel <neel.patel@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  16 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   8 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |   8 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 296 ++++++++++++------
 4 files changed, 222 insertions(+), 106 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index a4a8802f3771..02c1bb9eb32f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -15,7 +15,7 @@
 #define IONIC_MAX_RX_DESC		16384
 #define IONIC_MIN_TXRX_DESC		64
 #define IONIC_DEF_TXRX_DESC		4096
-#define IONIC_RX_FILL_THRESHOLD		16
+#define IONIC_RX_FILL_THRESHOLD		64
 #define IONIC_RX_FILL_DIV		8
 #define IONIC_LIFS_MAX			1024
 #define IONIC_WATCHDOG_SECS		5
@@ -181,8 +181,9 @@ typedef void (*ionic_desc_cb)(struct ionic_queue *q,
 			      struct ionic_desc_info *desc_info,
 			      struct ionic_cq_info *cq_info, void *cb_arg);
 
-#define IONIC_PAGE_SIZE				PAGE_SIZE
-#define IONIC_PAGE_SPLIT_SZ			(PAGE_SIZE / 2)
+#define IONIC_PAGE_ORDER			0
+#define IONIC_PAGE_SIZE				(PAGE_SIZE << IONIC_PAGE_ORDER)
+#define IONIC_PAGE_SPLIT_SZ			(PAGE_SIZE / 4)
 #define IONIC_PAGE_GFP_MASK			(GFP_ATOMIC | __GFP_NOWARN |\
 						 __GFP_COMP | __GFP_MEMALLOC)
 
@@ -193,6 +194,14 @@ struct ionic_buf_info {
 	u32 len;
 };
 
+#define IONIC_PAGE_CACHE_SIZE          2048
+
+struct ionic_page_cache {
+	u32 head;
+	u32 tail;
+	struct ionic_buf_info ring[IONIC_PAGE_CACHE_SIZE];
+} ____cacheline_aligned_in_smp;
+
 #define IONIC_MAX_FRAGS			(1 + IONIC_TX_MAX_SG_ELEMS_V1)
 
 struct ionic_desc_info {
@@ -251,6 +260,7 @@ struct ionic_queue {
 	unsigned int desc_size;
 	unsigned int sg_desc_size;
 	unsigned int pid;
+	struct ionic_page_cache page_cache;
 	char name[IONIC_QUEUE_NAME_MAX_SZ];
 } ____cacheline_aligned_in_smp;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5425a8983ae0..892462b07e40 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -51,6 +51,14 @@ struct ionic_rx_stats {
 	u64 alloc_err;
 	u64 hwstamp_valid;
 	u64 hwstamp_invalid;
+	u64 cache_full;
+	u64 cache_empty;
+	u64 cache_busy;
+	u64 cache_get;
+	u64 cache_put;
+	u64 buf_reused;
+	u64 buf_exhausted;
+	u64 buf_not_reusable;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 9859a4432985..5c3dc6a4aff4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -149,6 +149,14 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(hwstamp_invalid),
 	IONIC_RX_STAT_DESC(dropped),
 	IONIC_RX_STAT_DESC(vlan_stripped),
+	IONIC_RX_STAT_DESC(cache_full),
+	IONIC_RX_STAT_DESC(cache_empty),
+	IONIC_RX_STAT_DESC(cache_busy),
+	IONIC_RX_STAT_DESC(cache_get),
+	IONIC_RX_STAT_DESC(cache_put),
+	IONIC_RX_STAT_DESC(buf_exhausted),
+	IONIC_RX_STAT_DESC(buf_not_reusable),
+	IONIC_RX_STAT_DESC(buf_reused),
 };
 
 #define IONIC_NUM_LIF_STATS ARRAY_SIZE(ionic_lif_stats_desc)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0cb464931d3d..bd4f8873edc9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -5,6 +5,7 @@
 #include <linux/ipv6.h>
 #include <linux/if_vlan.h>
 #include <net/ip6_checksum.h>
+#include <linux/skbuff.h>
 
 #include "ionic.h"
 #include "ionic_lif.h"
@@ -27,14 +28,143 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
 }
 
-static int ionic_rx_page_alloc(struct ionic_queue *q,
+static void *ionic_rx_buf_va(struct ionic_buf_info *buf_info)
+{
+	return page_address(buf_info->page) + buf_info->page_offset;
+}
+
+static dma_addr_t ionic_rx_buf_pa(struct ionic_buf_info *buf_info)
+{
+	return buf_info->dma_addr + buf_info->page_offset;
+}
+
+static unsigned int ionic_rx_buf_size(struct ionic_buf_info *buf_info)
+{
+	return IONIC_PAGE_SIZE - buf_info->page_offset;
+}
+
+static bool ionic_rx_cache_put(struct ionic_queue *q,
+			       struct ionic_buf_info *buf_info)
+{
+	struct ionic_page_cache *cache = &q->page_cache;
+	struct ionic_rx_stats *stats = q_to_rx_stats(q);
+	u32 tail_next;
+
+	tail_next = (cache->tail + 1) & (IONIC_PAGE_CACHE_SIZE - 1);
+	if (tail_next == cache->head) {
+		stats->cache_full++;
+		return false;
+	}
+
+	get_page(buf_info->page);
+
+	cache->ring[cache->tail] = *buf_info;
+	cache->tail = tail_next;
+	stats->cache_put++;
+
+	return true;
+}
+
+static bool ionic_rx_cache_get(struct ionic_queue *q,
 			       struct ionic_buf_info *buf_info)
+{
+	struct ionic_page_cache *cache = &q->page_cache;
+	struct ionic_rx_stats *stats = q_to_rx_stats(q);
+
+	if (unlikely(cache->head == cache->tail)) {
+		stats->cache_empty++;
+		return false;
+	}
+
+	if (page_ref_count(cache->ring[cache->head].page) != 1) {
+		stats->cache_busy++;
+		return false;
+	}
+
+	*buf_info = cache->ring[cache->head];
+	cache->head = (cache->head + 1) & (IONIC_PAGE_CACHE_SIZE - 1);
+	stats->cache_get++;
+
+	dma_sync_single_for_device(q->dev, buf_info->dma_addr,
+				   IONIC_PAGE_SIZE,
+				   DMA_FROM_DEVICE);
+
+	return true;
+}
+
+static void ionic_rx_cache_drain(struct ionic_queue *q)
+{
+	struct ionic_page_cache *cache = &q->page_cache;
+	struct ionic_rx_stats *stats = q_to_rx_stats(q);
+	struct ionic_buf_info *buf_info;
+
+	while (cache->head != cache->tail) {
+		buf_info = &cache->ring[cache->head];
+		dma_unmap_page(q->dev, buf_info->dma_addr, IONIC_PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+		put_page(buf_info->page);
+		cache->head = (cache->head + 1) & (IONIC_PAGE_CACHE_SIZE - 1);
+	}
+
+	cache->head = 0;
+	cache->tail = 0;
+	stats->cache_empty = 0;
+	stats->cache_busy = 0;
+	stats->cache_get = 0;
+	stats->cache_put = 0;
+	stats->cache_full = 0;
+}
+
+static bool ionic_rx_buf_reuse(struct ionic_queue *q,
+			       struct ionic_buf_info *buf_info, u32 used)
+{
+	struct ionic_rx_stats *stats = q_to_rx_stats(q);
+	u32 size;
+
+	if (!dev_page_is_reusable(buf_info->page)) {
+		stats->buf_not_reusable++;
+		return false;
+	}
+
+	size = ALIGN(used, IONIC_PAGE_SPLIT_SZ);
+	buf_info->page_offset += size;
+	if (buf_info->page_offset >= IONIC_PAGE_SIZE) {
+		buf_info->page_offset = 0;
+		stats->buf_exhausted++;
+		return false;
+	}
+
+	stats->buf_reused++;
+
+	get_page(buf_info->page);
+
+	return true;
+}
+
+static void ionic_rx_buf_complete(struct ionic_queue *q,
+				  struct ionic_buf_info *buf_info, u32 used)
+{
+	if (ionic_rx_buf_reuse(q, buf_info, used))
+		return;
+
+	if (!ionic_rx_cache_put(q, buf_info))
+		dma_unmap_page_attrs(q->dev, buf_info->dma_addr, IONIC_PAGE_SIZE,
+				     DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+
+	buf_info->page = NULL;
+}
+
+static inline int ionic_rx_page_alloc(struct ionic_queue *q,
+				      struct ionic_buf_info *buf_info)
 {
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_rx_stats *stats;
 	struct device *dev;
 	struct page *page;
 
+	if (ionic_rx_cache_get(q, buf_info))
+		return 0;
+
 	dev = q->dev;
 	stats = q_to_rx_stats(q);
 
@@ -44,7 +174,7 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
 		return -EINVAL;
 	}
 
-	page = alloc_pages(IONIC_PAGE_GFP_MASK, 0);
+	page = alloc_pages_node(dev_to_node(dev), IONIC_PAGE_GFP_MASK, IONIC_PAGE_ORDER);
 	if (unlikely(!page)) {
 		net_err_ratelimited("%s: %s page alloc failed\n",
 				    netdev->name, q->name);
@@ -55,7 +185,7 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
 	buf_info->dma_addr = dma_map_page(dev, page, 0,
 					  IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, buf_info->dma_addr))) {
-		__free_pages(page, 0);
+		__free_pages(page, IONIC_PAGE_ORDER);
 		net_err_ratelimited("%s: %s dma map failed\n",
 				    netdev->name, q->name);
 		stats->dma_map_err++;
@@ -84,36 +214,30 @@ static void ionic_rx_page_free(struct ionic_queue *q,
 		return;
 
 	dma_unmap_page(dev, buf_info->dma_addr, IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
-	__free_pages(buf_info->page, 0);
+	__free_pages(buf_info->page, IONIC_PAGE_ORDER);
 	buf_info->page = NULL;
 }
 
-static bool ionic_rx_buf_recycle(struct ionic_queue *q,
-				 struct ionic_buf_info *buf_info, u32 used)
+static void ionic_rx_add_skb_frag(struct ionic_queue *q,
+				  struct sk_buff *skb,
+				  struct ionic_buf_info *buf_info,
+				  u32 off, u32 len)
 {
-	u32 size;
-
-	/* don't re-use pages allocated in low-mem condition */
-	if (page_is_pfmemalloc(buf_info->page))
-		return false;
-
-	/* don't re-use buffers from non-local numa nodes */
-	if (page_to_nid(buf_info->page) != numa_mem_id())
-		return false;
-
-	size = ALIGN(used, IONIC_PAGE_SPLIT_SZ);
-	buf_info->page_offset += size;
-	if (buf_info->page_offset >= IONIC_PAGE_SIZE)
-		return false;
+	dma_sync_single_for_cpu(q->dev,
+				ionic_rx_buf_pa(buf_info) + off,
+				len, DMA_FROM_DEVICE);
 
-	get_page(buf_info->page);
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			buf_info->page, buf_info->page_offset + off,
+			len,
+			IONIC_PAGE_SIZE);
 
-	return true;
+	ionic_rx_buf_complete(q, buf_info, off + len);
 }
 
-static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
-				      struct ionic_desc_info *desc_info,
-				      struct ionic_rxq_comp *comp)
+static struct sk_buff *ionic_rx_build_skb(struct ionic_queue *q,
+					  struct ionic_desc_info *desc_info,
+					  struct ionic_rxq_comp *comp)
 {
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_buf_info *buf_info;
@@ -121,73 +245,24 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 	struct device *dev = q->dev;
 	struct sk_buff *skb;
 	unsigned int i;
+	u16 head_len;
 	u16 frag_len;
+	u16 copy_len;
 	u16 len;
 
 	stats = q_to_rx_stats(q);
 
 	buf_info = &desc_info->bufs[0];
-	len = le16_to_cpu(comp->len);
-
-	prefetchw(buf_info->page);
 
-	skb = napi_get_frags(&q_to_qcq(q)->napi);
-	if (unlikely(!skb)) {
-		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
-				     netdev->name, q->name);
-		stats->alloc_err++;
+	if (unlikely(!buf_info->page))
 		return NULL;
-	}
-
-	i = comp->num_sg_elems + 1;
-	do {
-		if (unlikely(!buf_info->page)) {
-			dev_kfree_skb(skb);
-			return NULL;
-		}
-
-		frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
-		len -= frag_len;
-
-		dma_sync_single_for_cpu(dev,
-					buf_info->dma_addr + buf_info->page_offset,
-					frag_len, DMA_FROM_DEVICE);
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				buf_info->page, buf_info->page_offset, frag_len,
-				IONIC_PAGE_SIZE);
-
-		if (!ionic_rx_buf_recycle(q, buf_info, frag_len)) {
-			dma_unmap_page(dev, buf_info->dma_addr,
-				       IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
-			buf_info->page = NULL;
-		}
-
-		buf_info++;
 
-		i--;
-	} while (i > 0);
-
-	return skb;
-}
-
-static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
-					  struct ionic_desc_info *desc_info,
-					  struct ionic_rxq_comp *comp)
-{
-	struct net_device *netdev = q->lif->netdev;
-	struct ionic_buf_info *buf_info;
-	struct ionic_rx_stats *stats;
-	struct device *dev = q->dev;
-	struct sk_buff *skb;
-	u16 len;
-
-	stats = q_to_rx_stats(q);
+	prefetchw(buf_info->page);
 
-	buf_info = &desc_info->bufs[0];
 	len = le16_to_cpu(comp->len);
+	head_len = min_t(u16, q->lif->rx_copybreak, len);
 
-	skb = napi_alloc_skb(&q_to_qcq(q)->napi, len);
+	skb = napi_alloc_skb(&q_to_qcq(q)->napi, head_len);
 	if (unlikely(!skb)) {
 		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
 				     netdev->name, q->name);
@@ -195,21 +270,41 @@ static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
 		return NULL;
 	}
 
-	if (unlikely(!buf_info->page)) {
-		dev_kfree_skb(skb);
-		return NULL;
-	}
+	copy_len = ALIGN(head_len, sizeof(long)); /* for better memcpy performance */
+	dma_sync_single_for_cpu(dev, ionic_rx_buf_pa(buf_info), copy_len, DMA_FROM_DEVICE);
+	skb_copy_to_linear_data(skb, ionic_rx_buf_va(buf_info), copy_len);
+	skb_put(skb, head_len);
 
-	dma_sync_single_for_cpu(dev, buf_info->dma_addr + buf_info->page_offset,
-				len, DMA_FROM_DEVICE);
-	skb_copy_to_linear_data(skb, page_address(buf_info->page) + buf_info->page_offset, len);
-	dma_sync_single_for_device(dev, buf_info->dma_addr + buf_info->page_offset,
-				   len, DMA_FROM_DEVICE);
+	if (len > head_len) {
+		len -= head_len;
+		frag_len = min_t(u16, len, ionic_rx_buf_size(buf_info) - head_len);
+		len -= frag_len;
+		ionic_rx_add_skb_frag(q, skb, buf_info, head_len, frag_len);
+		buf_info++;
+		for (i = 0; i < comp->num_sg_elems; i++) {
+			if (len == 0)
+				goto err_out;
+			if (unlikely(!buf_info->page))
+				goto err_out;
+			frag_len = min_t(u16, len, ionic_rx_buf_size(buf_info));
+			len -= frag_len;
+			ionic_rx_add_skb_frag(q, skb, buf_info, 0, frag_len);
+			buf_info++;
+		}
+	} else {
+		dma_sync_single_for_device(dev,
+					   ionic_rx_buf_pa(buf_info),
+					   len, DMA_FROM_DEVICE);
+	}
 
-	skb_put(skb, len);
 	skb->protocol = eth_type_trans(skb, q->lif->netdev);
 
 	return skb;
+
+err_out:
+	if (skb)
+		dev_kfree_skb(skb);
+	return NULL;
 }
 
 static void ionic_rx_clean(struct ionic_queue *q,
@@ -235,11 +330,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 	stats->pkts++;
 	stats->bytes += le16_to_cpu(comp->len);
 
-	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
-		skb = ionic_rx_copybreak(q, desc_info, comp);
-	else
-		skb = ionic_rx_frags(q, desc_info, comp);
-
+	skb = ionic_rx_build_skb(q, desc_info, comp);
 	if (unlikely(!skb)) {
 		stats->dropped++;
 		return;
@@ -305,10 +396,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		}
 	}
 
-	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
-		napi_gro_receive(&qcq->napi, skb);
-	else
-		napi_gro_frags(&qcq->napi);
+	napi_gro_receive(&qcq->napi, skb);
 }
 
 bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
@@ -382,8 +470,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 		}
 
 		/* fill main descriptor - buf[0] */
-		desc->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
-		frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
+		desc->addr = cpu_to_le64(ionic_rx_buf_pa(buf_info));
+		frag_len = min_t(u16, len, ionic_rx_buf_size(buf_info));
 		desc->len = cpu_to_le16(frag_len);
 		remain_len -= frag_len;
 		buf_info++;
@@ -401,8 +489,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 				}
 			}
 
-			sg_elem->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
-			frag_len = min_t(u16, remain_len, IONIC_PAGE_SIZE - buf_info->page_offset);
+			sg_elem->addr = cpu_to_le64(ionic_rx_buf_pa(buf_info));
+			frag_len = min_t(u16, remain_len, ionic_rx_buf_size(buf_info));
 			sg_elem->len = cpu_to_le16(frag_len);
 			remain_len -= frag_len;
 			buf_info++;
@@ -451,6 +539,8 @@ void ionic_rx_empty(struct ionic_queue *q)
 
 	q->head_idx = 0;
 	q->tail_idx = 0;
+
+	ionic_rx_cache_drain(q);
 }
 
 static void ionic_dim_update(struct ionic_qcq *qcq, int napi_mode)
-- 
2.17.1

