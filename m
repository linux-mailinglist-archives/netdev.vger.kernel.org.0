Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098B829E889
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgJ2KJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgJ2KJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:04 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0BC0613CF;
        Thu, 29 Oct 2020 03:09:04 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id o18so2461006edq.4;
        Thu, 29 Oct 2020 03:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CqNUS7HcRPCCge3R03YlWR0VNXk0g9HQYTNptYIriU4=;
        b=g8GfVQlStWcB8JQ9WrTyXwfB6at9tKwefJK5QXB18khcv2zKYwyaSmU8tl5k6GIwoe
         sZjBr6y9g9Ese2VPgfPSz+CIi9v0KrmDWT0VooWnf7GEbN7yE3ZyNLZfm97xuPKpkiwn
         pKSj00qLRCYxcwjjuH1UvBbTx0AaV8PwnUjeUrYJl9dkSf5HfcTba7Xdqf9uLsDgq60t
         GjxJrfIPIcP986hIPdISdn4iP4bFjnE7YUF4nKdn30O/wpXoTmpFH/N9A9CmqT6/rXh8
         e7/5hLWJGD7cTAvq0VB7e0eNsaiYucq8/rMBNzhufUK70ZhKcKHj6c64zoJKeEzzlfrn
         Q6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CqNUS7HcRPCCge3R03YlWR0VNXk0g9HQYTNptYIriU4=;
        b=ItoJ68vk7o1++T0Y2eBgPPBb9ehUzbpKVOHZOUTMlKNWUg7vZrgLYgQ2++kM0uYeeP
         74+QAxsu4EcxVnvT7gh5WF2fHKzODYsR6jYdtPVzeSrGPVYH//8Piqsq0ts8cygwWEfU
         dQcdXWkQCJroJ/C4IQbEeaFC2mbsDSuGlZmuR4pJRYa5lEDAyiQ3rzk17uL6cjgiDeb8
         JJ2sAO3HBaD4rzM+YBZtxTNPohn3h93nYBCiZjU+NXJRqNMQDOhVhOM+N1rSKpjachsS
         HVXiSn3i6KTvn1zI6IhEFHwM7zdJMBndOQcwzCGste54Q+0Gd/f/HHyRA73tzfjr3My3
         astQ==
X-Gm-Message-State: AOAM530+DHuu0S9b+Ru1v4nLOH3QTOzosGeYTamLnh4EJkwHm5n21cBN
        dKP4I78xx3HHNzGTcZEER2k=
X-Google-Smtp-Source: ABdhPJzGsoRuP6b8TI0+sdOup3eyzcmG0k3Fa0VVeSrmgNzLjKNTRln69U58YfGyeXkO0GjRNwOa9A==
X-Received: by 2002:a50:e149:: with SMTP id i9mr1373860edl.56.1603966143208;
        Thu, 29 Oct 2020 03:09:03 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:09:02 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next 18/19] net: phy: realtek: implement generic .handle_interrupt() callback
Date:   Thu, 29 Oct 2020 12:07:40 +0200
Message-Id: <20201029100741.462818-19-ciorneiioana@gmail.com>
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

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Willy Liu <willy.liu@realtek.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/realtek.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fb1db713b7fb..dd77703af1be 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -149,6 +149,60 @@ static int rtl8211f_config_intr(struct phy_device *phydev)
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
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rtl821x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, RTL821x_INSR);
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
+	if (irq_status == 0)
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
@@ -556,6 +610,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8201F Fast Ethernet",
 		.ack_interrupt	= &rtl8201_ack_interrupt,
 		.config_intr	= &rtl8201_config_intr,
+		.handle_interrupt = rtl8201_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -582,6 +637,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8211B Gigabit Ethernet",
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211b_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.read_mmd	= &genphy_read_mmd_unsupported,
 		.write_mmd	= &genphy_write_mmd_unsupported,
 		.suspend	= rtl8211b_suspend,
@@ -601,6 +657,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8211DN Gigabit Ethernet",
 		.ack_interrupt	= rtl821x_ack_interrupt,
 		.config_intr	= rtl8211e_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -611,6 +668,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
+		.handle_interrupt = rtl821x_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -621,6 +679,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211f_config_init,
 		.ack_interrupt	= &rtl8211f_ack_interrupt,
 		.config_intr	= &rtl8211f_config_intr,
+		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
@@ -670,6 +729,7 @@ static struct phy_driver realtek_drvs[] = {
 		 */
 		.ack_interrupt	= genphy_no_ack_interrupt,
 		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 	},
-- 
2.28.0

