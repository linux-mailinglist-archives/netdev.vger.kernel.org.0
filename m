Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723E6332A9A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhCIPfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCIPfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:35:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99867C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 07:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cmlBmA5Ca69zVrKrDHTWi29oFz0YaiLJKE2F5q2givo=; b=FMv4PfzSHk40Q3EqOTmwoa2esV
        6EcEhFcyDOuB82ovhoF4jJHflc4iMVwnGPVZcsA9g7MMeRfrboyHcRcYI6rpsk30lbsnxGVGmsRBP
        0LqhSbHAh+MvojH49COuH/9uM0hWVqQZbrPylCUvdEPoHYK1BXDjDOpEqegwmgRDpBcPI9zhMJHHA
        dZT19O0S+6Lwa6++NzqWQeeESdQtfrSEUMMrYPLnsbYbtGWb68jeuawUwUZXn5N3wkgF8XBBeWi5q
        5XVary4nm7pQUNhk4auGz/uLAYTCmRsr9x176LnuNxlmVb5ZRb4n8glIHLorqcIYrouR0VHc95wqs
        6LDkb5hg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47366 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lJeO1-0003h1-RK; Tue, 09 Mar 2021 15:35:05 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lJeO1-0008Vj-Jk; Tue, 09 Mar 2021 15:35:05 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dpaa2-mac: add support for more ethtool 10G
 link modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lJeO1-0008Vj-Jk@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 09 Mar 2021 15:35:05 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink documentation says:
 * Note that the PHY may be able to transform from one connection
 * technology to another, so, eg, don't clear 1000BaseX just
 * because the MAC is unable to BaseX mode. This is more about
 * clearing unsupported speeds and duplex settings. The port modes
 * should not be cleared; phylink_set_port_modes() will help with this.

So add the missing 10G modes. This allows SFP+ modules to be used with
the SolidRun boards.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ccaf7e35abeb..c2a889ac089a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -125,6 +125,11 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_USXGMII:
 		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseER_Full);
 		if (state->interface == PHY_INTERFACE_MODE_10GBASER)
 			break;
 		phylink_set(mask, 5000baseT_Full);
-- 
2.20.1

