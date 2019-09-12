Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96B5B1629
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfILWLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:11:03 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58453 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326262; x=1599862262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3uaquGDOT/ehx9KEfhDmtdX3DhN47FxPNksAgs+Gca4=;
  b=DjWH/R5YEjliOO4Pw1iTQduUSmSQxyeJ+RUjEpnq2cAjVvfkRR7gXLCz
   Kgqkg0Nd+w4Uxul6GXheocNWX0sUF8t0T+DuMhV9bwXl0pJVWe5Cx/IqE
   M+TvisKbe3AornLnb00pWfHx9c4fy7dWzltxSZGxhvYijbgi+thXTGqoU
   8=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="784692894"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Sep 2019 22:11:01 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 85F94A203E;
        Thu, 12 Sep 2019 22:11:01 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:38 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:37 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:10:31 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 11/11] net: ena: fix incorrect update of intr_delay_resolution
Date:   Fri, 13 Sep 2019 01:08:48 +0300
Message-ID: <1568326128-4057-12-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_com.c    | 22 +++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_com.h    |  1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index c3f4846aa845..ea62604fdf8c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,18 +1281,30 @@ static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
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
-
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
index 617f51890449..25f70a59d42f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3501,6 +3501,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	*/
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
+	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
 	rc = ena_calc_queue_size(&calc_queue_ctx);
 	if (rc || io_queue_num <= 0) {
-- 
2.17.2

