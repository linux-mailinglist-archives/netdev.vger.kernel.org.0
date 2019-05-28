Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526E82C329
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfE1J1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:27:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35538 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfE1J1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kGSFJ8vgarU0epatlo5884Gw0TM+L29nyVT6BRCopYY=; b=Q110hdnmy6dsGMUa/haXpGeDFA
        5qGYlBnQTCmUHt2osETtoAGzjnlpKRuV4moAT1hCCHGPDiqavzP0ttpfQFEQVaOnq4+DyXLO7kxji
        Gf0hj/1m6foee9akw99s2NElF4Arp3hoVf75HYynLZ8OLNLB0Mx01Hlv4+3mVh/YX+geoIDwVgs7e
        WZUbHGi2Spjr1x0f2DBgtry9eGwLd9euTKOuZKfbhOiEiKRSC0uWv8LOb2108OFgtj+R2CG2wm2mW
        pZiY9UwzGYKwSP2p+nFGI0bQKHeIZU8iYogIPYZzgZQz90ixetNqCbXr54AFEAcSSSTmrXCrwJgNR
        QmDLnqQQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:39868 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYOA-0004qL-5S; Tue, 28 May 2019 10:27:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYO9-000584-J6; Tue, 28 May 2019 10:27:21 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: ensure consistent phy interface mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYO9-000584-J6@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:27:21 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that we supply the same phy interface mode to mac_link_down() as
we did for the corresponding mac_link_up() call.  This ensures that MAC
drivers that use the phy interface mode in these methods can depend on
mac_link_down() always corresponding to a mac_link_up() call for the
same interface mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 74983593834b..9044b95d2afe 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -51,6 +51,10 @@ struct phylink {
 
 	/* The link configuration settings */
 	struct phylink_link_state link_config;
+
+	/* The current settings */
+	phy_interface_t cur_interface;
+
 	struct gpio_desc *link_gpio;
 	struct timer_list link_poll;
 	void (*get_fixed_state)(struct net_device *dev,
@@ -446,12 +450,12 @@ static void phylink_resolve(struct work_struct *w)
 		if (!link_state.link) {
 			netif_carrier_off(ndev);
 			pl->ops->mac_link_down(ndev, pl->link_an_mode,
-					       pl->phy_state.interface);
+					       pl->cur_interface);
 			netdev_info(ndev, "Link is Down\n");
 		} else {
+			pl->cur_interface = link_state.interface;
 			pl->ops->mac_link_up(ndev, pl->link_an_mode,
-					     pl->phy_state.interface,
-					     pl->phydev);
+					     pl->cur_interface, pl->phydev);
 
 			netif_carrier_on(ndev);
 
-- 
2.7.4

