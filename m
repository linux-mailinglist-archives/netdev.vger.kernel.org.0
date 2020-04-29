Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41FB1BE7A3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgD2TrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgD2Tqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8CDC03C1AE;
        Wed, 29 Apr 2020 12:46:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v2so1217978plp.9;
        Wed, 29 Apr 2020 12:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mtGk2U0KpShp/95WB0t8JGG8XT1WcH0CeNOC8w7hdtY=;
        b=a3JIQrMrO2WRZP3wpeD3OcCemq5I129sg4PSWw90j6I8A9mh37U+rTezP2xX/AapPS
         VheMGjMxgK1bZ8n3ctcVmt8w+xGwZZKMPWPFaADOWLgoLtfhCpl5JqWd/vIis4F8NB6y
         zue0/KQHeQ6FajaNX5/FumEnaEd94WOcrpVT8m2whJ3oV+JU0KsploRWa/GkXkwz9tCl
         Kw0fTeeuRSBlhGjESEdTMDjr1F3unewr2CxhdhZuveXi+Hk079N8qAQRX1EA98Wd1OY/
         UQwPoCawgwIc1CMtrASALQd+wUbM2Pt7FCfUdgUFIr1qlokNittgi5lTApewk/xFowdu
         NuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mtGk2U0KpShp/95WB0t8JGG8XT1WcH0CeNOC8w7hdtY=;
        b=OKs7glRotP8eb/B2tujblFzJ7Cd7j5Ek2sPUwSyNgcaV8RBf8Mew7k9NhVdu9gDOJR
         2G2SbNq5fCQ9Ey3bwJUiFKv9ihZ3abDQYFyvlzwow7DQTE8TY3mtKPOrPYOdEU+7qHC8
         MAAyDBFAuflyapgGqDOVQgHtf1Iksm2tY8oSUOTU3L5Vtu3n0WpFT3IsZkNIRoWbxERk
         iaFrROenuVzjJwMG+vusleaFHYDbJn9/dhElFjeVaU9zTCWKhLizRDA9+sz02cmrYdz7
         A6Rw7gxgyMk3bXE4j8GgeFZmZSe2Sq70SGfMMeQ/IheXS1CG4zmY/WmFF8J4VYxCjZOv
         uXJQ==
X-Gm-Message-State: AGi0PuZnFIP+5VBMmPpZYEl7uFkCvNgLQeOy61NSJ4U9+kVFE0G8Y32m
        lNB0Q8iSEqNlR6/mdL86v34=
X-Google-Smtp-Source: APiQypKTrsnAhRIhIHOarUvx7Z8JxbNDqsCLNxsdCwSX2cplTQODuXj9ByUPVL82SNqTsqYvWb5IMg==
X-Received: by 2002:a17:90b:34c:: with SMTP id fh12mr83219pjb.134.1588189601528;
        Wed, 29 Apr 2020 12:46:41 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:41 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Doug Berger <doug.berger@broadcom.com>
Subject: [PATCH net-next 3/7] net: bcmgenet: move clk_wol management to bcmgenet_wol
Date:   Wed, 29 Apr 2020 12:45:48 -0700
Message-Id: <1588189552-899-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <doug.berger@broadcom.com>

The GENET_POWER_WOL_MAGIC power up and power down code configures
the device for WoL when suspending and disables the WoL logic when
resuming. It makes sense that this code should also manage the WoL
clocking.

This commit consolidates the logic and moves it earlier in the
resume sequence.

Since the clock is now only enabled if WoL is successfully entered
the wol_active flag is introduced to track that state to keep the
clock enables and disables balanced in case a suspend is aborted.
The MPD_EN hardware bit can't be used because it can be cleared
when the MAC is reset by a deep sleep.
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 19 +++++++------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  3 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 14 +++++++++++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index eb0dd4d4800c..57b8608feae1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET (Gigabit Ethernet) controller driver
  *
- * Copyright (c) 2014-2019 Broadcom
+ * Copyright (c) 2014-2020 Broadcom
  */
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
@@ -3619,6 +3619,10 @@ static int bcmgenet_resume(struct device *d)
 	if (ret)
 		return ret;
 
+	/* From WOL-enabled suspend, switch to regular clock */
+	if (device_may_wakeup(d) && priv->wolopts)
+		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
+
 	/* If this is an internal GPHY, power it back on now, before UniMAC is
 	 * brought out of reset as absolutely no UniMAC activity is allowed
 	 */
@@ -3629,10 +3633,6 @@ static int bcmgenet_resume(struct device *d)
 
 	init_umac(priv);
 
-	/* From WOL-enabled suspend, switch to regular clock */
-	if (priv->wolopts)
-		clk_disable_unprepare(priv->clk_wol);
-
 	phy_init_hw(dev->phydev);
 
 	/* Speed settings must be restored */
@@ -3650,9 +3650,6 @@ static int bcmgenet_resume(struct device *d)
 		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
 	}
 
-	if (priv->wolopts)
-		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3702,12 +3699,10 @@ static int bcmgenet_suspend(struct device *d)
 		phy_suspend(dev->phydev);
 
 	/* Prepare the device for Wake-on-LAN and switch to the slow clock */
-	if (device_may_wakeup(d) && priv->wolopts) {
+	if (device_may_wakeup(d) && priv->wolopts)
 		ret = bcmgenet_power_down(priv, GENET_POWER_WOL_MAGIC);
-		clk_prepare_enable(priv->clk_wol);
-	} else if (priv->internal_phy) {
+	else if (priv->internal_phy)
 		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
-	}
 
 	/* Turn off the clocks */
 	clk_disable_unprepare(priv->clk);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index c3bfe97f2e5c..a858b7305832 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2014-2017 Broadcom
+ * Copyright (c) 2014-2020 Broadcom
  */
 
 #ifndef __BCMGENET_H__
@@ -678,6 +678,7 @@ struct bcmgenet_priv {
 	struct clk *clk_wol;
 	u32 wolopts;
 	u8 sopass[SOPASS_MAX];
+	bool wol_active;
 
 	struct bcmgenet_mib_counters mib;
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 597c0498689a..da45a4645b94 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET (Gigabit Ethernet) Wake-on-LAN support
  *
- * Copyright (c) 2014-2017 Broadcom
+ * Copyright (c) 2014-2020 Broadcom
  */
 
 #define pr_fmt(fmt)				"bcmgenet_wol: " fmt
@@ -155,6 +155,9 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	netif_dbg(priv, wol, dev, "MPD WOL-ready status set after %d msec\n",
 		  retries);
 
+	clk_prepare_enable(priv->clk_wol);
+	priv->wol_active = 1;
+
 	/* Enable CRC forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = 1;
@@ -183,9 +186,14 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 		return;
 	}
 
+	if (!priv->wol_active)
+		return;	/* failed to suspend so skip the rest */
+
+	priv->wol_active = 0;
+	clk_disable_unprepare(priv->clk_wol);
+
+	/* Disable Magic Packet Detection */
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	if (!(reg & MPD_EN))
-		return;	/* already powered up so skip the rest */
 	reg &= ~(MPD_EN | MPD_PW_EN);
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
-- 
2.7.4

