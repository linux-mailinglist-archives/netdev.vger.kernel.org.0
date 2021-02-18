Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0062B31EF8D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhBRTR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBRSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 13:53:32 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7292DC06178B;
        Thu, 18 Feb 2021 10:52:52 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 599BC22248;
        Thu, 18 Feb 2021 19:52:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613674370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sMT/LV/JinhzmvJBsQDvTA5vWtOWa25y0vwf+f8M4PY=;
        b=ulzLiC+cTpa6z8cLH4E30lsycXFnl6BgOIcxF6hZ517Aa9kk592KhHf09CsojbR2bkv9S9
        ahkqWT2aWs+e0Yqb/ZGVM3ZEWujMjStoxOW89GkdEKj11vO2n0VBHBRX7DmxF5gN6SVd5t
        DpIk3QHjUu10Nfjcl4LzKGlewSM4nuc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 1/2] net: phy: at803x: add pages support to AR8031/33
Date:   Thu, 18 Feb 2021 19:52:39 +0100
Message-Id: <20210218185240.23615-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210218185240.23615-1-michael@walle.cc>
References: <20210218185240.23615-1-michael@walle.cc>
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
index c2aa4c92edde..194b414207d3 100644
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
 	.config_aneg		= at803x_config_aneg,
 	.soft_reset		= genphy_soft_reset,
-- 
2.20.1

