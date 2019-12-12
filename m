Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A4C11D38C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbfLLRQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:16:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33364 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbfLLRQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DbGPoazh/dYd0+cx0ceU254VzRUkvXVdpy7AAc6Izc0=; b=QDKi/D1Hijf8E9+N2pgXxc3ceS
        QYkjNZSRUrzCxdiXC3fDF9aLPgM+MhzBTtPQ89RXU/0nZNZo25r1GIicGBuNqTZeIZU4WNTH6loxU
        Pow3BekfuV+XJ+K3zHeXh15JPQL6ytIfJTdOsRHR2L9WLrxyK4/7Q7B8QByDj7G6rj0U5IAM9/v/C
        HnxKBkJwhg1kw8KAjxWnZHNt/0QVKaXbuA9UnzSPpm9pUznlNHWZeMBxx+5CsE+mc75cXHWQ6abeJ
        IjpNAXzD++OcQp/grMkgcpiTxikaBY6GJN/AAMWKHplDPlRiXBPeJBJCTojEANPuZC3tu6jdKZsKR
        0uYMaSjQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37752 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifS4T-00083t-H2; Thu, 12 Dec 2019 17:16:13 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifS4S-000706-ON; Thu, 12 Dec 2019 17:16:12 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Milind Parab <mparab@cadence.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: propagate phy_attach_direct() return
 code
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ifS4S-000706-ON@rmk-PC.armlinux.org.uk>
Date:   Thu, 12 Dec 2019 17:16:12 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_phy_attach() hides the return value of phy_attach_direct(), forcing
us to return a "generic" ENODEV error code that is indistinguishable
from the lack-of-phy-property case.

Switch to using of_phy_find_device() to find the PHY device, and then
propagating any phy_attach_direct() error back to the caller.

Link: https://lore.kernel.org/lkml/20191210113829.GT25745@shell.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7c660bf99d1..8d20cf3ba0b7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -859,14 +859,17 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 		return 0;
 	}
 
-	phy_dev = of_phy_attach(pl->netdev, phy_node, flags,
-				pl->link_interface);
+	phy_dev = of_phy_find_device(phy_node);
 	/* We're done with the phy_node handle */
 	of_node_put(phy_node);
-
 	if (!phy_dev)
 		return -ENODEV;
 
+	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+				pl->link_interface);
+	if (ret)
+		return ret;
+
 	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy_dev);
-- 
2.20.1

