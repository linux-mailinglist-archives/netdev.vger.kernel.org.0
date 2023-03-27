Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E906CAB64
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjC0RDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjC0RC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4851B3C00
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+uuTY07cEZLtCu7llQFeZCbIlPNwMnDDXnhwWXo7k9M=; b=nVEiDlh6i7bR19CKMb+iO5KD88
        70pTpVEBt2+C5f7Pm2HykQOGH5nTyXpmJtEJ+PwrGvsT5rtzizsbNgHUlA5Ay6/3vSG15w+kRfquo
        hwvWLi2K0UG63bjp0iXtjWAd0fKguT/1nTCC4bRfnrreD0O1bb5Zxj9k8UgP1f1TaNfo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008XtF-Ni; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 20/23] net: phylink: Add MAC_EEE to mac_capabilites
Date:   Mon, 27 Mar 2023 19:01:58 +0200
Message-Id: <20230327170201.2036708-21-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
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
 drivers/net/phy/phylink.c | 3 +++
 include/linux/phylink.h   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2e9ce6862042..192f9d13d3d1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1637,6 +1637,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	 */
 	phy_support_asym_pause(phy);
 
+	if (pl->config->mac_capabilities & MAC_EEE)
+		phy_support_eee(phy);
+
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6eee6194b5ab..beac34b71343 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -72,6 +72,9 @@ enum {
 	MAC_100000FD	= BIT(16),
 	MAC_200000FD	= BIT(17),
 	MAC_400000FD	= BIT(18),
+	/* MAC_EEE indicates that the MAC is Energy Efficient capable
+	   and that the PHY should negotiate its use, if possible */
+	MAC_EEE		= BIT(31),
 };
 
 static inline bool phylink_autoneg_inband(unsigned int mode)
-- 
2.39.2

