Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369066677EF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 15:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbjALOvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 09:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbjALOuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 09:50:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E6113E21
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H0SMtO6dUlN1pSMR+o6vHFTQb/GABIpKshEFZNv0KgY=; b=T6jZIiwh/9qtZ/dL0xjkQI7sPd
        gtz5CZG9LOJ4WJ+b74ogmFMh+UKYMC51Gc80KqwQRMdZZTEHLhqZ3Ww+P63Xtq1a4GckG0bD3JcWc
        yPKilcl7t2Dc0xKU2ZpZSfB5AWjPXLurDi98JbgqLm52IT0n63IIZYQph/bPknCowE/fXZgX3+evu
        EAAhb4iFpwYG2tZTkQy5M3aAP12OxeMVOMQslVgGVopLMfKK5ttS/SiCnJYE2Pi735QsadUWM6/Mq
        Cj+WFzhGsbu3lo6u11SrnYGnyMvZyPO0hOD7bFC2eb67QF4sseD0cTRi4txipTrdWpgwUfdQqagBH
        i4pwre2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39120 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pFyhX-0006Nc-FZ; Thu, 12 Jan 2023 14:37:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pFyhW-0067jq-Fh; Thu, 12 Jan 2023 14:37:06 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: pcs: pcs-lynx: use phylink_get_link_timer_ns()
 helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pFyhW-0067jq-Fh@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 12 Jan 2023 14:37:06 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the phylink_get_link_timer_ns() helper to get the period for the
link timer.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 7d5fc7f54b2f..3903f3baba2b 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -10,9 +10,6 @@
 #define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
 #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
 
-#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
-#define IEEE8023_LINK_TIMER_NS		10000000
-
 #define LINK_TIMER_LO			0x12
 #define LINK_TIMER_HI			0x13
 #define IF_MODE				0x14
@@ -126,26 +123,25 @@ static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertising)
 {
+	int link_timer_ns;
 	u32 link_timer;
 	u16 if_mode;
 	int err;
 
-	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
-		link_timer = LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
+	link_timer_ns = phylink_get_link_timer_ns(interface);
+	if (link_timer_ns > 0) {
+		link_timer = LINK_TIMER_VAL(link_timer_ns);
+
 		mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
 		mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
+	}
 
+	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
 		if_mode = 0;
 	} else {
 		if_mode = IF_MODE_SGMII_EN;
-		if (mode == MLO_AN_INBAND) {
+		if (mode == MLO_AN_INBAND)
 			if_mode |= IF_MODE_USE_SGMII_AN;
-
-			/* Adjust link timer for SGMII */
-			link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
-			mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
-			mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
-		}
 	}
 
 	err = mdiodev_modify(pcs, IF_MODE,
-- 
2.30.2

