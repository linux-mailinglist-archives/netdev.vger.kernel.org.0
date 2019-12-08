Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBC116335
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 18:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLHRav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 12:30:51 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:63106 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfLHRau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 12:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575826250; x=1607362250;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=amnTVPLpG+g5d7QhSVBfr6lXN7L+K57j1m3v+yHMVnE=;
  b=FzOQQRkFUEaQBGeqd1wqMDkUpa24skE/phqYCmZz3r8q/VUAjZx2MZgG
   h2znfYvH3bdK2ZGkyl61A5yaCW3fTNNsee9fqmRee4iLZkJWnAh9GFMJw
   IppvECCx9uKx0KoygAEms40faeN3Sc0G5YUZhMqWvX3l2ZkmjjuEwE6lw
   o=;
IronPort-SDR: EHjVOLbQmRttrxinP1JXKhr6cSO1cqO4MsAH5a6SqsrhhWkUG72/xHaALBlj0XyuoHfjH3LDr3
 o10N3cLH/DSw==
X-IronPort-AV: E=Sophos;i="5.69,292,1571702400"; 
   d="scan'208";a="6677531"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 08 Dec 2019 17:30:45 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 2E1B2A253F;
        Sun,  8 Dec 2019 17:30:44 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Dec 2019 17:30:43 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Dec 2019 17:30:43 +0000
Received: from dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (172.19.37.7)
 by mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 8 Dec 2019 17:30:43 +0000
Received: by dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (Postfix, from userid 3129586)
        id 2B7E4193; Sun,  8 Dec 2019 17:30:42 +0000 (UTC)
From:   Netanel Belgazal <netanel@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Netanel Belgazal <netanel@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>
Subject: [PATCH V1 net] net: ena: fix napi handler misbehavior when the napi budget is zero
Date:   Sun, 8 Dec 2019 17:30:26 +0000
Message-ID: <20191208173026.25745-1-netanel@amazon.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In netpoll the napi handler could be called with budget equal to zero.
Current ENA napi handler doesn't take that into consideration.

The napi handler handles Rx packets in a do-while loop.
Currently, the budget check happens only after decrementing the
budget, therefore the napi handler, in rare cases, could run over
MAX_INT packets.

In addition to that, this moves all budget related variables to int
calculation and stop mixing u32 to avoid ambiguity

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index c487d2a7d6dd..b4a145220aba 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1238,8 +1238,8 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	struct ena_napi *ena_napi = container_of(napi, struct ena_napi, napi);
 	struct ena_ring *tx_ring, *rx_ring;
 
-	u32 tx_work_done;
-	u32 rx_work_done;
+	int tx_work_done;
+	int rx_work_done = 0;
 	int tx_budget;
 	int napi_comp_call = 0;
 	int ret;
@@ -1256,7 +1256,11 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	}
 
 	tx_work_done = ena_clean_tx_irq(tx_ring, tx_budget);
-	rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
+	/* On netpoll the budget is zero and the handler should only clean the
+	 * tx completions.
+	 */
+	if (likely(budget))
+		rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
 
 	/* If the device is about to reset or down, avoid unmask
 	 * the interrupt and return 0 so NAPI won't reschedule
-- 
2.17.2

