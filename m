Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF43F37392
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfFFLzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:55:46 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:25477 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFLzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559822145; x=1591358145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rupOvGvjPYlMnmIuSW/iAdq3amBrZKOsrGqnC2/P1ss=;
  b=ntM/F9WuQfJQOTabSCiDvDCs/AwSlox46uI8baGh/ongEOqmSnHsQRQS
   CyIjZwOHVphaqOnCcoTjl7opFxd0ka3t/sDDDYzGEIUdFWeKTArDx0XLy
   eXZO6S/dpmYPotiy+mKoEdeIjRSXYIaiwnzAv8cb2qhhKllymPZED7dan
   g=;
X-IronPort-AV: E=Sophos;i="5.60,559,1549929600"; 
   d="scan'208";a="808940041"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Jun 2019 11:55:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 2BE45A240F;
        Thu,  6 Jun 2019 11:55:45 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:40 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:39 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 6 Jun 2019 11:55:36 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 3/6] net: ena: make ethtool show correct current and max queue sizes
Date:   Thu, 6 Jun 2019 14:55:17 +0300
Message-ID: <20190606115520.20394-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606115520.20394-1-sameehj@amazon.com>
References: <20190606115520.20394-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Currently ethtool -g shows the same size for current and max queue
sizes.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 10 ++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 ++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 878546a48..62915ad82 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -488,13 +488,11 @@ static void ena_get_ringparam(struct net_device *netdev,
 			      struct ethtool_ringparam *ring)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
-	struct ena_ring *tx_ring = &adapter->tx_ring[0];
-	struct ena_ring *rx_ring = &adapter->rx_ring[0];
 
-	ring->rx_max_pending = rx_ring->ring_size;
-	ring->tx_max_pending = tx_ring->ring_size;
-	ring->rx_pending = rx_ring->ring_size;
-	ring->tx_pending = tx_ring->ring_size;
+	ring->tx_max_pending = adapter->max_tx_ring_size;
+	ring->rx_max_pending = adapter->max_rx_ring_size;
+	ring->tx_pending = adapter->tx_ring_size;
+	ring->rx_pending = adapter->rx_ring_size;
 }
 
 static u32 ena_flow_hash_to_flow_type(u16 hash_fields)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index ba5d580e5..3fe4a9217 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3438,6 +3438,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->tx_ring_size = calc_queue_ctx.tx_queue_size;
 	adapter->rx_ring_size = calc_queue_ctx.rx_queue_size;
+	adapter->max_tx_ring_size = calc_queue_ctx.max_tx_queue_size;
+	adapter->max_rx_ring_size = calc_queue_ctx.max_rx_queue_size;
 	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
 	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
 
-- 
2.17.1

