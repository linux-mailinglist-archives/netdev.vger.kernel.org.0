Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76D1CC4F5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgEIWha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:37:30 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:46227 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgEIWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:37:28 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5256C23E38;
        Sun, 10 May 2020 00:37:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589063845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U50Zecb/HE6TwxeG5bz6LYePOYjqoHfUuO2j9vyXfKA=;
        b=MGv0W/lr/VAe0QTbER6EF7tvgmYtSPvlh3MgtLoovWTvDR5DrIXfT2LFZ2z2ttgfJYxZ4K
        sZtK+bjFwqm649CtEdna4L7V3mecOuJ5gNqpU1bojpvKPv6Vgzl/r1nj6A6PcFowDUd0Fb
        F/ScKveGtrG+CopDbcbvVzAj4GCo6zg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/4] net: phy: broadcom: add cable test support
Date:   Sun, 10 May 2020 00:37:13 +0200
Message-Id: <20200509223714.30855-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200509223714.30855-1-michael@walle.cc>
References: <20200509223714.30855-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most modern broadcom PHYs support ECD (enhanced cable diagnostics). Add
support for it in the bcm-phy-lib so they can easily be used in the PHY
driver.

There are two access methods for ECD: legacy by expansion registers and
via the new RDB registers which are exclusive. Provide functions in two
variants where the PHY driver can from. To keep things simple for now,
we just switch the register access to expansion registers in the RDB
variant for now. On the flipside, we have to keep a bus lock to prevent
any other non-legacy access on the PHY.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm-phy-lib.c | 194 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |   6 ++
 include/linux/brcmphy.h       |  52 +++++++++
 3 files changed, 252 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 41c728fbcfb2..4c4ee72a2e52 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -4,12 +4,14 @@
  */
 
 #include "bcm-phy-lib.h"
+#include <linux/bitfield.h>
 #include <linux/brcmphy.h>
 #include <linux/export.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 
 #define MII_BCM_CHANNEL_WIDTH     0x2000
 #define BCM_CL45VEN_EEE_ADV       0x3c
@@ -581,6 +583,198 @@ int bcm_phy_enable_jumbo(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
 
+int __bcm_phy_enable_rdb_access(struct phy_device *phydev)
+{
+	return __bcm_phy_write_exp(phydev, BCM54XX_EXP_REG7E, 0);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_enable_rdb_access);
+
+int __bcm_phy_enable_legacy_access(struct phy_device *phydev)
+{
+	return __bcm_phy_write_rdb(phydev, BCM54XX_RDB_REG0087,
+				   BCM54XX_ACCESS_MODE_LEGACY_EN);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_enable_legacy_access);
+
+static int _bcm_phy_cable_test_start(struct phy_device *phydev, bool is_rdb)
+{
+	u16 mask, set;
+	int ret;
+
+	/* Auto-negotiation must be enabled for cable diagnostics to work, but
+	 * don't advertise any capabilities.
+	 */
+	phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
+	phy_write(phydev, MII_ADVERTISE, ADVERTISE_CSMA);
+	phy_write(phydev, MII_CTRL1000, 0);
+
+	phy_lock_mdio_bus(phydev);
+	if (is_rdb) {
+		ret = __bcm_phy_enable_legacy_access(phydev);
+		if (ret)
+			goto out;
+	}
+
+	mask = BCM54XX_ECD_CTRL_CROSS_SHORT_DIS | BCM54XX_ECD_CTRL_UNIT_MASK;
+	set = BCM54XX_ECD_CTRL_RUN | BCM54XX_ECD_CTRL_BREAK_LINK |
+	      FIELD_PREP(BCM54XX_ECD_CTRL_UNIT_MASK,
+			 BCM54XX_ECD_CTRL_UNIT_CM);
+
+	ret = __bcm_phy_modify_exp(phydev, BCM54XX_EXP_ECD_CTRL, mask, set);
+
+out:
+	/* re-enable the RDB access even if there was an error */
+	if (is_rdb)
+		ret = __bcm_phy_enable_rdb_access(phydev) ? : ret;
+
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+
+static int bcm_phy_cable_test_report_trans(int result)
+{
+	switch (result) {
+	case BCM54XX_ECD_FAULT_TYPE_OK:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case BCM54XX_ECD_FAULT_TYPE_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case BCM54XX_ECD_FAULT_TYPE_SAME_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case BCM54XX_ECD_FAULT_TYPE_CROSS_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
+	case BCM54XX_ECD_FAULT_TYPE_INVALID:
+	case BCM54XX_ECD_FAULT_TYPE_BUSY:
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static bool bcm_phy_distance_valid(int result)
+{
+	switch (result) {
+	case BCM54XX_ECD_FAULT_TYPE_OPEN:
+	case BCM54XX_ECD_FAULT_TYPE_SAME_SHORT:
+	case BCM54XX_ECD_FAULT_TYPE_CROSS_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int bcm_phy_report_length(struct phy_device *phydev, int result,
+				 int pair)
+{
+	int val;
+
+	val = __bcm_phy_read_exp(phydev,
+				 BCM54XX_EXP_ECD_PAIR_A_LENGTH_RESULTS + pair);
+	if (val < 0)
+		return val;
+
+	if (val == BCM54XX_ECD_LENGTH_RESULTS_INVALID)
+		return 0;
+
+	/* intra-pair shorts report twice the length */
+	if (result == BCM54XX_ECD_FAULT_TYPE_CROSS_SHORT)
+		val >>= 1;
+
+	ethnl_cable_test_fault_length(phydev, pair, val);
+
+	return 0;
+}
+
+static int _bcm_phy_cable_test_get_status(struct phy_device *phydev,
+					  bool *finished, bool is_rdb)
+{
+	int pair_a, pair_b, pair_c, pair_d, ret;
+
+	*finished = false;
+
+	phy_lock_mdio_bus(phydev);
+
+	if (is_rdb) {
+		ret = __bcm_phy_enable_legacy_access(phydev);
+		if (ret)
+			goto out;
+	}
+
+	ret = __bcm_phy_read_exp(phydev, BCM54XX_EXP_ECD_CTRL);
+	if (ret < 0)
+		goto out;
+
+	if (ret & BCM54XX_ECD_CTRL_IN_PROGRESS) {
+		ret = 0;
+		goto out;
+	}
+
+	ret = __bcm_phy_read_exp(phydev, BCM54XX_EXP_ECD_FAULT_TYPE);
+	if (ret < 0)
+		goto out;
+
+	pair_a = FIELD_GET(BCM54XX_ECD_FAULT_TYPE_PAIR_A_MASK, ret);
+	pair_b = FIELD_GET(BCM54XX_ECD_FAULT_TYPE_PAIR_B_MASK, ret);
+	pair_c = FIELD_GET(BCM54XX_ECD_FAULT_TYPE_PAIR_C_MASK, ret);
+	pair_d = FIELD_GET(BCM54XX_ECD_FAULT_TYPE_PAIR_D_MASK, ret);
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				bcm_phy_cable_test_report_trans(pair_a));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_B,
+				bcm_phy_cable_test_report_trans(pair_b));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_C,
+				bcm_phy_cable_test_report_trans(pair_c));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_D,
+				bcm_phy_cable_test_report_trans(pair_d));
+
+	if (bcm_phy_distance_valid(pair_a))
+		bcm_phy_report_length(phydev, pair_a, 0);
+	if (bcm_phy_distance_valid(pair_b))
+		bcm_phy_report_length(phydev, pair_b, 1);
+	if (bcm_phy_distance_valid(pair_c))
+		bcm_phy_report_length(phydev, pair_c, 2);
+	if (bcm_phy_distance_valid(pair_d))
+		bcm_phy_report_length(phydev, pair_d, 3);
+
+	ret = 0;
+	*finished = true;
+out:
+	/* re-enable the RDB access even if there was an error */
+	if (is_rdb)
+		ret = __bcm_phy_enable_rdb_access(phydev) ? : ret;
+
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+
+int bcm_phy_cable_test_start(struct phy_device *phydev)
+{
+	return _bcm_phy_cable_test_start(phydev, false);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_cable_test_start);
+
+int bcm_phy_cable_test_get_status(struct phy_device *phydev, bool *finished)
+{
+	return _bcm_phy_cable_test_get_status(phydev, finished, false);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status);
+
+/* We assume that all PHYs which support RDB access can be switched to legacy
+ * mode. If, in the future, this is not true anymore, we have to re-implement
+ * this with RDB access.
+ */
+int bcm_phy_cable_test_start_rdb(struct phy_device *phydev)
+{
+	return _bcm_phy_cable_test_start(phydev, true);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_cable_test_start_rdb);
+
+int bcm_phy_cable_test_get_status_rdb(struct phy_device *phydev,
+				      bool *finished)
+{
+	return _bcm_phy_cable_test_get_status(phydev, finished, true);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status_rdb);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index b35d880220b9..237a8503c9b4 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -80,4 +80,10 @@ void bcm_phy_r_rc_cal_reset(struct phy_device *phydev);
 int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev);
 int bcm_phy_enable_jumbo(struct phy_device *phydev);
 
+int bcm_phy_cable_test_get_status_rdb(struct phy_device *phydev,
+				      bool *finished);
+int bcm_phy_cable_test_start_rdb(struct phy_device *phydev);
+int bcm_phy_cable_test_start(struct phy_device *phydev);
+int bcm_phy_cable_test_get_status(struct phy_device *phydev, bool *finished);
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 58d0150acc3e..d41624db6de2 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -119,6 +119,11 @@
 #define MII_BCM54XX_RDB_ADDR	0x1e
 #define MII_BCM54XX_RDB_DATA	0x1f
 
+/* legacy access control via rdb/expansion register */
+#define BCM54XX_RDB_REG0087		0x0087
+#define BCM54XX_EXP_REG7E		(MII_BCM54XX_EXP_SEL_ER + 0x7E)
+#define BCM54XX_ACCESS_MODE_LEGACY_EN	BIT(15)
+
 /*
  * AUXILIARY CONTROL SHADOW ACCESS REGISTERS.  (PHY REG 0x18)
  */
@@ -294,4 +299,51 @@
 #define MII_BRCM_CORE_EXPB0	0xB0
 #define MII_BRCM_CORE_EXPB1	0xB1
 
+/* Enhanced Cable Diagnostics */
+#define BCM54XX_RDB_ECD_CTRL			0x2a0
+#define BCM54XX_EXP_ECD_CTRL			(MII_BCM54XX_EXP_SEL_ER + 0xc0)
+
+#define BCM54XX_ECD_CTRL_CABLE_TYPE_CAT3	1	/* CAT3 or worse */
+#define BCM54XX_ECD_CTRL_CABLE_TYPE_CAT5	0	/* CAT5 or better */
+#define BCM54XX_ECD_CTRL_CABLE_TYPE_MASK	BIT(0)	/* cable type */
+#define BCM54XX_ECD_CTRL_INVALID		BIT(3)	/* invalid result */
+#define BCM54XX_ECD_CTRL_UNIT_CM		0	/* centimeters */
+#define BCM54XX_ECD_CTRL_UNIT_M			1	/* meters */
+#define BCM54XX_ECD_CTRL_UNIT_MASK		BIT(10)	/* cable length unit */
+#define BCM54XX_ECD_CTRL_IN_PROGRESS		BIT(11)	/* test in progress */
+#define BCM54XX_ECD_CTRL_BREAK_LINK		BIT(12)	/* unconnect link
+							 * during test
+							 */
+#define BCM54XX_ECD_CTRL_CROSS_SHORT_DIS	BIT(13)	/* disable inter-pair
+							 * short check
+							 */
+#define BCM54XX_ECD_CTRL_RUN			BIT(15)	/* run immediate */
+
+#define BCM54XX_RDB_ECD_FAULT_TYPE		0x2a1
+#define BCM54XX_EXP_ECD_FAULT_TYPE		(MII_BCM54XX_EXP_SEL_ER + 0xc1)
+#define BCM54XX_ECD_FAULT_TYPE_INVALID		0x0
+#define BCM54XX_ECD_FAULT_TYPE_OK		0x1
+#define BCM54XX_ECD_FAULT_TYPE_OPEN		0x2
+#define BCM54XX_ECD_FAULT_TYPE_SAME_SHORT	0x3 /* short same pair */
+#define BCM54XX_ECD_FAULT_TYPE_CROSS_SHORT	0x4 /* short different pairs */
+#define BCM54XX_ECD_FAULT_TYPE_BUSY		0x9
+#define BCM54XX_ECD_FAULT_TYPE_PAIR_D_MASK	GENMASK(3, 0)
+#define BCM54XX_ECD_FAULT_TYPE_PAIR_C_MASK	GENMASK(7, 4)
+#define BCM54XX_ECD_FAULT_TYPE_PAIR_B_MASK	GENMASK(11, 8)
+#define BCM54XX_ECD_FAULT_TYPE_PAIR_A_MASK	GENMASK(15, 12)
+#define BCM54XX_ECD_PAIR_A_LENGTH_RESULTS	0x2a2
+#define BCM54XX_ECD_PAIR_B_LENGTH_RESULTS	0x2a3
+#define BCM54XX_ECD_PAIR_C_LENGTH_RESULTS	0x2a4
+#define BCM54XX_ECD_PAIR_D_LENGTH_RESULTS	0x2a5
+
+#define BCM54XX_RDB_ECD_PAIR_A_LENGTH_RESULTS	0x2a2
+#define BCM54XX_EXP_ECD_PAIR_A_LENGTH_RESULTS	(MII_BCM54XX_EXP_SEL_ER + 0xc2)
+#define BCM54XX_RDB_ECD_PAIR_B_LENGTH_RESULTS	0x2a3
+#define BCM54XX_EXP_ECD_PAIR_B_LENGTH_RESULTS	(MII_BCM54XX_EXP_SEL_ER + 0xc3)
+#define BCM54XX_RDB_ECD_PAIR_C_LENGTH_RESULTS	0x2a4
+#define BCM54XX_EXP_ECD_PAIR_C_LENGTH_RESULTS	(MII_BCM54XX_EXP_SEL_ER + 0xc4)
+#define BCM54XX_RDB_ECD_PAIR_D_LENGTH_RESULTS	0x2a5
+#define BCM54XX_EXP_ECD_PAIR_D_LENGTH_RESULTS	(MII_BCM54XX_EXP_SEL_ER + 0xc5)
+#define BCM54XX_ECD_LENGTH_RESULTS_INVALID	0xffff
+
 #endif /* _LINUX_BRCMPHY_H */
-- 
2.20.1

