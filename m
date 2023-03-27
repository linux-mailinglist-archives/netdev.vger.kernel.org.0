Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD46CAB50
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjC0RDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjC0RCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4624C2B
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZhQkHuT+AJr7ULFm7T/FXWBYKjC5gnUt4Pdmi1EPOSE=; b=cEomkxEwf6xvB21EENV83TIWuq
        ykmgFc8JN+MzDHJyDdw2b10gweW15kz5xMqblCeeMoGcjcZvrdNE8V7srjiQQrWJRrP40Z4mCG8Lz
        INjVhL2ZaGjhzp4Nps0ZYtfMzFTWrm59QRfCYTiAO/4wKHb5TMfp6r9tyNur2j+wZCiQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008XqM-Et; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 01/23] net: phy: Add phydev->eee_active to simplify adjust link callbacks
Date:   Mon, 27 Mar 2023 19:01:39 +0200
Message-Id: <20230327170201.2036708-2-andrew@lunn.ch>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2 Check for errors from genphy_c45_eee_is_active
---
 drivers/net/phy/phy.c | 7 +++++++
 include/linux/phy.h   | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..68e1ce942dd6 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -928,9 +928,16 @@ static int phy_check_link_status(struct phy_device *phydev)
 	if (phydev->link && phydev->state != PHY_RUNNING) {
 		phy_check_downshift(phydev);
 		phydev->state = PHY_RUNNING;
+		err = genphy_c45_eee_is_active(phydev,
+					       NULL, NULL, NULL);
+		if (err < 0)
+			phydev->eee_active = false;
+		else
+			phydev->eee_active = err;
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
2.39.2

