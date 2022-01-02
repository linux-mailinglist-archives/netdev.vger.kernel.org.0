Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03E2482A82
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiABHhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:37:50 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:30488 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641109070; x=1672645070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bxbi6GFPqcEsD2sjNyh0mXTdHWX+xJAD8x+ASmfo+zo=;
  b=Gxpm0PEB1ne1IiEVB0QI1EzjHp17UxNnpMNqDacdz529Oa9cUQmU748C
   lNEPc8l1dnxgqvISs5RXpX6PEbmPW68aHrVxq5Nf1uqt1b87rqHKdNgYS
   qNP0QTpHIEUbJnd/zx6eed58Fo2fujcRvpxriNyQk+Qy+KJoaAtEp9Loa
   g=;
X-IronPort-AV: E=Sophos;i="5.88,255,1635206400"; 
   d="scan'208";a="162563218"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 02 Jan 2022 07:37:39 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id A0BF49268D;
        Sun,  2 Jan 2022 07:37:38 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:38 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:37 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Sun, 2 Jan 2022 07:37:36 +0000
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
Subject: [PATCH V2 net 2/3] net: ena: Fix wrong rx request id by resetting device
Date:   Sun, 2 Jan 2022 07:37:27 +0000
Message-ID: <20220102073728.12242-3-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220102073728.12242-1-akiyano@amazon.com>
References: <20220102073728.12242-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A wrong request id received from the device is a sign that
something is wrong with it, therefore trigger a device reset.

Also add some debug info to the "Page is NULL" print to make
it easier to debug.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2274063e34cc..52a8c60b7e29 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1428,6 +1428,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 				  u16 *next_to_clean)
 {
 	struct ena_rx_buffer *rx_info;
+	struct ena_adapter *adapter;
 	u16 len, req_id, buf = 0;
 	struct sk_buff *skb;
 	void *page_addr;
@@ -1440,8 +1441,14 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
-		netif_err(rx_ring->adapter, rx_err, rx_ring->netdev,
-			  "Page is NULL\n");
+		adapter = rx_ring->adapter;
+		netif_err(adapter, rx_err, rx_ring->netdev,
+			  "Page is NULL. qid %u req_id %u\n", rx_ring->qid, req_id);
+		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1, &rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+		/* Make sure reset reason is set before triggering the reset */
+		smp_mb__before_atomic();
+		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 		return NULL;
 	}
 
-- 
2.32.0

