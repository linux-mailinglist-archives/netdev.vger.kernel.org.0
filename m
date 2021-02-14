Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0731AE98
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhBNBFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:05:04 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52491 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:05:03 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B50923E64;
        Sun, 14 Feb 2021 02:04:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613264660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cm9+hyu/jdXvok6mnIkC3u4yV4aK+thZmQDCxEXkH7Y=;
        b=Q5ajWrRlxKqzJr+UaKSz7LFZCIPI0wW6rxF3MIVXliDlldbJ8hrQBFLDTTp1t2kqcKhAjo
        5Rf2FRFqSIsnpScb1XH2jpT6m+S8wQ0SnBQ6xRGybPk+7j9ayMihNxvdHKfXlNDHUfxjud
        izfm3LLG3D5014FXlna33/b27uIS/3E=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/2] net: phy: at803x: add pages support to AR8031/33
Date:   Sun, 14 Feb 2021 02:04:04 +0100
Message-Id: <20210214010405.32019-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210214010405.32019-1-michael@walle.cc>
References: <20210214010405.32019-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AR8031 has two register sets: Copper and Fiber. The fiber page is
used in case of 100Base-FX and 1000Base-X. But more importantly it is
also used for the SGMII link. Add support to switch between these two.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d67bddc111e3..a3aa10f14638 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -144,6 +144,9 @@
 #define ATH8035_PHY_ID 0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
+#define AT803X_FIBER_PAGE 0
+#define AT803X_COPPER_PAGE 1
+
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
@@ -1143,6 +1146,36 @@ static int at803x_cable_test_start(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_read_page(struct phy_device *phydev)
+{
+	int val;
+
+	val = __phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+	if (val < 0)
+		return val;
+
+	return (val & AT803X_BT_BX_REG_SEL) ? AT803X_COPPER_PAGE : AT803X_FIBER_PAGE;
+}
+
+static int at803x_write_page(struct phy_device *phydev, int page)
+{
+	u16 sel;
+
+	switch (page) {
+	case AT803X_FIBER_PAGE:
+		sel = 0;
+		break;
+	case AT803X_COPPER_PAGE:
+		sel = AT803X_BT_BX_REG_SEL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return __phy_modify(phydev, AT803X_REG_CHIP_CONFIG,
+			    AT803X_BT_BX_REG_SEL, sel);
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1189,6 +1222,8 @@ static struct phy_driver at803x_driver[] = {
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
+	.read_page		= at803x_read_page,
+	.write_page		= at803x_write_page,
 	.config_init		= at803x_config_init,
 	.soft_reset		= genphy_soft_reset,
 	.set_wol		= at803x_set_wol,
-- 
2.20.1

