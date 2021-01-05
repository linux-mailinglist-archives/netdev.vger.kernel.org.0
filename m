Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16882EAAFD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbhAEMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbhAEMiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 07:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96562226A;
        Tue,  5 Jan 2021 12:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609850284;
        bh=c1JwHuWKIlx1xv2KGZnyHDFR8sDjCB+gPYo/G+wROM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZkKBsz1G2VoJczYxxVP0bS1XGUBKPcWK2SVEz9yCrJNd+TQgoToxY6n/WPaB5yZu
         2kc9ifss5HInAD/cO2Ye95DE1bi1UHyZSILCz3uYfr/us9Ju5/iCjoTNUumf68m4+f
         l0wdGEZb3iDCXeVHGbfKsf9VVcb4gEOwDV6Lao6WoaKMk9NHamIY0oXxKm3IfwDLjB
         XI3w0xEfuRpXrjiIEtay/ClhavxH1RZoTVFB152bd4NZF+F7gz76woMRL9UQgzDYnj
         IoDH1EjIrdrLMPeF/OzvNClTNRPB7OGMjIfWjorkMR8m70k+hPsbsBs93LRcdud07Q
         J90CDqnBAqyNw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, ashkan.boldaji@digi.com,
        davem@davemloft.net, f.fainelli@gmail.com, lkp@intel.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: patch fixing mv88e6393x SERDES IRQ for Pavana's series
Date:   Tue,  5 Jan 2021 13:37:55 +0100
Message-Id: <20210105123755.30552-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <2c2bb4b92484ce21c0cf43076d6c7921bae7456a.1607685097.git.pavana.sharma@digi.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavana, please add this changes to your patch
  net: dsa: mv88e6xxx: Add support for mv88e6393x  family of Marvell

It fixes SERDES IRQ enablement and status reading for 10G on 6393x.

Also, there is a double space in your commit title (between words
"mv88e6393x" and "family"), please fix this.

You can add my Co-developed-by tag, if you want.

Co-developed-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |   2 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 100 +++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |   5 ++
 3 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fd6e4106f98e..ab929d9d93f3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4001,7 +4001,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6393x_serdes_power,
 	.serdes_get_lane = mv88e6393x_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_get_state = mv88e6393x_serdes_pcs_get_state,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
 	.serdes_irq_status = mv88e6393x_serdes_irq_status,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 622fe6df2ff9..ae21d1dea9ba 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -923,6 +923,30 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
+					       int port, int lane,
+					       struct phylink_link_state *state)
+{
+	u16 status;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err)
+		return err;
+
+	state->link = !!(status & MDIO_STAT1_LSTATUS);
+	if (state->link) {
+		if (state->interface == PHY_INTERFACE_MODE_5GBASER)
+			state->speed = SPEED_5000;
+		else
+			state->speed = SPEED_10000;
+		state->duplex = DUPLEX_FULL;
+	}
+
+	return 0;
+}
+
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
@@ -942,6 +966,25 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	}
 }
 
+int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				    int lane, struct phylink_link_state *state)
+{
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
+							    state);
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_10GBASER:
+		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
+							   state);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    int lane)
 {
@@ -1009,6 +1052,23 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
 }
 
+static void mv88e6393x_serdes_irq_link_10g(struct mv88e6xxx_chip *chip,
+					   int port, u8 lane)
+{
+	u16 status;
+	int err;
+
+	/* If the link has dropped, we want to know about it. */
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes STAT1: %d\n", err);
+		return;
+	}
+
+	dsa_port_phylink_mac_change(chip->ds, port, !!(status & MDIO_STAT1_LSTATUS));
+}
+
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 					     int lane, bool enable)
 {
@@ -1048,21 +1108,44 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 	return err;
 }
 
+static int mv88e6393x_serdes_irq_enable_10g(struct mv88e6xxx_chip *chip,
+					    u8 lane, bool enable)
+{
+	u16 val = 0;
+
+	if (enable)
+		val |= MV88E6393X_10G_INT_LINK_CHANGE;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6393X_10G_INT_ENABLE, val);
+}
+
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 				int lane, bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
 	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
 	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
-		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
+		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
+	return 0;
+}
+
+static int mv88e6393x_serdes_irq_status_10g(struct mv88e6xxx_chip *chip,
+					    u8 lane, u16 *status)
+{
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_10G_INT_STATUS, status);
+
 	return err;
 }
 
@@ -1078,8 +1161,6 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
-	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
 		if (err)
 			return ret;
@@ -1088,6 +1169,17 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 			ret = IRQ_HANDLED;
 			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
 		}
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
+	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
+		if (err)
+			return err;
+		if (status & MV88E6393X_10G_INT_LINK_CHANGE) {
+			ret = IRQ_HANDLED;
+			mv88e6393x_serdes_irq_link_10g(chip, port, lane);
+		}
+		break;
 	}
 
 	return ret;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index f17ddbb70127..4015db6287ca 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -42,6 +42,9 @@
 /* 10GBASE-R and 10GBASE-X4/X2 */
 #define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
 #define MV88E6390_10G_STAT1		(0x1000 + MDIO_STAT1)
+#define MV88E6393X_10G_INT_ENABLE	0x9000
+#define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
+#define MV88E6393X_10G_INT_STATUS	0x9001
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
@@ -124,6 +127,8 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
+int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				    int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    int lane);
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-- 
2.26.2

