Return-Path: <netdev+bounces-11800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 638F37347AD
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1961C20983
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3CABA2B;
	Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B006A941
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80966194
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=4ke+QQmHQPw5LFwbK921i86qja8urvg0T31Eynh8D9E=; b=JlXwzMKBlNL5dy1tICaDoLutS6
	GVf8uwLxjS7URWx/wZKCXkSaKQlXTUQ0HfBUjZ31sgNLTiR+cXjqewUpKdYKhDtmuGyhH5gBUZsHq
	SsrVGrp1Dq4/ZWKv/AQqvx++W63xjoBKZQwsjtoqyyw2rJROTKvh3LclZlRSUzLZf9gc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr3U-OG; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 9/9] net: fec: Fixup EEE
Date: Sun, 18 Jun 2023 20:41:19 +0200
Message-Id: <20230618184119.4017149-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230618184119.4017149-1-andrew@lunn.ch>
References: <20230618184119.4017149-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The enabling/disabling of EEE in the MAC should happen as a result of
auto negotiation. So move the enable/disable into
fec_enet_adjust_link() which gets called by phylib when there is a
change in link status.

fec_enet_set_eee() now just stores away the LPI timer value.
Everything else is passed to phylib, so it can correctly setup the
PHY.

fec_enet_get_eee() relies on phylib doing most of the work,
the MAC driver just adds the LPI timer value.

Call phy_support_eee() if the quirk is present to indicate the MAC
actually supports EEE.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Only call fec_enet_eee_mode_set for those that support EEE
---
 drivers/net/ethernet/freescale/fec_main.c | 27 +++++------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 69c62e49c7e6..7b83a4a544cc 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1920,13 +1920,8 @@ static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct ethtool_eee *p = &fep->eee;
 	unsigned int sleep_cycle, wake_cycle;
-	int ret = 0;
 
 	if (enable) {
-		ret = phy_init_eee(ndev->phydev, false);
-		if (ret)
-			return ret;
-
 		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
 		wake_cycle = sleep_cycle;
 	} else {
@@ -1934,10 +1929,6 @@ static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
 		wake_cycle = 0;
 	}
 
-	p->tx_lpi_enabled = enable;
-	p->eee_enabled = enable;
-	p->eee_active = enable;
-
 	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
 	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
 
@@ -1982,6 +1973,8 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 			netif_tx_unlock_bh(ndev);
 			napi_enable(&fep->napi);
 		}
+		if (fep->quirks & FEC_QUIRK_HAS_EEE)
+			fec_enet_eee_mode_set(ndev, phy_dev->enable_tx_lpi);
 	} else {
 		if (fep->link) {
 			napi_disable(&fep->napi);
@@ -2340,6 +2333,9 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	else
 		phy_set_max_speed(phy_dev, 100);
 
+	if (fep->quirks & FEC_QUIRK_HAS_EEE)
+		phy_support_eee(phy_dev);
+
 	fep->link = 0;
 	fep->full_duplex = 0;
 
@@ -3096,10 +3092,7 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	if (!netif_running(ndev))
 		return -ENETDOWN;
 
-	edata->eee_enabled = p->eee_enabled;
-	edata->eee_active = p->eee_active;
 	edata->tx_lpi_timer = p->tx_lpi_timer;
-	edata->tx_lpi_enabled = p->tx_lpi_enabled;
 
 	return phy_ethtool_get_eee(ndev->phydev, edata);
 }
@@ -3109,7 +3102,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct ethtool_eee *p = &fep->eee;
-	int ret = 0;
 
 	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
 		return -EOPNOTSUPP;
@@ -3119,15 +3111,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 
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
2.40.1


