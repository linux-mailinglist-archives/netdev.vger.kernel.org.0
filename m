Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804BC443F52
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhKCJX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:23:26 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:51849 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhKCJXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:23:10 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 0FDD9100002;
        Wed,  3 Nov 2021 09:20:31 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 6/6] net: ocelot: add jumbo frame support for FDMA
Date:   Wed,  3 Nov 2021 10:19:43 +0100
Message-Id: <20211103091943.3878621-7-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103091943.3878621-1-clement.leger@bootlin.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using the FDMA, using jumbo frames can lead to a large performance
improvement. When changing the MTU, the RX buffer size must be
increased to be large enough to receive jumbo frame. Since the FDMA is
shared amongst all interfaces, all the ports must be down before
changing the MTU. Buffers are sized to accept the maximum MTU supported
by each port.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 61 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c  |  7 +++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index d8cdf022bbee..bee1a310caa6 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -530,6 +530,67 @@ static void fdma_free_skbs_list(struct ocelot_fdma *fdma,
 	}
 }
 
+int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *port = &priv->port;
+	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_dcb *dcb, *dcb_temp;
+	struct list_head tmp = LIST_HEAD_INIT(tmp);
+	size_t old_rx_buf_size = fdma->rx_buf_size;
+	bool all_ports_down = true;
+	u8 port_num;
+
+	/* The FDMA RX list is shared amongst all the port, get the max MTU from
+	 * all of them
+	 */
+	for (port_num = 0; port_num < ocelot->num_phys_ports; port_num++) {
+		port = ocelot->ports[port_num];
+		if (!port)
+			continue;
+
+		priv = container_of(port, struct ocelot_port_private, port);
+
+		if (READ_ONCE(priv->dev->mtu) > new_mtu)
+			new_mtu = READ_ONCE(priv->dev->mtu);
+
+		/* All ports must be down to change the RX buffer length */
+		if (netif_running(priv->dev))
+			all_ports_down = false;
+	}
+
+	fdma->rx_buf_size = fdma_rx_compute_buffer_size(new_mtu);
+	if (fdma->rx_buf_size == old_rx_buf_size)
+		return 0;
+
+	if (!all_ports_down)
+		return -EBUSY;
+
+	priv = netdev_priv(dev);
+
+	fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
+
+	/* Discard all pending RX software and hardware descriptor */
+	fdma_free_skbs_list(fdma, &fdma->rx_hw, DMA_FROM_DEVICE);
+	fdma_free_skbs_list(fdma, &fdma->rx_sw, DMA_FROM_DEVICE);
+
+	/* Move all DCBs to a temporary list that will be injected in sw list */
+	if (!list_empty(&fdma->rx_hw))
+		list_splice_tail_init(&fdma->rx_hw, &tmp);
+	if (!list_empty(&fdma->rx_sw))
+		list_splice_tail_init(&fdma->rx_sw, &tmp);
+
+	list_for_each_entry_safe(dcb, dcb_temp, &tmp, node) {
+		list_del(&dcb->node);
+		ocelot_fdma_rx_add_dcb_sw(fdma, dcb);
+	}
+
+	ocelot_fdma_rx_refill(fdma);
+
+	return 0;
+}
+
 static int fdma_init_tx(struct ocelot_fdma *fdma)
 {
 	int i;
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethernet/mscc/ocelot_fdma.h
index 6c5c5872abf5..74514a0b291a 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.h
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
@@ -55,5 +55,6 @@ int ocelot_fdma_start(struct ocelot_fdma *fdma);
 int ocelot_fdma_stop(struct ocelot_fdma *fdma);
 int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew_op,
 			     struct sk_buff *skb, struct net_device *dev);
+int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu);
 
 #endif
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3971b810c5b4..d5e88d7b15c7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -492,6 +492,13 @@ static int ocelot_change_mtu(struct net_device *dev, int new_mtu)
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	int ret;
+
+	if (ocelot->fdma) {
+		ret = ocelot_fdma_change_mtu(dev, new_mtu);
+		if (ret)
+			return ret;
+	}
 
 	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
 	WRITE_ONCE(dev->mtu, new_mtu);
-- 
2.33.0

