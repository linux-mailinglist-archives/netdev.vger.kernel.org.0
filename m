Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE814249CB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbhJFWic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbhJFWiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:25 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E09C061760;
        Wed,  6 Oct 2021 15:36:32 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d8so15483094edx.9;
        Wed, 06 Oct 2021 15:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g41bRmxOJzxf37gujF+dBsiTfsshpCuEfZ9knc9cRxk=;
        b=fWiMxU135ypyIHCoKloamcCrc7xBoYEkCOh3A+m98rem6oZVeMyzh0v9jiRYdgpdK8
         G46e5b24NyvOsIi7BI5NWpzohxOt3jJooNA4uVIzdKMm8W0S7fmGTD794q8SDzovTyYM
         eocQwZg+gOhIodwyKpzgtBWZoDNhI+2vrub8C6UilW0Sd2b/U6ox5/Kr0CHC0Z9BpWvB
         2QDFjgBN0Emj0yK8Dp/fdIKwIccJmjGej1ENilD30L2WgM+ij35g4xrs/pOsv1OpWYAK
         a6tpPo0AGwpcDnQeFNh+1clpOnrq08IZMOaN1zBUGFKYyY3rkKSJnz4X+279kvuyZCZ4
         Ly5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g41bRmxOJzxf37gujF+dBsiTfsshpCuEfZ9knc9cRxk=;
        b=fXNGZ0CX7JoDYeLEbX86EMW33vZlS00TLu930jpUHrdg3CVBuzgaTYkORRvND3L4NV
         koDT5hVz5/EseDBDketdTo82hwBagTbXJD+I7AvZ/O1HV3N8j8yCQjijhUWqkgfg401a
         YSfTclO18EFJ9oIUjocnQJfGZodfmXSKj2bqEwEAz3d/97yuPI/LDcD7gVV+z3S2ncml
         O3jgVu41zWFM1aHBieCXnTjW92Jg86Y2tgCM0pyas/TFtKBH4cc1MGE2f9FrQSWvmMhj
         1EqiMoZvAWRciBFwEC8cpR7jxecrNqgVJloRz2vE7BABGf45GfEPK/4sF7sLZg9Gt0rZ
         ZoVg==
X-Gm-Message-State: AOAM532aciFwKtRBHhdd0dt/oaFfzChhE3ubovce3Z1M9QIBNJ0q+SxE
        OirmTaldhQYmQbT+uGhp09A=
X-Google-Smtp-Source: ABdhPJxx8sQ8zC+dTpr97zG/jYinMkxeaMUyk3vFYKHfjuz+JXxEbJNUvthFKsJ1UOkTg2OieHMrIQ==
X-Received: by 2002:a17:906:c246:: with SMTP id bl6mr1169200ejb.80.1633559790862;
        Wed, 06 Oct 2021 15:36:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH 02/13] drivers: net: phy: at803x: add DAC amplitude fix for 8327 phy
Date:   Thu,  7 Oct 2021 00:35:52 +0200
Message-Id: <20211006223603.18858-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8327 internal phy require DAC amplitude adjustement set to +6% with
100m speed. Also add additional define to report a change of the same
reg in QCA8337. (different scope it does set 1000m voltage)
Add link_change_notify function to set the proper amplitude adjustement
on PHY_RUNNING state and disable on any other state.

Fixes: c6bcec0d6928 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 9090f384c29e..71237a4e85a3 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -87,6 +87,8 @@
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
 
 #define AT803X_DEBUG_REG_0			0x00
+#define QCA8327_DEBUG_MANU_CTRL_EN		BIT(2)
+#define QCA8337_DEBUG_MANU_CTRL_EN		GENMASK(3, 2)
 #define AT803X_DEBUG_RX_CLK_DLY_EN		BIT(15)
 
 #define AT803X_DEBUG_REG_5			0x05
@@ -1314,9 +1316,37 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		break;
 	}
 
+	/* QCA8327 require DAC amplitude adjustment for 100m set to +6%.
+	 * Disable on init and enable only with 100m speed following
+	 * qca original source code.
+	 */
+	if (phydev->drv->phy_id == QCA8327_A_PHY_ID ||
+	    phydev->drv->phy_id == QCA8327_B_PHY_ID)
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
+
 	return 0;
 }
 
+static void qca83xx_link_change_notify(struct phy_device *phydev)
+{
+	/* QCA8337 doesn't require DAC Amplitude adjustement */
+	if (phydev->drv->phy_id == QCA8337_PHY_ID)
+		return;
+
+	/* Set DAC Amplitude adjustment to +6% for 100m on link running */
+	if (phydev->state == PHY_RUNNING) {
+		if (phydev->speed == SPEED_100)
+			at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+					      QCA8327_DEBUG_MANU_CTRL_EN,
+					      QCA8327_DEBUG_MANU_CTRL_EN);
+	} else {
+		/* Reset DAC Amplitude adjustment */
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
+	}
+}
+
 static int qca83xx_resume(struct phy_device *phydev)
 {
 	int ret, val;
@@ -1471,6 +1501,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8337 internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
@@ -1486,6 +1517,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8327-A internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
@@ -1501,6 +1533,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8327-B internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
-- 
2.32.0

