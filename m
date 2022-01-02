Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248ED482BB9
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiABPtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiABPs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 10:48:59 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92236C061761;
        Sun,  2 Jan 2022 07:48:59 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n436P-00018X-32; Sun, 02 Jan 2022 16:48:57 +0100
Date:   Sun, 2 Jan 2022 15:48:50 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v10 2/3] net: mdio: add helpers to extract clause 45 regad
 and devad fields
Message-ID: <YdHJYuO0rYAoWAfD@makrotopia.org>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdCNZh5PsBwbfMtp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Add a couple of helpers and definitions to extract the clause 45 regad
and devad fields from the regnum passed into MDIO drivers.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v10: correct order of SoB lines
v9: unchanged
v8: First inclusing upon comment on mailing list

 include/linux/mdio.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 9f3587a61e145..ecac96d52e010 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -7,6 +7,7 @@
 #define __LINUX_MDIO_H__
 
 #include <uapi/linux/mdio.h>
+#include <linux/bitfield.h>
 #include <linux/mod_devicetable.h>
 
 /* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
@@ -14,6 +15,7 @@
  */
 #define MII_ADDR_C45		(1<<30)
 #define MII_DEVADDR_C45_SHIFT	16
+#define MII_DEVADDR_C45_MASK	GENMASK(20, 16)
 #define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
 struct gpio_desc;
@@ -381,6 +383,16 @@ static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
 }
 
+static inline u16 mdiobus_c45_regad(u32 regnum)
+{
+	return FIELD_GET(MII_REGADDR_C45_MASK, regnum);
+}
+
+static inline u16 mdiobus_c45_devad(u32 regnum)
+{
+	return FIELD_GET(MII_DEVADDR_C45_MASK, regnum);
+}
+
 static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 				     u16 regnum)
 {
-- 
2.34.1

