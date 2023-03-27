Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326566CAB55
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjC0RDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjC0RCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E2C4EF7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aaMEyB/T5u8BtwRY2FG9AMNvWgS93E+JmUo3WB29QhM=; b=zmdS+fwVDO/0ToOL1LZJ6TQPuo
        jrex2udTuE/3HwKqWJE/SEteKRaT2t1Vm5UhVom/GwDC4bWNV21xhXmdiY/aORngixHxtpcIe2+Uz
        jFpFdkubAsDCdqXGM9CRPxqWSFJ3bDXC0xX44p+haZCYy/hKFfkDoBFsfXzHyTgkjD2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008Xqt-Oe; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 09/23] net: lan743x: Fixup EEE
Date:   Mon, 27 Mar 2023 19:01:47 +0200
Message-Id: <20230327170201.2036708-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
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
lan743x_phy_link_status_change() which gets called by phylib when
there is a change in link status.

lan743x_ethtool_set_eee() now just programs the hardware with the LTI
timer value, and passed everything else to phylib, so it can correctly
setup the PHY.

lan743x_ethtool_get_eee() relies on phylib doing most of the work, the
MAC driver just adds the LTI timer value.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 22 -------------------
 drivers/net/ethernet/microchip/lan743x_main.c |  7 ++++++
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 2db5949b4c7e..da2f1110e0db 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1073,16 +1073,10 @@ static int lan743x_ethtool_get_eee(struct net_device *netdev,
 
 	buf = lan743x_csr_read(adapter, MAC_CR);
 	if (buf & MAC_CR_EEE_EN_) {
-		eee->eee_enabled = true;
-		eee->eee_active = !!(eee->advertised & eee->lp_advertised);
-		eee->tx_lpi_enabled = true;
 		/* EEE_TX_LPI_REQ_DLY & tx_lpi_timer are same uSec unit */
 		buf = lan743x_csr_read(adapter, MAC_EEE_TX_LPI_REQ_DLY_CNT);
 		eee->tx_lpi_timer = buf;
 	} else {
-		eee->eee_enabled = false;
-		eee->eee_active = false;
-		eee->tx_lpi_enabled = false;
 		eee->tx_lpi_timer = 0;
 	}
 
@@ -1095,7 +1089,6 @@ static int lan743x_ethtool_set_eee(struct net_device *netdev,
 	struct lan743x_adapter *adapter;
 	struct phy_device *phydev;
 	u32 buf = 0;
-	int ret = 0;
 
 	if (!netdev)
 		return -EINVAL;
@@ -1112,23 +1105,8 @@ static int lan743x_ethtool_set_eee(struct net_device *netdev,
 	}
 
 	if (eee->eee_enabled) {
-		ret = phy_init_eee(phydev, false);
-		if (ret) {
-			netif_err(adapter, drv, adapter->netdev,
-				  "EEE initialization failed\n");
-			return ret;
-		}
-
 		buf = (u32)eee->tx_lpi_timer;
 		lan743x_csr_write(adapter, MAC_EEE_TX_LPI_REQ_DLY_CNT, buf);
-
-		buf = lan743x_csr_read(adapter, MAC_CR);
-		buf |= MAC_CR_EEE_EN_;
-		lan743x_csr_write(adapter, MAC_CR, buf);
-	} else {
-		buf = lan743x_csr_read(adapter, MAC_CR);
-		buf &= ~MAC_CR_EEE_EN_;
-		lan743x_csr_write(adapter, MAC_CR, buf);
 	}
 
 	return phy_ethtool_set_eee(phydev, eee);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 957d96a91a8a..7986f8fcf7d3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1457,6 +1457,13 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		    phydev->interface == PHY_INTERFACE_MODE_1000BASEX ||
 		    phydev->interface == PHY_INTERFACE_MODE_2500BASEX)
 			lan743x_sgmii_config(adapter);
+
+		data = lan743x_csr_read(adapter, MAC_CR);
+		if (phydev->eee_active)
+			data |=  MAC_CR_EEE_EN_;
+		else
+			data &= ~MAC_CR_EEE_EN_;
+		lan743x_csr_write(adapter, MAC_CR, data);
 	}
 }
 
-- 
2.39.2

