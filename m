Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D15212603F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLSLAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:25 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39615 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfLSLAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:23 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3CE5160012;
        Thu, 19 Dec 2019 11:00:19 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 07/15] net: phy: export __phy_read_page/__phy_write_page
Date:   Thu, 19 Dec 2019 11:55:07 +0100
Message-Id: <20191219105515.78400-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exports the __phy_read_page and __phy_write_page helpers, to
allow reading and setting the current page when a function already holds
the MDIO lock.

This is something the Microsemi PHY driver does during its
initialization because parts of its registers and engines are shared
between ports. With the upcoming MACsec offloading support in this PHY,
we'll need to configure the MACsec engine and to do so changing pages is
required.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/phy-core.c | 6 ++++--
 include/linux/phy.h        | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 769a076514b0..1075d34518f2 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -695,21 +695,23 @@ int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(phy_modify_mmd);
 
-static int __phy_read_page(struct phy_device *phydev)
+int __phy_read_page(struct phy_device *phydev)
 {
 	if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
 		return -EOPNOTSUPP;
 
 	return phydev->drv->read_page(phydev);
 }
+EXPORT_SYMBOL_GPL(__phy_read_page);
 
-static int __phy_write_page(struct phy_device *phydev, int page)
+int __phy_write_page(struct phy_device *phydev, int page)
 {
 	if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
 		return -EOPNOTSUPP;
 
 	return phydev->drv->write_page(phydev, page);
 }
+EXPORT_SYMBOL_GPL(__phy_write_page);
 
 /**
  * phy_save_page() - take the bus lock and save the current page
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11b92da25681..4179b59c5727 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -802,6 +802,9 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
 			 u16 set);
 int phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
 		       u16 set);
+int __phy_read_page(struct phy_device *phydev);
+int __phy_write_page(struct phy_device *phydev, int page);
+
 int __phy_modify(struct phy_device *phydev, u32 regnum, u16 mask, u16 set);
 int phy_modify(struct phy_device *phydev, u32 regnum, u16 mask, u16 set);
 
-- 
2.24.1

