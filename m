Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742F5B1622
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfILWKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:10 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:8406 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326209; x=1599862209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=soxZnBXLRJCmk9OwHbnzRQF+FTIpM5lb+lgg3KYK0VM=;
  b=Nl9HAnWYtwC5nY3R3WPotMHPk54gBJUODmEtDvspgXIAGjlYvUDC5T9c
   qS3xna90ejr9dQD68KuzIWo8Ft5PPm5wEGNlLm1fUiWjouKmgn8CHI2ZL
   ziSvhHErJGmL3+5KRfbFBWiDGBf9DocSXwr/aCuqreKS70mIhawbrt+CT
   U=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="750486920"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Sep 2019 22:10:07 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id C1F4AA0506;
        Thu, 12 Sep 2019 22:10:07 +0000 (UTC)
Received: from EX13D10UWA002.ant.amazon.com (10.43.160.228) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:49 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA002.ant.amazon.com (10.43.160.228) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:48 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:41 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 05/11] net: ena: remove code duplication in ena_com_update_nonadaptive_moderation_interval _*()
Date:   Fri, 13 Sep 2019 01:08:42 +0300
Message-ID: <1568326128-4057-6-git-send-email-akiyano@amazon.com>
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

Remove code duplication in:
ena_com_update_nonadaptive_moderation_interval_tx()
ena_com_update_nonadaptive_moderation_interval_rx()
functions.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index c9440abf6b95..ea859ecf664d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2773,32 +2773,34 @@ bool ena_com_interrupt_moderation_supported(struct ena_com_dev *ena_dev)
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

