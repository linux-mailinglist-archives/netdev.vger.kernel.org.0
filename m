Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232352B210A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKMQwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgKMQwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:52:50 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37162C0613D1;
        Fri, 13 Nov 2020 08:52:50 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b9so11461058edu.10;
        Fri, 13 Nov 2020 08:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y8LXIYYpPzP9HNW+uSjQkTA7aSXHrHU/5a1QvbrK6pU=;
        b=BRnS3vef3+4JF4h814sKEEfzHzathTr3zP9eIHtPdfV2LY6NMW3ZiS5rXequD/PLUE
         797x7iykRPBqI5QzsC4kDRKcUnaBnsYfZX6Ocuy2OArHcYKjZaEh9LLn0OCuaYLNuRG7
         P2AuWM4V4LzFf25P+a19Mjkv+A6YouTXUluvtot90zkdChM+KnF7dReEnVESBCy9o39M
         qTa56cPHmRNobXzckwdlVXPZ3lgWR8Lr6sW+0E1JglYuBS+z/+JZDhcPeSXWH61KTlmE
         9/G5k52bHJRSwPtaL1pxvBmpez+BR3GRY8X8/taVne4rS1nL/+/g0VMTEr5a8ocjPTTJ
         uPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8LXIYYpPzP9HNW+uSjQkTA7aSXHrHU/5a1QvbrK6pU=;
        b=OJOYPcxjOl5ZfkcNTbvXoakMywbvQuVvm19mPo5kC+ZpCcB8vJlJJgb2LM04W9YaQC
         d374bTKd35YxHog7N9PhqdRV0sP6/CmAa/sIiA3+cWstt3yB9oc7v0e784EafxiHnzU+
         GBfNM2C4p8Ls3vCq5caxevc1sSpOi9yu2zscWjPeVd9XBJjE2UFzIsC0ALoJcUtrwOH1
         4J8VqtsuEuD9u/jHPP66Mh4dCKF+6ezvir/QwV00vOf4kbcqpExajFILswlBKM7PiqyE
         YlhrjCyxIsX57MoHO7hvgXDr7YN47VKJ4Ky80Z+gHCiSGIft8UiK4ZO5yhN9msq+/8OW
         IlLA==
X-Gm-Message-State: AOAM530nHlkqYuAw0T7hjQW3bTQJC3aLJO9t1DTI/RsqDiA065frNFLM
        gpeujh1qUawzKs3mywQ6Vwo=
X-Google-Smtp-Source: ABdhPJwi0WxXi8Pchm9qV3/xraYf8xF91/u9NFzgnSQAAUU2QIR+MyXTwADfn2M/oPQYvTJEMacOXQ==
X-Received: by 2002:a05:6402:141:: with SMTP id s1mr3245649edu.87.1605286366930;
        Fri, 13 Nov 2020 08:52:46 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:46 -0800 (PST)
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
Subject: [PATCH RESEND net-next 01/18] net: phy: vitesse: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:09 +0200
Message-Id: <20201113165226.561153-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
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

