Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3396118646
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfLJL2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:28:00 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:35897 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfLJL17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575977278; x=1607513278;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Jcc+vsX75orkj6hyZNRtYxlsDe0KdfWHqBuKxaWANsU=;
  b=fEadFBYh2EUVe2OYfJrQBepIBsz6Gjy24ptxHCkApPvfpnUX5xkhkxFL
   GH2K2F9TFbWe53HS2oMeVNNozDDTtP3cnqtmWsu/rwzD+/qJgMUTnH1uD
   zwFujlRzuGxWQdostAbkR+Ci2RYwMVHQqNmAm2Dn2YHb0B2xViqb402kb
   k=;
IronPort-SDR: JAOugIfCPaIZGKmpavjEcZu8soj+ynwJUAXgmG6juvqr6sSXh3O8cFhHwaKah/c71TAF+WeCCp
 Q/yZ3xKD5Dfg==
X-IronPort-AV: E=Sophos;i="5.69,299,1571702400"; 
   d="scan'208";a="8407609"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Dec 2019 11:27:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 6F3F0A1842;
        Tue, 10 Dec 2019 11:27:56 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 11:27:56 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 11:27:54 +0000
Received: from dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (172.19.37.7)
 by mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:27:54 +0000
Received: by dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (Postfix, from userid 3129586)
        id 4A559BF; Tue, 10 Dec 2019 11:27:53 +0000 (UTC)
From:   Netanel Belgazal <netanel@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Netanel Belgazal <netanel@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>
Subject: [PATCH V2 net] net: ena: fix napi handler misbehavior when the napi budget is zero
Date:   Tue, 10 Dec 2019 11:27:44 +0000
Message-ID: <20191210112744.6301-1-netanel@amazon.com>
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
Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
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

