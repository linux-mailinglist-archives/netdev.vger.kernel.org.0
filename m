Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94B92C0EF7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389466AbgKWPil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730956AbgKWPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:41 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C85BC0613CF;
        Mon, 23 Nov 2020 07:38:41 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id gj5so23913507ejb.8;
        Mon, 23 Nov 2020 07:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O376hIiadPt9uM3Z2r8C1fbpx9uQFLckLdaH17lGghA=;
        b=YQCNjczoDElNKOLT5PNITkYw4gVSZjcG7fpmZPxQFDGhgAlvkArTmYYWwR3yWN8tfc
         DdDPkp81GELd2FRSjhmDTu7umc1Nxbu3C4WE8JTOi4H9BVQWpAXS4S3q3FhHAb9JIkjE
         ekv/OgiXExf8aOGPHid8MZ6fg0YWLJbZYhN1cI9pFy8VBJGUHc0dIGgyQ2QfQF2bKon5
         1WYKEArYgh3F/un/NlbtIPascyh0atDin/dBwHlMkk6uMm6ZSkRj4gjWwiJDu35hE/qm
         2P/75BxEJ8uwIzdXkwC6S/Is5GZtjoP2YSiaN7YeJb9Sh5Rviy0vCMHl7O8IMsgEQX1T
         UX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O376hIiadPt9uM3Z2r8C1fbpx9uQFLckLdaH17lGghA=;
        b=SK4bMDJ2JrP12CQmJOscmOe3p6YRYjG5RK1QNjXf1UtZnafde/7yW83dhNL76MShR1
         3HIbPjvFIzk4TQfHDcxz769skINe/nhadXe4T+rqw5L63vCag+5KbQwZ2Z3OwB7cqr7J
         vHbDR03HKrZ0gL0YI6KAOFb6RYJpMEE1QXOBoJ3mALctWJVTTk0dhxQ6LxccZyrrrk60
         T0wpJakvZPC/Onn5Aa8N9svmeduweLJRxAzvJAbRG+jCnPCF6PB52XTdChYjUenTZsmW
         H4u/lLMFPOWgpViAfW1Ge3w6wo8Udpo/L/2xZeUwkwyYBG0i8sQj2x/GJThY3iks29YM
         /kvw==
X-Gm-Message-State: AOAM532aRcDf8AoCdaO9nqe0nHxBEC3xfiWHEv15+slUOLt2szc5qwz+
        79vfqmbhBXSo0a739NAuUdgz2d7qCxTh8A==
X-Google-Smtp-Source: ABdhPJwxh0NOTfAsAkTFHoJq9zuREShkemefPDGlS/jqJWfj5UmYD9C12n7fGGyRvQmkLBHYpC+gZg==
X-Received: by 2002:a17:906:180b:: with SMTP id v11mr177928eje.466.1606145919667;
        Mon, 23 Nov 2020 07:38:39 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Mathias Kresin <dev@kresin.me>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net-next 01/15] net: phy: intel-xway: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:03 +0200
Message-Id: <20201123153817.1616814-2-ciorneiioana@gmail.com>
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

Cc: Mathias Kresin <dev@kresin.me>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/intel-xway.c | 46 ++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index b7875b36097f..1a27ae1bec5c 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -209,14 +209,6 @@ static int xway_gphy_ack_interrupt(struct phy_device *phydev)
 	return (reg < 0) ? reg : 0;
 }
 
-static int xway_gphy_did_interrupt(struct phy_device *phydev)
-{
-	int reg;
-
-	reg = phy_read(phydev, XWAY_MDIO_ISTAT);
-	return reg & XWAY_MDIO_INIT_MASK;
-}
-
 static int xway_gphy_config_intr(struct phy_device *phydev)
 {
 	u16 mask = 0;
@@ -227,6 +219,24 @@ static int xway_gphy_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, XWAY_MDIO_IMASK, mask);
 }
 
+static irqreturn_t xway_gphy_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, XWAY_MDIO_ISTAT);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & XWAY_MDIO_INIT_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static struct phy_driver xway_gphy[] = {
 	{
 		.phy_id		= PHY_ID_PHY11G_1_3,
@@ -236,7 +246,7 @@ static struct phy_driver xway_gphy[] = {
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -248,7 +258,7 @@ static struct phy_driver xway_gphy[] = {
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -260,7 +270,7 @@ static struct phy_driver xway_gphy[] = {
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -272,7 +282,7 @@ static struct phy_driver xway_gphy[] = {
 		.config_init	= xway_gphy_config_init,
 		.config_aneg	= xway_gphy14_config_aneg,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -283,7 +293,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -294,7 +304,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -305,7 +315,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -316,7 +326,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -327,7 +337,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_GBIT_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -338,7 +348,7 @@ static struct phy_driver xway_gphy[] = {
 		/* PHY_BASIC_FEATURES */
 		.config_init	= xway_gphy_config_init,
 		.ack_interrupt	= xway_gphy_ack_interrupt,
-		.did_interrupt	= xway_gphy_did_interrupt,
+		.handle_interrupt = xway_gphy_handle_interrupt,
 		.config_intr	= xway_gphy_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
-- 
2.28.0

