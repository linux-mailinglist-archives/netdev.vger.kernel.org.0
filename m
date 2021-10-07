Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983DA424B83
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbhJGBJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240174AbhJGBJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 444EA611CA;
        Thu,  7 Oct 2021 01:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568836;
        bh=iDx22fctTCKc8UXiTR7/ZHg+R/CctUQUMV/auQ3dtc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATpEnCuOS32SEQEngyAYGBXAzBpgrEjDN0KFK6I+YxP26GAAmgjxjckvKVz2qXK8e
         LuOlS3xpGYdafeeLczvwNXrsSvBNLcBki/Rqwgi9+9bd5hJ/0VsSD+kn/trcCIeGiU
         61hXeLr1ZZv7jAcRTCkfuXpvUi79hmdPjBt55R3Dd5/qLvgzJmFhBCBwpdKTrz3q42
         yRJ7EW/7AkT6CI0NddOXJVAQfsxaT0QhSnhgT/rBVYGaXc8u0Rq+Nm4ZhUWsFKEXhU
         MYIxX/0qL4jrF5G7h3Mql6d4PamDJyhKno9EtmW5Yw/EkZ1VnBS9mRwsd7AYWyTEHh
         4WTbzp3/ehabQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 7/9] eth: fwnode: add a helper for loading netdev->dev_addr
Date:   Wed,  6 Oct 2021 18:07:00 -0700
Message-Id: <20211007010702.3438216-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
References: <20211007010702.3438216-1-kuba@kernel.org>
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
v2: spell out address instead of addr in the function name
v3: fix function name in kdoc
---
 include/linux/etherdevice.h |  1 +
 include/linux/property.h    |  1 +
 net/ethernet/eth.c          | 20 ++++++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 32c30d0f7a73..e75116f48cd1 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -32,6 +32,7 @@ int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
 int device_get_mac_address(struct device *dev, char *addr);
+int device_get_ethdev_address(struct device *dev, struct net_device *netdev);
 int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr);
 
 u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
diff --git a/include/linux/property.h b/include/linux/property.h
index 4fb081684255..88fa726a76df 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 struct device;
+struct net_device;
 
 enum dev_prop_type {
 	DEV_PROP_U8,
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 29447a61d3ec..d7b8fa10fabb 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -617,3 +617,23 @@ int device_get_mac_address(struct device *dev, char *addr)
 	return fwnode_get_mac_address(dev_fwnode(dev), addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
+
+/**
+ * device_get_ethdev_address - Set netdev's MAC address from a given device
+ * @dev:	Pointer to the device
+ * @netdev:	Pointer to netdev to write the address to
+ *
+ * Wrapper around device_get_mac_address() which writes the address
+ * directly to netdev->dev_addr.
+ */
+int device_get_ethdev_address(struct device *dev, struct net_device *netdev)
+{
+	u8 addr[ETH_ALEN];
+	int ret;
+
+	ret = device_get_mac_address(dev, addr);
+	if (!ret)
+		eth_hw_addr_set(netdev, addr);
+	return ret;
+}
+EXPORT_SYMBOL(device_get_ethdev_address);
-- 
2.31.1

