Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3377037F6FE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhEMLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhEMLox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:44:53 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91918C061763;
        Thu, 13 May 2021 04:43:42 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lh9kb-0007HF-BQ; Thu, 13 May 2021 14:43:33 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v2 2/5] atl1c: improve performance by avoiding unnecessary pcie writes on xmit
Date:   Thu, 13 May 2021 14:43:23 +0300
Message-Id: <20210513114326.699663-3-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513114326.699663-1-gatis@mikrotik.com>
References: <20210513114326.699663-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel has xmit_more facility that hints the networking driver xmit
path about whether more packets are coming soon. This information can be
used to avoid unnecessary expensive PCIe transaction per tx packet.

Max TX pps on Mikrotik 10/25G NIC in a Threadripper 3960X system
improved from 1150Kpps to 1700Kpps.

Testing L2 forwarding on AR8151 hardware did not reveal a measurable
increase in latency.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 28c30d5288e4..08a0f49e03ce 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2211,8 +2211,8 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	return -1;
 }
 
-static void atl1c_tx_queue(struct atl1c_adapter *adapter, struct sk_buff *skb,
-			   struct atl1c_tpd_desc *tpd, enum atl1c_trans_queue type)
+static void atl1c_tx_queue(struct atl1c_adapter *adapter,
+			   enum atl1c_trans_queue type)
 {
 	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
 	u16 reg;
@@ -2238,6 +2238,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 
 	if (atl1c_tpd_avail(adapter, type) < tpd_req) {
 		/* no enough descriptor, just stop queue */
+		atl1c_tx_queue(adapter, type);
 		netif_stop_queue(netdev);
 		return NETDEV_TX_BUSY;
 	}
@@ -2246,6 +2247,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 
 	/* do TSO and check sum */
 	if (atl1c_tso_csum(adapter, skb, &tpd, type) != 0) {
+		atl1c_tx_queue(adapter, type);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -2270,8 +2272,10 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 		atl1c_tx_rollback(adapter, tpd, type);
 		dev_kfree_skb_any(skb);
 	} else {
-		netdev_sent_queue(adapter->netdev, skb->len);
-		atl1c_tx_queue(adapter, skb, tpd, type);
+		bool more = netdev_xmit_more();
+
+		if (__netdev_sent_queue(adapter->netdev, skb->len, more))
+			atl1c_tx_queue(adapter, type);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.31.1

