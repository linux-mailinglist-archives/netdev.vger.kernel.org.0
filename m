Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89F62B0942
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgKLP7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbgKLP6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:37 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F801C0617A6;
        Thu, 12 Nov 2020 07:58:36 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cq7so6862638edb.4;
        Thu, 12 Nov 2020 07:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRj8kGX7s7SWFRxtrV/mPs1BTo8dFHEN4BaCHQWnYmQ=;
        b=pUZkhamB3UDP4y1yRLxxo8fo/wUnYQ1KGoozgaEN91Du3bLl3lbR9yngsaecATSE92
         yJYh0BcSf9/g9GASTVltcLg/ydJYnBYsiJSHsVab5+bgE9ovjoNGAdnjgEXdpbJ3Qid3
         THvfvHM0AYl1JSZDLUQqYw2+iX23Px5va22OjFC0pqK/unEDY0xY8vBZl3gN80ntOKG/
         ROccObgrlW5H/089ubAYy3/ydnyGB/W8jd3BHF1t5l+f+U3K0nfvCs6B0cBHlH3P9Z4S
         aeju7qu8xTTkJmWl0KICsETtwhAfUEMLWJDDf+FxyxnfbYl2HKgKYPmTNd65etEmMVbp
         WIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRj8kGX7s7SWFRxtrV/mPs1BTo8dFHEN4BaCHQWnYmQ=;
        b=Z0PGT6BXE0WspMhvFAksQIz+gJK+zB2M7w+7yKV3gKO2eY+rlMu+A9jYTt9+vIf9dz
         vycXng2buJhVjfpaaLm2Xh92To003PTHk/j+04RGEi8880VmBxdM8hqm0LrhG9T6t0iE
         VkNA71TskygnJDb0mUX+UhDXz6waZpEImdR2yvbZLccNqmgucLG2pbb2e0uGlT7elyTd
         DhFXJCyw9sLeqw0vmdRTVJ0S25ivGt/43fF6BwC3w/2X1B7BX/0Da07sEmsxdNbc86cg
         pXq/McXVrEWxfUe3xFoCp8VZlny+CrechPdPP3FC6sy+NNVZwalExYX/kyI6gwem10hk
         5uTA==
X-Gm-Message-State: AOAM531Q41FjN2EWIIeC5IQ6b4nFb1pKfsxTGG4dy//kIjmR3JqS8Bm7
        iPw8wLHLmoNPLo/K/aLQk10=
X-Google-Smtp-Source: ABdhPJy8dpiboZp+qrbhLEGasMh0ODgyxflitttu9jZP9F0YI3212mgY2aC7P662Pr5sCotfCnYDoA==
X-Received: by 2002:a05:6402:22c6:: with SMTP id dm6mr397606edb.139.1605196715324;
        Thu, 12 Nov 2020 07:58:35 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:34 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 15/18] net: phy: ste10Xp: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:10 +0200
Message-Id: <20201112155513.411604-16-ciorneiioana@gmail.com>
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
 drivers/net/phy/ste10Xp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/ste10Xp.c b/drivers/net/phy/ste10Xp.c
index d735a01380ed..9f315332e0f2 100644
--- a/drivers/net/phy/ste10Xp.c
+++ b/drivers/net/phy/ste10Xp.c
@@ -76,6 +76,24 @@ static int ste10Xp_ack_interrupt(struct phy_device *phydev)
 	return 0;
 }
 
+static irqreturn_t ste10Xp_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_XCIIS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_XIE_DEFAULT_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static struct phy_driver ste10xp_pdriver[] = {
 {
 	.phy_id = STE101P_PHY_ID,
@@ -85,6 +103,7 @@ static struct phy_driver ste10xp_pdriver[] = {
 	.config_init = ste10Xp_config_init,
 	.ack_interrupt = ste10Xp_ack_interrupt,
 	.config_intr = ste10Xp_config_intr,
+	.handle_interrupt = ste10Xp_handle_interrupt,
 	.suspend = genphy_suspend,
 	.resume = genphy_resume,
 }, {
@@ -95,6 +114,7 @@ static struct phy_driver ste10xp_pdriver[] = {
 	.config_init = ste10Xp_config_init,
 	.ack_interrupt = ste10Xp_ack_interrupt,
 	.config_intr = ste10Xp_config_intr,
+	.handle_interrupt = ste10Xp_handle_interrupt,
 	.suspend = genphy_suspend,
 	.resume = genphy_resume,
 } };
-- 
2.28.0

