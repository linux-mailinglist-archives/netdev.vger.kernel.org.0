Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C56A1C2E79
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgECSPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 14:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728723AbgECSPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 14:15:36 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D729C061A0E;
        Sun,  3 May 2020 11:15:34 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A39A122FA7;
        Sun,  3 May 2020 20:15:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588529729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pe1oZ0gJvMeKHYh7RVOTyyKCz9hHsy+cLGRHdjIuQg4=;
        b=pKl4XfVvWsf1WDYabmKGrWH9o1/SzSbnm190Y1rPcbBQLmaffP0SRjPQPKxh6RziK6hCVA
        0bcXfTTsdeky09Y8wSrwy8Di9uoxN7aOmF9wVzcGLYI20FF3oU107LDBoGKCyegSR1XFt9
        teh7MjvHfhXvZeRCPZKEqlQ6zPNJqoo=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [RFC net-next] net: phy: at803x: add cable diagnostics support
Date:   Sun,  3 May 2020 20:15:17 +0200
Message-Id: <20200503181517.4538-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: A39A122FA7
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.860];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
driver support is straightforward, so lets add it.

The PHY just do one pair at a time, so we have to start the test four
times. The cable_test_get_status() can block and therefore we can just
busy polling the test completion and continue with the next pair until
we are done.
The time delta counter seems to run with 125MHz which just gives us a
resolution of about 82.4cm per tick.

This was tested with a 100m ethernet cable, a 1m cable and a broken
1m cable where pair 3 was shorted and pair 4 were open. Leaving the
100m cable unconnected resulted in a measured fault distance of about
114m. For the short cable the result the measured distance is either
82cm or 1.64m.

If the cable is connected to an active peer, the results might be
inconclusive if there are broken cables. I guess this is because
the remote PHY will disturb the measurement. Using an intact ethernet
cable the restart of the auto negotiation seem to cause the remote PHY
to stop sending distrubance signals.

Signed-off-by: Michael Walle <michael@walle.cc>
---
This is an RFC because the patch requires Andrew's cable test support:
https://lore.kernel.org/netdev/20200425180621.1140452-1-andrew@lunn.ch/

 drivers/net/phy/at803x.c | 167 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 76eb5a77fc5c..978f1b2fb931 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -18,6 +18,8 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
+#include <linux/ethtool_netlink.h>
+#include <uapi/linux/ethtool_netlink.h>
 #include <dt-bindings/net/qca-ar803x.h>
 
 #define AT803X_SPECIFIC_STATUS			0x11
@@ -46,6 +48,16 @@
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
@@ -110,6 +122,8 @@
 #define AT803X_MIN_DOWNSHIFT 2
 #define AT803X_MAX_DOWNSHIFT 9
 
+#define AT803X_CDT_DELAY_MS 1500
+
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
@@ -129,6 +143,7 @@ struct at803x_priv {
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
+	unsigned long cdt_start;
 };
 
 struct at803x_context {
@@ -794,11 +809,158 @@ static int at803x_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int at803x_cdt_test_result(u16 status)
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
+static int at803x_cable_test_get_status(struct phy_device *phydev,
+					bool *finished)
+{
+	struct at803x_priv *priv = phydev->priv;
+	static const int ethtool_pair[] = {
+		ETHTOOL_A_CABLE_PAIR_0, ETHTOOL_A_CABLE_PAIR_1,
+		ETHTOOL_A_CABLE_PAIR_2, ETHTOOL_A_CABLE_PAIR_3};
+	int pair, val, ret;
+	unsigned int delay_ms;
+
+	*finished = false;
+
+	if (priv->cdt_start) {
+		delay_ms = AT803X_CDT_DELAY_MS;
+		delay_ms -= jiffies_delta_to_msecs(jiffies - priv->cdt_start);
+		if (delay_ms > 0)
+			msleep(delay_ms);
+	}
+
+	for (pair = 0; pair < 4; pair++) {
+		ret = at803x_cdt_start(phydev, pair);
+		if (ret)
+			return ret;
+
+		ret = at803x_cdt_wait_for_completion(phydev);
+		if (ret)
+			return ret;
+
+		val = phy_read(phydev, AT803X_CDT_STATUS);
+		if (val < 0)
+			return val;
+
+		ethnl_cable_test_result(phydev, ethtool_pair[pair],
+					at803x_cdt_test_result(val));
+
+		if (at803x_cdt_fault_length_valid(val))
+			continue;
+
+		ethnl_cable_test_fault_length(phydev, ethtool_pair[pair],
+					      at803x_cdt_fault_length(val));
+	}
+
+	*finished = true;
+
+	return 0;
+}
+
+static int at803x_cable_test_start(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	int bmsr, ret;
+
+	/* According to the datasheet the CDT can be performed when
+	 * there is no link partner or when the link partner is
+	 * auto-negotiating. Thus restart the AN before starting the
+	 * test. Manual tests have shown, that the we have to wait
+	 * between 1s and 3s after restarting the AN to have reliable
+	 * results.
+	 */
+	bmsr = phy_read(phydev, MII_BMSR);
+	if (bmsr < 0)
+		return bmsr;
+
+	if (bmsr & BMSR_LSTATUS) {
+		ret = genphy_restart_aneg(phydev);
+		if (ret)
+			return ret;
+		priv->cdt_start = jiffies;
+	} else {
+		priv->cdt_start = 0;
+	}
+
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
@@ -813,6 +975,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
+	.cable_test_start	= at803x_cable_test_start,
+	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
@@ -833,6 +997,7 @@ static struct phy_driver at803x_driver[] = {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
 	.name			= "Qualcomm Atheros AR8031/AR8033",
+	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
@@ -848,6 +1013,8 @@ static struct phy_driver at803x_driver[] = {
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

