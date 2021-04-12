Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD3835C5F9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbhDLMPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhDLMPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6EA61278;
        Mon, 12 Apr 2021 12:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618229721;
        bh=Ld9a7ra9AvWdLyJGF2HSJGy8Zp0RjkIV3NMyltHFXVo=;
        h=From:To:Cc:Subject:Date:From;
        b=g6S791aPYf/GLAggc9hT1hwQU3fegfhIQyFR3/gRcL/6lOIfZNB8gNQRNipmH6zgQ
         pcFFVPS0ju4EpFlK3DVcKgvtibDQYbG59h6A6pghPzFXifJuRaCGLvCd3+6IUgz/Ve
         zz7GkOD07dPnMMuPH6fjaHDa0hEdinHIHl/3eBShkJisyzzsrc6UpNGV/a+gVHa5Yk
         ngzJSU4IRVB1QZv1a1jaQV25M66zfssbHGz/lgsGAyy6o8BYOeysX72SCJR0zd0cr5
         7VOTJLfDXTF90KbHv8bbusRoUCDQ73AoZYrWJA6q0YEh5P+OvLgJo0F8VFVOgtOZzl
         icXK0H0iI4/fw==
Received: by pali.im (Postfix)
        id 6490E687; Mon, 12 Apr 2021 14:15:18 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Date:   Mon, 12 Apr 2021 14:14:30 +0200
Message-Id: <20210412121430.20898-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
sensor reading"), Linux reports the temperature of Topaz hwmon as
constant -75°C.

This is because switches from the Topaz family (88E6141 / 88E6341) have
the address of the temperature sensor register different from Peridot.

This address is instead compatible with 88E1510 PHYs, as was used for
Topaz before the above mentioned commit.

Define a representative model for each switch family and add a mapping
table for constructing PHY IDs for the internal PHYs (since they don't
have a model number).

Create a new PHY ID and a new PHY driver for Topaz' internal PHY.
The only difference from Peridot's PHY driver is the HWMON probing
method.

Prior this change Topaz's internal PHY is detected by kernel as:

  PHY [...] driver [Marvell 88E6390] (irq=63)

And afterwards as:

  PHY [...] driver [Marvell 88E6341 Family] (irq=63)

Signed-off-by: Pali Rohár <pali@kernel.org>
BugLink: https://github.com/globalscaletechnologies/linux/issues/1
Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
Reviewed-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 56 ++++++++++++++++++++++----------
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/phy/marvell.c        | 32 ++++++++++++++++--
 include/linux/marvell_phy.h      |  5 +--
 4 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..e602c9816aee 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3026,6 +3026,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	return err;
 }
 
+static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family);
+
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
@@ -3040,24 +3042,9 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
 	mv88e6xxx_reg_unlock(chip);
 
-	if (reg == MII_PHYSID2) {
-		/* Some internal PHYs don't have a model number. */
-		if (chip->info->family != MV88E6XXX_FAMILY_6165)
-			/* Then there is the 6165 family. It gets is
-			 * PHYs correct. But it can also have two
-			 * SERDES interfaces in the PHY address
-			 * space. And these don't have a model
-			 * number. But they are not PHYs, so we don't
-			 * want to give them something a PHY driver
-			 * will recognise.
-			 *
-			 * Use the mv88e6390 family model number
-			 * instead, for anything which really could be
-			 * a PHY,
-			 */
-			if (!(val & 0x3f0))
-				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
-	}
+	/* Some internal PHYs don't have a model number. */
+	if (reg == MII_PHYSID2 && !(val & 0x3f0))
+		val |= mv88e6xxx_physid_for_family(chip->info->family);
 
 	return err ? err : val;
 }
@@ -5244,6 +5231,39 @@ static const struct mv88e6xxx_info *mv88e6xxx_lookup_info(unsigned int prod_num)
 	return NULL;
 }
 
+/* This table contains representative model for every family */
+static const enum mv88e6xxx_model family_model_table[] = {
+	[MV88E6XXX_FAMILY_6095] = MV88E6095,
+	[MV88E6XXX_FAMILY_6097] = MV88E6097,
+	[MV88E6XXX_FAMILY_6185] = MV88E6185,
+	[MV88E6XXX_FAMILY_6250] = MV88E6250,
+	[MV88E6XXX_FAMILY_6320] = MV88E6320,
+	[MV88E6XXX_FAMILY_6341] = MV88E6341,
+	[MV88E6XXX_FAMILY_6351] = MV88E6351,
+	[MV88E6XXX_FAMILY_6352] = MV88E6352,
+	[MV88E6XXX_FAMILY_6390] = MV88E6390,
+};
+static_assert(ARRAY_SIZE(family_model_table) == MV88E6XXX_FAMILY_LAST);
+
+static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family)
+{
+	enum mv88e6xxx_model model;
+
+	/* 6165 family gets it's PHYs correct. But it can also have two SERDES
+	 * interfaces in the PHY address space. And these don't have a model
+	 * number. But they are not PHYs, so we don't want to give them
+	 * something a PHY driver will recognise.
+	 */
+	if (family == MV88E6XXX_FAMILY_6165)
+		return 0;
+
+	model = family_model_table[family];
+	if (model == MV88E_NA)
+		return 0;
+
+	return mv88e6xxx_table[model].prod_num >> 4;
+}
+
 static int mv88e6xxx_detect(struct mv88e6xxx_chip *chip)
 {
 	const struct mv88e6xxx_info *info;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index a57c8886f3ac..70c736788a68 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -47,6 +47,7 @@ enum mv88e6xxx_frame_mode {
 
 /* List of supported models */
 enum mv88e6xxx_model {
+	MV88E_NA = 0, /* must be zero */
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
@@ -90,6 +91,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
 	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
+	MV88E6XXX_FAMILY_LAST
 };
 
 struct mv88e6xxx_ops;
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e26a5d663f8a..8018ddf7f316 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -3021,9 +3021,34 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 	},
 	{
-		.phy_id = MARVELL_PHY_ID_88E6390,
+		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
-		.name = "Marvell 88E6390",
+		.name = "Marvell 88E6341 Family",
+		/* PHY_GBIT_FEATURES */
+		.flags = PHY_POLL_CABLE_TEST,
+		.probe = m88e1510_probe,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e6390_config_aneg,
+		.read_status = marvell_read_status,
+		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
+		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E6390 Family",
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e6390_probe,
@@ -3107,7 +3132,8 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1540, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
-	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6390_FAMILY, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1548P, MARVELL_PHY_ID_MASK },
 	{ }
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 52b1610eae68..c544b70dfbd2 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -28,11 +28,12 @@
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
 
-/* The MV88e6390 Ethernet switch contains embedded PHYs. These PHYs do
+/* These Ethernet switch families contain embedded PHYs, but they do
  * not have a model ID. So the switch driver traps reads to the ID2
  * register and returns the switch family ID
  */
-#define MARVELL_PHY_ID_88E6390		0x01410f90
+#define MARVELL_PHY_ID_88E6341_FAMILY	0x01410f41
+#define MARVELL_PHY_ID_88E6390_FAMILY	0x01410f90
 
 #define MARVELL_PHY_FAMILY_ID(id)	((id) >> 4)
 
-- 
2.20.1

