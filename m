Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228B031525
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfEaTSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:18:38 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:38596 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfEaTSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:18:37 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJIKQr014237
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 13:18:20 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJI9W9010639
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:18:12 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: phylink: add fallback from SGMII to 1000BaseX
Date:   Fri, 31 May 2019 13:18:04 -0600
Message-Id: <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some copper SFP modules support both SGMII and 1000BaseX, but some
drivers/devices only support the 1000BaseX mode. Currently SGMII mode is
always being selected as the desired mode for such modules, and this
fails if the controller doesn't support SGMII. Add a fallback for this
case by trying 1000BaseX instead if the controller rejects SGMII mode.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/phylink.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 68d0a89..4fd72c2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1626,6 +1626,7 @@ static int phylink_sfp_module_insert(void *upstream,
 {
 	struct phylink *pl = upstream;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(orig_support) = { 0, };
 	struct phylink_link_state config;
 	phy_interface_t iface;
 	int ret = 0;
@@ -1635,6 +1636,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	ASSERT_RTNL();
 
 	sfp_parse_support(pl->sfp_bus, id, support);
+	linkmode_copy(orig_support, support);
 	port = sfp_parse_port(pl->sfp_bus, id, support);
 
 	memset(&config, 0, sizeof(config));
@@ -1663,6 +1665,25 @@ static int phylink_sfp_module_insert(void *upstream,
 
 	config.interface = iface;
 	ret = phylink_validate(pl, support, &config);
+
+	if (ret && iface == PHY_INTERFACE_MODE_SGMII &&
+	    phylink_test(orig_support, 1000baseX_Full)) {
+		/* Copper modules may select SGMII but the interface may not
+		 * support that mode, try 1000BaseX if supported.
+		 */
+
+		netdev_warn(pl->netdev, "validation of %s/%s with support %*pb "
+			    "failed: %d, trying 1000BaseX\n",
+			    phylink_an_mode_str(MLO_AN_INBAND),
+			    phy_modes(config.interface),
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, orig_support, ret);
+		iface = PHY_INTERFACE_MODE_1000BASEX;
+		config.interface = iface;
+		linkmode_copy(config.advertising, orig_support);
+		linkmode_copy(support, orig_support);
+		ret = phylink_validate(pl, support, &config);
+	}
+
 	if (ret) {
 		phylink_err(pl, "validation of %s/%s with support %*pb failed: %d\n",
 			    phylink_an_mode_str(MLO_AN_INBAND),
-- 
1.8.3.1

