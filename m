Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A812B6D1471
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjCaA4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCaAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C941B11144
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+533Q/Qe8nG30r/6OVIf8aM4XBgMlYrLzDC4nqWSFLw=; b=id96lhJQ/7IgBbx3a2zfJnZZ1g
        kXo3OVSKSIXDrIglmggmvhBYTPt/1alWivk2bb3On4Sb3w/89LY/MK+izsc/9ou7rhrKesUJ6Jhuq
        xyV8LFFbGxIWdtKTsa3xj1ewP50aQH3ReUV2BDNtkGJS+/JEylxFNmtFxdNs+JcLaRek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKP-Fl; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 05/24] net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
Date:   Fri, 31 Mar 2023 02:54:59 +0200
Message-Id: <20230331005518.2134652-6-andrew@lunn.ch>
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

The MAC driver changes its EEE hardware configuration in its
adjust_link callback. This is called when auto-neg completes. If
set_eee is called with a change to tx_lpi_enabled which does not
trigger an auto-neg, it is necessary to call the adjust_link callback
so that the MAC is reconfigured to take this change into account.

When setting phydev->eee_active, take tx_lpi_enabled into account, so
the MAC drivers don't need to consider tx_lpi_enabled.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v3: Update phydev->eee_active
---
 drivers/net/phy/phy-c45.c | 11 ++++++++---
 drivers/net/phy/phy.c     | 16 +++++++++++++---
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 29479e142826..a16124668e1d 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1455,6 +1455,8 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
  *
  * Description: it reportes the Supported/Advertisement/LP Advertisement
  * capabilities.
+ * Returns either error code, 0 if there was no change, or positive if
+ * there was a change which triggered auto-neg.
  */
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data)
@@ -1488,9 +1490,12 @@ int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
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
index c7a5d0240211..f4da7a5440e3 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -918,7 +918,7 @@ static void phy_update_eee_active(struct phy_device *phydev)
 	if (err < 0)
 		phydev->eee_active = false;
 	else
-		phydev->eee_active = err;
+		phydev->eee_active = (err & phydev->tx_lpi_enabled);
 }
 
 /**
@@ -1632,11 +1632,21 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 
 	mutex_lock(&phydev->lock);
 	ret = genphy_c45_ethtool_set_eee(phydev, data);
-	if (!ret)
+	if (ret >= 0) {
+		if (ret == 0) {
+			/* auto-neg not triggered */
+			if (phydev->tx_lpi_enabled != data->tx_lpi_enabled) {
+				phydev->tx_lpi_enabled = data->tx_lpi_enabled;
+				phy_update_eee_active(phydev);
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
2.40.0

