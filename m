Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052474F156B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbiDDNGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbiDDNGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:06:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822F33E5C2;
        Mon,  4 Apr 2022 06:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649077447; x=1680613447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s4YbeJjstt/yKOMGM1Xu3rmFy5geRTn14sYFJKh3pmw=;
  b=NXeKp71C8XltyR0Ba03VZ3UzSRkzjA2rIjL7hOnNrGHk/fjpnyaRVn1f
   tIMgfJTbmaTaYSVVzRWKPLhuBnro/8AJz17NxCzZ58Kj0r66UOg5sXbQj
   xOKz5IPS+lBY8ujpPGKpUKPbp3BtCZ+35EkqpgEP1h6RvDdGPAn/Y8n4b
   oEyvr+DfyM3bF1AEeA64HRX1WxxJaqWa7hqzGuwGcItWErweiYXyGerRz
   +c6QU7eCNGQOGK9oWdhHFXvru8fzg8Iv/gNHZlBipikiFIQISfV0WmD1q
   ZhDb4jif6yvEub6ycQpSJHepsGeDlivIChD5gWOr2YY4KmV1rufv4XIUo
   A==;
X-IronPort-AV: E=Sophos;i="5.90,234,1643698800"; 
   d="scan'208";a="154281326"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2022 06:04:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Apr 2022 06:04:06 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 4 Apr 2022 06:04:04 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 4/4] net: lan966x: Update FDMA to change MTU.
Date:   Mon, 4 Apr 2022 15:06:55 +0200
Message-ID: <20220404130655.4004204-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing the MTU, it is required to change also the size of the
DBs. In case those frames will arrive to CPU.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 95 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  1 +
 3 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 9cccb5f5f8e5..68bc53344326 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -633,6 +633,101 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	return err;
 }
 
+static int lan966x_fdma_get_max_mtu(struct lan966x *lan966x)
+{
+	int max_mtu = 0;
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		int mtu;
+
+		if (!lan966x->ports[i])
+			continue;
+
+		mtu = lan966x->ports[i]->dev->mtu;
+		if (mtu > max_mtu)
+			max_mtu = mtu;
+	}
+
+	return max_mtu;
+}
+
+static int lan966x_qsys_sw_status(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, QSYS_SW_STATUS(CPU_PORT));
+}
+
+static void lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
+{
+	void *rx_dcb, *tx_dcb, *tx_dcb_buf;
+	dma_addr_t rx_dma, tx_dma;
+	unsigned long flags;
+	u32 size;
+
+	/* Store these for later to free them */
+	rx_dma = lan966x->rx.dma;
+	tx_dma = lan966x->tx.dma;
+	rx_dcb = lan966x->rx.dcbs;
+	tx_dcb = lan966x->tx.dcbs;
+	tx_dcb_buf = lan966x->tx.dcbs_buf;
+
+	lan966x_fdma_rx_disable(&lan966x->rx);
+	lan966x_fdma_rx_free_skbs(&lan966x->rx);
+	lan966x->rx.page_order = round_up(new_mtu, PAGE_SIZE) / PAGE_SIZE - 1;
+	lan966x_fdma_rx_alloc(&lan966x->rx);
+	lan966x_fdma_rx_start(&lan966x->rx);
+
+	spin_lock_irqsave(&lan966x->tx_lock, flags);
+	lan966x_fdma_tx_disable(&lan966x->tx);
+	lan966x_fdma_tx_alloc(&lan966x->tx);
+	spin_unlock_irqrestore(&lan966x->tx_lock, flags);
+
+	/* Now it is possible to clean */
+	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, tx_dcb, tx_dma);
+
+	kfree(tx_dcb_buf);
+
+	size = sizeof(struct lan966x_rx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, rx_dcb, rx_dma);
+}
+
+int lan966x_fdma_change_mtu(struct lan966x *lan966x)
+{
+	int max_mtu;
+	u32 val;
+
+	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
+	if (round_up(max_mtu, PAGE_SIZE) / PAGE_SIZE - 1 ==
+	    lan966x->rx.page_order)
+		return 0;
+
+	/* Disable the CPU port */
+	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(0),
+		QSYS_SW_PORT_MODE_PORT_ENA,
+		lan966x, QSYS_SW_PORT_MODE(CPU_PORT));
+
+	/* Flush the CPU queues */
+	readx_poll_timeout(lan966x_qsys_sw_status, lan966x,
+			   val, !(QSYS_SW_STATUS_EQ_AVAIL_GET(val)),
+			   READL_SLEEP_US, READL_TIMEOUT_US);
+
+	/* Add a sleep in case there are frames between the queues and the CPU
+	 * port
+	 */
+	usleep_range(1000, 2000);
+
+	lan966x_fdma_reload(lan966x, max_mtu);
+
+	/* Enable back the CPU port */
+	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(1),
+		QSYS_SW_PORT_MODE_PORT_ENA,
+		lan966x,  QSYS_SW_PORT_MODE(CPU_PORT));
+	return 0;
+}
+
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
 {
 	if (lan966x->fdma_ndev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 245cf4168de0..ca1cef79b83f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -359,7 +359,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 	       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 	dev->mtu = new_mtu;
 
-	return 0;
+	return !lan966x->fdma ? 0 : lan966x_fdma_change_mtu(lan966x);
 }
 
 static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 47f42087b78d..e6642083ab9e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -398,6 +398,7 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
 int lan966x_fdma_init(struct lan966x *lan966x);
-- 
2.33.0

