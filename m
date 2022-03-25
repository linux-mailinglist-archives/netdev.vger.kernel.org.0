Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9104E7D61
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiCYTwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiCYTv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:51:29 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0249725DAB9;
        Fri, 25 Mar 2022 12:35:23 -0700 (PDT)
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 73246C90C9;
        Fri, 25 Mar 2022 17:25:38 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D01EEC000F;
        Fri, 25 Mar 2022 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648229042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N4xotwJkkW+qiv9g/qytp5wTklonmR/ZeKGbUvRh3HA=;
        b=n982tKe1Zy97vbuuRabCQ+9oNB7I5M3BM6wV8YnQq9mj4mol+2PF4OoRsOhY/355dL1P0R
        /udlkd9o49RumixvsIsbGvtlFg6JQc5iQVk95pssHnHoUnmyi/thrSaC4/ZLDtLFx6+BQ2
        QvQ5fQeNMBCHSRFstf2XY2XebRKkEZrbpdV/cZBMkME5bRQGwbV4sPioKmI7VYU2wDY28i
        8Iq1UiMhaISdEufJNqASYy9An9Ov1lBpAUBWb1aYyS43mG51puvM4rRTfO3cdAdw7bWpAh
        zCFJBgA5l8k6eQfqCcHEIeukBh3oU3xRnac4rX5m37L7o8tGHM0BgLRmLwyK2Q==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [net-next 4/5] net: mdiobus: fwnode: allow phy device registration with non OF nodes
Date:   Fri, 25 Mar 2022 18:22:33 +0100
Message-Id: <20220325172234.1259667-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325172234.1259667-1-clement.leger@bootlin.com>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a software node, we also want to call
fwnode_mdiobus_phy_device_register() which support all nodes type.
Remove the is_of_node() check to allow that.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 7f71c0700c55..9f9dc56f03aa 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -126,7 +126,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 			fwnode_handle_put(phy->mdio.dev.fwnode);
 			return rc;
 		}
-	} else if (is_of_node(child)) {
+	} else {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
 		if (rc) {
 			unregister_mii_timestamper(mii_ts);
-- 
2.34.1

