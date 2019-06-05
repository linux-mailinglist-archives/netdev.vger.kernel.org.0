Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629FE35DF1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfFENan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:30:43 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:55070 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727601AbfFENal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:30:41 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 81918C0134;
        Wed,  5 Jun 2019 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559741420; bh=9O0qDkRZ0SDrdNmNU4oaIDKn7YlKE6oSo3JyRP//AOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=kOAXK4kus5PLEY950QcjuRBu405hVvqDIXbRyZNpRQKhxgVMGZPH0uyG2PDhwZODc
         q0MN3db+VTbqvmDDKXobr1+B7+SqpTvDmxkPjChlMqEnjc3SSQLmdujKfxY31AT29k
         9nuPh+eFZRLGuNgdwlBMo+V27VbyyNxyInFyavx6jcCdqn/xpcUKMquN8jTjEihYg8
         3JHMi/gMW8fjBQKFLk93FoQdmNwhYvxgLpNOnCrOj3lEGPvNfqtPDssrem3PHx1e4t
         IQfW4dQz8P54lN+chliCyUmyLDk/8Q3df3UUMGbyAaHb1iyXEl0kjzTteJ3u4PsMM/
         kYY/zp8FDv9bw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 52F75A0235;
        Wed,  5 Jun 2019 13:30:39 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id EFDA43FEC9;
        Wed,  5 Jun 2019 15:30:38 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [RFC net-next 1/2] net: stmmac: Prepare to convert to phylink
Date:   Wed,  5 Jun 2019 15:30:28 +0200
Message-Id: <95af9cb02da5fdfc30967df9f291c80ecb01524d.1559741195.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559741195.git.joabreu@synopsys.com>
References: <cover.1559741195.git.joabreu@synopsys.com>
In-Reply-To: <cover.1559741195.git.joabreu@synopsys.com>
References: <cover.1559741195.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the convertion, split the adjust_link function into
mac_config and add the mac_link_up and mac_link_down functions.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 113 ++++++++++++++--------
 1 file changed, 72 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 268af79e2632..6a2f072c0ce3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -848,6 +848,72 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
 			priv->pause, tx_cnt);
 }
 
+static void stmmac_mac_config(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	struct phy_device *phydev = dev->phydev;
+	u32 ctrl;
+
+	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+
+	if (phydev->speed != priv->speed) {
+		ctrl &= ~priv->hw->link.speed_mask;
+
+		switch (phydev->speed) {
+		case SPEED_1000:
+			ctrl |= priv->hw->link.speed1000;
+			break;
+		case SPEED_100:
+			ctrl |= priv->hw->link.speed100;
+			break;
+		case SPEED_10:
+			ctrl |= priv->hw->link.speed10;
+			break;
+		default:
+			netif_warn(priv, link, priv->dev,
+				   "broken speed: %d\n", phydev->speed);
+			phydev->speed = SPEED_UNKNOWN;
+			break;
+		}
+
+		if (phydev->speed != SPEED_UNKNOWN)
+			stmmac_hw_fix_mac_speed(priv);
+
+		priv->speed = phydev->speed;
+	}
+
+	/* Now we make sure that we can be in full duplex mode.
+	 * If not, we operate in half-duplex mode. */
+	if (phydev->duplex != priv->oldduplex) {
+		if (!phydev->duplex)
+			ctrl &= ~priv->hw->link.duplex;
+		else
+			ctrl |= priv->hw->link.duplex;
+
+		priv->oldduplex = phydev->duplex;
+	}
+
+	/* Flow Control operation */
+	if (phydev->pause)
+		stmmac_mac_flow_ctrl(priv, phydev->duplex);
+
+	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+}
+
+static void stmmac_mac_link_down(struct net_device *dev, bool autoneg)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	stmmac_mac_set(priv, priv->ioaddr, false);
+}
+
+static void stmmac_mac_link_up(struct net_device *dev, bool autoneg)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	stmmac_mac_set(priv, priv->ioaddr, true);
+}
+
 /**
  * stmmac_adjust_link - adjusts the link parameters
  * @dev: net device structure
@@ -869,47 +935,7 @@ static void stmmac_adjust_link(struct net_device *dev)
 	mutex_lock(&priv->lock);
 
 	if (phydev->link) {
-		u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
-
-		/* Now we make sure that we can be in full duplex mode.
-		 * If not, we operate in half-duplex mode. */
-		if (phydev->duplex != priv->oldduplex) {
-			new_state = true;
-			if (!phydev->duplex)
-				ctrl &= ~priv->hw->link.duplex;
-			else
-				ctrl |= priv->hw->link.duplex;
-			priv->oldduplex = phydev->duplex;
-		}
-		/* Flow Control operation */
-		if (phydev->pause)
-			stmmac_mac_flow_ctrl(priv, phydev->duplex);
-
-		if (phydev->speed != priv->speed) {
-			new_state = true;
-			ctrl &= ~priv->hw->link.speed_mask;
-			switch (phydev->speed) {
-			case SPEED_1000:
-				ctrl |= priv->hw->link.speed1000;
-				break;
-			case SPEED_100:
-				ctrl |= priv->hw->link.speed100;
-				break;
-			case SPEED_10:
-				ctrl |= priv->hw->link.speed10;
-				break;
-			default:
-				netif_warn(priv, link, priv->dev,
-					   "broken speed: %d\n", phydev->speed);
-				phydev->speed = SPEED_UNKNOWN;
-				break;
-			}
-			if (phydev->speed != SPEED_UNKNOWN)
-				stmmac_hw_fix_mac_speed(priv);
-			priv->speed = phydev->speed;
-		}
-
-		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+		stmmac_mac_config(dev);
 
 		if (!priv->oldlink) {
 			new_state = true;
@@ -922,6 +948,11 @@ static void stmmac_adjust_link(struct net_device *dev)
 		priv->oldduplex = DUPLEX_UNKNOWN;
 	}
 
+	if (phydev->link)
+		stmmac_mac_link_up(dev, false);
+	else
+		stmmac_mac_link_down(dev, false);
+
 	if (new_state && netif_msg_link(priv))
 		phy_print_status(phydev);
 
-- 
2.7.4

