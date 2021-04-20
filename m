Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D6136539E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhDTHzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhDTHz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5992361008;
        Tue, 20 Apr 2021 07:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618905297;
        bh=rSCmV+qhLHvP35CWKC8PL/2R16UdtRxJjyiMInS+7EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=budcQ/jocN92Uvy9E7W0DrVHwDoaSLGyCeX9bvN+LiXoUrqy3mbi0pHQTbeVeyLme
         8jmC1UVx5qQL0zxQsmyraXuA/uyce8g1Fm0QpLmUZJfz9ZSJSOhu9MMztK3Wy8iXIA
         jrOlPKfJUxppFIDSSD0AjEMqfesroMsXRBEyvedMemvxvIQu1diB9qbeOlkdHaEoF3
         YhDy73FUqgT4OeX1/ufjKTLS0c894tb5RJXqJ4RboNHtry8flMUZGjgLTFIHpNbGny
         cuhy9nTuTMFCktsF7nDQKd/7vpWUhRADiEmqGKL4/i/sWXe+96ZW4juw6Ng9ceTApb
         JMb+DFptVcoQA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 5/5] net: phy: marvell: add support for Amethyst internal PHY
Date:   Tue, 20 Apr 2021 09:54:03 +0200
Message-Id: <20210420075403.5845-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420075403.5845-1-kabel@kernel.org>
References: <20210420075403.5845-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Amethyst internal PHY.

The only difference from Peridot is HWMON.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c   | 117 +++++++++++++++++++++++++++++++++++-
 include/linux/marvell_phy.h |   1 +
 2 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e505060d0743..1cce86b280af 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -118,10 +118,21 @@
 #define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_ONESHOT	(0x2 << 14)
 #define MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE		(0x3 << 14)
 #define MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK			(0x3 << 14)
+#define MII_88E6393_MISC_TEST_SAMPLES_2048	(0x0 << 11)
+#define MII_88E6393_MISC_TEST_SAMPLES_4096	(0x1 << 11)
+#define MII_88E6393_MISC_TEST_SAMPLES_8192	(0x2 << 11)
+#define MII_88E6393_MISC_TEST_SAMPLES_16384	(0x3 << 11)
+#define MII_88E6393_MISC_TEST_SAMPLES_MASK	(0x3 << 11)
+#define MII_88E6393_MISC_TEST_RATE_2_3MS	(0x5 << 8)
+#define MII_88E6393_MISC_TEST_RATE_6_4MS	(0x6 << 8)
+#define MII_88E6393_MISC_TEST_RATE_11_9MS	(0x7 << 8)
+#define MII_88E6393_MISC_TEST_RATE_MASK		(0x7 << 8)
 
 #define MII_88E6390_TEMP_SENSOR		0x1c
-#define MII_88E6390_TEMP_SENSOR_MASK	0xff
-#define MII_88E6390_TEMP_SENSOR_SAMPLES 10
+#define MII_88E6393_TEMP_SENSOR_THRESHOLD_MASK	0xff00
+#define MII_88E6393_TEMP_SENSOR_THRESHOLD_SHIFT	8
+#define MII_88E6390_TEMP_SENSOR_MASK		0xff
+#define MII_88E6390_TEMP_SENSOR_SAMPLES		10
 
 #define MII_88E1318S_PHY_MSCR1_REG	16
 #define MII_88E1318S_PHY_MSCR1_PAD_ODD	BIT(6)
@@ -2217,6 +2228,7 @@ static int marvell_vct7_cable_test_get_status(struct phy_device *phydev,
 
 #ifdef CONFIG_HWMON
 struct marvell_hwmon_ops {
+	int (*config)(struct phy_device *phydev);
 	int (*get_temp)(struct phy_device *phydev, long *temp);
 	int (*get_temp_critical)(struct phy_device *phydev, long *temp);
 	int (*set_temp_critical)(struct phy_device *phydev, long temp);
@@ -2391,6 +2403,65 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 	return ret;
 }
 
+static int m88e6393_get_temp(struct phy_device *phydev, long *temp)
+{
+	int err;
+
+	err = m88e1510_get_temp(phydev, temp);
+
+	/* 88E1510 measures T + 25, while the PHY on 88E6393X switch
+	 * T + 75, so we have to subtract another 50
+	 */
+	*temp -= 50000;
+
+	return err;
+}
+
+static int m88e6393_get_temp_critical(struct phy_device *phydev, long *temp)
+{
+	int ret;
+
+	*temp = 0;
+
+	ret = phy_read_paged(phydev, MII_MARVELL_MISC_TEST_PAGE,
+			     MII_88E6390_TEMP_SENSOR);
+	if (ret < 0)
+		return ret;
+
+	*temp = (((ret & MII_88E6393_TEMP_SENSOR_THRESHOLD_MASK) >>
+		  MII_88E6393_TEMP_SENSOR_THRESHOLD_SHIFT) - 75) * 1000;
+
+	return 0;
+}
+
+static int m88e6393_set_temp_critical(struct phy_device *phydev, long temp)
+{
+	temp = (temp / 1000) + 75;
+
+	return phy_modify_paged(phydev, MII_MARVELL_MISC_TEST_PAGE,
+				MII_88E6390_TEMP_SENSOR,
+				MII_88E6393_TEMP_SENSOR_THRESHOLD_MASK,
+				temp << MII_88E6393_TEMP_SENSOR_THRESHOLD_SHIFT);
+}
+
+static int m88e6393_hwmon_config(struct phy_device *phydev)
+{
+	int err;
+
+	err = m88e6393_set_temp_critical(phydev, 100000);
+	if (err)
+		return err;
+
+	return phy_modify_paged(phydev, MII_MARVELL_MISC_TEST_PAGE,
+				MII_88E6390_MISC_TEST,
+				MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK |
+				MII_88E6393_MISC_TEST_SAMPLES_MASK |
+				MII_88E6393_MISC_TEST_RATE_MASK,
+				MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE |
+				MII_88E6393_MISC_TEST_SAMPLES_2048 |
+				MII_88E6393_MISC_TEST_RATE_2_3MS);
+}
+
 static int marvell_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			      u32 attr, int channel, long *temp)
 {
@@ -2535,8 +2606,13 @@ static int marvell_hwmon_probe(struct phy_device *phydev)
 
 	priv->hwmon_dev = devm_hwmon_device_register_with_info(
 		dev, priv->hwmon_name, phydev, &marvell_hwmon_chip_info, NULL);
+	if (IS_ERR(priv->hwmon_dev))
+		return PTR_ERR(priv->hwmon_dev);
 
-	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
+	if (ops->config)
+		err = ops->config(phydev);
+
+	return err;
 }
 
 static const struct marvell_hwmon_ops m88e1121_hwmon_ops = {
@@ -2554,6 +2630,14 @@ static const struct marvell_hwmon_ops m88e6390_hwmon_ops = {
 	.get_temp = m88e6390_get_temp,
 };
 
+static const struct marvell_hwmon_ops m88e6393_hwmon_ops = {
+	.config = m88e6393_hwmon_config,
+	.get_temp = m88e6393_get_temp,
+	.get_temp_critical = m88e6393_get_temp_critical,
+	.set_temp_critical = m88e6393_set_temp_critical,
+	.get_temp_alarm = m88e1510_get_temp_alarm,
+};
+
 #define DEF_MARVELL_HWMON_OPS(s) (&(s))
 
 #else
@@ -2948,6 +3032,32 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E6393_FAMILY,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E6393 Family",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e6393_hwmon_ops),
+		/* PHY_GBIT_FEATURES */
+		.flags = PHY_POLL_CABLE_TEST,
+		.probe = marvell_probe,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1510_config_aneg,
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
 	{
 		.phy_id = MARVELL_PHY_ID_88E1340S,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
@@ -3014,6 +3124,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6390_FAMILY, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6393_FAMILY, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1548P, MARVELL_PHY_ID_MASK },
 	{ }
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index f61d82c53f30..acee44b9db26 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -39,6 +39,7 @@
  */
 #define MARVELL_PHY_ID_88E6341_FAMILY	0x01410f41
 #define MARVELL_PHY_ID_88E6390_FAMILY	0x01410f90
+#define MARVELL_PHY_ID_88E6393_FAMILY	0x002b0b9b
 
 #define MARVELL_PHY_FAMILY_ID(id)	((id) >> 4)
 
-- 
2.26.3

