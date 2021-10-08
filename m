Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6D426121
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbhJHAY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbhJHAY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:24:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE40C061570;
        Thu,  7 Oct 2021 17:23:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d3so2210519edp.3;
        Thu, 07 Oct 2021 17:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4IEdjq+B+/Tu4XXsbREn4Co9QK1TLiWV/cOfOjS1OgI=;
        b=g9B3BE0sCe0E8cRAzMy4Kz+MwuutHkXGqKqZ+3Lz6EzKBAyNhdFD4dJu/CqOrs8+ep
         Y974PwQ6F+kXQewdawOIQtJqtMYoGDSpwvw9B2hCii1KoE7ucnpAUebc6YLoXdpBIhLr
         35Z/+4hyp92SZv/QrS5250PkCIXLNJELRLyMAzaEnkLRsMQUya1N++7tO6BoDI1slLJk
         Z5ok1V7/VfpMT0yw2v1MGu5+Zg2jauway5k5coxAOGCaJcfBhhd+RSzqBEKmm9WyGMdR
         W/CYtaJuVYKVKJonqqoXfZZemKQNjFid3GwpxyirXYZMrd0ymKNmdz7RO+QYip4UIX6S
         hKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IEdjq+B+/Tu4XXsbREn4Co9QK1TLiWV/cOfOjS1OgI=;
        b=6D+cGdu0BZy8IThwvTpGxEpigOSOkNUzqe45ViqV4tBYHUZ3d0Ec04LHFURN9sQSYn
         cFHgh0Z2TrJi8eWQQXoJ2zldDNtd9uOrnDBmADhkYEPgbyZ8jcu1JNvlXMTr3WkFzDEO
         u+/tCM+I0DYkRByDe6KygAYTMIUVYuCXSCP7OPLCFG0o0OOkFYVCyvabY6XIdtAYqwgn
         8FcQaVxukNmQlaeSGcucHCqE70mf24MwsuSdQ1y+4GfKu1fSf8PcEYPPtluUJUrIL5Qa
         ioLTgqK3FYEwjLTOam3pCLJbvf9GAx/AHjNx64GtC8oEdYrS171nj4/zQr4h59k23EuL
         QQLg==
X-Gm-Message-State: AOAM533KmvpyBejJdljJAv8C0qnewMKweCbhQkQYogyHLytLglcaU5Xx
        bEy5pn6GBzx4UJWSJoZNq98=
X-Google-Smtp-Source: ABdhPJw8vnxVHIwn2t96k/cYYUlbnbFlQ75+yZRtho4hY7YTrWhkssazLDtea5spB0naFGGDYgOmig==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr10216945edb.383.1633652581034;
        Thu, 07 Oct 2021 17:23:01 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:00 -0700 (PDT)
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
Subject: [net PATCH v2 01/15] drivers: net: phy: at803x: fix resume for QCA8327 phy
Date:   Fri,  8 Oct 2021 02:22:11 +0200
Message-Id: <20211008002225.2426-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
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

