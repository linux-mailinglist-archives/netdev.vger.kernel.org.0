Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F284DE2BE
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbiCRUqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbiCRUqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:46:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B4D30CD8A;
        Fri, 18 Mar 2022 13:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647636327; x=1679172327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ENqD6ell0yupK/0eeOO9nyCUymoKCdDskrSLaGyrG+U=;
  b=VkyBcVdKCipE9d3h8DyJ2sAtgISdEUmJWQtiTxe/tp+GWtz9mnjX0JRK
   +wRlLUJHAvWw5Eiq6BDKdFWkPJLLDzaDm7KhwUYv6n9dACwSnAFob4OYy
   IxC8WggoEMDVa3BFDO7/hg2Wp8lUrciJVzdfPOyFdm/B9gTOsBxJbc3a1
   FzblzgEgxDtH6PXNGcTeD0hOmSp4pbzG+PW3IuotmXmzf+ecjZV+Sgj1D
   aw7C6zttm4oJnN6C8eVc0AUTvB9AAJtfUAQYe/zHdrsCDakUZP81fxX6S
   1umUGVkmGyb0PsPAm3jK+e7vNGvYN48M72nulq0VOBzZsuCXlJlGG8+Z6
   w==;
X-IronPort-AV: E=Sophos;i="5.90,192,1643698800"; 
   d="scan'208";a="166351434"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 13:45:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 13:45:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 13:45:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/4] net: lan966x: Update FDMA to change MTU.
Date:   Fri, 18 Mar 2022 21:47:50 +0100
Message-ID: <20220318204750.1864134-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
References: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c3266d07302d..f3245dd713f4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -636,6 +636,101 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
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
index 6cb9fffc3058..a78fee5471e7 100644
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
index bfa7feea2b56..fa4016f2b5d4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -397,6 +397,7 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_init(struct lan966x *lan966x);
-- 
2.33.0

