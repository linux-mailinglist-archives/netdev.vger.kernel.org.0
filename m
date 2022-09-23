Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8491E5E72C0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiIWEQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiIWEQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:16:45 -0400
X-Greylist: delayed 405 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 21:16:44 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B60EBD61
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:16:44 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 8A8F6101917BB;
        Fri, 23 Sep 2022 06:09:54 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 59AFE603E021;
        Fri, 23 Sep 2022 06:09:54 +0200 (CEST)
X-Mailbox-Line: From 8128fdb51eeebc9efbf3776a4097363a1317aaf1 Mon Sep 17 00:00:00 2001
Message-Id: <8128fdb51eeebc9efbf3776a4097363a1317aaf1.1663905575.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 23 Sep 2022 06:09:52 +0200
Subject: [PATCH net] net: phy: Don't WARN for PHY_UP state in
 mdio_bus_phy_resume()
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaolei Wang <xiaolei.wang@windriver.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume()
state") introduced a WARN() on resume from system sleep if a PHY is not
in PHY_HALTED state.

Commit 6dbe852c379f ("net: phy: Don't WARN for PHY_READY state in
mdio_bus_phy_resume()") added an exemption for PHY_READY state from
the WARN().

It turns out PHY_UP state needs to be exempted as well because the
following may happen on suspend:

  mdio_bus_phy_suspend()
    phy_stop_machine()
      phydev->state = PHY_UP  #  if (phydev->state >= PHY_UP)

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/netdev/2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/phy/phy_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2198f1302642..83cafa405720 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -316,11 +316,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we manged to get here with the PHY state machine in a state neither
-	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
-	 * and we should most likely be using MAC managed PM and we are not.
+	/* If we managed to get here with the PHY state machine in a state
+	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
+	 * that something went wrong and we should most likely be using
+	 * MAC managed PM, but we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
+		phydev->state != PHY_UP);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
-- 
2.36.1

