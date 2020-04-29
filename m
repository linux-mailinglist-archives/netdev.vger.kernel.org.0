Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412CF1BE803
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgD2UCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1112DC03C1AE;
        Wed, 29 Apr 2020 13:02:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so1594435pfx.6;
        Wed, 29 Apr 2020 13:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ds8ghz/z0oHHp2naelmxlGEWoTQQpYGk6dQJe+ea0fA=;
        b=QrVTtIB0RMBXghkcxhf2NUQxtXuA2IlehvbTSV5bqnVj2k5m0koKMcPxTf0QRvd7xn
         NhczMSqBEGM/T4dDXC4Uu8Kkb8KEByLnevgE71f4t7ynH1rvbiNiCKpwDq/btlH2/SRu
         lMDfppMSZhKZpQlwYiQ4jwDWOK2f1vB2tOWBDQt9OM4nqzWB/D9v5Pwdr92JG+bIQftG
         nZ6vE70KjtC5dEpyqy+2MIHc8gkURdR+WNifVoqAvG4BXVstedJ84U3BFv1P412k0pMK
         Wt3L8JlpCwWSA7KQZEj6uZOqafkGHWAE6qxdB9OThgMMnyE67GRzOoUnaFEhTL1H+Uy5
         Atng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ds8ghz/z0oHHp2naelmxlGEWoTQQpYGk6dQJe+ea0fA=;
        b=C/AAOkcLLpimTi13KV/yUpJ9P0hF69euu7tDAc3j5GTObEzyvMAlblYK0ZbBWuAVq7
         uSKVS3LF+X9jmz/mpTeCNndoiABb2JIWxAoOq1MfE9t/KvLzsIIj2OSyErwcuKD2zwcY
         mtpQ2/i/ub4hE8kkw9nXU+ynlc2HDTWuqaMBCQcM/KkTw7Dhoge+RwCQ0cVoNhHW18Q/
         xVk6PVTyle+flAYzSnS0j1vUqo8Zh79PfdHr4hx1ynTZPUSlX/JGg+7iFrUXii2ZoaXc
         A15FMWc4yfO7HM6SXKiXKSaGM2lkkxcuVLLWkvvOMLuwk0ENS1o+/biP6R51ydwTFC6b
         8Eyg==
X-Gm-Message-State: AGi0PuaGeZ+fx8SP79ArcSwL9LSg2i5SVPTOwq/T2tuSBvwUeY/hgPyF
        velpPomLXI3c5crtI+kCCq8=
X-Google-Smtp-Source: APiQypKsZoHihciLLuJ5eJ19zmznYjgo/XaVwlsSS1iPdHt4AA/HtkQW1aYGOP635/iIw53j6R8o5Q==
X-Received: by 2002:a62:64cd:: with SMTP id y196mr33130930pfb.116.1588190534587;
        Wed, 29 Apr 2020 13:02:14 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:13 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 3/7] net: bcmgenet: move clk_wol management to bcmgenet_wol
Date:   Wed, 29 Apr 2020 13:02:02 -0700
Message-Id: <1588190526-2082-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Doug Berger <opendmb@gmail.com>
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

