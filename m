Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730B6117033
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLIPTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:19:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35492 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLIPTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:19:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4j8jn4i7yNWH0edixdhaIWtKpHIiokVduoBDxldFkaY=; b=wbc1ryUM4qy77jjiSk8wJwxdDr
        q1iq3hXtcCtXhnR0ExA+wxl8+rh8vtz5eeomHA8Ni+CseAsM8FYypKvmBBeuqdZe4Qjy2fwegOh6Q
        zEBaoVMlrIbFd+mKf/PxuaiLbAZgyVmen+Ns2cb7aFg4KCOnDbu1gqgCs2b+gGG29RyMCKgadOB+l
        6+uxQ+T/6DpIJRk3hymrxQyg/MMR8BTPazAlE2UWvbyowKBQn9zjfL6y28zY3EXL/o1Cg4VsJAOEv
        NGF2HEB5jkdRiJv4YF0RlH4mdvb1YwQq+O7i7+AmXBIiIa4+/n/PcR+bmK8QbuEIinrM2j4UuW3Oy
        2kBVRXXA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54612 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKoR-0003ql-8F; Mon, 09 Dec 2019 15:19:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKoP-0004vF-8F; Mon, 09 Dec 2019 15:19:01 +0000
In-Reply-To: <20191209151553.GP25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 07/14] net: phylink: re-split
 __phylink_connect_phy()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieKoP-0004vF-8F@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 15:19:01 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support Clause 45 PHYs on SFP+ modules, which have an
indeterminant phy interface mode, we need to be able to call
phylink_bringup_phy() with a different interface mode to that used when
binding the PHY. Reduce __phylink_connect_phy() to an attach operation,
and move the call to phylink_bringup_phy() to its call sites.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8c3fafebe667..c32b2c080584 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -764,8 +764,8 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	return 0;
 }
 
-static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
-		phy_interface_t interface)
+static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
+			      phy_interface_t interface)
 {
 	int ret;
 
@@ -777,15 +777,7 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
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
@@ -805,13 +797,23 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
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
 
@@ -1812,8 +1814,17 @@ static void phylink_sfp_link_up(void *upstream)
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
+	int ret;
+
+	ret = phylink_attach_phy(pl, phy, pl->link_config.interface);
+	if (ret < 0)
+		return ret;
+
+	ret = phylink_bringup_phy(pl, phy);
+	if (ret)
+		phy_detach(phy);
 
-	return __phylink_connect_phy(upstream, phy, pl->link_config.interface);
+	return ret;
 }
 
 static void phylink_sfp_disconnect_phy(void *upstream)
-- 
2.20.1

