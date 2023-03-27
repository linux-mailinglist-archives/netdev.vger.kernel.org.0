Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267AB6CAB56
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjC0RDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbjC0RCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB05244
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zsb2pq3UsLsH0xCH0KWFxt5YjiNdRdyvnYXWO3w4Wmk=; b=kcsz7hsiASLjKucB596WkvMg5y
        AmL9/knopq3hlBpOu2zZmD8GzkwLw85PwEPXhC9VpyPYCrO4YknYpRx68rcD4mOCX0IQcXtTi1gXL
        E6HyTgmdZHrcV3RUVVi4yae+xLzrPPaS+qj7rkVQofG5qWHTwMnQ2xCR0qSqr11sUWdk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008XqZ-JC; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 04/23] net: phy: Keep track of EEE tx_lpi_enabled
Date:   Mon, 27 Mar 2023 19:01:42 +0200
Message-Id: <20230327170201.2036708-5-andrew@lunn.ch>
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

Have phylib keep track of the EEE tx_lpi_enabled configuration.  This
simplifies the MAC drivers, in that they don't need to store it.

Future patches to phylib will also make use of this information to
further simplify the MAC drivers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 5 ++++-
 include/linux/phy.h   | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d3d6ff4ed488..7d9205c3f235 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1585,7 +1585,7 @@ EXPORT_SYMBOL(phy_get_eee_err);
  * @data: ethtool_eee data
  *
  * Description: it reportes the Supported/Advertisement/LP Advertisement
- * capabilities.
+ * capabilities, etc.
  */
 int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 {
@@ -1596,6 +1596,7 @@ int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 
 	mutex_lock(&phydev->lock);
 	ret = genphy_c45_ethtool_get_eee(phydev, data);
+	data->tx_lpi_enabled = phydev->tx_lpi_enabled;
 	mutex_unlock(&phydev->lock);
 
 	return ret;
@@ -1618,6 +1619,8 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 
 	mutex_lock(&phydev->lock);
 	ret = genphy_c45_ethtool_set_eee(phydev, data);
+	if (!ret)
+		phydev->tx_lpi_enabled = data->tx_lpi_enabled;
 	mutex_unlock(&phydev->lock);
 
 	return ret;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 12addd1c29f2..f746d0b10e68 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -578,6 +578,7 @@ struct macsec_ops;
  * @advertising_eee: Currently advertised EEE linkmodes
  * @eee_enabled: Flag indicating whether the EEE feature is enabled
  * @eee_active: EEE is active for the current link mode
+ * @tx_lpi_enabled: EEE should send LPI
  * @lp_advertising: Current link partner advertised linkmodes
  * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
@@ -693,6 +694,7 @@ struct phy_device {
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 	bool eee_active;
+	bool tx_lpi_enabled;
 
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
-- 
2.39.2

