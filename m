Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F053A1AE5C8
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgDQT3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:29:21 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:49599 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbgDQT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:29:21 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3BBF52305C;
        Fri, 17 Apr 2020 21:29:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587151755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+zvcd+0WckOui3lqd6Z28Rq5hDjMDuAKF8K091Hhj8=;
        b=EUM77ycI0S2QQQTEe4s7pyzZeafRCZlK6/X8Xg1iKywJoye7clWcj/rDwteFi2F5DcM+kW
        H8IHCkn5YgHTUX0XYb2tinwLKYzp/HpZeAwkwcpn9IRYDjJmf/Ct3dKBSaq9LnIQJWnLQQ
        4X5F+E4owbSfxw5WQnQir0TAEcw/Jv0=
From:   Michael Walle <michael@walle.cc>
To:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Date:   Fri, 17 Apr 2020 21:28:58 +0200
Message-Id: <20200417192858.6997-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200417192858.6997-1-michael@walle.cc>
References: <20200417192858.6997-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 3BBF52305C
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.939];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[suse.com,roeck-us.net,lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY supports monitoring its die temperature as well as two analog
voltages. Add support for it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/hwmon/bcm54140.rst |  45 ++++
 Documentation/hwmon/index.rst    |   1 +
 drivers/net/phy/bcm54140.c       | 377 +++++++++++++++++++++++++++++++
 3 files changed, 423 insertions(+)
 create mode 100644 Documentation/hwmon/bcm54140.rst

diff --git a/Documentation/hwmon/bcm54140.rst b/Documentation/hwmon/bcm54140.rst
new file mode 100644
index 000000000000..bc6ea4b45966
--- /dev/null
+++ b/Documentation/hwmon/bcm54140.rst
@@ -0,0 +1,45 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+Broadcom BCM54140 Quad SGMII/QSGMII PHY
+=======================================
+
+Supported chips:
+
+   * Broadcom BCM54140
+
+     Datasheet: not public
+
+Author: Michael Walle <michael@walle.cc>
+
+Description
+-----------
+
+The Broadcom BCM54140 is a Quad SGMII/QSGMII PHY which supports monitoring
+its die temperature as well as two analog voltages.
+
+The AVDDL is a 1.0V analogue voltage, the AVDDH is a 3.3V analogue voltage.
+Both voltages and the temperature are measured in a round-robin fashion.
+
+Sysfs entries
+-------------
+
+The following attributes are supported.
+
+======================= ========================================================
+in0_label		"AVDDL"
+in0_input		Measured AVDDL voltage.
+in0_min			Minimum AVDDL voltage.
+in0_max			Maximum AVDDL voltage.
+in0_alarm		AVDDL voltage alarm.
+
+in1_label		"AVDDH"
+in1_input		Measured AVDDH voltage.
+in1_min			Minimum AVDDH voltage.
+in1_max			Maximum AVDDH voltage.
+in1_alarm		AVDDH voltage alarm.
+
+temp1_input		Die temperature.
+temp1_min		Minimum die temperature.
+temp1_max		Maximum die temperature.
+temp1_alarm		Die temperature alarm.
+======================= ========================================================
diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index f022583f96f6..19ad0846736d 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -42,6 +42,7 @@ Hardware Monitoring Kernel Drivers
    asb100
    asc7621
    aspeed-pwm-tacho
+   bcm54140
    bel-pfe
    coretemp
    da9052
diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 97465491b41b..97c364ce05e3 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/brcmphy.h>
+#include <linux/hwmon.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 
@@ -50,6 +51,54 @@
 #define  BCM54140_RDB_TOP_IMR_PORT1	BIT(5)
 #define  BCM54140_RDB_TOP_IMR_PORT2	BIT(6)
 #define  BCM54140_RDB_TOP_IMR_PORT3	BIT(7)
+#define BCM54140_RDB_MON_CTRL		0x831	/* monitor control */
+#define  BCM54140_RDB_MON_CTRL_V_MODE	BIT(3)	/* voltage mode */
+#define  BCM54140_RDB_MON_CTRL_SEL_MASK	GENMASK(2, 1)
+#define  BCM54140_RDB_MON_CTRL_SEL_TEMP	0	/* meassure temperature */
+#define  BCM54140_RDB_MON_CTRL_SEL_1V0	1	/* meassure AVDDL 1.0V */
+#define  BCM54140_RDB_MON_CTRL_SEL_3V3	2	/* meassure AVDDH 3.3V */
+#define  BCM54140_RDB_MON_CTRL_SEL_RR	3	/* meassure all round-robin */
+#define  BCM54140_RDB_MON_CTRL_PWR_DOWN	BIT(0)	/* power-down monitor */
+#define BCM54140_RDB_MON_TEMP_VAL	0x832	/* temperature value */
+#define BCM54140_RDB_MON_TEMP_MAX	0x833	/* temperature high thresh */
+#define BCM54140_RDB_MON_TEMP_MIN	0x834	/* temperature low thresh */
+#define  BCM54140_RDB_MON_TEMP_DATA_MASK GENMASK(9, 0)
+#define BCM54140_RDB_MON_1V0_VAL	0x835	/* AVDDL 1.0V value */
+#define BCM54140_RDB_MON_1V0_MAX	0x836	/* AVDDL 1.0V high thresh */
+#define BCM54140_RDB_MON_1V0_MIN	0x837	/* AVDDL 1.0V low thresh */
+#define  BCM54140_RDB_MON_1V0_DATA_MASK	GENMASK(10, 0)
+#define BCM54140_RDB_MON_3V3_VAL	0x838	/* AVDDH 3.3V value */
+#define BCM54140_RDB_MON_3V3_MAX	0x839	/* AVDDH 3.3V high thresh */
+#define BCM54140_RDB_MON_3V3_MIN	0x83a	/* AVDDH 3.3V low thresh */
+#define  BCM54140_RDB_MON_3V3_DATA_MASK	GENMASK(11, 0)
+#define BCM54140_RDB_MON_ISR		0x83b	/* interrupt status */
+#define  BCM54140_RDB_MON_ISR_3V3	BIT(2)	/* AVDDH 3.3V alarm */
+#define  BCM54140_RDB_MON_ISR_1V0	BIT(1)	/* AVDDL 1.0V alarm */
+#define  BCM54140_RDB_MON_ISR_TEMP	BIT(0)	/* temperature alarm */
+
+/* According to the datasheet the formula is:
+ *   T = 413.35 - (0.49055 * bits[9:0])
+ */
+#define BCM54140_HWMON_TO_TEMP(v) (413350L - (v) * 491)
+#define BCM54140_HWMON_FROM_TEMP(v) DIV_ROUND_CLOSEST_ULL(413350L - (v), 491)
+
+/* According to the datasheet the formula is:
+ *   U = bits[11:0] / 1024 * 220 / 0.2
+ *
+ * Normalized:
+ *   U = bits[11:0] / 4096 * 2514
+ */
+#define BCM54140_HWMON_TO_IN_1V0(v) ((v) * 2514 >> 11)
+#define BCM54140_HWMON_FROM_IN_1V0(v) DIV_ROUND_CLOSEST_ULL(((v) << 11), 2514)
+
+/* According to the datasheet the formula is:
+ *   U = bits[10:0] / 1024 * 880 / 0.7
+ *
+ * Normalized:
+ *   U = bits[10:0] / 2048 * 4400
+ */
+#define BCM54140_HWMON_TO_IN_3V3(v) ((v) * 4400 >> 12)
+#define BCM54140_HWMON_FROM_IN_3V3(v) DIV_ROUND_CLOSEST_ULL(((v) << 12), 4400)
 
 #define BCM54140_DEFAULT_DOWNSHIFT 5
 #define BCM54140_MAX_DOWNSHIFT 9
@@ -57,6 +106,258 @@
 struct bcm54140_phy_priv {
 	int port;
 	int base_addr;
+	bool pkg_init;
+	u16 alarm;
+};
+
+static umode_t bcm54140_hwmon_is_visible(const void *data,
+					 enum hwmon_sensor_types type,
+					 u32 attr, int channel)
+{
+	switch (type) {
+	case hwmon_in:
+		switch (attr) {
+		case hwmon_in_min:
+		case hwmon_in_max:
+			return 0644;
+		case hwmon_in_label:
+		case hwmon_in_input:
+		case hwmon_in_alarm:
+			return 0444;
+		default:
+			return 0;
+		}
+	case hwmon_temp:
+		switch (attr) {
+		case hwmon_temp_min:
+		case hwmon_temp_max:
+			return 0644;
+		case hwmon_temp_input:
+		case hwmon_temp_alarm:
+			return 0444;
+		default:
+			return 0;
+		}
+	default:
+		return 0;
+	}
+}
+
+static int bcm54140_hwmon_read_alarm(struct device *dev, unsigned int bit,
+				     long *val)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	struct bcm54140_phy_priv *priv = phydev->priv;
+	u16 tmp;
+
+	/* latch any alarm bits */
+	tmp = bcm_phy_read_rdb(phydev, BCM54140_RDB_MON_ISR);
+	if (tmp < 0)
+		return tmp;
+	priv->alarm |= tmp;
+
+	*val = !!(priv->alarm & bit);
+	priv->alarm &= ~bit;
+
+	return 0;
+}
+
+static int bcm54140_hwmon_read_temp(struct device *dev, u32 attr,
+				    int channel, long *val)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	u16 reg, tmp;
+
+	switch (attr) {
+	case hwmon_temp_input:
+		reg = BCM54140_RDB_MON_TEMP_VAL;
+		break;
+	case hwmon_temp_min:
+		reg = BCM54140_RDB_MON_TEMP_MIN;
+		break;
+	case hwmon_temp_max:
+		reg = BCM54140_RDB_MON_TEMP_MAX;
+		break;
+	case hwmon_temp_alarm:
+		return bcm54140_hwmon_read_alarm(dev,
+						 BCM54140_RDB_MON_ISR_TEMP,
+						 val);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	tmp = bcm_phy_read_rdb(phydev, reg);
+	if (tmp < 0)
+		return tmp;
+
+	*val = BCM54140_HWMON_TO_TEMP(tmp & BCM54140_RDB_MON_TEMP_DATA_MASK);
+
+	return 0;
+}
+
+static int bcm54140_hwmon_read_in(struct device *dev, u32 attr,
+				  int channel, long *val)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	u16 mask = (!channel) ? BCM54140_RDB_MON_1V0_DATA_MASK
+			      : BCM54140_RDB_MON_3V3_DATA_MASK;
+	u16 bit, reg, tmp;
+
+	switch (attr) {
+	case hwmon_in_input:
+		reg = (!channel) ? BCM54140_RDB_MON_1V0_VAL
+				 : BCM54140_RDB_MON_3V3_VAL;
+		break;
+	case hwmon_in_min:
+		reg = (!channel) ? BCM54140_RDB_MON_1V0_MIN
+				 : BCM54140_RDB_MON_3V3_MIN;
+		break;
+	case hwmon_in_max:
+		reg = (!channel) ? BCM54140_RDB_MON_1V0_MAX
+				 : BCM54140_RDB_MON_3V3_MAX;
+		break;
+	case hwmon_in_alarm:
+		bit = (!channel) ? BCM54140_RDB_MON_ISR_1V0
+				 : BCM54140_RDB_MON_ISR_3V3;
+		return bcm54140_hwmon_read_alarm(dev, bit, val);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	tmp = bcm_phy_read_rdb(phydev, reg);
+	if (tmp < 0)
+		return tmp;
+
+	if (!channel)
+		*val = BCM54140_HWMON_TO_IN_1V0(tmp & mask);
+	else
+		*val = BCM54140_HWMON_TO_IN_3V3(tmp & mask);
+
+	return 0;
+}
+
+static int bcm54140_hwmon_read(struct device *dev,
+			       enum hwmon_sensor_types type, u32 attr,
+			       int channel, long *val)
+{
+	switch (type) {
+	case hwmon_temp:
+		return bcm54140_hwmon_read_temp(dev, attr, channel, val);
+	case hwmon_in:
+		return bcm54140_hwmon_read_in(dev, attr, channel, val);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const char *const bcm54140_hwmon_in_labels[] = {
+	"AVDDL",
+	"AVDDH",
+};
+
+static int bcm54140_hwmon_read_string(struct device *dev,
+				      enum hwmon_sensor_types type, u32 attr,
+				      int channel, const char **str)
+{
+	switch (type) {
+	case hwmon_in:
+		switch (attr) {
+		case hwmon_in_label:
+			*str = bcm54140_hwmon_in_labels[channel];
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int bcm54140_hwmon_write_temp(struct device *dev, u32 attr,
+				     int channel, long val)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	u16 reg;
+
+	switch (attr) {
+	case hwmon_temp_min:
+		reg = BCM54140_RDB_MON_TEMP_MIN;
+		break;
+	case hwmon_temp_max:
+		reg = BCM54140_RDB_MON_TEMP_MAX;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return bcm_phy_modify_rdb(phydev, reg, BCM54140_RDB_MON_TEMP_DATA_MASK,
+				  BCM54140_HWMON_FROM_TEMP(val));
+}
+
+static int bcm54140_hwmon_write_in(struct device *dev, u32 attr,
+				   int channel, long val)
+{
+	struct phy_device *phydev = dev_get_drvdata(dev);
+	u16 mask = (!channel) ? BCM54140_RDB_MON_1V0_DATA_MASK
+			      : BCM54140_RDB_MON_3V3_DATA_MASK;
+	unsigned long raw = (!channel) ?  BCM54140_HWMON_FROM_IN_1V0(val)
+				       :  BCM54140_HWMON_FROM_IN_3V3(val);
+	u16 reg;
+
+	raw = clamp_val(raw, 0, mask);
+
+	switch (attr) {
+	case hwmon_in_min:
+		reg = (!channel) ? BCM54140_RDB_MON_1V0_MIN
+				 : BCM54140_RDB_MON_3V3_MIN;
+		break;
+	case hwmon_in_max:
+		reg = (!channel) ? BCM54140_RDB_MON_1V0_MAX
+				 : BCM54140_RDB_MON_3V3_MAX;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return bcm_phy_modify_rdb(phydev, reg, mask, raw);
+}
+
+static int bcm54140_hwmon_write(struct device *dev,
+				enum hwmon_sensor_types type, u32 attr,
+				int channel, long val)
+{
+	switch (type) {
+	case hwmon_temp:
+		return bcm54140_hwmon_write_temp(dev, attr, channel, val);
+	case hwmon_in:
+		return bcm54140_hwmon_write_in(dev, attr, channel, val);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct hwmon_channel_info *bcm54140_hwmon_info[] = {
+	HWMON_CHANNEL_INFO(temp,
+			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
+			   HWMON_T_ALARM),
+	HWMON_CHANNEL_INFO(in,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX |
+			   HWMON_I_ALARM | HWMON_I_LABEL,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX |
+			   HWMON_I_ALARM | HWMON_I_LABEL),
+	NULL
+};
+
+static const struct hwmon_ops bcm54140_hwmon_ops = {
+	.is_visible = bcm54140_hwmon_is_visible,
+	.read = bcm54140_hwmon_read,
+	.read_string = bcm54140_hwmon_read_string,
+	.write = bcm54140_hwmon_write,
+};
+
+static const struct hwmon_chip_info bcm54140_chip_info = {
+	.ops = &bcm54140_hwmon_ops,
+	.info = bcm54140_hwmon_info,
 };
 
 static int bcm54140_phy_base_read_rdb(struct phy_device *phydev, u16 rdb)
@@ -203,6 +504,74 @@ static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
 	return 0;
 }
 
+/* Check if one PHY has already done the init of the parts common to all PHYs
+ * in the Quad PHY package.
+ */
+static bool bcm54140_is_pkg_init(struct phy_device *phydev)
+{
+	struct mdio_device **map = phydev->mdio.bus->mdio_map;
+	struct bcm54140_phy_priv *priv;
+	struct phy_device *phy;
+	int i, addr;
+
+	/* Quad PHY */
+	for (i = 0; i < 4; i++) {
+		priv = phydev->priv;
+		addr = priv->base_addr + i;
+
+		if (!map[addr])
+			continue;
+
+		phy = container_of(map[addr], struct phy_device, mdio);
+
+		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
+		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
+			continue;
+
+		priv = phy->priv;
+
+		if (priv && priv->pkg_init)
+			return true;
+	}
+
+	return false;
+}
+
+static int bcm54140_enable_monitoring(struct phy_device *phydev)
+{
+	u16 mask, set;
+
+	/* 3.3V voltage mode */
+	set = BCM54140_RDB_MON_CTRL_V_MODE;
+
+	/* select round-robin */
+	mask = BCM54140_RDB_MON_CTRL_SEL_MASK;
+	set |= FIELD_PREP(BCM54140_RDB_MON_CTRL_SEL_MASK,
+			  BCM54140_RDB_MON_CTRL_SEL_RR);
+
+	/* remove power-down bit */
+	mask |= BCM54140_RDB_MON_CTRL_PWR_DOWN;
+
+	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_MON_CTRL, mask, set);
+}
+
+static int bcm54140_phy_probe_once(struct phy_device *phydev)
+{
+	struct device *hwmon;
+	int ret;
+
+	/* enable hardware monitoring */
+	ret = bcm54140_enable_monitoring(phydev);
+	if (ret)
+		return ret;
+
+	hwmon = devm_hwmon_device_register_with_info(&phydev->mdio.dev,
+						     "BCM54140", phydev,
+						     &bcm54140_chip_info,
+						     NULL);
+	return PTR_ERR_OR_ZERO(hwmon);
+}
+
 static int bcm54140_phy_probe(struct phy_device *phydev)
 {
 	struct bcm54140_phy_priv *priv;
@@ -218,6 +587,14 @@ static int bcm54140_phy_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (!bcm54140_is_pkg_init(phydev)) {
+		ret = bcm54140_phy_probe_once(phydev);
+		if (ret)
+			return ret;
+	}
+
+	priv->pkg_init = true;
+
 	dev_info(&phydev->mdio.dev,
 		 "probed (port %d, base PHY address %d)\n",
 		 priv->port, priv->base_addr);
-- 
2.20.1

