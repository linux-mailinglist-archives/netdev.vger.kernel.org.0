Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35018E1A72
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfJWMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:32:44 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46090 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391589AbfJWMcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 08:32:43 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7AC06200254;
        Wed, 23 Oct 2019 14:32:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6B01920024F;
        Wed, 23 Oct 2019 14:32:41 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2D1AF205FE;
        Wed, 23 Oct 2019 14:32:41 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] phylink: add ASSERT_RTNL() on phylink connect functions
Date:   Wed, 23 Oct 2019 15:32:20 +0300
Message-Id: <1571833940-26250-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The appropriate assert on the rtnl lock is not present in phylink's
connect functions which makes unusual calls to them not to be catched.
Add the appropriate ASSERT_RTNL().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phylink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index be7a2c0fa59b..d0aa0c861b2d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -786,6 +786,8 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
  */
 int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
+	ASSERT_RTNL();
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -815,6 +817,8 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	struct phy_device *phy_dev;
 	int ret;
 
+	ASSERT_RTNL();
+
 	/* Fixed links and 802.3z are handled without needing a PHY */
 	if (pl->link_an_mode == MLO_AN_FIXED ||
 	    (pl->link_an_mode == MLO_AN_INBAND &&
-- 
1.9.1

