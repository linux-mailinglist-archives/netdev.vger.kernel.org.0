Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52F42B210B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgKMQxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgKMQw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:52:57 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8C8C0613D1;
        Fri, 13 Nov 2020 08:52:56 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id o20so11497783eds.3;
        Fri, 13 Nov 2020 08:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jk5b9nB+oqKMHLVq5uhhdOuhJ71EuKFqGbaLsLlT2HU=;
        b=u1sXVljzxQE8fN07BTgMN4byhFhFGw2MKjNA5R1Fn+MbaNfh+ZKS6xxCDSIlUXPPI3
         kI5gIpxVBe0RFD1MdiXLDYL0GR4auKCajZia67ii3IM5Z9os1z+7X9FnQjZyPb08oxUk
         xs9fZv+/IP2HFz650JLliWmGXJtdWSsdr4G081Fb1KIoHDEZRR08B0eSyfUHP6OX42Pt
         BF8LK+xxbDSbpw9w1peuQ1ej7rFU6q5Y/w4P+FFFmwe2WbrUakAyc9/6G/Vt/umlN8tF
         FMD0VUhHt5CXnE3lgwLE69aQCY2HnA+g5/CnMP7i7iHiW2QBriKS4PEAcDPCOVR/WkuJ
         KJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jk5b9nB+oqKMHLVq5uhhdOuhJ71EuKFqGbaLsLlT2HU=;
        b=dNlhq6wzvjdP+N6CId7d/P5mzTGXYxPlB2SHGaOgxatNH+H4xNuwAMB9axU3OJeu0h
         WDokEg2ILL3TKOHU5ZkySU5X3VBGgbm9ukzH0UdeB6pE67Cr7dTQobyYETXOpE96+2N6
         KHrxtSmZnJeGPqudju4XOfdm/MGw73cgtCEHhjyAOsiZmnDjDO0dXsARKsYE26pMSDlB
         XSlIBM+70/NjSGagnVjES2bg87zwOlmD20iQyRi1X1BRSkyYka8ILNELBzhoASKyTCCI
         4ko6iRF3cWhswAOvAyP87OtllnL+HqvvVrG8pn2uzGF2VGrrFS+erxjOCdUkYMCsjbC9
         DU4A==
X-Gm-Message-State: AOAM531U6/r4A9wXmQI3HmDT4ycjvdWw9nsNY/USCB9zYDH/DAWwnb+K
        H851p3+qsahJwEExVeVlUic=
X-Google-Smtp-Source: ABdhPJyEg31SmQPPU+dDGjwKZzoqvgYEm2zzg+ZOjNUMZtVug93MSt+tGgwSFR3f4x0qRkVpXAsIIw==
X-Received: by 2002:a50:dac9:: with SMTP id s9mr3275732edj.75.1605286370408;
        Fri, 13 Nov 2020 08:52:50 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:49 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH RESEND net-next 03/18] net: phy: microchip: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:11 +0200
Message-Id: <20201113165226.561153-4-ciorneiioana@gmail.com>
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

Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
For the lan87xx_handle_interrupt() implementation, I do not know which
exact bits denote a link change status (since I do not have access to a
datasheet), so only in this driver's case, the phy state machine is
triggered if any bit is asserted in the Interrupt status register.

 drivers/net/phy/microchip.c    | 19 +++++++++++++++++++
 drivers/net/phy/microchip_t1.c | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index a644e8e5071c..b472a2149f08 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -56,6 +56,24 @@ static int lan88xx_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t lan88xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN88XX_INT_STS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & LAN88XX_INT_STS_LINK_CHANGE_))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lan88xx_suspend(struct phy_device *phydev)
 {
 	struct lan88xx_priv *priv = phydev->priv;
@@ -342,6 +360,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,
diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 1c9900162619..04cda8865deb 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -203,6 +203,24 @@ static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
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
 static int lan87xx_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
@@ -222,6 +240,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
 
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
-- 
2.28.0

