Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42F01BCE78
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgD1VPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbgD1VPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:15:12 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79EC03C1AC;
        Tue, 28 Apr 2020 14:15:12 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EA7BD22723;
        Tue, 28 Apr 2020 23:15:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588108510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DM6n7RNsmhoSxxAKEVPc3W8HQFHK3ap5WeCMwOzIOHE=;
        b=uadpuLjbZ9SEDmqwKOZR9UnzcOFbOKbYXqTGftF91Wi29dGETpN7qcV21N4AtkV8e7bH/n
        GWSZhBk+7Jo6TAocbb62b9L8wRSLFkOeQTGLLIrfeFyAUks+i1S2iLaRTuhRQ5JAvXMBc+
        8EhLbKFgjVf1fQLsja1uXXqHmmv6sNU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: at803x: add downshift support
Date:   Tue, 28 Apr 2020 23:15:02 +0200
Message-Id: <20200428211502.1290-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: EA7BD22723
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
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

The AR8031 and AR8035 support the link speed downshift. Add driver
support for it. One peculiarity of these PHYs is that it needs a
software reset after changing the setting, thus add the .soft_reset()
op and do a phy_init_hw() if necessary.

This was tested on a custom board with the AR8031.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 87 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 31b6edcc1fd1..f4fec5f644e9 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -43,6 +43,9 @@
 #define AT803X_INTR_STATUS			0x13
 
 #define AT803X_SMART_SPEED			0x14
+#define AT803X_SMART_SPEED_ENABLE		BIT(5)
+#define AT803X_SMART_SPEED_RETRY_LIMIT_MASK	GENMASK(4, 2)
+#define AT803X_SMART_SPEED_BYPASS_TIMER		BIT(1)
 #define AT803X_LED_CONTROL			0x18
 
 #define AT803X_DEVICE_ADDR			0x03
@@ -103,6 +106,10 @@
 #define AT803X_CLK_OUT_STRENGTH_HALF		1
 #define AT803X_CLK_OUT_STRENGTH_QUARTER		2
 
+#define AT803X_DEFAULT_DOWNSHIFT 5
+#define AT803X_MIN_DOWNSHIFT 2
+#define AT803X_MAX_DOWNSHIFT 9
+
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
@@ -713,6 +720,80 @@ static int at803x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
+{
+	int val;
+
+	val = phy_read(phydev, AT803X_SMART_SPEED);
+	if (val < 0)
+		return val;
+
+	if (val & AT803X_SMART_SPEED_ENABLE)
+		*d = FIELD_GET(AT803X_SMART_SPEED_RETRY_LIMIT_MASK, val) + 2;
+	else
+		*d = DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int at803x_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	u16 mask, set;
+	int ret;
+
+	switch (cnt) {
+	case DOWNSHIFT_DEV_DEFAULT_COUNT:
+		cnt = AT803X_DEFAULT_DOWNSHIFT;
+		fallthrough;
+	case AT803X_MIN_DOWNSHIFT ... AT803X_MAX_DOWNSHIFT:
+		set = AT803X_SMART_SPEED_ENABLE |
+		      AT803X_SMART_SPEED_BYPASS_TIMER |
+		      FIELD_PREP(AT803X_SMART_SPEED_RETRY_LIMIT_MASK, cnt - 2);
+		mask = AT803X_SMART_SPEED_RETRY_LIMIT_MASK;
+		break;
+	case DOWNSHIFT_DEV_DISABLE:
+		set = 0;
+		mask = AT803X_SMART_SPEED_ENABLE |
+		       AT803X_SMART_SPEED_BYPASS_TIMER;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = phy_modify_changed(phydev, AT803X_SMART_SPEED, mask, set);
+
+	/* After changing the smart speed settings, we need to perform a
+	 * software reset, use phy_init_hw() to make sure we set the
+	 * reapply any values which might got lost during software reset.
+	 */
+	if (ret == 1)
+		ret = phy_init_hw(phydev);
+
+	return ret;
+}
+
+static int at803x_get_tunable(struct phy_device *phydev,
+			      struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return at803x_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int at803x_set_tunable(struct phy_device *phydev,
+			      struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return at803x_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -722,6 +803,7 @@ static struct phy_driver at803x_driver[] = {
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
+	.soft_reset		= genphy_soft_reset,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
@@ -730,6 +812,8 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.get_tunable		= at803x_get_tunable,
+	.set_tunable		= at803x_set_tunable,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
@@ -754,6 +838,7 @@ static struct phy_driver at803x_driver[] = {
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
+	.soft_reset		= genphy_soft_reset,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
@@ -763,6 +848,8 @@ static struct phy_driver at803x_driver[] = {
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.get_tunable		= at803x_get_tunable,
+	.set_tunable		= at803x_set_tunable,
 }, {
 	/* Qualcomm Atheros AR8032 */
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
-- 
2.20.1

