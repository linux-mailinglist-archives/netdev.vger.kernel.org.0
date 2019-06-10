Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538E83B3EE
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbfFJLTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:19:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:39773 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389335AbfFJLTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560165589; x=1591701589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aJ8z+RcuVS4+gUyfd0kSXkTtpbNRzMRYpZrNaKtrX8k=;
  b=meteP95V1mGqQhpc09lvynJdpgHWCxOiJtDxPaY9N4Zkbs4LwhR9CXnR
   xEuskWCfbcED+EUsBYGBqgeibZwxeNkJEvUYtAKsnUTD3uWbC1yEOJWHE
   exvuvqaW2GemKZnMXSUdg5Fl30bHWBuhfJxtaIVC/+mPkQmi4Odyo2zK9
   I=;
X-IronPort-AV: E=Sophos;i="5.60,575,1549929600"; 
   d="scan'208";a="405749966"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jun 2019 11:19:48 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 8E924A053A;
        Mon, 10 Jun 2019 11:19:47 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:38 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:38 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 10 Jun 2019 11:19:35 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 5/6] net: ena: add ethtool function for changing io queue sizes
Date:   Mon, 10 Jun 2019 14:19:17 +0300
Message-ID: <20190610111918.21397-6-sameehj@amazon.com>
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

Implement the set_ringparam() function of the ethtool interface
to enable the changing of io queue sizes.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 25 +++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 14 +++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  5 +++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d34eca8a3..ed07b6d90 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -493,6 +493,30 @@ static void ena_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = adapter->rx_ring[0].ring_size;
 }
 
+static int ena_set_ringparam(struct net_device *netdev,
+			     struct ethtool_ringparam *ring)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	u32 new_tx_size, new_rx_size;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	new_tx_size = clamp_val(ring->tx_pending, ENA_MIN_RING_SIZE,
+				adapter->max_tx_ring_size);
+	new_tx_size = rounddown_pow_of_two(new_tx_size);
+
+	new_rx_size = clamp_val(ring->rx_pending, ENA_MIN_RING_SIZE,
+				adapter->max_rx_ring_size);
+	new_rx_size = rounddown_pow_of_two(new_rx_size);
+
+	if (new_tx_size == adapter->requested_tx_ring_size &&
+	    new_rx_size == adapter->requested_rx_ring_size)
+		return 0;
+
+	return ena_update_queue_sizes(adapter, new_tx_size, new_rx_size);
+}
+
 static u32 ena_flow_hash_to_flow_type(u16 hash_fields)
 {
 	u32 data = 0;
@@ -858,6 +882,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_coalesce		= ena_get_coalesce,
 	.set_coalesce		= ena_set_coalesce,
 	.get_ringparam		= ena_get_ringparam,
+	.set_ringparam		= ena_set_ringparam,
 	.get_sset_count         = ena_get_sset_count,
 	.get_strings		= ena_get_strings,
 	.get_ethtool_stats      = ena_get_ethtool_stats,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 938aca254..4b21b6046 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2031,6 +2031,20 @@ static int ena_close(struct net_device *netdev)
 	return 0;
 }
 
+int ena_update_queue_sizes(struct ena_adapter *adapter,
+			   u32 new_tx_size,
+			   u32 new_rx_size)
+{
+	bool dev_up;
+
+	dev_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+	ena_close(adapter->netdev);
+	adapter->requested_tx_ring_size = new_tx_size;
+	adapter->requested_rx_ring_size = new_rx_size;
+	ena_init_io_rings(adapter);
+	return dev_up ? ena_up(adapter) : 0;
+}
+
 static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct sk_buff *skb)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index e8fe08cb7..b9d590879 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -81,7 +81,6 @@
 #define ENA_DEFAULT_RING_SIZE	(1024)
 #define ENA_MIN_RING_SIZE	(256)
 
-
 #define ENA_TX_WAKEUP_THRESH		(MAX_SKB_FRAGS + 2)
 #define ENA_DEFAULT_RX_COPYBREAK	(256 - NET_IP_ALIGN)
 
@@ -389,6 +388,10 @@ void ena_dump_stats_to_dmesg(struct ena_adapter *adapter);
 
 void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 
+int ena_update_queue_sizes(struct ena_adapter *adapter,
+			   u32 new_tx_size,
+			   u32 new_rx_size);
+
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
 #endif /* !(ENA_H) */
-- 
2.17.1

