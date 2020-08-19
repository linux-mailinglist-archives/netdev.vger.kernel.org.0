Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD924A34A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgHSPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbgHSPiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:38:22 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CE3C061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:38:21 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id B8AF7140A99;
        Wed, 19 Aug 2020 17:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597851497; bh=xj1eswhaxDPAvqfcGRhLYBAKnnnxPSOk7jult7LQ5Ws=;
        h=From:To:Date;
        b=l3HcMD0TtrkUha9YK2/gq9m7z24n2k1xOl3eexrFTKNELnbWZB+Lzc5Gs6G4nseKu
         T6n5xsu3DLgnHL5HuOVgmJ3IuUMqYeM2nBvqiKTp7JmDHrSm/7WAKm4dhjB6VhKZk7
         9HEKCJHPnjImS/aWoA1cnotOCn4B5jjcLC/fkwqA=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add support for 88E6393X from Amethyst family
Date:   Wed, 19 Aug 2020 17:38:16 +0200
Message-Id: <20200819153816.30834-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200819153816.30834-1-marek.behun@nic.cz>
References: <20200819153816.30834-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for 88E6393X, which differs from Peridot (6390 family)
in that instead of XAUI and RXAUI it supports 5GBASE-R, 10GBASE-R and
USXGMII modes and these modes are supported on ports 0, 9 and 10.

The USXGMII is not supported yet, since I couldn't find information
about the corresponding PHY registers.

The SERDES stats counters are not implemented, because they work
differently from Peridot and I couldn't get them to work.

The SERDES register dumps are not implemented.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  97 ++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |   4 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  77 +++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h   |   9 +++
 drivers/net/dsa/mv88e6xxx/serdes.c | 126 ++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h |   8 ++
 6 files changed, 314 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a5e2740a79db..d97b898312e20 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -637,6 +637,21 @@ static void mv88e6390x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 	mv88e6390_phylink_validate(chip, port, mask, state);
 }
 
+static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
+					unsigned long *mask,
+					struct phylink_link_state *state)
+{
+	if (port == 0 || port == 9 || port == 10) {
+		phylink_set(mask, 2500baseX_Full);
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 5000baseT_Full);
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseKR_Full);
+	}
+
+	mv88e6390_phylink_validate(chip, port, mask, state);
+}
+
 static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 			       unsigned long *supported,
 			       struct phylink_link_state *state)
@@ -4705,6 +4720,63 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
+static const struct mv88e6xxx_ops mv88e6393x_ops = {
+	/* MV88E6XXX_FAMILY_6393 */
+	.setup_errata = mv88e6390_setup_errata,
+	.irl_init_all = mv88e6390_g2_irl_init_all,
+	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
+	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
+	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
+	.phy_read = mv88e6xxx_g2_smi_phy_read,
+	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.port_set_link = mv88e6xxx_port_set_link,
+	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
+	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
+	.port_max_speed_mode = mv88e6393x_port_max_speed_mode,
+	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
+	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
+	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ether_type = mv88e6351_port_set_ether_type,
+	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_pause_limit = mv88e6390_port_pause_limit,
+	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
+	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
+	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode = mv88e6393x_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
+	.stats_snapshot = mv88e6390_g1_stats_snapshot,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
+	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
+	.stats_get_strings = mv88e6320_stats_get_strings,
+	.stats_get_stats = mv88e6390_stats_get_stats,
+	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_egress_port = mv88e6390_g1_set_egress_port,
+	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
+	.vtu_getnext = mv88e6390_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6393x_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
+	.serdes_irq_status = mv88e6393x_serdes_irq_status,
+	.gpio_ops = &mv88e6352_gpio_ops,
+	.avb_ops = &mv88e6390_avb_ops,
+	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_validate = mv88e6393x_phylink_validate,
+};
+
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 	[MV88E6085] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
@@ -5366,6 +5438,31 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ptp_support = true,
 		.ops = &mv88e6390x_ops,
 	},
+
+	[MV88E6393X] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6393X,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6393X",
+		.num_databases = 4096,
+		.num_macs = 16384,
+		.num_ports = 11,	/* 10 + Z80 */
+		.num_internal_phys = 9,
+		.num_gpio = 16,
+		.max_vid = 8191,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 9,
+		.g2_irqs = 14,
+		.atu_move_port_mask = 0x1f,
+		.pvt = true,
+		.multi_chip = true,
+		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
+		.ops = &mv88e6393x_ops,
+	},
 };
 
 static const struct mv88e6xxx_info *mv88e6xxx_lookup_info(unsigned int prod_num)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index cc23810438dfe..9b36c7a21365b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -75,6 +75,7 @@ enum mv88e6xxx_model {
 	MV88E6352,
 	MV88E6390,
 	MV88E6390X,
+	MV88E6393X,
 };
 
 enum mv88e6xxx_family {
@@ -89,7 +90,8 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6341,	/* 6141 6341 */
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
-	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
+	MV88E6XXX_FAMILY_6390,	/* 6190 6190X 6191 6290 6390 6390X */
+	MV88E6XXX_FAMILY_6393,	/* 6393X */
 };
 
 struct mv88e6xxx_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 9d5189f2474ce..8e974bc1b858e 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -187,11 +187,16 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
 		break;
 	case 2500:
-		if (alt_bit)
-			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
-				MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		if (chip->info->family == MV88E6XXX_FAMILY_6393)
+			ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
 		else
 			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000;
+		if (alt_bit)
+			ctrl |= MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 5000:
+		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
 		break;
 	case 10000:
 		/* all bits set, fall through... */
@@ -390,6 +395,31 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 	return PHY_INTERFACE_MODE_NA;
 }
 
+/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X) */
+int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex)
+{
+	if (speed == SPEED_MAX)
+		speed = (port > 0 && port < 9) ? 1000 : 10000;
+
+	if (speed == 200 && port != 0)
+		return -EOPNOTSUPP;
+
+	if (speed >= 2500 && (port > 0 && port < 9))
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true,
+					       duplex);
+}
+
+phy_interface_t mv88e6393x_port_max_speed_mode(int port)
+{
+	if (port == 0 || port == 9 || port == 10)
+		return PHY_INTERFACE_MODE_10GBASER;
+
+	return PHY_INTERFACE_MODE_NA;
+}
+
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
@@ -414,6 +444,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_2500BASEX:
 		cmode = MV88E6XXX_PORT_STS_CMODE_2500BASEX;
 		break;
+	case PHY_INTERFACE_MODE_5GBASER:
+		cmode = MV88E6393_PORT_STS_CMODE_5GBASER;
+		break;
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
 		cmode = MV88E6XXX_PORT_STS_CMODE_XAUI;
@@ -421,6 +454,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_RXAUI:
 		cmode = MV88E6XXX_PORT_STS_CMODE_RXAUI;
 		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		cmode = MV88E6393_PORT_STS_CMODE_10GBASER;
+		break;
 	default:
 		cmode = 0;
 	}
@@ -482,6 +518,15 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
+	switch (mode) {
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
+		return -EINVAL;
+	default:
+		break;
+	}
+
 	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
@@ -491,6 +536,29 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
+	switch (mode) {
+	case PHY_INTERFACE_MODE_NA:
+		return 0;
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
+		return -EINVAL;
+	default:
+		break;
+	}
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
+}
+
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode)
+{
+	if (port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
 	switch (mode) {
 	case PHY_INTERFACE_MODE_NA:
 		return 0;
@@ -541,9 +609,12 @@ int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	switch (mode) {
 	case PHY_INTERFACE_MODE_NA:
 		return 0;
+	case PHY_INTERFACE_MODE_5GBASER:
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
 		return -EINVAL;
 	default:
 		break;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 44d76ac973f62..040b691b07eff 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -59,6 +59,9 @@
 #define MV88E6185_PORT_STS_CMODE_1000BASE_X	0x0005
 #define MV88E6185_PORT_STS_CMODE_PHY		0x0006
 #define MV88E6185_PORT_STS_CMODE_DISABLED	0x0007
+#define MV88E6393_PORT_STS_CMODE_5GBASER	0x000c
+#define MV88E6393_PORT_STS_CMODE_10GBASER	0x000d
+#define MV88E6393_PORT_STS_CMODE_USXGMII	0x000e
 
 /* Offset 0x01: MAC (or PCS or Physical) Control Register */
 #define MV88E6XXX_PORT_MAC_CTL				0x01
@@ -129,6 +132,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6393X	0x3930
 #define MV88E6XXX_PORT_SWITCH_ID_REV_MASK	0x000f
 
 /* Offset 0x04: Port Control Register */
@@ -312,10 +316,13 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex);
 int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
+int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex);
 
 phy_interface_t mv88e6341_port_max_speed_mode(int port);
 phy_interface_t mv88e6390_port_max_speed_mode(int port);
 phy_interface_t mv88e6390x_port_max_speed_mode(int port);
+phy_interface_t mv88e6393x_port_max_speed_mode(int port);
 
 int mv88e6xxx_port_set_state(struct mv88e6xxx_chip *chip, int port, u8 state);
 
@@ -362,6 +369,8 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode);
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9074d1097b614..e48057b366d51 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -526,6 +526,27 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 	return *lane == -1 ? -ENODEV : 0;
 }
 
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	*lane = -1;
+	switch (port) {
+	case 0:
+	case 9:
+	case 10:
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
+		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
+		    cmode == MV88E6393_PORT_STS_CMODE_5GBASER ||
+		    cmode == MV88E6393_PORT_STS_CMODE_10GBASER ||
+		    cmode == MV88E6393_PORT_STS_CMODE_USXGMII)
+			*lane = port;
+	}
+
+	return *lane == -1 ? -ENODEV : 0;
+}
+
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
 static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 				      bool up)
@@ -678,8 +699,8 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_power_sgmii(chip, lane, up);
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_XAUI:
-	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
+	case MV88E6XXX_PORT_STS_CMODE_XAUI: /* also MV88E6393_PORT_STS_CMODE_5GBASER */
+	case MV88E6XXX_PORT_STS_CMODE_RXAUI: /* also MV88E6393_PORT_STS_CMODE_10GBASER */
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
 	}
@@ -785,7 +806,10 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 
 	state->link = !!(status & MDIO_STAT1_LSTATUS);
 	if (state->link) {
-		state->speed = SPEED_10000;
+		if (state->interface == PHY_INTERFACE_MODE_5GBASER)
+			state->speed = SPEED_5000;
+		else
+			state->speed = SPEED_10000;
 		state->duplex = DUPLEX_FULL;
 	}
 
@@ -801,8 +825,10 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
 							    state);
+	case PHY_INTERFACE_MODE_5GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
 		return mv88e6390_serdes_pcs_get_state_10g(chip, port, lane,
 							  state);
 
@@ -878,6 +904,23 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
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
 					     u8 lane, bool enable)
 {
@@ -906,6 +949,36 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 	return 0;
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
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				 bool enable)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
+	case MV88E6393_PORT_STS_CMODE_5GBASER:
+	case MV88E6393_PORT_STS_CMODE_10GBASER:
+		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
+	}
+
+	return 0;
+}
+
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 					     u8 lane, u16 *status)
 {
@@ -942,6 +1015,53 @@ irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 	return ret;
 }
 
+static int mv88e6393x_serdes_irq_status_10g(struct mv88e6xxx_chip *chip,
+					    u8 lane, u16 *status)
+{
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_10G_INT_STATUS, status);
+
+	return err;
+}
+
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					 u8 lane)
+{
+	u8 cmode = chip->ports[port].cmode;
+	irqreturn_t ret = IRQ_NONE;
+	u16 status;
+	int err;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
+		if (err)
+			return ret;
+		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
+			      MV88E6390_SGMII_INT_LINK_UP)) {
+			ret = IRQ_HANDLED;
+			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
+		}
+		break;
+	case MV88E6393_PORT_STS_CMODE_5GBASER:
+	case MV88E6393_PORT_STS_CMODE_10GBASER:
+		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
+		if (err)
+			return ret;
+		if (status & MV88E6393X_10G_INT_LINK_CHANGE) {
+			ret = IRQ_HANDLED;
+			mv88e6393x_serdes_irq_link_10g(chip, port, lane);
+		}
+		break;
+	}
+
+	return ret;
+}
+
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
 	return irq_find_mapping(chip->g2_irq.domain, port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 95d04dab8d251..3999195caa62a 100644
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
@@ -77,6 +80,7 @@ int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				u8 lane, unsigned int mode,
 				phy_interface_t interface,
@@ -109,10 +113,14 @@ int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable);
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+				 bool enable);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					u8 lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					u8 lane);
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					 u8 lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-- 
2.26.2

