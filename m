Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285EC1BE805
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgD2UCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8B3C03C1AE;
        Wed, 29 Apr 2020 13:02:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so1598211pfn.5;
        Wed, 29 Apr 2020 13:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J0qBpGmXm74u59PdUpmcex0+8Nx3UhOE65qV5C+byAc=;
        b=oBv2dCRzEE5SUc08jlC7HFjePmFYkPwvHD5/IS+AWIo5Hj3W/JNKm4rP5mho5lBsB0
         yl9eAAJP6pnHwI/qpAB33pJfXMJsoGpQxG9robXKJX4aYLBmp6g7oCNa2sSqSCfdpXg5
         PMzF9/3EZMEcNYOY3G24GSZhxJGKo6/DyWPlJ9ZCd4l1RUWT5IgCNk1OHB0ik6FuCDwr
         FJPmoyLSsZfHocKW0C9Bd+tTYLdrB0vKDph6TrOoaOIqPzyji5ev8cVrHqjbeFBeoMxa
         DIh1zSM+uPwTDAZfPAUVeGbQWolV3d/DcPDg/uVSMUFHQroQGA0zRnBPGoQbOlgLMLSs
         eScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J0qBpGmXm74u59PdUpmcex0+8Nx3UhOE65qV5C+byAc=;
        b=QaV/b9rKndJWphx5Oioop4OTbiBMUpoXIII3UJU2RlZMPIkTKiNZJa+YsvQGHJ5rIc
         6tRWnq8N4tXMJeoSpKl5hMviaelxNW2jUTmvIaHzJStOZmZAIJaJIjtLenUBGAT3mU/o
         emhRKyyVIn+78gLjPHZVXD8A1xLSvIBbcZhNpA6D3VKGhPf+6RQE0ctLQcnKvo3WW43/
         I3o+O2ubqwf8OiqdRjVHmBdAFLVXdHuKb31PAbmjDztbGD8974ebtyk1c0RMndEBmqot
         9RV7gdkYSANZWdNdP2Bbh+R/P/9PMI0+JmzD/iKxVvM3v7A3rzianeU0bz8LVxLl9h+q
         xZ3w==
X-Gm-Message-State: AGi0PubrXctt0YbH6sDnJPLgQqYlirtgzv7o32UT5A1+hd6LMbOqpcLi
        JrG7uYDrmH1w7+QtXNa3PtY=
X-Google-Smtp-Source: APiQypJ02vjbrOILMgQC4AbLSwF3UAynZxs7gBl64GfniTmi0cwobVQHC5GRqDIhX+xh2L7NOZPj9w==
X-Received: by 2002:a63:220a:: with SMTP id i10mr7162640pgi.364.1588190539755;
        Wed, 29 Apr 2020 13:02:19 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:18 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 7/7] net: bcmgenet: add WAKE_FILTER support
Date:   Wed, 29 Apr 2020 13:02:06 -0700
Message-Id: <1588190526-2082-8-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables support for the WAKE_FILTER method of Wake on
LAN for the GENET driver. The method can be enabled by adding 'f'
to the interface 'wol' setting specified by ethtool.

Rx network flow rules can be specified using ethtool. Rules that
define a flow-type with the RX_CLS_FLOW_WAKE action (i.e. -2) can
wake the system from the 'standby' power state when the WAKE_FILTER
WoL method is enabled.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  5 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 43 +++++++++++++++++-----
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5ef1ea7e5312..ad614d7201bd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -724,7 +724,7 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 		break;
 	}
 
-	if (!fs->ring_cookie) {
+	if (!fs->ring_cookie || fs->ring_cookie == RX_CLS_FLOW_WAKE) {
 		/* Ring 0 flows can be handled by the default Descriptor Ring
 		 * We'll map them to ring 0, but don't enable the filter
 		 */
@@ -1499,7 +1499,8 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (cmd->fs.ring_cookie > priv->hw_params->rx_queues) {
+	if (cmd->fs.ring_cookie > priv->hw_params->rx_queues &&
+	    cmd->fs.ring_cookie != RX_CLS_FLOW_WAKE) {
 		netdev_err(dev, "rxnfc: Unsupported action (%llu)\n",
 			   cmd->fs.ring_cookie);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index da45a4645b94..4b9d65f392c2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -42,7 +42,7 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
-	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE;
+	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
 	wol->wolopts = priv->wolopts;
 	memset(wol->sopass, 0, sizeof(wol->sopass));
 
@@ -61,7 +61,7 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
 
-	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE))
+	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER))
 		return -EINVAL;
 
 	if (wol->wolopts & WAKE_MAGICSECURE)
@@ -117,8 +117,9 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode)
 {
 	struct net_device *dev = priv->dev;
+	struct bcmgenet_rxnfc_rule *rule;
+	u32 reg, hfb_ctrl_reg, hfb_enable = 0;
 	int retries = 0;
-	u32 reg;
 
 	if (mode != GENET_POWER_WOL_MAGIC) {
 		netif_err(priv, wol, dev, "unsupported mode: %d\n", mode);
@@ -135,13 +136,24 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	mdelay(10);
 
-	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	reg |= MPD_EN;
-	if (priv->wolopts & WAKE_MAGICSECURE) {
-		bcmgenet_set_mpd_password(priv);
-		reg |= MPD_PW_EN;
+	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
+		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
+		reg |= MPD_EN;
+		if (priv->wolopts & WAKE_MAGICSECURE) {
+			bcmgenet_set_mpd_password(priv);
+			reg |= MPD_PW_EN;
+		}
+		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	}
+
+	hfb_ctrl_reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	if (priv->wolopts & WAKE_FILTER) {
+		list_for_each_entry(rule, &priv->rxnfc_list, list)
+			if (rule->fs.ring_cookie == RX_CLS_FLOW_WAKE)
+				hfb_enable |= (1 << rule->fs.location);
+		reg = (hfb_ctrl_reg & ~RBUF_HFB_EN) | RBUF_ACPI_EN;
+		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
 	}
-	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Do not leave UniMAC in MPD mode only */
 	retries = bcmgenet_poll_wol_status(priv);
@@ -149,6 +161,7 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 		reg &= ~(MPD_EN | MPD_PW_EN);
 		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+		bcmgenet_hfb_reg_writel(priv, hfb_ctrl_reg, HFB_CTRL);
 		return retries;
 	}
 
@@ -158,6 +171,13 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	clk_prepare_enable(priv->clk_wol);
 	priv->wol_active = 1;
 
+	if (hfb_enable) {
+		bcmgenet_hfb_reg_writel(priv, hfb_enable,
+					HFB_FLT_ENABLE_V3PLUS + 4);
+		hfb_ctrl_reg = RBUF_HFB_EN | RBUF_ACPI_EN;
+		bcmgenet_hfb_reg_writel(priv, hfb_ctrl_reg, HFB_CTRL);
+	}
+
 	/* Enable CRC forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = 1;
@@ -197,6 +217,11 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg &= ~(MPD_EN | MPD_PW_EN);
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
+	/* Disable WAKE_FILTER Detection */
+	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
+	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+
 	/* Disable CRC Forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
-- 
2.7.4

