Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE962B20F4
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKMQxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgKMQxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:15 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1A2C0617A6;
        Fri, 13 Nov 2020 08:53:15 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t9so11472485edq.8;
        Fri, 13 Nov 2020 08:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRj8kGX7s7SWFRxtrV/mPs1BTo8dFHEN4BaCHQWnYmQ=;
        b=KJq9q/kdXRsrhvBiS0vVmLn9NOUaZvXxEgRajwcNbePCCFBhsUa0iQyBwEIsxkgP+m
         1Y2kpCki1NpgCxk2C/npdzsBH0ibwCjRjkENOJeOwE2qKLzpIiQeIwp+KImto0st9u5i
         TNrymWok3Vnm42UEgSTSP6gjOPla6rDzx/CydvtRMFF31+MUGYh5bABrXXgk58x350qk
         gYOlUmt2GrVhSSBzKu78oCXmpUeOpxucS+ODdpvvrOlLbalQK4LmB+J9jCHiV/yqfxz5
         CtMJq5yeJG46gnXj1VL1v6deowyEBoyEfNCCdhvxlogfl9XOuo3bW5RA4P3X8P7ShI/q
         i4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRj8kGX7s7SWFRxtrV/mPs1BTo8dFHEN4BaCHQWnYmQ=;
        b=sOxcYTQcEkVGl4jT6t9Fwerbaxm/H8Gv9ryyNeLTTIEh2BWJARab9C5SMhO843TkfK
         q/0NmRDWguYqMLRtXKU82TBidLJb7IbvI1/PY+IYTn57Zx4zuxr0yPfv6S/gnAJfjQsC
         3Kr3Bqud1heSC78G5Z7BGXihwR66RnQAoBwUmDbLLztT2z6p/IbdTpKVvc1T/Ye4GyD7
         hiynF1BhGO6vybS6QdiMOO5ObN1V2wbD/03se+Y1xd4mKN/SU6e1tUcfN4SAaHD3zSWE
         1A3GC52X065Euwp4KXhfTEvETHhj8Kns2ePHWucm1K8y9Pa+bj2WAUZBv42tWsI6Nlyh
         nG4g==
X-Gm-Message-State: AOAM530cf163w9oLtZIMTRx/6IK+PFQ9U+1oKtIDHfT9NfRESvfMvbcn
        PqAULa5WmK1y5iIoBrWkpIk=
X-Google-Smtp-Source: ABdhPJwp+Z+LZQtE8H02SuVcz5TQ7Zw7g5+8f6dxh+vlz2Eg1o/fsUFmy4QrnPl5Yza79RVTqOXtMw==
X-Received: by 2002:a50:d582:: with SMTP id v2mr3451357edi.218.1605286389308;
        Fri, 13 Nov 2020 08:53:09 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:08 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RESEND net-next 15/18] net: phy: ste10Xp: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:23 +0200
Message-Id: <20201113165226.561153-16-ciorneiioana@gmail.com>
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

