Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A912B0925
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgKLP6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgKLP6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:18 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E60FC0613D1;
        Thu, 12 Nov 2020 07:58:18 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v22so6839817edt.9;
        Thu, 12 Nov 2020 07:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y8LXIYYpPzP9HNW+uSjQkTA7aSXHrHU/5a1QvbrK6pU=;
        b=Mf8jMYwx3MccylRZVpZjJKNS5ZylfgEGGfPOj5DjKvYtf2p5gw2bpUVDQ8nrPlA8/a
         64cGwf9pKyxMHAzlpz084caVQsL/gfw/R8EeVWkJw9XR8SnDwT0pY1eTHeRlEG7nH7PV
         my9OGNkh1djkhZMsnmCvTRkg+IBDPw7pNtw8IV3rSRgkwIaH1vQwGQSpxV4ZUUiXw2zN
         NRH6QK4E2yNl7mSn/pYhKYOm6ghO+68h/Kr8CbiIEwqtSIW3QIRqp1him+7t9KGZlYs+
         31TtEfd/u3Xs0NNy7Boe8MbQg0VJ+ju7v35CoAr4f0HVweeaKSJmJwk0cZFHffXi/Jgt
         1C9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8LXIYYpPzP9HNW+uSjQkTA7aSXHrHU/5a1QvbrK6pU=;
        b=gaibUjvkQe6tpmlv5BXu7Z6M4tndLMM46UMmdYTPePtcBBrCugySP/V0x0H+zyBQFd
         X42CvRLDAW4xqQCag4gVpxRdqSo/Y9aC/cBLHXLeDMyGiDWpAzZXWGiv3f7kH1vtuhgE
         oCtwIj+kdfwqC4RwNfEErgZ6O07xBhsWu5VZE4jrfHDDPyop2EPp43IFVRWjEMxwAexY
         ricS8k4D8BfMDfo2NZOqD6Qbdq5sJsDe6gKbC1x/aEkOddhdtV5mQcLIoSs2q42GX1Ae
         NaADkqtpZkAx4TyTkj0z9ZvzsXSRItjmhDjRVd0uyz3DP55gnkmlCHiLMBNwpwmdsTL5
         wInA==
X-Gm-Message-State: AOAM5303OTYXy+L6qHWsiBazH8xVFkouC5M5pXdLdwBRGnCXqZPyA42N
        GhsPUQjI9834fqRpfOhK95sGWTnzgkBHuw==
X-Google-Smtp-Source: ABdhPJxyE0ct2CAg13yTcbpTMkESWQCLYtx5NFwd+sffgRCxJNuxcyBQU7Km0SQhC8J8yX6/FDwl8Q==
X-Received: by 2002:a05:6402:1456:: with SMTP id d22mr395126edx.77.1605196696690;
        Thu, 12 Nov 2020 07:58:16 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:16 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 01/18] net: phy: vitesse: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:54:56 +0200
Message-Id: <20201112155513.411604-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
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

Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/vitesse.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index bb680352708a..9f6cd6ec9747 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -40,6 +40,11 @@
 #define MII_VSC8244_ISTAT_SPEED		0x4000
 #define MII_VSC8244_ISTAT_LINK		0x2000
 #define MII_VSC8244_ISTAT_DUPLEX	0x1000
+#define MII_VSC8244_ISTAT_MASK		(MII_VSC8244_ISTAT_SPEED | \
+					 MII_VSC8244_ISTAT_LINK | \
+					 MII_VSC8244_ISTAT_DUPLEX)
+
+#define MII_VSC8221_ISTAT_MASK		MII_VSC8244_ISTAT_LINK
 
 /* Vitesse Auxiliary Control/Status Register */
 #define MII_VSC8244_AUX_CONSTAT		0x1c
@@ -311,6 +316,31 @@ static int vsc82xx_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t vsc82xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_mask;
+
+	if (phydev->drv->phy_id == PHY_ID_VSC8244 ||
+	    phydev->drv->phy_id == PHY_ID_VSC8572 ||
+	    phydev->drv->phy_id == PHY_ID_VSC8601)
+		irq_mask = MII_VSC8244_ISTAT_MASK;
+	else
+		irq_mask = MII_VSC8221_ISTAT_MASK;
+
+	irq_status = phy_read(phydev, MII_VSC8244_ISTAT);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & irq_mask))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int vsc8221_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -392,6 +422,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_aneg    = &vsc82x4_config_aneg,
 	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_VSC8244,
 	.name		= "Vitesse VSC8244",
@@ -401,6 +432,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_aneg	= &vsc82x4_config_aneg,
 	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	.phy_id         = PHY_ID_VSC8572,
 	.name           = "Vitesse VSC8572",
@@ -410,6 +442,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_aneg    = &vsc82x4_config_aneg,
 	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	.phy_id         = PHY_ID_VSC8601,
 	.name           = "Vitesse VSC8601",
@@ -418,6 +451,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_init    = &vsc8601_config_init,
 	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	.phy_id         = PHY_ID_VSC7385,
 	.name           = "Vitesse VSC7385",
@@ -463,6 +497,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_aneg    = &vsc82x4_config_aneg,
 	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	/* Vitesse 8221 */
 	.phy_id		= PHY_ID_VSC8221,
@@ -472,6 +507,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_init	= &vsc8221_config_init,
 	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
 	/* Vitesse 8211 */
 	.phy_id		= PHY_ID_VSC8211,
@@ -481,6 +517,7 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_init	= &vsc8221_config_init,
 	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
+	.handle_interrupt = &vsc82xx_handle_interrupt,
 } };
 
 module_phy_driver(vsc82xx_driver);
-- 
2.28.0

