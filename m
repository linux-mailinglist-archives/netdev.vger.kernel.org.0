Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26D65AAB61
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 11:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiIBJ2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 05:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiIBJ2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 05:28:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E756AC9EA4
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 02:27:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oU2xh-00030r-57; Fri, 02 Sep 2022 11:27:41 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oU2xd-003T6s-GX; Fri, 02 Sep 2022 11:27:39 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oU2xe-00AoBZ-PY; Fri, 02 Sep 2022 11:27:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net v1 1/1] net: dsa: microchip: fix kernel oops on ksz8 switches
Date:   Fri,  2 Sep 2022 11:27:37 +0200
Message-Id: <20220902092737.2576142-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After driver refactoring we was running ksz9477 specific CPU port
configuration on ksz8 family which ended with kernel oops. So, make sure
we run this code only on ksz9477 compatible devices.

Tested on KSZ8873 and KSZ9477.

Fixes: da8cd08520f3 ("net: dsa: microchip: add support for common phylink mac link up")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 30 ++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6bd69a7e6809d..872aba63e7d43 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -170,6 +170,13 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.exit = ksz8_switch_exit,
 };
 
+static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
+					unsigned int mode,
+					phy_interface_t interface,
+					struct phy_device *phydev, int speed,
+					int duplex, bool tx_pause,
+					bool rx_pause);
+
 static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.setup = ksz9477_setup,
 	.get_port_addr = ksz9477_get_port_addr,
@@ -196,6 +203,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = ksz9477_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
+	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = ksz9477_config_cpu_port,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = ksz9477_reset_switch,
@@ -230,6 +238,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = lan937x_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
+	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = lan937x_config_cpu_port,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = lan937x_reset_switch,
@@ -1656,13 +1665,13 @@ static void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
 	ksz_prmw8(dev, port, regs[P_XMII_CTRL_0], mask, val);
 }
 
-static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
-				    unsigned int mode,
-				    phy_interface_t interface,
-				    struct phy_device *phydev, int speed,
-				    int duplex, bool tx_pause, bool rx_pause)
+static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
+					unsigned int mode,
+					phy_interface_t interface,
+					struct phy_device *phydev, int speed,
+					int duplex, bool tx_pause,
+					bool rx_pause)
 {
-	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
 
 	p = &dev->ports[port];
@@ -1676,6 +1685,15 @@ static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	ksz_port_set_xmii_speed(dev, port, speed);
 
 	ksz_duplex_flowctrl(dev, port, duplex, tx_pause, rx_pause);
+}
+
+static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				    unsigned int mode,
+				    phy_interface_t interface,
+				    struct phy_device *phydev, int speed,
+				    int duplex, bool tx_pause, bool rx_pause)
+{
+	struct ksz_device *dev = ds->priv;
 
 	if (dev->dev_ops->phylink_mac_link_up)
 		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
-- 
2.30.2

