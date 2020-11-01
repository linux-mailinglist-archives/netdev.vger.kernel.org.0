Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466AC2A1E21
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgKAMym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgKAMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:34 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A7C0617A6;
        Sun,  1 Nov 2020 04:52:33 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b9so1151717edu.10;
        Sun, 01 Nov 2020 04:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0TfXwEdEcM2gE+zJ4+TFD7P1Hji79lCV+K46mLk+s54=;
        b=FjEXTGrv6H6vXnxI6hbEPjtiwuN3cBJy6HX4dnElAQOtJbkkyCDXHjflHI5o6k7dGV
         LAcJtCbXUyCqRbI+zztnQ00zThThN+H5HdmNFxnCW3xGm0SkXgJDUKg36Uy82RygCrBQ
         qc2BUjINPJ4KuDTn+WuRWRlcUq/iBJVx3mZghYb87BaJMSIlkHcaI3zb8PfYnJnZdbvf
         L0x4BSHsnq23jVeGLgZCfzEgBIF/Tq9I/M4wfYt83qWDxqm5ZtT1SqWMHqOdUmkmxioC
         U9snPE1upUiZQmWFtr+FrTg/j3Yuh44W2F4+tiAbB24vaWOyN3mnaFThKuUAkGqmfgKN
         LSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0TfXwEdEcM2gE+zJ4+TFD7P1Hji79lCV+K46mLk+s54=;
        b=cY7KWHZjqSoIjKktpGo6QQOcpcVcsXkLle6O3B9m8RvG0kWMFcTeKIx4qwkatizXWM
         oXscWUKtdkzGgLl+TCqkk9NBAKJq2ZirPMZemxg8kJuh8m0jL0ZTriYXXR5e3zWJWfZc
         wTJjDEEsaC8xGkvd/wvDLb80pKNnptzdfOMOLpwX44ojSU8hUEf+j1KH98jdLZv3OQre
         w2+XebKrtThNplZtXS5DqAnnjk2kerXNxXZvtysz9eW4bFSJMWICJLQuawzVWZ9Dl4gv
         6qTdBDAfym85ZpGd0DwixHBWFLUdijQVhTk6sNHzgkAX7kJ8AVvh8tfeuysm3ii47Avr
         H+/g==
X-Gm-Message-State: AOAM533RGNVChfuEzaMIGwp39dHf/TVKIKSO3cj6Csy6F5M8WOkDWFJI
        kZf6s66uyxF7FykdP8tWARLuv02zHDLfLN+j
X-Google-Smtp-Source: ABdhPJwCMOrosMN7EwS89TeufiD5JGPz0QCOnhVMAWMkNL08EiuxY00LABuXGnILZoXefowNu0l0zQ==
X-Received: by 2002:aa7:cb1a:: with SMTP id s26mr11842701edt.219.1604235152733;
        Sun, 01 Nov 2020 04:52:32 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:32 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 09/19] net: phy: aquantia: implement generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:51:04 +0200
Message-Id: <20201101125114.1316879-10-ciorneiioana@gmail.com>
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

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/aquantia_main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 41e7c1432497..17b33f0cb179 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -52,6 +52,7 @@
 #define MDIO_AN_TX_VEND_INT_STATUS1_DOWNSHIFT	BIT(1)
 
 #define MDIO_AN_TX_VEND_INT_STATUS2		0xcc01
+#define MDIO_AN_TX_VEND_INT_STATUS2_MASK	BIT(0)
 
 #define MDIO_AN_TX_VEND_INT_MASK2		0xd401
 #define MDIO_AN_TX_VEND_INT_MASK2_LINK		BIT(0)
@@ -270,6 +271,25 @@ static int aqr_ack_interrupt(struct phy_device *phydev)
 	return (reg < 0) ? reg : 0;
 }
 
+static irqreturn_t aqr_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read_mmd(phydev, MDIO_MMD_AN,
+				  MDIO_AN_TX_VEND_INT_STATUS2);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MDIO_AN_TX_VEND_INT_STATUS2_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int aqr_read_status(struct phy_device *phydev)
 {
 	int val;
@@ -585,6 +605,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -593,6 +614,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -601,6 +623,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 	.suspend	= aqr107_suspend,
 	.resume		= aqr107_resume,
@@ -611,6 +634,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -621,6 +645,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
 	.set_tunable    = aqr107_set_tunable,
@@ -639,6 +664,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
 	.set_tunable    = aqr107_set_tunable,
@@ -655,6 +681,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 };
-- 
2.28.0

