Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64D16B4A3
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBXWyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:11 -0500
Received: from foss.arm.com ([217.140.110.172]:43864 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBXWyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9175E31B;
        Mon, 24 Feb 2020 14:54:10 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 809CA3F534;
        Mon, 24 Feb 2020 14:54:10 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v2 1/6] mdio_bus: Add generic mdio_find_bus()
Date:   Mon, 24 Feb 2020 16:53:58 -0600
Message-Id: <20200224225403.1650656-2-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224225403.1650656-1-jeremy.linton@arm.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears most ethernet drivers follow one of two main strategies
for mdio bus/phy management. A monolithic model where the net driver
itself creates, probes and uses the phy, and one where an external
mdio/phy driver instantiates the mdio bus/phy and the net driver
only attaches to a known phy. Usually in this latter model the phys
are discovered via DT relationships or simply phy name/address
hardcoding.

This is a shame because modern well behaved mdio buses are self
describing and can be probed. The mdio layer itself is fully capable
of this, yet there isn't a clean way for a standalone net driver
to attach and enumerate the discovered devices. This is because
outside of of_mdio_find_bus() there isn't a straightforward way
to acquire the mii_bus pointer.

So, lets add a mdio_find_bus which can return the mii_bus based
only on its name.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/mdio_bus.c | 17 +++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 9bb9f37f21dc..3ab9ca7614d1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -462,6 +462,23 @@ static struct class mdio_bus_class = {
 	.dev_groups	= mdio_bus_groups,
 };
 
+/**
+ * mdio_find_bus - Given the name of a mdiobus, find the mii_bus.
+ * @mdio_bus_np: Pointer to the mii_bus.
+ *
+ * Returns a reference to the mii_bus, or NULL if none found.  The
+ * embedded struct device will have its reference count incremented,
+ * and this must be put_deviced'ed once the bus is finished with.
+ */
+struct mii_bus *mdio_find_bus(const char *mdio_name)
+{
+	struct device *d;
+
+	d = class_find_device_by_name(&mdio_bus_class, mdio_name);
+	return d ? to_mii_bus(d) : NULL;
+}
+EXPORT_SYMBOL(mdio_find_bus);
+
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /**
  * of_mdio_find_bus - Given an mii_bus node, find the mii_bus.
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c570e162e05e..bd4ac49a9dbe 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -289,6 +289,7 @@ static inline struct mii_bus *devm_mdiobus_alloc(struct device *dev)
 	return devm_mdiobus_alloc_size(dev, 0);
 }
 
+struct mii_bus *mdio_find_bus(const char *mdio_name);
 void devm_mdiobus_free(struct device *dev, struct mii_bus *bus);
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 
-- 
2.24.1

