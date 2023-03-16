Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE86BD25F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCPO2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjCPO2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:28:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB63BC88AD
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678976907; x=1710512907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YjfG5GDtETcqtZinMrRSL3Rh3CjZT9w1+JibO8SUIb0=;
  b=DxDVWFBjeaQlhvCoyLHfbZM0nMfLh9Mp2BAhFqxnE81iIDMyZx1Yfj0Y
   lc9XEJIuDuaB1BR73qE+kuvfb/VVj/+CVH+GIzdjtETXUGw56REKEoNa9
   pw8jwkkQikpzE/kRU3SywZ+yuknRhrKoRIBcMGJ7Swx1ag9SF659gHm46
   M=;
X-IronPort-AV: E=Sophos;i="5.98,265,1673913600"; 
   d="scan'208";a="270057498"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:28:21 +0000
Received: from EX19D013EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id D8E9340D5B;
        Thu, 16 Mar 2023 14:28:19 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D013EUA004.ant.amazon.com (10.252.50.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:28:18 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.176) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:28:10 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH v5 net-next 3/6] net: ena: Add an option to configure large LLQ headers
Date:   Thu, 16 Mar 2023 16:27:03 +0200
Message-ID: <20230316142706.4046263-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230316142706.4046263-1-shayagr@amazon.com>
References: <20230316142706.4046263-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.176]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

Allow configuring the device with large LLQ headers. The Low Latency
Queue (LLQ) allows the driver to write the first N bytes of the packet,
along with the rest of the TX descriptors directly into device (N can be
either 96 or 224 for large LLQ headers configuration).

Having L4 TCP/UDP headers contained in the first 96 bytes of the packet
is required to get maximum performance from the device.

Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 90 +++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  8 ++
 2 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 372e33831323..b97ecae439b2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3374,6 +3374,15 @@ static void ena_calc_io_queue_size(struct ena_adapter *adapter,
 	u32 max_tx_queue_size;
 	u32 max_rx_queue_size;
 
+	/* If this function is called after driver load, the ring sizes have already
+	 * been configured. Take it into account when recalculating ring size.
+	 */
+	if (adapter->tx_ring->ring_size)
+		tx_queue_size = adapter->tx_ring->ring_size;
+
+	if (adapter->rx_ring->ring_size)
+		rx_queue_size = adapter->rx_ring->ring_size;
+
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
 			&get_feat_ctx->max_queue_ext.max_queue_ext;
@@ -3415,6 +3424,24 @@ static void ena_calc_io_queue_size(struct ena_adapter *adapter,
 	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
 	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
 
+	/* When forcing large headers, we multiply the entry size by 2, and therefore divide
+	 * the queue size by 2, leaving the amount of memory used by the queues unchanged.
+	 */
+	if (adapter->large_llq_header_enabled) {
+		if ((llq->entry_size_ctrl_supported & ENA_ADMIN_LIST_ENTRY_SIZE_256B) &&
+		    ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
+			max_tx_queue_size /= 2;
+			dev_info(&adapter->pdev->dev,
+				 "Forcing large headers and decreasing maximum TX queue size to %d\n",
+				 max_tx_queue_size);
+		} else {
+			dev_err(&adapter->pdev->dev,
+				"Forcing large headers failed: LLQ is disabled or device does not support large headers\n");
+
+			adapter->large_llq_header_enabled = false;
+		}
+	}
+
 	tx_queue_size = clamp_val(tx_queue_size, ENA_MIN_RING_SIZE,
 				  max_tx_queue_size);
 	rx_queue_size = clamp_val(rx_queue_size, ENA_MIN_RING_SIZE,
@@ -3452,13 +3479,30 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
 	return 0;
 }
 
-static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
+static void set_default_llq_configurations(struct ena_adapter *adapter,
+					   struct ena_llq_configurations *llq_config,
+					   struct ena_admin_feature_llq_desc *llq)
 {
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+
 	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
 	llq_config->llq_stride_ctrl = ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
 	llq_config->llq_num_decs_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
-	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
-	llq_config->llq_ring_entry_size_value = 128;
+
+	adapter->large_llq_header_supported =
+		!!(ena_dev->supported_features & BIT(ENA_ADMIN_LLQ));
+	adapter->large_llq_header_supported &=
+		!!(llq->entry_size_ctrl_supported &
+			ENA_ADMIN_LIST_ENTRY_SIZE_256B);
+
+	if ((llq->entry_size_ctrl_supported & ENA_ADMIN_LIST_ENTRY_SIZE_256B) &&
+	    adapter->large_llq_header_enabled) {
+		llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_256B;
+		llq_config->llq_ring_entry_size_value = 256;
+	} else {
+		llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
+		llq_config->llq_ring_entry_size_value = 128;
+	}
 }
 
 static int ena_set_queues_placement_policy(struct pci_dev *pdev,
@@ -3477,6 +3521,13 @@ static int ena_set_queues_placement_policy(struct pci_dev *pdev,
 		return 0;
 	}
 
+	if (!ena_dev->mem_bar) {
+		netdev_err(ena_dev->net_device,
+			   "LLQ is advertised as supported but device doesn't expose mem bar\n");
+		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
+		return 0;
+	}
+
 	rc = ena_com_config_dev_mode(ena_dev, llq, llq_default_configurations);
 	if (unlikely(rc)) {
 		dev_err(&pdev->dev,
@@ -3492,15 +3543,8 @@ static int ena_map_llq_mem_bar(struct pci_dev *pdev, struct ena_com_dev *ena_dev
 {
 	bool has_mem_bar = !!(bars & BIT(ENA_MEM_BAR));
 
-	if (!has_mem_bar) {
-		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
-			dev_err(&pdev->dev,
-				"ENA device does not expose LLQ bar. Fallback to host mode policy.\n");
-			ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
-		}
-
+	if (!has_mem_bar)
 		return 0;
-	}
 
 	ena_dev->mem_bar = devm_ioremap_wc(&pdev->dev,
 					   pci_resource_start(pdev, ENA_MEM_BAR),
@@ -3512,10 +3556,11 @@ static int ena_map_llq_mem_bar(struct pci_dev *pdev, struct ena_com_dev *ena_dev
 	return 0;
 }
 
-static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
+static int ena_device_init(struct ena_adapter *adapter, struct pci_dev *pdev,
 			   struct ena_com_dev_get_features_ctx *get_feat_ctx,
 			   bool *wd_state)
 {
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	struct ena_llq_configurations llq_config;
 	struct device *dev = &pdev->dev;
 	bool readless_supported;
@@ -3600,7 +3645,7 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
 	*wd_state = !!(aenq_groups & BIT(ENA_ADMIN_KEEP_ALIVE));
 
-	set_default_llq_configurations(&llq_config);
+	set_default_llq_configurations(adapter, &llq_config, &get_feat_ctx->llq);
 
 	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx->llq,
 					     &llq_config);
@@ -3609,6 +3654,8 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 		goto err_admin_init;
 	}
 
+	ena_calc_io_queue_size(adapter, get_feat_ctx);
+
 	return 0;
 
 err_admin_init:
@@ -3707,7 +3754,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 	int rc;
 
 	set_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags);
-	rc = ena_device_init(ena_dev, adapter->pdev, &get_feat_ctx, &wd_state);
+	rc = ena_device_init(adapter, adapter->pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
 		dev_err(&pdev->dev, "Can not initialize device\n");
 		goto err;
@@ -4311,18 +4358,18 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, adapter);
 
-	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
+	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
 	if (rc) {
-		dev_err(&pdev->dev, "ENA device init failed\n");
-		if (rc == -ETIME)
-			rc = -EPROBE_DEFER;
+		dev_err(&pdev->dev, "ENA LLQ bar mapping failed\n");
 		goto err_netdev_destroy;
 	}
 
-	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
+	rc = ena_device_init(adapter, pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
-		dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
-		goto err_device_destroy;
+		dev_err(&pdev->dev, "ENA device init failed\n");
+		if (rc == -ETIME)
+			rc = -EPROBE_DEFER;
+		goto err_netdev_destroy;
 	}
 
 	/* Initial TX and RX interrupt delay. Assumes 1 usec granularity.
@@ -4332,7 +4379,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	ena_calc_io_queue_size(adapter, &get_feat_ctx);
 	if (unlikely(!max_num_io_queues)) {
 		rc = -EFAULT;
 		goto err_device_destroy;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 2cb141079474..3e8c4a66c7d8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -334,6 +334,14 @@ struct ena_adapter {
 
 	u32 msg_enable;
 
+	/* large_llq_header_enabled is used for two purposes:
+	 * 1. Indicates that large LLQ has been requested.
+	 * 2. Indicates whether large LLQ is set or not after device
+	 *    initialization / configuration.
+	 */
+	bool large_llq_header_enabled;
+	bool large_llq_header_supported;
+
 	u16 max_tx_sgl_size;
 	u16 max_rx_sgl_size;
 
-- 
2.25.1

