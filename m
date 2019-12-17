Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA349123851
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfLQVEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:04:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33380 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfLQVD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so3121143wmd.0;
        Tue, 17 Dec 2019 13:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fSUWXakASxcG8jM5XmWMHJ/oz4Kt5+UVWCiun2B1998=;
        b=Pyfnlm1MgePaptkY5iNr5orCz+53W7l4S0FaB/OcdJ4Ytc8zlPvzu2axf8pUzLn5WM
         NSeJWGaPDOJcgvAt9jdxB9E5Tryhv+AhpjfR5+9S4HfE9X0I3ICCTRlHfUotnV5jRyp0
         CozbyCwcQVir1sWSqPU3N4iE3x3R4En2VPLkayuItmYnHH0xrmrktZ52MIYNftnK2snT
         GxIRqCTQ+9Unq1yEEQPalZt+AOvl01+6DaRx31MUlXISqffaQpjNzTFCfpzVxE84w07p
         ddOsrTq2ix6okP3LbaihhcKD8uyK2tyw3BZQniUt2qheSiZ5WOK406PcYa/+HcL7rdx9
         FwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fSUWXakASxcG8jM5XmWMHJ/oz4Kt5+UVWCiun2B1998=;
        b=LRfxh5mEx79iu6dto5pxYif6yRo3o3ZzcqgoljZh2mJVEJfm7h+R5Ave6E1zMxbKgQ
         4pOY4Iua7/AKGACraTztz7A6/YZL8f4ndTh0iJMNcOfmkF9KvFmgQAFVu8AkKOySl8MR
         DZUE/8I+Nj6X+Ov69ay7HlVrB5EyXM+pnDXAlAw8EmoP7Y4QaoUEsZVdnqbungWG99B+
         gng7jZvaCuX/Q0oOiQSqWUsL61OElM/cIaubQGxvzGrxvW0xW2lOdEUrcOn5y4fNSNt5
         zixGxfkSn22RWBYXcCm6Xy/CKeQKKw5KfSYfAxfPpIxvTUYvfUr9Y3I5+m/rHaRcDJna
         tjtg==
X-Gm-Message-State: APjAAAXB7d6BP1N4sQaFx/ieiisQNzzECEfMltw5ULf7JLHHt6R2P6VB
        1zlXzG7Q4Lyj11KxaGfN4EzqK8PJ
X-Google-Smtp-Source: APXvYqwWbkWnoF+qAPy1RDpUSqSNPuqhzf1UIsscW57ZV0Bi/8Qk6Ygl5GQ9shfP6iFVebsjV7dQmA==
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr7454394wml.176.1576616604786;
        Tue, 17 Dec 2019 13:03:24 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:24 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 4/8] net: bcmgenet: Refactor bcmgenet_set_features()
Date:   Tue, 17 Dec 2019 13:02:25 -0800
Message-Id: <1576616549-39097-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
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
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 38 +++++++++++++-------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5674dc304032..8afa675b45da 100644
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
@@ -2878,10 +2882,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	init_umac(priv);
 
-	/* Make sure we reflect the value of CRC_CMD_FWD */
-	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
-
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
-- 
2.7.4

