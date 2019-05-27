Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645F32BBB2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfE0VXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:23:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50912 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfE0VW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 67654200C62;
        Mon, 27 May 2019 23:22:54 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 57DC4200C59;
        Mon, 27 May 2019 23:22:54 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C1F682060A;
        Mon, 27 May 2019 23:22:53 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 11/11] net: dsa: sja1105: Fix broken fixed-link interfaces on user ports
Date:   Tue, 28 May 2019 00:22:07 +0300
Message-Id: <1558992127-26008-12-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

PHYLIB and PHYLINK handle fixed-link interfaces differently. PHYLIB
wraps them in a software PHY ("pseudo fixed link") phydev construct such
that .adjust_link driver callbacks see an unified API. Whereas PHYLINK
simply creates a phylink_link_state structure and passes it to
.mac_config.

At the time the driver was introduced, DSA was using PHYLIB for the
CPU/cascade ports (the ones with no net devices) and PHYLINK for
everything else.

As explained below:

commit aab9c4067d2389d0adfc9c53806437df7b0fe3d5
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Thu May 10 13:17:36 2018 -0700

  net: dsa: Plug in PHYLINK support

  Drivers that utilize fixed links for user-facing ports (e.g: bcm_sf2)
  will need to implement phylink_mac_ops from now on to preserve
  functionality, since PHYLINK *does not* create a phy_device instance
  for fixed links.

In the above patch, DSA guards the .phylink_mac_config callback against
a NULL phydev pointer.  Therefore, .adjust_link is not called in case of
a fixed-link user port.

This patch fixes the situation by converting the driver from using
.adjust_link to .phylink_mac_config.  This can be done now in a unified
fashion for both slave and CPU/cascade ports because DSA now uses
PHYLINK for all ports.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0663b78a2f6c..cfdefd9f1905 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -734,15 +734,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
 
-static void sja1105_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
+static void sja1105_mac_config(struct dsa_switch *ds, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!phydev->link)
+	if (!state->link)
 		sja1105_adjust_port_config(priv, port, 0, false);
 	else
-		sja1105_adjust_port_config(priv, port, phydev->speed, true);
+		sja1105_adjust_port_config(priv, port, state->speed, true);
 }
 
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
@@ -1515,9 +1516,9 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
-	.adjust_link		= sja1105_adjust_link,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
+	.phylink_mac_config	= sja1105_mac_config,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.21.0

