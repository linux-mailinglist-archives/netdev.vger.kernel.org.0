Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047946EB8EB
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDVLtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjDVLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:49:09 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4912826AF;
        Sat, 22 Apr 2023 04:48:54 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBjY-00085G-2M;
        Sat, 22 Apr 2023 13:48:52 +0200
Date:   Sat, 22 Apr 2023 12:48:48 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [RFC PATCH net-next 4/8] net: phy: realtek: disable SGMII in-band AN
 for 2.5G PHYs
Message-ID: <87f666009413e8c6edac1ba30533b8f97a4fee76.1682163424.git.daniel@makrotopia.org>
References: <cover.1682163424.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1682163424.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC drivers don't use SGMII in-band autonegotiation unless told to do so
in device tree using 'managed = "in-band-status"'. When using MDIO to
access a PHY, in-band-status is unneeded as we have link-status via
MDIO. Switch off SGMII in-band autonegotiation using magic values.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Reported-by: Chukun Pan <amadeus@jmu.edu.cn>
Reported-by: Yevhen Kolomeiko <jarvis2709@gmail.com>
Tested-by: Yevhen Kolomeiko <jarvis2709@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 9b477dd17fa56..f97b5e49fae58 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -883,6 +883,7 @@ static irqreturn_t rtl9000a_handle_interrupt(struct phy_device *phydev)
 static int rtl8221b_config_init(struct phy_device *phydev)
 {
 	u16 option_mode;
+	int val;
 
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_2500BASEX:
@@ -919,6 +920,13 @@ static int rtl8221b_config_init(struct phy_device *phydev)
 		break;
 	}
 
+	/* Disable SGMII AN */
+	phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x7588, 0x2);
+	phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x7589, 0x71d0);
+	phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x7587, 0x3);
+	phy_read_mmd_poll_timeout(phydev, RTL8221B_MMD_SERDES_CTRL, 0x7587,
+				  val, !(val & BIT(0)), 500, 100000, false);
+
 	return 0;
 }
 
-- 
2.40.0

