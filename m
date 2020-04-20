Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4351B017E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 08:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDTGWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 02:22:02 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51565 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgDTGWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 02:22:02 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 7E23D44046D;
        Mon, 20 Apr 2020 09:21:58 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH net-next v2] net: phy: marvell10g: add firmware load support
Date:   Mon, 20 Apr 2020 09:21:47 +0300
Message-Id: <31f9d27ed19e074db87307c319c4d07309acecae.1587363707.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
bit is pulled up, the host must load firmware to the PHY volatile RAM
after reset over MDIO. Add support for loading firmware at run-time.

The code loads the firmware only when the PHY is in MV_PMA_BOOT_WAITING
state at probe time, i.e. PHY is waiting for host to load firmware. The
code will not update currently running PHY firmware.

This patch does not include support for writing firmware into the PHY
non-volatile SPI flash (when SPI_CONFIG strap is pulled down).

Firmware files are available from Marvell under NDA.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---

Kernel Ethernet PHY maintainers are unlikely to take this patch
upstream. This is because the linux-firmware repository can not accept
the firmware files since they are not legally distributable. I post the
code here as reference to anyone who needs firmware load functionality
to make this hardware design work.

This patch applies on top of kernel v5.7-rc2.

v2:

  * Declare firmware files with MODULE_FIRMWARE() (Heiner Kallweit)

  * Bail out of firmware load loop on PHY write error (Florian Fainelli)

  * Release firmware file on load error (Florian Fainelli)

  * Drop mv3310_report_firmware_rev(); rely on recently introduced
    firmware version report instead

  * Extend commit log
---
 drivers/net/phy/marvell10g.c | 102 +++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index d3cb88651ad2..f4eb24be77d0 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -28,15 +28,26 @@
 #include <linux/marvell_phy.h>
 #include <linux/phy.h>
 #include <linux/sfp.h>
+#include <linux/firmware.h>
 
 #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
+#define MV_FIRMWARE_HEADER_SIZE		32
+
 enum {
 	MV_PMA_FW_VER0		= 0xc011,
 	MV_PMA_FW_VER1		= 0xc012,
 	MV_PMA_BOOT		= 0xc050,
 	MV_PMA_BOOT_FATAL	= BIT(0),
+	MV_PMA_BOOT_PROGRESS_MASK = 0x0006,
+	MV_PMA_BOOT_WAITING	= 0x0002,
+	MV_PMA_BOOT_FW_LOADED	= BIT(6),
+
+	MV_PCS_FW_LOW_WORD	= 0xd0f0,
+	MV_PCS_FW_HIGH_WORD	= 0xd0f1,
+	MV_PCS_RAM_DATA		= 0xd0f2,
+	MV_PCS_RAM_CHECKSUM	= 0xd0f3,
 
 	MV_PCS_BASE_T		= 0x0000,
 	MV_PCS_BASE_R		= 0x1000,
@@ -354,6 +365,89 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	return 0;
 }
 
+static int mv3310_write_firmware(struct phy_device *phydev, const u8 *data,
+		unsigned int size)
+{
+	unsigned int low_byte, high_byte;
+	u16 checksum = 0, ram_checksum;
+	unsigned int i = 0;
+	int ret;
+
+	while (i < size) {
+		low_byte = data[i++];
+		high_byte = data[i++];
+		checksum += low_byte + high_byte;
+		ret = phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_DATA,
+				(high_byte << 8) | low_byte);
+		if (ret < 0)
+			return ret;
+		cond_resched();
+	}
+
+	ram_checksum = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
+	if (ram_checksum != checksum) {
+		dev_err(&phydev->mdio.dev, "firmware checksum failed");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mv3310_load_firmware(struct phy_device *phydev)
+{
+	const struct firmware *fw_entry;
+	char *fw_file;
+	int ret;
+
+	switch (phydev->drv->phy_id) {
+	case MARVELL_PHY_ID_88X3310:
+		fw_file = "mrvl/x3310fw.hdr";
+		break;
+	case MARVELL_PHY_ID_88E2110:
+		fw_file = "mrvl/e21x0fw.hdr";
+		break;
+	default:
+		dev_warn(&phydev->mdio.dev, "unknown firmware file for %s PHY",
+				phydev->drv->name);
+		return -EINVAL;
+	}
+
+	ret = request_firmware(&fw_entry, fw_file, &phydev->mdio.dev);
+	if (ret < 0)
+		return ret;
+
+	/* Firmware size must be larger than header, and even */
+	if (fw_entry->size <= MV_FIRMWARE_HEADER_SIZE ||
+			(fw_entry->size % 2) != 0) {
+		dev_err(&phydev->mdio.dev, "firmware file invalid");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Clear checksum register */
+	phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
+
+	/* Set firmware load address */
+	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_LOW_WORD, 0);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_HIGH_WORD, 0x0010);
+
+	ret = mv3310_write_firmware(phydev,
+			fw_entry->data + MV_FIRMWARE_HEADER_SIZE,
+			fw_entry->size - MV_FIRMWARE_HEADER_SIZE);
+	if (ret < 0)
+		goto out;
+
+	phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT,
+			MV_PMA_BOOT_FW_LOADED, MV_PMA_BOOT_FW_LOADED);
+
+	msleep(100);
+
+out:
+	release_firmware(fw_entry);
+
+	return ret;
+}
+
 static const struct sfp_upstream_ops mv3310_sfp_ops = {
 	.attach = phy_sfp_attach,
 	.detach = phy_sfp_detach,
@@ -380,6 +474,12 @@ static int mv3310_probe(struct phy_device *phydev)
 		return -ENODEV;
 	}
 
+	if ((ret & MV_PMA_BOOT_PROGRESS_MASK) == MV_PMA_BOOT_WAITING) {
+		ret = mv3310_load_firmware(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -779,6 +879,8 @@ static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
 	{ MARVELL_PHY_ID_88E2110, MARVELL_PHY_ID_MASK },
 	{ },
 };
+MODULE_FIRMWARE("mrvl/x3310fw.hdr");
+MODULE_FIRMWARE("mrvl/e21x0fw.hdr");
 MODULE_DEVICE_TABLE(mdio, mv3310_tbl);
 MODULE_DESCRIPTION("Marvell Alaska X 10Gigabit Ethernet PHY driver (MV88X3310)");
 MODULE_LICENSE("GPL");
-- 
2.25.1

