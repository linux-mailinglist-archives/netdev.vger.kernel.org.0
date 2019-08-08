Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6E863FE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403797AbfHHOKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:16 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:40187 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403794AbfHHOKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:15 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0E7BF200009;
        Thu,  8 Aug 2019 14:10:12 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 7/9] net: phy: export __phy_read_page/__phy_write_page
Date:   Thu,  8 Aug 2019 16:05:58 +0200
Message-Id: <20190808140600.21477-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
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
index 16667fbac8bf..09621193ba2c 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -648,15 +648,17 @@ int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(phy_modify_mmd);
 
-static int __phy_read_page(struct phy_device *phydev)
+int __phy_read_page(struct phy_device *phydev)
 {
 	return phydev->drv->read_page(phydev);
 }
+EXPORT_SYMBOL_GPL(__phy_read_page);
 
-static int __phy_write_page(struct phy_device *phydev, int page)
+int __phy_write_page(struct phy_device *phydev, int page)
 {
 	return phydev->drv->write_page(phydev, page);
 }
+EXPORT_SYMBOL_GPL(__phy_write_page);
 
 /**
  * phy_save_page() - take the bus lock and save the current page
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6947a19587e4..a64b99158b38 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -792,6 +792,9 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
 			 u16 set);
 int phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
 		       u16 set);
+int __phy_read_page(struct phy_device *phydev);
+int __phy_write_page(struct phy_device *phydev, int page);
+
 int __phy_modify(struct phy_device *phydev, u32 regnum, u16 mask, u16 set);
 int phy_modify(struct phy_device *phydev, u32 regnum, u16 mask, u16 set);
 
-- 
2.21.0

