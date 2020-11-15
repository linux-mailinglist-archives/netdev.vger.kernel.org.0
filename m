Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C2E2B31A9
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKOAmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:42:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:50546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOAmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:42:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7AEDAAD43;
        Sun, 15 Nov 2020 00:42:04 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Tomas Hlavacek <tomas.hlavacek@nic.cz>,
        =?UTF-8?q?Bed=C5=99icha=20Ko=C5=A1atu?= <bedrich.kosata@nic.cz>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII without comphy
Date:   Sun, 15 Nov 2020 01:41:51 +0100
Message-Id: <20201115004151.12899-1-afaerber@suse.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 (net: ethernet: mvneta:
Add 2500BaseX support for SoCs without comphy) added support for 2500BaseX.

In case a comphy is not provided, mvneta_validate()'s check
  state->interface == PHY_INTERFACE_MODE_2500BASEX
could never be true (it would've returned with empty bitmask before),
so that 2500baseT_Full and 2500baseX_Full do net get added to the mask.

This causes phylink_sfp_config() to fail validation of 2.5G SFP support.

Address this by adding 2500baseX_Full and 2500baseT_Full to the mask for
  state->interface == PHY_INTERFACE_MODE_NA
as well.

Also handle PHY_INTERFACE_MODE_2500BASEX in two checks for allowed modes
and update a comment.

Tested with 2.5G and 1G SFPs on Turris Omnia before assigning comphy.

Fixes: 1a642ca7f389 ("net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy")
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 drivers/net/ethernet/marvell/mvneta.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..c5016036de3a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3812,10 +3812,11 @@ static void mvneta_validate(struct phylink_config *config,
 	struct mvneta_port *pp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* We only support QSGMII, SGMII, 802.3z and RGMII modes */
+	/* We only support QSGMII, SGMII, HSGMII, 802.3z and RGMII modes */
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != PHY_INTERFACE_MODE_QSGMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    state->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    !phy_interface_mode_is_8023z(state->interface) &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -3834,7 +3835,8 @@ static void mvneta_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	}
-	if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
+	if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX
+		       || state->interface == PHY_INTERFACE_MODE_NA) {
 		phylink_set(mask, 2500baseT_Full);
 		phylink_set(mask, 2500baseX_Full);
 	}
@@ -5038,6 +5040,7 @@ static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 
 	if (phy_mode != PHY_INTERFACE_MODE_QSGMII &&
 	    phy_mode != PHY_INTERFACE_MODE_SGMII &&
+	    phy_mode != PHY_INTERFACE_MODE_2500BASEX &&
 	    !phy_interface_mode_is_8023z(phy_mode) &&
 	    !phy_interface_mode_is_rgmii(phy_mode))
 		return -EINVAL;
-- 
2.28.0

