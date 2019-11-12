Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00382F9035
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfKLNHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:07:55 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:34568 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbfKLNHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:07:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ThuRDNx_1573564059;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThuRDNx_1573564059)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Nov 2019 21:07:40 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     xiyou.wangcong@gmail.com, eric.dumazet@gmail.com,
        shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: remove static inline from dev_put()/dev_hold()
Date:   Tue, 12 Nov 2019 21:05:11 +0800
Message-Id: <20191112130510.91570-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes static inline from dev_put()/dev_hold() in order to help
trace the pcpu_refcnt leak of net_device.

We have sufferred this kind of issue for several times during
manipulating NIC between different net namespaces. It prints this
log in dmesg:

  unregister_netdevice: waiting for eth0 to become free. Usage count = 1

However, it is hard to find out who called and leaked refcnt in time. It
only left the crime scene but few evidence. Once leaked, it is not
safe to fix it up on the running host. We can't trace dev_put/dev_hold
directly, for the functions are inlined and used wildly amoung modules.
And this issue is common, there are tens of patches fixes net_device
refcnt leak for various causes.

To trace the refcnt manipulating, this patch removes static inline from
dev_put()/dev_hold(). We can use tools, such as eBPF with kprobe, to
find out who holds but forgets to put refcnt. This will not be called
frequently, so the overhead is limited.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
v1->v2:
- provides two trace events and tracepoitns together in patch #2
- fix some typos in commit message
---
 include/linux/netdevice.h | 24 ++++--------------------
 net/core/dev.c            | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c20f190b4c18..872d266c6da5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3720,27 +3720,11 @@ extern unsigned int	netdev_budget_usecs;
 /* Called by rtnetlink.c:rtnl_unlock() */
 void netdev_run_todo(void);
 
-/**
- *	dev_put - release reference to device
- *	@dev: network device
- *
- * Release reference to device to allow it to be freed.
- */
-static inline void dev_put(struct net_device *dev)
-{
-	this_cpu_dec(*dev->pcpu_refcnt);
-}
+/* Release reference to device to allow it to be freed. */
+void dev_put(struct net_device *dev);
 
-/**
- *	dev_hold - get reference to device
- *	@dev: network device
- *
- * Hold reference to device to keep it from being freed.
- */
-static inline void dev_hold(struct net_device *dev)
-{
-	this_cpu_inc(*dev->pcpu_refcnt);
-}
+/* Hold reference to device to keep it from being freed. */
+void dev_hold(struct net_device *dev);
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
diff --git a/net/core/dev.c b/net/core/dev.c
index 99ac84ff398f..620fb3d6718a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1294,6 +1294,30 @@ void netdev_notify_peers(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_notify_peers);
 
+/**
+ *	dev_put - release reference to device
+ *	@dev: network device
+ *
+ * Release reference to device to allow it to be freed.
+ */
+void dev_put(struct net_device *dev)
+{
+	this_cpu_dec(*dev->pcpu_refcnt);
+}
+EXPORT_SYMBOL(dev_put);
+
+/**
+ *	dev_hold - get reference to device
+ *	@dev: network device
+ *
+ * Hold reference to device to keep it from being freed.
+ */
+void dev_hold(struct net_device *dev)
+{
+	this_cpu_inc(*dev->pcpu_refcnt);
+}
+EXPORT_SYMBOL(dev_hold);
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-- 
2.24.0

