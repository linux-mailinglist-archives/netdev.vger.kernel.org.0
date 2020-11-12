Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946542B0954
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgKLQAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgKLP60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:26 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F1AC0613D4;
        Thu, 12 Nov 2020 07:58:26 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id y17so2925068ejh.11;
        Thu, 12 Nov 2020 07:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2XY8ttvdIFiCYz29ukEUuH1Xm19QPYXW7DIh+FSk/8=;
        b=IZS4ybW8CI3QnVvcxHwHmD2hj4HFIZkwmB9H2kewmiQbpnf1z31PQzv5t6+motXvZ1
         na61XssyPc+8TBXJk+/u4ktHG6Chdj1XYeTXaHk+HU3g+l7soWOObJxvSlw1pp2Al1km
         vLJOXZutzOhPU3Kx0cGGN30ONs60HIC77RiNx2Bp7S1xRhW7uJsfkVFa0IuDAOR+gxOL
         XMd9wslm8WzfeAPd0ndic3yNYPoMkiG2fmDW9+jMZDmrZpRK+7iqDJUcXY2STgY3Z6EH
         P59QNw2WuA+3twqXXZ97t6HYx4pg66mPwEjkPs912W05h71YbByJ4JE90NEFRN1K/iwZ
         jv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2XY8ttvdIFiCYz29ukEUuH1Xm19QPYXW7DIh+FSk/8=;
        b=BfUuEc674pqFWNqssB88wXGzX05T2E58LzXN2+YI3Gvwsq27mAYkD3ixCldXCgYEU5
         SCoTVV804vP1Qi4zaV/Kw1UHM0ED7Zy0StQ90mgad+gRZ++b2DKdxMvbj1xi/ob/3MTl
         5alLqnvOfD7FUTMlTRFEM9AihQURJVLgFpSJqjb9FqGFRh6YIu/g+/sbrutWHQkdQdl4
         SPsPgaA5g72P8dHa67zOt47WND4n9NI3siH7VroBRuWnQak50CKkGLXB7d+he7bkKMsX
         hwKz3IxlI4kMGV3YMLRoIr70Z3vR/qj+Z7lkRtkYRq711dcf995KuHzdYCmvIVzjpE+C
         D+Xw==
X-Gm-Message-State: AOAM532bseFPUemBxBZcrLr9zGWYnLRUM5A/8Ou8DtI/wz/Xz91mMMe1
        9y047V7xoN5QEYaoYpiKHrM=
X-Google-Smtp-Source: ABdhPJxPPObF7VfIddXXiBMyQt+VUupzwm6zuT9DBmU0EB+A8vu/lvDbSE+2CfAu6X8Ia3le410xLg==
X-Received: by 2002:a17:906:c298:: with SMTP id r24mr30422591ejz.38.1605196704749;
        Thu, 12 Nov 2020 07:58:24 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:24 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH net-next 07/18] net: phy: lxt: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:02 +0200
Message-Id: <20201112155513.411604-8-ciorneiioana@gmail.com>
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

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/lxt.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index fec58ad69e02..716d9936bc90 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -37,6 +37,8 @@
 
 #define MII_LXT970_ISR       18  /* Interrupt Status Register */
 
+#define MII_LXT970_IRS_MINT  BIT(15)
+
 #define MII_LXT970_CONFIG    19  /* Configuration Register    */
 
 /* ------------------------------------------------------------------------- */
@@ -47,6 +49,7 @@
 #define MII_LXT971_IER_IEN	0x00f2
 
 #define MII_LXT971_ISR		19  /* Interrupt Status Register */
+#define MII_LXT971_ISR_MASK	0x00f0
 
 /* register definitions for the 973 */
 #define MII_LXT973_PCR 16 /* Port Configuration Register */
@@ -81,6 +84,33 @@ static int lxt970_config_intr(struct phy_device *phydev)
 		return phy_write(phydev, MII_LXT970_IER, 0);
 }
 
+static irqreturn_t lxt970_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	/* The interrupt status register is cleared by reading BMSR
+	 * followed by MII_LXT970_ISR
+	 */
+	irq_status = phy_read(phydev, MII_BMSR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_status = phy_read(phydev, MII_LXT970_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_LXT970_IRS_MINT))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lxt970_config_init(struct phy_device *phydev)
 {
 	return phy_write(phydev, MII_LXT970_CONFIG, 0);
@@ -105,6 +135,24 @@ static int lxt971_config_intr(struct phy_device *phydev)
 		return phy_write(phydev, MII_LXT971_IER, 0);
 }
 
+static irqreturn_t lxt971_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_LXT971_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_LXT971_ISR_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 /*
  * A2 version of LXT973 chip has an ERRATA: it randomly return the contents
  * of the previous even register when you read a odd register regularly
@@ -239,6 +287,7 @@ static struct phy_driver lxt97x_driver[] = {
 	.config_init	= lxt970_config_init,
 	.ack_interrupt	= lxt970_ack_interrupt,
 	.config_intr	= lxt970_config_intr,
+	.handle_interrupt = lxt970_handle_interrupt,
 }, {
 	.phy_id		= 0x001378e0,
 	.name		= "LXT971",
@@ -246,6 +295,7 @@ static struct phy_driver lxt97x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt	= lxt971_ack_interrupt,
 	.config_intr	= lxt971_config_intr,
+	.handle_interrupt = lxt971_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-- 
2.28.0

