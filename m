Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5462B32D4
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 08:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgKOHfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 02:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgKOHfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 02:35:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAD3C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 23:35:47 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1keCZV-0006Lj-BJ; Sun, 15 Nov 2020 08:35:37 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1keCZT-0000O4-9V; Sun, 15 Nov 2020 08:35:35 +0100
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
Subject: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats support
Date:   Sun, 15 Nov 2020 08:35:33 +0100
Message-Id: <20201115073533.1366-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
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
 drivers/net/dsa/qca/ar9331.c | 113 +++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index e24a99031b80..f6947fb0182f 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -101,6 +101,9 @@
 	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
 	 AR9331_SW_PORT_STATUS_SPEED_M)
 
+/* MIB registers */
+#define AR9331_PORT_MIB_COUNTER(_i)			(0x20000 + (_i) * 0x100)
+
 /* Phy bypass mode
  * ------------------------------------------------------------------------
  * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
@@ -165,6 +168,61 @@ struct ar9331_sw_priv {
 	struct reset_control *sw_reset;
 };
 
+struct ar9331_mib_desc {
+	unsigned int size;
+	unsigned int offset;
+	const char *name;
+};
+
+#define MIB_DESC(_s, _o, _n)	\
+	{			\
+		.size = (_s),	\
+		.offset = (_o),	\
+		.name = (_n),	\
+	}
+
+static const struct ar9331_mib_desc ar9331_mib[] = {
+	MIB_DESC(1, 0x00, "RxBroad"),
+	MIB_DESC(1, 0x04, "RxPause"),
+	MIB_DESC(1, 0x08, "RxMulti"),
+	MIB_DESC(1, 0x0c, "RxFcsErr"),
+	MIB_DESC(1, 0x10, "RxAlignErr"),
+	MIB_DESC(1, 0x14, "RxRunt"),
+	MIB_DESC(1, 0x18, "RxFragment"),
+	MIB_DESC(1, 0x1c, "Rx64Byte"),
+	MIB_DESC(1, 0x20, "Rx128Byte"),
+	MIB_DESC(1, 0x24, "Rx256Byte"),
+	MIB_DESC(1, 0x28, "Rx512Byte"),
+	MIB_DESC(1, 0x2c, "Rx1024Byte"),
+	MIB_DESC(1, 0x30, "Rx1518Byte"),
+	MIB_DESC(1, 0x34, "RxMaxByte"),
+	MIB_DESC(1, 0x38, "RxTooLong"),
+	MIB_DESC(2, 0x3c, "RxGoodByte"),
+	MIB_DESC(2, 0x44, "RxBadByte"),
+	MIB_DESC(1, 0x4c, "RxOverFlow"),
+	MIB_DESC(1, 0x50, "Filtered"),
+	MIB_DESC(1, 0x54, "TxBroad"),
+	MIB_DESC(1, 0x58, "TxPause"),
+	MIB_DESC(1, 0x5c, "TxMulti"),
+	MIB_DESC(1, 0x60, "TxUnderRun"),
+	MIB_DESC(1, 0x64, "Tx64Byte"),
+	MIB_DESC(1, 0x68, "Tx128Byte"),
+	MIB_DESC(1, 0x6c, "Tx256Byte"),
+	MIB_DESC(1, 0x70, "Tx512Byte"),
+	MIB_DESC(1, 0x74, "Tx1024Byte"),
+	MIB_DESC(1, 0x78, "Tx1518Byte"),
+	MIB_DESC(1, 0x7c, "TxMaxByte"),
+	MIB_DESC(1, 0x80, "TxOverSize"),
+	MIB_DESC(2, 0x84, "TxByte"),
+	MIB_DESC(1, 0x8c, "TxCollision"),
+	MIB_DESC(1, 0x90, "TxAbortCol"),
+	MIB_DESC(1, 0x94, "TxMultiCol"),
+	MIB_DESC(1, 0x98, "TxSingleCol"),
+	MIB_DESC(1, 0x9c, "TxExcDefer"),
+	MIB_DESC(1, 0xa0, "TxDefer"),
+	MIB_DESC(1, 0xa4, "TxLateCol"),
+};
+
 /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
  * If some kind of optimization is used, the request should be repeated.
  */
@@ -475,6 +533,58 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
 }
 
+static void ar9331_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+			       uint8_t *data)
+{
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ar9331_mib); i++)
+		strncpy(data + i * ETH_GSTRING_LEN, ar9331_mib[i].name,
+			ETH_GSTRING_LEN);
+}
+
+static void ar9331_get_ethtool_stats(struct dsa_switch *ds, int port,
+				     uint64_t *data)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	const struct ar9331_mib_desc *mib;
+	u32 reg, i, stat;
+	u64 hi;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(ar9331_mib); i++) {
+		mib = &ar9331_mib[i];
+		reg = AR9331_PORT_MIB_COUNTER(port) + mib->offset;
+
+		ret = regmap_read(regmap, reg, &stat);
+		if (ret)
+			dev_err_ratelimited(priv->dev, "%s: %i\n", __func__,
+					    ret);
+		data[i] = stat;
+		if (mib->size == 2) {
+			ret = regmap_read(regmap, reg + 4, &stat);
+			if (ret)
+				dev_err_ratelimited(priv->dev, "%s: %i\n",
+						    __func__, ret);
+
+			hi = stat;
+			data[i] |= hi << 32;
+		}
+	}
+}
+
+static int ar9331_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return ARRAY_SIZE(ar9331_mib);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -483,6 +593,9 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.phylink_mac_config	= ar9331_sw_phylink_mac_config,
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
+	.get_strings		= ar9331_get_strings,
+	.get_ethtool_stats	= ar9331_get_ethtool_stats,
+	.get_sset_count		= ar9331_get_sset_count,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.28.0

