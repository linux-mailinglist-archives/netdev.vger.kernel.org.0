Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BC03B3EB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389320AbfFJLTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:19:44 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:19895 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389311AbfFJLTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560165583; x=1591701583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nZIuSjEWtC+SM8G7Bt4wB1hQPYqVdGxIyon9Rc44MUw=;
  b=gRIjtDN0Nrptlp+qiuOsfKT82rHx8TNyx+UmnRxOiqQaJhloWkYErd/R
   Ai2Tnc7BC+y9sO/EQHEi7n4/AoSGwLyVPhwr4SvT7+XF8Ei61fXtyk+XI
   4OrF+3RXfb/B2mtbXrw+JGnHFepMqIEq3hbYQlOm+WNGTjYrPF8dyAzPD
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,575,1549929600"; 
   d="scan'208";a="400061897"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Jun 2019 11:19:42 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 2865DA1BE5;
        Mon, 10 Jun 2019 11:19:42 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:32 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:32 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 10 Jun 2019 11:19:29 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 3/6] net: ena: make ethtool show correct current and max queue sizes
Date:   Mon, 10 Jun 2019 14:19:15 +0300
Message-ID: <20190610111918.21397-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610111918.21397-1-sameehj@amazon.com>
References: <20190610111918.21397-1-sameehj@amazon.com>
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
index 5687a2860..f9152dfc9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -486,13 +486,11 @@ static void ena_get_ringparam(struct net_device *netdev,
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

