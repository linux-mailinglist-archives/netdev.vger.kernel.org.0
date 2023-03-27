Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5186CAB57
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjC0RDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjC0RCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B095252
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e0m7j6SezYrBhtF/+cBMWZxzfiKdBjQQrISuhWpeZXE=; b=rL2lZFD4dqb5OC0lm+oafhOR46
        wSBeYwOFYPW7uJT/QFbcoVRBYLdKwGwyZXhO0HoiEMO+51pvoY42YJMr5slJahdIwSC5T3JYqSgak
        It3WhzGDokZqWTN77LVdAv5Z26hj6pk1ZBamGBv0gc36zY0rX/vyzHvOhyiZKg1yz8fA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008Xqd-KG; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 05/23] net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
Date:   Mon, 27 Mar 2023 19:01:43 +0200
Message-Id: <20230327170201.2036708-6-andrew@lunn.ch>
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

The MAC driver changes its EEE hardware configuration in its
adjust_link callback. This is called when auto-neg completes. If
set_eee is called with a change to tx_lpi_enabled which does not
trigger an auto-neg, it is necessary to call the adjust_link callback
so that the MAC is reconfigured to take this change into account.

When setting phydev->eee_active, take tx_lpi_enabled into account, so
the MAC drivers don't need to consider tx_lpi_enabled.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-c45.c | 11 ++++++++---
 drivers/net/phy/phy.c     | 15 ++++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index fee514b96ab1..84e859eae64b 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1431,6 +1431,8 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
  *
  * Description: it reportes the Supported/Advertisement/LP Advertisement
  * capabilities.
+ * Returns either error code, 0 if there was no change, or positive if
+ * there was a change which triggered auto-neg.
  */
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data)
@@ -1464,9 +1466,12 @@ int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
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
index 7d9205c3f235..b074ac5d1de1 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -933,7 +933,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 		if (err < 0)
 			phydev->eee_active = false;
 		else
-			phydev->eee_active = err;
+			phydev->eee_active = (err & phydev->tx_lpi_enabled);
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
 		phydev->state = PHY_NOLINK;
@@ -1619,11 +1619,20 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 
 	mutex_lock(&phydev->lock);
 	ret = genphy_c45_ethtool_set_eee(phydev, data);
-	if (!ret)
+	if (ret >= 0) {
+		if (ret == 0) {
+			/* auto-neg not triggered */
+			if (phydev->tx_lpi_enabled != data->tx_lpi_enabled) {
+				phydev->tx_lpi_enabled = data->tx_lpi_enabled;
+				if (phydev->link)
+					phy_link_up(phydev);
+			}
+		}
 		phydev->tx_lpi_enabled = data->tx_lpi_enabled;
+	}
 	mutex_unlock(&phydev->lock);
 
-	return ret;
+	return (ret < 0 ? ret : 0);
 }
 EXPORT_SYMBOL(phy_ethtool_set_eee);
 
-- 
2.39.2

