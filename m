Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB067B395A
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfIPLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:14 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:31707 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbfIPLcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633532; x=1600169532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DkpM2YbWvMehO/4gktnsu85KJs7t+2bwsruqMVNdGkc=;
  b=Ap7CKHbYhbb2Zd3Z2JFQKmQpzTMH9JBKdf6gjjpAan9Kvz/QT3RgPon7
   lP7/H9ZgkRbvIGPLT4v4xFr7ZEkDylG9VvP9dVwOYBIxdOERnefWrYPch
   duc6hJAt7JoFuEtJq8NfA1QFiSV05TKz9VQoyAOwR9w47ReMBnSq9fN5q
   g=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="750940069"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Sep 2019 11:32:12 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 2F7FFA1D4C;
        Mon, 16 Sep 2019 11:32:11 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:58 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:58 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:55 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 05/11] net: ena: remove code duplication in ena_com_update_nonadaptive_moderation_interval _*()
Date:   Mon, 16 Sep 2019 14:31:30 +0300
Message-ID: <1568633496-4143-6-git-send-email-akiyano@amazon.com>
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

Remove code duplication in:
ena_com_update_nonadaptive_moderation_interval_tx()
ena_com_update_nonadaptive_moderation_interval_rx()
functions.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index f3c67c27c19c..bbb59fd220a1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2772,32 +2772,34 @@ bool ena_com_interrupt_moderation_supported(struct ena_com_dev *ena_dev)
 						  ENA_ADMIN_INTERRUPT_MODERATION);
 }
 
-int ena_com_update_nonadaptive_moderation_interval_tx(struct ena_com_dev *ena_dev,
-						      u32 tx_coalesce_usecs)
+static int ena_com_update_nonadaptive_moderation_interval(u32 coalesce_usecs,
+							  u32 intr_delay_resolution,
+							  u32 *intr_moder_interval)
 {
-	if (!ena_dev->intr_delay_resolution) {
+	if (!intr_delay_resolution) {
 		pr_err("Illegal interrupt delay granularity value\n");
 		return -EFAULT;
 	}
 
-	ena_dev->intr_moder_tx_interval = tx_coalesce_usecs /
-		ena_dev->intr_delay_resolution;
+	*intr_moder_interval = coalesce_usecs / intr_delay_resolution;
 
 	return 0;
 }
 
+int ena_com_update_nonadaptive_moderation_interval_tx(struct ena_com_dev *ena_dev,
+						      u32 tx_coalesce_usecs)
+{
+	return ena_com_update_nonadaptive_moderation_interval(tx_coalesce_usecs,
+							      ena_dev->intr_delay_resolution,
+							      &ena_dev->intr_moder_tx_interval);
+}
+
 int ena_com_update_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_dev,
 						      u32 rx_coalesce_usecs)
 {
-	if (!ena_dev->intr_delay_resolution) {
-		pr_err("Illegal interrupt delay granularity value\n");
-		return -EFAULT;
-	}
-
-	ena_dev->intr_moder_rx_interval = rx_coalesce_usecs /
-		ena_dev->intr_delay_resolution;
-
-	return 0;
+	return ena_com_update_nonadaptive_moderation_interval(rx_coalesce_usecs,
+							      ena_dev->intr_delay_resolution,
+							      &ena_dev->intr_moder_rx_interval);
 }
 
 void ena_com_destroy_interrupt_moderation(struct ena_com_dev *ena_dev)
-- 
2.17.2

