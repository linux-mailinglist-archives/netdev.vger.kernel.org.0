Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501DE13733D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgAJQU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:20:28 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54017 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbgAJQU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:20:27 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 8E1F14001B;
        Fri, 10 Jan 2020 16:20:24 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v5 04/15] net: phy: add MACsec ops in phy_device
Date:   Fri, 10 Jan 2020 17:19:59 +0100
Message-Id: <20200110162010.338611-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110162010.338611-1-antoine.tenart@bootlin.com>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a reference to MACsec ops in the phy_device, to allow
PHYs to support offloading MACsec operations. The phydev lock will be
held while calling those helpers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/phy.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0cc757ea2264..5179296b3eb5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -333,6 +333,7 @@ struct phy_c45_device_ids {
 };
 
 struct macsec_context;
+struct macsec_ops;
 
 /* phy_device: An instance of a PHY
  *
@@ -356,6 +357,7 @@ struct macsec_context;
  * attached_dev: The attached enet driver's device instance ptr
  * adjust_link: Callback for the enet controller to respond to
  * changes in the link state.
+ * macsec_ops: MACsec offloading ops.
  *
  * speed, duplex, pause, supported, advertising, lp_advertising,
  * and autoneg are used like in mii_if_info
@@ -455,6 +457,11 @@ struct phy_device {
 
 	void (*phy_link_change)(struct phy_device *, bool up, bool do_carrier);
 	void (*adjust_link)(struct net_device *dev);
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec management functions */
+	const struct macsec_ops *macsec_ops;
+#endif
 };
 #define to_phy_device(d) container_of(to_mdio_device(d), \
 				      struct phy_device, mdio)
-- 
2.24.1

