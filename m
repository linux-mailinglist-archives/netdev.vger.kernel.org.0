Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B535D96A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhDMH4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhDMH4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF54613B1;
        Tue, 13 Apr 2021 07:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618300581;
        bh=ZDP5GkJ26LaZdHCjVi307mmTUn/wTcpgZQkl1xjLo2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WesdP7Yxr/Ip69r2RS/M6RYq8psGRsDZ+s9q/UuiOQhyxVk7sRCkJvPl6Ld8FqkvV
         hUkCwt7ZfGSEd9Lnto75Dl6urFohdwPLlxNA3QR3U93WWJ4LoBp850ebdhNcs5HXsj
         xBDzGo3Rj8Gc+CiLYguSO567ot+88yKo+oHMeAfG408IYKe64rkFup/zPpelxO8CH5
         4wPN+mBogW5BtH2N+ItXXljb7WDaHH5rma7X1ARrnU9kqiSYCYmoboIyUwXLxQYXDE
         wxmqa5vxBgJFtmjAusS++6frVlZirKnrpGnIJBMLpm/cz+hTkRn/BWaoowgzJL97+9
         idk8Ysy9o2IhA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/5] net: phy: marvell: refactor HWMON OOP style
Date:   Tue, 13 Apr 2021 09:55:34 +0200
Message-Id: <20210413075538.30175-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210413075538.30175-1-kabel@kernel.org>
References: <20210413075538.30175-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a structure of Marvell PHY specific HWMON methods to reduce code
duplication. Store a pointer to this structure into the PHY driver's
driver_data member.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c | 371 +++++++++++++-------------------------
 1 file changed, 127 insertions(+), 244 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 8018ddf7f316..63788d5c13eb 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2216,6 +2216,19 @@ static int marvell_vct7_cable_test_get_status(struct phy_device *phydev,
 }
 
 #ifdef CONFIG_HWMON
+struct marvell_hwmon_ops {
+	int (*get_temp)(struct phy_device *phydev, long *temp);
+	int (*get_temp_critical)(struct phy_device *phydev, long *temp);
+	int (*set_temp_critical)(struct phy_device *phydev, long temp);
+	int (*get_temp_alarm)(struct phy_device *phydev, long *alarm);
+};
+
+static const struct marvell_hwmon_ops *
+to_marvell_hwmon_ops(const struct phy_device *phydev)
+{
+	return phydev->drv->driver_data;
+}
+
 static int m88e1121_get_temp(struct phy_device *phydev, long *temp)
 {
 	int oldpage;
@@ -2259,75 +2272,6 @@ static int m88e1121_get_temp(struct phy_device *phydev, long *temp)
 	return phy_restore_page(phydev, oldpage, ret);
 }
 
-static int m88e1121_hwmon_read(struct device *dev,
-			       enum hwmon_sensor_types type,
-			       u32 attr, int channel, long *temp)
-{
-	struct phy_device *phydev = dev_get_drvdata(dev);
-	int err;
-
-	switch (attr) {
-	case hwmon_temp_input:
-		err = m88e1121_get_temp(phydev, temp);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return err;
-}
-
-static umode_t m88e1121_hwmon_is_visible(const void *data,
-					 enum hwmon_sensor_types type,
-					 u32 attr, int channel)
-{
-	if (type != hwmon_temp)
-		return 0;
-
-	switch (attr) {
-	case hwmon_temp_input:
-		return 0444;
-	default:
-		return 0;
-	}
-}
-
-static u32 m88e1121_hwmon_chip_config[] = {
-	HWMON_C_REGISTER_TZ,
-	0
-};
-
-static const struct hwmon_channel_info m88e1121_hwmon_chip = {
-	.type = hwmon_chip,
-	.config = m88e1121_hwmon_chip_config,
-};
-
-static u32 m88e1121_hwmon_temp_config[] = {
-	HWMON_T_INPUT,
-	0
-};
-
-static const struct hwmon_channel_info m88e1121_hwmon_temp = {
-	.type = hwmon_temp,
-	.config = m88e1121_hwmon_temp_config,
-};
-
-static const struct hwmon_channel_info *m88e1121_hwmon_info[] = {
-	&m88e1121_hwmon_chip,
-	&m88e1121_hwmon_temp,
-	NULL
-};
-
-static const struct hwmon_ops m88e1121_hwmon_hwmon_ops = {
-	.is_visible = m88e1121_hwmon_is_visible,
-	.read = m88e1121_hwmon_read,
-};
-
-static const struct hwmon_chip_info m88e1121_hwmon_chip_info = {
-	.ops = &m88e1121_hwmon_hwmon_ops,
-	.info = m88e1121_hwmon_info,
-};
-
 static int m88e1510_get_temp(struct phy_device *phydev, long *temp)
 {
 	int ret;
@@ -2390,92 +2334,6 @@ static int m88e1510_get_temp_alarm(struct phy_device *phydev, long *alarm)
 	return 0;
 }
 
-static int m88e1510_hwmon_read(struct device *dev,
-			       enum hwmon_sensor_types type,
-			       u32 attr, int channel, long *temp)
-{
-	struct phy_device *phydev = dev_get_drvdata(dev);
-	int err;
-
-	switch (attr) {
-	case hwmon_temp_input:
-		err = m88e1510_get_temp(phydev, temp);
-		break;
-	case hwmon_temp_crit:
-		err = m88e1510_get_temp_critical(phydev, temp);
-		break;
-	case hwmon_temp_max_alarm:
-		err = m88e1510_get_temp_alarm(phydev, temp);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return err;
-}
-
-static int m88e1510_hwmon_write(struct device *dev,
-				enum hwmon_sensor_types type,
-				u32 attr, int channel, long temp)
-{
-	struct phy_device *phydev = dev_get_drvdata(dev);
-	int err;
-
-	switch (attr) {
-	case hwmon_temp_crit:
-		err = m88e1510_set_temp_critical(phydev, temp);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return err;
-}
-
-static umode_t m88e1510_hwmon_is_visible(const void *data,
-					 enum hwmon_sensor_types type,
-					 u32 attr, int channel)
-{
-	if (type != hwmon_temp)
-		return 0;
-
-	switch (attr) {
-	case hwmon_temp_input:
-	case hwmon_temp_max_alarm:
-		return 0444;
-	case hwmon_temp_crit:
-		return 0644;
-	default:
-		return 0;
-	}
-}
-
-static u32 m88e1510_hwmon_temp_config[] = {
-	HWMON_T_INPUT | HWMON_T_CRIT | HWMON_T_MAX_ALARM,
-	0
-};
-
-static const struct hwmon_channel_info m88e1510_hwmon_temp = {
-	.type = hwmon_temp,
-	.config = m88e1510_hwmon_temp_config,
-};
-
-static const struct hwmon_channel_info *m88e1510_hwmon_info[] = {
-	&m88e1121_hwmon_chip,
-	&m88e1510_hwmon_temp,
-	NULL
-};
-
-static const struct hwmon_ops m88e1510_hwmon_hwmon_ops = {
-	.is_visible = m88e1510_hwmon_is_visible,
-	.read = m88e1510_hwmon_read,
-	.write = m88e1510_hwmon_write,
-};
-
-static const struct hwmon_chip_info m88e1510_hwmon_chip_info = {
-	.ops = &m88e1510_hwmon_hwmon_ops,
-	.info = m88e1510_hwmon_info,
-};
-
 static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 {
 	int sum = 0;
@@ -2534,63 +2392,114 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 	return ret;
 }
 
-static int m88e6390_hwmon_read(struct device *dev,
-			       enum hwmon_sensor_types type,
-			       u32 attr, int channel, long *temp)
+static int marvell_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
+			      u32 attr, int channel, long *temp)
 {
 	struct phy_device *phydev = dev_get_drvdata(dev);
-	int err;
+	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
+	int err = -EOPNOTSUPP;
 
 	switch (attr) {
 	case hwmon_temp_input:
-		err = m88e6390_get_temp(phydev, temp);
+		if (ops->get_temp)
+			err = ops->get_temp(phydev, temp);
+		break;
+	case hwmon_temp_crit:
+		if (ops->get_temp_critical)
+			err = ops->get_temp_critical(phydev, temp);
+		break;
+	case hwmon_temp_max_alarm:
+		if (ops->get_temp_alarm)
+			err = ops->get_temp_alarm(phydev, temp);
 		break;
 	default:
-		return -EOPNOTSUPP;
+		fallthrough;
+	}
+
+	return err;
+}
+
+static int marvell_hwmon_write(struct device *dev, enum hwmon_sensor_types type,
+			       u32 attr, int channel, long temp)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
+	int err = -EOPNOTSUPP;
+
+	switch (attr) {
+	case hwmon_temp_crit:
+		if (ops->set_temp_critical)
+			err = ops->set_temp_critical(phydev, temp);
+		break;
+	default:
+		fallthrough;
 	}
 
 	return err;
 }
 
-static umode_t m88e6390_hwmon_is_visible(const void *data,
-					 enum hwmon_sensor_types type,
-					 u32 attr, int channel)
+static umode_t marvell_hwmon_is_visible(const void *data,
+					enum hwmon_sensor_types type,
+					u32 attr, int channel)
 {
+	const struct phy_device *phydev = data;
+	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
+
 	if (type != hwmon_temp)
 		return 0;
 
 	switch (attr) {
 	case hwmon_temp_input:
-		return 0444;
+		return ops->get_temp ? 0444 : 0;
+	case hwmon_temp_max_alarm:
+		return ops->get_temp_alarm ? 0444 : 0;
+	case hwmon_temp_crit:
+		return (ops->get_temp_critical ? 0444 : 0) |
+		       (ops->set_temp_critical ? 0200 : 0);
 	default:
 		return 0;
 	}
 }
 
-static u32 m88e6390_hwmon_temp_config[] = {
-	HWMON_T_INPUT,
+static u32 marvell_hwmon_chip_config[] = {
+	HWMON_C_REGISTER_TZ,
+	0
+};
+
+static const struct hwmon_channel_info marvell_hwmon_chip = {
+	.type = hwmon_chip,
+	.config = marvell_hwmon_chip_config,
+};
+
+/* we can define HWMON_T_CRIT and HWMON_T_MAX_ALARM even though these are not
+ * defined for all PHYs, because the hwmon code checks whether the attributes
+ * exists via the .is_visible method
+ */
+static u32 marvell_hwmon_temp_config[] = {
+	HWMON_T_INPUT | HWMON_T_CRIT | HWMON_T_MAX_ALARM,
 	0
 };
 
-static const struct hwmon_channel_info m88e6390_hwmon_temp = {
+static const struct hwmon_channel_info marvell_hwmon_temp = {
 	.type = hwmon_temp,
-	.config = m88e6390_hwmon_temp_config,
+	.config = marvell_hwmon_temp_config,
 };
 
-static const struct hwmon_channel_info *m88e6390_hwmon_info[] = {
-	&m88e1121_hwmon_chip,
-	&m88e6390_hwmon_temp,
+static const struct hwmon_channel_info *marvell_hwmon_info[] = {
+	&marvell_hwmon_chip,
+	&marvell_hwmon_temp,
 	NULL
 };
 
-static const struct hwmon_ops m88e6390_hwmon_hwmon_ops = {
-	.is_visible = m88e6390_hwmon_is_visible,
-	.read = m88e6390_hwmon_read,
+static const struct hwmon_ops marvell_hwmon_hwmon_ops = {
+	.is_visible = marvell_hwmon_is_visible,
+	.read = marvell_hwmon_read,
+	.write = marvell_hwmon_write,
 };
 
-static const struct hwmon_chip_info m88e6390_hwmon_chip_info = {
-	.ops = &m88e6390_hwmon_hwmon_ops,
-	.info = m88e6390_hwmon_info,
+static const struct hwmon_chip_info marvell_hwmon_chip_info = {
+	.ops = &marvell_hwmon_hwmon_ops,
+	.info = marvell_hwmon_info,
 };
 
 static int marvell_hwmon_name(struct phy_device *phydev)
@@ -2613,49 +2522,48 @@ static int marvell_hwmon_name(struct phy_device *phydev)
 	return 0;
 }
 
-static int marvell_hwmon_probe(struct phy_device *phydev,
-			       const struct hwmon_chip_info *chip)
+static int marvell_hwmon_probe(struct phy_device *phydev)
 {
+	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
 	struct marvell_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	int err;
 
+	if (!ops)
+		return 0;
+
 	err = marvell_hwmon_name(phydev);
 	if (err)
 		return err;
 
 	priv->hwmon_dev = devm_hwmon_device_register_with_info(
-		dev, priv->hwmon_name, phydev, chip, NULL);
+		dev, priv->hwmon_name, phydev, &marvell_hwmon_chip_info, NULL);
 
 	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
 }
 
-static int m88e1121_hwmon_probe(struct phy_device *phydev)
-{
-	return marvell_hwmon_probe(phydev, &m88e1121_hwmon_chip_info);
-}
+static const struct marvell_hwmon_ops m88e1121_hwmon_ops = {
+	.get_temp = m88e1121_get_temp,
+};
 
-static int m88e1510_hwmon_probe(struct phy_device *phydev)
-{
-	return marvell_hwmon_probe(phydev, &m88e1510_hwmon_chip_info);
-}
+static const struct marvell_hwmon_ops m88e1510_hwmon_ops = {
+	.get_temp = m88e1510_get_temp,
+	.get_temp_critical = m88e1510_get_temp_critical,
+	.set_temp_critical = m88e1510_set_temp_critical,
+	.get_temp_alarm = m88e1510_get_temp_alarm,
+};
+
+static const struct marvell_hwmon_ops m88e6390_hwmon_ops = {
+	.get_temp = m88e6390_get_temp,
+};
+
+#define DEF_MARVELL_HWMON_OPS(s) (&(s))
 
-static int m88e6390_hwmon_probe(struct phy_device *phydev)
-{
-	return marvell_hwmon_probe(phydev, &m88e6390_hwmon_chip_info);
-}
 #else
-static int m88e1121_hwmon_probe(struct phy_device *phydev)
-{
-	return 0;
-}
 
-static int m88e1510_hwmon_probe(struct phy_device *phydev)
-{
-	return 0;
-}
+#define DEF_MARVELL_HWMON_OPS(s) NULL
 
-static int m88e6390_hwmon_probe(struct phy_device *phydev)
+static int marvell_hwmon_probe(struct phy_device *phydev)
 {
 	return 0;
 }
@@ -2671,40 +2579,7 @@ static int marvell_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	return 0;
-}
-
-static int m88e1121_probe(struct phy_device *phydev)
-{
-	int err;
-
-	err = marvell_probe(phydev);
-	if (err)
-		return err;
-
-	return m88e1121_hwmon_probe(phydev);
-}
-
-static int m88e1510_probe(struct phy_device *phydev)
-{
-	int err;
-
-	err = marvell_probe(phydev);
-	if (err)
-		return err;
-
-	return m88e1510_hwmon_probe(phydev);
-}
-
-static int m88e6390_probe(struct phy_device *phydev)
-{
-	int err;
-
-	err = marvell_probe(phydev);
-	if (err)
-		return err;
-
-	return m88e6390_hwmon_probe(phydev);
+	return marvell_hwmon_probe(phydev);
 }
 
 static struct phy_driver marvell_drivers[] = {
@@ -2810,8 +2685,9 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1121R,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1121R",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1121_hwmon_ops),
 		/* PHY_GBIT_FEATURES */
-		.probe = m88e1121_probe,
+		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1121_config_aneg,
 		.read_status = marvell_read_status,
@@ -2927,9 +2803,10 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1510,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1510",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = m88e1510_probe,
+		.probe = marvell_probe,
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
@@ -2955,9 +2832,10 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1540,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1540",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = m88e1510_probe,
+		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
@@ -2980,7 +2858,8 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1545,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1545",
-		.probe = m88e1510_probe,
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
+		.probe = marvell_probe,
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.config_init = marvell_config_init,
@@ -3024,9 +2903,10 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E6341 Family",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = m88e1510_probe,
+		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
@@ -3049,9 +2929,10 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E6390 Family",
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e6390_hwmon_ops),
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = m88e6390_probe,
+		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
@@ -3074,7 +2955,8 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1340S,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1340S",
-		.probe = m88e1510_probe,
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
+		.probe = marvell_probe,
 		/* PHY_GBIT_FEATURES */
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
@@ -3095,7 +2977,8 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1548P,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1548P",
-		.probe = m88e1510_probe,
+		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
+		.probe = marvell_probe,
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
-- 
2.26.3

