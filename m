Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D206CAB58
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjC0RDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjC0RCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4905247
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cOrixxE3tHqyXa3Nr2dzz5PGH4IoWRQNe61+BCFhrog=; b=TbwJyS2gBt0FtaLH9NRmWfx7Lk
        bgpDGMXpRs7hjGdJ4pv4+OuLFKy82FsxVMU4oCrCW9bfqWy5mjUqhqDu46dCbzTK1cKKvw4Pa2MtO
        +XXGfHMNIt/ZAYGUez5GFtNINaaxBkXtkIgS+BpzVksRf1HIJtErD/FCuyqXo/kDlsIM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008Xrp-Ti; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 11/23] net: FEC: Fixup EEE
Date:   Mon, 27 Mar 2023 19:01:49 +0200
Message-Id: <20230327170201.2036708-12-andrew@lunn.ch>
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
fec_enet_adjust_link() which gets called by phylib when there is a
change in link status.

fec_enet_set_eee() now just stores away the LTI timer value.
Everything else is passed to phylib, so it can correctly setup the
PHY.

fec_enet_get_eee() relies on phylib doing most of the work,
the MAC driver just adds the LTI timer value.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Only call fec_enet_eee_mode_set for those that support EEE
---
 drivers/net/ethernet/freescale/fec_main.c | 28 ++++-------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 462755f5d33e..fda1f9ff32b9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1930,18 +1930,13 @@ static int fec_enet_us_to_tx_cycle(struct net_device *ndev, int us)
 	return us * (fep->clk_ref_rate / 1000) / 1000;
 }
 
-static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
+static int fec_enet_eee_mode_set(struct net_device *ndev, bool eee_active)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct ethtool_eee *p = &fep->eee;
 	unsigned int sleep_cycle, wake_cycle;
-	int ret = 0;
-
-	if (enable) {
-		ret = phy_init_eee(ndev->phydev, false);
-		if (ret)
-			return ret;
 
+	if (eee_active) {
 		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
 		wake_cycle = sleep_cycle;
 	} else {
@@ -1949,10 +1944,6 @@ static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
 		wake_cycle = 0;
 	}
 
-	p->tx_lpi_enabled = enable;
-	p->eee_enabled = enable;
-	p->eee_active = enable;
-
 	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
 	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
 
@@ -1997,6 +1988,8 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 			netif_tx_unlock_bh(ndev);
 			napi_enable(&fep->napi);
 		}
+		if (fep->quirks & FEC_QUIRK_HAS_EEE)
+			fec_enet_eee_mode_set(ndev, phy_dev->eee_active);
 	} else {
 		if (fep->link) {
 			napi_disable(&fep->napi);
@@ -3109,10 +3102,7 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	if (!netif_running(ndev))
 		return -ENETDOWN;
 
-	edata->eee_enabled = p->eee_enabled;
-	edata->eee_active = p->eee_active;
 	edata->tx_lpi_timer = p->tx_lpi_timer;
-	edata->tx_lpi_enabled = p->tx_lpi_enabled;
 
 	return phy_ethtool_get_eee(ndev->phydev, edata);
 }
@@ -3122,7 +3112,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct ethtool_eee *p = &fep->eee;
-	int ret = 0;
 
 	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
 		return -EOPNOTSUPP;
@@ -3132,15 +3121,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 
 	p->tx_lpi_timer = edata->tx_lpi_timer;
 
-	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
-	    !edata->tx_lpi_timer)
-		ret = fec_enet_eee_mode_set(ndev, false);
-	else
-		ret = fec_enet_eee_mode_set(ndev, true);
-
-	if (ret)
-		return ret;
-
 	return phy_ethtool_set_eee(ndev->phydev, edata);
 }
 
-- 
2.39.2

