Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668B7424B77
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbhJGBJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240158AbhJGBJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DB96113E;
        Thu,  7 Oct 2021 01:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568833;
        bh=flZKj9k4EeR4fOCjIhjxZbheaMUnhhSI4pcH3Uh3Eqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXR1UfSYambCxAqFp/aN6izcHbLu796PM32WRsJAM8ixsMCc1dW/uMmN738J2ZZiT
         cQhObGbLR3z7BMIIO91i1nbTQuf+QiJTnRSH25TitZQKsBm29BQOmzZl+wx2oXTwWH
         x5ggVucXZIyoCs37f1Sby7yx2uZX75jHHQdxy3ezIW41SerH6m0FtJ1x8fRf2tk+1f
         Rs66T1A595BnF2gSgAyqoM8ybkkMd8fNUF02Hinjon882gTfLz5DTFER5RLk4JAOvp
         pckif9In++Mm+BBxK0IXy+KF64IK3sZIn7rZtvYSKSy0ImtrCZ/EhN51NoolUE9KKa
         CzmNou2oixs7w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/9] of: net: add a helper for loading netdev->dev_addr
Date:   Wed,  6 Oct 2021 18:06:55 -0700
Message-Id: <20211007010702.3438216-3-kuba@kernel.org>
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

There are roughly 40 places where netdev->dev_addr is passed
as the destination to a of_get_mac_address() call. Add a helper
which takes a dev pointer instead, so it can call an appropriate
helper.

Note that of_get_mac_address() already assumes the address is
6 bytes long (ETH_ALEN) so use eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/of_net.h |  6 ++++++
 net/core/of_net.c      | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index cf31188329b5..0797e2edb8c2 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -14,6 +14,7 @@
 struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
+int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
 static inline int of_get_phy_mode(struct device_node *np,
@@ -27,6 +28,11 @@ static inline int of_get_mac_address(struct device_node *np, u8 *mac)
 	return -ENODEV;
 }
 
+static inline int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
+{
+	return -ENODEV;
+}
+
 static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
 {
 	return NULL;
diff --git a/net/core/of_net.c b/net/core/of_net.c
index dbac3a172a11..f1a9bf7578e7 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -143,3 +143,28 @@ int of_get_mac_address(struct device_node *np, u8 *addr)
 	return of_get_mac_addr_nvmem(np, addr);
 }
 EXPORT_SYMBOL(of_get_mac_address);
+
+/**
+ * of_get_ethdev_address()
+ * @np:		Caller's Device Node
+ * @dev:	Pointer to netdevice which address will be updated
+ *
+ * Search the device tree for the best MAC address to use.
+ * If found set @dev->dev_addr to that address.
+ *
+ * See documentation of of_get_mac_address() for more information on how
+ * the best address is determined.
+ *
+ * Return: 0 on success and errno in case of error.
+ */
+int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
+{
+	u8 addr[ETH_ALEN];
+	int ret;
+
+	ret = of_get_mac_address(np, addr);
+	if (!ret)
+		eth_hw_addr_set(dev, addr);
+	return ret;
+}
+EXPORT_SYMBOL(of_get_ethdev_address);
-- 
2.31.1

