Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED336D5CCF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbjDDKN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbjDDKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:13:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0665C2D48
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:12:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdeQ-0007TV-5l; Tue, 04 Apr 2023 12:12:30 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdeM-008tQd-UU; Tue, 04 Apr 2023 12:12:26 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdeM-005nXc-BU; Tue, 04 Apr 2023 12:12:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make flow control, speed, and duplex on CPU port configurable
Date:   Tue,  4 Apr 2023 12:12:25 +0200
Message-Id: <20230404101225.1382059-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow flow control, speed, and duplex settings on the CPU port to be
configurable. Previously, the speed and duplex relied on default switch
values, which limited flexibility. Additionally, flow control was
hardcoded and only functional in duplex mode. This update enhances the
configurability of these parameters.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h       |  4 ++
 drivers/net/dsa/microchip/ksz8795.c    | 54 ++++++++++++++++++++++----
 drivers/net/dsa/microchip/ksz_common.c |  1 +
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index ea05abfbd51d..9bb19764fa33 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -58,5 +58,9 @@ int ksz8_switch_detect(struct ksz_device *dev);
 int ksz8_switch_init(struct ksz_device *dev);
 void ksz8_switch_exit(struct ksz_device *dev);
 int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu);
+void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
+			      unsigned int mode, phy_interface_t interface,
+			      struct phy_device *phydev, int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
 
 #endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index d0e3f6e2db1d..8917f22f90d2 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1321,12 +1321,52 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 			if (remote & KSZ8_PORT_FIBER_MODE)
 				p->fiber = 1;
 		}
-		if (p->fiber)
-			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
-				     PORT_FORCE_FLOW_CTRL, true);
-		else
-			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
-				     PORT_FORCE_FLOW_CTRL, false);
+	}
+}
+
+void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
+			      unsigned int mode, phy_interface_t interface,
+			      struct phy_device *phydev, int speed, int duplex,
+			      bool tx_pause, bool rx_pause)
+{
+	struct dsa_switch *ds = dev->ds;
+	struct ksz_port *p;
+	u8 ctrl = 0;
+
+	p = &dev->ports[port];
+
+	if (dsa_upstream_port(ds, port)) {
+		u8 mask = SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
+			SW_FLOW_CTRL | SW_10_MBIT;
+
+		if (duplex) {
+			if (tx_pause && rx_pause)
+				ctrl |= SW_FLOW_CTRL;
+		} else {
+			ctrl |= SW_HALF_DUPLEX;
+			if (tx_pause && rx_pause)
+				ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
+		}
+
+		if (speed == SPEED_10)
+			ctrl |= SW_10_MBIT;
+
+		ksz_rmw8(dev, REG_SW_CTRL_4, mask, ctrl);
+
+		p->phydev.speed = speed;
+	} else {
+		const u16 *regs = dev->info->regs;
+
+		if (duplex) {
+			if (tx_pause && rx_pause)
+				ctrl |= PORT_FORCE_FLOW_CTRL;
+		} else {
+			if (tx_pause && rx_pause)
+				ctrl |= PORT_BACK_PRESSURE;
+		}
+
+		ksz_rmw8(dev, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
+			 PORT_BACK_PRESSURE, ctrl);
 	}
 }
 
@@ -1380,8 +1420,6 @@ int ksz8_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
-	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
-
 	/* Enable automatic fast aging when link changed detected. */
 	ksz_cfg(dev, S_LINK_AGING_CTRL, SW_LINK_AUTO_AGING, true);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5568d7b22135..93131347ad98 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -208,6 +208,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
+	.phylink_mac_link_up = ksz8_phylink_mac_link_up,
 	.config_cpu_port = ksz8_config_cpu_port,
 	.enable_stp_addr = ksz8_enable_stp_addr,
 	.reset = ksz8_reset_switch,
-- 
2.39.2

