Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196FF69971B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBPOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBPOV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:21:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3294486;
        Thu, 16 Feb 2023 06:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676557288; x=1708093288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GUDLjwXxhrwyJq9sUb4L73P8nOx6Iz2rRWkAP2imO0o=;
  b=xNsxpnTgm894YDvO7/yI2VEJjIXT8RaVnM0Riida9RhcdbZJ7qSnEZ3F
   b8YAg0VgjTMkHCwCM/RPQB4F6K7wJd3z6ikdbhBse5l6hgmcVEsXBEKEO
   XgVyoR5ivr+RmNm1dFAkswi3e9WttvzoUsEJeF0uDN9RIWk5XuzO2lJlH
   UK2DAxz7tNDe+e3n+95Y34dFIdBO8gBBq8rpII5UfVjZXEgE9Ea8/0/9p
   0PrY8toV0Uolq2L3xNEA6Qfo7BATo0PTJLhpNtTYkxgO0BR8EpmszjBDP
   5g26staQ6Duh5Wb/7+NDq+m16nwabz1nM5i5n9zVH/fOQjm0a6jJZArN6
   w==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="137572857"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 07:21:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:21:26 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:21:26 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        <woojung.huh@microchip.com>, <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <edumazet@google.com>, <linux-usb@vger.kernel.org>,
        <kuba@kernel.org>
Subject: [PATCH net 2/2] net:phy:microchip: fix accessing the LAN7800's internal phy specific registers from the MAC driver
Date:   Thu, 16 Feb 2023 07:20:54 -0700
Message-ID: <ab5302b82d771a7bf5b0fa135c645890ffba0595.1676490952.git.yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1676490952.git.yuiko.oshino@microchip.com>
References: <cover.1676490952.git.yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add lan88xx_link_change_notify() to the internal phy driver and move the phy specific register accesses there.

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index ccecee2524ce..0b88635f4fbc 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -342,6 +342,37 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static void lan88xx_link_change_notify(struct phy_device *phydev)
+{
+	int temp;
+
+	/* At forced 100 F/H mode, chip may fail to set mode correctly
+	 * when cable is switched between long(~50+m) and short one.
+	 * As workaround, set to 10 before setting to 100
+	 * at forced 100 F/H mode.
+	 */
+	if (!phydev->autoneg && phydev->speed == 100) {
+		/* disable phy interrupt */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+
+		temp = phy_read(phydev, MII_BMCR);
+		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
+		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
+		temp |= BMCR_SPEED100;
+		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
+
+		/* clear pending interrupt generated while workaround */
+		temp = phy_read(phydev, LAN88XX_INT_STS);
+
+		/* enable phy interrupt back */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+	}
+}
+
 static struct phy_driver microchip_phy_driver[] = {
 {
 	.phy_id		= 0x0007c132,
@@ -359,6 +390,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
+	.link_change_notify = lan88xx_link_change_notify,
 
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
-- 
2.17.1

