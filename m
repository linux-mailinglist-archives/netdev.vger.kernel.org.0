Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F573487DA5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiAGUYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:13 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:64474 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiAGUYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587049; x=1673123049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TQ/xj/DcwZj9ynpc1UeQfimXlDdnslNFaP/0vahuUHI=;
  b=ZXvd7pshYq7s6tOYoBzz3Fe5SA7GOhEHMAYEw/cEDtN3CktSrRoGbzjR
   n3zsPVzjTr4UlwxjX67Sa0OnIOzo5XfnZVnn3ywwqc4h/nvBdOl3DzZKw
   9CocP56HXJ8FFZQ2BfztzM7x1NkkPG0cLASpfPG8jL8ZiaVRdZeSOwY4t
   s=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="53547249"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 07 Jan 2022 20:23:55 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id CC7C71A00B9;
        Fri,  7 Jan 2022 20:23:54 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:53 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:53 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:23:52 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V2 net-next 01/10] net: ena: Change return value of ena_calc_io_queue_size() to void
Date:   Fri, 7 Jan 2022 20:23:37 +0000
Message-ID: <20220107202346.3522-2-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ena_calc_io_queue_size() always returns 0, therefore make it a
void function and update the calling function to stop checking
the return value.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 05cadc4e66e0..78770984ec95 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4146,7 +4146,7 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 }
 
 
-static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
+static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 {
 	struct ena_admin_feature_llq_desc *llq = &ctx->get_feat_ctx->llq;
 	struct ena_com_dev *ena_dev = ctx->ena_dev;
@@ -4208,8 +4208,6 @@ static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 	ctx->max_rx_queue_size = max_rx_queue_size;
 	ctx->tx_queue_size = tx_queue_size;
 	ctx->rx_queue_size = rx_queue_size;
-
-	return 0;
 }
 
 /* ena_probe - Device Initialization Routine
@@ -4320,8 +4318,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	rc = ena_calc_io_queue_size(&calc_queue_ctx);
-	if (rc || !max_num_io_queues) {
+	ena_calc_io_queue_size(&calc_queue_ctx);
+	if (unlikely(!max_num_io_queues)) {
 		rc = -EFAULT;
 		goto err_device_destroy;
 	}
-- 
2.32.0

