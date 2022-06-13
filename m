Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6A1549A04
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbiFMRbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiFMRbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:31:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AEC13C1E5
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hY4fmrNpxg88QslsXhTsyL7htm1xyNT/Thakua5vKQ8=; b=bwJVMq5lsL7uzH5WoGjiYj9iiw
        kTy5HdD8HQgBdbTf/cuVnYoQ+jIM12nuxbc7ydjloRPbSvLV1sI7Djmc7PTSYNO8cX8QqWIBBkXiS
        WsO4bD4DECrDSBs8EV+8m6mt0dFkl4quA3qyq7cqAlmXUd4ncPHan229EqOOn/EwkfjzE9ZECjZUF
        9zTQGW1WnWQfX2HlHLOV5w4Az4rDFrCp0xfGYOa0w3bPyIEUaz+ITH9XqhxqnEeuMpLPsN78hpfT/
        yqIdFuQBTw1vHVug6qIRNJV9LCYOZ2ez+813zpgWMaRt1eEYgbTIg2/6tzkeoOWQi54Jk+iDc2QR6
        j5GXanpg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52088 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgf-0001rh-AX; Mon, 13 Jun 2022 14:00:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jge-000JYn-Mc; Mon, 13 Jun 2022 14:00:56 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 07/15] net: mdio: add unlocked mdiobus and mdiodev
 bus accessors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jge-000JYn-Mc@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:56 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following unlocked accessors to complete the set:
__mdiobus_modify()
__mdiodev_read()
__mdiodev_write()
__mdiodev_modify()
__mdiodev_modify_changed()
which we will need for Marvell DSA PCS conversion.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c | 24 ++++++++++++++++++++++--
 include/linux/mdio.h       | 26 ++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5224ff0ac0db..f8c56e0b7a9d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -922,6 +922,26 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * __mdiobus_modify - Convenience function for modifying a given mdio device
+ *	register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int __mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
+		     u16 set)
+{
+	int err;
+
+	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
+
+	return err < 0 ? err : 0;
+}
+EXPORT_SYMBOL_GPL(__mdiobus_modify);
+
 /**
  * mdiobus_modify - Convenience function for modifying a given mdio device
  *	register
@@ -936,10 +956,10 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
 	int err;
 
 	mutex_lock(&bus->mdio_lock);
-	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
+	err = __mdiobus_modify(bus, addr, regnum, mask, set);
 	mutex_unlock(&bus->mdio_lock);
 
-	return err < 0 ? err : 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(mdiobus_modify);
 
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 0f91ea11777a..9a3a9cded388 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -414,6 +414,8 @@ static inline u32 linkmode_adv_to_mii_t1_adv_m_t(unsigned long *advertising)
 
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int __mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
+		     u16 set);
 int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			     u16 mask, u16 set);
 
@@ -426,6 +428,30 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
 
+static inline int __mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
+{
+	return __mdiobus_read(mdiodev->bus, mdiodev->addr, regnum);
+}
+
+static inline int __mdiodev_write(struct mdio_device *mdiodev, u32 regnum,
+				  u16 val)
+{
+	return __mdiobus_write(mdiodev->bus, mdiodev->addr, regnum, val);
+}
+
+static inline int __mdiodev_modify(struct mdio_device *mdiodev, u32 regnum,
+				   u16 mask, u16 set)
+{
+	return __mdiobus_modify(mdiodev->bus, mdiodev->addr, regnum, mask, set);
+}
+
+static inline int __mdiodev_modify_changed(struct mdio_device *mdiodev,
+					   u32 regnum, u16 mask, u16 set)
+{
+	return __mdiobus_modify_changed(mdiodev->bus, mdiodev->addr, regnum,
+					mask, set);
+}
+
 static inline int mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
 {
 	return mdiobus_read(mdiodev->bus, mdiodev->addr, regnum);
-- 
2.30.2

