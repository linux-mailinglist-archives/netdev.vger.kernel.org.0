Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811B3422D0C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbhJEPz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236256AbhJEPzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD2261872;
        Tue,  5 Oct 2021 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633449209;
        bh=Jvzf3sR3bi5J3QC5sQKEy/KU3W8kMoCRQL7Zsxfvgk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcqSKmJNkzXDdnqKcVFo3BLx7K3abapF0qp2bXP0GYIjI34iPJRIjKimo6U4BeocJ
         KBquPfNsSOkum+qalw0Spu4i8GU1Y6wVUhN8mOm+Lgb8MbsEN9u1WV+LWlDayXXCr+
         /+so3MXiG1rFmFaxKf5KHUEf8gjMru4zibWPOwjknOE9VyGfkJ8P8z0MDDY3LmvZxy
         ardyORQYNWdLxiUSwSuvFth7v1u04xhmPW98vyvElxZaybRfaIEVB12DyLvfwuTdJk
         TJ/0OyFkfQ9tLO6LKlcmiZaDd5L54YG/KSiUcCkWAWPTcdW3Jt5dBVWNVc/X7v+6R0
         pLX5Um8lItQjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/4] device property: add a helper for loading netdev->dev_addr
Date:   Tue,  5 Oct 2021 08:53:20 -0700
Message-Id: <20211005155321.2966828-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005155321.2966828-1-kuba@kernel.org>
References: <20211005155321.2966828-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

There is a handful of drivers which pass netdev->dev_addr as
the destination buffer to device_get_mac_address(). Add a helper
which takes a dev pointer instead, so it can call an appropriate
helper.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/base/property.c  | 20 ++++++++++++++++++++
 include/linux/property.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 453918eb7390..1c8d4676addc 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -997,6 +997,26 @@ void *device_get_mac_address(struct device *dev, char *addr, int alen)
 }
 EXPORT_SYMBOL(device_get_mac_address);
 
+/**
+ * device_get_ethdev_addr - Set netdev's MAC address from a given device
+ * @dev:	Pointer to the device
+ * @netdev:	Pointer to netdev to write the address to
+ *
+ * Wrapper around device_get_mac_address() which writes the address
+ * directly to netdev->dev_addr.
+ */
+void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev)
+{
+	u8 addr[ETH_ALEN];
+	void *ret;
+
+	ret = device_get_mac_address(dev, addr, ETH_ALEN);
+	if (ret)
+		eth_hw_addr_set(netdev, addr);
+	return ret;
+}
+EXPORT_SYMBOL(device_get_ethdev_addr);
+
 /**
  * fwnode_irq_get - Get IRQ directly from a fwnode
  * @fwnode:	Pointer to the firmware node
diff --git a/include/linux/property.h b/include/linux/property.h
index 357513a977e5..24dc4d2b9dbd 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 struct device;
+struct net_device;
 
 enum dev_prop_type {
 	DEV_PROP_U8,
@@ -390,6 +391,7 @@ const void *device_get_match_data(struct device *dev);
 int device_get_phy_mode(struct device *dev);
 
 void *device_get_mac_address(struct device *dev, char *addr, int alen);
+void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev);
 
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
 void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
-- 
2.31.1

