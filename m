Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F482C0F13
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389743AbgKWPj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389670AbgKWPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:58 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8990C0613CF;
        Mon, 23 Nov 2020 07:38:57 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q16so17541242edv.10;
        Mon, 23 Nov 2020 07:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmtMdyzeHBYHPpq35X+F3862eXFIVMymWHYH6aQfZo4=;
        b=Ms7N6qLr2LyLgKoqkiPzc60J1/oEkRHlaQJa9/KdlAMnagJ2e1lmNej7u/B5EX/wJq
         eGzxF0b2LTaCwL36JKYnKt5GbpSbsw5pX7N1LdTB2V+xDAxNEG04WjfPOvN2NaBXUEzd
         hmdG3GrXNAasTjJZM013rWoOE3YdPAssLUi8aBW7E4PfvEccd2mPXGmwdO3JE1vYl+ja
         0LSLobo+3ZgYK2T3vc3a+vQF+UOn07oTwC2gDWzz9AtYpGvT8F1n0TFYS/+qFhoLIbZ5
         jtsIUQgU78RBvRJ6bNgC3U7qDT8v1drlOqpwZXLaqoeeRuV0HgxIROb9iorWoEVoFa06
         EKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmtMdyzeHBYHPpq35X+F3862eXFIVMymWHYH6aQfZo4=;
        b=LjtJGNq+Mae2EpF4jCB6WQ02CECOlMH0KfMiI3Ot8GjTObq/JeQBlez8H/8xUaoABy
         2inoFOcjZea47vMWivpU8g72dCg8Fv/K6w3VqssnmpKR2btHAGz5h8IRL1eNmp8nAzrH
         sZTeQxzRo9mzi+DXJlNY22NbTeKDMdxAMuA21GeB21iwyas7uK5NqRikQbPlkI2VSRgK
         T4oau40/vGmbkJr84u5gVHuhNHSEuiXqeVplp5e78AoyMvFzHzQqcjaUkWdXEV+Uxtgf
         JHKmY3n9XIebQYo63q4T+wDm+bNVxd7RG3etbcQwi7g58C1p1ZHEveyJQf+g1X52V5kB
         1F8Q==
X-Gm-Message-State: AOAM531gbuPKjCyeaAYHEOp4FqsmH87jUeT0VrrBe4eOO4aUi/U5/ZXY
        4Q7bSrohr4fgl0dKMOQXtje4fZuXFu7rbQ==
X-Google-Smtp-Source: ABdhPJx20BdcA8PWSj5x9MNiS9+g1m/uFabwE6rdEjwiBXh+LwZgeoUPmB9xOXwNufVX+3lB/Kpo9Q==
X-Received: by 2002:a50:f147:: with SMTP id z7mr15095287edl.76.1606145936430;
        Mon, 23 Nov 2020 07:38:56 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:55 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 11/15] net: phy: ti: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:13 +0200
Message-Id: <20201123153817.1616814-12-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/dp83640.c   | 27 +++++++++++++++++++++++
 drivers/net/phy/dp83822.c   | 37 +++++++++++++++++++++++++++++++
 drivers/net/phy/dp83848.c   | 33 ++++++++++++++++++++++++++++
 drivers/net/phy/dp83867.c   | 25 +++++++++++++++++++++
 drivers/net/phy/dp83869.c   | 25 +++++++++++++++++++++
 drivers/net/phy/dp83tc811.c | 44 +++++++++++++++++++++++++++++++++++++
 6 files changed, 191 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index f2caccaf4408..89577f1d3576 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -50,6 +50,14 @@
 #define MII_DP83640_MISR_LINK_INT_EN 0x20
 #define MII_DP83640_MISR_ED_INT_EN 0x40
 #define MII_DP83640_MISR_LQ_INT_EN 0x80
+#define MII_DP83640_MISR_ANC_INT 0x400
+#define MII_DP83640_MISR_DUP_INT 0x800
+#define MII_DP83640_MISR_SPD_INT 0x1000
+#define MII_DP83640_MISR_LINK_INT 0x2000
+#define MII_DP83640_MISR_INT_MASK (MII_DP83640_MISR_ANC_INT |\
+				   MII_DP83640_MISR_DUP_INT |\
+				   MII_DP83640_MISR_SPD_INT |\
+				   MII_DP83640_MISR_LINK_INT)
 
 /* phyter seems to miss the mark by 16 ns */
 #define ADJTIME_FIX	16
@@ -1193,6 +1201,24 @@ static int dp83640_config_intr(struct phy_device *phydev)
 	}
 }
 
+static irqreturn_t dp83640_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_DP83640_MISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_DP83640_MISR_INT_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 {
 	struct dp83640_private *dp83640 =
@@ -1517,6 +1543,7 @@ static struct phy_driver dp83640_driver = {
 	.config_init	= dp83640_config_init,
 	.ack_interrupt  = dp83640_ack_interrupt,
 	.config_intr    = dp83640_config_intr,
+	.handle_interrupt = dp83640_handle_interrupt,
 };
 
 static int __init dp83640_init(void)
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index c162c9551bd1..bb512ac3f533 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -303,6 +303,41 @@ static int dp83822_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83822_PHYSCR, physcr_status);
 }
 
+static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	/* The MISR1 and MISR2 registers are holding the interrupt status in
+	 * the upper half (15:8), while the lower half (7:0) is used for
+	 * controlling the interrupt enable state of those individual interrupt
+	 * sources. To determine the possible interrupt sources, just read the
+	 * MISR* register and use it directly to know which interrupts have
+	 * been enabled previously or not.
+	 */
+	irq_status = phy_read(phydev, MII_DP83822_MISR1);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
+		goto trigger_machine;
+
+	irq_status = phy_read(phydev, MII_DP83822_MISR2);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
+		goto trigger_machine;
+
+	return IRQ_NONE;
+
+trigger_machine:
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
 	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
@@ -576,6 +611,7 @@ static int dp83822_resume(struct phy_device *phydev)
 		.set_wol = dp83822_set_wol,			\
 		.ack_interrupt = dp83822_ack_interrupt,		\
 		.config_intr = dp83822_config_intr,		\
+		.handle_interrupt = dp83822_handle_interrupt,	\
 		.suspend = dp83822_suspend,			\
 		.resume = dp83822_resume,			\
 	}
@@ -591,6 +627,7 @@ static int dp83822_resume(struct phy_device *phydev)
 		.set_wol = dp83822_set_wol,			\
 		.ack_interrupt = dp83822_ack_interrupt,		\
 		.config_intr = dp83822_config_intr,		\
+		.handle_interrupt = dp83822_handle_interrupt,	\
 		.suspend = dp83822_suspend,			\
 		.resume = dp83822_resume,			\
 	}
diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index 54c7c1b44e4d..b707a9b27847 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -37,6 +37,20 @@
 	 DP83848_MISR_SPD_INT_EN |	\
 	 DP83848_MISR_LINK_INT_EN)
 
+#define DP83848_MISR_RHF_INT		BIT(8)
+#define DP83848_MISR_FHF_INT		BIT(9)
+#define DP83848_MISR_ANC_INT		BIT(10)
+#define DP83848_MISR_DUP_INT		BIT(11)
+#define DP83848_MISR_SPD_INT		BIT(12)
+#define DP83848_MISR_LINK_INT		BIT(13)
+#define DP83848_MISR_ED_INT		BIT(14)
+
+#define DP83848_INT_MASK		\
+	(DP83848_MISR_ANC_INT |	\
+	 DP83848_MISR_DUP_INT |	\
+	 DP83848_MISR_SPD_INT |	\
+	 DP83848_MISR_LINK_INT)
+
 static int dp83848_ack_interrupt(struct phy_device *phydev)
 {
 	int err = phy_read(phydev, DP83848_MISR);
@@ -66,6 +80,24 @@ static int dp83848_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, DP83848_MICR, control);
 }
 
+static irqreturn_t dp83848_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, DP83848_MISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & DP83848_INT_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp83848_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -104,6 +136,7 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 		/* IRQ related */				\
 		.ack_interrupt	= dp83848_ack_interrupt,	\
 		.config_intr	= dp83848_config_intr,		\
+		.handle_interrupt = dp83848_handle_interrupt,	\
 	}
 
 static struct phy_driver dp83848_driver[] = {
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 69d3eacc2b96..aba4e4c1f75c 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -310,6 +310,30 @@ static int dp83867_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83867_MICR, micr_status);
 }
 
+static irqreturn_t dp83867_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_enabled;
+
+	irq_status = phy_read(phydev, MII_DP83867_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_enabled = phy_read(phydev, MII_DP83867_MICR);
+	if (irq_enabled < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & irq_enabled))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp83867_read_status(struct phy_device *phydev)
 {
 	int status = phy_read(phydev, MII_DP83867_PHYSTS);
@@ -827,6 +851,7 @@ static struct phy_driver dp83867_driver[] = {
 		/* IRQ related */
 		.ack_interrupt	= dp83867_ack_interrupt,
 		.config_intr	= dp83867_config_intr,
+		.handle_interrupt = dp83867_handle_interrupt,
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index cf6dec7b7d8e..487d1b8beec5 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -207,6 +207,30 @@ static int dp83869_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83869_MICR, micr_status);
 }
 
+static irqreturn_t dp83869_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_enabled;
+
+	irq_status = phy_read(phydev, MII_DP83869_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_enabled = phy_read(phydev, MII_DP83869_MICR);
+	if (irq_enabled < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & irq_enabled))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp83869_set_wol(struct phy_device *phydev,
 			   struct ethtool_wolinfo *wol)
 {
@@ -852,6 +876,7 @@ static struct phy_driver dp83869_driver[] = {
 		/* IRQ related */
 		.ack_interrupt	= dp83869_ack_interrupt,
 		.config_intr	= dp83869_config_intr,
+		.handle_interrupt = dp83869_handle_interrupt,
 		.read_status	= dp83869_read_status,
 
 		.get_tunable	= dp83869_get_tunable,
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index d73725312c7c..a93c64ac76a3 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -254,6 +254,49 @@ static int dp83811_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	/* The INT_STAT registers 1, 2 and 3 are holding the interrupt status
+	 * in the upper half (15:8), while the lower half (7:0) is used for
+	 * controlling the interrupt enable state of those individual interrupt
+	 * sources. To determine the possible interrupt sources, just read the
+	 * INT_STAT* register and use it directly to know which interrupts have
+	 * been enabled previously or not.
+	 */
+	irq_status = phy_read(phydev, MII_DP83811_INT_STAT1);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
+		goto trigger_machine;
+
+	irq_status = phy_read(phydev, MII_DP83811_INT_STAT2);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
+		goto trigger_machine;
+
+	irq_status = phy_read(phydev, MII_DP83811_INT_STAT3);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
+		goto trigger_machine;
+
+	return IRQ_NONE;
+
+trigger_machine:
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int dp83811_config_aneg(struct phy_device *phydev)
 {
 	int value, err;
@@ -345,6 +388,7 @@ static struct phy_driver dp83811_driver[] = {
 		.set_wol = dp83811_set_wol,
 		.ack_interrupt = dp83811_ack_interrupt,
 		.config_intr = dp83811_config_intr,
+		.handle_interrupt = dp83811_handle_interrupt,
 		.suspend = dp83811_suspend,
 		.resume = dp83811_resume,
 	 },
-- 
2.28.0

