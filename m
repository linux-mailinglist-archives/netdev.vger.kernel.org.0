Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E034D68ECF5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjBHKcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjBHKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:32:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912C546D63
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:32:24 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkN-00047W-Cl; Wed, 08 Feb 2023 11:32:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkK-003UhY-SL; Wed, 08 Feb 2023 11:32:14 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkK-00Aa3x-Pr; Wed, 08 Feb 2023 11:32:12 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Date:   Wed,  8 Feb 2023 11:32:03 +0100
Message-Id: <20230208103211.2521836-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208103211.2521836-1-o.rempel@pengutronix.de>
References: <20230208103211.2521836-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of KSZ9477 family switches provides EEE support. To enable it, we
just need to register set_mac_eee/set_mac_eee handlers and validate
supported chip version and port.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/ksz_common.c | 65 ++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 46becc0382d6..0a2d78253d17 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2673,6 +2673,69 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return -EOPNOTSUPP;
 }
 
+static int ksz_validate_eee(struct dsa_switch *ds, int port)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->info->internal_phy[port])
+		return -EOPNOTSUPP;
+
+	switch (dev->chip_id) {
+	case KSZ8563_CHIP_ID:
+	case KSZ9477_CHIP_ID:
+	case KSZ9563_CHIP_ID:
+	case KSZ9567_CHIP_ID:
+	case KSZ9893_CHIP_ID:
+	case KSZ9896_CHIP_ID:
+	case KSZ9897_CHIP_ID:
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int ksz_get_mac_eee(struct dsa_switch *ds, int port,
+			   struct ethtool_eee *e)
+{
+	int ret;
+
+	ret = ksz_validate_eee(ds, port);
+	if (ret)
+		return ret;
+
+	/* There is no documented control of Tx LPI configuration. */
+	e->tx_lpi_enabled = true;
+	/* There is no documented control of Tx LPI timer. According to tests
+	 * Tx LPI timer seems to be set by default to minimal value.
+	 */
+	e->tx_lpi_timer = 0;
+
+	return 0;
+}
+
+static int ksz_set_mac_eee(struct dsa_switch *ds, int port,
+			   struct ethtool_eee *e)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	ret = ksz_validate_eee(ds, port);
+	if (ret)
+		return ret;
+
+	if (!e->tx_lpi_enabled) {
+		dev_err(dev->dev, "Disabling EEE Tx LPI is not supported\n");
+		return -EINVAL;
+	}
+
+	if (e->tx_lpi_timer) {
+		dev_err(dev->dev, "Setting EEE Tx LPI timer is not supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void ksz_set_xmii(struct ksz_device *dev, int port,
 			 phy_interface_t interface)
 {
@@ -3130,6 +3193,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_txtstamp		= ksz_port_txtstamp,
 	.port_rxtstamp		= ksz_port_rxtstamp,
 	.port_setup_tc		= ksz_setup_tc,
+	.get_mac_eee		= ksz_get_mac_eee,
+	.set_mac_eee		= ksz_set_mac_eee,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
-- 
2.30.2

