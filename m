Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3052869A47A
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjBQDnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjBQDm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B815BB92
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=waYTpH7xzT+d9Vre098AMU+bvyjjZGWhg0/1S/e8Oh0=; b=XATibcZHXeDpEpIuxjOvIDREI9
        BaZQ7SQitK54CrWrs5hX7OJpGiJLoqthM6yRhufhVXonTiCaJYc5l7p6OvDHCVNIqCjad9Q/2puTC
        Lr0eJhUGGhLMTaEp45aXmLc/nIkYvh0NzXeM4zlA87cDof6WFBMXj0rlChYAMNJetDbg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6N-3r; Fri, 17 Feb 2023 04:42:44 +0100
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
Subject: [PATCH RFC 06/18] net: lan743x: Fixup EEE
Date:   Fri, 17 Feb 2023 04:42:18 +0100
Message-Id: <20230217034230.1249661-7-andrew@lunn.ch>
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
lan743x_phy_link_status_change() which gets called by phylib when
there is a change in link status.

lan743x_ethtool_set_eee() now just programs the hardware with the LTI
timer value, and passed everything else to phylib, so it can correctly
setup the PHY.

lan743x_ethtool_get_eee() relies on phylib doing most of the work, the
MAC driver just adds the LTI timer value, and tx_lpi_enabled based on
if EEE is active.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 20 -------------------
 drivers/net/ethernet/microchip/lan743x_main.c |  7 +++++++
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 2db5949b4c7e..044d67a564e0 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1073,15 +1073,11 @@ static int lan743x_ethtool_get_eee(struct net_device *netdev,
 
 	buf = lan743x_csr_read(adapter, MAC_CR);
 	if (buf & MAC_CR_EEE_EN_) {
-		eee->eee_enabled = true;
-		eee->eee_active = !!(eee->advertised & eee->lp_advertised);
 		eee->tx_lpi_enabled = true;
 		/* EEE_TX_LPI_REQ_DLY & tx_lpi_timer are same uSec unit */
 		buf = lan743x_csr_read(adapter, MAC_EEE_TX_LPI_REQ_DLY_CNT);
 		eee->tx_lpi_timer = buf;
 	} else {
-		eee->eee_enabled = false;
-		eee->eee_active = false;
 		eee->tx_lpi_enabled = false;
 		eee->tx_lpi_timer = 0;
 	}
@@ -1095,7 +1091,6 @@ static int lan743x_ethtool_set_eee(struct net_device *netdev,
 	struct lan743x_adapter *adapter;
 	struct phy_device *phydev;
 	u32 buf = 0;
-	int ret = 0;
 
 	if (!netdev)
 		return -EINVAL;
@@ -1112,23 +1107,8 @@ static int lan743x_ethtool_set_eee(struct net_device *netdev,
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
index 7e0871b631e4..803e83880887 100644
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
2.39.1

