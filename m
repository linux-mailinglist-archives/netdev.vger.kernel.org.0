Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D004185F0
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 05:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhIZDXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 23:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhIZDXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 23:23:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527B9C061570;
        Sat, 25 Sep 2021 20:21:37 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23so9841378pji.0;
        Sat, 25 Sep 2021 20:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XqjYGyqWuP2MM36ccVq5VIFVuxmx+6QGWJMXwqZHo/o=;
        b=c+A+0TU/ktP6gJOiXqNszuxW5QbNTIqMPhqdsHusiFhf+fkuCvTCe8zLcDrI1F9efS
         dVXklevgjASX8UAtkanHr6ZBi11DJLp39OcFyigcSs2R5BfT9kq8lbgyOpU5uKYeBK/N
         jq6D5Sh0QK+FOtcg8rvYjIMnj4PlSSv7hC4t0FPKYwZUSci7Ko5Rn5AImer7kkkHFAsr
         /Lww1xIgRz6p6wtzOQ9thKNqS2RSh64OJW3N3JZbzCsB3gJ/vuK8jXFX9x3ZPi1nRLVd
         tTALbr3t5kLZvOeSPY9a71t508rxED3oi/Z7OQrFfmxYwaG0i5avZdzrivU60NiXHC57
         KBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XqjYGyqWuP2MM36ccVq5VIFVuxmx+6QGWJMXwqZHo/o=;
        b=3hma83W7GRv64mzRHhMgdxXIQaXXL1UltYHGBxi8G1aM/DCaiqkHrWYDyD71oeNof6
         Y7TgnnPVXbhsh9htg6VsUuibHfWdz2haSc0JS0NW1EtrZi2wAn+XpQbFczHbFBQGn61L
         bIYcHI4TCCG1mzZy51ffrU/YGdAYXdCULE6LR20LVXi1lt8/Xwn2RAJkXl7o2NipbEMe
         zLtQmKAmYoWzkRyCWIQ/Xt6hhcfwnzWIpIv6Q3yrnNfce9Oag+se1EntLhZQ9FSoMwTL
         3gth9RucEIeGlLgSXYid0AxjPbVqry1A1p24ZDtP1KLbfqKI2qrYU+ziJ9gB3hxlMguO
         4nyg==
X-Gm-Message-State: AOAM531Ki7vQsfCDDqhTkm3tNGL8op+a9e+kNd/OaK+q+gvlamIrVUyw
        yCaknDtvPk1R9aTJGDoyRiwR3I5vewM=
X-Google-Smtp-Source: ABdhPJw8rfdviCau2dt+oiqUm6UixbJS5rBrZ/9PvDDP+oLFiJCiscbAtxgxp5eb64pGQLQJfPQzpQ==
X-Received: by 2002:a17:90a:514e:: with SMTP id k14mr11693258pjm.154.1632626496552;
        Sat, 25 Sep 2021 20:21:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm14205312pgl.90.2021.09.25.20.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 20:21:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/4] net: bcmgenet: pull mac_config from adjust_link
Date:   Sat, 25 Sep 2021 20:21:13 -0700
Message-Id: <20210926032114.1785872-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926032114.1785872-1-f.fainelli@gmail.com>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

This commit separates out the MAC configuration that occurs on a
PHY state change into a function named bcmgenet_mac_config().

This allows the function to be called directly elsewhere.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 94 ++++++++++----------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 8fce5878a7d9..789ca6212817 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -25,59 +25,63 @@
 
 #include "bcmgenet.h"
 
-/* setup netdev link state when PHY link status change and
- * update UMAC and RGMII block when link up
- */
-void bcmgenet_mii_setup(struct net_device *dev)
+static void bcmgenet_mac_config(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
 	u32 reg, cmd_bits = 0;
 
-	if (phydev->link) {
-		/* speed */
-		if (phydev->speed == SPEED_1000)
-			cmd_bits = CMD_SPEED_1000;
-		else if (phydev->speed == SPEED_100)
-			cmd_bits = CMD_SPEED_100;
-		else
-			cmd_bits = CMD_SPEED_10;
-		cmd_bits <<= CMD_SPEED_SHIFT;
-
-		/* duplex */
-		if (phydev->duplex != DUPLEX_FULL)
-			cmd_bits |= CMD_HD_EN;
-
-		/* pause capability */
-		if (!phydev->pause)
-			cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
-
-		/*
-		 * Program UMAC and RGMII block based on established
-		 * link speed, duplex, and pause. The speed set in
-		 * umac->cmd tell RGMII block which clock to use for
-		 * transmit -- 25MHz(100Mbps) or 125MHz(1Gbps).
-		 * Receive clock is provided by the PHY.
-		 */
-		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-		reg &= ~OOB_DISABLE;
-		reg |= RGMII_LINK;
-		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
-
-		reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-		reg &= ~((CMD_SPEED_MASK << CMD_SPEED_SHIFT) |
-			       CMD_HD_EN |
-			       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
-		reg |= cmd_bits;
-		if (reg & CMD_SW_RESET) {
-			reg &= ~CMD_SW_RESET;
-			bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-			udelay(2);
-			reg |= CMD_TX_EN | CMD_RX_EN;
-		}
+	/* speed */
+	if (phydev->speed == SPEED_1000)
+		cmd_bits = CMD_SPEED_1000;
+	else if (phydev->speed == SPEED_100)
+		cmd_bits = CMD_SPEED_100;
+	else
+		cmd_bits = CMD_SPEED_10;
+	cmd_bits <<= CMD_SPEED_SHIFT;
+
+	/* duplex */
+	if (phydev->duplex != DUPLEX_FULL)
+		cmd_bits |= CMD_HD_EN;
+
+	/* pause capability */
+	if (!phydev->pause)
+		cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
+
+	/* Program UMAC and RGMII block based on established
+	 * link speed, duplex, and pause. The speed set in
+	 * umac->cmd tell RGMII block which clock to use for
+	 * transmit -- 25MHz(100Mbps) or 125MHz(1Gbps).
+	 * Receive clock is provided by the PHY.
+	 */
+	reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
+	reg &= ~OOB_DISABLE;
+	reg |= RGMII_LINK;
+	bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	reg &= ~((CMD_SPEED_MASK << CMD_SPEED_SHIFT) |
+		       CMD_HD_EN |
+		       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
+	reg |= cmd_bits;
+	if (reg & CMD_SW_RESET) {
+		reg &= ~CMD_SW_RESET;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		udelay(2);
+		reg |= CMD_TX_EN | CMD_RX_EN;
 	}
+	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+}
+
+/* setup netdev link state when PHY link status change and
+ * update UMAC and RGMII block when link up
+ */
+void bcmgenet_mii_setup(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
 
+	if (phydev->link)
+		bcmgenet_mac_config(dev);
 	phy_print_status(phydev);
 }
 
-- 
2.25.1

