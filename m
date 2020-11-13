Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8620A2B20F1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKMQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgKMQxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:08 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25DCC0613D1;
        Fri, 13 Nov 2020 08:53:07 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v4so11484703edi.0;
        Fri, 13 Nov 2020 08:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkNqvIU4e2wqvsaKr1NdRBEHW1oOns68JPzxdKku3G4=;
        b=mDKbjeC6R2mL6u1kRwXL70w7RNiOOFwp5xGjOCupZ3r+sxzvuNL8HuksUzq7CH7vfE
         JZP++8tmvsDpWvhgpeP+YzNL98KZeeP9UWKVZyjC6bFFxp1I/E3nIJLkx1zYQuN/5V+S
         DfviGc65InThZMIXfuYhxX0xHiT8u3zuia7HFJasp/C1weCpAg3vfBnbEGGLTlOOPJt9
         GfxUNgghBIAhpG3kQIYxxIpDWQTigvWDDsQpY3TTGa5RUPG7kmlcQVE6VKp6lbKVI9Zs
         zGHJxAhAPwyphQr/vkN3fvbwFzHnXZwG3a+ldmq2noPzMfsW2Vlxir2nNvTn/EkxFH0Q
         naRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkNqvIU4e2wqvsaKr1NdRBEHW1oOns68JPzxdKku3G4=;
        b=bWklfDTJZiO7WX0boxSt2VBnujlSTRMIU7f5qUXwhtprEef4p38Ts6fWKVzC+3Qhtf
         15zt4AdJ8MltIC2NOPQ5iD4xQtEoaPzN/qgXr+CFwNRj3bivUEaYyFOTd/eD5OwB2WTC
         ar7s7vvC2h7DlDqiDXY/am2/Csv4fWj10hHGJvuR9BK3RuhLjS7g07llTdntInDV/zB5
         enRuw7uBFin7tTQXsMSk+2xQI2nQbjHdGewH8+oYk8mWiVXcvo0/nb1SfGjQNhKTNw3w
         fi89rTjxTgsMonZoFHO2T0+UK0ZFDPdCHICW9mOTzAA+wnqE9bgjRGHpjkS9Vr34m3ce
         3ZHA==
X-Gm-Message-State: AOAM530HdsYguTss2a7xjL/20+9CLQzq9mLdYBYSx14dXaEND9x1Y04g
        t8qFhRHcXGgkBhFE4xELsz8=
X-Google-Smtp-Source: ABdhPJwcJWdwg7uw6oiJ1zxe29FQpTgbM/olBmy9chhNTNIdZPX3q9naNIK1TT4876pBFSCWuxn87w==
X-Received: by 2002:aa7:df04:: with SMTP id c4mr3429393edy.25.1605286383281;
        Fri, 13 Nov 2020 08:53:03 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:02 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RESEND net-next 11/18] net: phy: amd: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:19 +0200
Message-Id: <20201113165226.561153-12-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/amd.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/amd.c b/drivers/net/phy/amd.c
index eef35f8c8d45..ae75d95c398c 100644
--- a/drivers/net/phy/amd.c
+++ b/drivers/net/phy/amd.c
@@ -20,6 +20,10 @@
 #define MII_AM79C_IR_EN_ANEG	0x0100	/* IR enable Aneg Complete */
 #define MII_AM79C_IR_IMASK_INIT	(MII_AM79C_IR_EN_LINK | MII_AM79C_IR_EN_ANEG)
 
+#define MII_AM79C_IR_LINK_DOWN	BIT(2)
+#define MII_AM79C_IR_ANEG_DONE	BIT(0)
+#define MII_AM79C_IR_IMASK_STAT	(MII_AM79C_IR_LINK_DOWN | MII_AM79C_IR_ANEG_DONE)
+
 MODULE_DESCRIPTION("AMD PHY driver");
 MODULE_AUTHOR("Heiko Schocher <hs@denx.de>");
 MODULE_LICENSE("GPL");
@@ -56,6 +60,24 @@ static int am79c_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t am79c_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_AM79C_IR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_AM79C_IR_IMASK_STAT))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static struct phy_driver am79c_driver[] = { {
 	.phy_id		= PHY_ID_AM79C874,
 	.name		= "AM79C874",
@@ -64,6 +86,7 @@ static struct phy_driver am79c_driver[] = { {
 	.config_init	= am79c_config_init,
 	.ack_interrupt	= am79c_ack_interrupt,
 	.config_intr	= am79c_config_intr,
+	.handle_interrupt = am79c_handle_interrupt,
 } };
 
 module_phy_driver(am79c_driver);
-- 
2.28.0

