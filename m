Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523CF5F8DBA
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJITdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJITdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:33:31 -0400
X-Greylist: delayed 533 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Oct 2022 12:33:29 PDT
Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B351DF26;
        Sun,  9 Oct 2022 12:33:29 -0700 (PDT)
From:   Furkan Kardame <f.kardame@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1665343474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0RGT+cnc5KlanDi6/VZkIBN/8bGM2fw81AiU1VLnLLs=;
        b=Rr81dPcznea03FX/A8ZzAZZVJp9cQsRCOU4yt2tcGuNtGC+PRPtGwZqnyT5lw02Oafwr4L
        N0TJQ/EB7myu4NWUK7f8ABn4+3v9AE3mfDfma23LKJViZsztHgSHK+JKyvXoVTTBxvTiSs
        ky7fhyR3MgLeYnnCG50xcPnoAiW6s8hBYKgWik8WBolaOF8CJTpWuIngpntJB6L93OK9Rz
        vFLx0bqefFoIm7CTfdWVNQSic0RaRnUdqvvvHl6SOT1HrkLHKTtShLrrOz5PmfoXvz4A8h
        VEW1s9MIMnMy2yqQQSrJTrmZMpxaLzklpn8f+07kePobPgRJ4tqtU0yFekc6BQ==
To:     pgwipeout@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Furkan Kardame <f.kardame@manjaro.org>
Subject: [PATCH] net: phy: add support for Motorcomm yt8531C phy
Date:   Sun,  9 Oct 2022 22:24:05 +0300
Message-Id: <20221009192405.97118-1-f.kardame@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=f.kardame@manjaro.org smtp.mailfrom=f.kardame@manjaro.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

This patch adds support for Motorcomm YT8531C which is
used in OrangePi 3 LTS, OrangePi 4 LTS and OrangePi 800
Currently being used by Manjaro Arm kernel

Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
---
 drivers/net/phy/motorcomm.c | 90 +++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 7e6ac2c5e..cbc8ef15d 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -10,6 +10,7 @@
 #include <linux/phy.h>
 
 #define PHY_ID_YT8511		0x0000010a
+#define PHY_ID_YT8531		0x4f51e91b
 
 #define YT8511_PAGE_SELECT	0x1e
 #define YT8511_PAGE		0x1f
@@ -38,6 +39,38 @@
 #define YT8511_DELAY_FE_TX_EN	(0xf << 12)
 #define YT8511_DELAY_FE_TX_DIS	(0x2 << 12)
 
+#define YT8531_RGMII_CONFIG1	0xa003
+
+/* TX Gig-E Delay is bits 3:0, default 0x1
+ * TX Fast-E Delay is bits 7:4, default 0xf
+ * RX Delay is bits 13:10, default 0x0
+ * Delay = 150ps * N
+ * On = 2000ps, off = 50ps
+ */
+#define YT8531_DELAY_GE_TX_EN	(0xd << 0)
+#define YT8531_DELAY_GE_TX_DIS	(0x0 << 0)
+#define YT8531_DELAY_FE_TX_EN	(0xd << 4)
+#define YT8531_DELAY_FE_TX_DIS	(0x0 << 4)
+#define YT8531_DELAY_RX_EN	(0xd << 10)
+#define YT8531_DELAY_RX_DIS	(0x0 << 10)
+#define YT8531_DELAY_MASK	(GENMASK(13, 10) | GENMASK(7, 0))
+
+#define YT8531_SYNCE_CFG	0xa012
+
+/* Clk src config is bits 3:1
+ * 3b000 src from pll
+ * 3b001 src from rx_clk
+ * 3b010 src from serdes
+ * 3b011 src from ptp_in
+ * 3b100 src from 25mhz refclk *default*
+ * 3b101 src from 25mhz ssc
+ * Clk rate select is bit 4
+ * 1b0 25mhz clk output *default*
+ * 1b1 125mhz clk output
+ * Clkout enable is bit 6
+ */
+#define YT8531_CLKCFG_125M	(BIT(6) | BIT(4) | (0x0 < 1))
+
 static int yt8511_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, YT8511_PAGE_SELECT);
@@ -111,6 +145,51 @@ static int yt8511_config_init(struct phy_device *phydev)
 	return phy_restore_page(phydev, oldpage, ret);
 }
 
+static int yt8531_config_init(struct phy_device *phydev)
+{
+	int oldpage, ret = 0;
+	unsigned int val;
+
+	oldpage = phy_select_page(phydev, YT8531_RGMII_CONFIG1);
+	if (oldpage < 0)
+		goto err_restore_page;
+
+	/* set rgmii delay mode */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val = YT8531_DELAY_RX_DIS | YT8531_DELAY_GE_TX_DIS | YT8531_DELAY_FE_TX_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = YT8531_DELAY_RX_EN | YT8531_DELAY_GE_TX_DIS | YT8531_DELAY_FE_TX_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = YT8531_DELAY_RX_DIS | YT8531_DELAY_GE_TX_EN | YT8531_DELAY_FE_TX_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val = YT8531_DELAY_RX_EN | YT8531_DELAY_GE_TX_EN | YT8531_DELAY_FE_TX_EN;
+		break;
+	default: /* do not support other modes */
+		ret = -EOPNOTSUPP;
+		goto err_restore_page;
+	}
+
+	ret = __phy_modify(phydev, YT8511_PAGE, YT8531_DELAY_MASK, val);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* set clock mode to 125mhz */
+	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8531_SYNCE_CFG);
+	if (ret < 0)
+		goto err_restore_page;
+
+	ret = __phy_write(phydev, YT8511_PAGE, YT8531_CLKCFG_125M);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static struct phy_driver motorcomm_phy_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
@@ -120,7 +200,16 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= yt8511_read_page,
 		.write_page	= yt8511_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8531),
+		.name		= "YT8531 Gigabit Ethernet",
+		.config_init	= yt8531_config_init,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= yt8511_read_page,
+		.write_page	= yt8511_write_page,
 	},
+
 };
 
 module_phy_driver(motorcomm_phy_drvs);
@@ -131,6 +220,7 @@ MODULE_LICENSE("GPL");
 
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531) },
 	{ /* sentinal */ }
 };
 
-- 
2.37.3

