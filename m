Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5532BBAE
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfE0VWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:22:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50830 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfE0VWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:52 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B1AD200C5C;
        Mon, 27 May 2019 23:22:50 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7E59D200C59;
        Mon, 27 May 2019 23:22:50 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id F1CF12060A;
        Mon, 27 May 2019 23:22:49 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 05/11] net: phylink: Add phylink_mac_link_{up,down} wrapper functions
Date:   Tue, 28 May 2019 00:22:01 +0300
Message-Id: <1558992127-26008-6-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that reduces the clutter in phylink_resolve
around calling the .mac_link_up/.mac_link_down driver callbacks.  In a
further patch this logic will be extended to emit notifications in case
a net device does not exist.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phylink.c | 50 +++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 74983593834b..83ab83c3edba 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -395,6 +395,34 @@ static const char *phylink_pause_to_str(int pause)
 	}
 }
 
+static void phylink_mac_link_up(struct phylink *pl,
+				struct phylink_link_state link_state)
+{
+	struct net_device *ndev = pl->netdev;
+
+	pl->ops->mac_link_up(ndev, pl->link_an_mode,
+			     pl->phy_state.interface,
+			     pl->phydev);
+
+	netif_carrier_on(ndev);
+
+	netdev_info(ndev,
+		    "Link is Up - %s/%s - flow control %s\n",
+		    phy_speed_to_str(link_state.speed),
+		    phy_duplex_to_str(link_state.duplex),
+		    phylink_pause_to_str(link_state.pause));
+}
+
+static void phylink_mac_link_down(struct phylink *pl)
+{
+	struct net_device *ndev = pl->netdev;
+
+	netif_carrier_off(ndev);
+	pl->ops->mac_link_down(ndev, pl->link_an_mode,
+			       pl->phy_state.interface);
+	netdev_info(ndev, "Link is Down\n");
+}
+
 static void phylink_resolve(struct work_struct *w)
 {
 	struct phylink *pl = container_of(w, struct phylink, resolve);
@@ -443,24 +471,10 @@ static void phylink_resolve(struct work_struct *w)
 	}
 
 	if (link_state.link != netif_carrier_ok(ndev)) {
-		if (!link_state.link) {
-			netif_carrier_off(ndev);
-			pl->ops->mac_link_down(ndev, pl->link_an_mode,
-					       pl->phy_state.interface);
-			netdev_info(ndev, "Link is Down\n");
-		} else {
-			pl->ops->mac_link_up(ndev, pl->link_an_mode,
-					     pl->phy_state.interface,
-					     pl->phydev);
-
-			netif_carrier_on(ndev);
-
-			netdev_info(ndev,
-				    "Link is Up - %s/%s - flow control %s\n",
-				    phy_speed_to_str(link_state.speed),
-				    phy_duplex_to_str(link_state.duplex),
-				    phylink_pause_to_str(link_state.pause));
-		}
+		if (!link_state.link)
+			phylink_mac_link_down(pl);
+		else
+			phylink_mac_link_up(pl, link_state);
 	}
 	if (!link_state.link && pl->mac_link_dropped) {
 		pl->mac_link_dropped = false;
-- 
2.21.0

