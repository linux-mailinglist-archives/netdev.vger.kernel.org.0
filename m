Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC41C495E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJBIVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:21:23 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36702 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfJBIVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:21:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570004481; x=1601540481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HhysQOjmDZzbLnYtN++MsrmJtyEdxsJbOJnrJtvwMAk=;
  b=Ze/QGtyPNtnKXthi6G/L0Ft40tfrn//aNQpnCeIR5BoyH74xjOOB4twE
   QGe3psiJAcU1VI5qgc+h3JBfrkY7cznfLIWbeXwT2v0wQsJI3q7HkFNiL
   1J9UbvT9GlfNmv86fB8YxxC6x6fRwKH00guB7SdyDTlqOyztxzTwz4wVg
   I=;
X-IronPort-AV: E=Sophos;i="5.64,573,1559520000"; 
   d="scan'208";a="425255974"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 02 Oct 2019 08:21:20 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 26625A181C;
        Wed,  2 Oct 2019 08:21:20 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:06 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:06 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 2 Oct 2019 08:21:03 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 2/5] net: ena: multiple queue creation related cleanups
Date:   Wed, 2 Oct 2019 11:20:49 +0300
Message-ID: <20191002082052.14051-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002082052.14051-1-sameehj@amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

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
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 33 +++++++-------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d4d2639d2..6afafcdb8 100644
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
 
@@ -2683,14 +2683,13 @@ err_mmio_read_less:
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
@@ -2783,8 +2782,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		goto err_device_destroy;
 	}
 
-	rc = ena_enable_msix_and_set_admin_interrupts(adapter,
-						      adapter->num_io_queues);
+	rc = ena_enable_msix_and_set_admin_interrupts(adapter);
 	if (rc) {
 		dev_err(&pdev->dev, "Enable MSI-X failed\n");
 		goto err_device_destroy;
@@ -3350,7 +3348,7 @@ static void set_default_llq_configurations(struct ena_llq_configurations *llq_co
 	llq_config->llq_ring_entry_size_value = 128;
 }
 
-static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
+static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 {
 	struct ena_admin_feature_llq_desc *llq = &ctx->get_feat_ctx->llq;
 	struct ena_com_dev *ena_dev = ctx->ena_dev;
@@ -3359,7 +3357,7 @@ static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
 	u32 max_tx_queue_size;
 	u32 max_rx_queue_size;
 
-	if (ctx->ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
 			&ctx->get_feat_ctx->max_queue_ext.max_queue_ext;
 		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
@@ -3497,26 +3495,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -3570,7 +3561,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	u64_stats_init(&adapter->syncp);
 
-	rc = ena_enable_msix_and_set_admin_interrupts(adapter, io_queue_num);
+	rc = ena_enable_msix_and_set_admin_interrupts(adapter);
 	if (rc) {
 		dev_err(&pdev->dev,
 			"Failed to enable and set the admin interrupts\n");
-- 
2.17.1

