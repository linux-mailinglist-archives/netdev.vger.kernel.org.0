Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462C83264C4
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 10:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZPdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 10:33:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AECC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 07:32:18 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n20so15523896ejb.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 07:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lnWZd2hc36j/4DfctR+9nbXakMKG42PbHxUCqgGfZo=;
        b=Av77EkGccwO1H9NHaY8NLxSD1mt+GYALbSNR5kmxF9x4LSRw6IY/+aLLDzAtxU6zwt
         qUQmm50YQLUWGTYFO0q5Lv/SwzqYpJza5WG9G991xfLdYk6071VhoUJagolzkCslm8ID
         3sFDjxlneVMPvvKkHRmVFiY/uOqsL/Y6w3xVuC8rKztHSlNMXaFHRZSjCrd+pdlljkuA
         HBULhiAsA4UGctNqBkZee9NuN/qj1afR+C9IRx9mmf6mZFk7m6D4yx/bEeTufgpbXwEH
         KS7BJd09iFCx5fat0/k3fYBDpO2Z1jesDHUtpi1jpUBuFbMvXIxlsMYPZq9lXtPv0Idg
         ffag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lnWZd2hc36j/4DfctR+9nbXakMKG42PbHxUCqgGfZo=;
        b=trV7VUGeCBqFVNhLAKKnIjNUyMpX8PHJZKeBtWFBTvSsW1ctJhKplIq5oh1/vkQO2W
         U1B686+hSKYn24TiNnN4nPutPXImK9JiLrd5R2cnJYzwzmz/ur9j2zhpEaryvtaCM/Ab
         qMjca5891yT/MMuKGw3NTQxmmNFMrikHxlAhZ0mJQRVCc2wmwvogsRdlsjt0zA6yO0RT
         2mhm1Hmgddas3c/vLLw7b0NGD+VDNn+YXBaxKozrdIX9dxfbWkv9hqEwNPLsoFpS7vBJ
         CFMscX8+J2tcTddfDwhisdbOLwCsbiEwO11EDIeYMtT4fjAnuAr9DzZu5e7uWehWdRSY
         XwHw==
X-Gm-Message-State: AOAM533XEpMOUMGpyHAaOXBN3VHUbiGO67cXZfdozKqcAaSZMOXJl3Sq
        CQ5WrWTwmyngiEwH/A2XQfQ=
X-Google-Smtp-Source: ABdhPJwgmKdGdBCKt3lmBWDehrcuRbbfWH4SYSKzuWO3sKkjnNmTEd5rkd8xwO6nxY9nvaQHGrcQbw==
X-Received: by 2002:a17:906:145b:: with SMTP id q27mr4086172ejc.432.1614353537356;
        Fri, 26 Feb 2021 07:32:17 -0800 (PST)
Received: from yoga-910.localhost ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id g3sm6272167edk.75.2021.02.26.07.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 07:32:17 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sven Schuchmann <schuchmann@schleissheimer.de>
Subject: [PATCH net] net: phy: ti: take into account all possible interrupt sources
Date:   Fri, 26 Feb 2021 17:30:20 +0200
Message-Id: <20210226153020.867852-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The previous implementation of .handle_interrupt() did not take into
account the fact that all the interrupt status registers should be
acknowledged since multiple interrupt sources could be asserted.

Fix this by reading all the status registers before exiting with
IRQ_NONE or triggering the PHY state machine.

Fixes: 1d1ae3c6ca3f ("net: phy: ti: implement generic .handle_interrupt() callback")
Reported-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/dp83822.c   |  9 +++++----
 drivers/net/phy/dp83tc811.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index be1224b4447b..f7a2ec150e54 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -290,6 +290,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The MISR1 and MISR2 registers are holding the interrupt status in
@@ -305,7 +306,7 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83822_MISR2);
 	if (irq_status < 0) {
@@ -313,11 +314,11 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 688fadffb249..7ea32fb77190 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -264,6 +264,7 @@ static int dp83811_config_intr(struct phy_device *phydev)
 
 static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The INT_STAT registers 1, 2 and 3 are holding the interrupt status
@@ -279,7 +280,7 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT2);
 	if (irq_status < 0) {
@@ -287,7 +288,7 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT3);
 	if (irq_status < 0) {
@@ -295,11 +296,11 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.30.0

