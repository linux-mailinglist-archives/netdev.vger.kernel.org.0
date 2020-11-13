Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19ABA2B20F5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMQxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgKMQxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:03 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8544DC0613D1;
        Fri, 13 Nov 2020 08:53:02 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id me8so14421325ejb.10;
        Fri, 13 Nov 2020 08:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2XY8ttvdIFiCYz29ukEUuH1Xm19QPYXW7DIh+FSk/8=;
        b=ehH8Si/mvbYCdsxzZQi2rM0jGAzlYnjQ0aQvYHJZBhmxpTxkeJPo5sW9bOCczJwc1P
         Kby9pQ8ajPVBLr+fHf8KNRJYsrfQo0PTjVjCZ7zbqgHYKKPJ911CcIBAJA0Tn3Ox93Dn
         n7yLHv8KQHWq64SkPdyNb+pHuX0EDdUCAzRVjX1my3f9Du/6UTTeFe5NS8Ofvlzg9Rqn
         tWV31sFneqSDvyGph30xANuIv1Ip9YOWrptrvv8GFcpLaYED987S/PXwQDSlAvwC6nWw
         QU46+uDQH6rwd+vbJ9fUxmhfnE9edhFjYXk/WfnoLMEyZfeBz/U360f0PCI9RiLjOq19
         bCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2XY8ttvdIFiCYz29ukEUuH1Xm19QPYXW7DIh+FSk/8=;
        b=TOMDfQC04LrbM2XJ9ENyVW2VhOzOuI1UxjaUhG54QrxtJfInK/G+LIvpiW2pyzAQ8g
         Oo0T6MMmQhJQjyzc9+SV8up0OvLgQLUUc53W+oOEnwwVUbjExMNxTrn6Qb4ufuNKcopv
         CY7QGsrJ4B5gfmEltGvl4bMrNzmMqGv1NJio3JWdZbhX9dKXzA5BBFKyPpNet8ZLdqzp
         lr9gc727OgO/BAdysTJLGb7DorYDzCnbpg+utDZkqE80y4ljf1nlFGExU1Zwcv+ncg0w
         E2vGmPRQUfXu9MBOxx0EXa/011P0fUuYSFzsy8xt04ikdPPki0uQi39ZFYHQa64BB/nc
         BF8w==
X-Gm-Message-State: AOAM53037oYZk1j0AJ2aOGCgBMLeYW3ZIAZmTwa/RU3/CnVuk5fXKfu2
        qZzCypBgIE2fU78q86GnLTE=
X-Google-Smtp-Source: ABdhPJwxgCC3PEVb/7JXrhR44g1s/vQkG0wg5Gf9wmqYKL+OqA20NfDAYc/7Y2cdHjKJxIbxNbABOg==
X-Received: by 2002:a17:906:3a55:: with SMTP id a21mr2734205ejf.357.1605286376415;
        Fri, 13 Nov 2020 08:52:56 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:55 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH RESEND net-next 07/18] net: phy: lxt: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:15 +0200
Message-Id: <20201113165226.561153-8-ciorneiioana@gmail.com>
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

