Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAD13FF304
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346866AbhIBSLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346712AbhIBSLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 14:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26CEF6109E;
        Thu,  2 Sep 2021 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630606240;
        bh=bJKMDSMTDSPzCmUV6+TfycnsnYGDNeK5NjfMv6rYFg8=;
        h=From:To:Cc:Subject:Date:From;
        b=ilR1IgZoi+TbhqezSu4TX/WtFEQG/Y4eam5SgMqer4j+0UDd/Puu9Y/0XCV12ECEc
         bLIEaeHr7hhkuaB7/QZUdRidDnEVHrzdxob3D/HlEkOoV5Ljk0gbWyPFyJT/WukSp3
         967XHv2RW0X7nWkRB6XbGLEkCgUH71lDYUy4QO+fiPpb6kQ7Ck9V+GR3ZrWWktwEcv
         9KDDnZzRG2i1vvP7kAtWzDym/5Ljsged+LtijX5MEKOuSTkGaxK3sffCieJp4g4M9Q
         QkdkEYFTpBgIavHKn93iSIUwpq06emG04nI/J+LH765zx0wvR5CUvkgfWkXcMU8G0z
         3N7IiiRq8OA/A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gnaaman@drivenets.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: create netdev->dev_addr assignment helpers
Date:   Thu,  2 Sep 2021 11:10:37 -0700
Message-Id: <20210902181037.1958358-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent work on converting address list to a tree made it obvious
we need an abstraction around writing netdev->dev_addr. Without
such abstraction updating the main device address is invisible
to the core.

Introduce a number of helpers which for now just wrap memcpy()
but in the future can make necessary changes to the address
tree.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Looking at the code these seem to be the helpers we'll need
to cover most cases. Adding them early so they propagate to
other trees, the patches to use those will start flowing
after the merge window.
---
 include/linux/etherdevice.h | 12 ++++++++++++
 include/linux/netdevice.h   | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 330345b1be54..928c411bd509 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -299,6 +299,18 @@ static inline void ether_addr_copy(u8 *dst, const u8 *src)
 #endif
 }
 
+/**
+ * eth_hw_addr_set - Assign Ethernet address to a net_device
+ * @dev: pointer to net_device structure
+ * @addr: address to assign
+ *
+ * Assign given address to the net_device, addr_assign_type is not changed.
+ */
+static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
+{
+	ether_addr_copy(dev->dev_addr, addr);
+}
+
 /**
  * eth_hw_addr_inherit - Copy dev_addr from another net_device
  * @dst: pointer to net_device to copy dev_addr to
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7c41593c1d6a..d79163208dfd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4641,6 +4641,24 @@ void __hw_addr_unsync_dev(struct netdev_hw_addr_list *list,
 void __hw_addr_init(struct netdev_hw_addr_list *list);
 
 /* Functions used for device addresses handling */
+static inline void
+__dev_addr_set(struct net_device *dev, const u8 *addr, size_t len)
+{
+	memcpy(dev->dev_addr, addr, len);
+}
+
+static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
+{
+	__dev_addr_set(dev, addr, dev->addr_len);
+}
+
+static inline void
+dev_addr_mod(struct net_device *dev, unsigned int offset,
+	     const u8 *addr, size_t len)
+{
+	memcpy(&dev->dev_addr[offset], addr, len);
+}
+
 int dev_addr_add(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
 int dev_addr_del(struct net_device *dev, const unsigned char *addr,
-- 
2.31.1

