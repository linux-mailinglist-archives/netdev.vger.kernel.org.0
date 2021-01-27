Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706653054A8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhA0H3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:29:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S316516AbhA0Adk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:33:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4Ykz-002mXC-7h; Wed, 27 Jan 2021 01:32:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>, tobias@waldekranz.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [patch net-next v2] net: dsa: mv88e6xxx: Make global2 support mandatory
Date:   Wed, 27 Jan 2021 01:32:10 +0100
Message-Id: <20210127003210.663173-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Early generations of the mv88e6xxx did not have the global 2
registers. In order to keep the driver slim, it was decided to make
the code for these registers optional. Over time, more generations of
switches have been added, always supporting global 2 and adding more
and more registers. No effort has been made to keep these additional
registers also optional to slim the driver down when used for older
generations. Optional global 2 now just gives additional development
and maintenance burden for no real gain.

Make global 2 support always compiled in.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/Kconfig   |  12 --
 drivers/net/dsa/mv88e6xxx/Makefile  |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c    |   4 -
 drivers/net/dsa/mv88e6xxx/global2.h | 194 ----------------------------
 4 files changed, 3 insertions(+), 213 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index b17540926c11..05af632b0f59 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -9,21 +9,9 @@ config NET_DSA_MV88E6XXX
 	  This driver adds support for most of the Marvell 88E6xxx models of
 	  Ethernet switch chips, except 88E6060.
 
-config NET_DSA_MV88E6XXX_GLOBAL2
-	bool "Switch Global 2 Registers support"
-	default y
-	depends on NET_DSA_MV88E6XXX
-	help
-	  This registers set at internal SMI address 0x1C provides extended
-	  features like EEPROM interface, trunking, cross-chip setup, etc.
-
-	  It is required on most chips. If the chip you compile the support for
-	  doesn't have such registers set, say N here. In doubt, say Y.
-
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX_GLOBAL2
 	depends on PTP_1588_CLOCK
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index 4b080b448ce7..c8eca2b6f959 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -5,9 +5,9 @@ mv88e6xxx-objs += devlink.o
 mv88e6xxx-objs += global1.o
 mv88e6xxx-objs += global1_atu.o
 mv88e6xxx-objs += global1_vtu.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2_avb.o
-mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2_scratch.o
+mv88e6xxx-objs += global2.o
+mv88e6xxx-objs += global2_avb.o
+mv88e6xxx-objs += global2_scratch.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2f976050a0d7..2a70d379aa4c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5227,10 +5227,6 @@ static int mv88e6xxx_detect(struct mv88e6xxx_chip *chip)
 	/* Update the compatible info with the probed one */
 	chip->info = info;
 
-	err = mv88e6xxx_g2_require(chip);
-	if (err)
-		return err;
-
 	dev_info(chip->dev, "switch 0x%x detected: %s, revision %u\n",
 		 chip->info->prod_num, chip->info->name, rev);
 
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 253a79582a1d..4127f82275ad 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -296,13 +296,6 @@
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_TRIG	1
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_EVREQ	2
 
-#ifdef CONFIG_NET_DSA_MV88E6XXX_GLOBAL2
-
-static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
-{
-	return 0;
-}
-
 int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
 int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg,
@@ -370,191 +363,4 @@ int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
 int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats);
 
-#else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
-
-static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
-{
-	if (chip->info->global2_addr) {
-		dev_err(chip->dev, "this chip requires CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 enabled\n");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static inline int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, u16 *val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip,
-					int reg, int bit, int val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6352_g2_irl_init_all(struct mv88e6xxx_chip *chip,
-					    int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6390_g2_irl_init_all(struct mv88e6xxx_chip *chip,
-					    int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_smi_phy_read(struct mv88e6xxx_chip *chip,
-					    struct mii_bus *bus,
-					    int addr, int reg, u16 *val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_smi_phy_write(struct mv88e6xxx_chip *chip,
-					     struct mii_bus *bus,
-					     int addr, int reg, u16 val)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip,
-					      u8 *addr)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_get_eeprom8(struct mv88e6xxx_chip *chip,
-					   struct ethtool_eeprom *eeprom,
-					   u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_eeprom8(struct mv88e6xxx_chip *chip,
-					   struct ethtool_eeprom *eeprom,
-					   u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_get_eeprom16(struct mv88e6xxx_chip *chip,
-					    struct ethtool_eeprom *eeprom,
-					    u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_set_eeprom16(struct mv88e6xxx_chip *chip,
-					    struct ethtool_eeprom *eeprom,
-					    u8 *data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_pvt_write(struct mv88e6xxx_chip *chip,
-					 int src_dev, int src_port, u16 data)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_misc_4_bit_port(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void mv88e6xxx_g2_irq_free(struct mv88e6xxx_chip *chip)
-{
-}
-
-static inline int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
-					      struct mii_bus *bus)
-{
-	return 0;
-}
-
-static inline void mv88e6xxx_g2_irq_mdio_free(struct mv88e6xxx_chip *chip,
-					      struct mii_bus *bus)
-{
-}
-
-static inline int mv88e6185_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6352_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops = {};
-static const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops = {};
-static const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {};
-
-static const struct mv88e6xxx_avb_ops mv88e6165_avb_ops = {};
-static const struct mv88e6xxx_avb_ops mv88e6352_avb_ops = {};
-static const struct mv88e6xxx_avb_ops mv88e6390_avb_ops = {};
-
-static const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops = {};
-
-static inline int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
-						    bool external)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip,
-						int num, bool hash, u16 mask)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip,
-						   int id, u16 map)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
-						    int target, int port)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
-					     u16 kind, u16 bin)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip,
-					     u16 *stats)
-{
-	return -EOPNOTSUPP;
-}
-
-#endif /* CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
-
 #endif /* _MV88E6XXX_GLOBAL2_H */
-- 
2.30.0

