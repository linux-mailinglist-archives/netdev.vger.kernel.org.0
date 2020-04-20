Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D921B1A1B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgDTX0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgDTX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:26:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49910C061A0F;
        Mon, 20 Apr 2020 16:26:46 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D95B52305B;
        Tue, 21 Apr 2020 01:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587425202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mg55jAWnyGklLpF4hcvYO5UC1V9z/nSb+63z5lgDZRw=;
        b=pFyH0B4W6/Puge5h/kDWGvE7SLohtekorFO4ao75fRJIgCBf7TLFxhBOia9pHERrS7DzwX
        XY/PQ3sdHr9rte9ZyceGdxKBUgnC/l9jk2+tfTLEKW+99d9pJRo4oT7idsvdJm/3Mj3ZUD
        haSy9WM/oAMPix5HRud1fAT5zpzIQhg=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage for PHYs
Date:   Tue, 21 Apr 2020 01:26:22 +0200
Message-Id: <20200420232624.9127-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: D95B52305B
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.870];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are packages which contain multiple PHY devices, eg. a quad PHY
transceiver. Provide functions to allocate and free shared storage.

Usually, a quad PHY contains global registers, which don't belong to any
PHY. Provide convenience functions to access these registers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mdio_bus.c   |   1 +
 drivers/net/phy/phy_device.c | 112 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  86 +++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb74..247cb6610a05 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -611,6 +611,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	mutex_init(&bus->mdio_lock);
+	mutex_init(&bus->shared_lock);
 
 	/* de-assert bus level PHY GPIO reset */
 	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192472..420af3f732c3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1457,6 +1457,118 @@ bool phy_driver_is_genphy_10g(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_driver_is_genphy_10g);
 
+/**
+ * phy_package_join - join a common PHY group
+ * @phydev: target phy_device struct
+ * @addr: cookie and PHY address for global register access
+ *
+ * This joins a PHY group and provides a shared storage for all phydevs in
+ * this group. This is intended to be used for packages which contain
+ * more than one PHY, for example a quad PHY transceiver.
+ *
+ * The addr parameter serves as a cookie which has to have the same value
+ * for all members of one group and as a PHY address to access generic
+ * registers of a PHY package. Usually, one of the PHY addresses of the
+ * different PHYs in the package provides access to these global registers.
+ * The address which is given here, will be used in the phy_package_read()
+ * and phy_package_write() convenience functions. If your PHY doesn't have
+ * global registers you can just pick any of the PHY addresses.
+ *
+ * This will set the shared pointer of the phydev to the shared storage.
+ * If this is the first call for a this cookie the share storage will be
+ * allocated.
+ */
+int phy_package_join(struct phy_device *phydev, int addr)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	struct phy_package_shared *shared;
+
+	if (addr >= PHY_MAX_ADDR)
+		return -EINVAL;
+
+	mutex_lock(&bus->shared_lock);
+	shared = bus->shared[addr];
+	if (!shared) {
+		shared = kzalloc(sizeof(*shared), GFP_KERNEL);
+		shared->addr = addr;
+		refcount_set(&shared->refcnt, 1);
+		bus->shared[addr] = shared;
+	} else {
+		refcount_inc(&shared->refcnt);
+	}
+	mutex_unlock(&bus->shared_lock);
+
+	phydev->shared = shared;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phy_package_join);
+
+/**
+ * phy_package_leave - leave a common PHY group
+ * @phydev: target phy_device struct
+ *
+ * This leaves a PHY group created by phy_package_join(). If this phydev
+ * was the last user of the shared data between the group, this data is
+ * freed. Resets the phydev->shared pointer to NULL.
+ */
+void phy_package_leave(struct phy_device *phydev)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return;
+
+	if (refcount_dec_and_mutex_lock(&shared->refcnt, &bus->shared_lock)) {
+		bus->shared[shared->addr] = NULL;
+		mutex_unlock(&bus->shared_lock);
+		kfree(shared);
+	}
+
+	phydev->shared = NULL;
+}
+EXPORT_SYMBOL_GPL(phy_package_leave);
+
+static void devm_phy_package_leave(struct device *dev, void *res)
+{
+	phy_package_leave(*(struct phy_device **)res);
+}
+
+/**
+ * devm_phy_package_join - resource managed phy_package_join()
+ * @dev: device that is registering this GPIO device
+ * @phydev: target phy_device struct
+ * @addr: cookie and PHY address for global register access
+ *
+ * Managed phy_package_join(). Shared storage fetched by this function,
+ * phy_package_leave() is automatically called on driver detach. See
+ * phy_package_join() for more information.
+ */
+int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
+			  int addr)
+{
+	struct phy_device **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_phy_package_leave, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	ret = phy_package_join(phydev, addr);
+
+	if (!ret) {
+		*ptr = phydev;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_phy_package_join);
+
 /**
  * phy_detach - detach a PHY device from its network device
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca463ddc..d0d85868af76 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -25,6 +25,7 @@
 #include <linux/u64_stats_sync.h>
 #include <linux/irqreturn.h>
 #include <linux/iopoll.h>
+#include <linux/refcount.h>
 
 #include <linux/atomic.h>
 
@@ -227,6 +228,25 @@ struct mdio_bus_stats {
 	struct u64_stats_sync syncp;
 };
 
+
+/* Represents a shared structure between different phydev's in the same
+ * package, for example a quad PHY. See phy_package_join() and
+ * phy_package_leave().
+ */
+struct phy_package_shared {
+	int addr;
+	refcount_t refcnt;
+	unsigned long flags;
+
+	/* private data pointer */
+	/* note that this pointer is shared between different phydevs and
+	 * the user has to take care of appropriate locking.
+	 */
+	void *priv;
+};
+
+#define PHY_SHARED_F_INIT_DONE 0
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -275,6 +295,12 @@ struct mii_bus {
 	int reset_delay_us;
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
+
+	/* protect access to the shared element */
+	struct mutex shared_lock;
+
+	/* shared state across different PHYs */
+	struct phy_package_shared *shared[PHY_MAX_ADDR];
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
@@ -461,6 +487,10 @@ struct phy_device {
 	/* For use by PHYs to maintain extra state */
 	void *priv;
 
+	/* shared data pointer */
+	/* For use by PHYs inside the same package and needs a shared state. */
+	struct phy_package_shared *shared;
+
 	/* Interrupt and Polling infrastructure */
 	struct delayed_work state_queue;
 
@@ -1341,6 +1371,10 @@ int phy_ethtool_get_link_ksettings(struct net_device *ndev,
 int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
+int phy_package_join(struct phy_device *phydev, int addr);
+void phy_package_leave(struct phy_device *phydev);
+int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
+			  int addr);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
@@ -1393,6 +1427,58 @@ static inline int phy_ethtool_get_stats(struct phy_device *phydev,
 	return 0;
 }
 
+static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
+{
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return -EIO;
+
+	return mdiobus_read(phydev->mdio.bus, shared->addr, regnum);
+}
+
+static inline int __phy_package_read(struct phy_device *phydev, u32 regnum)
+{
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return -EIO;
+
+	return __mdiobus_read(phydev->mdio.bus, shared->addr, regnum);
+}
+
+static inline int phy_package_write(struct phy_device *phydev,
+				    u32 regnum, u16 val)
+{
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return -EIO;
+
+	return mdiobus_write(phydev->mdio.bus, shared->addr, regnum, val);
+}
+
+static inline int __phy_package_write(struct phy_device *phydev,
+				      u32 regnum, u16 val)
+{
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return -EIO;
+
+	return __mdiobus_write(phydev->mdio.bus, shared->addr, regnum, val);
+}
+
+static inline bool phy_package_init_once(struct phy_device *phydev)
+{
+	struct phy_package_shared *shared = phydev->shared;
+
+	if (!shared)
+		return false;
+
+	return !test_and_set_bit(PHY_SHARED_F_INIT_DONE, &shared->flags);
+}
+
 extern struct bus_type mdio_bus_type;
 
 struct mdio_board_info {
-- 
2.20.1

