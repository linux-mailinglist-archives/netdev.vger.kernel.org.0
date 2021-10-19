Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F82433301
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhJSKCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhJSKCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:02:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CD0C061745
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9MSk+3BpIs07upbf8HJPJAddJOysixvdlenboAJ8gV4=; b=IGIOLLL6xMjwgsoAd/Thf6I89R
        MHH+7Apjyf+RGMkZ2NAvyqJTEX2npkaJ0zhy4LsINSTagTYXiLH8w/Q7x2TV5yf/luQse1id+M8S3
        IzCtQPX0M01riwOM9mTBKwvci+TjNLFv73h24DZ7gLx4EsnZ5F4OuIBnykTTB5PIepdz6AdKBaht8
        RsxfBTCgcoE100qTpM++64sZnLIEDzPasJVww7pewZ+JLHVeoN6sNJQsYCDtQLklWfuXvrBC2g4N5
        Q98hXLS3yOe9l4Hw+nGcDBH8axc/8XQEOwPZPDw/DDJO0qkC3WXY5liFi4FWA65ldabYzWnFlAuRc
        rvTHys/w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60972 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mclue-0005xw-UQ; Tue, 19 Oct 2021 11:00:05 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mclue-005LYy-Fd; Tue, 19 Oct 2021 11:00:04 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: rejig SFP interface selection in
 ksettings_set()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mclue-005LYy-Fd@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 19 Oct 2021 11:00:04 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ea269a6f7207 ("net: phylink: Update SFP selected interface on
advertising changes") added a better solution to selecting the
interface mode for SFPs using the advertisement mask. This method will
work for mvneta and mvpp2 when selecting between 2500base-X and
1000base-X without needing to use the basex helper, or indicate that
we support both 1000base-X and 2500base-X when in either of these two
interface modes.

Hence, we need to eliminate the validation prior to selecting the
interface, otherwise when we clean up mvneta's validation function, we
will end up locking to 2500base-X as we validate with an interface mode
of PHY_INERFACE_MODE_2500BASEX.

The supported mask will already have been reduced down to the union of
support for the SFP and MAC already, so we can be confident that the
advertisement mask is already appropriately restricted. We only need to
select the appropriate interface, and then revalidate with the new
interface mode.

We get rid of the check for pl->sfp_port too, this is meaningless here
as it doesn't get cleared when a module is removed, so it doesn't
indicate if a module is present. Just rely on pl->sfp_bus.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ab651f6197cc..f6e848f1181c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1613,20 +1613,11 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,
 			 config.an_enabled);
 
-	/* Validate without changing the current supported mask. */
-	linkmode_copy(support, pl->supported);
-	if (phylink_validate(pl, support, &config))
-		return -EINVAL;
-
-	/* If autonegotiation is enabled, we must have an advertisement */
-	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
-		return -EINVAL;
-
 	/* If this link is with an SFP, ensure that changes to advertised modes
 	 * also cause the associated interface to be selected such that the
 	 * link can be configured correctly.
 	 */
-	if (pl->sfp_port && pl->sfp_bus) {
+	if (pl->sfp_bus) {
 		config.interface = sfp_select_interface(pl->sfp_bus,
 							config.advertising);
 		if (config.interface == PHY_INTERFACE_MODE_NA) {
@@ -1646,8 +1637,17 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 				    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
 			return -EINVAL;
 		}
+	} else {
+		/* Validate without changing the current supported mask. */
+		linkmode_copy(support, pl->supported);
+		if (phylink_validate(pl, support, &config))
+			return -EINVAL;
 	}
 
+	/* If autonegotiation is enabled, we must have an advertisement */
+	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
+		return -EINVAL;
+
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
-- 
2.30.2

