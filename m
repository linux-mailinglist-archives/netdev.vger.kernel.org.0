Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A58425A89
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbhJGSVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243536AbhJGSUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5894261283;
        Thu,  7 Oct 2021 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633630736;
        bh=PFX8y1pMbhhY3Eyaj3LrRKN7lf2+C9DSnzWmjRwDoSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMKQKmnkoCTs9X8tHHzxus9Mf4TetgYbDtuN/3opmZ/i2m+GJWfPmWMg4SLr5Nm28
         0XG6mXcN7oDQko3fAg7YW37vIXdhkHwL9c+AS9vnkD2mzCsD9r420RWnz1x6fSL6Rv
         1qQan9cdy1mHejwmLp31YERBn9zgje3TeoqkRhrXAnX5Mkrj0L3jFup2FqcLvV0x8n
         uLxgcUfsPTQwSpratqVmQ1Zek9zalnkqtUBHfE4hH6tZnxX+uDEARg+ooYVjNvcR4S
         QkpE9xedOKptniTp4YMqb4zFD1bqmogrNa+MyIH0XaVoHu3DUJQvFIiSNSsnhpUmz+
         rNmNAd6HR+EYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/3] eth: platform: add a helper for loading netdev->dev_addr
Date:   Thu,  7 Oct 2021 11:18:46 -0700
Message-Id: <20211007181847.3529859-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007181847.3529859-1-kuba@kernel.org>
References: <20211007181847.3529859-1-kuba@kernel.org>
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
the destination buffer to eth_platform_get_mac_address().
Add a helper which takes a dev pointer instead, so it can call
an appropriate helper.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: align the temp buffer on the stack
---
 include/linux/etherdevice.h |  1 +
 net/ethernet/eth.c          | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index e75116f48cd1..3cf546d2ffd1 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -29,6 +29,7 @@ struct device;
 struct fwnode_handle;
 
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
+int platform_get_ethdev_address(struct device *dev, struct net_device *netdev);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
 int device_get_mac_address(struct device *dev, char *addr);
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 182de70ac258..c7d9e08107cb 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -523,6 +523,26 @@ int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 }
 EXPORT_SYMBOL(eth_platform_get_mac_address);
 
+/**
+ * platform_get_ethdev_address - Set netdev's MAC address from a given device
+ * @dev:	Pointer to the device
+ * @netdev:	Pointer to netdev to write the address to
+ *
+ * Wrapper around eth_platform_get_mac_address() which writes the address
+ * directly to netdev->dev_addr.
+ */
+int platform_get_ethdev_address(struct device *dev, struct net_device *netdev)
+{
+	u8 addr[ETH_ALEN] __aligned(2);
+	int ret;
+
+	ret = eth_platform_get_mac_address(dev, addr);
+	if (!ret)
+		eth_hw_addr_set(netdev, addr);
+	return ret;
+}
+EXPORT_SYMBOL(platform_get_ethdev_address);
+
 /**
  * nvmem_get_mac_address - Obtain the MAC address from an nvmem cell named
  * 'mac-address' associated with given device.
-- 
2.31.1

