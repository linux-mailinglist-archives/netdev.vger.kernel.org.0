Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4E6D146F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCaA4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCaAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3623F1043E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1/dbEsXqGx48zAli55PJOIiTxiYPYrEPuTGpZjjHHLI=; b=OjNq+Iv8jJis45LH3HPNEs3D3w
        iNPv+Dnw7OyUMU643v/u0bwSCIA5ro8o8QOu1Phk8YoaAPSSZme1+eO1Q/6JZppG3XnBHLxy4+g6L
        IV95vUWrC3qPeH1Ei4DAJUvrpr8K2TtuMBDI/ejKigyj/Vi4i/W7oVJvkSe0npC2svmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xLJ-V1; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 19/24] net: usb: lan78xx: Fixup EEE
Date:   Fri, 31 Mar 2023 02:55:13 +0200
Message-Id: <20230331005518.2134652-20-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enabling/disabling of EEE in the MAC should happen as a result of
auto negotiation. So move the enable/disable into
lan783xx_phy_link_status_change() which gets called by phylib when
there is a change in link status.

lan78xx_set_eee() now just programs the hardware with the LTI
timer value, and passed everything else to phylib, so it can correctly
setup the PHY.

lan743x_get_eee() relies on phylib doing most of the work, the
MAC driver just adds the LTI timer value.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v3: Fixup compiler error, missing read in read/modify/write.
---
 drivers/net/usb/lan78xx.c | 42 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index c458c030fadf..729183e57080 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1690,17 +1690,10 @@ static int lan78xx_get_eee(struct net_device *net, struct ethtool_eee *edata)
 
 	ret = lan78xx_read_reg(dev, MAC_CR, &buf);
 	if (buf & MAC_CR_EEE_EN_) {
-		edata->eee_enabled = true;
-		edata->eee_active = !!(edata->advertised &
-				       edata->lp_advertised);
-		edata->tx_lpi_enabled = true;
 		/* EEE_TX_LPI_REQ_DLY & tx_lpi_timer are same uSec unit */
 		ret = lan78xx_read_reg(dev, EEE_TX_LPI_REQ_DLY, &buf);
 		edata->tx_lpi_timer = buf;
 	} else {
-		edata->eee_enabled = false;
-		edata->eee_active = false;
-		edata->tx_lpi_enabled = false;
 		edata->tx_lpi_timer = 0;
 	}
 
@@ -1721,24 +1714,16 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 	if (ret < 0)
 		return ret;
 
-	if (edata->eee_enabled) {
-		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
-		buf |= MAC_CR_EEE_EN_;
-		ret = lan78xx_write_reg(dev, MAC_CR, buf);
-
-		phy_ethtool_set_eee(net->phydev, edata);
-
-		buf = (u32)edata->tx_lpi_timer;
-		ret = lan78xx_write_reg(dev, EEE_TX_LPI_REQ_DLY, buf);
-	} else {
-		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
-		buf &= ~MAC_CR_EEE_EN_;
-		ret = lan78xx_write_reg(dev, MAC_CR, buf);
-	}
+	ret = phy_ethtool_set_eee(net->phydev, edata);
+	if (ret < 0)
+		goto out;
 
+	buf = (u32)edata->tx_lpi_timer;
+	ret = lan78xx_write_reg(dev, EEE_TX_LPI_REQ_DLY, buf);
+out:
 	usb_autopm_put_interface(dev->intf);
 
-	return 0;
+	return ret;
 }
 
 static u32 lan78xx_get_link(struct net_device *net)
@@ -2114,7 +2099,20 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 
 static void lan78xx_link_status_change(struct net_device *net)
 {
+	struct lan78xx_net *dev = netdev_priv(net);
 	struct phy_device *phydev = net->phydev;
+	u32 data;
+	int ret;
+
+	ret = lan78xx_read_reg(dev, MAC_CR, &data);
+	if (ret < 0)
+		return;
+
+	if (phydev->eee_active)
+		data |=  MAC_CR_EEE_EN_;
+	else
+		data &= ~MAC_CR_EEE_EN_;
+	lan78xx_write_reg(dev, MAC_CR, data);
 
 	phy_print_status(phydev);
 }
-- 
2.40.0

