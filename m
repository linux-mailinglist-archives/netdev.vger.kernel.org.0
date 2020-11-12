Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42292B0944
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgKLP73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgKLP6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:35 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE31C0613D1;
        Thu, 12 Nov 2020 07:58:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id cw8so8547991ejb.8;
        Thu, 12 Nov 2020 07:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6jMD8aRzONibBh+E/XbB8QBNX+IURULm74n4EN/rLQ=;
        b=MTOVzU0RiShadULyp/ZHCFerVkdXz3VP//XJf2d8780z5KP3sS0EG38vaHOKb6khGh
         D1gX6KULM1EQneccB9L03iMJwFfoBfYUzJBpXeurTaUkYJDYruL5/efVWMsRMHBlUE7S
         dNdSpUbIn7USqdWCl/Fhm4jH6yFzymg/Wx/OfI6iqTTCMKAj/rWLqNaXm+Zkhp6CX+dz
         ra8klylrEiDr08HrzSRjeS7DacGxsCb+csqJ115ptMsCNhN0aPNiH2WDlTZ38e9FnZoO
         ffpA3d9TWX1Bk/v8h5inbjOMTMgfbAGs3jOaBQvmblB2alwShg3WEonhLzf5ZHu+uC8L
         bgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6jMD8aRzONibBh+E/XbB8QBNX+IURULm74n4EN/rLQ=;
        b=d4GarEqtrwpW9GqZbgzuaQQNZcWmPg+D0ch5CPpq9f2ipjDrBtfSA9jwHbC+vm1b1p
         r5ybp7xxKq9kJhoEA1zQxYJ9/L28pxKTwG6A4Yp53cF8S1wC9It7S/7KbKG+MeL9XSB4
         OHI+n4KYsD53DqsnHlXCO/IdYbceZy0sCsGd1SbscOVhZ2Mm95DKxW1OGBfrS4Rg88CF
         DfLQ0THP6owSyR0wkA4IiS42VwQr5Sx1zMTLphYVZuciYOAtZNKC1AkJT4M0DKojXKn5
         JUVOS6tK+UXUhQGvGveLa+YsKEkus0Zkaqj6HXjTwFinkXiwpxyc/UDAc3xHA7uPpTbh
         zD0A==
X-Gm-Message-State: AOAM533DUqLz0CPmCaiRXlVee6mWl2XlIbsyQxOQlhkru1jOpW0LkckL
        SZxoTqe80fcgJ4uRHF82pBg=
X-Google-Smtp-Source: ABdhPJzU3mfh+6ud4bRmKvIgWB3vgjQtC4XM1z4lAiOXjMD5AP8TsgShrDB8Z1ljFYukcgAFYyz9Mg==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr31842944ejp.190.1605196712998;
        Thu, 12 Nov 2020 07:58:32 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:32 -0800 (PST)
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
Subject: [PATCH net-next 13/18] net: phy: smsc: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:08 +0200
Message-Id: <20201112155513.411604-14-ciorneiioana@gmail.com>
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

