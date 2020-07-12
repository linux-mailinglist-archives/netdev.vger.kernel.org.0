Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D42B21CBE8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgGLWg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:59 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53825 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbgGLWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593417; x=1626129417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OqtmgQTRrJaz/mD3xfazv1bdkFslh5sRXWr8ybPngpA=;
  b=S+KCXjvLWSX9r2tbIpyJ/Sc70kc2KNe2wZujvsGtlF6TqwFO7ujczAG7
   9jr+GXIPCzfL2ZVqw6yjmpcAUz9M8GQHqWlPX3NE1tpAeTb+EvGAy7cDq
   9zQ+kNkXPlJGYM7uvnFgP5Ye8QsmYS31CG7Nm+s5Uk9WgX9/ML8q8CaHn
   Q=;
IronPort-SDR: dlXW1Q8lBfB0cJkFj4pXxBmRInPsN7ttJSlo8ccnLK2azewHFneQemfjGIqQUyD2kVDT13K2HD
 lSdjwM0h8Cqg==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="59141415"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Jul 2020 22:36:56 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 30F92A1968;
        Sun, 12 Jul 2020 22:36:56 +0000 (UTC)
Received: from EX13D21UWA003.ant.amazon.com (10.43.160.184) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:48 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA003.ant.amazon.com (10.43.160.184) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:48 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:43 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 6/7] net: ena: move llq configuration from ena_probe to ena_device_init()
Date:   Mon, 13 Jul 2020 01:36:10 +0300
Message-ID: <1594593371-14045-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

When the ENA device resets to recover from some error state, all LLQ
configuration values are reset to their defaults, because LLQ is
initialized only once during ena_probe().

Changes in this commit:
1. Move the LLQ configuration process into ena_init_device()
which is called from both ena_probe() and ena_restore_device(). This
way, LLQ setup configurations that are different from the default
values will survive resets.

2. Extract the LLQ bar mapping to ena_map_llq_bar(),
and call once in the lifetime of the driver from ena_probe(),
since there is no need to unmap and map the LLQ bar again every reset.

3. Map the LLQ bar if it exists, regardless if initialization of LLQ
placement policy (ENA_ADMIN_PLACEMENT_POLICY_DEV) succeeded
or not. Initialization might fail the first time, falling back to the
ENA_ADMIN_PLACEMENT_POLICY_HOST placement policy, but later succeed
after device reset, in which case the LLQ bar needs to be mapped
already.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 136 ++++++++++---------
 1 file changed, 73 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index fd5f0d87cc59..7b8301bac1ce 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3279,10 +3279,71 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
 	return 0;
 }
 
+static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
+{
+	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
+	llq_config->llq_stride_ctrl = ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
+	llq_config->llq_num_decs_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
+	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
+	llq_config->llq_ring_entry_size_value = 128;
+}
+
+static int ena_set_queues_placement_policy(struct pci_dev *pdev,
+					   struct ena_com_dev *ena_dev,
+					   struct ena_admin_feature_llq_desc *llq,
+					   struct ena_llq_configurations *llq_default_configurations)
+{
+	int rc;
+	u32 llq_feature_mask;
+
+	llq_feature_mask = 1 << ENA_ADMIN_LLQ;
+	if (!(ena_dev->supported_features & llq_feature_mask)) {
+		dev_err(&pdev->dev,
+			"LLQ is not supported Fallback to host mode policy.\n");
+		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
+		return 0;
+	}
+
+	rc = ena_com_config_dev_mode(ena_dev, llq, llq_default_configurations);
+	if (unlikely(rc)) {
+		dev_err(&pdev->dev,
+			"Failed to configure the device mode.  Fallback to host mode policy.\n");
+		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
+	}
+
+	return 0;
+}
+
+static int ena_map_llq_mem_bar(struct pci_dev *pdev, struct ena_com_dev *ena_dev,
+			       int bars)
+{
+	bool has_mem_bar = !!(bars & BIT(ENA_MEM_BAR));
+
+	if (!has_mem_bar) {
+		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
+			dev_err(&pdev->dev,
+				"ENA device does not expose LLQ bar. Fallback to host mode policy.\n");
+			ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
+		}
+
+		return 0;
+	}
+
+	ena_dev->mem_bar = devm_ioremap_wc(&pdev->dev,
+					   pci_resource_start(pdev, ENA_MEM_BAR),
+					   pci_resource_len(pdev, ENA_MEM_BAR));
+
+	if (!ena_dev->mem_bar)
+		return -EFAULT;
+
+	return 0;
+}
+
 static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 			   struct ena_com_dev_get_features_ctx *get_feat_ctx,
 			   bool *wd_state)
 {
+	struct ena_llq_configurations llq_config;
 	struct device *dev = &pdev->dev;
 	bool readless_supported;
 	u32 aenq_groups;
@@ -3373,6 +3434,15 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
 	*wd_state = !!(aenq_groups & BIT(ENA_ADMIN_KEEP_ALIVE));
 
+	set_default_llq_configurations(&llq_config);
+
+	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx->llq,
+					     &llq_config);
+	if (rc) {
+		dev_err(&pdev->dev, "ena device init failed\n");
+		goto err_admin_init;
+	}
+
 	return 0;
 
 err_admin_init:
@@ -3879,54 +3949,6 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 	return max_num_io_queues;
 }
 
-static int ena_set_queues_placement_policy(struct pci_dev *pdev,
-					   struct ena_com_dev *ena_dev,
-					   struct ena_admin_feature_llq_desc *llq,
-					   struct ena_llq_configurations *llq_default_configurations)
-{
-	bool has_mem_bar;
-	int rc;
-	u32 llq_feature_mask;
-
-	llq_feature_mask = 1 << ENA_ADMIN_LLQ;
-	if (!(ena_dev->supported_features & llq_feature_mask)) {
-		dev_err(&pdev->dev,
-			"LLQ is not supported Fallback to host mode policy.\n");
-		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
-		return 0;
-	}
-
-	has_mem_bar = pci_select_bars(pdev, IORESOURCE_MEM) & BIT(ENA_MEM_BAR);
-
-	rc = ena_com_config_dev_mode(ena_dev, llq, llq_default_configurations);
-	if (unlikely(rc)) {
-		dev_err(&pdev->dev,
-			"Failed to configure the device mode.  Fallback to host mode policy.\n");
-		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
-		return 0;
-	}
-
-	/* Nothing to config, exit */
-	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
-		return 0;
-
-	if (!has_mem_bar) {
-		dev_err(&pdev->dev,
-			"ENA device does not expose LLQ bar. Fallback to host mode policy.\n");
-		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
-		return 0;
-	}
-
-	ena_dev->mem_bar = devm_ioremap_wc(&pdev->dev,
-					   pci_resource_start(pdev, ENA_MEM_BAR),
-					   pci_resource_len(pdev, ENA_MEM_BAR));
-
-	if (!ena_dev->mem_bar)
-		return -EFAULT;
-
-	return 0;
-}
-
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
@@ -4042,14 +4064,6 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 	pci_release_selected_regions(pdev, release_bars);
 }
 
-static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
-{
-	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
-	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
-	llq_config->llq_stride_ctrl = ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
-	llq_config->llq_num_decs_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
-	llq_config->llq_ring_entry_size_value = 128;
-}
 
 static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 {
@@ -4131,7 +4145,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
-	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
 	struct net_device *netdev;
@@ -4186,13 +4199,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_region;
 	}
 
-	set_default_llq_configurations(&llq_config);
-
-	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx.llq,
-					     &llq_config);
+	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
 	if (rc) {
-		dev_err(&pdev->dev, "ena device init failed\n");
-		goto err_device_destroy;
+		dev_err(&pdev->dev, "ena llq bar mapping failed\n");
+		goto err_free_ena_dev;
 	}
 
 	calc_queue_ctx.ena_dev = ena_dev;
-- 
2.23.1

