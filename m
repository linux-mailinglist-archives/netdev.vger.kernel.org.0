Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD15C390F8B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhEZEc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhEZEcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ACFC06175F
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:51 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Oz-Be; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002d9-PK; Wed, 26 May 2021 06:30:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v3 9/9] net: phy: micrel: ksz886x/ksz8081: add cabletest support
Date:   Wed, 26 May 2021 06:30:37 +0200
Message-Id: <20210526043037.9830-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210526043037.9830-1-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch support for cable test for the ksz886x switches and the
ksz8081 PHY.

The patch was tested on a KSZ8873RLL switch with following results:

- port 1:
  - provides invalid values, thus return -ENOTSUPP
    (Errata: DS80000830A: "LinkMD does not work on Port 1",
     http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf)

- port 2:
  - can detect distance
  - can detect open on each wire of pair A (wire 1 and 2)
  - can detect open only on one wire of pair B (only wire 3)
  - can detect short between wires of a pair (wires 1 + 2 or 3 + 6)
  - short between pairs is detected as open.
    For example short between wires 2 + 3 is detected as open.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

---

- added PHY_POLL_CABLE_TEST to make it work in interrupt mode
---
 drivers/net/dsa/microchip/ksz8795.c |  13 ++
 drivers/net/phy/micrel.c            | 180 ++++++++++++++++++++++++++++
 include/linux/micrel_phy.h          |   1 +
 3 files changed, 194 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ae5fe9c829da..1881adb19c85 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -970,6 +970,18 @@ static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
 		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
 }
 
+static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	/* Silicon Errata Sheet (DS80000830A):
+	 * Port 1 does not work with LinkMD Cable-Testing.
+	 * Port 1 does not respond to received PAUSE control frames.
+	 */
+	if (!port)
+		return MICREL_KSZ8_P1_ERRATA;
+
+	return 0;
+}
+
 static void ksz8_get_strings(struct dsa_switch *ds, int port,
 			     u32 stringset, uint8_t *buf)
 {
@@ -1507,6 +1519,7 @@ static void ksz8_validate(struct dsa_switch *ds, int port,
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.get_phy_flags		= ksz8_sw_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index b6ce7bd66738..6b744e68ce97 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
@@ -53,6 +54,18 @@
 #define	KSZPHY_INTCS_STATUS			(KSZPHY_INTCS_LINK_DOWN_STATUS |\
 						 KSZPHY_INTCS_LINK_UP_STATUS)
 
+/* LinkMD Control/Status */
+#define KSZ8081_LMD				0x1d
+#define KSZ8081_LMD_ENABLE_TEST			BIT(15)
+#define KSZ8081_LMD_STAT_NORMAL			0
+#define KSZ8081_LMD_STAT_OPEN			1
+#define KSZ8081_LMD_STAT_SHORT			2
+#define KSZ8081_LMD_STAT_FAIL			3
+#define KSZ8081_LMD_STAT_MASK			GENMASK(14, 13)
+/* Short cable (<10 meter) has been detected by LinkMD */
+#define KSZ8081_LMD_SHORT_INDICATOR		BIT(12)
+#define KSZ8081_LMD_DELTA_TIME_MASK		GENMASK(8, 0)
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -1386,6 +1399,167 @@ static int kszphy_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz886x_cable_test_start(struct phy_device *phydev)
+{
+	if (phydev->dev_flags & MICREL_KSZ8_P1_ERRATA)
+		return -ENOTSUPP;
+
+	/* If autoneg is enabled, we won't be able to test cross pair
+	 * short. In this case, the PHY will "detect" a link and
+	 * confuse the internal state machine - disable auto neg here.
+	 * If autoneg is disabled, we should set the speed to 10mbit.
+	 */
+	return phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE | BMCR_SPEED100);
+}
+
+static int ksz886x_cable_test_result_trans(u16 status)
+{
+	switch (FIELD_GET(KSZ8081_LMD_STAT_MASK, status)) {
+	case KSZ8081_LMD_STAT_NORMAL:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case KSZ8081_LMD_STAT_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case KSZ8081_LMD_STAT_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case KSZ8081_LMD_STAT_FAIL:
+		/* fall through */
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static bool ksz886x_cable_test_failed(u16 status)
+{
+	return FIELD_GET(KSZ8081_LMD_STAT_MASK, status) ==
+		KSZ8081_LMD_STAT_FAIL;
+}
+
+static bool ksz886x_cable_test_fault_length_valid(u16 status)
+{
+	switch (FIELD_GET(KSZ8081_LMD_STAT_MASK, status)) {
+	case KSZ8081_LMD_STAT_OPEN:
+		/* fall through */
+	case KSZ8081_LMD_STAT_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int ksz886x_cable_test_fault_length(u16 status)
+{
+	int dt;
+
+	/* According to the data sheet the distance to the fault is
+	 * DELTA_TIME * 0.4 meters.
+	 */
+	dt = FIELD_GET(KSZ8081_LMD_DELTA_TIME_MASK, status);
+
+	return (dt * 400) / 10;
+}
+
+static int ksz886x_cable_test_wait_for_completion(struct phy_device *phydev)
+{
+	int val, ret;
+
+	ret = phy_read_poll_timeout(phydev, KSZ8081_LMD, val,
+				    !(val & KSZ8081_LMD_ENABLE_TEST),
+				    30000, 100000, true);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)
+{
+	static const int ethtool_pair[] = {
+		ETHTOOL_A_CABLE_PAIR_A,
+		ETHTOOL_A_CABLE_PAIR_B,
+	};
+	int ret, val, mdix;
+
+	/* There is no way to choice the pair, like we do one ksz9031.
+	 * We can workaround this limitation by using the MDI-X functionality.
+	 */
+	if (pair == 0)
+		mdix = ETH_TP_MDI;
+	else
+		mdix = ETH_TP_MDI_X;
+
+	switch (phydev->phy_id & MICREL_PHY_ID_MASK) {
+	case PHY_ID_KSZ8081:
+		ret = ksz8081_config_mdix(phydev, mdix);
+		break;
+	case PHY_ID_KSZ886X:
+		ret = ksz886x_config_mdix(phydev, mdix);
+		break;
+	default:
+		ret = -ENODEV;
+	}
+
+	if (ret)
+		return ret;
+
+	/* Now we are ready to fire. This command will send a 100ns pulse
+	 * to the pair.
+	 */
+	ret = phy_write(phydev, KSZ8081_LMD, KSZ8081_LMD_ENABLE_TEST);
+	if (ret)
+		return ret;
+
+	ret = ksz886x_cable_test_wait_for_completion(phydev);
+	if (ret)
+		return ret;
+
+	val = phy_read(phydev, KSZ8081_LMD);
+	if (val < 0)
+		return val;
+
+	if (ksz886x_cable_test_failed(val))
+		return -EAGAIN;
+
+	ret = ethnl_cable_test_result(phydev, ethtool_pair[pair],
+				      ksz886x_cable_test_result_trans(val));
+	if (ret)
+		return ret;
+
+	if (!ksz886x_cable_test_fault_length_valid(val))
+		return 0;
+
+	return ethnl_cable_test_fault_length(phydev, ethtool_pair[pair],
+					     ksz886x_cable_test_fault_length(val));
+}
+
+static int ksz886x_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	unsigned long pair_mask = 0x3;
+	int retries = 20;
+	int pair, ret;
+
+	*finished = false;
+
+	/* Try harder if link partner is active */
+	while (pair_mask && retries--) {
+		for_each_set_bit(pair, &pair_mask, 4) {
+			ret = ksz886x_cable_test_one_pair(phydev, pair);
+			if (ret == -EAGAIN)
+				continue;
+			if (ret < 0)
+				return ret;
+			clear_bit(pair, &pair_mask);
+		}
+		/* If link partner is in autonegotiation mode it will send 2ms
+		 * of FLPs with at least 6ms of silence.
+		 * Add 2ms sleep to have better chances to hit this silence.
+		 */
+		if (pair_mask)
+			msleep(2);
+	}
+
+	*finished = true;
+
+	return 0;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1492,6 +1666,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_KSZ8081,
 	.name		= "Micrel KSZ8081 or KSZ8091",
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.flags		= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ksz8081_type,
 	.probe		= kszphy_probe,
@@ -1506,6 +1681,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
+	.cable_test_start	= ksz886x_cable_test_start,
+	.cable_test_get_status	= ksz886x_cable_test_get_status,
 }, {
 	.phy_id		= PHY_ID_KSZ8061,
 	.name		= "Micrel KSZ8061",
@@ -1594,11 +1771,14 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_POLL_CABLE_TEST,
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz886x_config_aneg,
 	.read_status	= ksz886x_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= ksz886x_resume,
+	.cable_test_start	= ksz886x_cable_test_start,
+	.cable_test_get_status	= ksz886x_cable_test_get_status,
 }, {
 	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 58370abd9f4f..3d43c60b49fa 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -39,6 +39,7 @@
 /* struct phy_device dev_flags definitions */
 #define MICREL_PHY_50MHZ_CLK	0x00000001
 #define MICREL_PHY_FXEN		0x00000002
+#define MICREL_KSZ8_P1_ERRATA	0x00000003
 
 #define MICREL_KSZ9021_EXTREG_CTRL	0xB
 #define MICREL_KSZ9021_EXTREG_DATA_WRITE	0xC
-- 
2.29.2

