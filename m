Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C22C0F01
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgKWPiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389613AbgKWPix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:53 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F707C0613CF;
        Mon, 23 Nov 2020 07:38:51 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so23942248ejk.2;
        Mon, 23 Nov 2020 07:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sM8faEX0Cx9oXuKgSwivvFPThJ27cR2sjDuMpcARVXA=;
        b=LgXhHcPSE7B140XtJ8eSxIvW64IpuEy2xORJShJ9qjPDQ5Oj7Qh9DeuNT/ZsI4IPf4
         FUoubsryKXdULQc7Ws/gwFzu8g3mQbQHToxDwj3dd6Ry9vkErkyKoj1SKPkm7JmfKHzt
         B+wPKqazzBUZZQiyAdnw2bPItwf5rDwru4cTRVqkSyOrqd8ZYbckPTyumZ/XADBWMNdw
         uYySDE65lAMypSNpT+MbWVBrLw8o5OjSnsAvGlofaya50ImCOwwmdH6BNA+yi8k2G+jb
         HyReqlRQpLdPNAx0II6UszwPkH2OeMYA1OqQxuauUUlYRz4AkzNxoBY4hyMztr3BFhZ5
         dRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sM8faEX0Cx9oXuKgSwivvFPThJ27cR2sjDuMpcARVXA=;
        b=IFaYSsUAUv/CH1tu98/yY/rIfbAlF6hFGVEzYNgNStBZGLbW3W+Ou5Xn7NLiCt1yIK
         L5P8LjV9wvvpesuo/pVU4sIMv6S6gQCLo7thm9H8R5Gm8e6lHYbkQrrk6KB/tGoSqLsM
         SB7wHKoxdAe7C8NUKUcfteN7FjmXoSlhD8TRgokYpzj6I41P6f9HgRu+w2rdADbcO0//
         gWmrr402ee/Q6dlkt3vVmIbjGjRR8vETB6Ftw6DIdvmF6dAm2zBy1UqYZP4eHTuDMpss
         fLYYeg8QvUHV6E+4vuN/sc3eXbMGFdooCAENsthITmJDEGHi0932cKsnKuTBJj194wc0
         9VYw==
X-Gm-Message-State: AOAM531dBBBS5YcMUuBRTF5+hWFjdrc+iaQ0lxT08y26wajdtNZujlUN
        eG8f5MkWD5mBv1ZecD/zcOM=
X-Google-Smtp-Source: ABdhPJynDRYVEgmTPOf9bjASaMxjGROrQ7/AkUwb+eIncUX3/wfTz1KvUbMrS+lwxHhJLFSmcRasKA==
X-Received: by 2002:a17:906:33c4:: with SMTP id w4mr188763eja.380.1606145930282;
        Mon, 23 Nov 2020 07:38:50 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:49 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Marek Vasut <marex@denx.de>,
        Antoine Tenart <atenart@kernel.org>
Subject: [PATCH net-next 07/15] net: phy: micrel: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:09 +0200
Message-Id: <20201123153817.1616814-8-ciorneiioana@gmail.com>
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

Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/micrel.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a7f74b3b97af..9aa96ebd31c8 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -48,6 +48,10 @@
 #define	KSZPHY_INTCS_LINK_UP			BIT(8)
 #define	KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
 						KSZPHY_INTCS_LINK_DOWN)
+#define	KSZPHY_INTCS_LINK_DOWN_STATUS		BIT(2)
+#define	KSZPHY_INTCS_LINK_UP_STATUS		BIT(0)
+#define	KSZPHY_INTCS_STATUS			(KSZPHY_INTCS_LINK_DOWN_STATUS |\
+						 KSZPHY_INTCS_LINK_UP_STATUS)
 
 /* PHY Control 1 */
 #define	MII_KSZPHY_CTRL_1			0x1e
@@ -182,6 +186,24 @@ static int kszphy_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_KSZPHY_INTCS, temp);
 }
 
+static irqreturn_t kszphy_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_KSZPHY_INTCS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if ((irq_status & KSZPHY_INTCS_STATUS))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int kszphy_rmii_clk_sel(struct phy_device *phydev, bool val)
 {
 	int ctrl;
@@ -1162,6 +1184,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1174,6 +1197,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1189,6 +1213,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1205,6 +1230,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_aneg	= ksz8041_config_aneg,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1220,6 +1246,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1233,6 +1260,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1249,6 +1277,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1264,6 +1293,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8081_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1277,6 +1307,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8061_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1290,6 +1321,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz9021_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1309,6 +1341,7 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= ksz9031_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
@@ -1338,6 +1371,7 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-- 
2.28.0

