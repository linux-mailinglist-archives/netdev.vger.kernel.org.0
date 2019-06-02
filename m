Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2971B32382
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 16:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFBONG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 10:13:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35230 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBONG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 10:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fGUDYUlZv1P9M2NShtU9t7DVk5Kjb7tgB11eNEqgCPE=; b=RxVrdHA1fiURmxwbMZtTqSE79X
        eX4lJJFq91ZxsLctb8qq+FB2NIF9vUb1RJZ2BDW5mJhtH6g5Re+dQ0ZdvJlOx+WSP1y34ZKDuFmJG
        Pgi3m6ZaRH7dCOkl6YAW3LQfZZ3oPqRgZ2x2C0nHbE+SKjL1TLRMsiz0bgCsWwei9i/6NOq/dKwq2
        3yU5D2N+fDJ31BrbgAZGL+4RWFDx72KgaVzjvkvDFnvnZ2IzFg9tirLxZmaaqXR+oRRRhBtEWackX
        +hzIcnLfJhmZeuLsokmJoZeYQJOphD8y397sI7csFUZ8SaOJcx0MjrPCo1efDe20vI32KjY4cxzNC
        4+sgHZ/w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56592 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hXREF-0005Qa-Du; Sun, 02 Jun 2019 15:12:55 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hXREE-0005KM-Jy; Sun, 02 Jun 2019 15:12:54 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] net: phylink: avoid reducing support mask
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hXREE-0005KM-Jy@rmk-PC.armlinux.org.uk>
Date:   Sun, 02 Jun 2019 15:12:54 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid reducing the support mask as a result of the interface type
selected for SFP modules, or when setting the link settings through
ethtool - this should only change when the supported link modes of
the hardware combination change.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9044b95d2afe..4c0616ba314d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1073,6 +1073,7 @@ EXPORT_SYMBOL_GPL(phylink_ethtool_ksettings_get);
 int phylink_ethtool_ksettings_set(struct phylink *pl,
 				  const struct ethtool_link_ksettings *kset)
 {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct ethtool_link_ksettings our_kset;
 	struct phylink_link_state config;
 	int ret;
@@ -1083,11 +1084,12 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	    kset->base.autoneg != AUTONEG_ENABLE)
 		return -EINVAL;
 
+	linkmode_copy(support, pl->supported);
 	config = pl->link_config;
 
 	/* Mask out unsupported advertisements */
 	linkmode_and(config.advertising, kset->link_modes.advertising,
-		     pl->supported);
+		     support);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	if (kset->base.autoneg == AUTONEG_DISABLE) {
@@ -1097,7 +1099,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 * duplex.
 		 */
 		s = phy_lookup_setting(kset->base.speed, kset->base.duplex,
-				       pl->supported, false);
+				       support, false);
 		if (!s)
 			return -EINVAL;
 
@@ -1126,7 +1128,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);
 	}
 
-	if (phylink_validate(pl, pl->supported, &config))
+	if (phylink_validate(pl, support, &config))
 		return -EINVAL;
 
 	/* If autonegotiation is enabled, we must have an advertisement */
@@ -1576,6 +1578,7 @@ static int phylink_sfp_module_insert(void *upstream,
 {
 	struct phylink *pl = upstream;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support1);
 	struct phylink_link_state config;
 	phy_interface_t iface;
 	int ret = 0;
@@ -1603,6 +1606,8 @@ static int phylink_sfp_module_insert(void *upstream,
 		return ret;
 	}
 
+	linkmode_copy(support1, support);
+
 	iface = sfp_select_interface(pl->sfp_bus, id, config.advertising);
 	if (iface == PHY_INTERFACE_MODE_NA) {
 		netdev_err(pl->netdev,
@@ -1612,7 +1617,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	}
 
 	config.interface = iface;
-	ret = phylink_validate(pl, support, &config);
+	ret = phylink_validate(pl, support1, &config);
 	if (ret) {
 		netdev_err(pl->netdev, "validation of %s/%s with support %*pb failed: %d\n",
 			   phylink_an_mode_str(MLO_AN_INBAND),
-- 
2.7.4

