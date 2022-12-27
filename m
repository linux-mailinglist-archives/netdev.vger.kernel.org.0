Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6146570CA
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiL0XII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiL0XHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:44 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A229E03D;
        Tue, 27 Dec 2022 15:07:27 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9E35F168F;
        Wed, 28 Dec 2022 00:07:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZcKmEvWBu/sPAlrpc3OKARVAht4Rj3HvMDK82/MupfY=;
        b=IKeJ0RNYWS3nnlxaCQbNCpq8E7bei/+8AyyFZvxPM/kv5e3ry1VssNYvSczFmBKViNXhgs
        EUN2pUf74WXpz2tgfU3RB/YK4zQOgmIMK5UWgrQdpWy+8savYKWTxvi6nPjlGi8VTH5dWw
        y3p4jEGzEgzUCKvfS6iZQ0iEYJ+4wn4lcVQag1Q6Af3ax24+ZhFkJzqqZ8Jt50crFtZtoY
        5U6ygbDXidm5nNHB0mGtl4VWmg9G6D0DSdjKgf9lEjicKzy8Fyhc28K7ypyuAJEppdeZUg
        clvl4Cnxb//ZoWOFGnKFArCxEg/fRi93StFYsjq0Casfn+A/DvuglEcgwbEOdQ==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:17 +0100
Subject: [PATCH RFC net-next v2 01/12] net: mdio: Add dedicated C45 API to
 MDIO bus drivers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-1-ddb37710e5a7@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Currently C22 and C45 transactions are mixed over a combined API calls
which make use of a special bit in the reg address to indicate if a
C45 transaction should be performed. This makes it impossible to know
if the bus driver actually supports C45. Additionally, many C22 only
drivers don't return -EOPNOTSUPP when asked to perform a C45
transaction, they mistaking perform a C22 transaction.

This is the first step to cleanly separate C22 from C45. To maintain
backwards compatibility until all drivers which are capable of
performing C45 are converted to this new API, the helper functions
will fall back to the older API if the new API is not
supported. Eventually this fallback will be removed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mdio_bus.c | 189 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  39 +++++-----
 include/linux/phy.h        |   5 ++
 3 files changed, 214 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 1cd604cd1fa1..bde195864c17 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -826,6 +826,100 @@ int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
 
+/**
+ * __mdiobus_c45_read - Unlocked version of the mdiobus_c45_read function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to read
+ *
+ * Read a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
+{
+	int retval;
+
+	lockdep_assert_held_once(&bus->mdio_lock);
+
+	if (bus->read_c45)
+		retval = bus->read_c45(bus, addr, devad, regnum);
+	else
+		retval = bus->read(bus, addr, mdiobus_c45_addr(devad, regnum));
+
+	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+	mdiobus_stats_acct(&bus->stats[addr], true, retval);
+
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_c45_read);
+
+/**
+ * __mdiobus_c45_write - Unlocked version of the mdiobus_write function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * Write a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+			u16 val)
+{
+	int err;
+
+	lockdep_assert_held_once(&bus->mdio_lock);
+
+	if (bus->write_c45)
+		err = bus->write_c45(bus, addr, devad, regnum, val);
+	else
+		err = bus->write(bus, addr, mdiobus_c45_addr(devad, regnum),
+				 val);
+
+	trace_mdio_access(bus, 0, addr, regnum, val, err);
+	mdiobus_stats_acct(&bus->stats[addr], false, err);
+
+	return err;
+}
+EXPORT_SYMBOL(__mdiobus_c45_write);
+
+/**
+ * __mdiobus_c45_modify_changed - Unlocked version of the mdiobus_modify function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to modify
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * Read, modify, and if any change, write the register value back to the
+ * device. Any error returns a negative number.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+static int __mdiobus_c45_modify_changed(struct mii_bus *bus, int addr,
+					int devad, u32 regnum, u16 mask,
+					u16 set)
+{
+	int new, ret;
+
+	ret = __mdiobus_c45_read(bus, addr, devad, regnum);
+	if (ret < 0)
+		return ret;
+
+	new = (ret & ~mask) | set;
+	if (new == ret)
+		return 0;
+
+	ret = __mdiobus_c45_write(bus, addr, devad, regnum, new);
+
+	return ret < 0 ? ret : 1;
+}
+
 /**
  * mdiobus_read_nested - Nested version of the mdiobus_read function
  * @bus: the mii_bus struct
@@ -873,6 +967,29 @@ int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 }
 EXPORT_SYMBOL(mdiobus_read);
 
+/**
+ * mdiobus_c45_read - Convenience function for reading a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to read
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
+{
+	int retval;
+
+	mutex_lock(&bus->mdio_lock);
+	retval = __mdiobus_c45_read(bus, addr, devad, regnum);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_c45_read);
+
 /**
  * mdiobus_write_nested - Nested version of the mdiobus_write function
  * @bus: the mii_bus struct
@@ -922,6 +1039,31 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * mdiobus_c45_write - Convenience function for writing a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		      u16 val)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_c45_write(bus, addr, devad, regnum, val);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(mdiobus_c45_write);
+
 /**
  * mdiobus_modify - Convenience function for modifying a given mdio device
  *	register
@@ -943,6 +1085,30 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
 }
 EXPORT_SYMBOL_GPL(mdiobus_modify);
 
+/**
+ * mdiobus_c45_modify - Convenience function for modifying a given mdio device
+ *	register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int mdiobus_c45_modify(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		       u16 mask, u16 set)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_c45_modify_changed(bus, addr, devad, regnum,
+					   mask, set);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err < 0 ? err : 0;
+}
+EXPORT_SYMBOL_GPL(mdiobus_c45_modify);
+
 /**
  * mdiobus_modify_changed - Convenience function for modifying a given mdio
  *	device register and returning if it changed
@@ -965,6 +1131,29 @@ int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(mdiobus_modify_changed);
 
+/**
+ * mdiobus_c45_modify_changed - Convenience function for modifying a given mdio
+ *	device register and returning if it changed
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int mdiobus_c45_modify_changed(struct mii_bus *bus, int devad, int addr,
+			       u32 regnum, u16 mask, u16 set)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_c45_modify_changed(bus, addr, devad, regnum, mask, set);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mdiobus_c45_modify_changed);
+
 /**
  * mdio_bus_match - determine if given MDIO driver supports the given
  *		    MDIO device
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index f7fbbf3069e7..1e78c8410b21 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -423,6 +423,17 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int __mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
+			u16 val);
+int mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
+		      u16 val);
+int mdiobus_c45_modify(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		       u16 mask, u16 set);
+
+int mdiobus_c45_modify_changed(struct mii_bus *bus, int addr, int devad,
+			       u32 regnum, u16 mask, u16 set);
 
 static inline int mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
 {
@@ -463,29 +474,19 @@ static inline u16 mdiobus_c45_devad(u32 regnum)
 	return FIELD_GET(MII_DEVADDR_C45_MASK, regnum);
 }
 
-static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
-				     u16 regnum)
+static inline int mdiodev_c45_modify(struct mdio_device *mdiodev, int devad,
+				     u32 regnum, u16 mask, u16 set)
 {
-	return __mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
+	return mdiobus_c45_modify(mdiodev->bus, mdiodev->addr, devad, regnum,
+				  mask, set);
 }
 
-static inline int __mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
-				      u16 regnum, u16 val)
+static inline int mdiodev_c45_modify_changed(struct mdio_device *mdiodev,
+					     int devad, u32 regnum, u16 mask,
+					     u16 set)
 {
-	return __mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum),
-			       val);
-}
-
-static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
-				   u16 regnum)
-{
-	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
-}
-
-static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
-				    u16 regnum, u16 val)
-{
-	return mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum), val);
+	return mdiobus_c45_modify_changed(mdiodev->bus, mdiodev->addr, devad,
+					  regnum, mask, set);
 }
 
 static inline int mdiodev_c45_read(struct mdio_device *mdiodev, int devad,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..c33ad3255e3a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -364,6 +364,11 @@ struct mii_bus {
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	/** @write: Perform a write transfer on the bus */
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	/** @read: Perform a C45 read transfer on the bus */
+	int (*read_c45)(struct mii_bus *bus, int addr, int devnum, int regnum);
+	/** @write: Perform a C45 write transfer on the bus */
+	int (*write_c45)(struct mii_bus *bus, int addr, int devnum,
+			 int regnum, u16 val);
 	/** @reset: Perform a reset of the bus */
 	int (*reset)(struct mii_bus *bus);
 

-- 
2.30.2
