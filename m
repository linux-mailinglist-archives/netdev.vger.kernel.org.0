Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42024946BB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 06:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358556AbiATFTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 00:19:43 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:46382
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236290AbiATFTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 00:19:41 -0500
Received: from localhost.localdomain (1-171-82-176.dynamic-ip.hinet.net [1.171.82.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D061440D2E;
        Thu, 20 Jan 2022 05:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642655979;
        bh=LDTRKyufVIbBOkW2X/i15inUM9Sh3auq+doIIyGR024=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=fzqh5T5Gycbs8DJLrvgH2TroN8G+nvnVs2/97sXH2aqyjNLgr1Sxtry8hWGrcPxGs
         VdhGKAFUt071AI+l0pBg3468VrM+CMqiTZd4GqjXOLURTo8OGxzaVmHIHqMPwQhLH1
         49Rh4h8ki4aqJRGfKYAUjF8LnUgNh3E3mUxLOvrVVLL3MRJfmpVeiO7qIPcpkzaZMT
         /HplfJpTuPHIPB1g7Egj4KTrkcl20pAt7U5POjSsU5JBZnC4atx2v+iPzGY9vG/ZzQ
         Vtt9l+7Q3VbUoA/iZU0viOX9yQnxXiWgODWZJvPohvT2EYQqZjPAPXt/z5erHw7JiR
         pmQXcC1Szn6Ow==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: phy: marvell: Honor phy LED set by system firmware on a Dell hardware
Date:   Thu, 20 Jan 2022 13:19:29 +0800
Message-Id: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
instead of setting another value, keep it untouched and restore the saved
value on system resume.

Introduce config_led() callback in phy_driver() to make the implemtation
generic.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Split with a new helper to find default LED config.
 - Make the patch more generic.

 drivers/net/phy/marvell.c    | 43 +++++++++++++++++++++++++++++-------
 drivers/net/phy/phy_device.c | 21 ++++++++++++++++++
 include/linux/phy.h          |  9 ++++++++
 3 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 739859c0dfb18..54ee54a6895c9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -746,10 +746,14 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
-static void marvell_config_led(struct phy_device *phydev)
+static int marvell_find_led_config(struct phy_device *phydev)
 {
-	u16 def_config;
-	int err;
+	int def_config;
+
+	if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
+		def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
+		return def_config < 0 ? -1 : def_config;
+	}
 
 	switch (MARVELL_PHY_FAMILY_ID(phydev->phy_id)) {
 	/* Default PHY LED config: LED[0] .. Link, LED[1] .. Activity */
@@ -769,20 +773,30 @@ static void marvell_config_led(struct phy_device *phydev)
 			def_config = MII_88E1510_PHY_LED_DEF;
 		break;
 	default:
-		return;
+		return -1;
 	}
 
+	return def_config;
+}
+
+static void marvell_config_led(struct phy_device *phydev, bool resume)
+{
+	int err;
+
+	if (!resume)
+		phydev->led_config = marvell_find_led_config(phydev);
+
+	if (phydev->led_config == -1)
+		return;
+
 	err = phy_write_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL,
-			      def_config);
+			      phydev->led_config);
 	if (err < 0)
 		phydev_warn(phydev, "Fail to config marvell phy LED.\n");
 }
 
 static int marvell_config_init(struct phy_device *phydev)
 {
-	/* Set default LED */
-	marvell_config_led(phydev);
-
 	/* Set registers from marvell,reg-init DT property */
 	return marvell_of_reg_init(phydev);
 }
@@ -2845,6 +2859,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = marvell_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1101_config_aneg,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
@@ -2944,6 +2959,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1121_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -2965,6 +2981,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1318_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1318_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3044,6 +3061,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1116r_config_init,
+		.config_led = marvell_config_led,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3065,6 +3083,7 @@ static struct phy_driver marvell_drivers[] = {
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e1510_probe,
 		.config_init = m88e1510_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3094,6 +3113,7 @@ static struct phy_driver marvell_drivers[] = {
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3120,6 +3140,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3144,6 +3165,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_BASIC_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e3016_config_init,
+		.config_led = marvell_config_led,
 		.aneg_done = marvell_aneg_done,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3165,6 +3187,7 @@ static struct phy_driver marvell_drivers[] = {
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3191,6 +3214,7 @@ static struct phy_driver marvell_drivers[] = {
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3217,6 +3241,7 @@ static struct phy_driver marvell_drivers[] = {
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3242,6 +3267,7 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		/* PHY_GBIT_FEATURES */
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3264,6 +3290,7 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.config_init = marvell_1011gbe_config_init,
+		.config_led = marvell_config_led,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f8..c9e97206aa9e8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -12,6 +12,7 @@
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -1157,6 +1158,7 @@ static int phy_poll_reset(struct phy_device *phydev)
 int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
+	bool resume = phydev->suspended;
 
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
@@ -1184,6 +1186,9 @@ int phy_init_hw(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (phydev->drv->config_led)
+		phydev->drv->config_led(phydev, resume);
+
 	if (phydev->drv->config_intr) {
 		ret = phydev->drv->config_intr(phydev);
 		if (ret < 0)
@@ -1342,6 +1347,17 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+static const struct dmi_system_id platform_flags[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
+		},
+		.driver_data = (void *)PHY_USE_FIRMWARE_LED,
+	},
+	{}
+};
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1363,6 +1379,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	struct mii_bus *bus = phydev->mdio.bus;
 	struct device *d = &phydev->mdio.dev;
 	struct module *ndev_owner = NULL;
+	const struct dmi_system_id *dmi;
 	bool using_genphy = false;
 	int err;
 
@@ -1443,6 +1460,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 			phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
 	}
 
+	dmi = dmi_first_match(platform_flags);
+	if (dmi)
+		phydev->dev_flags |= (u32)dmi->driver_data;
+
 	phydev->dev_flags |= flags;
 
 	phydev->interface = interface;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6de8d7a90d78e..3a944a6564f43 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -517,6 +517,8 @@ struct phy_c45_device_ids {
 struct macsec_context;
 struct macsec_ops;
 
+#define PHY_USE_FIRMWARE_LED 0x1000000
+
 /**
  * struct phy_device - An instance of a PHY
  *
@@ -663,6 +665,7 @@ struct phy_device {
 
 	struct phy_led_trigger *led_link_trigger;
 #endif
+	int led_config;
 
 	/*
 	 * Interrupt number for this PHY
@@ -776,6 +779,12 @@ struct phy_driver {
 	 */
 	int (*config_init)(struct phy_device *phydev);
 
+	/**
+	 * @config_led: Called to config the PHY LED,
+	 * Use the resume flag to indicate init or resume
+	 */
+	void (*config_led)(struct phy_device *phydev, bool resume);
+
 	/**
 	 * @probe: Called during discovery.  Used to set
 	 * up device-specific structures, if any
-- 
2.33.1

