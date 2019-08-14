Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15C38D65D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNOk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:40:28 -0400
Received: from mail.nic.cz ([217.31.204.67]:34400 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfHNOk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 10:40:27 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id E277C140C21;
        Wed, 14 Aug 2019 16:40:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565793625; bh=G2EktcNdGCBJMQovRAGgYcpgI0JS0bMZ6vHXLejS0Pk=;
        h=From:To:Date;
        b=G2cs5DtmBpWP28O2C741wZnqRgKeMADCdkUPKmKIf3rlp2zl7E6/dTbBLNyJK711i
         p0ZzPLjs9sr3Yilj5gnWKsw7FTl0vFrnNQMRSM2vOCUaQU8uriTEEwmfSxo8eb4KQ5
         1VXzpjZ1N3qqJgNeUvD4MivWGtcBh2ZHZdFUfAa8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2] net: dsa: mv88e6xxx: check for mode change in port_setup_mac
Date:   Wed, 14 Aug 2019 16:40:24 +0200
Message-Id: <20190814144024.27975-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx_port_setup_mac checks if the requested MAC settings are
different from the current ones, and if not, does nothing (since chaning
them requires putting the link down).

In this check it only looks if the triplet [link, speed, duplex] is
being changed.

This patch adds support to also check if the mode parameter (of type
phy_interface_t) is requested to be changed. The current mode is
computed by the ->port_link_state() method, and if it is different from
PHY_INTERFACE_MODE_NA, we check for equality with the requested mode.

In the implementations of the mv88e6250_port_link_state() method we set
the current mode to PHY_INTERFACE_MODE_NA - so the code does not check
for mode change on 6250.

In the mv88e6352_port_link_state() method, we use the cached cmode of
the port to determine the mode as phy_interface_t (and if it is not
enough, eg. for RGMII, we also look at the port control register for
RX/TX timings).

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  4 +++-
 drivers/net/dsa/mv88e6xxx/port.c | 38 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 818a83eb2dcb..9b3ad22a5b98 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -417,7 +417,9 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 	 */
 	if (state.link == link &&
 	    state.speed == speed &&
-	    state.duplex == duplex)
+	    state.duplex == duplex &&
+	    (state.interface == mode ||
+	     state.interface == PHY_INTERFACE_MODE_NA))
 		return 0;
 
 	/* Port's MAC control must not be changed unless the link is down */
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04309ef0a1cc..c95cdb73e5a2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -590,6 +590,7 @@ int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	state->link = !!(reg & MV88E6250_PORT_STS_LINK);
 	state->an_enabled = 1;
 	state->an_complete = state->link;
+	state->interface = PHY_INTERFACE_MODE_NA;
 
 	return 0;
 }
@@ -600,6 +601,43 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 	int err;
 	u16 reg;
 
+	switch (chip->ports[port].cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_RGMII:
+		err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL,
+					  &reg);
+		if (err)
+			return err;
+
+		if ((reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK) &&
+		    (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_TXCLK))
+			state->interface = PHY_INTERFACE_MODE_RGMII_ID;
+		else if (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK)
+			state->interface = PHY_INTERFACE_MODE_RGMII_RXID;
+		else if (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_TXCLK)
+			state->interface = PHY_INTERFACE_MODE_RGMII_TXID;
+		else
+			state->interface = PHY_INTERFACE_MODE_RGMII;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+		state->interface = PHY_INTERFACE_MODE_1000BASEX;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+		state->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		state->interface = PHY_INTERFACE_MODE_2500BASEX;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_XAUI:
+		state->interface = PHY_INTERFACE_MODE_XAUI;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
+		state->interface = PHY_INTERFACE_MODE_RXAUI;
+		break;
+	default:
+		/* we do not support other cmode values here */
+		state->interface = PHY_INTERFACE_MODE_NA;
+	}
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index ceec771f8bfc..1abf5ea033e2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -42,6 +42,7 @@
 #define MV88E6XXX_PORT_STS_TX_PAUSED		0x0020
 #define MV88E6XXX_PORT_STS_FLOW_CTL		0x0010
 #define MV88E6XXX_PORT_STS_CMODE_MASK		0x000f
+#define MV88E6XXX_PORT_STS_CMODE_RGMII		0x0007
 #define MV88E6XXX_PORT_STS_CMODE_100BASE_X	0x0008
 #define MV88E6XXX_PORT_STS_CMODE_1000BASE_X	0x0009
 #define MV88E6XXX_PORT_STS_CMODE_SGMII		0x000a
-- 
2.21.0

