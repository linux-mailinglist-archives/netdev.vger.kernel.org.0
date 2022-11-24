Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494016374C8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKXJHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKXJHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:07:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047E9116067
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CsBNsKXUazmcHXGqDf/tfkmCFQ5+m3wSWQI0+PIG5XM=; b=MPYFDzz+wUlUehEDx7bTnapfqT
        j3TbY55zQTaYEGLrlxbu+KrsOiTz/Le/4lYZrpduFKVbpxokMU9MR65yitqz8o4U2FNphIaejcfEk
        TTUeoYlUmaJGPgakh6DfQr6btjiKo0ChEE+SttU/BAthARuhelfOFmuiBVENcjGxmQK10PG218lmy
        eFp5xzu//TFliCzc4sjasqvqsOalmHTbN54UYw7fWOrfkBeP1QrCLKmtcGuV73c7v3bzaE0H6B4q0
        0epb4lRWNq+XCesq26/3HOVBP/tcdE0ypF5cAup8xiGpeN4B4wPQzf9goRoE0viNGDeLwf+iMxatv
        Uxz9Gsgg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56200 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oy8C1-0003sK-CY; Thu, 24 Nov 2022 09:06:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oy8C0-007VtS-NX; Thu, 24 Nov 2022 09:06:48 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Tim Harvey <tharvey@gateworks.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: fix PHY validation with rate adaption
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oy8C0-007VtS-NX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 24 Nov 2022 09:06:48 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tim Harvey reports that link modes which he does not expect to be
supported are being advertised, and this is because of the workaround
we have for PHYs that switch interface modes.

Fix this up by checking whether rate matching will be used for the
requested interface mode, and if rate matching will be used, perform
validation only with the requested interface mode, rather than invoking
this workaround.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
I think Sean agreed that this patch was a good idea, but Tim never
tested it. It would be good to get it tested.

 drivers/net/phy/phylink.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6547b6cc6cbe..2805b04d6402 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1603,19 +1603,29 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
 
-	/* Clause 45 PHYs switch their Serdes lane between several different
-	 * modes, normally 10GBASE-R, SGMII. Some use 2500BASE-X for 2.5G
-	 * speeds. We really need to know which interface modes the PHY and
-	 * MAC supports to properly work out which linkmodes can be supported.
+	/* Check whether we would use rate matching for the proposed interface
+	 * mode.
 	 */
-	if (phy->is_c45 &&
+	config.rate_matching = phy_get_rate_matching(phy, interface);
+
+	/* Clause 45 PHYs may switch their Serdes lane between, e.g. 10GBASE-R,
+	 * 5GBASE-R, 2500BASE-X and SGMII if they are not using rate matching.
+	 * For some interface modes (e.g. RXAUI, XAUI and USXGMII) switching
+	 * their Serdes is either unnecessary or not reasonable.
+	 *
+	 * For these which switch interface modes, we really need to know which
+	 * interface modes the PHY supports to properly work out which ethtool
+	 * linkmodes can be supported. For now, as a work-around, we validate
+	 * against all interface modes, which may lead to more ethtool link
+	 * modes being advertised than are actually supported.
+	 */
+	if (phy->is_c45 && config.rate_matching == RATE_MATCH_NONE &&
 	    interface != PHY_INTERFACE_MODE_RXAUI &&
 	    interface != PHY_INTERFACE_MODE_XAUI &&
 	    interface != PHY_INTERFACE_MODE_USXGMII)
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
-	config.rate_matching = phy_get_rate_matching(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
-- 
2.30.2

