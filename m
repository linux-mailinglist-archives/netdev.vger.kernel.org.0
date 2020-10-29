Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973E729E899
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgJ2KKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgJ2KIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500B3C0613D2;
        Thu, 29 Oct 2020 03:08:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id oq3so1135496ejb.7;
        Thu, 29 Oct 2020 03:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bW7tXe/erM9Tt8UJnQV2tscGEtc/fntIia0lMw15mkk=;
        b=cmfZJk10YRB07EKEu1BdOk8rxCcqU9PG+Sg9/fZDgZKAQ737mn1+Ujz623LujHaym9
         s+uidHKjD2vi5o6Wc1GaWP/XJ4J+cmggXBsD4J5UrCq0Ycohlo49zqqXAuFsEYKCS4Xz
         0y+DXj453CIe0JZ3sSwaNrBmKYPlC3PMH6yNBJHN4vbxGaAcEyuw1Z/zfssjTp8CgxkI
         g0sKCOg6xdIQFP+npy2/tb4b97Yq1mS/N6ll/b+fjRz9yJ3QgJ83Z0FqCy2MSjR2S0lY
         VizqaCcDlkuZXqM/uiHVfSKLjZ7/IC5PPY9xFBxLrfwqWRyvr4Uju79ki+0ugAl/6qqn
         2k8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bW7tXe/erM9Tt8UJnQV2tscGEtc/fntIia0lMw15mkk=;
        b=TSEZ8UwwJuRSrYxm7336Odh/cTKlkELJAxQVqxmJE656kSbqK1nKeiE2ohWBMxEUBD
         XcRFVCkDme7ZV7Xl4+wxd1jQ5zEsgn/sb7/Zu9mVMuMtfEupWEnZxucGiA9lVwB2hZLP
         sNI6KecpDndF8Vt1Ao41iZlf+TPLy/DmwU32pO5yVSnGFB7hmMszd6U3dWbpnXjftNpA
         Wcla72xN3bq033GGUDtOfnTTRlJteh9eo2LeTUyZ7WOdSP0jWMc0POaDMpR4fcLWhBgd
         v+mzoRjhC6mWcsyKDPxD+YdzUSb5uXbpK1jDsQtmDoJ4I4zpkinxBdHtRWDzxS6GoO0O
         ARDw==
X-Gm-Message-State: AOAM53077qrc8IGLUAKTHyJhD/hwyVat36olPWItnWNk5YhtLrCG3Skp
        9ci0KZB3W6hdxhywhYUCDQDli5KodBJHZofr
X-Google-Smtp-Source: ABdhPJzhHssjd6UE/qYtDlb8KQ8DJSc9B1goPnnU5IOPQooAKWJ+aiVDmoCJ3hjw3vcyHfthtbL5oQ==
X-Received: by 2002:a17:906:e116:: with SMTP id gj22mr3391957ejb.313.1603966128991;
        Thu, 29 Oct 2020 03:08:48 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:48 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 07/19] net: phy: mscc: implement generic .handle_interrupt() callback
Date:   Thu, 29 Oct 2020 12:07:29 +0200
Message-Id: <20201029100741.462818-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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
 drivers/net/phy/mscc/mscc_main.c | 56 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index b705121c9d26..ae790fd3734c 100644
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
+	if (irq_status == 0)
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

