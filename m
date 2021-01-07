Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9002ED044
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbhAGM5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbhAGM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:57:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7DC0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 04:56:22 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kxUpt-0001v1-A0; Thu, 07 Jan 2021 13:56:17 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kxUpr-0004zm-2K; Thu, 07 Jan 2021 13:56:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Date:   Thu,  7 Jan 2021 13:56:13 +0100
Message-Id: <20210107125613.19046-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107125613.19046-1-o.rempel@pengutronix.de>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add stats support for the ar9331 switch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 164 ++++++++++++++++++++++++++++++++++-
 1 file changed, 163 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 4d49c5f2b790..1a15845ceedd 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -101,6 +101,9 @@
 	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
 	 AR9331_SW_PORT_STATUS_SPEED_M)
 
+/* MIB registers */
+#define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
+
 /* Phy bypass mode
  * ------------------------------------------------------------------------
  * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
@@ -154,6 +157,66 @@
 #define AR9331_SW_MDIO_POLL_SLEEP_US		1
 #define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
 
+/* The interval should be small enough to avoid overflow of 32bit MIBs */
+/*
+ * FIXME: until we can read MIBs from stats64 call directly (i.e. sleep
+ * there), we have to poll stats more frequently then it is actually needed.
+ * For overflow protection, normally, 100 sec interval should have been OK.
+ */
+#define STATS_INTERVAL_JIFFIES			(3 * HZ)
+
+struct ar9331_sw_stats_raw {
+	u32 rxbroad;			/* 0x00 */
+	u32 rxpause;			/* 0x04 */
+	u32 rxmulti;			/* 0x08 */
+	u32 rxfcserr;			/* 0x0c */
+	u32 rxalignerr;			/* 0x10 */
+	u32 rxrunt;			/* 0x14 */
+	u32 rxfragment;			/* 0x18 */
+	u32 rx64byte;			/* 0x1c */
+	u32 rx128byte;			/* 0x20 */
+	u32 rx256byte;			/* 0x24 */
+	u32 rx512byte;			/* 0x28 */
+	u32 rx1024byte;			/* 0x2c */
+	u32 rx1518byte;			/* 0x30 */
+	u32 rxmaxbyte;			/* 0x34 */
+	u32 rxtoolong;			/* 0x38 */
+	u32 rxgoodbyte;			/* 0x3c */
+	u32 rxgoodbyte_hi;
+	u32 rxbadbyte;			/* 0x44 */
+	u32 rxbadbyte_hi;
+	u32 rxoverflow;			/* 0x4c */
+	u32 filtered;			/* 0x50 */
+	u32 txbroad;			/* 0x54 */
+	u32 txpause;			/* 0x58 */
+	u32 txmulti;			/* 0x5c */
+	u32 txunderrun;			/* 0x60 */
+	u32 tx64byte;			/* 0x64 */
+	u32 tx128byte;			/* 0x68 */
+	u32 tx256byte;			/* 0x6c */
+	u32 tx512byte;			/* 0x70 */
+	u32 tx1024byte;			/* 0x74 */
+	u32 tx1518byte;			/* 0x78 */
+	u32 txmaxbyte;			/* 0x7c */
+	u32 txoversize;			/* 0x80 */
+	u32 txbyte;			/* 0x84 */
+	u32 txbyte_hi;
+	u32 txcollision;		/* 0x8c */
+	u32 txabortcol;			/* 0x90 */
+	u32 txmulticol;			/* 0x94 */
+	u32 txsinglecol;		/* 0x98 */
+	u32 txexcdefer;			/* 0x9c */
+	u32 txdefer;			/* 0xa0 */
+	u32 txlatecol;			/* 0xa4 */
+};
+
+struct ar9331_sw_port {
+	int idx;
+	struct delayed_work mib_read;
+	struct rtnl_link_stats64 stats;
+	struct spinlock stats_lock;
+};
+
 struct ar9331_sw_priv {
 	struct device *dev;
 	struct dsa_switch ds;
@@ -165,8 +228,17 @@ struct ar9331_sw_priv {
 	struct mii_bus *sbus; /* mdio slave */
 	struct regmap *regmap;
 	struct reset_control *sw_reset;
+	struct ar9331_sw_port port[AR9331_SW_PORTS];
 };
 
+static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_port *port)
+{
+	struct ar9331_sw_port *p = port - port->idx;
+
+	return (struct ar9331_sw_priv *)((void *)p -
+					 offsetof(struct ar9331_sw_priv, port));
+}
+
 /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
  * If some kind of optimization is used, the request should be repeated.
  */
@@ -424,6 +496,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					    phy_interface_t interface)
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct ar9331_sw_port *p = &priv->port[port];
 	struct regmap *regmap = priv->regmap;
 	int ret;
 
@@ -431,6 +504,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
 				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
 	if (ret)
 		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
+
+	cancel_delayed_work_sync(&p->mib_read);
 }
 
 static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -441,10 +516,13 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					  bool tx_pause, bool rx_pause)
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct ar9331_sw_port *p = &priv->port[port];
 	struct regmap *regmap = priv->regmap;
 	u32 val;
 	int ret;
 
+	schedule_delayed_work(&p->mib_read, 0);
+
 	val = AR9331_SW_PORT_STATUS_MAC_MASK;
 	switch (speed) {
 	case SPEED_1000:
@@ -477,6 +555,74 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
 }
 
+static void ar9331_read_stats(struct ar9331_sw_port *port)
+{
+	struct ar9331_sw_priv *priv = ar9331_sw_port_to_priv(port);
+	struct rtnl_link_stats64 *stats = &port->stats;
+	struct ar9331_sw_stats_raw raw;
+	int ret;
+
+	/* Do the slowest part first, to avoid needless locking for long time */
+	ret = regmap_bulk_read(priv->regmap, AR9331_MIB_COUNTER(port->idx),
+			       &raw, sizeof(raw) / sizeof(u32));
+	if (ret) {
+		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
+		return;
+	}
+	/* All MIB counters are cleared automatically on read */
+
+	spin_lock(&port->stats_lock);
+
+	stats->rx_bytes += raw.rxgoodbyte;
+	stats->tx_bytes += raw.txbyte;
+
+	stats->rx_packets += raw.rx64byte + raw.rx128byte + raw.rx256byte +
+		raw.rx512byte + raw.rx1024byte + raw.rx1518byte + raw.rxmaxbyte;
+	stats->tx_packets += raw.tx64byte + raw.tx128byte + raw.tx256byte +
+		raw.tx512byte + raw.tx1024byte + raw.tx1518byte + raw.txmaxbyte;
+
+	stats->rx_length_errors += raw.rxrunt + raw.rxfragment + raw.rxtoolong;
+	stats->rx_crc_errors += raw.rxfcserr;
+	stats->rx_frame_errors += raw.rxalignerr;
+	stats->rx_missed_errors += raw.rxoverflow;
+	stats->rx_nohandler += raw.filtered;
+	stats->rx_dropped += raw.filtered;
+	stats->rx_errors += raw.rxfcserr + raw.rxalignerr + raw.rxrunt +
+		raw.rxfragment + raw.rxoverflow + raw.rxtoolong;
+
+	stats->tx_window_errors += raw.txlatecol;
+	stats->tx_fifo_errors += raw.txunderrun;
+	stats->tx_aborted_errors += raw.txabortcol;
+	stats->tx_errors += raw.txoversize + raw.txabortcol + raw.txunderrun +
+		raw.txlatecol;
+
+	stats->multicast += raw.rxmulti;
+	stats->collisions += raw.txcollision;
+
+	spin_unlock(&port->stats_lock);
+}
+
+static void ar9331_do_stats_poll(struct work_struct *work)
+{
+	struct ar9331_sw_port *port = container_of(work, struct ar9331_sw_port,
+						   mib_read.work);
+
+	ar9331_read_stats(port);
+
+	schedule_delayed_work(&port->mib_read, STATS_INTERVAL_JIFFIES);
+}
+
+static void ar9331_get_stats64(struct dsa_switch *ds, int port,
+			       struct rtnl_link_stats64 *s)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct ar9331_sw_port *p = &priv->port[port];
+
+	spin_lock(&p->stats_lock);
+	memcpy(s, &p->stats, sizeof(*s));
+	spin_unlock(&p->stats_lock);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -485,6 +631,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.phylink_mac_config	= ar9331_sw_phylink_mac_config,
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
+	.get_stats64		= ar9331_get_stats64,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
@@ -796,7 +943,7 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
 {
 	struct ar9331_sw_priv *priv;
 	struct dsa_switch *ds;
-	int ret;
+	int ret, i;
 
 	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -831,6 +978,14 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
 	ds->ops = &priv->ops;
 	dev_set_drvdata(&mdiodev->dev, priv);
 
+	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
+		struct ar9331_sw_port *port = &priv->port[i];
+
+		port->idx = i;
+		spin_lock_init(&port->stats_lock);
+		INIT_DELAYED_WORK(&port->mib_read, ar9331_do_stats_poll);
+	}
+
 	ret = dsa_register_switch(ds);
 	if (ret)
 		goto err_remove_irq;
@@ -846,6 +1001,13 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
 static void ar9331_sw_remove(struct mdio_device *mdiodev)
 {
 	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
+		struct ar9331_sw_port *port = &priv->port[i];
+
+		cancel_delayed_work_sync(&port->mib_read);
+	}
 
 	irq_domain_remove(priv->irqdomain);
 	mdiobus_unregister(priv->mbus);
-- 
2.30.0

