Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C903A1B98
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhFIRTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:19:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49868 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFIRTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:19:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lr1ps-00006c-7i; Wed, 09 Jun 2021 17:17:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: phy: realtek: net: Fix less than zero comparison of a u16
Date:   Wed,  9 Jun 2021 18:17:48 +0100
Message-Id: <20210609171748.298027-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparisons of the u16 values priv->phycr1 and priv->phycr2 to less
than zero always false because they are unsigned. Fix this by using an
int for the assignment and less than zero check.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 0a4355c2b7f8 ("net: phy: realtek: add dt property to disable CLKOUT clock")
Fixes: d90db36a9e74 ("net: phy: realtek: add dt property to enable ALDPS mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/realtek.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 1b844a06fe72..11be60333fa8 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -94,24 +94,25 @@ static int rtl821x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct rtl821x_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->phycr1 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
-	if (priv->phycr1 < 0)
-		return priv->phycr1;
+	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
+	if (ret < 0)
+		return ret;
 
-	priv->phycr1 &= (RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF);
+	priv->phycr1 = ret & (RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF);
 	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
 		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
 
-	priv->phycr2 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
-	if (priv->phycr2 < 0)
-		return priv->phycr2;
+	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
+	if (ret < 0)
+		return ret;
 
-	priv->phycr2 &= RTL8211F_CLKOUT_EN;
+	priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
 	if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
 		priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
 
-- 
2.31.1

