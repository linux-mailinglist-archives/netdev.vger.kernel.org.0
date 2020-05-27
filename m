Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109EA1E4ABD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391520AbgE0Qqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:46:35 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:63309 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389014AbgE0Qqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:46:34 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 2F65240012;
        Wed, 27 May 2020 16:46:30 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next 1/8] net: phy: add support for a common probe between shared PHYs
Date:   Wed, 27 May 2020 18:41:51 +0200
Message-Id: <20200527164158.313025-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527164158.313025-1-antoine.tenart@bootlin.com>
References: <20200527164158.313025-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shared PHYs (PHYs in the same hardware package) may have shared
registers and their drivers would usually need to share information.
There is currently a way to have a shared (part of the) init, by using
phy_package_init_once(). This patch extends the logic to share parts of
the probe to allow sharing the initialization of locks or resources
retrieval.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/phy.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8c05d0fb5c00..058219b6441f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -244,7 +244,8 @@ struct phy_package_shared {
 };
 
 /* used as bit number in atomic bitops */
-#define PHY_SHARED_F_INIT_DONE 0
+#define PHY_SHARED_F_INIT_DONE  0
+#define PHY_SHARED_F_PROBE_DONE 1
 
 /*
  * The Bus class for PHYs.  Devices which provide access to
@@ -1554,14 +1555,25 @@ static inline int __phy_package_write(struct phy_device *phydev,
 	return __mdiobus_write(phydev->mdio.bus, shared->addr, regnum, val);
 }
 
-static inline bool phy_package_init_once(struct phy_device *phydev)
+static inline bool __phy_package_set_once(struct phy_device *phydev,
+					  unsigned int b)
 {
 	struct phy_package_shared *shared = phydev->shared;
 
 	if (!shared)
 		return false;
 
-	return !test_and_set_bit(PHY_SHARED_F_INIT_DONE, &shared->flags);
+	return !test_and_set_bit(b, &shared->flags);
+}
+
+static inline bool phy_package_init_once(struct phy_device *phydev)
+{
+	return __phy_package_set_once(phydev, PHY_SHARED_F_INIT_DONE);
+}
+
+static inline bool phy_package_probe_once(struct phy_device *phydev)
+{
+	return __phy_package_set_once(phydev, PHY_SHARED_F_PROBE_DONE);
 }
 
 extern struct bus_type mdio_bus_type;
-- 
2.26.2

