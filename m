Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA566B3956
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbfIPLbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:31:48 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:31633 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfIPLbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633507; x=1600169507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ee/wvIFclAzTmEpyHqsyZYJZ0N3azIx73yvNs0C3Vl4=;
  b=AlGtdFQxbUMuj0Qo0Zrk+Qp24+BHluZfKw/ReGcn4hWXjbX6PYuVbS1x
   aePIljRdgnIHEeDoD4eTH7sEITus/DDClnCX1129y1j6RvWKnBy32obEf
   HdkHLL4pnfj/mg8rygpztt9M24vzqQTt/qu2MCgjmICvgSh3De+sXqKHF
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="750940011"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Sep 2019 11:31:45 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 9C531A1C99;
        Mon, 16 Sep 2019 11:31:45 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:45 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:44 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:41 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 01/11] net: ena: add intr_moder_rx_interval to struct ena_com_dev and use it
Date:   Mon, 16 Sep 2019 14:31:26 +0300
Message-ID: <1568633496-4143-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add intr_moder_rx_interval to struct ena_com_dev and use it as the
location where the interrupt moderation rx interval is saved, instead
of the interrupt moderation table.

This is done as a first step before removing the old interrupt moderation
code.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    | 20 ++++----------------
 drivers/net/ethernet/amazon/ena/ena_com.h    |  8 +++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  3 ++-
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 911a2e7a375a..4144936bf8a2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1297,9 +1297,6 @@ static int ena_com_init_interrupt_moderation_table(struct ena_com_dev *ena_dev)
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-	unsigned int i;
-
 	if (!intr_delay_resolution) {
 		pr_err("Illegal intr_delay_resolution provided. Going to use default 1 usec resolution\n");
 		intr_delay_resolution = 1;
@@ -1307,8 +1304,7 @@ static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 	ena_dev->intr_delay_resolution = intr_delay_resolution;
 
 	/* update Rx */
-	for (i = 0; i < ENA_INTR_MAX_NUM_OF_LEVELS; i++)
-		intr_moder_tbl[i].intr_moder_interval /= intr_delay_resolution;
+	ena_dev->intr_moder_rx_interval /= intr_delay_resolution;
 
 	/* update Tx */
 	ena_dev->intr_moder_tx_interval /= intr_delay_resolution;
@@ -2798,11 +2794,8 @@ int ena_com_update_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_de
 		return -EFAULT;
 	}
 
-	/* We use LOWEST entry of moderation table for storing
-	 * nonadaptive interrupt coalescing values
-	 */
-	ena_dev->intr_moder_tbl[ENA_INTR_MODER_LOWEST].intr_moder_interval =
-		rx_coalesce_usecs / ena_dev->intr_delay_resolution;
+	ena_dev->intr_moder_rx_interval = rx_coalesce_usecs /
+		ena_dev->intr_delay_resolution;
 
 	return 0;
 }
@@ -2907,12 +2900,7 @@ unsigned int ena_com_get_nonadaptive_moderation_interval_tx(struct ena_com_dev *
 
 unsigned int ena_com_get_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_dev)
 {
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-
-	if (intr_moder_tbl)
-		return intr_moder_tbl[ENA_INTR_MODER_LOWEST].intr_moder_interval;
-
-	return 0;
+	return ena_dev->intr_moder_rx_interval;
 }
 
 void ena_com_init_intr_moderation_entry(struct ena_com_dev *ena_dev,
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 0d3664fe260d..baeefc6af4f3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -93,7 +93,7 @@
 #define ENA_INTR_HIGHEST_BYTES          (192 * 1024)
 
 #define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
-#define ENA_INTR_INITIAL_RX_INTERVAL_USECS		4
+#define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
 #define ENA_INTR_DELAY_OLD_VALUE_WEIGHT			6
 #define ENA_INTR_DELAY_NEW_VALUE_WEIGHT			4
 #define ENA_INTR_MODER_LEVEL_STRIDE			2
@@ -376,7 +376,13 @@ struct ena_com_dev {
 	struct ena_host_attribute host_attr;
 	bool adaptive_coalescing;
 	u16 intr_delay_resolution;
+
+	/* interrupt moderation intervals are in usec divided by
+	 * intr_delay_resolution, which is supplied by the device.
+	 */
 	u32 intr_moder_tx_interval;
+	u32 intr_moder_rx_interval;
+
 	struct ena_intr_moder_entry *intr_moder_tbl;
 
 	struct ena_com_llq_info llq_info;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 664e3ed97ea9..233b252ceb9e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3485,10 +3485,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
 	calc_queue_ctx.pdev = pdev;
 
-	/* initial Tx interrupt delay, Assumes 1 usec granularity.
+	/* Initial Tx and RX interrupt delay. Assumes 1 usec granularity.
 	* Updated during device initialization with the real granularity
 	*/
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
+	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
 	rc = ena_calc_queue_size(&calc_queue_ctx);
 	if (rc || io_queue_num <= 0) {
-- 
2.17.2

