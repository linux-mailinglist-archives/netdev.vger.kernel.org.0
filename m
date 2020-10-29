Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B361F29E879
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgJ2KIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgJ2KIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26B0C0613D2;
        Thu, 29 Oct 2020 03:08:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id k3so2968527ejj.10;
        Thu, 29 Oct 2020 03:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3Br0Gv7C0TSxz79J2fDgy42Yrv0+gQW3rUji9YA368=;
        b=V2zcCpfAq259F8y6tdKDrKYhmP1YxaGZ3z7HxGDlV+GW3XnY2YjCKwjjjfe00h8O7/
         yTQ65PtRqjeUwfG37tvXO6MFeWoAWOYptKj7EnmxhSnh+BYNOq6GLc0qaLQZmFXqlEks
         9E1NSEKDOCd25ZIdEO6q1metVmqJU4SdYMFIGZXZEpFKf1Y7VAsIiaIE++Zcl8CPCTH5
         3aQUoq4HJgtAkZNpih6fUjY1/9eHd6RGrABtcN5JTKne4DH5qXUOGwFrdQtN9DYuv6H2
         vQ/jzRTogOY9s8i76u/V544sF9qowRZmhhLc6tYICKjmrZFzs58zMtA99UGL6+k+ciLq
         I+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3Br0Gv7C0TSxz79J2fDgy42Yrv0+gQW3rUji9YA368=;
        b=N41tkWO22tVgUukMwMXK1qCJti81Aeoyj2SK22BATDXfS6gUtYzXuyTigtU8iRORx+
         xFodRuc9nL1fjQVUL822jvmkX8dhHfhuIaEJ04LjaPjSvYbN6hgS0BY6RkjvJDnqNcR6
         VKLT9hoqdGp44uQc7n6ktnuYPVPQbEF0AW2YE+OUfJrpjcr9uhe7/2OZbRbGwbeZIkO1
         75bvvdihPBZdllUel/k3IWnJT1OsikkV9yUWqi2fjB1CcZnjNN0u//zJyQBIGeY9TyJs
         nmMZFGLiQSl0+L3dQo4M4YhFq/QIp0kr9aFK/UrW4x4moPSLI93yAs6SHhnb/4Z2LykW
         FnKg==
X-Gm-Message-State: AOAM533SzzHpZOCLqa1pbaCtvm+eo53QJTv+DSyEjK+wdPOeTD5FMoNg
        EqyQqdRAWEVdKHplj1Qjb5t1+Dx0q0gvHW4X
X-Google-Smtp-Source: ABdhPJw31Lc497wnRpVGlUTZ5qZcq98XqXv80z/85gmjH0t7zbU2iFG08oZZcyOGWjW6d5mQ8eStEg==
X-Received: by 2002:a17:906:c2d2:: with SMTP id ch18mr3242941ejb.446.1603966131475;
        Thu, 29 Oct 2020 03:08:51 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:50 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 09/19] net: phy: aquantia: implement generic .handle_interrupt() callback
Date:   Thu, 29 Oct 2020 12:07:31 +0200
Message-Id: <20201029100741.462818-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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
 drivers/net/phy/aquantia_main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 41e7c1432497..e7f315898efb 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -270,6 +270,24 @@ static int aqr_ack_interrupt(struct phy_device *phydev)
 	return (reg < 0) ? reg : 0;
 }
 
+static irqreturn_t aqr_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
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
 static int aqr_read_status(struct phy_device *phydev)
 {
 	int val;
@@ -585,6 +603,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -593,6 +612,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -601,6 +621,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 	.suspend	= aqr107_suspend,
 	.resume		= aqr107_resume,
@@ -611,6 +632,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 {
@@ -621,6 +643,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
 	.set_tunable    = aqr107_set_tunable,
@@ -639,6 +662,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
 	.set_tunable    = aqr107_set_tunable,
@@ -655,6 +679,7 @@ static struct phy_driver aqr_driver[] = {
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
+	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
 };
-- 
2.28.0

