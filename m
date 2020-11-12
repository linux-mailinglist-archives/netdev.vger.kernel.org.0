Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313302B0959
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgKLQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgKLP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A55C0613D1;
        Thu, 12 Nov 2020 07:58:23 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so8617555ejk.2;
        Thu, 12 Nov 2020 07:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Dxgm0Fh4+mVDplG8D4f9NidT6Io7JYvUTeWlAV1zP4=;
        b=pyg5GqOmz/eBt9TQplvpB5pKmtX108W5DQ98evVzlZGHIuOOPKz7MlLYU7ITibYDul
         cIsCs+t0/67siqpQptpTEeRaUUWmSQp9Z6W18I6OowJsnFAsJklx+KtNphB4jUZy41PM
         Uol+zk3x8GoDED559iX+nt0JqMfpEk8ZOBfYtlYxGWxMjOQKEDIqAZcxVWO0+6mI8PMa
         pBTTUbc0JNyrbpLhQwq7BJUeqKjWPFANBYEjf6+jsHE5SVB4Tuon2f8tL7Dq4Jmm5/6J
         XBsNas7qt4DJtHj6BYRfhDVvnGtTcDaihmtlyxzVKoIX1+ikHPsnAsMuaI75/MP21Uhw
         4Q8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Dxgm0Fh4+mVDplG8D4f9NidT6Io7JYvUTeWlAV1zP4=;
        b=oNkiI/8U3zz+aOj/V3EkgxSmIiWhQKn2gIuifaRkoFObwV/Zzm5JgVgfLYoJCjukeT
         7+ejXqMMFh4+IItnL9pb4l2kCnOnQq0iXk/jXYs4gZtMZquz7pCdVU3aL9QxbO6Q8Eq/
         bBXuouiBv6180nkd4e552+GrbMRxny6L+ISFpGveN33tLcB6Zkp57H6JvlMczXiMU/Yh
         rRmXf37Hip+Li6nkvYRPCsYLmAV98YednswOKrKebd4lVO+jdFzBqUhuQ/NYc+cMxm9E
         F0J8NnfBBMSvAOx3upT4JtV5rUqIPxbRkOAUUgNLyMGK4Xjty5QIR65HZ82XlNpnMvAU
         dAcA==
X-Gm-Message-State: AOAM530pkbc6+3YZyiD3TCQGcykbQIW1m947GcGV0AX0nsycMnA8uKuF
        v/eA6W6ARy9re/wJMaSbjHs=
X-Google-Smtp-Source: ABdhPJz9i/npt4GaVeuZL2KAXR6GaACKnNYYjjQ2CsCXPOn2NNCjCOOu1dQ5mKgmyLBBUZ+6qN5r7A==
X-Received: by 2002:a17:906:43c7:: with SMTP id j7mr29430502ejn.397.1605196702351;
        Thu, 12 Nov 2020 07:58:22 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:21 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 05/18] net: phy: marvell: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:00 +0200
Message-Id: <20201112155513.411604-6-ciorneiioana@gmail.com>
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

Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/marvell.c | 57 ++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2563526bf4a6..bb843b960436 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -327,6 +327,24 @@ static int marvell_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_M1011_IEVENT);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_M1011_IMASK_INIT))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int marvell_set_polarity(struct phy_device *phydev, int polarity)
 {
 	int reg;
@@ -1659,18 +1677,6 @@ static int marvell_aneg_done(struct phy_device *phydev)
 	return (retval < 0) ? retval : (retval & MII_M1011_PHY_STATUS_RESOLVED);
 }
 
-static int m88e1121_did_interrupt(struct phy_device *phydev)
-{
-	int imask;
-
-	imask = phy_read(phydev, MII_M1011_IEVENT);
-
-	if (imask & MII_M1011_IMASK_INIT)
-		return 1;
-
-	return 0;
-}
-
 static void m88e1318_get_wol(struct phy_device *phydev,
 			     struct ethtool_wolinfo *wol)
 {
@@ -2699,6 +2705,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1101_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2717,6 +2724,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = marvell_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2738,6 +2746,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2759,6 +2768,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2779,6 +2789,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1118_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2798,7 +2809,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2820,7 +2831,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = genphy_resume,
@@ -2842,6 +2853,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = genphy_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2862,6 +2874,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1118_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2880,6 +2893,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = marvell_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2897,6 +2911,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1116r_config_init,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2919,7 +2934,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = marvell_resume,
@@ -2948,7 +2963,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2974,7 +2989,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2999,7 +3014,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3020,7 +3035,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3045,7 +3060,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3067,7 +3082,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
-- 
2.28.0

