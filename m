Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280BC661487
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjAHKgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjAHKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:36:05 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AFCE0C3
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673174164; x=1704710164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPgABhr7ie7jATqagQ7xcHqNsDrm8OL8O6BdbfdvoFo=;
  b=CtZFlr17qzX0YiX4zPBPCfu8GCwag3P6qkaTAqChRHJwyxAdgW+VYfVt
   e8HtTzML2ihnpgVMlfWOQjIoTdoMl/3nnh0yMUbt9Vw1QgKybPPvMgpUI
   UCMjSCTCWv1kzeGezX0diKTmN9p6j4hZPCHOI7/VLibC++zICXzKu5wWx
   8=;
X-IronPort-AV: E=Sophos;i="5.96,310,1665446400"; 
   d="scan'208";a="297950532"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 10:36:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id DF8B3160C2D;
        Sun,  8 Jan 2023 10:36:01 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 8 Jan 2023 10:35:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sun, 8 Jan 2023 10:35:53 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Sun, 8 Jan 2023 10:35:51 +0000
From:   David Arinzon <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net-next 4/5] net: ena: Several changes to support large LLQ configuration
Date:   Sun, 8 Jan 2023 10:35:32 +0000
Message-ID: <20230108103533.10104-5-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Allow queue related parameters to be recalculated upon every
   VF reset.
2. Handling of queues configured before ena_device_init() function
   is called.
3. Prevention of large LLQ configuration if LLQ is not
   supported.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 48 +++++++++++++-------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 24b95765bb04..fac8c913de6b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -44,6 +44,8 @@ MODULE_DEVICE_TABLE(pci, ena_pci_tbl);
 
 static int ena_rss_init_default(struct ena_adapter *adapter);
 static void check_for_admin_com_state(struct ena_adapter *adapter);
+static void ena_calc_io_queue_size(struct ena_adapter *adapter,
+				   struct ena_com_dev_get_features_ctx *get_feat_ctx);
 
 static void ena_init_io_rings(struct ena_adapter *adapter,
 			      int first_index, int count);
@@ -3427,6 +3429,13 @@ static int ena_set_queues_placement_policy(struct pci_dev *pdev,
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
@@ -3442,15 +3451,8 @@ static int ena_map_llq_mem_bar(struct pci_dev *pdev, struct ena_com_dev *ena_dev
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
@@ -3462,10 +3464,11 @@ static int ena_map_llq_mem_bar(struct pci_dev *pdev, struct ena_com_dev *ena_dev
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
@@ -3561,6 +3564,8 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 		goto err_admin_init;
 	}
 
+	ena_calc_io_queue_size(adapter, get_feat_ctx);
+
 	return 0;
 
 err_admin_init:
@@ -3659,7 +3664,7 @@ int ena_restore_device(struct ena_adapter *adapter)
 	int rc;
 
 	set_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags);
-	rc = ena_device_init(ena_dev, adapter->pdev, &get_feat_ctx, &wd_state);
+	rc = ena_device_init(adapter, adapter->pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
 		dev_err(&pdev->dev, "Can not initialize device\n");
 		goto err;
@@ -4187,9 +4192,19 @@ static void ena_calc_io_queue_size(struct ena_adapter *adapter,
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	u32 tx_queue_size = ENA_DEFAULT_RING_SIZE;
 	u32 rx_queue_size = ENA_DEFAULT_RING_SIZE;
+	bool tx_configured, rx_configured;
 	u32 max_tx_queue_size;
 	u32 max_rx_queue_size;
 
+	/* If this function is called after driver load, the ring sizes have
+	 * already been configured. Take it into account when recalculating ring
+	 * size.
+	 */
+	tx_configured = !!adapter->tx_ring[0].ring_size;
+	rx_configured = !!adapter->rx_ring[0].ring_size;
+	tx_queue_size = tx_configured ? adapter->tx_ring[0].ring_size : tx_queue_size;
+	rx_queue_size = rx_configured ? adapter->rx_ring[0].ring_size : rx_queue_size;
+
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
 			&get_feat_ctx->max_queue_ext.max_queue_ext;
@@ -4354,6 +4369,12 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_netdev_destroy;
 	}
 
+	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
+	if (rc) {
+		dev_err(&pdev->dev, "ENA LLQ bar mapping failed\n");
+		goto err_devlink_destroy;
+	}
+
 	rc = ena_device_init(adapter, pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
 		dev_err(&pdev->dev, "ENA device init failed\n");
@@ -4362,12 +4383,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_devlink_destroy;
 	}
 
-	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
-	if (rc) {
-		dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
-		goto err_device_destroy;
-	}
-
 	/* Initial TX and RX interrupt delay. Assumes 1 usec granularity.
 	 * Updated during device initialization with the real granularity
 	 */
@@ -4375,7 +4390,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	ena_calc_io_queue_size(adapter, &get_feat_ctx);
 	if (unlikely(!max_num_io_queues)) {
 		rc = -EFAULT;
 		goto err_device_destroy;
-- 
2.38.1

