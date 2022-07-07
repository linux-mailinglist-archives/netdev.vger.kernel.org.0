Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC07569E76
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiGGJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiGGJUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:20:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB3326E5
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PMrZeWE8+0odShjffNvdG+m1LC9uh2dW9YPJvxm0iic=; b=sBoxPuwuCt2N08Ys8ghY973tHI
        GA/BAhqBHdJd1i1C5L4+Vm0Tuv+xd75KM5O/X/w23ZpR+w8YRpwhtfqvuCniIcYCyCfvrYzwpJF2R
        UHFUZ4Qy660rNg7tlZoi/Kw1hb2j3WRRPR0IkBYHWu7pFRZeNW5DWKiJKyUV0rmBlviqxXsLPg070
        aAqmG49v5xMbcoz8R+bjf/cq0okhncgvkv3Ogb8Xz7WQAml4SJFQhu9D0e+83Fc4DV/64pUIEbVA7
        KL+j1MD+4ztyl7HGXo1A3wFZMr+ZbrzeetUHJcNOZaEGcLF9p4Za9VuAK+fQGfMylOURzlTB/PbfA
        neV/JUfQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40108 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o9Ng2-0003hy-Pe; Thu, 07 Jul 2022 10:20:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o9Ng2-005Qbe-3H; Thu, 07 Jul 2022 10:20:02 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: phylink: fix SGMII inband autoneg enable
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o9Ng2-005Qbe-3H@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 07 Jul 2022 10:20:02 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are operating in SGMII inband mode, it implies that there is a
PHY connected, and the ethtool advertisement for autoneg applies to
the PHY, not the SGMII link. When in 1000base-X mode, then this applies
to the 802.3z link and needs to be applied to the PCS.

Fix this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7ed3b2c3a359..54903165be4b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3166,7 +3166,9 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 
 	/* Ensure ISOLATE bit is disabled */
 	if (mode == MLO_AN_INBAND &&
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising))
+	    (interface == PHY_INTERFACE_MODE_SGMII ||
+	     interface == PHY_INTERFACE_MODE_QSGMII ||
+	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
 		bmcr = BMCR_ANENABLE;
 	else
 		bmcr = 0;
-- 
2.30.2

