Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D13123BF0
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLRAvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:52 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52486 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfLRAva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:30 -0500
Received: by mail-pj1-f67.google.com with SMTP id w23so49622pjd.2;
        Tue, 17 Dec 2019 16:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fCTHj12G+M+oIsAQ6yhmQ7Qk1y5dZl1KYqTEl/6R+Sg=;
        b=fbCiSFtYCJPgHlYavsvnPaltQBQgJTA9YysJkipxGAfk28wj2x0d8RyhUSLmyCnaZ1
         0FntiolGQfXEuZDm23fgBpWJgpGsI7m8FktGskLAydxokxGpUzQLiiambFxMg0e7Vm/F
         nCowGQnme040klIdyNTAF7ZqA35lpKxNkM9oOSePe4GBOdVCut+gBUSMxSxiinhqPch5
         sNBE2tR7/UxhBE0AwRNZYbIA5X0/vT8ycRVST0K5h6eFdFWCN7cBZiqhOz5OZhKDchBd
         S/GY23ofMg7X4/l3hwoGyiIJ0Fp0RFwyPdVOWELLF3II370l5l+OkoEULCII8n+kOeO+
         A4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fCTHj12G+M+oIsAQ6yhmQ7Qk1y5dZl1KYqTEl/6R+Sg=;
        b=s0QTwqw+w/8MUZxW8UZp03+NrQZ9F/bil1XHQs4pnpBjkoLXFb6UpGdagHoVHW/vbm
         T5h61YDRd3HZLgmbGYFRGBJlIgu8uwpnwJUh6JSFeQ6Xyf1zeoOhHYS/63D+Fjxt75z+
         oCNOC2YNgP/JwWX2SRoVUPfR9RGQdUe8z0LFrYKv7rbFouT7h7JWP61hMls4LrGc2gmH
         U46eSIukUoOvf5R1RvYalqWEcAmuYr+tmpuRRC0w9vdbD9PYsa+yB2xJHA/5OuN9AycE
         savcu7nZs7t4Y85l57NIZiRPAlpz5ffCj4D5NsXKxxX7G7zvKQeL/w0gVs7DR3jpzy81
         lHDA==
X-Gm-Message-State: APjAAAUjGL3UXYV4Dv5ZIUk7WlMzYxz3H0Sw4B6r0OD1YE1KlpMBmbjt
        LywsqwE9ckGf0bZ8j0ex8n0=
X-Google-Smtp-Source: APXvYqw7R14iRN1uZzAFinjzZOh3+ZENUAziYtOFEU3tIDRlliY37rT8j8adIwONHbUeFzO9ynQl9g==
X-Received: by 2002:a17:90a:6:: with SMTP id 6mr193048pja.71.1576630289852;
        Tue, 17 Dec 2019 16:51:29 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:29 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 4/8] net: bcmgenet: Refactor bcmgenet_set_features()
Date:   Tue, 17 Dec 2019 16:51:11 -0800
Message-Id: <1576630275-17591-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally enabling TX and RX checksum
offloads, refactor bcmgenet_set_features() a bit such that
__netdev_update_features() during register_netdev() can make sure
that features are correctly programmed during network device
registration.

Since we can now be called during register_netdev() with clocks
gated, we need to temporarily turn them on/off in order to have a
successful register programming.

We also move the CRC forward setting read into
bcmgenet_set_features() since priv->crc_fwd_en matters while
turning on RX checksum offload, that way we are guaranteed they
are in sync in case we ever add support for NETIF_F_RXFCS at some
point in the future.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 38 +++++++++++++-------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 13cbe5828adb..811713e3d230 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -508,8 +508,8 @@ static int bcmgenet_set_link_ksettings(struct net_device *dev,
 	return phy_ethtool_ksettings_set(dev->phydev, cmd);
 }
 
-static int bcmgenet_set_rx_csum(struct net_device *dev,
-				netdev_features_t wanted)
+static void bcmgenet_set_rx_csum(struct net_device *dev,
+				 netdev_features_t wanted)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 rbuf_chk_ctrl;
@@ -535,12 +535,10 @@ static int bcmgenet_set_rx_csum(struct net_device *dev,
 		rbuf_chk_ctrl &= ~RBUF_SKIP_FCS;
 
 	bcmgenet_rbuf_writel(priv, rbuf_chk_ctrl, RBUF_CHK_CTRL);
-
-	return 0;
 }
 
-static int bcmgenet_set_tx_csum(struct net_device *dev,
-				netdev_features_t wanted)
+static void bcmgenet_set_tx_csum(struct net_device *dev,
+				 netdev_features_t wanted)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	bool desc_64b_en;
@@ -563,21 +561,27 @@ static int bcmgenet_set_tx_csum(struct net_device *dev,
 
 	bcmgenet_tbuf_ctrl_set(priv, tbuf_ctrl);
 	bcmgenet_rbuf_writel(priv, rbuf_ctrl, RBUF_CTRL);
-
-	return 0;
 }
 
 static int bcmgenet_set_features(struct net_device *dev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
-	netdev_features_t wanted = dev->wanted_features;
-	int ret = 0;
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	u32 reg;
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Make sure we reflect the value of CRC_CMD_FWD */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
 
-	if (changed & NETIF_F_HW_CSUM)
-		ret = bcmgenet_set_tx_csum(dev, wanted);
-	if (changed & (NETIF_F_RXCSUM))
-		ret = bcmgenet_set_rx_csum(dev, wanted);
+	bcmgenet_set_tx_csum(dev, features);
+	bcmgenet_set_rx_csum(dev, features);
+
+	clk_disable_unprepare(priv->clk);
 
 	return ret;
 }
@@ -2880,10 +2884,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	init_umac(priv);
 
-	/* Make sure we reflect the value of CRC_CMD_FWD */
-	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
-
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
-- 
2.7.4

