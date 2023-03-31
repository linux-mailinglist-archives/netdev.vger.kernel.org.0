Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF586D1465
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCaAzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCaAzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3901D322
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=w0Zqeh2lsTq+b7kVuSkMzxzALPtz+WvJtFj2bjWgq38=; b=v0D8COP9DEHFoHWl3EbQ9qiqUX
        2I+YfeQj64xRJ9UADj2rzyzKvNjXKoTffW2Ny6Gz0EeEQ/RoMXMOIyW/wF+qNnRqy0C8C1+jef1zn
        n2eDHqAakdtkxrAg4nKeI4Jfe5r1Ttl+WVIAK98IrTm29R1A5tHuVXx1Clv7olBDeRrU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKT-Gi; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 06/24] net: phylink: Handle change in EEE from phylib
Date:   Fri, 31 Mar 2023 02:55:00 +0200
Message-Id: <20230331005518.2134652-7-andrew@lunn.ch>
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

phylib can indicate a change in EEE outside of the link coming
up. When it does this, the link will already be up and remain
up. Detect this in the phylink adjust_link callback, and call the
mac_set_eee() callback, rather than running the resolver. This then
avoids violating phylinks guarantee of not calling mac_link_up()
without a corresponding mac_link_down().

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 453f80544792..cf26acc920bd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1594,10 +1594,13 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 {
 	struct phylink *pl = phydev->phylink;
 	bool tx_pause, rx_pause;
+	bool eee_changed;
 
 	phy_get_pause(phydev, &tx_pause, &rx_pause);
 
 	mutex_lock(&pl->state_mutex);
+	eee_changed = (pl->phy_state.link == up);
+
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
 	pl->phy_state.eee_active = phydev->eee_active;
@@ -1609,9 +1612,14 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 		pl->phy_state.pause |= MLO_PAUSE_RX;
 	pl->phy_state.interface = phydev->interface;
 	pl->phy_state.link = up;
+
+	if (eee_changed && pl->mac_ops->mac_set_eee)
+		pl->mac_ops->mac_set_eee(pl->config, pl->phy_state.eee_active);
+
 	mutex_unlock(&pl->state_mutex);
 
-	phylink_run_resolve(pl);
+	if (!eee_changed)
+		phylink_run_resolve(pl);
 
 	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
-- 
2.40.0

