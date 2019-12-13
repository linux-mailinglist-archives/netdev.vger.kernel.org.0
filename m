Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807B911E700
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfLMPuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:50:21 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45895 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbfLMPuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:50:18 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 2F8FE1C000B;
        Fri, 13 Dec 2019 15:50:16 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v3 07/15] net: phy: export __phy_read_page/__phy_write_page
Date:   Fri, 13 Dec 2019 16:48:36 +0100
Message-Id: <20191213154844.635389-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213154844.635389-1-antoine.tenart@bootlin.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
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
2.23.0

