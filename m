Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6171DA878E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbfIDN73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:29 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39230 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730126AbfIDN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:21 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 6886F82181E; Wed,  4 Sep 2019 20:53:19 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id F3D15821820;
        Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 4/4] gianfar: use DT more consistently when selecting PHY connection type
Date:   Wed,  4 Sep 2019 20:52:22 +0700
Message-Id: <20190904135223.31754-5-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
 <20190904135223.31754-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, gianfar only used phy-connection-type DT property when
connected to PHY in the rgmii-id mode. It ignored the property otherwise,
relying on the connection type auto-detection carried out by MAC and
providing that reconstructed mode to of_phy_connect(). It also did not
consider alternative phy-mode property at all.

Make the driver properly query DT node for PHY connection type first and
use an obtained value if it was specified there. Otherwise, if a particular
DT relies on connection type auto-detection, fall back to reconstructing
the value from MAC registers, as before.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/net/ethernet/freescale/gianfar.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 17fb412e4bb4..24bf7f68375f 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -639,7 +639,6 @@ static phy_interface_t gfar_get_interface(struct net_device *dev)
 static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 {
 	const char *model;
-	const char *ctype;
 	const void *mac_addr;
 	int err = 0, i;
 	struct net_device *dev = NULL;
@@ -802,13 +801,15 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 				     FSL_GIANFAR_DEV_HAS_TIMER |
 				     FSL_GIANFAR_DEV_HAS_RX_FILER;
 
-	err = of_property_read_string(np, "phy-connection-type", &ctype);
-
-	/* We only care about rgmii-id.  The rest are autodetected */
-	if (err == 0 && !strcmp(ctype, "rgmii-id"))
-		priv->interface = PHY_INTERFACE_MODE_RGMII_ID;
+	/* Use PHY connection type from the DT node if one is specified there.
+	 * rgmii-id really needs to be specified. Other types can be
+	 * detected by hardware
+	 */
+	err = of_get_phy_mode(np);
+	if (err >= 0)
+		priv->interface = err;
 	else
-		priv->interface = PHY_INTERFACE_MODE_MII;
+		priv->interface = gfar_get_interface(dev);
 
 	if (of_find_property(np, "fsl,magic-packet", NULL))
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_MAGIC_PACKET;
@@ -1670,7 +1671,7 @@ static int init_phy(struct net_device *dev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct gfar_private *priv = netdev_priv(dev);
-	phy_interface_t interface;
+	phy_interface_t interface = priv->interface;
 	struct phy_device *phydev;
 	struct ethtool_eee edata;
 
@@ -1686,8 +1687,6 @@ static int init_phy(struct net_device *dev)
 	priv->oldspeed = 0;
 	priv->oldduplex = -1;
 
-	interface = gfar_get_interface(dev);
-
 	phydev = of_phy_connect(dev, priv->phy_node, &adjust_link, 0,
 				interface);
 	if (!phydev) {
-- 
2.23.0

