Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63BD457085
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhKSOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235820AbhKSOZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584F061B27;
        Fri, 19 Nov 2021 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331720;
        bh=t7AwmsrV6rHp0EOmVNoeE9eU/vY3KRVesw5b7q4k0d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/ycqw1W3FMMEUpEo1uSWDxKTzpWqbzSpTeyp0Z0xKu5ZvE3VMeqaXfuFWxu66EfF
         pWD6//6uDRrPkh0AzeiHLDOpBia8y26OS5ROZGyHuKP5+v+WnxkT449FJPcZksQCS5
         sNbKlcWhtFb7VAgXULCw2uMToroRAcjtAP50cQS941Oc9m2lMBfrLpnyRwkLtH3wvk
         mB/eR+mdcRA1YuQo0GTaJ/pDtttdI8kL09cM3jc2Sc8OB7Hd5wZ4eaSmhhGS+hjNca
         sG/05vVxNLGZNGzyMpmxKNN5PoOfMtP9I7bPDYBykfHK/pFaqAfuWfttUD6h4qp8EF
         rpT+8U15QHxdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/7] dev_addr: add a modification check
Date:   Fri, 19 Nov 2021 06:21:53 -0800
Message-Id: <20211119142155.3779933-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
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
 include/linux/netdevice.h |  5 +++++
 net/core/dev.c            |  1 +
 net/core/dev_addr_lists.c | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2462195784a9..cb7f2661d187 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1942,6 +1942,8 @@ enum netdev_ml_priv_type {
  *	@unlink_list:	As netif_addr_lock() can be called recursively,
  *			keep a list of interfaces to be deleted.
  *
+ *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2268,6 +2270,8 @@ struct net_device {
 
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
+
+	u8 dev_addr_shadow[MAX_ADDR_LEN];
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4288,6 +4292,7 @@ int dev_addr_del(struct net_device *dev, const unsigned char *addr,
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

