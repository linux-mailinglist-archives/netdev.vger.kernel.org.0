Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5838202335
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 12:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgFTKbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 06:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgFTKbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 06:31:10 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DF4C06174E;
        Sat, 20 Jun 2020 03:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3Xn1zf3T3INmNdHOM/bMhUMSVLMNwPdYgwO5kNvKgl8=; b=gJtrXiV3Qk293P2iJZogMkCBBi
        mOcBu/d2wXxZc/esMS2BWyZSZAE6jL/x/t65Y0T/VSHiZfNWoCYVLCHiWt5i9VlUS8b6FG35v9W/s
        GAtNv7nR2kLIUIXi+rb5J2jno4zRYm7MVmDvb1TO/z+TnChXDur9hlbKMZ7cY8hQjPPUcXtjtlEyx
        SuuibsBC7RoQiU4FGNEvTpy4xmBiOopJRmNgvNa0cMLWOTD/g55tssIfE0DmYu917wKaHuathNmS3
        32l0OdLC125QtTb9DtDCF7E9zgGxaYrJMoNuUaI5+4PoEWB9xTMybTM/mHJEtDzSOcpNLEpyEYE3a
        KOT6qffg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jmam9-0004BS-A1; Sat, 20 Jun 2020 11:31:05 +0100
Date:   Sat, 20 Jun 2020 11:31:05 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 2/3] net: dsa: qca8k: Improve SGMII interface
 handling
Message-ID: <a1916a08fc522ef774f1ceed7feadbcae5b305e9.1592648711.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
 <cover.1592648711.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1592648711.git.noodles@earth.li>
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
 drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h | 13 +++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 63b84789f16b..11d1c290d90f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -673,6 +673,9 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
 
+	/* We don't have interrupts for link changes, so we need to poll */
+	ds->pcs_poll = true;
+
 	return 0;
 }
 
@@ -681,7 +684,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
+	u32 reg, val;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -740,6 +743,34 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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
+		if (dsa_is_cpu_port(ds, port)) {
+			/* CPU port, we're talking to the CPU MAC, be a PHY */
+			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+			val |= QCA8K_SGMII_MODE_CTRL_PHY;
+		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+			val |= QCA8K_SGMII_MODE_CTRL_MAC;
+		} else if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
+			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
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

