Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621011592C4
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbgBKPSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:22 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:2052 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgBKPSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434301; x=1612970301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d7EkEPpul5d9WP4/P7XzSZcV5qlndQVvPOtItuRE6iY=;
  b=f5sMIi61ZDxLORmxpRDFV/KlH1gpUvW8esMuiQvtI5dCdP55UicvuGsk
   Z0gSJMuvlidmsUmN5oRYbCn3g0viF7La1Zytn275gz/GWKPTQRKBDG/bF
   h9QDM8lFd8j5qCS3mwGVxFCNQ1Qo85TB4ZlQwO4xas3GGg2dalKzyBd8U
   0=;
IronPort-SDR: Q0/ga3vTK5w5ZKES64Pqhdgb02aQycW/AA7Y7ZrbbAjLb2x3z1KxXW2gMYs/BJ6qwyTFQH7XhH
 5Tg9IEkuTi2g==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="15757272"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 11 Feb 2020 15:17:59 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 96BF41417F2;
        Tue, 11 Feb 2020 15:17:58 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id B6AD681D41; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 09/12] net: ena: fix corruption of dev_idx_to_host_tbl
Date:   Tue, 11 Feb 2020 15:17:48 +0000
Message-ID: <20200211151751.29718-10-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
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
index 8ab192cb2..74743fd8a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,30 +1281,6 @@ static int ena_com_ind_tbl_convert_to_device(struct ena_com_dev *ena_dev)
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
@@ -2638,10 +2614,6 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
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

