Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E183F14CC08
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgA2OEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:46 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:48479 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgA2OEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306683; x=1611842683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zYDI4XR2Kh/hz7+cfR5mCzFs3lp52NBfpxwrEI3xIZ8=;
  b=bK7+D0i18X4VhUTV4WEErf7FHWJfIR5uwjxA0bHxP7uZwA0YV2GEF10Q
   6A+AZlkhvDNOAfGQxvlFNhF7uk7fWnMh7Pv/D/J1iY32XfwNyh6Sl2NRP
   /DYugY/T2loX0/8YhjII1y57dsvlmfL+mUPYijrpCdCPIeAe+h0+D46IJ
   o=;
IronPort-SDR: zasOZQMQfPAAHkLoxLeRfnTa7NWhiaXEdZ2Tp+6n1/UhrITKfEIAw53d35AkG+3fhq9Djpjz4o
 raUPgd6fp2nA==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="23166081"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 29 Jan 2020 14:04:28 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 77506A1BB0;
        Wed, 29 Jan 2020 14:04:26 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id AB5F481D10; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 08/11] net: ena: fix corruption of dev_idx_to_host_tbl
Date:   Wed, 29 Jan 2020 14:04:19 +0000
Message-ID: <20200129140422.20166-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200129140422.20166-1-sameehj@amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

The function ena_com_ind_tbl_convert_from_device() has an overflow
bug as explained below. Either way, this function is not needed at
all since we don't retrieve the indirection table from the device
at any point which means that this conversion is not needed.

The bug:
The for loop iterates over all io_sq_queues, when passing the actual
number of used queues the io_sq_queues[i].idx equals 0 since they are
uninitialized which results in the following code to be executed till
the end of the loop:

dev_idx_to_host_tbl[0] = i;

This results dev_idx_to_host_tbl[0] in being equal to
ENA_TOTAL_NUM_QUEUES - 1.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 28 -----------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 8bcf76f92..b05c3eb81 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1276,30 +1276,6 @@ static int ena_com_ind_tbl_convert_to_device(struct ena_com_dev *ena_dev)
 	return 0;
 }
 
-static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
-{
-	u16 dev_idx_to_host_tbl[ENA_TOTAL_NUM_QUEUES] = { (u16)-1 };
-	struct ena_rss *rss = &ena_dev->rss;
-	u8 idx;
-	u16 i;
-
-	for (i = 0; i < ENA_TOTAL_NUM_QUEUES; i++)
-		dev_idx_to_host_tbl[ena_dev->io_sq_queues[i].idx] = i;
-
-	for (i = 0; i < 1 << rss->tbl_log_size; i++) {
-		if (rss->rss_ind_tbl[i].cq_idx > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-		idx = (u8)rss->rss_ind_tbl[i].cq_idx;
-
-		if (dev_idx_to_host_tbl[idx] > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-
-		rss->host_rss_ind_tbl[i] = dev_idx_to_host_tbl[idx];
-	}
-
-	return 0;
-}
-
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
@@ -2641,10 +2617,6 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 	if (!ind_tbl)
 		return 0;
 
-	rc = ena_com_ind_tbl_convert_from_device(ena_dev);
-	if (unlikely(rc))
-		return rc;
-
 	for (i = 0; i < (1 << rss->tbl_log_size); i++)
 		ind_tbl[i] = rss->host_rss_ind_tbl[i];
 
-- 
2.24.1.AMZN

