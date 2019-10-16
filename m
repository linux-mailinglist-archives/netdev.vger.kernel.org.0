Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90C2D936A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393859AbfJPOLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:11:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59731 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731923AbfJPOLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 10:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1571235098; x=1602771098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WCHjHhMWtmw3SUZ1ZeiWQ8q/m1l8Nzjm1mtSLYDIUos=;
  b=toCERAJyHNc0HGr+BhAqtSqiEDJcQoHL5p7EIxBepkBo3WGrVWDwLXvV
   9/lVJHITRN+P9R/3b/mhdOcje0FbOJq+CuP6fjQk7zhQJWpgUpRWQDAqn
   6UrMQ4IaLvtPcdVr/XzpTDoJ2yyJeHHSfbiQxjCl6jjAvrfAQTr2NtWIX
   8=;
X-IronPort-AV: E=Sophos;i="5.67,304,1566864000"; 
   d="scan'208";a="759418122"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Oct 2019 14:11:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 449F5221CB8;
        Wed, 16 Oct 2019 14:11:36 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 16 Oct 2019 14:11:29 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 16 Oct 2019 14:11:29 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 16 Oct 2019 14:11:25 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V2 net-next v2 3/3] net: ena: Add first_interrupt field to napi struct
Date:   Wed, 16 Oct 2019 17:11:11 +0300
Message-ID: <20191016141111.5895-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016141111.5895-1-sameehj@amazon.com>
References: <20191016141111.5895-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The first_interrupt field is accessed in ena_intr_msix_io() upon
receiving an interrupt.The rx_ring and tx_ring fields of napi can
be NULL when receiving interrupt for xdp queues. This patch fixes
the issue by moving the field to the ena_napi struct.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 ++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5a90163fa..97b333d07 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1809,6 +1809,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
+	tx_ring->first_interrupt = ena_napi->first_interrupt;
+	rx_ring->first_interrupt = ena_napi->first_interrupt;
+
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -1880,8 +1883,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 {
 	struct ena_napi *ena_napi = data;
 
-	ena_napi->tx_ring->first_interrupt = true;
-	ena_napi->rx_ring->first_interrupt = true;
+	ena_napi->first_interrupt = true;
 
 	napi_schedule_irqoff(&ena_napi->napi);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index cb0804947..c666a9cac 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -168,6 +168,7 @@ struct ena_napi {
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	struct ena_ring *xdp_ring;
+	bool first_interrupt;
 	u32 qid;
 	struct dim dim;
 };
-- 
2.17.1

