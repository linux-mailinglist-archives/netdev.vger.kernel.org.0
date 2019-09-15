Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1060EB30AF
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbfIOP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:27:53 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:32926 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfIOP1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568561271; x=1600097271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=FX2wpfdITnfdF3oy6+RY8I9lchl+1WbTEm5jV9Toer4=;
  b=R+LMGs+pw+M1I16pabQnyxov/EcrirEd6Dm6Kkfb6NfjCko0FYbiQcBR
   vUMa2uWDyk8la8DREkt5vQ6Cr9xHNFSqNtAgQYfPodJwXynxadZLMlyal
   pQHIAnzEHgP2dVY8oVmvntVX1ROD2N4Yg4QCHlWjzW3tHDkresTlUJZd4
   M=;
X-IronPort-AV: E=Sophos;i="5.64,509,1559520000"; 
   d="scan'208";a="832173359"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Sep 2019 15:27:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id E25C2A220A;
        Sun, 15 Sep 2019 15:27:50 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:38 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:38 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 15 Sep 2019 15:27:34 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 2/5] net: ena: multiple queue creation related cleanups
Date:   Sun, 15 Sep 2019 18:27:19 +0300
Message-ID: <20190915152722.8240-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915152722.8240-1-sameehj@amazon.com>
References: <20190915152722.8240-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

- Move the print to dmesg of creating io queues from ena_probe to
  ena_up. ena_up is the place where queues are actually created.
- Rename ena_calc_queue_size() to ena_calc_io_queue_size() for clarity
  and consistency
- Remove redundant number of io queues parameter in functions
  ena_enable_msix() and ena_enable_msix_and_set_admin_interrupts(),
  which already get adapter parameter, so use adapter->num_io_queues
  in the function instead.
- Use the local variable ena_dev instead of ctx->ena_dev in
  ena_calc_io_queue_size
- Fix multi row comment alignments

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 40 ++++++++++----------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d4d2639d2..b7cd80c5f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1332,7 +1332,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
  * the number of potential io queues is the minimum of what the device
  * supports and the number of vCPUs.
  */
-static int ena_enable_msix(struct ena_adapter *adapter, int num_queues)
+static int ena_enable_msix(struct ena_adapter *adapter)
 {
 	int msix_vecs, irq_cnt;
 
@@ -1343,7 +1343,7 @@ static int ena_enable_msix(struct ena_adapter *adapter, int num_queues)
 	}
 
 	/* Reserved the max msix vectors we might need */
-	msix_vecs = ENA_MAX_MSIX_VEC(num_queues);
+	msix_vecs = ENA_MAX_MSIX_VEC(adapter->num_io_queues);
 	netif_dbg(adapter, probe, adapter->netdev,
 		  "trying to enable MSI-X, vectors %d\n", msix_vecs);
 
@@ -1885,6 +1885,13 @@ static int ena_up(struct ena_adapter *adapter)
 	if (rc)
 		goto err_req_irq;
 
+	netif_info(adapter, ifup, adapter->netdev, "creating %d io queues. rx queue size: %d tx queue size. %d LLQ is %s\n",
+		   adapter->num_io_queues,
+		   adapter->requested_rx_ring_size,
+		   adapter->requested_tx_ring_size,
+		   (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) ?
+		   "ENABLED" : "DISABLED");
+
 	rc = create_queues_with_size_backoff(adapter);
 	if (rc)
 		goto err_create_queues_with_backoff;
@@ -2683,14 +2690,13 @@ err_mmio_read_less:
 	return rc;
 }
 
-static int ena_enable_msix_and_set_admin_interrupts(struct ena_adapter *adapter,
-						    int io_vectors)
+static int ena_enable_msix_and_set_admin_interrupts(struct ena_adapter *adapter)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	struct device *dev = &adapter->pdev->dev;
 	int rc;
 
-	rc = ena_enable_msix(adapter, io_vectors);
+	rc = ena_enable_msix(adapter);
 	if (rc) {
 		dev_err(dev, "Can not reserve msix vectors\n");
 		return rc;
@@ -2783,8 +2789,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		goto err_device_destroy;
 	}
 
-	rc = ena_enable_msix_and_set_admin_interrupts(adapter,
-						      adapter->num_io_queues);
+	rc = ena_enable_msix_and_set_admin_interrupts(adapter);
 	if (rc) {
 		dev_err(&pdev->dev, "Enable MSI-X failed\n");
 		goto err_device_destroy;
@@ -3350,7 +3355,7 @@ static void set_default_llq_configurations(struct ena_llq_configurations *llq_co
 	llq_config->llq_ring_entry_size_value = 128;
 }
 
-static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
+static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 {
 	struct ena_admin_feature_llq_desc *llq = &ctx->get_feat_ctx->llq;
 	struct ena_com_dev *ena_dev = ctx->ena_dev;
@@ -3359,7 +3364,7 @@ static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
 	u32 max_tx_queue_size;
 	u32 max_rx_queue_size;
 
-	if (ctx->ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
 			&ctx->get_feat_ctx->max_queue_ext.max_queue_ext;
 		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
@@ -3497,26 +3502,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
 	calc_queue_ctx.pdev = pdev;
 
-	/* Initial Tx and RX interrupt delay. Assumes 1 usec granularity.
-	* Updated during device initialization with the real granularity
-	*/
+	/* initial Tx interrupt delay, Assumes 1 usec granularity.
+	 * Updated during device initialization with the real granularity
+	 */
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	rc = ena_calc_queue_size(&calc_queue_ctx);
+	rc = ena_calc_io_queue_size(&calc_queue_ctx);
 	if (rc || io_queue_num <= 0) {
 		rc = -EFAULT;
 		goto err_device_destroy;
 	}
 
-	dev_info(&pdev->dev, "creating %d io queues. rx queue size: %d tx queue size. %d LLQ is %s\n",
-		 io_queue_num,
-		 calc_queue_ctx.rx_queue_size,
-		 calc_queue_ctx.tx_queue_size,
-		 (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) ?
-		 "ENABLED" : "DISABLED");
-
 	/* dev zeroed in init_etherdev */
 	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), io_queue_num);
 	if (!netdev) {
@@ -3570,7 +3568,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	u64_stats_init(&adapter->syncp);
 
-	rc = ena_enable_msix_and_set_admin_interrupts(adapter, io_queue_num);
+	rc = ena_enable_msix_and_set_admin_interrupts(adapter);
 	if (rc) {
 		dev_err(&pdev->dev,
 			"Failed to enable and set the admin interrupts\n");
-- 
2.17.1

