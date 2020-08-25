Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5CB251855
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgHYMNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:13:02 -0400
Received: from pd9568d8c.dip0.t-ipconnect.de ([217.86.141.140]:46701 "EHLO
        remote.esd.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726159AbgHYMNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:13:01 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2020 08:13:01 EDT
Received: from esd-s7 ([10.0.0.77]:49372 helo=esd-s7.esd)
        by remote.esd.eu with esmtp (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <daniel.gorsulowski@esd.eu>)
        id 1kAXjV-0008Rs-33; Tue, 25 Aug 2020 14:07:22 +0200
Received: from debby.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id D833B7C162F;
        Tue, 25 Aug 2020 14:07:21 +0200 (CEST)
X-CTCH-RefID: str=0001.0A682F19.5F44FEFA.0005,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From:   Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com,
        Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
Subject: [PATCH] net: dp83869: Fix RGMII internal delay configuration
Date:   Tue, 25 Aug 2020 14:07:21 +0200
Message-Id: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RGMII control register at 0x32 indicates the states for the bits
RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:

  RGMII Transmit/Receive Clock Delay
    0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
    0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.

This commit fixes the inversed behavior of these bits

Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")

Signed-off-by: Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
---
 drivers/net/phy/dp83869.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 58103152c601..3ad48673f865 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -427,18 +427,18 @@ static int dp83869_config_init(struct phy_device *phydev)
 			return ret;
 
 		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
-		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
+		val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
 			 DP83869_RGMII_RX_CLK_DELAY_EN);
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-			val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
+			val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
 				DP83869_RGMII_RX_CLK_DELAY_EN);
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
+			val &= ~DP83869_RGMII_TX_CLK_DELAY_EN;
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
+			val &= ~DP83869_RGMII_RX_CLK_DELAY_EN;
 
 		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL,
 				    val);
-- 
2.19.2

