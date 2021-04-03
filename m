Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667633533E7
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhDCLt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhDCLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B4DC0617A7
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000ew-7A; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007yP-SO; Sat, 03 Apr 2021 13:48:49 +0200
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
Subject: [PATCH net-next v1 7/9] net: dsa: qca: ar9331: add bridge support
Date:   Sat,  3 Apr 2021 13:48:46 +0200
Message-Id: <20210403114848.30528-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403114848.30528-1-o.rempel@pengutronix.de>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch is providing forwarding matrix, with it we can configure
individual bridges. Potentially we can configure more then one not VLAN
based bridge on this HW.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 73 ++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index b2c22ba924f0..bf9588574205 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -40,6 +40,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/if_bridge.h>
 #include <linux/module.h>
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
@@ -1134,6 +1135,76 @@ static int ar9331_sw_set_ageing_time(struct dsa_switch *ds,
 				  val);
 }
 
+static int ar9331_sw_port_bridge_join(struct dsa_switch *ds, int port,
+				      struct net_device *br)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int port_mask = BIT(priv->cpu_port);
+	int i, ret;
+	u32 val;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev != br)
+			continue;
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
+		ret = regmap_set_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
+		if (ret)
+			goto error;
+
+		if (i != port)
+			port_mask |= BIT(i);
+	}
+
+	val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask);
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
+				 AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, val);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
+
+	return ret;
+}
+
+static void ar9331_sw_port_bridge_leave(struct dsa_switch *ds, int port,
+					struct net_device *br)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int i, ret;
+	u32 val;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev != br)
+			continue;
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
+		ret = regmap_clear_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
+		if (ret)
+			goto error;
+	}
+
+	val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(priv->cpu_port));
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
+				 AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, val);
+	if (ret)
+		goto error;
+
+	return;
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -1150,6 +1221,8 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.port_mdb_add           = ar9331_sw_port_mdb_add,
 	.port_mdb_del           = ar9331_sw_port_mdb_del,
 	.set_ageing_time	= ar9331_sw_set_ageing_time,
+	.port_bridge_join	= ar9331_sw_port_bridge_join,
+	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.29.2

