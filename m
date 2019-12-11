Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9911A95C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfLKK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:56:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39556 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKK4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zp9aXuZNWIG9v1kQccnIPryDcjgq5bN+ESIyg9GHsKk=; b=KO1E6aAkQA7ep2DxDRHAQKtjfx
        nceiBLupJEKl7wN2rna+S967JXxTu7qiZKbq3mYcspPwEwkSmWnsVO18nyLAsP6ZvVr+ihalXPjpq
        wVg41/A+oB42xpcVN6UAUy3qXBYXpv0Xna0pztyC/VRJpt8TmO2EHflIOoR26TOdf5U1fQREU2IQi
        uTZ4lu1FyAIZYTVZCqjedCjCKWUsKb4bACcPJr97WiK6BnRtIo/YAciE7krUlJ7WfD5Zyo8F1Xdek
        2rrct2Gm4Jp/+3rR5Cv0OizPsI06lZuuvG7e6lHbH1QSRmmm7ge7x1nQ4whT+o8Do71h5XVWR5gJt
        2F83ahjA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56740 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfP-0007v1-Is; Wed, 11 Dec 2019 10:56:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfN-0002yK-6a; Wed, 11 Dec 2019 10:56:25 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 07/14] net: phylink: re-split
 __phylink_connect_phy()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfN-0002yK-6a@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:25 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support Clause 45 PHYs on SFP+ modules, which have an
indeterminant phy interface mode, we need to be able to call
phylink_bringup_phy() with a different interface mode to that used when
binding the PHY. Reduce __phylink_connect_phy() to an attach operation,
and move the call to phylink_bringup_phy() to its call sites.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8c3fafebe667..e6157534d3bd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -764,11 +764,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	return 0;
 }
 
-static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
-		phy_interface_t interface)
+static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
+			      phy_interface_t interface)
 {
-	int ret;
-
 	if (WARN_ON(pl->link_an_mode == MLO_AN_FIXED ||
 		    (pl->link_an_mode == MLO_AN_INBAND &&
 		     phy_interface_mode_is_8023z(interface))))
@@ -777,15 +775,7 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
 	if (pl->phydev)
 		return -EBUSY;
 
-	ret = phy_attach_direct(pl->netdev, phy, 0, interface);
-	if (ret)
-		return ret;
-
-	ret = phylink_bringup_phy(pl, phy);
-	if (ret)
-		phy_detach(phy);
-
-	return ret;
+	return phy_attach_direct(pl->netdev, phy, 0, interface);
 }
 
 /**
@@ -805,13 +795,23 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
  */
 int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
+	int ret;
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
 		pl->link_config.interface = pl->link_interface;
 	}
 
-	return __phylink_connect_phy(pl, phy, pl->link_interface);
+	ret = phylink_attach_phy(pl, phy, pl->link_interface);
+	if (ret < 0)
+		return ret;
+
+	ret = phylink_bringup_phy(pl, phy);
+	if (ret)
+		phy_detach(phy);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(phylink_connect_phy);
 
@@ -1812,8 +1812,17 @@ static void phylink_sfp_link_up(void *upstream)
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
+	int ret;
 
-	return __phylink_connect_phy(upstream, phy, pl->link_config.interface);
+	ret = phylink_attach_phy(pl, phy, pl->link_config.interface);
+	if (ret < 0)
+		return ret;
+
+	ret = phylink_bringup_phy(pl, phy);
+	if (ret)
+		phy_detach(phy);
+
+	return ret;
 }
 
 static void phylink_sfp_disconnect_phy(void *upstream)
-- 
2.20.1

