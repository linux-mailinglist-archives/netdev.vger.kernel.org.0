Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13086FE61A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKOT5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:57:06 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49976 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOT5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:57:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MmokANADVNxSKfPnBLkOrQaIxUZ7Bt71vd5PbXhA/1M=; b=a6YahVWcSx1Pk3yRR1HLMiQ8O6
        EQSOjejNzdToRm+dcO/oVkUEk7KNxPY+gmPlNmTZJGrJ/34jgzsNp/ca6ZgElI0aiXTNhULno2U9W
        Ptq+lS4grhRAYezTiZUf1AWBgf9/kzYPcEqBPB64++To3tEqDtp4XhTrQe3n7irY+soDOKtKGdsD9
        h4qeDXepdBGQERsxkbZpYzT7u7C0TnHD3O71wHXKXN1JBGhvflkXrtXKuFe33IbUG5yW5GMAW6EQi
        Off56fE83ymK7ufYkjsC+jZEDuuR7A4jFby7LN7+j7CGGLtjRH4K3wPQIw1rVznteAX3vl4J4MaVm
        W0sC4/Vg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:55148 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhi8-00036s-Pl; Fri, 15 Nov 2019 19:56:52 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhi7-0007b1-99; Fri, 15 Nov 2019 19:56:51 +0000
In-Reply-To: <20191115195339.GR25745@shell.armlinux.org.uk>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: phy: add core phylib sfp support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iVhi7-0007b1-99@rmk-PC.armlinux.org.uk>
Date:   Fri, 15 Nov 2019 19:56:51 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add core phylib help for supporting SFP sockets on PHYs.  This provides
a mechanism to inform the SFP layer about PHY up/down events, and also
unregister the SFP bus when the PHY is going away.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c        |  7 ++++
 drivers/net/phy/phy_device.c | 66 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 11 ++++++
 3 files changed, 84 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0a314cf45408..cb9ab24ee898 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -23,6 +23,7 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/sfp.h>
 #include <linux/workqueue.h>
 #include <linux/mdio.h>
 #include <linux/io.h>
@@ -866,6 +867,9 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
+	if (phydev->sfp_bus)
+		sfp_upstream_stop(phydev->sfp_bus);
+
 	phydev->state = PHY_HALTED;
 
 	mutex_unlock(&phydev->lock);
@@ -900,6 +904,9 @@ void phy_start(struct phy_device *phydev)
 		goto out;
 	}
 
+	if (phydev->sfp_bus)
+		sfp_upstream_start(phydev->sfp_bus);
+
 	/* if phy was suspended, bring the physical link up again */
 	__phy_resume(phydev);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9ddfb8b0ce04..ff47ec245100 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -27,6 +27,7 @@
 #include <linux/bitmap.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/sfp.h>
 #include <linux/mdio.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
@@ -1174,6 +1175,65 @@ phy_standalone_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(phy_standalone);
 
+/**
+ * phy_sfp_attach - attach the SFP bus to the PHY upstream network device
+ * @upstream: pointer to the phy device
+ * @bus: sfp bus representing cage being attached
+ *
+ * This is used to fill in the sfp_upstream_ops .attach member.
+ */
+void phy_sfp_attach(void *upstream, struct sfp_bus *bus)
+{
+	struct phy_device *phydev = upstream;
+
+	if (phydev->attached_dev)
+		phydev->attached_dev->sfp_bus = bus;
+	phydev->sfp_bus_attached = true;
+}
+EXPORT_SYMBOL(phy_sfp_attach);
+
+/**
+ * phy_sfp_detach - detach the SFP bus from the PHY upstream network device
+ * @upstream: pointer to the phy device
+ * @bus: sfp bus representing cage being attached
+ *
+ * This is used to fill in the sfp_upstream_ops .detach member.
+ */
+void phy_sfp_detach(void *upstream, struct sfp_bus *bus)
+{
+	struct phy_device *phydev = upstream;
+
+	if (phydev->attached_dev)
+		phydev->attached_dev->sfp_bus = NULL;
+	phydev->sfp_bus_attached = false;
+}
+EXPORT_SYMBOL(phy_sfp_detach);
+
+/**
+ * phy_sfp_probe - probe for a SFP cage attached to this PHY device
+ * @phydev: Pointer to phy_device
+ * @ops: SFP's upstream operations
+ */
+int phy_sfp_probe(struct phy_device *phydev,
+		  const struct sfp_upstream_ops *ops)
+{
+	struct sfp_bus *bus;
+	int ret;
+
+	if (phydev->mdio.dev.fwnode) {
+		bus = sfp_bus_find_fwnode(phydev->mdio.dev.fwnode);
+		if (IS_ERR(bus))
+			return PTR_ERR(bus);
+
+		phydev->sfp_bus = bus;
+
+		ret = sfp_bus_add_upstream(bus, phydev, ops);
+		sfp_bus_put(bus);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(phy_sfp_probe);
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1249,6 +1309,9 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (dev) {
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
+
+		if (phydev->sfp_bus_attached)
+			dev->sfp_bus = phydev->sfp_bus;
 	}
 
 	/* Some Ethernet drivers try to connect to a PHY device before
@@ -2333,6 +2396,9 @@ static int phy_remove(struct device *dev)
 	phydev->state = PHY_DOWN;
 	mutex_unlock(&phydev->lock);
 
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	if (phydev->drv && phydev->drv->remove) {
 		phydev->drv->remove(phydev);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1f9a141ccfb4..9753d9f28d73 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -203,6 +203,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 
 struct device;
 struct phylink;
+struct sfp_bus;
+struct sfp_upstream_ops;
 struct sk_buff;
 
 /*
@@ -342,6 +344,8 @@ struct phy_c45_device_ids {
  * dev_flags: Device-specific flags used by the PHY driver.
  * irq: IRQ number of the PHY's interrupt (-1 if none)
  * phy_timer: The timer for handling the state machine
+ * sfp_bus_attached: flag indicating whether the SFP bus has been attached
+ * sfp_bus: SFP bus attached to this PHY's fiber port
  * attached_dev: The attached enet driver's device instance ptr
  * adjust_link: Callback for the enet controller to respond to
  * changes in the link state.
@@ -430,6 +434,9 @@ struct phy_device {
 
 	struct mutex lock;
 
+	/* This may be modified under the rtnl lock */
+	bool sfp_bus_attached;
+	struct sfp_bus *sfp_bus;
 	struct phylink *phylink;
 	struct net_device *attached_dev;
 
@@ -1015,6 +1022,10 @@ int phy_suspend(struct phy_device *phydev);
 int phy_resume(struct phy_device *phydev);
 int __phy_resume(struct phy_device *phydev);
 int phy_loopback(struct phy_device *phydev, bool enable);
+void phy_sfp_attach(void *upstream, struct sfp_bus *bus);
+void phy_sfp_detach(void *upstream, struct sfp_bus *bus);
+int phy_sfp_probe(struct phy_device *phydev,
+	          const struct sfp_upstream_ops *ops);
 struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 			      phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
-- 
2.20.1

