Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9862F2B2101
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKMQxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgKMQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E05C0613D1;
        Fri, 13 Nov 2020 08:53:12 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o21so14439931ejb.3;
        Fri, 13 Nov 2020 08:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6jMD8aRzONibBh+E/XbB8QBNX+IURULm74n4EN/rLQ=;
        b=CQx44aI6193GjQCexgTAB2PYUHksVhqbQ1OuprPFMhsLmdeZlGtb8VcUbH+LMAGaIk
         NoBxN0/ioip5zMqgbMXYAjl/x9yU0WURwRPePkteRoJTF32jLAQfK8yDAg63ixDqOOi1
         WTK/KYd33Gigpbb8yerFUnvHxfqHu/W0w+1RYrPMr9MS4fWKeO7LjWAobU2NqGICzy2u
         0O9fbSucymyc2x0BRyYQByFdClZjuap/1/2QkchIlLzvJHGAcX8XJ0c8nRyNhxjmXmDg
         ujKxvuZT8AyLGpkNzeruspC0iASmllpYUKrNRkKfFZ9b/jWpyRowGqB9FWNotz8mpX3e
         OO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6jMD8aRzONibBh+E/XbB8QBNX+IURULm74n4EN/rLQ=;
        b=I3Z1zpgBJi+UW2xTg2G61lJA8MAG1dlwyR/KllbYfJ9UnSDHCoAsqglNr1vVImmcoO
         YjtOAhGKpaqEKIMXyfp9TPjpgPqQxj1YNbWorHlKzWnpSJ1sATpLlirWdn6kLIFbZE7B
         FCErgbqdb59x7EfEOxqPQWLBKxwfCI6nJT/Jy3pb9ZIpw82efvgzcAjuappHdsfcyde1
         fSbGsl+05u/aYPnck5Ef4Ifmuh50jc2R6sTkC2mrJlo0L3GdbZlHhRYRKR1v/S5ojl9p
         nIueT+EiGRUtiBeR6pA7yxeekqfo2EQBS1+txhVxXfl/B2vmvYl00BCLCmls7j/AkB32
         T49A==
X-Gm-Message-State: AOAM5332g8NRRcAmDpIXS2Qlzdjl982H0IC6V24w4TD7TcmoychOVmjs
        zBPgZ8MHBUhhNnj/10aMnM4=
X-Google-Smtp-Source: ABdhPJzDwI1eMkiCqTcgCjJsxp2/ZLGYrU9ub1nRiNNQbgy554jUc3XludrD/fcSZgMvwa8o+brXqg==
X-Received: by 2002:a17:906:d94:: with SMTP id m20mr2940038eji.279.1605286386250;
        Fri, 13 Nov 2020 08:53:06 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:05 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andre Edich <andre.edich@microchip.com>,
        Marco Felsch <m.felsch@pengutronix.de>
Subject: [PATCH RESEND net-next 13/18] net: phy: smsc: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:21 +0200
Message-Id: <20201113165226.561153-14-ciorneiioana@gmail.com>
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

Cc: Andre Edich <andre.edich@microchip.com>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/smsc.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ec97669be5c2..8d9eb1b3d2df 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -72,6 +72,30 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_enabled;
+
+	irq_enabled = phy_read(phydev, MII_LAN83C185_IM);
+	if (irq_enabled < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
+	if (irq_status < 0) {
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
 static int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
@@ -314,6 +338,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
@@ -333,6 +358,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	/* Statistics */
 	.get_sset_count = smsc_get_sset_count,
@@ -362,6 +388,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	/* Statistics */
 	.get_sset_count = smsc_get_sset_count,
@@ -385,6 +412,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
@@ -410,6 +438,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	/* Statistics */
 	.get_sset_count = smsc_get_sset_count,
@@ -436,6 +465,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
 	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
 
 	/* Statistics */
 	.get_sset_count = smsc_get_sset_count,
-- 
2.28.0

