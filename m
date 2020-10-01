Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C6927FCE0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731946AbgJAKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbgJAKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:10:22 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05660C0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:10:21 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id aaAA230054C55Sk06aAAAP; Thu, 01 Oct 2020 12:10:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXO-0001Mj-1q; Thu, 01 Oct 2020 12:10:10 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXO-0003kk-1V; Thu, 01 Oct 2020 12:10:10 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next v4 resend 5/5] ravb: Add support for explicit internal clock delay configuration
Date:   Thu,  1 Oct 2020 12:10:08 +0200
Message-Id: <20201001101008.14365-6-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001101008.14365-1-geert+renesas@glider.be>
References: <20201001101008.14365-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some EtherAVB variants support internal clock delay configuration, which
can add larger delays than the delays that are typically supported by
the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
properties).

Historically, the EtherAVB driver configured these delays based on the
"rgmii-*id" PHY mode.  This caused issues with PHY drivers that
implement PHY internal delays properly[1].  Hence a backwards-compatible
workaround was added by masking the PHY mode[2].

Add proper support for explicit configuration of the MAC internal clock
delays using the new "[rt]x-internal-delay-ps" properties.
Fall back to the old handling if none of these properties is present.

[1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for
    the KSZ9031 PHY")
[2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
    delays twice").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v4:
  - Add Reviewed-by,

v3:
  - No changes,

v2:
  - Add Reviewed-by,
  - Split long line,
  - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
  - Use 1 instead of true when assigning to a single-bit bitfield.
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 36 ++++++++++++++++++------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index e5ca12ce93c730a9..7453b17a37a2c8d0 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1038,6 +1038,7 @@ struct ravb_private {
 	unsigned wol_enabled:1;
 	unsigned rxcidm:1;		/* RX Clock Internal Delay Mode */
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
+	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	int num_tx_desc;		/* TX descriptors per packet */
 };
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 59dadd971345e0d1..aa120e3f1e4d4da5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1034,11 +1034,8 @@ static int ravb_phy_init(struct net_device *ndev)
 		pn = of_node_get(np);
 	}
 
-	iface = priv->phy_interface;
-	if (priv->chip_id != RCAR_GEN2 && phy_interface_mode_is_rgmii(iface)) {
-		/* ravb_set_delay_mode() takes care of internal delay mode */
-		iface = PHY_INTERFACE_MODE_RGMII;
-	}
+	iface = priv->rgmii_override ? PHY_INTERFACE_MODE_RGMII
+				     : priv->phy_interface;
 	phydev = of_phy_connect(ndev, pn, ravb_adjust_link, 0, iface);
 	of_node_put(pn);
 	if (!phydev) {
@@ -1989,20 +1986,41 @@ static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
 };
 
 /* Set tx and rx clock internal delay modes */
-static void ravb_parse_delay_mode(struct net_device *ndev)
+static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	bool explicit_delay = false;
+	u32 delay;
+
+	if (!of_property_read_u32(np, "rx-internal-delay-ps", &delay)) {
+		/* Valid values are 0 and 1800, according to DT bindings */
+		priv->rxcidm = !!delay;
+		explicit_delay = true;
+	}
+	if (!of_property_read_u32(np, "tx-internal-delay-ps", &delay)) {
+		/* Valid values are 0 and 2000, according to DT bindings */
+		priv->txcidm = !!delay;
+		explicit_delay = true;
+	}
 
+	if (explicit_delay)
+		return;
+
+	/* Fall back to legacy rgmii-*id behavior */
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID)
+	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID) {
 		priv->rxcidm = 1;
+		priv->rgmii_override = 1;
+	}
 
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
 		if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
 			  "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
-			  phy_modes(priv->phy_interface)))
+			  phy_modes(priv->phy_interface))) {
 			priv->txcidm = 1;
+			priv->rgmii_override = 1;
+		}
 	}
 }
 
@@ -2148,7 +2166,7 @@ static int ravb_probe(struct platform_device *pdev)
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
 	if (priv->chip_id != RCAR_GEN2) {
-		ravb_parse_delay_mode(ndev);
+		ravb_parse_delay_mode(np, ndev);
 		ravb_set_delay_mode(ndev);
 	}
 
-- 
2.17.1

