Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA95443F4C
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhKCJXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:23:17 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:43141 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhKCJXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:23:07 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 9A87F100003;
        Wed,  3 Nov 2021 09:20:29 +0000 (UTC)
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
Subject: [PATCH v2 4/6] net: ocelot: add support for ndo_change_mtu
Date:   Wed,  3 Nov 2021 10:19:41 +0100
Message-Id: <20211103091943.3878621-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103091943.3878621-1-clement.leger@bootlin.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for changing MTU for the ocelot register based
interface. For ocelot, JUMBO frame size can be set up to 25000 bytes
but has been set to 9000 which is a saner value and allow for maximum
gain of performances. Frames larger than 9000 bytes do not yield
a noticeable improvement.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.h     |  2 ++
 drivers/net/ethernet/mscc/ocelot_net.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e43da09b8f91..ba0dec7dd64f 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -32,6 +32,8 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
+#define OCELOT_JUMBO_MTU	9000
+
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d76def435b23..5916492fd6d0 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -482,6 +482,18 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+static int ocelot_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
+	WRITE_ONCE(dev->mtu, new_mtu);
+
+	return 0;
+}
+
 enum ocelot_action_type {
 	OCELOT_MACT_LEARN,
 	OCELOT_MACT_FORGET,
@@ -768,6 +780,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_open			= ocelot_port_open,
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
+	.ndo_change_mtu			= ocelot_change_mtu,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
@@ -1699,6 +1712,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 
 	dev->netdev_ops = &ocelot_port_netdev_ops;
 	dev->ethtool_ops = &ocelot_ethtool_ops;
+	dev->max_mtu = OCELOT_JUMBO_MTU;
 
 	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
 		NETIF_F_HW_TC;
-- 
2.33.0

