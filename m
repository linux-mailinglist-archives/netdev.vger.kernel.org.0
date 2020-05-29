Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA031E7D1E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgE2MZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgE2MZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:25:51 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEE8C08C5C6
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 05:25:51 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:21:946d:6344:ccc1])
        by baptiste.telenet-ops.be with bizsmtp
        id kcRi2200155ue4H01cRi43; Fri, 29 May 2020 14:25:49 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jee4z-0005Pb-Sb; Fri, 29 May 2020 14:25:41 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jee4z-0008Ah-Ot; Fri, 29 May 2020 14:25:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RFT] ravb: Mask PHY mode to avoid inserting delays twice
Date:   Fri, 29 May 2020 14:25:40 +0200
Message-Id: <20200529122540.31368-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until recently, the Micrel KSZ9031 PHY driver ignored any PHY mode
("RGMII-*ID") settings, but used the hardware defaults, augmented by
explicit configuration of individual skew values using the "*-skew-ps"
DT properties.  The lack of PHY mode support was compensated by the
EtherAVB MAC driver, which configures TX and/or RX internal delay
itself, based on the PHY mode.

However, now the KSZ9031 driver has gained PHY mode support, delays may
be configured twice, causing regressions.  E.g. on the Renesas
Salvator-X board with R-Car M3-W ES1.0, TX performance dropped from ca.
400 Mbps to 0.1-0.3 Mbps, as measured by nuttcp.

As internal delay configuration supported by the KSZ9031 PHY is too
limited for some use cases, the ability to configure MAC internal delay
is deemed useful and necessary.  Hence a proper fix would involve
splitting internal delay configuration in two parts, one for the PHY,
and one for the MAC.  However, this would require adding new DT
properties, thus breaking DTB backwards-compatibility.

Hence fix the regression in a backwards-compatibility way, by letting
the EtherAVB driver mask the PHY mode when it has inserted a delay, to
avoid the PHY driver adding a second delay.  This also fixes messages
like:

    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: *-skew-ps values should be used only with phy-mode = "rgmii"

as the PHY no longer sees the original RGMII-*ID mode.

Solving the issue by splitting configuration in two parts can be handled
in future patches, and would require retaining a backwards-compatibility
mode anyway.

Fixes: bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Tested on:
  - Salvator-X with R-Car H3 ES1.0 (limited too 100M, hardware erratum),
  - Salvator-X with R-Car M3-W ES1.0,
  - Salvator-XS with R-Car H3 ES2.0,
  - Salvator-XS with R-Car M3-N ES1.0,
  - Ebisu-4D with R-Car E3 ES1.0 (limited to 100M, no MAC TX delay).

Needs testing on:
  - ULCB with various R-Car H3, M3-W, and M3-N SoCs and revisions,
  - HiHope RZ/G2M sub board, using RGMII-TXID,
  - Eagle and V3MSK with R-Car V3M, using RGMII-ID,

Not affected by this patch, but may still be impacted by the micrel
patch, as it changed skew values for all RGMII* modes, not just for
RGMII-*ID modes, so needs testing:
  - Condor with R-Car V3H, using GEther MAC (support for TX/RX internal
    delay not yet implemented) and RGMII-ID.
  - V3HSK with R-Car V3H, using GEther MAC and RGMII,
  - Draak with R-Car D3 using EtherAVB MAC and RGMII (limited to 100M,
    no MAC TX delay).

Reference:
  "Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
  the KSZ9031 PHY"
  (https://lore.kernel.org/r/CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com/)
---
 drivers/net/ethernet/renesas/ravb_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 067ad25553b92e43..a442bcf64b9cd875 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1014,6 +1014,7 @@ static int ravb_phy_init(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	struct phy_device *phydev;
 	struct device_node *pn;
+	phy_interface_t iface;
 	int err;
 
 	priv->link = 0;
@@ -1032,8 +1033,13 @@ static int ravb_phy_init(struct net_device *ndev)
 		}
 		pn = of_node_get(np);
 	}
-	phydev = of_phy_connect(ndev, pn, ravb_adjust_link, 0,
-				priv->phy_interface);
+
+	iface = priv->phy_interface;
+	if (priv->chip_id != RCAR_GEN2 && phy_interface_mode_is_rgmii(iface)) {
+		/* ravb_set_delay_mode() takes care of internal delay mode */
+		iface = PHY_INTERFACE_MODE_RGMII;
+	}
+	phydev = of_phy_connect(ndev, pn, ravb_adjust_link, 0, iface);
 	of_node_put(pn);
 	if (!phydev) {
 		netdev_err(ndev, "failed to connect PHY\n");
-- 
2.17.1

