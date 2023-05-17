Return-Path: <netdev+bounces-3336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E767067B5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E841B1C20D7F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A738731113;
	Wed, 17 May 2023 12:11:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9621B2C748
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:11:12 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5ED5FEB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:10:52 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzK-0001I0-R4; Wed, 17 May 2023 14:10:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzI-000q05-Oi; Wed, 17 May 2023 14:10:36 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzH-00FxCr-Ss; Wed, 17 May 2023 14:10:35 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v2 1/2] net: dsa: microchip: ksz8: Make flow control, speed, and duplex on CPU port configurable
Date: Wed, 17 May 2023 14:10:33 +0200
Message-Id: <20230517121034.3801640-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230517121034.3801640-1-o.rempel@pengutronix.de>
References: <20230517121034.3801640-1-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
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

Allow flow control, speed, and duplex settings on the CPU port to be
configurable. Previously, the speed and duplex relied on default switch
values, which limited flexibility. Additionally, flow control was
hardcoded and only functional in duplex mode. This update enhances the
configurability of these parameters.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h       |  4 +++
 drivers/net/dsa/microchip/ksz8795.c    | 47 ++++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.c |  1 +
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index e68465fdf6b9..ec02baca726f 100644
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
index f56fca1b1a22..75b98a5d53af 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1371,6 +1371,51 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
+/**
+ * ksz8_upstram_link_up - Configures the CPU/upstream port of the switch.
+ * @dev: The KSZ device instance.
+ * @port: The port number to configure.
+ * @speed: The desired link speed.
+ * @duplex: The desired duplex mode.
+ * @tx_pause: If true, enables transmit pause.
+ * @rx_pause: If true, enables receive pause.
+ *
+ * Description:
+ * The function configures flow control and speed settings for the CPU/upstream
+ * port of the switch based on the desired settings, current duplex mode, and
+ * speed.
+ */
+static void ksz8_upstram_link_up(struct ksz_device *dev, int port, int speed,
+				 int duplex, bool tx_pause, bool rx_pause)
+{
+	u8 ctrl = 0;
+
+	if (duplex) {
+		if (tx_pause || rx_pause)
+			ctrl |= SW_FLOW_CTRL;
+	} else {
+		ctrl |= SW_HALF_DUPLEX;
+		if (tx_pause || rx_pause)
+			ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
+	}
+
+	if (speed == SPEED_10)
+		ctrl |= SW_10_MBIT;
+
+	ksz_rmw8(dev, REG_SW_CTRL_4, SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
+		 SW_FLOW_CTRL | SW_10_MBIT, ctrl);
+}
+
+void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
+			      unsigned int mode, phy_interface_t interface,
+			      struct phy_device *phydev, int speed, int duplex,
+			      bool tx_pause, bool rx_pause)
+{
+	if (dsa_is_upstream_port(dev->ds, port))
+		ksz8_upstram_link_up(dev, port, speed, duplex, tx_pause,
+				     rx_pause);
+}
+
 static int ksz8_handle_global_errata(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -1419,8 +1464,6 @@ int ksz8_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
-	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
-
 	/* Enable automatic fast aging when link changed detected. */
 	ksz_cfg(dev, S_LINK_AGING_CTRL, SW_LINK_AUTO_AGING, true);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a4428be5f483..6e19ad70c671 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -210,6 +210,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
+	.phylink_mac_link_up = ksz8_phylink_mac_link_up,
 	.config_cpu_port = ksz8_config_cpu_port,
 	.enable_stp_addr = ksz8_enable_stp_addr,
 	.reset = ksz8_reset_switch,
-- 
2.39.2


