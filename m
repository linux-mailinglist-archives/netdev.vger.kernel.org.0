Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16F6554CB0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358275AbiFVOSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358274AbiFVOSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:18:11 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3093C717;
        Wed, 22 Jun 2022 07:17:32 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0F44122238;
        Wed, 22 Jun 2022 16:17:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1655907450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EVhXj21wXaP9dB+YPvcxxYA6B/31ROffb1PSUfK8g50=;
        b=EIdgyoE72orTXwzBYT2VDIi3Z2962L/pIdq9zXF7Dl3QyP1cKyMuVO3VyhJ4PiSS3+qgVO
        7XXHxovk3PyGd2tliDgcoUAE55fYM7RDaoI/rIS5TAdUmvIvQjW9M6TrT3xKPzPSy7Qm2z
        WkDR8Q14qJIjL/BCjQy4e1uYU576i5A=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Xu Liang <lxu@maxlinear.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hwmon@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: mxl-gpy: add temperature sensor
Date:   Wed, 22 Jun 2022 16:17:16 +0200
Message-Id: <20220622141716.3517645-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GPY115 and GPY2xx PHYs contain an integrated temperature sensor. It
accuracy is +/- 5°C. Add support for it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/Kconfig   |   2 +
 drivers/net/phy/mxl-gpy.c | 106 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9fee639ee5c8..09fa17796d4d 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -216,6 +216,8 @@ config MARVELL_88X2222_PHY
 
 config MAXLINEAR_GPHY
 	tristate "Maxlinear Ethernet PHYs"
+	select POLYNOMIAL if HWMON
+	depends on HWMON || HWMON=n
 	help
 	  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
 	  GPY241, GPY245 PHYs.
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 6c4da2f9e90a..5b99acf44337 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -8,7 +8,9 @@
 
 #include <linux/module.h>
 #include <linux/bitfield.h>
+#include <linux/hwmon.h>
 #include <linux/phy.h>
+#include <linux/polynomial.h>
 #include <linux/netdevice.h>
 
 /* PHY ID */
@@ -64,6 +66,10 @@
 #define VSPEC1_SGMII_ANEN_ANRS	(VSPEC1_SGMII_CTRL_ANEN | \
 				 VSPEC1_SGMII_CTRL_ANRS)
 
+/* Temperature sensor */
+#define VPSPEC1_TEMP_STA	0x0E
+#define VPSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
+
 /* WoL */
 #define VPSPEC2_WOL_CTL		0x0E06
 #define VPSPEC2_WOL_AD01	0x0E08
@@ -80,6 +86,102 @@ static const struct {
 	{9, 0x73},
 };
 
+#if IS_ENABLED(CONFIG_HWMON)
+/* The original translation formulae of the temperature (in degrees of Celsius)
+ * are as follows:
+ *
+ *   T = -2.5761e-11*(N^4) + 9.7332e-8*(N^3) + -1.9165e-4*(N^2) +
+ *       3.0762e-1*(N^1) + -5.2156e1
+ *
+ * where [-52.156, 137.961]C and N = [0, 1023].
+ *
+ * They must be accordingly altered to be suitable for the integer arithmetics.
+ * The technique is called 'factor redistribution', which just makes sure the
+ * multiplications and divisions are made so to have a result of the operations
+ * within the integer numbers limit. In addition we need to translate the
+ * formulae to accept millidegrees of Celsius. Here what it looks like after
+ * the alterations:
+ *
+ *   T = -25761e-12*(N^4) + 97332e-9*(N^3) + -191650e-6*(N^2) +
+ *       307620e-3*(N^1) + -52156
+ *
+ * where T = [-52156, 137961]mC and N = [0, 1023].
+ */
+static const struct polynomial poly_N_to_temp = {
+	.terms = {
+		{4,  -25761, 1000, 1},
+		{3,   97332, 1000, 1},
+		{2, -191650, 1000, 1},
+		{1,  307620, 1000, 1},
+		{0,  -52156,    1, 1}
+	}
+};
+
+static int gpy_hwmon_read(struct device *dev,
+			  enum hwmon_sensor_types type,
+			  u32 attr, int channel, long *value)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VPSPEC1_TEMP_STA);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -ENODATA;
+
+	*value = polynomial_calc(&poly_N_to_temp,
+				 FIELD_GET(VPSPEC1_TEMP_STA_DATA, ret));
+
+	return 0;
+}
+
+static umode_t gpy_hwmon_is_visible(const void *data,
+				    enum hwmon_sensor_types type,
+				    u32 attr, int channel)
+{
+	return 0444;
+}
+
+static const struct hwmon_channel_info *gpy_hwmon_info[] = {
+	HWMON_CHANNEL_INFO(temp, HWMON_T_INPUT),
+	NULL
+};
+
+static const struct hwmon_ops gpy_hwmon_hwmon_ops = {
+	.is_visible	= gpy_hwmon_is_visible,
+	.read		= gpy_hwmon_read,
+};
+
+static const struct hwmon_chip_info gpy_hwmon_chip_info = {
+	.ops		= &gpy_hwmon_hwmon_ops,
+	.info		= gpy_hwmon_info,
+};
+
+static int gpy_hwmon_register(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct device *hwmon_dev;
+	char *hwmon_name;
+
+	hwmon_name = devm_hwmon_sanitize_name(dev, dev_name(dev));
+	if (IS_ERR(hwmon_name))
+		return PTR_ERR(hwmon_name);
+
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, hwmon_name,
+							 phydev,
+							 &gpy_hwmon_chip_info,
+							 NULL);
+
+	return PTR_ERR_OR_ZERO(hwmon_dev);
+}
+#else
+static int gpy_hwmon_register(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif
+
 static int gpy_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -109,6 +211,10 @@ static int gpy_probe(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = gpy_hwmon_register(phydev);
+	if (ret)
+		return ret;
+
 	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
 		    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
 
-- 
2.30.2

