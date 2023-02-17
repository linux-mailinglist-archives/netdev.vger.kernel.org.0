Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABC869A482
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjBQDnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBQDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676C510248
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S/Jx5gMwx/xTf99BMu4GouHv5wT2CqOdQODOmD1Tv4M=; b=gb70nzqO01fb66fyYsvA0OfMKI
        yqKgkYWpHNDK23ArFfmz2WG/RoIB25PVh2tD+5l3yx8wW3wXCtE5oTgIQbRZfKYA3jIKC6zTUfT5D
        D+ZfZnmxwDpKoCGY/0Tbr5xFazO5fmnffuAaOmkKX+dgboIlqc4pfVXyOXW7ZnRRAZJc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F79-Iw; Fri, 17 Feb 2023 04:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 18/18] net: usb: lan78xx: Fixup EEE
Date:   Fri, 17 Feb 2023 04:42:30 +0100
Message-Id: <20230217034230.1249661-19-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
MAC driver just adds the LTI timer value, and tx_lpi_enabled based on
if EEE is active.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/usb/lan78xx.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db..a06eac83cc01 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1690,16 +1690,11 @@ static int lan78xx_get_eee(struct net_device *net, struct ethtool_eee *edata)
 
 	ret = lan78xx_read_reg(dev, MAC_CR, &buf);
 	if (buf & MAC_CR_EEE_EN_) {
-		edata->eee_enabled = true;
-		edata->eee_active = !!(edata->advertised &
-				       edata->lp_advertised);
 		edata->tx_lpi_enabled = true;
 		/* EEE_TX_LPI_REQ_DLY & tx_lpi_timer are same uSec unit */
 		ret = lan78xx_read_reg(dev, EEE_TX_LPI_REQ_DLY, &buf);
 		edata->tx_lpi_timer = buf;
 	} else {
-		edata->eee_enabled = false;
-		edata->eee_active = false;
 		edata->tx_lpi_enabled = false;
 		edata->tx_lpi_timer = 0;
 	}
@@ -1721,24 +1716,16 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
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
@@ -2114,8 +2101,10 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 
 static void lan78xx_link_status_change(struct net_device *net)
 {
+	struct lan78xx_net *dev = netdev_priv(net);
 	struct phy_device *phydev = net->phydev;
 	int temp;
+	u32 data;
 
 	/* At forced 100 F/H mode, chip may fail to set mode correctly
 	 * when cable is switched between long(~50+m) and short one.
@@ -2142,6 +2131,13 @@ static void lan78xx_link_status_change(struct net_device *net)
 		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
 		phy_write(phydev, LAN88XX_INT_MASK, temp);
 	}
+
+	lan78xx_read_reg(dev, MAC_CR, &data);
+	if (phydev->eee_active)
+		data |=  MAC_CR_EEE_EN_;
+	else
+		data &= ~MAC_CR_EEE_EN_;
+	lan78xx_write_reg(dev, MAC_CR, data);
 }
 
 static int irq_map(struct irq_domain *d, unsigned int irq,
-- 
2.39.1

