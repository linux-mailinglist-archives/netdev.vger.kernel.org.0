Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DFC33F171
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhCQNr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhCQNrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 09:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB7B64F70;
        Wed, 17 Mar 2021 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615988844;
        bh=zNZ0OeccKUqo0oZGDr4+RfG3RRdzQ0QPeBNO13OmbXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYrd2En62ByGj6IwYzb8sGFAtZ86HwfJVj3htXZw39XJCE0EStwhE8Z5j8qqa9yAi
         uRSoSfhtWcA1bhUV3V1WhIncAzzRiIdC10OJFLwmvE7Jaxya9IUo5aXHbVlcCCxoXN
         bC0aD8nRDf+78KzfXYowb4yBje8bQQmeBaWlTDZwRoSAwgBFVjiQBkqiYywHEgCpml
         6KeadvR2YQ2dDXphGzu2jBtV1uC9M3l7EbGVxwzM4Tl5vH4L2WSPwbKv0NmI1TUoUo
         Cc2OYRIVOozGr8CeSySY6rxCmCRyhRGmQfLY7wRVjUieBGccSmIY6uzJHE3QJT2WFh
         QZ/ZJmR5PJeJg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        olteanv@gmail.com, andrew@lunn.ch, ashkan.boldaji@digi.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, lkp@intel.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v17 3/4] net: dsa: mv88e6xxx: add support for mv88e6393x family
Date:   Wed, 17 Mar 2021 14:46:42 +0100
Message-Id: <20210317134643.24463-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317134643.24463-1-kabel@kernel.org>
References: <20210317134643.24463-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavana Sharma <pavana.sharma@digi.com>

The Marvell 88E6393X device is a single-chip integration of a 11-port
Ethernet switch with eight integrated Gigabit Ethernet (GbE)
transceivers and three 10-Gigabit interfaces.

This patch adds functionalities specific to mv88e6393x family (88E6393X,
88E6193X and 88E6191X).

The main differences between previous devices and this one are:
- port 0 can be a SERDES port
- all SERDESes are one-lane, eg. no XAUI nor RXAUI
- on the other hand the SERDESes can do USXGMII, 10GBASER and 5GBASER
  (on 6191X only one SERDES is capable of more than 1g; USXGMII is not
  yet supported with this change)
- Port Policy CTL register is changed to Port Policy MGMT CTL register,
  via which several more registers can be accessed indirectly
- egress monitor port is configured differently
- ingress monitor/CPU/mirror ports are configured differently and can be
  configured per port (ie. each port can have different ingress monitor
  port, for example)
- port speed AltBit works differently than previously
- PHY registers can be also accessed via MDIO address 0x18 and 0x19
  (on previous devices they could be accessed only via Global 2 offsets
   0x18 and 0x19, which means two indirections; this feature is not yet
   leveraged with thiis commit)

Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Co-developed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 155 ++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h |   8 +
 drivers/net/dsa/mv88e6xxx/port.c    | 267 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  45 +++++
 drivers/net/dsa/mv88e6xxx/serdes.c  | 256 ++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h  |  34 ++++
 8 files changed, 771 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fc9d3875f099..0ffeb73a4058 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -635,6 +635,29 @@ static void mv88e6390x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 	mv88e6390_phylink_validate(chip, port, mask, state);
 }
 
+static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
+					unsigned long *mask,
+					struct phylink_link_state *state)
+{
+	if (port == 0 || port == 9 || port == 10) {
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseKR_Full);
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseER_Full);
+		phylink_set(mask, 5000baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+		phylink_set(mask, 2500baseT_Full);
+	}
+
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
+
+	mv88e6065_phylink_validate(chip, port, mask, state);
+}
+
 static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 			       unsigned long *supported,
 			       struct phylink_link_state *state)
@@ -4589,6 +4612,69 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
+static const struct mv88e6xxx_ops mv88e6393x_ops = {
+	/* MV88E6XXX_FAMILY_6393 */
+	.setup_errata = mv88e6393x_serdes_setup_errata,
+	.irl_init_all = mv88e6390_g2_irl_init_all,
+	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
+	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
+	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
+	.phy_read = mv88e6xxx_g2_smi_phy_read,
+	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.port_set_link = mv88e6xxx_port_set_link,
+	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
+	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
+	.port_max_speed_mode = mv88e6393x_port_max_speed_mode,
+	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
+	.port_set_ether_type = mv88e6393x_port_set_ether_type,
+	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_pause_limit = mv88e6390_port_pause_limit,
+	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
+	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
+	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode = mv88e6393x_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
+	.port_set_upstream_port = mv88e6393x_port_set_upstream_port,
+	.stats_snapshot = mv88e6390_g1_stats_snapshot,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
+	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
+	.stats_get_strings = mv88e6320_stats_get_strings,
+	.stats_get_stats = mv88e6390_stats_get_stats,
+	/* .set_cpu_port is missing because this family does not support a global
+	 * CPU port, only per port CPU port which is set via
+	 * .port_set_upstream_port method.
+	 */
+	.set_egress_port = mv88e6393x_set_egress_port,
+	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
+	.vtu_getnext = mv88e6390_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.serdes_power = mv88e6393x_serdes_power,
+	.serdes_get_lane = mv88e6393x_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6393x_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
+	.serdes_irq_status = mv88e6393x_serdes_irq_status,
+	/* TODO: serdes stats */
+	.gpio_ops = &mv88e6352_gpio_ops,
+	.avb_ops = &mv88e6390_avb_ops,
+	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_validate = mv88e6393x_phylink_validate,
+};
+
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 	[MV88E6085] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
@@ -4960,6 +5046,52 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ops = &mv88e6191_ops,
 	},
 
+	[MV88E6191X] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6191X,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6191X",
+		.num_databases = 4096,
+		.num_ports = 11,	/* 10 + Z80 */
+		.num_internal_phys = 9,
+		.max_vid = 8191,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 10,
+		.g2_irqs = 14,
+		.atu_move_port_mask = 0x1f,
+		.pvt = true,
+		.multi_chip = true,
+		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
+		.ops = &mv88e6393x_ops,
+	},
+
+	[MV88E6193X] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6193X,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6193X",
+		.num_databases = 4096,
+		.num_ports = 11,	/* 10 + Z80 */
+		.num_internal_phys = 9,
+		.max_vid = 8191,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 10,
+		.g2_irqs = 14,
+		.atu_move_port_mask = 0x1f,
+		.pvt = true,
+		.multi_chip = true,
+		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
+		.ops = &mv88e6393x_ops,
+	},
+
 	[MV88E6220] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
 		.family = MV88E6XXX_FAMILY_6250,
@@ -5250,6 +5382,29 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ptp_support = true,
 		.ops = &mv88e6390x_ops,
 	},
+
+	[MV88E6393X] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6393X,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6393X",
+		.num_databases = 4096,
+		.num_ports = 11,	/* 10 + Z80 */
+		.num_internal_phys = 9,
+		.max_vid = 8191,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 10,
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
index 022e382339e2..bce6e0dc8535 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -63,6 +63,8 @@ enum mv88e6xxx_model {
 	MV88E6190,
 	MV88E6190X,
 	MV88E6191,
+	MV88E6191X,
+	MV88E6193X,
 	MV88E6220,
 	MV88E6240,
 	MV88E6250,
@@ -75,6 +77,7 @@ enum mv88e6xxx_model {
 	MV88E6352,
 	MV88E6390,
 	MV88E6390X,
+	MV88E6393X,
 };
 
 enum mv88e6xxx_family {
@@ -90,6 +93,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
 	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
+	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
 };
 
 struct mv88e6xxx_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 7c396964d0b2..4f3dbb015f77 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -22,6 +22,7 @@
 #define MV88E6185_G1_STS_PPU_STATE_DISABLED		0x8000
 #define MV88E6185_G1_STS_PPU_STATE_POLLING		0xc000
 #define MV88E6XXX_G1_STS_INIT_READY			0x0800
+#define MV88E6393X_G1_STS_IRQ_DEVICE_2			9
 #define MV88E6XXX_G1_STS_IRQ_AVB			8
 #define MV88E6XXX_G1_STS_IRQ_DEVICE			7
 #define MV88E6XXX_G1_STS_IRQ_STATS			6
@@ -59,6 +60,7 @@
 #define MV88E6185_G1_CTL1_SCHED_PRIO		0x0800
 #define MV88E6185_G1_CTL1_MAX_FRAME_1632	0x0400
 #define MV88E6185_G1_CTL1_RELOAD_EEPROM		0x0200
+#define MV88E6393X_G1_CTL1_DEVICE2_EN		0x0200
 #define MV88E6XXX_G1_CTL1_DEVICE_EN		0x0080
 #define MV88E6XXX_G1_CTL1_STATS_DONE_EN		0x0040
 #define MV88E6XXX_G1_CTL1_VTU_PROBLEM_EN	0x0020
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 4127f82275ad..c78769cdbb59 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -38,9 +38,15 @@
 /* Offset 0x02: MGMT Enable Register 2x */
 #define MV88E6XXX_G2_MGMT_EN_2X		0x02
 
+/* Offset 0x02: MAC LINK change IRQ Register for MV88E6393X */
+#define MV88E6393X_G2_MACLINK_INT_SRC		0x02
+
 /* Offset 0x03: MGMT Enable Register 0x */
 #define MV88E6XXX_G2_MGMT_EN_0X		0x03
 
+/* Offset 0x03: MAC LINK change IRQ Mask Register for MV88E6393X */
+#define MV88E6393X_G2_MACLINK_INT_MASK		0x03
+
 /* Offset 0x04: Flow Control Delay Register */
 #define MV88E6XXX_G2_FLOW_CTL	0x04
 
@@ -52,6 +58,8 @@
 #define MV88E6XXX_G2_SWITCH_MGMT_FORCE_FLOW_CTL_PRI	0x0080
 #define MV88E6XXX_G2_SWITCH_MGMT_RSVD2CPU		0x0008
 
+#define MV88E6393X_G2_EGRESS_MONITOR_DEST		0x05
+
 /* Offset 0x06: Device Mapping Table Register */
 #define MV88E6XXX_G2_DEVICE_MAPPING		0x06
 #define MV88E6XXX_G2_DEVICE_MAPPING_UPDATE	0x8000
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index d8590025e75f..154541d807df 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -14,6 +14,7 @@
 #include <linux/phylink.h>
 
 #include "chip.h"
+#include "global2.h"
 #include "port.h"
 #include "serdes.h"
 
@@ -25,6 +26,14 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 	return mv88e6xxx_read(chip, addr, reg, val);
 }
 
+int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
+			    int bit, int val)
+{
+	int addr = chip->info->port_base_addr + port;
+
+	return mv88e6xxx_wait_bit(chip, addr, reg, bit, val);
+}
+
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
 			 u16 val)
 {
@@ -426,6 +435,106 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 	return PHY_INTERFACE_MODE_NA;
 }
 
+/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
+ * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
+ * values for speeds 2500 & 5000 conflict.
+ */
+int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex)
+{
+	u16 reg, ctrl;
+	int err;
+
+	if (speed == SPEED_MAX)
+		speed = (port > 0 && port < 9) ? 1000 : 10000;
+
+	if (speed == 200 && port != 0)
+		return -EOPNOTSUPP;
+
+	if (speed >= 2500 && port > 0 && port < 9)
+		return -EOPNOTSUPP;
+
+	switch (speed) {
+	case 10:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_10;
+		break;
+	case 100:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_100;
+		break;
+	case 200:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_100 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 1000:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
+		break;
+	case 2500:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 5000:
+		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 10000:
+	case SPEED_UNFORCED:
+		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_UNFORCED;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (duplex) {
+	case DUPLEX_HALF:
+		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX;
+		break;
+	case DUPLEX_FULL:
+		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
+			MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL;
+		break;
+	case DUPLEX_UNFORCED:
+		/* normal duplex detection */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
+	if (err)
+		return err;
+
+	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
+		 MV88E6390_PORT_MAC_CTL_ALTSPEED |
+		 MV88E6390_PORT_MAC_CTL_FORCE_SPEED);
+
+	if (speed != SPEED_UNFORCED)
+		reg |= MV88E6390_PORT_MAC_CTL_FORCE_SPEED;
+
+	reg |= ctrl;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
+	if (err)
+		return err;
+
+	if (speed)
+		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
+	else
+		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
+	dev_dbg(chip->dev, "p%d: %s %s duplex\n", port,
+		reg & MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX ? "Force" : "Unforce",
+		reg & MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL ? "full" : "half");
+
+	return 0;
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
@@ -450,6 +559,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_2500BASEX:
 		cmode = MV88E6XXX_PORT_STS_CMODE_2500BASEX;
 		break;
+	case PHY_INTERFACE_MODE_5GBASER:
+		cmode = MV88E6393X_PORT_STS_CMODE_5GBASER;
+		break;
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
 		cmode = MV88E6XXX_PORT_STS_CMODE_XAUI;
@@ -457,6 +569,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_RXAUI:
 		cmode = MV88E6XXX_PORT_STS_CMODE_RXAUI;
 		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		cmode = MV88E6393X_PORT_STS_CMODE_10GBASER;
+		break;
 	default:
 		cmode = 0;
 	}
@@ -541,6 +656,29 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode)
+{
+	int err;
+	u16 reg;
+
+	if (port != 0 && port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	/* mv88e6393x errata 4.5: EEE should be disabled on SERDES ports */
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_MAC_CTL_EEE;
+	reg |= MV88E6XXX_PORT_MAC_CTL_FORCE_EEE;
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
+	if (err)
+		return err;
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
+}
+
 static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
 					     int port)
 {
@@ -1185,6 +1323,135 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_PRI_OVERRIDE, 0);
 }
 
+/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X */
+
+static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, int port,
+					u16 pointer, u8 data)
+{
+	u16 reg;
+
+	reg = MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL,
+				    reg);
+}
+
+static int mv88e6393x_port_policy_write_all(struct mv88e6xxx_chip *chip,
+					    u16 pointer, u8 data)
+{
+	int err, port;
+
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		if (dsa_is_unused_port(chip->ds, port))
+			continue;
+
+		err = mv88e6393x_port_policy_write(chip, port, pointer, data);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
+			       enum mv88e6xxx_egress_direction direction,
+			       int port)
+{
+	u16 ptr;
+	int err;
+
+	switch (direction) {
+	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST;
+		err = mv88e6393x_port_policy_write_all(chip, ptr, port);
+		if (err)
+			return err;
+		break;
+	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		ptr = MV88E6393X_G2_EGRESS_MONITOR_DEST;
+		err = mv88e6xxx_g2_write(chip, ptr, port);
+		if (err)
+			return err;
+		break;
+	}
+
+	return 0;
+}
+
+int mv88e6393x_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
+				      int upstream_port)
+{
+	u16 ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST;
+	u8 data = MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI |
+		  upstream_port;
+
+	return mv88e6393x_port_policy_write(chip, port, ptr, data);
+}
+
+int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
+{
+	u16 ptr;
+	int err;
+
+	/* Consider the frames with reserved multicast destination
+	 * addresses matching 01:80:c2:00:00:00 and
+	 * 01:80:c2:00:00:02 as MGMT.
+	 */
+	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO;
+	err = mv88e6393x_port_policy_write_all(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI;
+	err = mv88e6393x_port_policy_write_all(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO;
+	err = mv88e6393x_port_policy_write_all(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI;
+	err = mv88e6393x_port_policy_write_all(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Offset 0x10 & 0x11: EPC */
+
+static int mv88e6393x_port_epc_wait_ready(struct mv88e6xxx_chip *chip, int port)
+{
+	int bit = __bf_shf(MV88E6393X_PORT_EPC_CMD_BUSY);
+
+	return mv88e6xxx_port_wait_bit(chip, port, MV88E6393X_PORT_EPC_CMD, bit, 0);
+}
+
+/* Port Ether type for 6393X family */
+
+int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
+				   u16 etype)
+{
+	u16 val;
+	int err;
+
+	err = mv88e6393x_port_epc_wait_ready(chip, port);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_DATA, etype);
+	if (err)
+		return err;
+
+	val = MV88E6393X_PORT_EPC_CMD_BUSY |
+	      MV88E6393X_PORT_EPC_CMD_WRITE |
+	      MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_CMD, val);
+}
+
 /* Offset 0x0f: Port Ether type */
 
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index e6d0eaa6aa1d..948ba577a159 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -49,6 +49,9 @@
 #define MV88E6XXX_PORT_STS_CMODE_2500BASEX	0x000b
 #define MV88E6XXX_PORT_STS_CMODE_XAUI		0x000c
 #define MV88E6XXX_PORT_STS_CMODE_RXAUI		0x000d
+#define MV88E6393X_PORT_STS_CMODE_5GBASER	0x000c
+#define MV88E6393X_PORT_STS_CMODE_10GBASER	0x000d
+#define MV88E6393X_PORT_STS_CMODE_USXGMII	0x000e
 #define MV88E6185_PORT_STS_CDUPLEX		0x0008
 #define MV88E6185_PORT_STS_CMODE_MASK		0x0007
 #define MV88E6185_PORT_STS_CMODE_GMII_FD	0x0000
@@ -68,6 +71,8 @@
 #define MV88E6390_PORT_MAC_CTL_FORCE_SPEED		0x2000
 #define MV88E6390_PORT_MAC_CTL_ALTSPEED			0x1000
 #define MV88E6352_PORT_MAC_CTL_200BASE			0x1000
+#define MV88E6XXX_PORT_MAC_CTL_EEE			0x0200
+#define MV88E6XXX_PORT_MAC_CTL_FORCE_EEE		0x0100
 #define MV88E6185_PORT_MAC_CTL_AN_EN			0x0400
 #define MV88E6185_PORT_MAC_CTL_AN_RESTART		0x0200
 #define MV88E6185_PORT_MAC_CTL_AN_DONE			0x0100
@@ -117,6 +122,8 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6176	0x1760
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6190	0x1900
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191	0x1910
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6191X	0x1920
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6193X	0x1930
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185	0x1a70
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6220	0x2200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240	0x2400
@@ -129,6 +136,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6393X	0x3930
 #define MV88E6XXX_PORT_SWITCH_ID_REV_MASK	0x000f
 
 /* Offset 0x04: Port Control Register */
@@ -236,6 +244,19 @@
 #define MV88E6XXX_PORT_POLICY_CTL_TRAP		0x0002
 #define MV88E6XXX_PORT_POLICY_CTL_DISCARD	0x0003
 
+/* Offset 0x0E: Policy & MGMT Control Register (FAMILY_6393X) */
+#define MV88E6393X_PORT_POLICY_MGMT_CTL				0x0e
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE			0x8000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_MASK		0x3f00
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_DATA_MASK		0x00ff
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO	0x2000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI	0x2100
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO	0x2400
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI	0x2500
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST	0x3000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST		0x3800
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI	0x00e0
+
 /* Offset 0x0F: Port Special Ether Type */
 #define MV88E6XXX_PORT_ETH_TYPE		0x0f
 #define MV88E6XXX_PORT_ETH_TYPE_DEFAULT	0x9100
@@ -243,6 +264,15 @@
 /* Offset 0x10: InDiscards Low Counter */
 #define MV88E6XXX_PORT_IN_DISCARD_LO	0x10
 
+/* Offset 0x10: Extended Port Control Command */
+#define MV88E6393X_PORT_EPC_CMD		0x10
+#define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
+
+/* Offset 0x11: Extended Port Control Data */
+#define MV88E6393X_PORT_EPC_DATA	0x11
+
 /* Offset 0x11: InDiscards High Counter */
 #define MV88E6XXX_PORT_IN_DISCARD_HI	0x11
 
@@ -288,6 +318,8 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val);
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
 			 u16 val);
+int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
+			    int bit, int val);
 
 int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
 			     int pause);
@@ -315,10 +347,13 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
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
 
@@ -353,6 +388,14 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 			      enum mv88e6xxx_policy_action action);
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
+int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
+			       enum mv88e6xxx_egress_direction direction,
+			       int port);
+int mv88e6393x_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
+				      int upstream_port);
+int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
+int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
+				   u16 etype);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
 int mv88e6xxx_port_set_trunk(struct mv88e6xxx_chip *chip, int port,
@@ -371,6 +414,8 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode);
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index e48260c5c6ba..470856bcd2f3 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -637,6 +637,27 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
+/* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane address
+ * a port is using else Returns -ENODEV.
+ */
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+{
+	u8 cmode = chip->ports[port].cmode;
+	int lane = -ENODEV;
+
+	if (port != 0 && port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_5GBASER ||
+	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER)
+		lane = port;
+
+	return lane;
+}
+
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
 static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
 				      bool up)
@@ -902,6 +923,30 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
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
@@ -921,6 +966,25 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
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
@@ -988,6 +1052,23 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
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
@@ -1027,6 +1108,83 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
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
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
+				 int lane, bool enable)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
+	}
+
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
+	return err;
+}
+
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					 int lane)
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
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
+		if (err)
+			return err;
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
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane)
 {
@@ -1112,3 +1270,101 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 			p[i] = reg;
 	}
 }
+
+static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
+{
+	u16 reg, pcs;
+	int err;
+
+	/* mv88e6393x family errata 4.6:
+	 * Cannot clear PwrDn bit on SERDES on port 0 if device is configured
+	 * CPU_MGD mode or P0_mode is configured for [x]MII.
+	 * Workaround: Set Port0 SERDES register 4.F002 bit 5=0 and bit 15=1.
+	 *
+	 * It seems that after this workaround the SERDES is automatically
+	 * powered up (the bit is cleared), so power it down.
+	 */
+	if (lane == MV88E6393X_PORT0_LANE) {
+		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
+					    MDIO_MMD_PHYXS,
+					    MV88E6393X_SERDES_POC, &reg);
+		if (err)
+			return err;
+
+		reg &= ~MV88E6393X_SERDES_POC_PDOWN;
+		reg |= MV88E6393X_SERDES_POC_RESET;
+
+		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+					     MV88E6393X_SERDES_POC, reg);
+		if (err)
+			return err;
+
+		err = mv88e6390_serdes_power_sgmii(chip, lane, false);
+		if (err)
+			return err;
+	}
+
+	/* mv88e6393x family errata 4.8:
+	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may
+	 * not come up after hardware reset or software reset of SERDES core.
+	 * Workaround is to write SERDES register 4.F074.14=1 for only those
+	 * modes and 0 in all other modes.
+	 */
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_SERDES_POC, &pcs);
+	if (err)
+		return err;
+
+	pcs &= MV88E6393X_SERDES_POC_PCS_MASK;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_ERRATA_4_8_REG, &reg);
+	if (err)
+		return err;
+
+	if (pcs == MV88E6393X_SERDES_POC_PCS_1000BASEX ||
+	    pcs == MV88E6393X_SERDES_POC_PCS_SGMII_PHY ||
+	    pcs == MV88E6393X_SERDES_POC_PCS_SGMII_MAC)
+		reg |= MV88E6393X_ERRATA_4_8_BIT;
+	else
+		reg &= ~MV88E6393X_ERRATA_4_8_BIT;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6393X_ERRATA_4_8_REG, reg);
+}
+
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT0_LANE);
+	if (err)
+		return err;
+
+	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT9_LANE);
+	if (err)
+		return err;
+
+	return mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT10_LANE);
+}
+
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
+			    bool on)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (port != 0 && port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+	case MV88E6393X_PORT_STS_CMODE_5GBASER:
+	case MV88E6393X_PORT_STS_CMODE_10GBASER:
+		return mv88e6390_serdes_power_10g(chip, lane, on);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index ce4d0fef124d..cbb3ba30caea 100644
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
@@ -73,11 +76,33 @@
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
 
+#define MV88E6393X_PORT0_LANE			0x00
+#define MV88E6393X_PORT9_LANE			0x09
+#define MV88E6393X_PORT10_LANE			0x0a
+
+/* Port Operational Configuration */
+#define MV88E6393X_SERDES_POC			0xf002
+#define MV88E6393X_SERDES_POC_PCS_1000BASEX	0x0000
+#define MV88E6393X_SERDES_POC_PCS_2500BASEX	0x0001
+#define MV88E6393X_SERDES_POC_PCS_SGMII_PHY	0x0002
+#define MV88E6393X_SERDES_POC_PCS_SGMII_MAC	0x0003
+#define MV88E6393X_SERDES_POC_PCS_5GBASER	0x0004
+#define MV88E6393X_SERDES_POC_PCS_10GBASER	0x0005
+#define MV88E6393X_SERDES_POC_PCS_USXGMII_PHY	0x0006
+#define MV88E6393X_SERDES_POC_PCS_USXGMII_MAC	0x0007
+#define MV88E6393X_SERDES_POC_PCS_MASK		0x0007
+#define MV88E6393X_SERDES_POC_RESET		BIT(15)
+#define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
+
+#define MV88E6393X_ERRATA_4_8_REG		0xF074
+#define MV88E6393X_ERRATA_4_8_BIT		BIT(14)
+
 int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				int lane, unsigned int mode,
 				phy_interface_t interface,
@@ -92,6 +117,8 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
+int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				    int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    int lane);
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -110,18 +137,25 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
+			    bool on);
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip);
 int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
+				 int lane, bool enable);
 irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
+					 int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-- 
2.26.2

