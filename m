Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBAC2A1E1F
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgKAMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKAMw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:27 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A4AC0617A6;
        Sun,  1 Nov 2020 04:52:27 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o9so12738088ejg.1;
        Sun, 01 Nov 2020 04:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAr2ZpROTUIh8AyndHrw65H5Tjuc6RrJxRTm7QHUC9c=;
        b=kgPmBeJMeW0hJeo7er3LfchxAFxmGI/4Yb5AzlL6EpKM2mzcMolBfkLTL2cAdhv9IB
         pAOD7+6KO6FpijBMsw+jcwkJ9a2WTwqkASBBodgHog9Sf3+rOEYdrlb9AxJKSJttSgLL
         R/qfDNgYc42NjiC+NXj5tkTj//tWpvrUuWvOeGZDV839J6/PP20mII9dFzFOugUbrLT4
         Jh8fvAKlmRRfGP5JMrLd4VRprUvYQ7P7AEGNyhzWsxoINfLtveY3xEg/geN6siEsX02z
         Js8PhPwtWpQCB+maBIYs9V2mtBXR7gIB/zvdKTOyzYgaQjqnijnLYNacCQCmcrTleyi6
         DG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAr2ZpROTUIh8AyndHrw65H5Tjuc6RrJxRTm7QHUC9c=;
        b=QNCKS0smjgrgjNoHIoQjMbbtFeQudOM6dxlwD4lCXpX/jy9uMjfOBmEdujCEvi7SPs
         IHENWpryS+9QufK6Hn2W3D6b9kyQZYOoouN2sIJ0ktJzojcz6lM12NiFPqa+Q7lHcFDs
         8MUrL74ZqHTCfm/6WZkXS6WINboRlhkys5LhZi/jRW5V25uVkFR3Ewx571w/typZEbHd
         pBblEJaOHTyMkDAVcgddmHqjHq17FNPFB4OnYw2Ov+2s1rP84nN7VQQ0r1YsfNT6u/YP
         lSA1CB7wSl6xefWCn59E1GlQw6cRDVDl7zPPrbCivW77wT2u2zynmVL22cq+w2A80JCy
         yCAg==
X-Gm-Message-State: AOAM533Zig5x/PJSjM2r2YaTSQrVC4Buk7UmCpG4Xo2IyQHARGkHEKhE
        jy/wA+rRwVm2b0LBb/ACP6c=
X-Google-Smtp-Source: ABdhPJzryKXM/CZpRt22sJbREQXlV5y8WsJJxu3+mXkcAAzZAGZH5yM6kvF0BndBVI5VbsWm75/SVg==
X-Received: by 2002:a17:906:260a:: with SMTP id h10mr4506040ejc.159.1604235146026;
        Sun, 01 Nov 2020 04:52:26 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:25 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 04/19] net: phy: at803x: implement generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:50:59 +0200
Message-Id: <20201101125114.1316879-5-ciorneiioana@gmail.com>
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

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/at803x.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index ed601a7e46a0..c7f91934cf82 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -628,6 +628,32 @@ static int at803x_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t at803x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, int_enabled;
+
+	irq_status = phy_read(phydev, AT803X_INTR_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	/* Read the current enabled interrupts */
+	int_enabled = phy_read(phydev, AT803X_INTR_ENABLE);
+	if (int_enabled < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	/* See if this was one of our enabled interrupts */
+	if (!(irq_status & int_enabled))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static void at803x_link_change_notify(struct phy_device *phydev)
 {
 	/*
@@ -1064,6 +1090,7 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1084,6 +1111,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
@@ -1102,6 +1130,7 @@ static struct phy_driver at803x_driver[] = {
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1122,6 +1151,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
@@ -1134,6 +1164,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 	.read_status		= at803x_read_status,
-- 
2.28.0

