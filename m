Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD0228120
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgGUNja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61061 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgGUNja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338769; x=1626874769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Jm23THymBN5DpGxvN7jwTbr9N99p9Bj9KfweIFZSN+Y=;
  b=ehE4iN7FbN2aoK+naGTQMoOTt1t5d0v///WESemadGjW/dKARfTbCyw0
   uSaKGCQQ0z63U9Ec3MYbdUalS8L2YzxhCJV1R6kah0eJ9e5rB/XZRhT5e
   idsPRU93Cuf26pVm0RmSDLfMW8MB5VNuAIKWFczwC4S6MucU78EGlKb0w
   A=;
IronPort-SDR: EzQmp7N1zAxTHvCJswF2z4vowMn0D8TeuQV51Ropfck/lbpw27F/VpnlUUJ6hXDMeRORqUwhg8
 uDWjBjoiVEpQ==
X-IronPort-AV: E=Sophos;i="5.75,378,1589241600"; 
   d="scan'208";a="61582193"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Jul 2020 13:39:28 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 7966EA1DA6;
        Tue, 21 Jul 2020 13:39:27 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:39:05 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:39:04 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:39:00 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 7/8] net: ena: move llq configuration from ena_probe to ena_device_init()
Date:   Tue, 21 Jul 2020 16:38:10 +0300
Message-ID: <1595338691-3130-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
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
index 491ea013868b..913d698b9834 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3280,10 +3280,71 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
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
@@ -3374,6 +3435,15 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
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
@@ -3880,54 +3950,6 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
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
@@ -4043,14 +4065,6 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
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
@@ -4132,7 +4146,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
-	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
 	struct net_device *netdev;
@@ -4187,13 +4200,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
2.23.3

