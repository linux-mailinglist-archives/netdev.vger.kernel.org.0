Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578271C7361
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgEFOzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:55:03 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:43029 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgEFOzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:55:02 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2354022EEB;
        Wed,  6 May 2020 16:54:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588776897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1HXOD90+xthCbcF5aODRvO5s4y3GjqVZeWMcm2C9hg=;
        b=m9HhLh3dnD9BTg85PIRYHxEzW+9tKI8srVGI3MjgXJkJaWDcnUKGyPN86orzkyHrB0ai5O
        VyiY7R2tdN04JifV18FNmxuUW/9Pc3kWUfo+q974YzVhTm0Tkrc3osn/smhyhl7PxpHZMl
        VHiTEHII3umwamTkGQq8kpYUr38joLY=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 1/3] net: phy: add concept of shared storage for PHYs
Date:   Wed,  6 May 2020 16:53:13 +0200
Message-Id: <20200506145315.13967-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200506145315.13967-1-michael@walle.cc>
References: <20200506145315.13967-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_bus.c   |   1 +
 drivers/net/phy/phy_device.c | 138 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  89 ++++++++++++++++++++++
 3 files changed, 228 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 3e79b96fa344..255fdfcc13a6 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -614,6 +614,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	mutex_init(&bus->mdio_lock);
+	mutex_init(&bus->shared_lock);
 
 	/* de-assert bus level PHY GPIO reset */
 	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7e1ddd5745d2..b1c5e4503bc4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1461,6 +1461,144 @@ bool phy_driver_is_genphy_10g(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_driver_is_genphy_10g);
 
+/**
+ * phy_package_join - join a common PHY group
+ * @phydev: target phy_device struct
+ * @addr: cookie and PHY address for global register access
+ * @priv_size: if non-zero allocate this amount of bytes for private data
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
+ * If this is the first call for a this cookie the shared storage will be
+ * allocated. If priv_size is non-zero, the given amount of bytes are
+ * allocated for the priv member.
+ *
+ * Returns < 1 on error, 0 on success. Esp. calling phy_package_join()
+ * with the same cookie but a different priv_size is an error.
+ */
+int phy_package_join(struct phy_device *phydev, int addr, size_t priv_size)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	struct phy_package_shared *shared;
+	int ret;
+
+	if (addr < 0 || addr >= PHY_MAX_ADDR)
+		return -EINVAL;
+
+	mutex_lock(&bus->shared_lock);
+	shared = bus->shared[addr];
+	if (!shared) {
+		ret = -ENOMEM;
+		shared = kzalloc(sizeof(*shared), GFP_KERNEL);
+		if (!shared)
+			goto err_unlock;
+		if (priv_size) {
+			shared->priv = kzalloc(priv_size, GFP_KERNEL);
+			if (!shared->priv)
+				goto err_free;
+			shared->priv_size = priv_size;
+		}
+		shared->addr = addr;
+		refcount_set(&shared->refcnt, 1);
+		bus->shared[addr] = shared;
+	} else {
+		ret = -EINVAL;
+		if (priv_size && priv_size != shared->priv_size)
+			goto err_unlock;
+		refcount_inc(&shared->refcnt);
+	}
+	mutex_unlock(&bus->shared_lock);
+
+	phydev->shared = shared;
+
+	return 0;
+
+err_free:
+	kfree(shared);
+err_unlock:
+	mutex_unlock(&bus->shared_lock);
+	return ret;
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
+	struct phy_package_shared *shared = phydev->shared;
+	struct mii_bus *bus = phydev->mdio.bus;
+
+	if (!shared)
+		return;
+
+	if (refcount_dec_and_mutex_lock(&shared->refcnt, &bus->shared_lock)) {
+		bus->shared[shared->addr] = NULL;
+		mutex_unlock(&bus->shared_lock);
+		kfree(shared->priv);
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
+ * @dev: device that is registering this PHY package
+ * @phydev: target phy_device struct
+ * @addr: cookie and PHY address for global register access
+ * @priv_size: if non-zero allocate this amount of bytes for private data
+ *
+ * Managed phy_package_join(). Shared storage fetched by this function,
+ * phy_package_leave() is automatically called on driver detach. See
+ * phy_package_join() for more information.
+ */
+int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
+			  int addr, size_t priv_size)
+{
+	struct phy_device **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_phy_package_leave, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	ret = phy_package_join(phydev, addr, priv_size);
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
index e2bfb9240587..1d36ac608159 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -25,6 +25,7 @@
 #include <linux/u64_stats_sync.h>
 #include <linux/irqreturn.h>
 #include <linux/iopoll.h>
+#include <linux/refcount.h>
 
 #include <linux/atomic.h>
 
@@ -227,6 +228,28 @@ struct mdio_bus_stats {
 	struct u64_stats_sync syncp;
 };
 
+/* Represents a shared structure between different phydev's in the same
+ * package, for example a quad PHY. See phy_package_join() and
+ * phy_package_leave().
+ */
+struct phy_package_shared {
+	int addr;
+	refcount_t refcnt;
+	unsigned long flags;
+	size_t priv_size;
+
+	/* private data pointer */
+	/* note that this pointer is shared between different phydevs and
+	 * the user has to take care of appropriate locking. It is allocated
+	 * and freed automatically by phy_package_join() and
+	 * phy_package_leave().
+	 */
+	void *priv;
+};
+
+/* used as bit number in atomic bitops */
+#define PHY_SHARED_F_INIT_DONE 0
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -278,6 +301,12 @@ struct mii_bus {
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
 
@@ -478,6 +507,10 @@ struct phy_device {
 	/* For use by PHYs to maintain extra state */
 	void *priv;
 
+	/* shared data pointer */
+	/* For use by PHYs inside the same package that need a shared state. */
+	struct phy_package_shared *shared;
+
 	/* Interrupt and Polling infrastructure */
 	struct delayed_work state_queue;
 
@@ -1354,6 +1387,10 @@ int phy_ethtool_get_link_ksettings(struct net_device *ndev,
 int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
+int phy_package_join(struct phy_device *phydev, int addr, size_t priv_size);
+void phy_package_leave(struct phy_device *phydev);
+int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
+			  int addr, size_t priv_size);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
@@ -1406,6 +1443,58 @@ static inline int phy_ethtool_get_stats(struct phy_device *phydev,
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

