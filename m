Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A273DE8F3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhHCIxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhHCIxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:53:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1B3C0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:53:26 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAqAr-0008Jy-Pr; Tue, 03 Aug 2021 10:53:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAqAr-00069a-3k; Tue, 03 Aug 2021 10:53:21 +0200
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
Subject: [PATCH net v2 1/1] net: dsa: qca: ar9331: make proper initial port defaults
Date:   Tue,  3 Aug 2021 10:53:20 +0200
Message-Id: <20210803085320.23605-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that all external port are actually isolated from each other,
so no packets are leaked.

Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- do not enable address learning by default

 drivers/net/dsa/qca/ar9331.c | 98 +++++++++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 6686192e1883..de7c06b6c85f 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -101,6 +101,46 @@
 	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
 	 AR9331_SW_PORT_STATUS_SPEED_M)
 
+#define AR9331_SW_REG_PORT_CTRL(_port)			(0x104 + (_port) * 0x100)
+#define AR9331_SW_PORT_CTRL_ING_MIRROR_EN		BIT(17)
+#define AR9331_SW_PORT_CTRL_EG_MIRROR_EN		BIT(16)
+#define AR9331_SW_PORT_CTRL_DOUBLE_TAG_VLAN		BIT(15)
+#define AR9331_SW_PORT_CTRL_LEARN_EN			BIT(14)
+#define AR9331_SW_PORT_CTRL_SINGLE_VLAN_EN		BIT(13)
+#define AR9331_SW_PORT_CTRL_MAC_LOOP_BACK		BIT(12)
+#define AR9331_SW_PORT_CTRL_HEAD_EN			BIT(11)
+#define AR9331_SW_PORT_CTRL_IGMP_MLD_EN			BIT(10)
+#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE		GENMASK(9, 8)
+#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_KEEP		0
+#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_STRIP		1
+#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_ADD		2
+#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_DOUBLE		3
+#define AR9331_SW_PORT_CTRL_LEARN_ONE_LOCK		BIT(7)
+#define AR9331_SW_PORT_CTRL_PORT_LOCK_EN		BIT(6)
+#define AR9331_SW_PORT_CTRL_LOCK_DROP_EN		BIT(5)
+#define AR9331_SW_PORT_CTRL_PORT_STATE			GENMASK(2, 0)
+#define AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED		0
+#define AR9331_SW_PORT_CTRL_PORT_STATE_BLOCKING		1
+#define AR9331_SW_PORT_CTRL_PORT_STATE_LISTENING	2
+#define AR9331_SW_PORT_CTRL_PORT_STATE_LEARNING		3
+#define AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD		4
+
+#define AR9331_SW_REG_PORT_VLAN(_port)			(0x108 + (_port) * 0x100)
+#define AR9331_SW_PORT_VLAN_8021Q_MODE			GENMASK(31, 30)
+#define AR9331_SW_8021Q_MODE_SECURE			3
+#define AR9331_SW_8021Q_MODE_CHECK			2
+#define AR9331_SW_8021Q_MODE_FALLBACK			1
+#define AR9331_SW_8021Q_MODE_NONE			0
+#define AR9331_SW_PORT_VLAN_ING_PORT_PRI		GENMASK(29, 27)
+#define AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN		BIT(26)
+#define AR9331_SW_PORT_VLAN_PORT_VID_MEMBER		GENMASK(25, 16)
+#define AR9331_SW_PORT_VLAN_ARP_LEAKY_EN		BIT(15)
+#define AR9331_SW_PORT_VLAN_UNI_LEAKY_EN		BIT(14)
+#define AR9331_SW_PORT_VLAN_MULTI_LEAKY_EN		BIT(13)
+#define AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN	BIT(12)
+#define AR9331_SW_PORT_VLAN_PORT_VID			GENMASK(11, 0)
+#define AR9331_SW_PORT_VLAN_PORT_VID_DEF		1
+
 /* MIB registers */
 #define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
 
@@ -371,12 +411,62 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 	return 0;
 }
 
-static int ar9331_sw_setup(struct dsa_switch *ds)
+static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
 	struct regmap *regmap = priv->regmap;
+	u32 port_mask, port_ctrl, val;
 	int ret;
 
+	/* Generate default port settings */
+	port_ctrl = FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
+			       AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED);
+
+	if (dsa_is_cpu_port(ds, port)) {
+		/* CPU port should be allowed to communicate with all user
+		 * ports.
+		 */
+		port_mask = dsa_user_ports(ds);
+		/* Enable Atheros header on CPU port. This will allow us
+		 * communicate with each port separately
+		 */
+		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
+	} else if (dsa_is_user_port(ds, port)) {
+		/* User ports should communicate only with the CPU port.
+		 */
+		port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);
+	} else {
+		/* Other ports do not need to communicate at all */
+		port_mask = 0;
+	}
+
+	val = FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
+			 AR9331_SW_8021Q_MODE_NONE) |
+		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask) |
+		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
+			   AR9331_SW_PORT_VLAN_PORT_VID_DEF);
+
+	ret = regmap_write(regmap, AR9331_SW_REG_PORT_VLAN(port), val);
+	if (ret)
+		goto error;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_PORT_CTRL(port), port_ctrl);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	dev_err(priv->dev, "%s: error: %i\n", __func__, ret);
+
+	return ret;
+}
+
+static int ar9331_sw_setup(struct dsa_switch *ds)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int ret, i;
+
 	ret = ar9331_sw_reset(priv);
 	if (ret)
 		return ret;
@@ -402,6 +492,12 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
 	if (ret)
 		goto error;
 
+	for (i = 0; i < ds->num_ports; i++) {
+		ret = ar9331_sw_setup_port(ds, i);
+		if (ret)
+			goto error;
+	}
+
 	ds->configure_vlan_while_not_filtering = false;
 
 	return 0;
-- 
2.30.2

