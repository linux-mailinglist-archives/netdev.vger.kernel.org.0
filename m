Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F531524
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfEaTSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:18:33 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:44352 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfEaTSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:18:32 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJIDCm018183
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 13:18:13 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJI9WA010639
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:18:13 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: phylink: support using device PHY in fixed or 802.3z mode
Date:   Fri, 31 May 2019 13:18:05 -0600
Message-Id: <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx AXI Ethernet controller supports SFP modules in 1000BaseX
mode in a somewhat unusual manner: it still exposes a PHY device which
needs some PHY-level initialization for the PCS/PMA layer to work properly,
and which provides some link status/control information.

In this case, we want to use the phylink layer to support proper
communication with the SFP module, but in most other respects we want to
use the PHY attached to the controller.

Currently the phylink driver does not initialize or use a controller PHY
even if it exists for fixed-link or 802.3z PHY modes, and doesn't
support SFP module attachment in those modes. This change allows it to
utilize a controller PHY if it is defined, and allows SFP module
attachment/initialization but does not connect the PHY device to the
controller (to allow the controller PHY to be used for link state
tracking).

Fully supporting this setup would probably require initializing and
tracking the state of both PHYs, which is a much more complex change and
doesn't appear to be required for this use case.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/phylink.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 4fd72c2..9362aca 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -819,12 +819,6 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	struct phy_device *phy_dev;
 	int ret;
 
-	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->link_an_mode == MLO_AN_FIXED ||
-	    (pl->link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_interface)))
-		return 0;
-
 	phy_node = of_parse_phandle(dn, "phy-handle", 0);
 	if (!phy_node)
 		phy_node = of_parse_phandle(dn, "phy", 0);
@@ -1697,9 +1691,6 @@ static int phylink_sfp_module_insert(void *upstream,
 		    phy_modes(config.interface),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
 
-	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
-		return -EINVAL;
-
 	changed = !bitmap_equal(pl->supported, support,
 				__ETHTOOL_LINK_MODE_MASK_NBITS);
 	if (changed) {
@@ -1751,12 +1742,30 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
 
+	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
+	 *  ignore the SFP PHY and just use the PHY attached to the MAC.
+	 */
+	if (pl->link_an_mode == MLO_AN_FIXED ||
+	    (pl->link_an_mode == MLO_AN_INBAND &&
+	      phy_interface_mode_is_8023z(pl->link_config.interface)))
+		return 0;
+
 	return __phylink_connect_phy(upstream, phy, pl->link_config.interface);
 }
 
 static void phylink_sfp_disconnect_phy(void *upstream)
 {
-	phylink_disconnect_phy(upstream);
+	struct phylink *pl = upstream;
+
+	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
+	 * ignore the SFP PHY and just use the PHY attached to the MAC.
+	 */
+	if (pl->link_an_mode == MLO_AN_FIXED ||
+	    (pl->link_an_mode == MLO_AN_INBAND &&
+	      phy_interface_mode_is_8023z(pl->link_config.interface)))
+		return;
+
+	phylink_disconnect_phy(pl);
 }
 
 static const struct sfp_upstream_ops sfp_phylink_ops = {
-- 
1.8.3.1

