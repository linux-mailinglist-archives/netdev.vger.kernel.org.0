Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CD1F5BE2
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgFJTPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgFJTPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:15:17 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55000C03E96B;
        Wed, 10 Jun 2020 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zo74S6Tgm/5tnXKJIYWaheG+mRE/yn79KpLHWNR0tJU=; b=HjEzXVS3xT209+YOf9LTgpWiPK
        bIi08pg3fWQLgQ34DKbUfsiINdOI+KaGodkIadlu9cjnF9lgVVQnWT4Bu5/Vrrt4izF5IDLxiOU7X
        31ZLAuPKx7jFx4qAmjVZBqJVERCpVvBqfuhXPxyUEGHDRbPOkbYGFMQeq86GIx+72sXjAH468qMtf
        jBfrxaPhLR2+P4oWh2SPCDXqEllx0uJ1w+mN1VIAJ/vUyeMLfMPb0yx/LokEykABS2dXs4NiqqgGV
        xVVucTZw4SpN1vWOn9AQINIn/P22dd03UMR7HsiFJbDouxWDin6c3kWrqii5Dyu3ioDIJK8+1E01O
        5hdmE3ew==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jj6Bt-0005rD-RW; Wed, 10 Jun 2020 20:15:13 +0100
Date:   Wed, 10 Jun 2020 20:15:13 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves the handling of the SGMII interface on the QCA8K
devices. Previously the driver did no configuration of the port, even if
it was selected. We now configure it up in the appropriate
PHY/MAC/Base-X mode depending on what phylink tells us we are connected
to and ensure it is enabled.

Tested with a device where the CPU connection is RGMII (i.e. the common
current use case) + one where the CPU connection is SGMII. I don't have
any devices where the SGMII interface is brought out to something other
than the CPU.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 28 +++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h | 13 +++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index dcd9e8fa99b6..33e62598289e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -681,7 +681,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
+	u32 reg, val;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -740,6 +740,32 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		/* Enable SGMII on the port */
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
+
+		/* Enable/disable SerDes auto-negotiation as necessary */
+		val = qca8k_read(priv, QCA8K_REG_PWS);
+		if (phylink_autoneg_inband(mode))
+			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
+		else
+			val |= QCA8K_PWS_SERDES_AEN_DIS;
+		qca8k_write(priv, QCA8K_REG_PWS, val);
+
+		/* Configure the SGMII parameters */
+		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
+
+		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+
+		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+		if (dsa_is_cpu_port(ds, port)) {
+			/* CPU port, we're talking to the CPU MAC, be a PHY */
+			val |= QCA8K_SGMII_MODE_CTRL_PHY;
+		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			val |= QCA8K_SGMII_MODE_CTRL_MAC;
+		} else {
+			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
+		}
+
+		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 42d6ea24eb14..10ef2bca2cde 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -36,6 +36,8 @@
 #define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
+#define QCA8K_REG_PWS					0x010
+#define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
 #define QCA8K_REG_MIB					0x034
@@ -69,6 +71,7 @@
 #define   QCA8K_PORT_STATUS_LINK_UP			BIT(8)
 #define   QCA8K_PORT_STATUS_LINK_AUTO			BIT(9)
 #define   QCA8K_PORT_STATUS_LINK_PAUSE			BIT(10)
+#define   QCA8K_PORT_STATUS_FLOW_AUTO			BIT(12)
 #define QCA8K_REG_PORT_HDR_CTRL(_i)			(0x9c + (_i * 4))
 #define   QCA8K_PORT_HDR_CTRL_RX_MASK			GENMASK(3, 2)
 #define   QCA8K_PORT_HDR_CTRL_RX_S			2
@@ -77,6 +80,16 @@
 #define   QCA8K_PORT_HDR_CTRL_ALL			2
 #define   QCA8K_PORT_HDR_CTRL_MGMT			1
 #define   QCA8K_PORT_HDR_CTRL_NONE			0
+#define QCA8K_REG_SGMII_CTRL				0x0e0
+#define   QCA8K_SGMII_EN_PLL				BIT(1)
+#define   QCA8K_SGMII_EN_RX				BIT(2)
+#define   QCA8K_SGMII_EN_TX				BIT(3)
+#define   QCA8K_SGMII_EN_SD				BIT(4)
+#define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
+#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
+#define   QCA8K_SGMII_MODE_CTRL_BASEX			(0 << 22)
+#define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
+#define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
 
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
-- 
2.20.1

