Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8B427437
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243815AbhJHXgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243777AbhJHXgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 19:36:40 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1310C061570;
        Fri,  8 Oct 2021 16:34:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p13so42573334edw.0;
        Fri, 08 Oct 2021 16:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbqqoyYUIZZYbznL3kKosmLxfC3pf231vxrIrzT+TdU=;
        b=N6juvDIt1jwZL+1At7QVhifWJofDBtVu9O1zB0NR/EG1MMmZo8EzIcay+pIB/ukUaB
         4pza5E8/Mygmf7FtRQc6HwvdffkSbUuveoVlzX3Az7YiICU21HZnDKRr9A96xCycVNWn
         I9gbgNevDDzh+BQxGP57DexSzxIOaCmuoAJdGT0iv5UIgkPS5V5CwwxaUOahFiuva+lZ
         JaadQpSSNilDuFa3rYe7jzEzko/DK3BDE3ZtbC/RblLt+wXigkqTeJiuk3M4jjb5I3F5
         5G/xzb/vj9xST9lVogOmPnhzBg7x2Yijf3ZirWi/bPwhEUOQOtUN9U+xHZlDrCDsF1mu
         C5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbqqoyYUIZZYbznL3kKosmLxfC3pf231vxrIrzT+TdU=;
        b=u2HoYZySMddKJJXQVjaI2swVVZ145hZb0un7F9yD9GV6D6VPDk6H8IUt46G+3NaJvc
         I0l1RGc2Llq4x3gVAd816HIFtpapHZVeAX74RnhxqeIf4fhULmJ7shu0lItERrfpRv/J
         ccMy2Ui0wFaaDq0b4ZNjQjmLlk2mCVCM5d5v2bx4zoqWom9gVf88YSzcHjOHk+z+VbR5
         fa45ihNV6L1Cx6URNS+AcK9oK/CCGDwOJzKgI/zLntkiIs0ktuxzdRo15wBWrz+WufTY
         AoEwqeSCPJ0kEdhWKqG7M5qYWWvQBZ7qlDgSdc66mWfLQ+xONtKyf9sdEZol4l9Dj3Gc
         l2pQ==
X-Gm-Message-State: AOAM5325IGg7U6PFTwx0Vsiwz6RuK01w4LaZHKeYfXehKFyuMQYQKvK3
        ATcVyfCRqObVz2UqGW5GQPw=
X-Google-Smtp-Source: ABdhPJwBGDFoRBplaNNL0bDGBfrzAAVZdu8hhunyEBJU+r8aI/SZXNp/+tWHHLxcaEFnA6cRVhWNdA==
X-Received: by 2002:a17:906:1fc1:: with SMTP id e1mr7723208ejt.515.1633736083011;
        Fri, 08 Oct 2021 16:34:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b2sm300211edv.73.2021.10.08.16.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 16:34:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for QCA8327 phy
Date:   Sat,  9 Oct 2021 01:34:25 +0200
Message-Id: <20211008233426.1088-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation phy resume triggers phy reset and restart
auto-negotiation. Add a dedicated function to wait reset to finish as
it was notice a regression where port sometime are not reliable after a
suspend/resume session. The reset wait logic is copied from phy_poll_reset.
Add dedicated suspend function to use genphy_suspend only with QCA8337
phy and set only additional debug settings for QCA8327. With more test
it was reported that QCA8327 doesn't proprely support this mode and
using this cause the unreliability of the switch ports, especially the
malfunction of the port0.

Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 69 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3feee4d59030..c6c87b82c95c 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -92,9 +92,14 @@
 #define AT803X_DEBUG_REG_5			0x05
 #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
 
+#define AT803X_DEBUG_REG_HIB_CTRL		0x0b
+#define   AT803X_DEBUG_HIB_CTRL_SEL_RST_80U	BIT(10)
+#define   AT803X_DEBUG_HIB_CTRL_EN_ANY_CHANGE	BIT(13)
+
 #define AT803X_DEBUG_REG_3C			0x3C
 
 #define AT803X_DEBUG_REG_3D			0x3D
+#define   AT803X_DEBUG_GATE_CLK_IN1000		BIT(6)
 
 #define AT803X_DEBUG_REG_1F			0x1F
 #define AT803X_DEBUG_PLL_ON			BIT(2)
@@ -1312,6 +1317,58 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca83xx_resume(struct phy_device *phydev)
+{
+	int ret, val;
+
+	/* Skip reset if not suspended */
+	if (!phydev->suspended)
+		return 0;
+
+	/* Reinit the port, reset values set by suspend */
+	qca83xx_config_init(phydev);
+
+	/* Reset the port on port resume */
+	phy_set_bits(phydev, MII_BMCR, BMCR_RESET | BMCR_ANENABLE);
+
+	/* On resume from suspend the switch execute a reset and
+	 * restart auto-negotiation. Wait for reset to complete.
+	 */
+	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
+				    50000, 600000, true);
+	if (ret)
+		return ret;
+
+	msleep(1);
+
+	return 0;
+}
+
+static int qca83xx_suspend(struct phy_device *phydev)
+{
+	u16 mask = 0;
+
+	/* Only QCA8337 support actual suspend.
+	 * QCA8327 cause port unreliability when phy suspend
+	 * is set.
+	 */
+	if (phydev->drv->phy_id == QCA8337_PHY_ID) {
+		genphy_suspend(phydev);
+	} else {
+		mask |= ~(BMCR_SPEED1000 | BMCR_FULLDPLX);
+		phy_modify(phydev, MII_BMCR, mask, 0);
+	}
+
+	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_3D,
+			      AT803X_DEBUG_GATE_CLK_IN1000, 0);
+
+	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_HIB_CTRL,
+			      AT803X_DEBUG_HIB_CTRL_EN_ANY_CHANGE |
+			      AT803X_DEBUG_HIB_CTRL_SEL_RST_80U, 0);
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1421,8 +1478,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count		= at803x_get_sset_count,
 	.get_strings		= at803x_get_strings,
 	.get_stats		= at803x_get_stats,
-	.suspend		= genphy_suspend,
-	.resume			= genphy_resume,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-A from switch QCA8327-AL1A */
 	.phy_id			= QCA8327_A_PHY_ID,
@@ -1436,8 +1493,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count		= at803x_get_sset_count,
 	.get_strings		= at803x_get_strings,
 	.get_stats		= at803x_get_stats,
-	.suspend		= genphy_suspend,
-	.resume			= genphy_resume,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-B from switch QCA8327-BL1A */
 	.phy_id			= QCA8327_B_PHY_ID,
@@ -1451,8 +1508,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count		= at803x_get_sset_count,
 	.get_strings		= at803x_get_strings,
 	.get_stats		= at803x_get_stats,
-	.suspend		= genphy_suspend,
-	.resume			= genphy_resume,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
2.32.0

