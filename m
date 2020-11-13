Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6582B2103
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgKMQxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgKMQxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:06 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38BAC0613D1;
        Fri, 13 Nov 2020 08:53:05 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so11423165edj.13;
        Fri, 13 Nov 2020 08:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ulq0yD0my4Otp65SkQZNLolrSXf+hFMzY6ErDKfcVE=;
        b=EGR8EKGQaHe6bFSQpGDmmNGl/WIB2HVmkjDDtcShtg0/I5abvMg85bKrkVNt2oWmvs
         51zrGMDjJegpl4Pov7C0JQlk8Vl1ULinUT8ifbbeb1hNP5oijnDmTAsGVoZlNeLA0A2i
         4rU5/z2CWu1Xm+bwxposVRMhZRoWLbIpsVxeJPFcs1cAkkNe5GAfA7nIhFnu91b1yPSR
         YwRaJDJ6qQgLytfz/uw1PaTAOIVyyblEuhNQPICnUkAPySrFcUjhIiIK0tvzxJVJmIXc
         6P9PY68rKPk+0p52aJPOIajCqAn784T3FODZG1N0MB33xrsc3IkbR0tDDi8vDM7z56nV
         5Qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ulq0yD0my4Otp65SkQZNLolrSXf+hFMzY6ErDKfcVE=;
        b=GWjUQf7yoyEDWMlZ/WFSZyRzar0JNWWiQ7+7vV4fTxliHEgD41sgRbaO5ozf6RjyFh
         rkbY/7SosFT7bK68OOPeX7ugFzLoi21N+qDlup5fGkDkPpNXdDrj3PWPkrlmt/FJwo/7
         Z4OKGX5pFU/eMoadDQquSYzTMjYUlNORq3dPN1lcK8BLWr/N2D5GxRvA5At0HxeBd/7T
         tDKSY1lkyHLPpUaq4KapiPQmZeeDg1PqOTFRLUykiVQsie9lGLhATejYIehBGCnjwho0
         Yr0k+h5rtXLYIe+T3PcDz1aJQ1sPnmj/YaYQicufdku9uSUTZLau3hbqplywsY0S0Nh6
         pKOA==
X-Gm-Message-State: AOAM530ABzHtYDzuvbtI8gtoj7lFoFJWXOjr3mOLr4zAgDNmTrsQ2QGK
        Jo5xTL1zfA2+4hioRGvTEE0=
X-Google-Smtp-Source: ABdhPJxPLDeDhiBlOMUqwYhYP2953OXnIxlVOx/MN6vQce2iimbxulsGPXwhypNzmGS0qtOz8mzPeA==
X-Received: by 2002:aa7:d709:: with SMTP id t9mr3562326edq.305.1605286379576;
        Fri, 13 Nov 2020 08:52:59 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:58 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH RESEND net-next 09/18] net: phy: nxp-tja11xx: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:17 +0200
Message-Id: <20201113165226.561153-10-ciorneiioana@gmail.com>
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

Cc: Marek Vasut <marex@denx.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/nxp-tja11xx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index a72fa0d2e7c7..1c4c5c267fe6 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -44,6 +44,9 @@
 #define MII_CFG2_SLEEP_REQUEST_TO_16MS	0x3
 
 #define MII_INTSRC			21
+#define MII_INTSRC_LINK_FAIL		BIT(10)
+#define MII_INTSRC_LINK_UP		BIT(9)
+#define MII_INTSRC_MASK			(MII_INTSRC_LINK_FAIL | MII_INTSRC_LINK_UP)
 #define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
 
@@ -604,6 +607,24 @@ static int tja11xx_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_INTEN, value);
 }
 
+static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_INTSRC);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_INTSRC_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int tja11xx_cable_test_start(struct phy_device *phydev)
 {
 	int ret;
@@ -749,6 +770,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
+		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
 		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}, {
@@ -772,6 +794,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
+		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
 		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}
-- 
2.28.0

