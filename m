Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCDBA1265EC
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLSPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:41:22 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50198 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLSPlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576770081; x=1608306081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oTyk/LS7mEYZnFXqntCIN70mkHozaXfwZmp4u0+qPtg=;
  b=KlqXZm6qVjRZZi0d+JCsHxIPhpBsipjND2TGtyI7jsjqGZAFtt1KP2eU
   uHQZWWz1w7c6957xVKFE0V9Icm6T67SjJx0AMtWavmRYCwqo0kYyEMcJD
   7I06QnasdoROzSjwRcN4hKE9fRfEfuyjMLi4BHDYCy7hrSqu5FDIZvU0m
   w=;
IronPort-SDR: lIgAPmmLL6/kLH7t7NxlxQke8xA1H62jWuphtIUoJBqJjI8sgbaz9zKm/V6sVM4i720130PFxg
 4J9P7Yg1H+Pg==
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="15859695"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Dec 2019 15:41:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 69656A24DA;
        Thu, 19 Dec 2019 15:41:08 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:07 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.74) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Dec 2019 15:41:03 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 1/2] net: ena: fix default tx interrupt moderation interval
Date:   Thu, 19 Dec 2019 17:40:55 +0200
Message-ID: <1576770056-1304-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
References: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Current default non-adaptive tx interrupt moderation interval is 196 us.
This value is too high and might cause the tx queue to fill up.

In this commit we set the default non-adaptive tx interrupt moderation
interval to 64 us in order to:
1. Reduce the probability of the queue filling-up (when compared to the
   current default value of 196 us).
2. Reduce unnecessary tx interrupt overhead (which happens if we set the
   default tx interval to 0).
   We determined experimentally that 64 us is an optimal value that
   reduces interrupt rate by more than 20% without affecting performance.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 7c941eb..0ce37d5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -72,7 +72,7 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
+#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		64
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
 #define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
 
-- 
2.7.4

