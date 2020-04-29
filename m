Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17511BE7A2
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgD2Tqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Tql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26381C035493;
        Wed, 29 Apr 2020 12:46:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so1204184pjh.2;
        Wed, 29 Apr 2020 12:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SYWum3ZnYsfLSG0jDSyn5h0VUobSFoO/qhOlaCswZZY=;
        b=iL3Ls+ntdFBJSjM2bz4+YHeg0DtHnqRps2YE/2gubNg47g6xnBXNRsH7UEdK2CwbYc
         BZbsUS9Ur46sWQMrxPugSeBTNjQbbSr7TBTs252Un2gEZC/jZ/ICfLtkSoCAu+rbcBsq
         AXP0PupEUGvlvUVeX5y7yJIZnYwd7oKaCaQREx/CTiztv6yRv/1CTKOw5a7h8HAiW3GL
         HI+Qc87V1ADL563zV2ePO8ta/uRuHrWE1OtDAvb7cpfEkob3W2qjxe3SSt7jgce5hYjj
         fS9dAshk3BTAtAChEdh9lsEdMnrRgqVs2YGDZ1FQ7w1poF3UiQYqiJZmALJESvDN6xWu
         uRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SYWum3ZnYsfLSG0jDSyn5h0VUobSFoO/qhOlaCswZZY=;
        b=CAfdc+Snu+ssXrgHrXnAdNE7SE63vR4QQFcu/FphXJdSG1uuxZj7cVk5WOhsCBGfcA
         kH8lt1HuTjPfBBsJdYY2tO+KYDAd1EAPydguN9kl45LgZ6ov2XcHT+JO/8hmbJcy2w7z
         R9SGxTrlqkLxGl41pXgaSEqJe8Ad8iFgSoKy7mE/sbZ8Ysyac7cyBNcpw7/7o4Z0ObUB
         dIbsT3RM2V/6vJBc2mzA55SXH9B1YiHOkJ65UR3fIKGxFUhjGcnnGx01TXGaXAdvHjN7
         5mtwH69fFL2cQtnuOdt2zeA91o965KhHpkz2ewjmkFigv1TSJvzLd2hysSqQg1Qg/J8g
         9xXw==
X-Gm-Message-State: AGi0PubMyltGfWlvtE80H7Sp5ap6shJl5cs4um3DoLu86oM7VsjwRqvT
        YlNdb1zeT6YxiTGLZ3cM/kvtjk6X
X-Google-Smtp-Source: APiQypJ6HXBv0gezNfvDGSDGYPMI8pGkgrgfYUAgvjp7KzVb+VfTCg0WHegHbU//y6EtteToUAU67Q==
X-Received: by 2002:a17:90a:3287:: with SMTP id l7mr84089pjb.126.1588189600675;
        Wed, 29 Apr 2020 12:46:40 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:40 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 2/7] net: bcmgenet: Fix WoL with password after deep sleep
Date:   Wed, 29 Apr 2020 12:45:47 -0700
Message-Id: <1588189552-899-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
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

