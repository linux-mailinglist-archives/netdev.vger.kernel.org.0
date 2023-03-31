Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563626D146B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCaAz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5AC1041F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ywMkoH6yiyWWuEZTTgl8DXNHkG9cJErCqcID5K7/eHA=; b=EsDnkXOMeTKF4Xhf08ngMmK3D3
        bagmmT3RL3bqVOcq2OmmLFW6TNQ83MS13bENwkY6kc4fL9O6woKHy4gCNHicd72MbKfqG00Q03VR1
        4NxRZOrERCFegJW6kZSszd7xfNGZrYpXJUgNcFu6lTxWi8c+PYcNe1nIeKsFahL0G6R4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xK9-As; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 01/24] net: phy: Add phydev->eee_active to simplify adjust link callbacks
Date:   Fri, 31 Mar 2023 02:54:55 +0200
Message-Id: <20230331005518.2134652-2-andrew@lunn.ch>
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

MAC drivers which support EEE need to know the results of the EEE
auto-neg in order to program the hardware to perform EEE or not.  The
oddly named phy_init_eee() can be used to determine this, it returns 0
if EEE should be used, or a negative error code,
e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
resulted in it not being used.

However, many MAC drivers get this wrong. Add phydev->eee_active which
indicates the result of the autoneg for EEE, including if EEE is
administratively disabled with ethtool. The MAC driver can then access
this in the same way as link speed and duplex in the adjust link
callback.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2 Check for errors from genphy_c45_eee_is_active
v3 Refactor into helper which can be used in a later patch
---
 drivers/net/phy/phy.c | 21 +++++++++++++++++++++
 include/linux/phy.h   |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..150df69d9e08 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -902,6 +902,25 @@ int phy_config_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_config_aneg);
 
+/**
+ * phy_update_eee_active - Update phydev->eee_active statue
+ * @phydev: the phy_device struct
+ *
+ * Description: Read from the PHY is EEE is active. Use the
+ * information to set eee_active in phydev, which the MAC can then use
+ * to enable EEE in the MAC.
+ */
+static void phy_update_eee_active(struct phy_device *phydev)
+{
+	int err;
+
+	err = genphy_c45_eee_is_active(phydev, NULL, NULL, NULL);
+	if (err < 0)
+		phydev->eee_active = false;
+	else
+		phydev->eee_active = err;
+}
+
 /**
  * phy_check_link_status - check link status and set state accordingly
  * @phydev: the phy_device struct
@@ -928,9 +947,11 @@ static int phy_check_link_status(struct phy_device *phydev)
 	if (phydev->link && phydev->state != PHY_RUNNING) {
 		phy_check_downshift(phydev);
 		phydev->state = PHY_RUNNING;
+		phy_update_eee_active(phydev);
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
 		phydev->state = PHY_NOLINK;
+		phydev->eee_active = false;
 		phy_link_down(phydev);
 	}
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fefd5091bc24..5cc2dcb17eb0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -577,6 +577,7 @@ struct macsec_ops;
  * @supported_eee: supported PHY EEE linkmodes
  * @advertising_eee: Currently advertised EEE linkmodes
  * @eee_enabled: Flag indicating whether the EEE feature is enabled
+ * @eee_active: EEE is active for the current link mode
  * @lp_advertising: Current link partner advertised linkmodes
  * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
@@ -691,6 +692,7 @@ struct phy_device {
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
+	bool eee_active;
 
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
-- 
2.40.0

