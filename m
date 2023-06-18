Return-Path: <netdev+bounces-11794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 294337347A7
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ABF41C208A5
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C3879FC;
	Sun, 18 Jun 2023 18:41:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C639979C2
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:45 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC01139
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=if/n0lYWckOaL9Pm4SRy18In1h5gGzetUt4qsWtWPeg=; b=u7wYK4dYtgj4UTx4/UOqz5+R/o
	98zSmseGSStqFfELEZ2MmcLxavOY1JmoyY+xVT3MIFl8bJAVsyUGeOCuxPUlOq20pnDWUx++GES+4
	Ff5xQ7eCakiVXG9uotG5S/gkG0+Tlxtl0KfX4YwFDnkjxlM29RL4VR86pDuwAxv157g4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr3I-Kv; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 6/9] net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
Date: Sun, 18 Jun 2023 20:41:16 +0200
Message-Id: <20230618184119.4017149-7-andrew@lunn.ch>
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

The MAC driver changes its EEE hardware configuration in its
adjust_link callback. This is called when auto-neg
completes. Disabling EEE via eee_enabled false will trigger an
autoneg, and as a result the adjust_link callback will be called with
phydev->enable_tx_lpi set to false. Similarly, eee_enabled set to true
and with a change of advertised link modes will result in a new
autoneg, and a call the adjust_link call.

If set_eee is called with only a change to tx_lpi_enabled which does
not trigger an auto-neg, it is necessary to call the adjust_link
callback so that the MAC is reconfigured to take this change into
account.

When setting phydev->enable_tx_lpi, take both eee_enabled and
tx_lpi_enabled into account, so the MAC drivers just needs to act on
phydev->enable_tx_lpi and not the whole EEE configuration.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-c45.c | 11 ++++++++---
 drivers/net/phy/phy.c     | 25 ++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index d1d7cf34ac0b..7ddae1df9254 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1434,6 +1434,8 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
  * advertised, but the previously advertised link modes are
  * retained. This allows EEE to be enabled/disabled in a none
  * destructive way.
+ * Returns either error code, 0 if there was no change, or positive if
+ * there was a change which triggered auto-neg.
  */
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data)
@@ -1467,9 +1469,12 @@ int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 	ret = genphy_c45_an_config_eee_aneg(phydev);
 	if (ret < 0)
 		return ret;
-	if (ret > 0)
-		return phy_restart_aneg(phydev);
-
+	if (ret > 0) {
+		ret = phy_restart_aneg(phydev);
+		if (ret < 0)
+			return ret;
+		return 1;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(genphy_c45_ethtool_set_eee);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 48150d5626d8..830bca772f68 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -934,7 +934,8 @@ static int phy_check_link_status(struct phy_device *phydev)
 		if (err < 0)
 			phydev->enable_tx_lpi = false;
 		else
-			phydev->enable_tx_lpi = err;
+			phydev->enable_tx_lpi = (err & phydev->eee_cfg.tx_lpi_enabled);
+
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
 		phydev->state = PHY_NOLINK;
@@ -1606,6 +1607,21 @@ int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 }
 EXPORT_SYMBOL(phy_ethtool_get_eee);
 
+/* auto-neg not triggered, directly inform the MAC if something
+ * changed'
+ */
+static void phy_ethtool_set_eee_noneg(struct phy_device *phydev,
+				      struct ethtool_eee *data)
+{
+	if (phydev->eee_cfg.tx_lpi_enabled !=
+	    data->tx_lpi_enabled) {
+		eee_to_eeecfg(data, &phydev->eee_cfg);
+		phydev->enable_tx_lpi = eeecfg_mac_can_tx_lpi(&phydev->eee_cfg);
+		if (phydev->link)
+			phy_link_up(phydev);
+	}
+}
+
 /**
  * phy_ethtool_set_eee - set EEE supported and status
  * @phydev: target phy_device struct
@@ -1622,11 +1638,14 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 
 	mutex_lock(&phydev->lock);
 	ret = genphy_c45_ethtool_set_eee(phydev, data);
-	if (!ret)
+	if (ret >= 0) {
+		if (ret == 0)
+			phy_ethtool_set_eee_noneg(phydev, data);
 		eee_to_eeecfg(data, &phydev->eee_cfg);
+	}
 	mutex_unlock(&phydev->lock);
 
-	return ret;
+	return (ret < 0 ? ret : 0);
 }
 EXPORT_SYMBOL(phy_ethtool_set_eee);
 
-- 
2.40.1


