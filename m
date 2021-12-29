Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2354815AE
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 18:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhL2RR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 12:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhL2RR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 12:17:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A8CC061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 09:17:26 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w16so88696138edc.11
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 09:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YVyWyxRhmdNp6igWct+pDw1ciuy7wVl5Nx1G1zURkfw=;
        b=qTzcJTcejWljapbMxK+wSr+vjHSuedbOuZ7j0uNJlrOXusIT9S6GJYv3BtemWWvBjx
         6lsDR3Vv4356rlst7+7fzA2j0Ioos+fimcAvrGiVDRwcf7mj74W692GNaEBBjnyc3nSV
         p6D8iNilIEMd0zdQp3XBjTL9/88L2ZAmrNEOXikRIOeqhY6hnmhzo6ysg2bM3VnVySGZ
         XxLYRoMuH/N4UcbUSUrG2mjpiYnXNHq7ELq+ITF+2woOJrd53DvA8JGinnvMypId/V3b
         IzJxSpilyryXdvICpi+bWTFL7MTJODTzTE+kHTq8ycYvlHabyvTqgCOIOpppdAU4rPNZ
         gIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YVyWyxRhmdNp6igWct+pDw1ciuy7wVl5Nx1G1zURkfw=;
        b=y4L6jNBMdBY1phVSwd1rhgbcczZ5FvegudsnseKYb9dHmqTqTOpGEzVNaOLWt/PMkz
         V78JkWuDLL1crJ0NS8ynXkQTk254Mu9TXRBpfaAWXdOofu6H5rHp2G4VE9QLtqBCfnNQ
         MLIxoUxfTMDkqqF1z1CSOXgqCHlD19nwYqCjAxPceg+8yGGNwIRfGVLaAxS7F07j0RsV
         hqlWLMU4rPJdfqSgPbU9wFGtF3Am6lfX9TKxlmSBxblf4g/Dr6mVvCbdVcyTqtUhHHzO
         4L7PBJuvRrcOTPz8l7pbWJr5bP7UpGvs3jYahPZEl5DrMURkHMoOWcm23upDfpXwraNu
         eyBg==
X-Gm-Message-State: AOAM530njnV6c66H7TF/Z7ApGnQbOcPCJMYPKTjeapDwtdS2H4gUEbpY
        v1Ti82+hbQEWPRp2OGDgv2c=
X-Google-Smtp-Source: ABdhPJy7tRixb7zRcOwjID1J/7Ae9cpS5BU7ro0XTS0KQnuW2cIYQXK/7aJRg20t/BJWdPAh1WZvcg==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr26317408edb.83.1640798245353;
        Wed, 29 Dec 2021 09:17:25 -0800 (PST)
Received: from localhost.localdomain ([2a00:f41:3894:b142:1667:a0ff:5387:8a85])
        by smtp.gmail.com with ESMTPSA id hr5sm7044617ejc.5.2021.12.29.09.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 09:17:25 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] net: dsa: bcm_sf2: refactor LED regs access
Date:   Wed, 29 Dec 2021 18:16:42 +0100
Message-Id: <20211229171642.22942-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228220951.17751-1-zajec5@gmail.com>
References: <20211228220951.17751-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

1. Define more regs. Some switches (e.g. BCM4908) have up to 6 regs.
2. Add helper for handling non-lineral port <-> reg mappings.
3. Add support for 12 B LED reg blocks on BCM4908 (different layout)

Complete support for LEDs setup will be implemented once Linux receives
a proper design & implementation for "hardware" LEDs.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: bcm_sf2_reg_led_base(): share code for ports 0, 1 and 2
---
 drivers/net/dsa/bcm_sf2.c      | 54 ++++++++++++++++++++++++----
 drivers/net/dsa/bcm_sf2.h      | 10 ++++++
 drivers/net/dsa/bcm_sf2_regs.h | 65 +++++++++++++++++++++++++++++++---
 3 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 13aa43b5cffd..33499fcd8848 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -62,6 +62,38 @@ static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
 	return REG_SWITCH_STATUS;
 }
 
+static u16 bcm_sf2_reg_led_base(struct bcm_sf2_priv *priv, int port)
+{
+	switch (port) {
+	case 0:
+		return REG_LED_0_CNTRL;
+	case 1:
+		return REG_LED_1_CNTRL;
+	case 2:
+		return REG_LED_2_CNTRL;
+	}
+
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		switch (port) {
+		case 3:
+			return REG_LED_3_CNTRL;
+		case 7:
+			return REG_LED_4_CNTRL;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	WARN_ONCE(1, "Unsupported port %d\n", port);
+
+	/* RO fallback reg */
+	return REG_SWITCH_STATUS;
+}
+
 /* Return the number of active ports, not counting the IMP (CPU) port */
 static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 {
@@ -187,9 +219,14 @@ static void bcm_sf2_gphy_enable_set(struct dsa_switch *ds, bool enable)
 
 	/* Use PHY-driven LED signaling */
 	if (!enable) {
-		reg = reg_readl(priv, REG_LED_CNTRL(0));
-		reg |= SPDLNK_SRC_SEL;
-		reg_writel(priv, reg, REG_LED_CNTRL(0));
+		u16 led_ctrl = bcm_sf2_reg_led_base(priv, 0);
+
+		if (priv->type == BCM7278_DEVICE_ID ||
+		    priv->type == BCM7445_DEVICE_ID) {
+			reg = reg_led_readl(priv, led_ctrl, 0);
+			reg |= LED_CNTRL_SPDLNK_SRC_SEL;
+			reg_led_writel(priv, reg, led_ctrl, 0);
+		}
 	}
 }
 
@@ -1232,9 +1269,14 @@ static const u16 bcm_sf2_4908_reg_offsets[] = {
 	[REG_SPHY_CNTRL]	= 0x24,
 	[REG_CROSSBAR]		= 0xc8,
 	[REG_RGMII_11_CNTRL]	= 0x014c,
-	[REG_LED_0_CNTRL]	= 0x40,
-	[REG_LED_1_CNTRL]	= 0x4c,
-	[REG_LED_2_CNTRL]	= 0x58,
+	[REG_LED_0_CNTRL]		= 0x40,
+	[REG_LED_1_CNTRL]		= 0x4c,
+	[REG_LED_2_CNTRL]		= 0x58,
+	[REG_LED_3_CNTRL]		= 0x64,
+	[REG_LED_4_CNTRL]		= 0x88,
+	[REG_LED_5_CNTRL]		= 0xa0,
+	[REG_LED_AGGREGATE_CTRL]	= 0xb8,
+
 };
 
 static const struct bcm_sf2_of_data bcm_sf2_4908_data = {
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index 0d48402068d3..00afc94ce522 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -210,6 +210,16 @@ SF2_IO_MACRO(acb);
 SWITCH_INTR_L2(0);
 SWITCH_INTR_L2(1);
 
+static inline u32 reg_led_readl(struct bcm_sf2_priv *priv, u16 off, u16 reg)
+{
+	return readl_relaxed(priv->reg + priv->reg_offsets[off] + reg);
+}
+
+static inline void reg_led_writel(struct bcm_sf2_priv *priv, u32 val, u16 off, u16 reg)
+{
+	writel_relaxed(val, priv->reg + priv->reg_offsets[off] + reg);
+}
+
 /* RXNFC */
 int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc, u32 *rule_locs);
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 7bffc80f241f..da0dedbd6555 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -25,6 +25,10 @@ enum bcm_sf2_reg_offs {
 	REG_LED_0_CNTRL,
 	REG_LED_1_CNTRL,
 	REG_LED_2_CNTRL,
+	REG_LED_3_CNTRL,
+	REG_LED_4_CNTRL,
+	REG_LED_5_CNTRL,
+	REG_LED_AGGREGATE_CTRL,
 	REG_SWITCH_REG_MAX,
 };
 
@@ -56,6 +60,63 @@ enum bcm_sf2_reg_offs {
 #define CROSSBAR_BCM4908_EXT_GPHY4	1
 #define CROSSBAR_BCM4908_EXT_RGMII	2
 
+/* Relative to REG_LED_*_CNTRL (BCM7278, BCM7445) */
+#define  LED_CNTRL_NO_LINK_ENCODE_SHIFT		0
+#define  LED_CNTRL_M10_ENCODE_SHIFT		2
+#define  LED_CNTRL_M100_ENCODE_SHIFT		4
+#define  LED_CNTRL_M1000_ENCODE_SHIFT		6
+#define  LED_CNTRL_SEL_NO_LINK_ENCODE_SHIFT	8
+#define  LED_CNTRL_SEL_10M_ENCODE_SHIFT		10
+#define  LED_CNTRL_SEL_100M_ENCODE_SHIFT	12
+#define  LED_CNTRL_SEL_1000M_ENCODE_SHIFT	14
+#define  LED_CNTRL_RX_DV_EN			(1 << 16)
+#define  LED_CNTRL_TX_EN_EN			(1 << 17)
+#define  LED_CNTRL_SPDLNK_LED0_ACT_SEL_SHIFT	18
+#define  LED_CNTRL_SPDLNK_LED1_ACT_SEL_SHIFT	20
+#define  LED_CNTRL_ACT_LED_ACT_SEL_SHIFT	22
+#define  LED_CNTRL_SPDLNK_SRC_SEL		(1 << 24)
+#define  LED_CNTRL_SPDLNK_LED0_ACT_POL_SEL	(1 << 25)
+#define  LED_CNTRL_SPDLNK_LED1_ACT_POL_SEL	(1 << 26)
+#define  LED_CNTRL_ACT_LED_POL_SEL		(1 << 27)
+#define  LED_CNTRL_MASK				0x3
+
+/* Register relative to REG_LED_*_CNTRL (BCM4908) */
+#define REG_LED_CTRL				0x0
+#define  LED_CTRL_RX_ACT_EN			0x00000001
+#define  LED_CTRL_TX_ACT_EN			0x00000002
+#define  LED_CTRL_SPDLNK_LED0_ACT_SEL		0x00000004
+#define  LED_CTRL_SPDLNK_LED1_ACT_SEL		0x00000008
+#define  LED_CTRL_SPDLNK_LED2_ACT_SEL		0x00000010
+#define  LED_CTRL_ACT_LED_ACT_SEL		0x00000020
+#define  LED_CTRL_SPDLNK_LED0_ACT_POL_SEL	0x00000040
+#define  LED_CTRL_SPDLNK_LED1_ACT_POL_SEL	0x00000080
+#define  LED_CTRL_SPDLNK_LED2_ACT_POL_SEL	0x00000100
+#define  LED_CTRL_ACT_LED_POL_SEL		0x00000200
+#define  LED_CTRL_LED_SPD_OVRD			0x00001c00
+#define  LED_CTRL_LNK_STATUS_OVRD		0x00002000
+#define  LED_CTRL_SPD_OVRD_EN			0x00004000
+#define  LED_CTRL_LNK_OVRD_EN			0x00008000
+
+/* Register relative to REG_LED_*_CNTRL (BCM4908) */
+#define REG_LED_LINK_SPEED_ENC_SEL		0x4
+#define  LED_LINK_SPEED_ENC_SEL_NO_LINK_SHIFT	0
+#define  LED_LINK_SPEED_ENC_SEL_10M_SHIFT	3
+#define  LED_LINK_SPEED_ENC_SEL_100M_SHIFT	6
+#define  LED_LINK_SPEED_ENC_SEL_1000M_SHIFT	9
+#define  LED_LINK_SPEED_ENC_SEL_2500M_SHIFT	12
+#define  LED_LINK_SPEED_ENC_SEL_10G_SHIFT	15
+#define  LED_LINK_SPEED_ENC_SEL_MASK		0x7
+
+/* Register relative to REG_LED_*_CNTRL (BCM4908) */
+#define REG_LED_LINK_SPEED_ENC			0x8
+#define  LED_LINK_SPEED_ENC_NO_LINK_SHIFT	0
+#define  LED_LINK_SPEED_ENC_M10_SHIFT		3
+#define  LED_LINK_SPEED_ENC_M100_SHIFT		6
+#define  LED_LINK_SPEED_ENC_M1000_SHIFT		9
+#define  LED_LINK_SPEED_ENC_M2500_SHIFT		12
+#define  LED_LINK_SPEED_ENC_M10G_SHIFT		15
+#define  LED_LINK_SPEED_ENC_MASK		0x7
+
 /* Relative to REG_RGMII_CNTRL */
 #define  RGMII_MODE_EN			(1 << 0)
 #define  ID_MODE_DIS			(1 << 1)
@@ -73,10 +134,6 @@ enum bcm_sf2_reg_offs {
 #define  LPI_COUNT_SHIFT		9
 #define  LPI_COUNT_MASK			0x3F
 
-#define REG_LED_CNTRL(x)		(REG_LED_0_CNTRL + (x))
-
-#define  SPDLNK_SRC_SEL			(1 << 24)
-
 /* Register set relative to 'INTRL2_0' and 'INTRL2_1' */
 #define INTRL2_CPU_STATUS		0x00
 #define INTRL2_CPU_SET			0x04
-- 
2.31.1

