Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8294C4960
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfJBIV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:21:29 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50263 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfJBIV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570004488; x=1601540488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ETNoVm/41DkpMwoTtztpjFcb9Yd2jPEoveAieIZWcug=;
  b=uyLTsk4AOuFIbo5LAqacX8vUEDagOM2Po3V40KwX6Xynsuw7Paa94VNs
   ENBL4AmZfVCbfN8LLxcbSZimU4YgGWZIhLV4uU4+htfx72OblAZcySr/p
   rwFpSBzi+olcI6/KYZ5WurKqFLqb9mJpKhJuFGGU4IL+jdTaPdmmZXM6B
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,573,1559520000"; 
   d="scan'208";a="789041974"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Oct 2019 08:21:25 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 17F61A1DCC;
        Wed,  2 Oct 2019 08:21:25 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:15 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:15 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 2 Oct 2019 08:21:12 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels callback
Date:   Wed, 2 Oct 2019 11:20:52 +0300
Message-ID: <20191002082052.14051-6-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002082052.14051-1-sameehj@amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Set channels callback enables the user to change the count of queues
used by the driver using ethtool. We decided to currently support only
equal number of rx and tx queues, this might change in the future.

Also rename dev_up to dev_was_up in ena_update_queue_count() to make
it clearer.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 17 ++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 22 ++++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  3 +++
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index c9d760465..f58fc3c68 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -744,6 +744,22 @@ static void ena_get_channels(struct net_device *netdev,
 	channels->combined_count = 0;
 }
 
+static int ena_set_channels(struct net_device *netdev,
+			    struct ethtool_channels *channels)
+{
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	u32 new_channel_count;
+
+	if (channels->rx_count != channels->tx_count ||
+	    channels->max_tx != channels->max_rx)
+		return -EINVAL;
+
+	new_channel_count = clamp_val(channels->tx_count,
+				      ENA_MIN_NUM_IO_QUEUES, channels->max_tx);
+
+	return ena_update_queue_count(adapter, new_channel_count);
+}
+
 static int ena_get_tunable(struct net_device *netdev,
 			   const struct ethtool_tunable *tuna, void *data)
 {
@@ -807,6 +823,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_rxfh		= ena_get_rxfh,
 	.set_rxfh		= ena_set_rxfh,
 	.get_channels		= ena_get_channels,
+	.set_channels		= ena_set_channels,
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
 };
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e964783c4..7d44b3440 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2044,14 +2044,30 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size)
 {
-	bool dev_up;
+	bool dev_was_up;
 
-	dev_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 	ena_close(adapter->netdev);
 	adapter->requested_tx_ring_size = new_tx_size;
 	adapter->requested_rx_ring_size = new_rx_size;
 	ena_init_io_rings(adapter);
-	return dev_up ? ena_up(adapter) : 0;
+	return dev_was_up ? ena_up(adapter) : 0;
+}
+
+int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	bool dev_was_up;
+
+	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
+	ena_close(adapter->netdev);
+	adapter->num_io_queues = new_channel_count;
+       /* We need to destroy the rss table so that the indirection
+	* table will be reinitialized by ena_up()
+	*/
+	ena_com_rss_destroy(ena_dev);
+	ena_init_io_rings(adapter);
+	return dev_was_up ? ena_open(adapter->netdev) : 0;
 }
 
 static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 7499afb58..bffd778f2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -82,6 +82,8 @@
 #define ENA_DEFAULT_RING_SIZE	(1024)
 #define ENA_MIN_RING_SIZE	(256)
 
+#define ENA_MIN_NUM_IO_QUEUES	(1)
+
 #define ENA_TX_WAKEUP_THRESH		(MAX_SKB_FRAGS + 2)
 #define ENA_DEFAULT_RX_COPYBREAK	(256 - NET_IP_ALIGN)
 
@@ -388,6 +390,7 @@ void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 int ena_update_queue_sizes(struct ena_adapter *adapter,
 			   u32 new_tx_size,
 			   u32 new_rx_size);
+int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
-- 
2.17.1

