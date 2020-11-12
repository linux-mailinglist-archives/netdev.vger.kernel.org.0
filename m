Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3117A2B092B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgKLP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbgKLP6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:32 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0CFC0613D1;
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so8618174ejk.2;
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkNqvIU4e2wqvsaKr1NdRBEHW1oOns68JPzxdKku3G4=;
        b=PGiFjk/VHNUF8u5h9TApysnZMoYVrG0jw4aPmONKw3Wu1naCQF8iafFqUx1WmdVO+l
         9Jje1OPwUBlnpmi70Yt67EbmTBvyRwbwMseWt1ymQMIqjtsFaA0eBgWBKBlJ7jeCYsSF
         ObXklZeekAkt/twzD5QnpRT2Aev/KmzmCqpZxmmeQxgRqbHMdnZU5hgpmv5UvvgS5iSn
         klRq0VbAkVm1Eyd5FlUeP/XAUdDE6ruoW8EM+jjDPTGWZI2pGyZivTu+0DUY/LiREAV6
         6PfAu64akHBboPV0CWcZG8EUywIIYu133PLX4f3gT0HXvSgJ2/+lNiL/x/Q9D+z1a2C2
         0uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkNqvIU4e2wqvsaKr1NdRBEHW1oOns68JPzxdKku3G4=;
        b=AUV/XTXOSm2ULi5+f79Iw7993wgraIE9Zn4wh+hXmNARKfA9PVBJUbXTYRjWN1NPmO
         KyTsZJsdKZgW8EFqmW/e3XJb4MUdpHigRW2gxiCvgo+AVJWKq/MzxTEZlETLQG0x+8IK
         OL14Jl8D0tvPelpl9gZdtHY4xfRWX4HiZldGvvl5M9hYhM4We49SJHPDgKAPPOPTCNBi
         ZMBpS4BRXNt/VkXUxVZfyOQIzF0njGnk3p4nkO/7vP4mIo1BtZLmBv/tboOU2yCGehf2
         jt0jWoRfzxsQRXsVC2CiETma05BI3if2HXGTRvWHeJLjD6mdO4Xoz1uxDA9560GYJxME
         1zDg==
X-Gm-Message-State: AOAM533OL88H/GIc557jEEbOwXLjBMzjkIJ3TtP+3Fya6excrccPzYIw
        n4i3HFjz1LcWdAiDO0OZVmg=
X-Google-Smtp-Source: ABdhPJxLBstO6oJvLi8vFDDkTa9R1ICv/irV2WOlV7y2XnRHTMGcUDO3Szw0JGj4Uu7whIrAxzwijg==
X-Received: by 2002:a17:906:f05:: with SMTP id z5mr14672273eji.8.1605196710426;
        Thu, 12 Nov 2020 07:58:30 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:29 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 11/18] net: phy: amd: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:06 +0200
Message-Id: <20201112155513.411604-12-ciorneiioana@gmail.com>
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

