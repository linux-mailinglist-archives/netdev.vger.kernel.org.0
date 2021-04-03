Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0110E3533E3
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhDCLtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbhDCLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4315FC061797
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000ex-76; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007yY-TJ; Sat, 03 Apr 2021 13:48:49 +0200
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
Subject: [PATCH net-next v1 8/9] net: dsa: qca: ar9331: add STP support
Date:   Sat,  3 Apr 2021 13:48:47 +0200
Message-Id: <20210403114848.30528-9-o.rempel@pengutronix.de>
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

According to the datasheet, this switch has configurable STP port
states. Suddenly LISTENING and BLOCKING states didn't forwarded packets
to the CPU and linux bridge continuously re enabled ports even if a  loop
was detected. To make it work, I reused bridge functionality to isolate
port in LISTENING and BLOCKING states.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 69 ++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index bf9588574205..83b59e771a5f 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -327,6 +327,7 @@ struct ar9331_sw_priv {
 	struct reset_control *sw_reset;
 	struct ar9331_sw_port port[AR9331_SW_PORTS];
 	int cpu_port;
+	u32 isolated_ports;
 };
 
 static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_port *port)
@@ -1151,6 +1152,10 @@ static int ar9331_sw_port_bridge_join(struct dsa_switch *ds, int port,
 		if (!dsa_is_user_port(ds, port))
 			continue;
 
+		/* part of the bridge but should be isolated for now */
+		if (priv->isolated_ports & BIT(i))
+			continue;
+
 		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
 		ret = regmap_set_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
 		if (ret)
@@ -1205,6 +1210,69 @@ static void ar9331_sw_port_bridge_leave(struct dsa_switch *ds, int port,
 	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
 }
 
+static void ar9331_sw_port_stp_state_set(struct dsa_switch *ds, int port,
+					 u8 state)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct net_device *br = dsa_to_port(ds, port)->bridge_dev;
+	struct regmap *regmap = priv->regmap;
+	u32 port_ctrl = 0, port_state = 0;
+	bool join = false;
+	int ret;
+
+	/*
+	 * STP hw support is buggy or I didn't understood it. So, it seems to
+	 * be easier to make hand crafted implementation by using bridge
+	 * functionality. Similar implementation can be found on ksz9477 switch
+	 * and may be we need some generic code to so for all related devices
+	 */
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		join = true;
+		fallthrough;
+	case BR_STATE_LEARNING:
+		port_ctrl = AR9331_SW_PORT_CTRL_LEARN_EN;
+		fallthrough;
+	case BR_STATE_LISTENING:
+	case BR_STATE_BLOCKING:
+		port_state = AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD;
+		break;
+	case BR_STATE_DISABLED:
+	default:
+		port_state = AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED;
+		break;
+	}
+
+	port_ctrl |= FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE, port_state);
+
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_CTRL(port),
+				 AR9331_SW_PORT_CTRL_LEARN_EN |
+				 AR9331_SW_PORT_CTRL_PORT_STATE, port_ctrl);
+	if (ret)
+		goto error;
+
+	if (!dsa_is_user_port(ds, port))
+		return;
+
+	/*
+	 * here we care only about user ports. CPU port do not need this
+	 * configuration
+	 */
+	if (join) {
+		priv->isolated_ports &= ~BIT(port);
+		if (br)
+			ar9331_sw_port_bridge_join(ds, port, br);
+	} else {
+		priv->isolated_ports |= BIT(port);
+		if (br)
+			ar9331_sw_port_bridge_leave(ds, port, br);
+	}
+
+	return;
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -1223,6 +1291,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.set_ageing_time	= ar9331_sw_set_ageing_time,
 	.port_bridge_join	= ar9331_sw_port_bridge_join,
 	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
+	.port_stp_state_set	= ar9331_sw_port_stp_state_set,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.29.2

