Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF38B3966
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbfIPLdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:33:11 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:37095 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731539AbfIPLdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633589; x=1600169589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EbhW/2qd3ZAZAO57MtDkSSObM4GtRXBafDCSXd6Fm+w=;
  b=FbKC5aqKEM+xqgr9IcAXfQIwN2QuYTanQIgNG065siLiN4uEI5ObPgEQ
   OT3qS3ns5nQGk5C6qbfIejDPo5vw2ZhSAN4AdWPfkJKJY5U6GO4M6STHr
   qjR6u4Q57pd4fFGhRrrYHn0fQgw9klYgImdKPqrVSCY5lg8aRnhmZTTxy
   0=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="702600996"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Sep 2019 11:32:55 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 345C5A21C3;
        Mon, 16 Sep 2019 11:32:39 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:18 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:18 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:32:15 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 11/11] net: ena: fix incorrect update of intr_delay_resolution
Date:   Mon, 16 Sep 2019 14:31:36 +0300
Message-ID: <1568633496-4143-12-git-send-email-akiyano@amazon.com>
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

ena_dev->intr_moder_rx/tx_interval save the intervals received from the
user after dividing them by ena_dev->intr_delay_resolution. Therefore
when intr_delay_resolution changes, the code needs to first mutiply
intr_moder_rx/tx_interval by the previous intr_delay_resolution to get
the value originally given by the user, and only then divide it by the
new intr_delay_resolution.

Current code does not first multiply intr_moder_rx/tx_interval by the old
intr_delay_resolution. This commit fixes it.

Also initialize ena_dev->intr_delay_resolution to be 1.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    | 21 ++++++++++++++++----
 drivers/net/ethernet/amazon/ena/ena_com.h    |  1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 621b747f062b..ea62604fdf8c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,17 +1281,30 @@ static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
+	/* Initial value of intr_delay_resolution might be 0 */
+	u16 prev_intr_delay_resolution =
+		ena_dev->intr_delay_resolution ?
+		ena_dev->intr_delay_resolution :
+		ENA_DEFAULT_INTR_DELAY_RESOLUTION;
+
 	if (!intr_delay_resolution) {
 		pr_err("Illegal intr_delay_resolution provided. Going to use default 1 usec resolution\n");
-		intr_delay_resolution = 1;
+		intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	}
-	ena_dev->intr_delay_resolution = intr_delay_resolution;
 
 	/* update Rx */
-	ena_dev->intr_moder_rx_interval /= intr_delay_resolution;
+	ena_dev->intr_moder_rx_interval =
+		ena_dev->intr_moder_rx_interval *
+		prev_intr_delay_resolution /
+		intr_delay_resolution;
 
 	/* update Tx */
-	ena_dev->intr_moder_tx_interval /= intr_delay_resolution;
+	ena_dev->intr_moder_tx_interval =
+		ena_dev->intr_moder_tx_interval *
+		prev_intr_delay_resolution /
+		intr_delay_resolution;
+
+	ena_dev->intr_delay_resolution = intr_delay_resolution;
 }
 
 /*****************************************************************************/
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index ddc2a8c50333..7c941eba0bc9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -74,6 +74,7 @@
 
 #define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
+#define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
 
 #define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 54539e57aa73..e4bf7a4af87a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3500,6 +3500,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	*/
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
+	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
 	rc = ena_calc_queue_size(&calc_queue_ctx);
 	if (rc || io_queue_num <= 0) {
-- 
2.17.2

