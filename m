Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA0B3084
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbfIOO3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 10:29:54 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:48700 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfIOO3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 10:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568557792; x=1600093792;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Wzzi6esTUmqId8YNbXwEtWtASUgtx/C/B2/zDPECedk=;
  b=uU6Iga+lreOO86M85MYq2izTh7zfIgvS+95sN2snPxvp7vnPd1JuzHD3
   4nb/W6VpRDqVvJUdzC5QBRh20vAERd0Ps+WfXWX5oxP9UaX0huQNnKvxN
   SsMS1XE18sglLe8d85OYvdnwIczq9gG8xv5dT/vBH1KIr5enMHi6x/Y+E
   4=;
X-IronPort-AV: E=Sophos;i="5.64,509,1559520000"; 
   d="scan'208";a="832163756"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Sep 2019 14:29:51 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id BF9E9A1CB1;
        Sun, 15 Sep 2019 14:29:50 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 14:29:49 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 14:29:49 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 15 Sep 2019 14:29:46 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net] net: ena: don't wake up tx queue when down
Date:   Sun, 15 Sep 2019 17:29:44 +0300
Message-ID: <20190915142944.7572-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

There is a race condition that can occur when calling ena_down().
The ena_clean_tx_irq() - which is a part of the napi handler -
function might wake up the tx queue when the queue is supposed
to be down (during recovery or changing the size of the queues
for example) This causes the ena_start_xmit() function to trigger
and possibly try to access the destroyed queues.

The race is illustrated below:

Flow A:                                       Flow B(napi handler)
ena_down()
   netif_carrier_off()
   netif_tx_disable()
                                                      ena_clean_tx_irq()
                                                         netif_tx_wake_queue()
   ena_napi_disable_all()
   ena_destroy_all_io_queues()

After these flows the tx queue is active and ena_start_xmit() accesses
the destroyed queue which leads to a kernel panic.

fixes: 1738cd3ed342 (net: ena: Add a driver for Amazon Elastic Network Adapters (ENA))

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 664e3ed97..d118ed4c5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -823,7 +823,8 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 		above_thresh =
 			ena_com_sq_have_enough_space(tx_ring->ena_com_io_sq,
 						     ENA_TX_WAKEUP_THRESH);
-		if (netif_tx_queue_stopped(txq) && above_thresh) {
+		if (netif_tx_queue_stopped(txq) && above_thresh &&
+		    test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags)) {
 			netif_tx_wake_queue(txq);
 			u64_stats_update_begin(&tx_ring->syncp);
 			tx_ring->tx_stats.queue_wakeup++;
-- 
2.17.1

