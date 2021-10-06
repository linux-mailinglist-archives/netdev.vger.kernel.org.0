Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6089D4241AF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbhJFPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239269AbhJFPq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C11861175;
        Wed,  6 Oct 2021 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535104;
        bh=J8SQZOsHErLGjNcMYumV5Wok1ordz77WLwxNfXRIFGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJjhyHbXqqbuTs7lmia5BR2ph9FIbp5boe0ScKuP64uDEhORkL0ZT/WIF5GMGCApn
         VXKD2R84IYTlPy5EnAw+dcQ2Apbsnl8PSnwaCFHg4HfuZxL6LCeVCn30cBTSlzw3Rs
         yb4L9+CKAMWk6/Lj0KFzRelkrYvBDSoN5n4FLzqu5ipv375dQjwMMxys1kWKM0tVHz
         V46rajoSGf5yqbQLwKObQ4iUdU8JOtNohNXniiZFL+ldlyga36SOSXzzzbKPAuMdyE
         FtyNE6u2c5/Gv6vLIWM233ywvwuIrnaI79qxqGjyExVeuZjhpJaZS48QMIvAcUHyaI
         uyro9edU7xcsg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 7/9] eth: fwnode: add a helper for loading netdev->dev_addr
Date:   Wed,  6 Oct 2021 08:44:24 -0700
Message-Id: <20211006154426.3222199-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006154426.3222199-1-kuba@kernel.org>
References: <20211006154426.3222199-1-kuba@kernel.org>
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
index 29447a61d3ec..5441b232d8a4 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -617,3 +617,23 @@ int device_get_mac_address(struct device *dev, char *addr)
 	return fwnode_get_mac_address(dev_fwnode(dev), addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
+
+/**
+ * device_get_ethdev_addr - Set netdev's MAC address from a given device
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

