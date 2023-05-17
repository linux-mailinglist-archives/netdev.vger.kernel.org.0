Return-Path: <netdev+bounces-3337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 402387067B6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FBD81C20C67
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A3131114;
	Wed, 17 May 2023 12:11:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624A31104
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:11:12 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF65FE2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:10:52 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzK-0001Hv-R6; Wed, 17 May 2023 14:10:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzI-000pzz-HZ; Wed, 17 May 2023 14:10:36 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzFzH-00FxD3-TT; Wed, 17 May 2023 14:10:35 +0200
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
Subject: [PATCH net-next v2 2/2] net: dsa: microchip: ksz8: Add function to configure downstream ports for KSZ8xxx
Date: Wed, 17 May 2023 14:10:34 +0200
Message-Id: <20230517121034.3801640-3-o.rempel@pengutronix.de>
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

This patch introduces the function 'ksz8_downstram_link_up' to the
Microchip KSZ8xxx driver. This function configures the flow control settings
for the downstream ports of the switch based on desired settings and the
current duplex mode.

The KSZ8795 switch, unlike the KSZ8873, supports asynchronous pause control.
However, a single bit controls both RX and TX pause, so we can't enforce
asynchronous pause control. The flow control can be set based on the
auto-negotiation process, depending on the capabilities of both link partners.

For the KSZ8873, the PORT_FORCE_FLOW_CTRL bit can be set by the hardware
bootstrap, ignoring the auto-negotiation result. Therefore, even in
auto-negotiation mode, we need to ensure that the PORT_FORCE_FLOW_CTRL bit is
correctly set.

In the absence of auto-negotiation, we will enforce synchronous pause control
for the KSZ8795 switch.

Note: It is currently not possible to force disable flow control on a port if
we still advertise pause support. This configuration is not currently supported
by Linux, and it may not make practical sense. However, it's essential to
understand this limitation when working with the KSZ8873 and similar devices.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 84 +++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 75b98a5d53af..a6cacf273991 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1371,6 +1371,88 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
+/**
+ * ksz8_downstram_link_up - Configures the downstream port of the switch.
+ * @dev: The KSZ device instance.
+ * @port: The port number to configure.
+ * @duplex: The desired duplex mode.
+ * @tx_pause: If true, enables transmit pause.
+ * @rx_pause: If true, enables receive pause.
+ *
+ * Description:
+ * The function configures flow control settings for a given port based on the
+ * desired settings and current duplex mode.
+ *
+ * According to the KSZ8873 datasheet, the PORT_FORCE_FLOW_CTRL bit in the
+ * Port Control 2 register (0x1A for Port 1, 0x22 for Port 2, 0x32 for Port 3)
+ * determines how flow control is handled on the port:
+ *    "1 = will always enable full-duplex flow control on the port, regardless
+ *         of AN result.
+ *     0 = full-duplex flow control is enabled based on AN result."
+ *
+ * This means that the flow control behavior depends on the state of this bit:
+ * - If PORT_FORCE_FLOW_CTRL is set to 1, the switch will ignore AN results and
+ *   force flow control on the port.
+ * - If PORT_FORCE_FLOW_CTRL is set to 0, the switch will enable or disable
+ *   flow control based on the AN results.
+ *
+ * However, there is a potential limitation in this configuration. It is
+ * currently not possible to force disable flow control on a port if we still
+ * advertise pause support. While such a configuration is not currently
+ * supported by Linux, and may not make practical sense, it's important to be
+ * aware of this limitation when working with the KSZ8873 and similar devices.
+ */
+static void ksz8_downstram_link_up(struct ksz_device *dev, int port,
+				   int duplex, bool tx_pause, bool rx_pause)
+{
+	const u16 *regs = dev->info->regs;
+	u8 ctrl = 0;
+	int ret;
+
+	/*
+	 * The KSZ8795 switch differs from the KSZ8873 by supporting
+	 * asynchronous pause control. However, since a single bit is used to
+	 * control both RX and TX pause, we can't enforce asynchronous pause
+	 * control - both TX and RX pause will be either enabled or disabled
+	 * together.
+	 *
+	 * If auto-negotiation is enabled, we usually allow the flow control to
+	 * be determined by the auto-negotiation process based on the
+	 * capabilities of both link partners. However, for KSZ8873, the
+	 * PORT_FORCE_FLOW_CTRL bit may be set by the hardware bootstrap,
+	 * ignoring the auto-negotiation result. Thus, even in auto-negotiatio
+	 * mode, we need to ensure that the PORT_FORCE_FLOW_CTRL bit is
+	 * properly cleared.
+	 *
+	 * In the absence of auto-negotiation, we will enforce synchronous
+	 * pause control for the KSZ8795 switch.
+	 */
+	if (duplex) {
+		bool aneg_en = false;
+
+		ret = ksz_pread8(dev, port, regs[P_FORCE_CTRL], &ctrl);
+		if (ret)
+			return;
+
+		if (ksz_is_ksz88x3(dev)) {
+			if ((ctrl & PORT_AUTO_NEG_ENABLE))
+				aneg_en = true;
+		} else {
+			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
+				aneg_en = true;
+		}
+
+		if (!aneg_en && (tx_pause || rx_pause))
+			ctrl |= PORT_FORCE_FLOW_CTRL;
+	} else {
+		if (tx_pause || rx_pause)
+			ctrl |= PORT_BACK_PRESSURE;
+	}
+
+	ksz_prmw8(dev, port, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
+		  PORT_BACK_PRESSURE, ctrl);
+}
+
 /**
  * ksz8_upstram_link_up - Configures the CPU/upstream port of the switch.
  * @dev: The KSZ device instance.
@@ -1414,6 +1496,8 @@ void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
 	if (dsa_is_upstream_port(dev->ds, port))
 		ksz8_upstram_link_up(dev, port, speed, duplex, tx_pause,
 				     rx_pause);
+	else
+		ksz8_downstram_link_up(dev, port, duplex, tx_pause, rx_pause);
 }
 
 static int ksz8_handle_global_errata(struct dsa_switch *ds)
-- 
2.39.2


