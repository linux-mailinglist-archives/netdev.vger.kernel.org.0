Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53007427439
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243855AbhJHXgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243802AbhJHXgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 19:36:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAE8C061755;
        Fri,  8 Oct 2021 16:34:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a25so26065460edx.8;
        Fri, 08 Oct 2021 16:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TIVh7aXnS7WMSRSGvwGkaRzozu+hXv97EwwaZX+jHdM=;
        b=Ch98HwOMLrYmbzezG949Y4CDsQ2qYld4USSd5PK7JS0pdJvNcC4DO6jXPpmhELEHNB
         DxuQdNEd8qsHfn9xWkmoe/FxOck6NYlLWInMY2LaTvN/UfG4ohbll7YWM/mSP8snWS53
         NeL/Fhu0bKxtJbri4IbXTYjK43DDQC0Lq8YFJ7rP/oBW0Pk4K7U9WWSKYxCU3cxesK0o
         0MusXMy5MB9/btf6I4RWMwhrcn5/9kqvNNGiBX1hSFmdMTmLN/OEakGmHa3SdYdOkfvU
         E1MDrUhXZX/blE6Q/qov2cd7pmGKCyAJ3mkY5bCG0OKMWqKR3k85wuW9Uh9d+LrYa2AI
         fQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TIVh7aXnS7WMSRSGvwGkaRzozu+hXv97EwwaZX+jHdM=;
        b=WLn/kF6lpEGR9xjTNegfDQbYnNPgu7iFwFeezGmex+Vr7pJNaUA7Dgq0fI97zwaCDh
         aOr/TsdijN9eGxRHR5HOxxS3BCzY6sqSC00M81ljyDrPzxptgIP/QA+Nz6OQ0x3324kA
         jA+3YbV+A0xrb+qxYhCgPwTiJ2DfY7+AJoZz1Uoz58dlh6d99XNcqOWj5gcB7wHSDvLK
         odYHS+QzLJ1Id7FtbdVngLfNWPL2ayWDCSK1dQPbH8IG39NBYFO6Dm6dWeQkqvSYflSl
         VJEaBZBn/fMAKHmK0cH8oomlDSLh4GyHxbYdnBqF+fVjHBT0NxsDiPirlAvRwC23cXgi
         RdTA==
X-Gm-Message-State: AOAM531cNw5qnrOkOb7NwRpHeoQHB46nYAWqPLzOMBpobcx5sXLG/qrU
        PSYZm+pUuO0zLGGX+8Fiqdo=
X-Google-Smtp-Source: ABdhPJwMjg4na9kQU1XPkwCaOyIRjU+iJznN/bL3dBuNJeL4DntizkcRjtgi9wKmR0NaIzcd4IVqlA==
X-Received: by 2002:a50:c006:: with SMTP id r6mr19406022edb.289.1633736083798;
        Fri, 08 Oct 2021 16:34:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b2sm300211edv.73.2021.10.08.16.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 16:34:43 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net PATCH 2/2] drivers: net: phy: at803x: add DAC amplitude fix for 8327 phy
Date:   Sat,  9 Oct 2021 01:34:26 +0200
Message-Id: <20211008233426.1088-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008233426.1088-1-ansuelsmth@gmail.com>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
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

Fixes: b4df02b562f4 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c6c87b82c95c..5208ea8fdd69 100644
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

