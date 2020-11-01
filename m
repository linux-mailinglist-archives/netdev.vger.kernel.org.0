Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605FC2A1E17
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgKAMyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgKAMwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:40 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCD3C061A04;
        Sun,  1 Nov 2020 04:52:39 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id p9so14839530eji.4;
        Sun, 01 Nov 2020 04:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iS2wGb1rYfIGE8w7brWcF74JiOLpyjEsEgakNJwn5v0=;
        b=kS7X2DbaOiwv9etAyFTMigUQ1y/VS5v+4xWyu8s5wxQWHfTIu0lp0Py6d3CXEtrIWn
         GQlqJpkvYtI9i9wJ1+Jz/JuVrdxcwx9GnUzRGJKuodRqRblL03X5PGUl4I8nawSxrQLR
         MqRIJbYovGTZxtHrhoYQ7jsoH+zXN9fD0Yt3hOAMzq8pk3LnXo1gxpa34U064WEtUBwp
         OCBXDcCwlvbyzVIButRiqL1R062LdgMRlDbDrI11HBwNO6tht98kAKjeviM9LhIq61Nk
         kDy5+fWBDRLVOM3KCp4afbElLLL6VNzQ7oRH/5CyYQQ2ChvE89AeKF7tv9M3gZYEA/WF
         JekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iS2wGb1rYfIGE8w7brWcF74JiOLpyjEsEgakNJwn5v0=;
        b=Ig6Ztp6mR6y/35yQeY/zXoluHD8YjL+BFGFgFYgM33IvvPH6SL7KVO8aYB0Lrq+ISg
         s4R5OvpArV/eYMjakIC7i/D+5q6yYSO4WMabniYTAOuMxFJ++PMY/dG24n72MKo1ES+p
         QHhNn2zZWBJQ1BE3HyNo0VbbPsqC+7KS4xqK9acU9DentxLwc6lN2Tywofa3ogRJw/Lm
         JkUa18gKJoxMizqk10kj8NVdnX6T5NVRUwxXjFZJE8Y2TvhSfxDzrBJ3adG3XyEC5yd+
         +cWISpKewWpjSqU4XJK5y/fXd0MeZF416/akgQEHiEYU1MwuqMkkKJELtOMJaqu1jNo2
         UuRg==
X-Gm-Message-State: AOAM530ncOu2JS2hmxHgkF4ZfMhu5KRcqX9qtp6YKFrNqlF+8LkgCudk
        FNxxzH7vInOVj0Q9I0IRRzw=
X-Google-Smtp-Source: ABdhPJy99FS3u032T+Z3rZOIZJYY49V8abhQpynVvihRl5c8SCLWL8sm/yGvtZyTHg7Qsgdmu+7ubQ==
X-Received: by 2002:a17:906:519e:: with SMTP id y30mr10665225ejk.186.1604235157919;
        Sun, 01 Nov 2020 04:52:37 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:37 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 13/19] net: phy: cicada: implement the generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:51:08 +0200
Message-Id: <20201101125114.1316879-14-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Adjust .handle_interrupt() so that we only take into account the
   enabled IRQs.

 drivers/net/phy/cicada.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/cicada.c
index 9d1612a4d7e6..086c62ff5293 100644
--- a/drivers/net/phy/cicada.c
+++ b/drivers/net/phy/cicada.c
@@ -96,6 +96,24 @@ static int cis820x_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t cis820x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_CIS8201_ISTAT);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_CIS8201_IMASK_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 /* Cicada 8201, a.k.a Vitesse VSC8201 */
 static struct phy_driver cis820x_driver[] = {
 {
@@ -106,6 +124,7 @@ static struct phy_driver cis820x_driver[] = {
 	.config_init	= &cis820x_config_init,
 	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
+	.handle_interrupt = &cis820x_handle_interrupt,
 }, {
 	.phy_id		= 0x000fc440,
 	.name		= "Cicada Cis8204",
@@ -114,6 +133,7 @@ static struct phy_driver cis820x_driver[] = {
 	.config_init	= &cis820x_config_init,
 	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
+	.handle_interrupt = &cis820x_handle_interrupt,
 } };
 
 module_phy_driver(cis820x_driver);
-- 
2.28.0

