Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866A01B39D2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgDVIQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:41 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42374 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgDVIQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543397; x=1619079397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YVUePSdberQu3WTDxh/422SzdAJvk8ZLOskxX5A8YpA=;
  b=FPWXTlN6U5yTcyZJUYERU6Y2sTyEm2qxuKbtucSZLPQRXWVDNMBHU2yD
   iNJtr8rWA2b3MZ+YQ7L+3sAKpmFEebc3pZeCSyAqLrwl5fnyvie+HB3r9
   x57e1laM5917hjYZ+YesX/zXtpKaU2I+10dXSZmuuUPaj919+G3yxO3CH
   E=;
IronPort-SDR: dSVDIJcTwbydHFAABvq2kbsJ4R8oGAgE1ijg8truAmmNTzDattcP04gUPkvroCKeHk+83R8JDa
 A05AVpxsG4Rg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="40116062"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Apr 2020 08:16:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 4C393A2369;
        Wed, 22 Apr 2020 08:16:37 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 8546D81D25; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 11/13] net: ena: move llq configuration from ena_probe to ena_device_init()
Date:   Wed, 22 Apr 2020 08:16:26 +0000
Message-ID: <20200422081628.8103-12-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This refactor is done as preparation for an upcoming feature of allowing
to increase the header size when LLQ is on.

Such a change needs to survive a device reset (for instance due to some
recoverable error). In order to do that, llq initialization needs to
happen both at device initialization and at device restore. We therefore
move it to ena_device_init() which is called from both ena_probe()
and ena_restore_device().

Also, functions are moved around in order for them to be defined
before they are used.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 133 ++++++++++---------
 1 file changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2818965427e9..37c5ae52de7d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3263,10 +3263,68 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
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
+	bool has_mem_bar;
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
+	has_mem_bar = pci_select_bars(pdev, IORESOURCE_MEM) & BIT(ENA_MEM_BAR);
+
+	rc = ena_com_config_dev_mode(ena_dev, llq, llq_default_configurations);
+	if (unlikely(rc)) {
+		dev_err(&pdev->dev,
+			"Failed to configure the device mode.  Fallback to host mode policy.\n");
+		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
+		return 0;
+	}
+
+	/* Nothing to config, exit */
+	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
+		return 0;
+
+	if (!has_mem_bar) {
+		dev_err(&pdev->dev,
+			"ENA device does not expose LLQ bar. Fallback to host mode policy.\n");
+		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
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
@@ -3357,6 +3415,15 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
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
@@ -3864,54 +3931,6 @@ static int ena_calc_max_io_queue_num(struct pci_dev *pdev,
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
@@ -4027,14 +4046,6 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
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
@@ -4116,7 +4127,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
-	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
 	struct net_device *netdev;
@@ -4169,15 +4179,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_region;
 	}
 
-	set_default_llq_configurations(&llq_config);
-
-	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx.llq,
-					     &llq_config);
-	if (rc) {
-		dev_err(&pdev->dev, "ena device init failed\n");
-		goto err_device_destroy;
-	}
-
 	calc_queue_ctx.ena_dev = ena_dev;
 	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
 	calc_queue_ctx.pdev = pdev;
-- 
2.24.1.AMZN

