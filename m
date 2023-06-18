Return-Path: <netdev+bounces-11801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3287347AE
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55FF5280F72
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8115BBA32;
	Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8BBA947
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CB4197
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=weAI44WQbR8/6mC+T9ihZ/jVhfDc7WbXEIwrrkRDTYs=; b=p/z2FmJyyLNtG/mFuDUNbODBp0
	T19fYuZEFLxQ933PzhdYJ9vZKbfE5Mpkrt+9DFVF7xHS1T37w3x3eEajVTiIrX2oLHZ2U2BhxvODe
	5GISg9vhkDDg+xWQ0Fk7sahabDlIBPY5tr/Kpg3lZbyQEL7WkPkJF00Ie0JP8Ybbi7jc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr37-HR; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH v4 net-next 3/9] net: phy: Add phydev->enable_tx_lpi to simplify adjust link callbacks
Date: Sun, 18 Jun 2023 20:41:13 +0200
Message-Id: <20230618184119.4017149-4-andrew@lunn.ch>
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

MAC drivers which support EEE need to know the results of the EEE
auto-neg in order to program the hardware to perform EEE or not.  The
oddly named phy_init_eee() can be used to determine this, it returns 0
if EEE should be used, or a negative error code,
e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
resulted in it not being used.

However, many MAC drivers get this wrong. Add phydev->enable_tx_lpi
which indicates the result of the autoneg for EEE, including if EEE is
administratively disabled with ethtool. The MAC driver can then access
this in the same way as link speed and duplex in the adjust link
callback. If enable_tx_lpi is true, the MAC should send low power
indications and does not need to consider anything else with respect
to EEE.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2 Check for errors from genphy_c45_eee_is_active
v5: Rename to enable_tx_lpi to fit better with phylink changes
---
 drivers/net/phy/phy.c | 7 +++++++
 include/linux/phy.h   | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index bdf00b2b2c1d..add94626b604 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -929,9 +929,16 @@ static int phy_check_link_status(struct phy_device *phydev)
 	if (phydev->link && phydev->state != PHY_RUNNING) {
 		phy_check_downshift(phydev);
 		phydev->state = PHY_RUNNING;
+		err = genphy_c45_eee_is_active(phydev,
+					       NULL, NULL, NULL);
+		if (err < 0)
+			phydev->enable_tx_lpi = false;
+		else
+			phydev->enable_tx_lpi = err;
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
 		phydev->state = PHY_NOLINK;
+		phydev->enable_tx_lpi = false;
 		phy_link_down(phydev);
 	}
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11c1e91563d4..851421248212 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -584,6 +584,7 @@ struct macsec_ops;
  * @supported_eee: supported PHY EEE linkmodes
  * @advertising_eee: Currently advertised EEE linkmodes
  * @eee_enabled: Flag indicating whether the EEE feature is enabled
+ * @enable_tx_lpi: When True, MAC should transmit LPI to PHY
  * @lp_advertising: Current link partner advertised linkmodes
  * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
@@ -700,6 +701,7 @@ struct phy_device {
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
+	bool enable_tx_lpi;
 
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
-- 
2.40.1


