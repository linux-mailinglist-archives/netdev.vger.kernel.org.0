Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07964253FA
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbhJGN1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241031AbhJGN1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9FB761261;
        Thu,  7 Oct 2021 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633613121;
        bh=3k4xtL882TGMiPmDOqwaAftKF2QoH1HBtEur0pztv40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pepyAFxF4HXVyXzaqMWQXzDECralIZC+AScVQyXtvvBl9HXEaouuz/MvAL8JsNGKS
         N3cnOvMwaQbE7ZGtYxZAmo437+eINwAt6kBcnYxvQ5G9mIQ5J53JVoxEoozsxfvpVN
         AnH6Y6JI3bV6NhzOo2P1bHsviRSXiikPkFhrJ7u1YCMmldUBMwTGFbZ2uM1WWixeH3
         s4ymwGuEBV9VQh8OczC1qT+RqFKLfIgCWZWa2yqFzSegvAjW7Y5h8K/MzN3bmB9I4q
         2ae29O5yfuN3WPIwDJUBGV5vZvaYhuGsT9snhYiQQhez9U+rSuPjXncwOiQgBVaoDc
         4maisJKXLlaMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] eth: platform: add a helper for loading netdev->dev_addr
Date:   Thu,  7 Oct 2021 06:25:10 -0700
Message-Id: <20211007132511.3462291-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007132511.3462291-1-kuba@kernel.org>
References: <20211007132511.3462291-1-kuba@kernel.org>
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
index 182de70ac258..63683b11ca4b 100644
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
+	u8 addr[ETH_ALEN];
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

