Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46D4553AB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbhKRESR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242867AbhKRESH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4AD561B7D;
        Thu, 18 Nov 2021 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208908;
        bh=c11qU6SZ+mSXfBbNMgB+A4fHvlOIrFCzZvkBlo8uKtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEHxycTArEvL0IXZk3R65h0oExH6pFvDinABTqY4dm1wEDM9x1QYJXTaZcgHOM1yI
         lJSQZzrhUfoFA0yBp0rfZeX7QX9ZRoM12EYSxcCU+vFtfVgvd4pNiAmiWnBspKM9by
         IBBue4SiAORcSrvTeZ3kWaHzHM5nduPO5e86rM3SzuEk7miilI5YClG3qdc0R33Qz9
         hNSlHXFw3ypY+7W6+WnHoXox7n1uNiq9yun/dudMjRz9KzpfyhH1y+qawrWsYTnTHo
         V5ByucYNclkCbPXC8Ug7hru4U3CJ8amNMT8uqzhWfSmmDMKABARUBLGcZhOfywwoNU
         u55VVxWv6/YJw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 7/9] dev_addr: add a modification check
Date:   Wed, 17 Nov 2021 20:14:59 -0800
Message-Id: <20211118041501.3102861-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr should only be modified via helpers,
but someone may be casting off the const. Add a runtime
check to catch abuses.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h |  3 +++
 net/core/dev.c            |  1 +
 net/core/dev_addr_lists.c | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2462195784a9..b2ae8b9e04e4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2268,6 +2268,8 @@ struct net_device {
 
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
+
+	u8 dev_addr_shadow[MAX_ADDR_LEN];
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4288,6 +4290,7 @@ int dev_addr_del(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
 void dev_addr_flush(struct net_device *dev);
 int dev_addr_init(struct net_device *dev);
+void dev_addr_check(struct net_device *dev);
 
 /* Functions used for unicast addresses handling */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr);
diff --git a/net/core/dev.c b/net/core/dev.c
index 92c9258cbf28..9219e319e901 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1377,6 +1377,7 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	int ret;
 
 	ASSERT_RTNL();
+	dev_addr_check(dev);
 
 	if (!netif_device_present(dev)) {
 		/* may be detached because parent is runtime-suspended */
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index a23a83ac18e5..969942734951 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -498,6 +498,21 @@ EXPORT_SYMBOL(__hw_addr_init);
  * Device addresses handling functions
  */
 
+/* Check that netdev->dev_addr is not written to directly as this would
+ * break the rbtree layout. All changes should go thru dev_addr_set() and co.
+ * Remove this check in mid-2024.
+ */
+void dev_addr_check(struct net_device *dev)
+{
+	if (!memcmp(dev->dev_addr, dev->dev_addr_shadow, MAX_ADDR_LEN))
+		return;
+
+	netdev_warn(dev, "Current addr:  %*ph\n", MAX_ADDR_LEN, dev->dev_addr);
+	netdev_warn(dev, "Expected addr: %*ph\n",
+		    MAX_ADDR_LEN, dev->dev_addr_shadow);
+	netdev_WARN(dev, "Incorrect netdev->dev_addr\n");
+}
+
 /**
  *	dev_addr_flush - Flush device address list
  *	@dev: device
@@ -509,6 +524,7 @@ EXPORT_SYMBOL(__hw_addr_init);
 void dev_addr_flush(struct net_device *dev)
 {
 	/* rtnl_mutex must be held here */
+	dev_addr_check(dev);
 
 	__hw_addr_flush(&dev->dev_addrs);
 	dev->dev_addr = NULL;
@@ -552,8 +568,11 @@ void dev_addr_mod(struct net_device *dev, unsigned int offset,
 {
 	struct netdev_hw_addr *ha;
 
+	dev_addr_check(dev);
+
 	ha = container_of(dev->dev_addr, struct netdev_hw_addr, addr[0]);
 	memcpy(&ha->addr[offset], addr, len);
+	memcpy(&dev->dev_addr_shadow[offset], addr, len);
 }
 EXPORT_SYMBOL(dev_addr_mod);
 
-- 
2.31.1

