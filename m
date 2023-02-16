Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C1699719
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjBPOV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:21:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D90CC0A;
        Thu, 16 Feb 2023 06:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676557287; x=1708093287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=X0+bIdYpTBO5RXlUx/jmxakO7fnyW2GuUVeSqP3IaL4=;
  b=R5IIghMMhPxbg4fQA39I+lJnhkL7Hq1v23WGYBa3c71d+JbP4jSqlXGb
   OqrpkSpngMvFtI/PKsiftrxijArZTBzOgeoyDEE7NyYB9JfqgWsJ3gHwg
   gHhANVbXfG+/qBXn3LlsPbxYCgepCk+rHv0IIewchr7dQHFegui8yS+mO
   cWxV417IWuiFmqct7VslDcHZx2ibmlG9nzfgkYw5nR6Mv3OUOrnxdoKoE
   vs4gLWb+fZj/HSsrHVxmNTyesn5gP8HJYPVdK0Ht/w1HSzCDaadKDhEu+
   3AxXhM2LDcYyyaBLZzdXZjsHt7b2WnoMyesIqntVbTMUcpqCQPua58AmE
   g==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="137572856"
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
Subject: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver
Date:   Thu, 16 Feb 2023 07:20:53 -0700
Message-ID: <b317787e1e55f9c59c55a3cf5f9f02d477dd5a59.1676490952.git.yuiko.oshino@microchip.com>
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

Move the LAN7800 internal phy (phy ID  0x0007c132) specific register accesses to the phy driver (microchip.c).

Fixes: 14437e3fa284f465dbbc8611fd4331ca8d60e986 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/usb/lan78xx.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db..068488890d57 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2115,33 +2115,8 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 static void lan78xx_link_status_change(struct net_device *net)
 {
 	struct phy_device *phydev = net->phydev;
-	int temp;
-
-	/* At forced 100 F/H mode, chip may fail to set mode correctly
-	 * when cable is switched between long(~50+m) and short one.
-	 * As workaround, set to 10 before setting to 100
-	 * at forced 100 F/H mode.
-	 */
-	if (!phydev->autoneg && (phydev->speed == 100)) {
-		/* disable phy interrupt */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
 
-		temp = phy_read(phydev, MII_BMCR);
-		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
-		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
-		temp |= BMCR_SPEED100;
-		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
-
-		/* clear pending interrupt generated while workaround */
-		temp = phy_read(phydev, LAN88XX_INT_STS);
-
-		/* enable phy interrupt back */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
-	}
+	phy_print_status(phydev);
 }
 
 static int irq_map(struct irq_domain *d, unsigned int irq,
-- 
2.17.1

