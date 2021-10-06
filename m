Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D646D4241A4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhJFPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239230AbhJFPqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D57A161183;
        Wed,  6 Oct 2021 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535101;
        bh=5rmHuNFQVbItrxxMi67UxT/6YXZHI4ggsjfy/5r6efs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq+eQdO0W7/2bLqcvKhIKIBkGkibTJUykPQxH/VPteynnRJ3lhT1v0n3hA/KJU8Ll
         4Eh3ZCZM9RB1QL4phlb6eRzftuNevq3zN/Ntt3aFit08P1vFoixMbpBspow8W6R/WP
         FGL+HpDo9f8w3ZscTibpqnlYpyAel+HemCx6b6+bGOQmMOAtewJ50+s3U9c6Hzz+Yi
         xIG9B/w34LsbVnvnOo5Jp+gV8R2GTAlGOXRCzcfa/rCv1A5i13jo1IkmwamYSm+quf
         ooKFFAipnmmh6Eqs+2vEsvg7J65Iwa1dIK5Crh+CCCtCnkFveir2J+w2U+t/gaFWA5
         i07ewhqw0m8Mg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/9] of: net: add a helper for loading netdev->dev_addr
Date:   Wed,  6 Oct 2021 08:44:19 -0700
Message-Id: <20211006154426.3222199-3-kuba@kernel.org>
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
index daef3b0d9270..314b9accd98c 100644
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

