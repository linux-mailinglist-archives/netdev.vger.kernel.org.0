Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B092A1E22
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgKAMyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgKAMwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:31 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C9C0617A6;
        Sun,  1 Nov 2020 04:52:31 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id l16so11386145eds.3;
        Sun, 01 Nov 2020 04:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Mnjy6MKRQ6zbrurlyNhEaek9Xs8TNBfqDfRG5N513g=;
        b=dfWZK4FShdJVxbn3m9gKZaCJbe7qxMMn+/YFllVkf+MoiIAzrWBIaR9fjRBuo9/Jt0
         lwprRGMlfnkkFdh4lKyWACk7rpm1vAQMPBiWB5LJsXAIBrzFCZSa1kGSmx53gn7sXHg5
         osntDBWu4IEbAJwHvRIFz0leHuQIm5Zw5ox4sUFiS9/sa+sX0+RWS9QR0whjpVHzhKR3
         4i29OgCkFJHgoqdfvCmxP/6ub0UGRTN+0kjzOJ6ENDKkWHFyQ2YTnnzr/jEypuU+GOti
         6X5PlY4yD1ZB8JFlwWCBJKUwKgNMbeCGWd74q7V3PqKmr2I2esXA7M0wdKsiBkOCYdkD
         zm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Mnjy6MKRQ6zbrurlyNhEaek9Xs8TNBfqDfRG5N513g=;
        b=DT4l0w6oa8VohAlWYu5a+cyIs3Y04q/kKTp9JZkgRkCnQWQBQuTRSvJuk0bgfFgBeo
         /O+fC6rsez/5M00xIfVKNGnMUl3GjjbEOC3afNnfLtG28Te8AAe50K7QzqhUMgh4kOOd
         aR/5a4bl4VvTWYcaCG5CY6dZmMHfCNARU9kCmo5C2iM63OLh1TOWmyJym4haWIZ1FZIF
         JFgeDijNnMvkW89huE+nVeYmkx8AsEPZ1astG/BVXwAf/JaFMBgHgeBfQ3dcYrdXNG+J
         EmuAvYYXkPBMwXruH1HAPGo9HpCNrhUFldqZ6rVAR/1K2RR01JADDvdRfmNpQcWfZ7kc
         qmVA==
X-Gm-Message-State: AOAM531HgMM5HR1Lg9oSeNgIo+BvTaVi5yTQy/oimfAIzyXRK/EyCOg8
        B77DcXWwxGUsssH9MTVtMy8=
X-Google-Smtp-Source: ABdhPJxH9j8uKSyezOtxqlgGXtRA0LE/T1ALc8UPIhcdni+sW5+2gjCTmVokEFKyHug/QVtaKYnTUg==
X-Received: by 2002:aa7:c6d9:: with SMTP id b25mr11471646eds.27.1604235149988;
        Sun, 01 Nov 2020 04:52:29 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:29 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 07/19] net: phy: mscc: implement generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:51:02 +0200
Message-Id: <20201101125114.1316879-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
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

Also, remove the .did_interrupt() callback since it's not anymore used.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/mscc/mscc_main.c | 56 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index b705121c9d26..48883730bf6f 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1541,16 +1541,6 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static int vsc8584_did_interrupt(struct phy_device *phydev)
-{
-	int rc = 0;
-
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		rc = phy_read(phydev, MII_VSC85XX_INT_STATUS);
-
-	return (rc < 0) ? 0 : rc & MII_VSC85XX_INT_MASK_MASK;
-}
-
 static int vsc8514_config_pre_init(struct phy_device *phydev)
 {
 	/* These are the settings to override the silicon default
@@ -1948,6 +1938,24 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 	return rc;
 }
 
+static irqreturn_t vsc85xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_VSC85XX_INT_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_VSC85XX_INT_MASK_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int vsc85xx_config_aneg(struct phy_device *phydev)
 {
 	int rc;
@@ -2114,7 +2122,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init	= &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt	= &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2139,9 +2147,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8574_probe,
@@ -2163,7 +2170,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init    = &vsc8514_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2187,7 +2194,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init	= &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt	= &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2211,7 +2218,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init    = &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2235,7 +2242,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init	= &vsc85xx_config_init,
 	.config_aneg	= &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt	= &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2259,7 +2266,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init    = &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2283,9 +2290,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init    = &vsc8584_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8574_probe,
@@ -2308,9 +2314,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_init    = &vsc8584_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8584_probe,
@@ -2335,7 +2340,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8574_probe,
@@ -2359,9 +2363,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.handle_interrupt = vsc85xx_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8574_probe,
@@ -2388,7 +2391,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8584_probe,
@@ -2413,7 +2415,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8584_probe,
@@ -2438,7 +2439,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
-	.did_interrupt  = &vsc8584_did_interrupt,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.probe		= &vsc8584_probe,
-- 
2.28.0

