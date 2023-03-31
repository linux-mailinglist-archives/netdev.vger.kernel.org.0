Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B745D6D146E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCaA4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjCaAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA6E1042E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Yg/2dJzWMvYIFv1CqxSeP+R8BAfCeyF2/k8+iXX0Xzg=; b=k9WOhifDdsk5zoDJokWjX09M/y
        J6sS0DY9nUqqFPhwAKQIix3nn+k1QhbEg8IhFI8c27KAPOrLOHgkJKlXzF2UPJAYiXdxnVzXwAVTP
        ZA4SbsobLAANORX9UX7oBzsN10DSixJW2HZtqj16vISkGVlLcd/oG1oAAEsE3aAoX848=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33M-008xLR-0y; Fri, 31 Mar 2023 02:55:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 21/24] net: phylink: Add MAC_EEE to mac_capabilites
Date:   Fri, 31 Mar 2023 02:55:15 +0200
Message-Id: <20230331005518.2134652-22-andrew@lunn.ch>
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

If the MAC supports Energy Efficient Ethernet, it should indicate this
by setting the MAC_EEE bit in the config.mac_capabilities
bitmap. phylink will then enable EEE in the PHY, if it supports it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v3: Move MAC_EEE to BIT(2) and renumber link modes.
---
 drivers/net/phy/phylink.c |  3 +++
 include/linux/phylink.h   | 39 ++++++++++++++++++++++-----------------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 61e4502086c3..191cafd37e62 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1647,6 +1647,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	 */
 	phy_support_asym_pause(phy);
 
+	if (pl->config->mac_capabilities & MAC_EEE)
+		phy_support_eee(phy);
+
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 52f29b648853..cb5204fb9106 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -52,26 +52,31 @@ enum {
 	 */
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
-	MAC_10HD	= BIT(2),
-	MAC_10FD	= BIT(3),
+
+	/* MAC_EEE indicates that the MAC is Energy Efficient capable
+	 * and that the PHY should negotiate its use, if possible
+	 */
+	MAC_EEE		= BIT(2),
+	MAC_10HD	= BIT(3),
+	MAC_10FD	= BIT(4),
 	MAC_10		= MAC_10HD | MAC_10FD,
-	MAC_100HD	= BIT(4),
-	MAC_100FD	= BIT(5),
+	MAC_100HD	= BIT(5),
+	MAC_100FD	= BIT(6),
 	MAC_100		= MAC_100HD | MAC_100FD,
-	MAC_1000HD	= BIT(6),
-	MAC_1000FD	= BIT(7),
+	MAC_1000HD	= BIT(7),
+	MAC_1000FD	= BIT(8),
 	MAC_1000	= MAC_1000HD | MAC_1000FD,
-	MAC_2500FD	= BIT(8),
-	MAC_5000FD	= BIT(9),
-	MAC_10000FD	= BIT(10),
-	MAC_20000FD	= BIT(11),
-	MAC_25000FD	= BIT(12),
-	MAC_40000FD	= BIT(13),
-	MAC_50000FD	= BIT(14),
-	MAC_56000FD	= BIT(15),
-	MAC_100000FD	= BIT(16),
-	MAC_200000FD	= BIT(17),
-	MAC_400000FD	= BIT(18),
+	MAC_2500FD	= BIT(9),
+	MAC_5000FD	= BIT(10),
+	MAC_10000FD	= BIT(11),
+	MAC_20000FD	= BIT(12),
+	MAC_25000FD	= BIT(13),
+	MAC_40000FD	= BIT(14),
+	MAC_50000FD	= BIT(15),
+	MAC_56000FD	= BIT(16),
+	MAC_100000FD	= BIT(17),
+	MAC_200000FD	= BIT(18),
+	MAC_400000FD	= BIT(19),
 };
 
 static inline bool phylink_autoneg_inband(unsigned int mode)
-- 
2.40.0

