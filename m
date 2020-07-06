Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4995021599E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgGFOfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729382AbgGFOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:35:43 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAA8C08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 07:35:42 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed20:e012:1552:6e81:c371])
        by michel.telenet-ops.be with bizsmtp
        id zqbX2200F0tDR5Q06qbXVQ; Mon, 06 Jul 2020 16:35:40 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jsSDT-0004kR-Dm; Mon, 06 Jul 2020 16:35:31 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jsSDT-0004mJ-Bk; Mon, 06 Jul 2020 16:35:31 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 3/7] ravb: Split delay handling in parsing and applying
Date:   Mon,  6 Jul 2020 16:35:25 +0200
Message-Id: <20200706143529.18306-4-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706143529.18306-1-geert+renesas@glider.be>
References: <20200706143529.18306-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, full delay handling is done in both the probe and resume
paths.  Split it in two parts, so the resume path doesn't have to redo
the parsing part over and over again.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
v2:
  - Add Reviewed-by,
  - Use 1 instead of true when assigning to a single-bit bitfield.
---
 drivers/net/ethernet/renesas/ravb.h      |  4 +++-
 drivers/net/ethernet/renesas/ravb_main.c | 21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9f88b5db4f89843a..e5ca12ce93c730a9 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1036,7 +1036,9 @@ struct ravb_private {
 	unsigned no_avb_link:1;
 	unsigned avb_link_active_low:1;
 	unsigned wol_enabled:1;
-	int num_tx_desc;	/* TX descriptors per packet */
+	unsigned rxcidm:1;		/* RX Clock Internal Delay Mode */
+	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
+	int num_tx_desc;		/* TX descriptors per packet */
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a442bcf64b9cd875..1337831eb9bff8f6 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1967,23 +1967,32 @@ static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
 };
 
 /* Set tx and rx clock internal delay modes */
-static void ravb_set_delay_mode(struct net_device *ndev)
+static void ravb_parse_delay_mode(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int set = 0;
 
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID)
-		set |= APSR_DM_RDM;
+		priv->rxcidm = 1;
 
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
 		if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
 			  "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
 			  phy_modes(priv->phy_interface)))
-			set |= APSR_DM_TDM;
+			priv->txcidm = 1;
 	}
+}
 
+static void ravb_set_delay_mode(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	u32 set = 0;
+
+	if (priv->rxcidm)
+		set |= APSR_DM_RDM;
+	if (priv->txcidm)
+		set |= APSR_DM_TDM;
 	ravb_modify(ndev, APSR, APSR_DM, set);
 }
 
@@ -2116,8 +2125,10 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id != RCAR_GEN2)
+	if (priv->chip_id != RCAR_GEN2) {
+		ravb_parse_delay_mode(ndev);
 		ravb_set_delay_mode(ndev);
+	}
 
 	/* Allocate descriptor base address table */
 	priv->desc_bat_size = sizeof(struct ravb_desc) * DBAT_ENTRY_NUM;
-- 
2.17.1

