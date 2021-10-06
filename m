Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456F24249C6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbhJFWid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbhJFWiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:24 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5874AC061755;
        Wed,  6 Oct 2021 15:36:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z20so15407934edc.13;
        Wed, 06 Oct 2021 15:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HISJKp5s6i0STFRR4xQ5zmfLE/DXCkjj2PuSFsQHH2w=;
        b=UoGexV3EpRH+e/p7azhBHSe7XKtaojtvjpgV3trJCJZfRlMBAfTH8tp6S3c7kUEO18
         IQ90nWGab5GvHRjXDLPcrQqymi4DTb44aMFix+oG2R/PZJl0UB7jjqGQSxyUQ30++gQR
         PqoH46N2t2At3JfFlxEnRHZe2wwe9ZR5Kq0fUQaeVFjuB/GblTOg/dUvgC3PIvAfjmx5
         RcIMi9JeP0rw2xG/qtBeQHQSFKHsKjrOR7p0olo/N8mjX77soXtAMRArM4BMRk3gs2aV
         JK/nImWjYuCbaznu5lGk5RpGSIWtKaOkXgdNvkr2IX02vqnvJrRBz0G0PLQEQ8o/4CF5
         Uqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HISJKp5s6i0STFRR4xQ5zmfLE/DXCkjj2PuSFsQHH2w=;
        b=DudD9FBVg1FL5Ccdn67f/joEnoNG6YVesQ9sQQxB7Gvy3sp5joczG3MsMf7R4XCQI0
         48xfM7Jt8snkzDaQ3Kt0+xNb3AlJFNtcjNv17NoX/oV+CGIYaQVL5BMXHzisAazBg2TT
         2CGeY0efhqXoQ97ngecw9zy5IpT4AhdmZn10qhZPZPglrqAlktoiC4kmFTP2DAAfbwVR
         Vqy6b/s2sGogTrdf6Tq1sP9Gp1k6wJl996cLGAiF/AoNCEbBlwenegrsZgPrade6y1MP
         vV1o6wPC4d8huOV/1MZDRUWnXuQ2Vuj4MVv1Gr6Xl4Wfhlr9MuvydEF472NMIciaLKXC
         HAmw==
X-Gm-Message-State: AOAM532yPCn8m1XL0KBA128WZBDPoC42rNzBXIoBS5rV5R0LgdMBxeHd
        3lh+lovqfBaJ1DI3DhR2g1s=
X-Google-Smtp-Source: ABdhPJyzvsPPxKzaneQtINyXjNafdWHFssPu2i3PYXI+QwNuqpfSgK63Mlx4BoooxMb71yneV5tn6A==
X-Received: by 2002:a05:6402:2906:: with SMTP id ee6mr1250781edb.170.1633559789771;
        Wed, 06 Oct 2021 15:36:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:29 -0700 (PDT)
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
Subject: [net-next PATCH 01/13] drivers: net: phy: at803x: fix resume for QCA8327 phy
Date:   Thu,  7 Oct 2021 00:35:51 +0200
Message-Id: <20211006223603.18858-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
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

Fixes: 52a6cdbe43a3 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 75 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3feee4d59030..9090f384c29e 100644
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
 
-#define AT803X_DEBUG_REG_3D			0x3D
+#define AT803X_DEBUG_REG_GREEN			0x3D
+#define   AT803X_DEBUG_GATE_CLK_IN1000		BIT(6)
 
 #define AT803X_DEBUG_REG_1F			0x1F
 #define AT803X_DEBUG_PLL_ON			BIT(2)
@@ -1295,7 +1300,7 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		/* For 100M waveform */
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_0, 0x02ea);
 		/* Turn on Gigabit clock */
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x68a0);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x68a0);
 		break;
 
 	case 2:
@@ -1303,7 +1308,7 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		fallthrough;
 	case 4:
 		phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_AZ_DEBUG, 0x803f);
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x6860);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x6860);
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_5, 0x2c46);
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3C, 0x6000);
 		break;
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
+	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_GREEN,
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

