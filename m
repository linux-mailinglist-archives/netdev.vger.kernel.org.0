Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7662A39FBA8
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhFHQFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:05:46 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8777 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFHQFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168234; x=1654704234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A415yFAqN9g50l94CBe75wATOrItbmizWSGgfao8S9g=;
  b=ZTr9a7tXmS0IP4kjDqBCsYup0HT5lEerShv4bs+cX9Sfly8zRpn91TWH
   nFA/KNszbACle+CgeLttnxZlF15JmC0j6bx4g7hVDcvFmkDiZXp4dtCzF
   dB8mvCbhG1j+QP6ysOjHrt0vhXObEMN+lQxw8QzedOAezR7edGADd75dn
   E=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="117409485"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 08 Jun 2021 16:03:45 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id AC725A1DD3;
        Tue,  8 Jun 2021 16:03:43 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.93) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:03:35 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>, Ido Segev <idose@amazon.com>
Subject: [Patch v1 net-next 08/10] net: ena: aggregate doorbell common operations into a function
Date:   Tue, 8 Jun 2021 19:01:16 +0300
Message-ID: <20210608160118.3767932-9-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D43UWC003.ant.amazon.com (10.43.162.16) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena_ring_tx_doorbell() is introduced to call the doorbell and
increase the driver's corresponding stat.

Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 38 ++++++++++----------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6e648b6882b7..37c839401c6c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -86,6 +86,12 @@ static void ena_increase_stat(u64 *statp, u64 cnt,
 	u64_stats_update_end(syncp);
 }
 
+static void ena_ring_tx_doorbell(struct ena_ring *tx_ring)
+{
+	ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
+	ena_increase_stat(&tx_ring->tx_stats.doorbells, 1, &tx_ring->syncp);
+}
+
 static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
@@ -144,7 +150,7 @@ static int ena_xmit_common(struct net_device *dev,
 		netif_dbg(adapter, tx_queued, dev,
 			  "llq tx max burst size of queue %d achieved, writing doorbell to send burst\n",
 			  ring->qid);
-		ena_com_write_sq_doorbell(ring->ena_com_io_sq);
+		ena_ring_tx_doorbell(ring);
 	}
 
 	/* prepare the packet's descriptors to dma engine */
@@ -313,14 +319,12 @@ static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
 			     xdpf->len);
 	if (rc)
 		goto error_unmap_dma;
-	/* trigger the dma engine. ena_com_write_sq_doorbell()
-	 * has a mb
+
+	/* trigger the dma engine. ena_ring_tx_doorbell()
+	 * calls a memory barrier inside it.
 	 */
-	if (flags & XDP_XMIT_FLUSH) {
-		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
-		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
-				  &xdp_ring->syncp);
-	}
+	if (flags & XDP_XMIT_FLUSH)
+		ena_ring_tx_doorbell(xdp_ring);
 
 	return rc;
 
@@ -361,11 +365,8 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 	}
 
 	/* Ring doorbell to make device aware of the packets */
-	if (flags & XDP_XMIT_FLUSH) {
-		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
-		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
-				  &xdp_ring->syncp);
-	}
+	if (flags & XDP_XMIT_FLUSH)
+		ena_ring_tx_doorbell(xdp_ring);
 
 	spin_unlock(&xdp_ring->xdp_tx_lock);
 
@@ -3100,14 +3101,11 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	if (netif_xmit_stopped(txq) || !netdev_xmit_more()) {
-		/* trigger the dma engine. ena_com_write_sq_doorbell()
-		 * has a mb
+	if (netif_xmit_stopped(txq) || !netdev_xmit_more())
+		/* trigger the dma engine. ena_ring_tx_doorbell()
+		 * calls a memory barrier inside it.
 		 */
-		ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
-		ena_increase_stat(&tx_ring->tx_stats.doorbells, 1,
-				  &tx_ring->syncp);
-	}
+		ena_ring_tx_doorbell(tx_ring);
 
 	return NETDEV_TX_OK;
 
-- 
2.25.1

