Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9D2CDD0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfE1RlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:41:06 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43248 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfE1Rky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:40:54 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C86EA20102E;
        Tue, 28 May 2019 19:40:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BB21B20102B;
        Tue, 28 May 2019 19:40:51 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 237F7205F4;
        Tue, 28 May 2019 19:40:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 07/11] net: phylink: Add PHYLINK_DEV operation type
Date:   Tue, 28 May 2019 20:38:13 +0300
Message-Id: <1559065097-31832-8-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the PHYLINK_DEV operation type, the PHYLINK infrastructure can work
without an attached net_device. For printing usecases, instead, a struct
device * should be passed to PHYLINK using the phylink_config structure.

Also, netif_carrier_* calls ar guarded by the presence of a valid
net_device. When using the PHYLINK_DEV operation type, we cannot check
link status using the netif_carrier_ok() API so instead, keep an
internal state of the MAC and call mac_link_{down,up} only when the link
changed.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
 - none

 drivers/net/phy/phylink.c | 25 ++++++++++++++++++++-----
 include/linux/phylink.h   |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5a283bf9d402..5f6120f3fa3f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -42,6 +42,8 @@ struct phylink {
 	struct net_device *netdev;
 	const struct phylink_mac_ops *ops;
 	struct phylink_config *config;
+	struct device *dev;
+	unsigned int old_link_state:1;
 
 	unsigned long phylink_disable_state; /* bitmask of disables */
 	struct phy_device *phydev;
@@ -404,7 +406,8 @@ static void phylink_mac_link_up(struct phylink *pl,
 			     pl->phy_state.interface,
 			     pl->phydev);
 
-	netif_carrier_on(ndev);
+	if (ndev)
+		netif_carrier_on(ndev);
 
 	netdev_info(ndev,
 		    "Link is Up - %s/%s - flow control %s\n",
@@ -417,7 +420,8 @@ static void phylink_mac_link_down(struct phylink *pl)
 {
 	struct net_device *ndev = pl->netdev;
 
-	netif_carrier_off(ndev);
+	if (ndev)
+		netif_carrier_off(ndev);
 	pl->ops->mac_link_down(pl->config, pl->link_an_mode,
 			       pl->phy_state.interface);
 	netdev_info(ndev, "Link is Down\n");
@@ -428,6 +432,7 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink *pl = container_of(w, struct phylink, resolve);
 	struct phylink_link_state link_state;
 	struct net_device *ndev = pl->netdev;
+	int link_changed;
 
 	mutex_lock(&pl->state_mutex);
 	if (pl->phylink_disable_state) {
@@ -470,7 +475,13 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
 
-	if (link_state.link != netif_carrier_ok(ndev)) {
+	if (pl->netdev)
+		link_changed = (link_state.link != netif_carrier_ok(ndev));
+	else
+		link_changed = (link_state.link != pl->old_link_state);
+
+	if (link_changed) {
+		pl->old_link_state = link_state.link;
 		if (!link_state.link)
 			phylink_mac_link_down(pl);
 		else
@@ -571,6 +582,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->config = config;
 	if (config->type == PHYLINK_NETDEV) {
 		pl->netdev = to_net_dev(config->dev);
+	} else if (config->type == PHYLINK_DEV) {
+		pl->dev = config->dev;
 	} else {
 		kfree(pl);
 		return ERR_PTR(-EINVAL);
@@ -910,7 +923,8 @@ void phylink_start(struct phylink *pl)
 		    phy_modes(pl->link_config.interface));
 
 	/* Always set the carrier off */
-	netif_carrier_off(pl->netdev);
+	if (pl->netdev)
+		netif_carrier_off(pl->netdev);
 
 	/* Apply the link configuration to the MAC when starting. This allows
 	 * a fixed-link to start with the correct parameters, and also
@@ -1255,7 +1269,8 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		switch (pl->link_an_mode) {
 		case MLO_AN_PHY:
 			/* Silently mark the carrier down, and then trigger a resolve */
-			netif_carrier_off(pl->netdev);
+			if (pl->netdev)
+				netif_carrier_off(pl->netdev);
 			phylink_run_resolve(pl);
 			break;
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 67f35f07ac4b..0f6f65bb9d44 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -56,6 +56,7 @@ struct phylink_link_state {
 
 enum phylink_op_type {
 	PHYLINK_NETDEV = 0,
+	PHYLINK_DEV,
 };
 
 /**
-- 
1.9.1

