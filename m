Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553621BE80C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgD2UCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgD2UCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7307EC03C1AE;
        Wed, 29 Apr 2020 13:02:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f7so1587277pfa.9;
        Wed, 29 Apr 2020 13:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SYWum3ZnYsfLSG0jDSyn5h0VUobSFoO/qhOlaCswZZY=;
        b=kASBbSG2Y+m0qJObDTSTlmTSkZyk0AhBnwpoKMvM1AO3HtMws3K+EBeAANoqC+Wr95
         eRvbfwJTjDHFsPEfvVx2ZTJgEufX7iSaO+48GOeAl1+fPTvxBVUKXDKdoFkrxuXWl9mC
         XZHivxeGvDC2slGQGIQKk9b6oSDwm/NqanBRq42bKf1fJ3YTl734Ldu/4nmLQxnAjvC6
         Lgif7O9E8JKZpEOZ9ESqtCP2cJ4d4DN/jj9OcWQ73qsP12y5kl2FcMoJrto5N8xf3Yam
         lwa5jxeLYaeG7KTvNfarmtUfbfTsrLsCKnxg1mToMWmSC8u3Y6XEgmIDvK2WI/5GTiNo
         2/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SYWum3ZnYsfLSG0jDSyn5h0VUobSFoO/qhOlaCswZZY=;
        b=j+wAgXPX27Yn9kkWIPRLg564X0WNrSNnexFir10G1YYiThSMeGOMQ4Tx44z1+QMuHq
         msUmYCUPJhVllAEHuMOLXZoxF9wGTmT+XNkKJER8lcu3KkJHHdQ7pYU5SneWV4Nd7bYb
         uP2HhTe1C2f7NKgOfUDLPXGCLaG/ECOOjSCuUxzLoxJ3tOJz0C1/xu49lZ5Ga50CJU7R
         mntmZulD+u8MYqCuUGA8WrnioY603H8Q5bA7Qe7Ko42wjLaPGQco972cj34nXaSEPx2q
         vSuu08MhWwGkQx2A2kjp0uV0z8diFni2MkdnMaayj1gVIfldnDviQS2D9qjHwKB1s3oK
         xbSw==
X-Gm-Message-State: AGi0PuZlKgmsZZZ13vvdQgtZ3DppT7apNV4acZRGOLqffRLUS3PA8Wmu
        kOojAxt8kleK/INxJrm+ThY=
X-Google-Smtp-Source: APiQypJP3S9G2ZKqVVgcQlJkrH+KBcIg8Ek96iKCoB8qUyX9E4lyvZnHqhtRiIzaIPRdDm0v5H1+bQ==
X-Received: by 2002:a63:1e5a:: with SMTP id p26mr34551434pgm.233.1588190532963;
        Wed, 29 Apr 2020 13:02:12 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:12 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 2/7] net: bcmgenet: Fix WoL with password after deep sleep
Date:   Wed, 29 Apr 2020 13:02:01 -0700
Message-Id: <1588190526-2082-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Broadcom STB chips support a deep sleep mode where all register contents
are lost. Because we were stashing the MagicPacket password into some of
these registers a suspend into that deep sleep then a resumption would
not lead to being able to wake-up from MagicPacket with password again.

Fix this by keeping a software copy of the password and program it
during suspend.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  2 ++
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 39 ++++++++++------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index daf8fb2c39b6..c3bfe97f2e5c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -14,6 +14,7 @@
 #include <linux/if_vlan.h>
 #include <linux/phy.h>
 #include <linux/dim.h>
+#include <linux/ethtool.h>
 
 /* total number of Buffer Descriptors, same for Rx/Tx */
 #define TOTAL_DESC				256
@@ -676,6 +677,7 @@ struct bcmgenet_priv {
 	/* WOL */
 	struct clk *clk_wol;
 	u32 wolopts;
+	u8 sopass[SOPASS_MAX];
 
 	struct bcmgenet_mib_counters mib;
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index c9a43695b182..597c0498689a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -41,18 +41,13 @@
 void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 reg;
 
 	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE;
 	wol->wolopts = priv->wolopts;
 	memset(wol->sopass, 0, sizeof(wol->sopass));
 
-	if (wol->wolopts & WAKE_MAGICSECURE) {
-		reg = bcmgenet_umac_readl(priv, UMAC_MPD_PW_MS);
-		put_unaligned_be16(reg, &wol->sopass[0]);
-		reg = bcmgenet_umac_readl(priv, UMAC_MPD_PW_LS);
-		put_unaligned_be32(reg, &wol->sopass[2]);
-	}
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, priv->sopass, sizeof(priv->sopass));
 }
 
 /* ethtool function - set WOL (Wake on LAN) settings.
@@ -62,7 +57,6 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
-	u32 reg;
 
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
@@ -70,17 +64,8 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE))
 		return -EINVAL;
 
-	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	if (wol->wolopts & WAKE_MAGICSECURE) {
-		bcmgenet_umac_writel(priv, get_unaligned_be16(&wol->sopass[0]),
-				     UMAC_MPD_PW_MS);
-		bcmgenet_umac_writel(priv, get_unaligned_be32(&wol->sopass[2]),
-				     UMAC_MPD_PW_LS);
-		reg |= MPD_PW_EN;
-	} else {
-		reg &= ~MPD_PW_EN;
-	}
-	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(priv->sopass, wol->sopass, sizeof(priv->sopass));
 
 	/* Flag the device and relevant IRQ as wakeup capable */
 	if (wol->wolopts) {
@@ -120,6 +105,14 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
 	return retries;
 }
 
+static void bcmgenet_set_mpd_password(struct bcmgenet_priv *priv)
+{
+	bcmgenet_umac_writel(priv, get_unaligned_be16(&priv->sopass[0]),
+			     UMAC_MPD_PW_MS);
+	bcmgenet_umac_writel(priv, get_unaligned_be32(&priv->sopass[2]),
+			     UMAC_MPD_PW_LS);
+}
+
 int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode)
 {
@@ -144,13 +137,17 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 	reg |= MPD_EN;
+	if (priv->wolopts & WAKE_MAGICSECURE) {
+		bcmgenet_set_mpd_password(priv);
+		reg |= MPD_PW_EN;
+	}
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Do not leave UniMAC in MPD mode only */
 	retries = bcmgenet_poll_wol_status(priv);
 	if (retries < 0) {
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-		reg &= ~MPD_EN;
+		reg &= ~(MPD_EN | MPD_PW_EN);
 		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 		return retries;
 	}
@@ -189,7 +186,7 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 	if (!(reg & MPD_EN))
 		return;	/* already powered up so skip the rest */
-	reg &= ~MPD_EN;
+	reg &= ~(MPD_EN | MPD_PW_EN);
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Disable CRC Forward */
-- 
2.7.4

