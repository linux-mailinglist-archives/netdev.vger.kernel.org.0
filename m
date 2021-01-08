Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD9A2EF408
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhAHOhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbhAHOhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 09:37:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7984723998;
        Fri,  8 Jan 2021 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610116626;
        bh=onCuP3OPQU6rcZksRkzZzSCM0BrTHOJxzk/WCIU25e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUcphE+RfI9pqVDrRsSJJBpOJnfXegA8fG5O3QTk0n1rPfGy7PTVPrQGKnzJbGgFG
         zbMYjVXh0Lm/jtEodpTjBeJNCib2ajV197xBCygrm2QIwF8HltbtSn6can1xKZhF8X
         iVfDFwbijDA4sQkyM11KoOpvxAzrcevjFt/zLGbybQQqj6pAw4vnuKv9zOgaMN/rvc
         XMEDzBQ2n+UwQ60ZskqiWhpO+grglAbJLfgbWKWO6keZS6xH4b7u+n12/E7jJsaVUn
         WmTIk1aAMyoLXUqbuFvVSk+WFD/q16pB4cHI8gDDRTxUFlo5eDmZTqsFONbYEBTJ4l
         mKSRSSo38IBVg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH] changes for Pavana
Date:   Fri,  8 Jan 2021 15:36:58 +0100
Message-Id: <20210108143658.4176-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- some nitpicks are fixed here, mostly alignemnts
- also mv88e6393x_serdes_power() now enables 10g PHY not only for
  10gbase-r, but also for 5gbase-r mode

Pavana, you can apply this patch as previously:
  cd linux
  patch -p1 <path-to.patch
  git commit --amend drivers/net/dsa/mv88e6xxx/{port,serdes}.{c,h}

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.c   | 24 +++++++---------
 drivers/net/dsa/mv88e6xxx/port.h   | 12 ++++----
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 ++++++++++++++++--------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 18 ++++++------
 4 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index c38fcb8163ce..7025c1e83beb 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -436,13 +436,11 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 }
 
 /* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
- * This function adds new speed 5000 supported by Amethyst family.
  * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
  * values for speeds 2500 & 5000 conflict.
  */
-
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
-		int speed, int duplex)
+				     int speed, int duplex)
 {
 	u16 reg, ctrl;
 	int err;
@@ -506,8 +504,8 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 		return err;
 
 	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
-			MV88E6390_PORT_MAC_CTL_ALTSPEED |
-			MV88E6390_PORT_MAC_CTL_FORCE_SPEED);
+		 MV88E6390_PORT_MAC_CTL_ALTSPEED |
+		 MV88E6390_PORT_MAC_CTL_FORCE_SPEED);
 
 	if (speed != SPEED_UNFORCED)
 		reg |= MV88E6390_PORT_MAC_CTL_FORCE_SPEED;
@@ -543,7 +541,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		cmode = MV88E6XXX_PORT_STS_CMODE_2500BASEX;
 		break;
 	case PHY_INTERFACE_MODE_5GBASER:
-		cmode = MV88E6XXX_PORT_STS_CMODE_5GBASER;
+		cmode = MV88E6393X_PORT_STS_CMODE_5GBASER;
 		break;
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
@@ -554,10 +552,10 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_10GKR:
-		cmode = MV88E6XXX_PORT_STS_CMODE_10GBASER;
+		cmode = MV88E6393X_PORT_STS_CMODE_10GBASER;
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
-		cmode = MV88E6XXX_PORT_STS_CMODE_USXGMII;
+		cmode = MV88E6393X_PORT_STS_CMODE_USXGMII;
 		break;
 	default:
 		cmode = 0;
@@ -1278,9 +1276,8 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
 /* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X */
 
 static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
-				u8 data)
+					u8 data)
 {
-
 	int err = 0;
 	int port;
 	u16 reg;
@@ -1299,8 +1296,8 @@ static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer
 }
 
 int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
-				enum mv88e6xxx_egress_direction direction,
-				int port)
+			       enum mv88e6xxx_egress_direction direction,
+			       int port)
 {
 	u16 ptr;
 	int err;
@@ -1319,6 +1316,7 @@ int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
 			return err;
 		break;
 	}
+
 	return 0;
 }
 
@@ -1374,7 +1372,7 @@ static int mv88e6393x_port_epc_wait_ready(struct mv88e6xxx_chip *chip, int port)
 /* Port Ether type for 6393X family */
 
 int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
-					u16 etype)
+				   u16 etype)
 {
 	u16 val;
 	int err;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 051665fa22d5..70a5b246b7e2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -49,9 +49,9 @@
 #define MV88E6XXX_PORT_STS_CMODE_2500BASEX	0x000b
 #define MV88E6XXX_PORT_STS_CMODE_XAUI		0x000c
 #define MV88E6XXX_PORT_STS_CMODE_RXAUI		0x000d
-#define MV88E6XXX_PORT_STS_CMODE_5GBASER	0x000c
-#define MV88E6XXX_PORT_STS_CMODE_10GBASER	0x000d
-#define MV88E6XXX_PORT_STS_CMODE_USXGMII	0x000e
+#define MV88E6393X_PORT_STS_CMODE_5GBASER	0x000c
+#define MV88E6393X_PORT_STS_CMODE_10GBASER	0x000d
+#define MV88E6393X_PORT_STS_CMODE_USXGMII	0x000e
 #define MV88E6185_PORT_STS_CDUPLEX		0x0008
 #define MV88E6185_PORT_STS_CMODE_MASK		0x0007
 #define MV88E6185_PORT_STS_CMODE_GMII_FD	0x0000
@@ -317,7 +317,7 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
 			 u16 val);
 int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
-		int bit, int val);
+			    int bit, int val);
 int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
 			     int pause);
 int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
@@ -345,7 +345,7 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
-					int speed, int duplex);
+				     int speed, int duplex);
 phy_interface_t mv88e6341_port_max_speed_mode(int port);
 phy_interface_t mv88e6390_port_max_speed_mode(int port);
 phy_interface_t mv88e6390x_port_max_speed_mode(int port);
@@ -385,7 +385,7 @@ int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
 int mv88e6393x_port_set_cpu_dest(struct mv88e6xxx_chip *chip, int port);
 int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
-				u16 etype);
+				   u16 etype);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index ae21d1dea9ba..94262c02c658 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -649,12 +649,13 @@ int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		return -EOPNOTSUPP;
 
 	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
-		cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-		cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
-		cmode == MV88E6XXX_PORT_STS_CMODE_5GBASER ||
-		cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER ||
-		cmode == MV88E6XXX_PORT_STS_CMODE_USXGMII)
+	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_5GBASER ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_USXGMII)
 		lane = port;
+
 	return lane;
 }
 
@@ -1121,7 +1122,7 @@ static int mv88e6393x_serdes_irq_enable_10g(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				int lane, bool enable)
+				 int lane, bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
 
@@ -1130,8 +1131,8 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
-	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
-	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
 	}
 
@@ -1150,7 +1151,7 @@ static int mv88e6393x_serdes_irq_status_10g(struct mv88e6xxx_chip *chip,
 }
 
 irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane)
+					 int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -1170,8 +1171,8 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
 		}
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
-	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
 		if (err)
 			return err;
@@ -1351,7 +1352,7 @@ int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
 }
 
 static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
-					bool on)
+					 bool on)
 {
 	u8 cmode = chip->ports[lane].cmode;
 	u16 config, pcs;
@@ -1363,7 +1364,7 @@ static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		pcs = MV88E6393X_PCS_SELECT_2500BASEX;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		pcs = MV88E6393X_PCS_SELECT_10GBASER;
 		break;
 	default:
@@ -1378,15 +1379,15 @@ static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
 		 * Workaround: Set Port0 SERDES register 4.F002.5=0
 		 */
 		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6393X_SERDES_POC, &config);
+				      MV88E6393X_SERDES_POC, &config);
 		config &= ~(MV88E6393X_SERDES_POC_PCS_MODE_MASK |
-				MV88E6393X_SERDES_POC_PDOWN);
+			    MV88E6393X_SERDES_POC_PDOWN);
 		config |= pcs;
 		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6393X_SERDES_POC, config);
+				       MV88E6393X_SERDES_POC, config);
 		config |= MV88E6393X_SERDES_POC_RESET;
 		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6393X_SERDES_POC, config);
+				       MV88E6393X_SERDES_POC, config);
 
 		/* mv88e6393x family errata 3.7 :
 		 * When changing cmode on SERDES port from any other mode to
@@ -1396,21 +1397,21 @@ static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
 		 */
 		config = MV88E6390_SGMII_ANAR_1000BASEX_FD;
 		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6390_SGMII_ANAR, config);
+				       MV88E6390_SGMII_ANAR, config);
 
 		/* soft reset the PCS/PMA */
 		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6390_SGMII_CONTROL, &config);
+				      MV88E6390_SGMII_CONTROL, &config);
 		config |= MV88E6390_SGMII_CONTROL_RESET;
 		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				MV88E6390_SGMII_CONTROL, config);
+				       MV88E6390_SGMII_CONTROL, config);
 	}
 
 	return 0;
 }
 
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-		    bool on)
+			    bool on)
 {
 	u8 cmode;
 
@@ -1425,7 +1426,8 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		return mv88e6390_serdes_power_sgmii(chip, lane, on);
-	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		return mv88e6390_serdes_power_10g(chip, lane, on);
 	}
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 4015db6287ca..773f35edf433 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -84,9 +84,9 @@
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
 
-#define MV88E6393X_PORT0_LANE		0x00
-#define MV88E6393X_PORT9_LANE		0x09
-#define MV88E6393X_PORT10_LANE		0x0a
+#define MV88E6393X_PORT0_LANE			0x00
+#define MV88E6393X_PORT9_LANE			0x09
+#define MV88E6393X_PORT10_LANE			0x0a
 
 /* Port Operational Configuration */
 #define MV88E6393X_PCS_SELECT_1000BASEX		0x0000
@@ -98,13 +98,13 @@
 #define MV88E6393X_PCS_SELECT_USXGMII_PHY	0x0006
 #define MV88E6393X_PCS_SELECT_USXGMII_MAC	0x0007
 
-#define MV88E6393X_SERDES_POC		0xf002
-#define MV88E6393X_SERDES_POC_PCS_MODE_MASK		0x0007
+#define MV88E6393X_SERDES_POC			0xf002
+#define MV88E6393X_SERDES_POC_PCS_MODE_MASK	0x0007
 #define MV88E6393X_SERDES_POC_RESET		BIT(15)
 #define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
 #define MV88E6393X_SERDES_POC_ANEG		BIT(3)
 
-#define MV88E6393X_ERRATA_1000BASEX_SGMII		0xF074
+#define MV88E6393X_ERRATA_1000BASEX_SGMII	0xF074
 #define MV88E6393X_ERRATA_1000BASEX_SGMII_BIT	BIT(14)
 
 int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
@@ -148,7 +148,7 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-		    bool on);
+			    bool on);
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip);
 int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
@@ -157,7 +157,7 @@ int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-	    int lane, bool enable);
+				 int lane, bool enable);
 irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
@@ -165,7 +165,7 @@ irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
 irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane);
+					 int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-- 
2.26.2

