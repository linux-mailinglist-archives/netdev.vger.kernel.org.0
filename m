Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E841CC4E7
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgEIWRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:17:40 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45619 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgEIWRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:17:39 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 186502330D;
        Sun, 10 May 2020 00:17:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589062656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CxUxFtBWa0UHkBOjbAguYdGxpG4+fVKLVEcHz/1a6LU=;
        b=mEkAdCagkI+FopQZBrvGiGn6NDNQ+jjIwXN9TV/0bBo3xbwqKo71x8ncDWOZXsdKvceypY
        4iINsD21UuuElHDPYGAHI6QewkgucK2xc2BuoiClXsbqxYDFEQGOqOAvOGFqcTDni5cpOm
        xMOj480yQ2RCHy+LPU5JQaCOc/bRAQc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: at803x: add cable diagnostics support
Date:   Sun, 10 May 2020 00:17:19 +0200
Message-Id: <20200509221719.24334-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
driver support is straightforward, so lets add it.

The PHY just do one pair at a time, so we have to start the test four
times. The cable_test_get_status() can block and therefore we can just
busy poll the test completion and continue with the next pair until we
are done.
The time delta counter seems to run at 125MHz which just gives us a
resolution of about 82.4cm per tick.

100m cable, A/B/C/D open:
  Cable test started for device eth0.
  Cable test completed for device eth0.
  Pair: Pair A, result: Open Circuit
  Pair: Pair A, fault length: 107.94m
  Pair: Pair B, result: Open Circuit
  Pair: Pair B, fault length: 104.64m
  Pair: Pair C, result: Open Circuit
  Pair: Pair C, fault length: 105.47m
  Pair: Pair D, result: Open Circuit
  Pair: Pair D, fault length: 107.94m

1m cable, A/B connected, C shorted, D open:
  Cable test started for device eth0.
  Cable test completed for device eth0.
  Pair: Pair A, result: OK
  Pair: Pair B, result: OK
  Pair: Pair C, result: Short within Pair
  Pair: Pair C, fault length: 0.82m
  Pair: Pair D, result: Open Circuit
  Pair: Pair D, fault length: 0.82m

Signed-off-by: Michael Walle <michael@walle.cc>
---

Please note that this patch depends on Andrew's latest cable testing
series:
https://lore.kernel.org/netdev/20200509162851.362346-1-andrew@lunn.ch/

changes since RFC:
 - reverse xmas tree
 - enable AN with no capabilites
 - retry measurements until all lanes succeeded.

 drivers/net/phy/at803x.c | 176 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 76eb5a77fc5c..822b3acf6be7 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/of_gpio.h>
 #include <linux/bitfield.h>
 #include <linux/gpio/consumer.h>
@@ -46,6 +47,16 @@
 #define AT803X_SMART_SPEED_ENABLE		BIT(5)
 #define AT803X_SMART_SPEED_RETRY_LIMIT_MASK	GENMASK(4, 2)
 #define AT803X_SMART_SPEED_BYPASS_TIMER		BIT(1)
+#define AT803X_CDT				0x16
+#define AT803X_CDT_MDI_PAIR_MASK		GENMASK(9, 8)
+#define AT803X_CDT_ENABLE_TEST			BIT(0)
+#define AT803X_CDT_STATUS			0x1c
+#define AT803X_CDT_STATUS_STAT_NORMAL		0
+#define AT803X_CDT_STATUS_STAT_SHORT		1
+#define AT803X_CDT_STATUS_STAT_OPEN		2
+#define AT803X_CDT_STATUS_STAT_FAIL		3
+#define AT803X_CDT_STATUS_STAT_MASK		GENMASK(9, 8)
+#define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
 #define AT803X_LED_CONTROL			0x18
 
 #define AT803X_DEVICE_ADDR			0x03
@@ -794,11 +805,171 @@ static int at803x_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int at803x_cable_test_result_trans(u16 status)
+{
+	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
+	case AT803X_CDT_STATUS_STAT_NORMAL:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case AT803X_CDT_STATUS_STAT_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case AT803X_CDT_STATUS_STAT_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case AT803X_CDT_STATUS_STAT_FAIL:
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static bool at803x_cdt_test_failed(u16 status)
+{
+	return FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status) ==
+		AT803X_CDT_STATUS_STAT_FAIL;
+}
+
+static bool at803x_cdt_fault_length_valid(u16 status)
+{
+	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
+	case AT803X_CDT_STATUS_STAT_OPEN:
+	case AT803X_CDT_STATUS_STAT_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int at803x_cdt_fault_length(u16 status)
+{
+	int dt;
+
+	/* According to the datasheet the distance to the fault is
+	 * DELTA_TIME * 0.824 meters.
+	 *
+	 * The author suspect the correct formula is:
+	 *
+	 *   fault_distance = DELTA_TIME * (c * VF) / 125MHz / 2
+	 *
+	 * where c is the speed of light, VF is the velocity factor of
+	 * the twisted pair cable, 125MHz the counter frequency and
+	 * we need to divide by 2 because the hardware will measure the
+	 * round trip time to the fault and back to the PHY.
+	 *
+	 * With a VF of 0.69 we get the factor 0.824 mentioned in the
+	 * datasheet.
+	 */
+	dt = FIELD_GET(AT803X_CDT_STATUS_DELTA_TIME_MASK, status);
+
+	return (dt * 824) / 10;
+}
+
+static int at803x_cdt_start(struct phy_device *phydev, int pair)
+{
+	u16 cdt;
+
+	cdt = FIELD_PREP(AT803X_CDT_MDI_PAIR_MASK, pair) |
+	      AT803X_CDT_ENABLE_TEST;
+
+	return phy_write(phydev, AT803X_CDT, cdt);
+}
+
+static int at803x_cdt_wait_for_completion(struct phy_device *phydev)
+{
+	int val, ret;
+
+	/* One test run takes about 25ms */
+	ret = phy_read_poll_timeout(phydev, AT803X_CDT, val,
+				    !(val & AT803X_CDT_ENABLE_TEST),
+				    30000, 100000, true);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int at803x_cable_test_one_pair(struct phy_device *phydev, int pair)
+{
+	static const int ethtool_pair[] = {
+		ETHTOOL_A_CABLE_PAIR_A,
+		ETHTOOL_A_CABLE_PAIR_B,
+		ETHTOOL_A_CABLE_PAIR_C,
+		ETHTOOL_A_CABLE_PAIR_D,
+	};
+	int ret, val;
+
+	ret = at803x_cdt_start(phydev, pair);
+	if (ret)
+		return ret;
+
+	ret = at803x_cdt_wait_for_completion(phydev);
+	if (ret)
+		return ret;
+
+	val = phy_read(phydev, AT803X_CDT_STATUS);
+	if (val < 0)
+		return val;
+
+	if (at803x_cdt_test_failed(val))
+		return 0;
+
+	ethnl_cable_test_result(phydev, ethtool_pair[pair],
+				at803x_cable_test_result_trans(val));
+
+	if (at803x_cdt_fault_length_valid(val))
+		ethnl_cable_test_fault_length(phydev, ethtool_pair[pair],
+					      at803x_cdt_fault_length(val));
+
+	return 1;
+}
+
+static int at803x_cable_test_get_status(struct phy_device *phydev,
+					bool *finished)
+{
+	unsigned long pair_mask = 0xf;
+	int retries = 20;
+	int pair, ret;
+
+	*finished = false;
+
+	/* According to the datasheet the CDT can be performed when
+	 * there is no link partner or when the link partner is
+	 * auto-negotiating. Starting the test will restart the AN
+	 * automatically. It seems that doing this repeatedly we will
+	 * get a slot where our link partner won't disturb our
+	 * measurement.
+	 */
+	while (pair_mask && retries--) {
+		for_each_set_bit(pair, &pair_mask, 4) {
+			ret = at803x_cable_test_one_pair(phydev, pair);
+			if (ret < 0)
+				return ret;
+			if (ret)
+				clear_bit(pair, &pair_mask);
+		}
+		if (pair_mask)
+			msleep(250);
+	}
+
+	*finished = true;
+
+	return 0;
+}
+
+static int at803x_cable_test_start(struct phy_device *phydev)
+{
+	/* Enable auto-negotiation, but advertise no capabilities, no link
+	 * will be established. A restart of the auto-negotiation is not
+	 * required, because the cable test will automatically break the link.
+	 */
+	phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
+	phy_write(phydev, MII_ADVERTISE, ADVERTISE_CSMA);
+	phy_write(phydev, MII_CTRL1000, 0);
+
+	/* we do all the (time consuming) work later */
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
 	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
 	.name			= "Qualcomm Atheros AR8035",
+	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
@@ -813,6 +984,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
@@ -833,6 +1006,7 @@ static struct phy_driver at803x_driver[] = {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
 	.name			= "Qualcomm Atheros AR8031/AR8033",
+	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
@@ -848,6 +1022,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= &at803x_config_intr,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8032 */
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
-- 
2.20.1

