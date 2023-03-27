Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA86CAB63
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjC0RDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjC0RC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8E059E0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QtcqV3kxurbDsCWi3HKWslvcIrE5D+rOFUtcWGVvBso=; b=QFJryehvONRCXg7lL790FW+mcj
        nbp3ZJ0dWZnbMmGNQCwnFUfV7kLBdc26wS4V4NVjiJV4qTXCmFfGtj+eqPzNAX3jbvQhAhN+uNeMe
        glGD77aN78aIThDy2NwRbDpyE3P2eLPnS19SAF6w3ZVXyG8c5vt0tshgUhaMRnBwEaX0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008Xt6-Jo; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 19/23] net: phy: Add phy_support_eee() indicating MAC support EEE
Date:   Mon, 27 Mar 2023 19:01:57 +0200
Message-Id: <20230327170201.2036708-20-andrew@lunn.ch>
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

In order for EEE to operate, both the MAC and the PHY need to support
it, similar to how pause works. Copy the pause concept and add the
call phy_support_eee() which the MAC makes after connecting the PHY to
indicate it supports EEE. phylib will then advertise EEE when auto-neg
is performed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 16 ++++++++++++++++
 include/linux/phy.h          |  3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c0760cbf534b..30f07623637b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2760,6 +2760,22 @@ void phy_advertise_supported(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_advertise_supported);
 
+/**
+ * phy_support_eee - Enable support of EEE
+ * @phydev: target phy_device struct
+ *
+ * Description: Called by the MAC to indicate is supports Energy
+ * Efficient Ethernet. This should be called before phy_start() in
+ * order that EEE is negotiated when the link comes up as part of
+ * phy_start().
+ */
+void phy_support_eee(struct phy_device *phydev)
+{
+	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
+	phydev->tx_lpi_enabled = true;
+}
+EXPORT_SYMBOL(phy_support_eee);
+
 /**
  * phy_support_sym_pause - Enable support of symmetrical pause
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9769021b1aa7..b8c489f2b4f2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -683,7 +683,7 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	/* used for eee validation */
+	/* used for eee validation and configuration*/
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising_eee);
 	bool eee_enabled;
@@ -1823,6 +1823,7 @@ void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
 void phy_support_sym_pause(struct phy_device *phydev);
 void phy_support_asym_pause(struct phy_device *phydev);
+void phy_support_eee(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
-- 
2.39.2

