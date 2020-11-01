Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875E02A1E0A
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgKAMw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgKAMwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:46 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AE0C061A47;
        Sun,  1 Nov 2020 04:52:45 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o21so7777519ejb.3;
        Sun, 01 Nov 2020 04:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BE/4+zMoaGoG+Y2qJFFSFExn1Z28yG9OqagJu4uYRWs=;
        b=BHGwvMyDdX4LFcgIqboA6AtP4BVoXwwFL3kGRYLqtoE2T+1cnT0bmlHcRLR60YNXEz
         F7/YItk9yXoGvFJ2AS5HEVucdR3gfPOpR9BcJG8CWVpPDU7+kCfl7SYTfoYsSskQMJqD
         gELrZhNsRaKoBi42C3ejvrJ8QJZKGOZrlIICHT/kzU0DNGm4iH4/xeaJdv3IfJu7w0Zg
         pLrfbNivxIBNFPqA7JvivE+RO3/ag7E2k2sbOu9FiA31ZPjxAqwLWHrkxuPeexx4GEP5
         Y3P4yjd3jfcbJ9unyNeqOUM07krgzr5v0koxCg4hu6fDYA69okdGyufOL2tmU2BZfnuc
         7LkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BE/4+zMoaGoG+Y2qJFFSFExn1Z28yG9OqagJu4uYRWs=;
        b=lOOwbeCMDuLwJO8g7kCauNw3WbdbIjBrMVvVFRGYQ69faf5siqzlui/dm4EwKpIa9X
         uv91XtgpQ4IgHOSiXdzRYFl3skJ1OQ9gqkrkWWhA6qoOviUpwAK1W01LnLSfq7f+6+M9
         +Xoi+A4zCabmQ6ZiVsRu+ZTgtCv+Ce0+XfUMXFrxjgXazBIzw3Gj4TnQaRVcpe0voXzJ
         ZhcXw/Vxx4rsJoDioZJaCZBHFMnlfv29GPnw0Fhi2KX/G8ZmANHcAekQ5kRDWe/OnkBx
         qQYc+JxyOPP1DhYN1pOMOShGtd0XL8lHeUdJDlwhzOWK2zpOPMEtKBuPCFcW85NZXq/u
         iQuw==
X-Gm-Message-State: AOAM531a5G5pOGZEod944EdEqMNs6yoK9X8nsNMQfwictjAEX/oLi8cp
        ANdfTGswa1dlFOdvodAVCY8=
X-Google-Smtp-Source: ABdhPJzF2Yr5TIx71MQA1KXIERry6MKXDlF50xCO0pVSq2oDph5GWmmD2WVExkokJx/d1CrfwYaRjg==
X-Received: by 2002:a17:906:cb2:: with SMTP id k18mr11336819ejh.71.1604235164410;
        Sun, 01 Nov 2020 04:52:44 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:43 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next v2 18/19] net: phy: realtek: implement generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:51:13 +0200
Message-Id: <20201101125114.1316879-19-ciorneiioana@gmail.com>
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

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Willy Liu <willy.liu@realtek.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/realtek.c | 72 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fb1db713b7fb..820b4e8ef23a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -41,6 +41,12 @@
 #define RTL8211E_RX_DELAY			BIT(11)
 
 #define RTL8201F_ISR				0x1e
+#define RTL8201F_ISR_ANERR			BIT(15)
+#define RTL8201F_ISR_DUPLEX			BIT(13)
+#define RTL8201F_ISR_LINK			BIT(11)
+#define RTL8201F_ISR_MASK			(RTL8201F_ISR_ANERR | \
+						 RTL8201F_ISR_DUPLEX | \
+						 RTL8201F_ISR_LINK)
 #define RTL8201F_IER				0x13
 
 #define RTL8366RB_POWER_SAVE			0x15
@@ -149,6 +155,66 @@ static int rtl8211f_config_intr(struct phy_device *phydev)
 	return phy_write_paged(phydev, 0xa42, RTL821x_INER, val);
 }
 
+static irqreturn_t rtl8201_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, RTL8201F_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & RTL8201F_ISR_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rtl821x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_enabled;
+
+	irq_status = phy_read(phydev, RTL821x_INSR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_enabled = phy_read(phydev, RTL821x_INER);
+	if (irq_enabled < 0) {
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
+static irqreturn_t rtl8211f_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read_paged(phydev, 0xa43, RTL8211F_INSR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & RTL8211F_INER_LINK_STATUS))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int rtl8211_config_aneg(struct phy_device *phydev)
 {
 	int ret;
@@ -556,6 +622,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8201F Fast Ethernet",
 		.ack_interrupt	= &rtl8201_ack_interrupt,
 		.config_intr	= &rtl8201_config_intr,
+		.handle_interrupt = rtl8201_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -582,6 +649,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8211B Gigabit Ethernet",
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211b_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.read_mmd	= &genphy_read_mmd_unsupported,
 		.write_mmd	= &genphy_write_mmd_unsupported,
 		.suspend	= rtl8211b_suspend,
@@ -601,6 +669,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8211DN Gigabit Ethernet",
 		.ack_interrupt	= rtl821x_ack_interrupt,
 		.config_intr	= rtl8211e_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -611,6 +680,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -621,6 +691,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211f_config_init,
 		.ack_interrupt	= &rtl8211f_ack_interrupt,
 		.config_intr	= &rtl8211f_config_intr,
+		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -670,6 +741,7 @@ static struct phy_driver realtek_drvs[] = {
 		 */
 		.ack_interrupt	= genphy_no_ack_interrupt,
 		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 	},
-- 
2.28.0

