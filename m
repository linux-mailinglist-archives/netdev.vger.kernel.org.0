Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA065427DF4
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhJIWs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhJIWs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:48:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEC0C061764;
        Sat,  9 Oct 2021 15:46:30 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d3so23393573edp.3;
        Sat, 09 Oct 2021 15:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbqqoyYUIZZYbznL3kKosmLxfC3pf231vxrIrzT+TdU=;
        b=Mh6NBkQ5xOIisgMZnKVvx9JhVjo8znS7SRWC8Grjw/EUMNM7CtarhuRHm3wrAoa3wj
         BQdpGJAojvPy/kqYzcWVTUunI0HltwKIazIpzIQcdOdG7UvDHdg/YIkpSCAGPsK42jkI
         NWyzPRJbvq+CnoV87LFdeirz3NW5uOCoB3EU9/xpPpu95pvK0uhujmXTeaMnivWA2H5I
         amHwGWGxPMgyaMQrxTNXzyjW3LQjcYraCP95qF+7FiqPA9hrO0qJ1yeGcn5SDm+87RiL
         dCd/XNJtobPcayeO3nN8uKV2Y5C10K+5PLocRjQMfXufUqA3GFxrz+VpFDBw6izPXRPB
         uG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbqqoyYUIZZYbznL3kKosmLxfC3pf231vxrIrzT+TdU=;
        b=EMx3AVsaocaA6e7WrLW2BV6A3NtkfvmL1a6UlXgS4zwwH4u3zp0GvJ9xKmvsd4BuPp
         atrPL9jgm101rHkMk0wyba9prpMqG4AV+Qmhrh5QY4TyR/x5Z/RyeqYY/D9wRgLLGIAG
         GD6f2mdv4gXvREI25p4mnGeViIPQBHMLmFbj+CvY8Zuy5JlnX9RLHOta/UjWyFo3Cwvp
         cwCMlG2tIEzzEfY5wYUHFuLQsmMGNFi6F5tb2JuCxH3mzbTsFzx0FvCEG2iOce1JRFTE
         ogh/07aQZhiaYxKn3PDnjSl7KJ+0/fvFn5ZfsDmy1QJMK3cdZwQ28v/Sxfuqnt91+Dxz
         mtkQ==
X-Gm-Message-State: AOAM5310E+D7KW2y2Ny2bP3+nm7C2drFxtXshKnrPb0+pnBwNClB5YXm
        e6b/80wiRa3hhhAkHEQNU8k=
X-Google-Smtp-Source: ABdhPJwZ2AwyoInOODIFquLetzyOhNYCtxW/gMphHPQIrTsWH+KkHoGwVvW/rH4FEdNhmeyFmu41Ow==
X-Received: by 2002:a50:d98d:: with SMTP id w13mr27941169edj.51.1633819588680;
        Sat, 09 Oct 2021 15:46:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id l13sm1727115eds.92.2021.10.09.15.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:46:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 1/4] net: phy: at803x: fix resume for QCA8327 phy
Date:   Sun, 10 Oct 2021 00:46:15 +0200
Message-Id: <20211009224618.4988-1-ansuelsmth@gmail.com>
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

