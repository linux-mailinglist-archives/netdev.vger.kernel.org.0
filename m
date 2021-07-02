Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3FA3B9EEE
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhGBKUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhGBKUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:20:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4AC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 03:18:08 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzGFH-0005BD-3u; Fri, 02 Jul 2021 12:18:03 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzGFF-0003fO-Ts; Fri, 02 Jul 2021 12:18:01 +0200
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
Subject: [PATCH net-next v2 4/6] net: dsa: qca: ar9331: add ageing time support
Date:   Fri,  2 Jul 2021 12:17:49 +0200
Message-Id: <20210702101751.13168-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702101751.13168-1-o.rempel@pengutronix.de>
References: <20210702101751.13168-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch provides global ageing time configuration, so let DSA use
it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca/ar9331.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index a8be099c5700..2abec323ef14 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -1076,6 +1076,25 @@ static void ar9331_sw_port_fast_age(struct dsa_switch *ds, int port)
 	dev_err(priv->dev, "%s: error: %i\n", __func__, ret);
 }
 
+static int ar9331_sw_set_ageing_time(struct dsa_switch *ds,
+				     unsigned int ageing_time)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	u32 time, val;
+
+	time = DIV_ROUND_UP(ageing_time, AR9331_SW_AT_AGE_TIME_COEF);
+	if (!time)
+		time = 1;
+	else if (time > U16_MAX)
+		time = U16_MAX;
+
+	val = FIELD_PREP(AR9331_SW_AT_AGE_TIME, time) | AR9331_SW_AT_AGE_EN;
+	return regmap_update_bits(regmap, AR9331_SW_REG_ADDR_TABLE_CTRL,
+				  AR9331_SW_AT_AGE_EN | AR9331_SW_AT_AGE_TIME,
+				  val);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -1091,6 +1110,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.port_fdb_dump		= ar9331_sw_port_fdb_dump,
 	.port_mdb_add           = ar9331_sw_port_mdb_add,
 	.port_mdb_del           = ar9331_sw_port_mdb_del,
+	.set_ageing_time	= ar9331_sw_set_ageing_time,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
@@ -1444,6 +1464,8 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
 	priv->ops = ar9331_sw_ops;
 	ds->ops = &priv->ops;
 	dev_set_drvdata(&mdiodev->dev, priv);
+	ds->ageing_time_min = AR9331_SW_AT_AGE_TIME_COEF;
+	ds->ageing_time_max = AR9331_SW_AT_AGE_TIME_COEF * U16_MAX;
 
 	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
 		struct ar9331_sw_port *port = &priv->port[i];
-- 
2.30.2

