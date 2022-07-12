Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7847E571AF7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiGLNQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiGLNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:16:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4474DF4;
        Tue, 12 Jul 2022 06:16:03 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D7A9422249;
        Tue, 12 Jul 2022 15:16:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657631762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1eHMRpW+oTXNDNSJlNq7iOEgDl3HFbuG1KOFvnVIGo=;
        b=nSb7c/hAb4Jei3tlILPG9XmJS7GHJpQWz15BuzoCXh2xU32SClrq/W/pixBZYI7Ik7bNvc
        Q+IA86j0CdV/ilBmcJH13Wj73ebvN+Zd0EmY/NXIjtAtO1QbblP/JrPV9tRd33So7lroLt
        sZfzxp5KyDiAfVThgyBP0hrVOyuMMtw=
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/4] net: phy: mxl-gpy: cache PHY firmware version
Date:   Tue, 12 Jul 2022 15:15:52 +0200
Message-Id: <20220712131554.2737792-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712131554.2737792-1-michael@walle.cc>
References: <20220712131554.2737792-1-michael@walle.cc>
MIME-Version: 1.0
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

Cache the firmware version during probe. There is no need to read the
firmware version on every autonegotiation.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 9728ef93fc0b..b6303089d425 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -77,6 +77,11 @@
 #define VPSPEC2_WOL_AD45	0x0E0A
 #define WOL_EN			BIT(0)
 
+struct gpy_priv {
+	u8 fw_type;
+	u8 fw_minor;
+};
+
 static const struct {
 	int type;
 	int minor;
@@ -198,6 +203,8 @@ static int gpy_config_init(struct phy_device *phydev)
 
 static int gpy_probe(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
+	struct gpy_priv *priv;
 	int fw_version;
 	int ret;
 
@@ -207,15 +214,22 @@ static int gpy_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	/* Show GPY PHY FW version in dmesg */
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	phydev->priv = priv;
+
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
 		return fw_version;
+	priv->fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_version);
+	priv->fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_version);
 
 	ret = gpy_hwmon_register(phydev);
 	if (ret)
 		return ret;
 
+	/* Show GPY PHY FW version in dmesg */
 	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
 		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
 
@@ -224,20 +238,13 @@ static int gpy_probe(struct phy_device *phydev)
 
 static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
 {
-	int fw_ver, fw_type, fw_minor;
+	struct gpy_priv *priv = phydev->priv;
 	size_t i;
 
-	fw_ver = phy_read(phydev, PHY_FWV);
-	if (fw_ver < 0)
-		return true;
-
-	fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_ver);
-	fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_ver);
-
 	for (i = 0; i < ARRAY_SIZE(ver_need_sgmii_reaneg); i++) {
-		if (fw_type != ver_need_sgmii_reaneg[i].type)
+		if (priv->fw_type != ver_need_sgmii_reaneg[i].type)
 			continue;
-		if (fw_minor < ver_need_sgmii_reaneg[i].minor)
+		if (priv->fw_minor < ver_need_sgmii_reaneg[i].minor)
 			return true;
 		break;
 	}
@@ -605,18 +612,12 @@ static int gpy_loopback(struct phy_device *phydev, bool enable)
 
 static int gpy115_loopback(struct phy_device *phydev, bool enable)
 {
-	int ret;
-	int fw_minor;
+	struct gpy_priv *priv = phydev->priv;
 
 	if (enable)
 		return gpy_loopback(phydev, enable);
 
-	ret = phy_read(phydev, PHY_FWV);
-	if (ret < 0)
-		return ret;
-
-	fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, ret);
-	if (fw_minor > 0x0076)
+	if (priv->fw_minor > 0x76)
 		return gpy_loopback(phydev, 0);
 
 	return genphy_soft_reset(phydev);
-- 
2.30.2

