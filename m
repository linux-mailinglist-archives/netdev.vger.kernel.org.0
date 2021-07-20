Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967F93CFD65
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbhGTOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239404AbhGTOSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B9961351;
        Tue, 20 Jul 2021 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792447;
        bh=pHyLO7XdBqB9b11XMcjL6pyqAxv3jNUilA+S4CfR2Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDYc8hlb/dITtpCC+/wurO7gYhyj/UmKjfmQ6v/7umY5gv8+aQVN/vDmojJOC5W+N
         dRmQJ/Z2eBkz2ZPVCa9iCpV6BRNeqhpa9wc1BRACRfa782y8TQ6yoJmCoXzTuGiwDZ
         2Qo7bf8Qq+9IkEn1VTu9ap3BaukJtv7Sn/XIeB6p7tbzcF/XROSyvHG9TK6Kbf63ed
         7iCvCB0hjPixp25CXDXpMS3flQu4oqNxCGWmP7wjVMXlV+fWtI7e7aIfJcKCYLYQpL
         TsN3rZeLlhtT1LfYGkTZUtrJLlxLUoWOFdviAilRUeIh90pCUlh7j4W7WepWPIScyz
         b7zBwEDBaPbHw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 30/31] net: bridge: move bridge ioctls out of .ndo_do_ioctl
Date:   Tue, 20 Jul 2021 16:46:37 +0200
Message-Id: <20210720144638.2859828-31-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Working towards obsoleting the .ndo_do_ioctl operation entirely,
stop passing the SIOCBRADDIF/SIOCBRDELIF device ioctl commands
into this callback.

My first attempt was to add another ndo_siocbr() callback, but
as there is only a single driver that takes these commands and
there is already a hook mechanism to call directly into this
driver, extend this hook instead, and use it for both the
deviceless and the device specific ioctl commands.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/if_bridge.h |  7 ++++++-
 net/bridge/br.c           |  2 +-
 net/bridge/br_device.c    |  1 -
 net/bridge/br_ioctl.c     | 15 +++------------
 net/bridge/br_private.h   |  5 ++---
 net/core/dev_ioctl.c      | 11 ++++++++---
 net/socket.c              | 33 +++++++++++++++++++++++----------
 7 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b651c5e32a28..cdaa40fccc0f 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -60,7 +60,12 @@ struct br_ip_list {
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
-extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
+struct net_bridge;
+void brioctl_set(int (*hook)(struct net *net, struct net_bridge *br,
+			     unsigned int cmd, struct ifreq *ifr,
+			     void __user *uarg));
+int br_ioctl_call(struct net *net, struct net_bridge *br, unsigned int cmd,
+		  struct ifreq *ifr, void __user *uarg);
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
 int br_multicast_list_adjacent(struct net_device *dev,
diff --git a/net/bridge/br.c b/net/bridge/br.c
index ef743f94254d..cf9d4b46a775 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -352,7 +352,7 @@ static int __init br_init(void)
 	if (err)
 		goto err_out5;
 
-	brioctl_set(br_ioctl_deviceless_stub);
+	brioctl_set(br_ioctl_stub);
 
 #if IS_ENABLED(CONFIG_ATM_LANE)
 	br_fdb_test_addr_hook = br_fdb_test_addr;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b57ff551caba..bed28a59f7f5 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -450,7 +450,6 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_set_rx_mode	 = br_dev_set_multicast_list,
 	.ndo_change_rx_flags	 = br_dev_change_rx_flags,
 	.ndo_change_mtu		 = br_change_mtu,
-	.ndo_do_ioctl		 = br_dev_ioctl,
 	.ndo_siocdevprivate	 = br_dev_siocdevprivate,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	 = br_netpoll_setup,
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 9f924fe43641..46a24c20e405 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -366,7 +366,8 @@ static int old_deviceless(struct net *net, void __user *uarg)
 	return -EOPNOTSUPP;
 }
 
-int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd, void __user *uarg)
+int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
+		  struct ifreq *ifr, void __user *uarg)
 {
 	switch (cmd) {
 	case SIOCGIFBR:
@@ -390,21 +391,11 @@ int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd, void __user *uar
 
 		return br_del_bridge(net, buf);
 	}
-	}
-	return -EOPNOTSUPP;
-}
-
-int br_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct net_bridge *br = netdev_priv(dev);
 
-	switch (cmd) {
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
-		return add_del_if(br, rq->ifr_ifindex, cmd == SIOCBRADDIF);
+		return add_del_if(br, ifr->ifr_ifindex, cmd == SIOCBRADDIF);
 
 	}
-
-	br_debug(br, "Bridge does not support ioctl 0x%x\n", cmd);
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3f90be8c9ce0..736965df9f04 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -790,11 +790,10 @@ br_port_get_check_rtnl(const struct net_device *dev)
 }
 
 /* br_ioctl.c */
-int br_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 			  void __user *data, int cmd);
-int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd,
-			     void __user *arg);
+int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
+		  struct ifreq *ifr, void __user *uarg);
 
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 2f58afbaf87a..73dbb136eb5e 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -6,6 +6,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/wireless.h>
+#include <linux/if_bridge.h>
 #include <net/dsa.h>
 #include <net/wext.h>
 
@@ -373,6 +374,12 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	case SIOCWANDEV:
 		return dev_siocwandev(dev, &ifr->ifr_settings);
 
+	case SIOCBRADDIF:
+	case SIOCBRDELIF:
+		if (!netif_device_present(dev))
+			return -ENODEV;
+		return br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
+
 	case SIOCSHWTSTAMP:
 		err = net_hwtstamp_validate(ifr);
 		if (err)
@@ -398,9 +405,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCBONDSETHWADDR ||
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
 		    cmd == SIOCBONDINFOQUERY ||
-		    cmd == SIOCBONDCHANGEACTIVE ||
-		    cmd == SIOCBRADDIF ||
-		    cmd == SIOCBRDELIF) {
+		    cmd == SIOCBONDCHANGEACTIVE) {
 			err = dev_do_ioctl(dev, ifr, cmd);
 		} else
 			err = -EINVAL;
diff --git a/net/socket.c b/net/socket.c
index 48471a219c1d..42665bd99ea4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1064,9 +1064,13 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
  */
 
 static DEFINE_MUTEX(br_ioctl_mutex);
-static int (*br_ioctl_hook) (struct net *, unsigned int cmd, void __user *arg);
+static int (*br_ioctl_hook)(struct net *net, struct net_bridge *br,
+			    unsigned int cmd, struct ifreq *ifr,
+			    void __user *uarg);
 
-void brioctl_set(int (*hook) (struct net *, unsigned int, void __user *))
+void brioctl_set(int (*hook)(struct net *net, struct net_bridge *br,
+			     unsigned int cmd, struct ifreq *ifr,
+			     void __user *uarg))
 {
 	mutex_lock(&br_ioctl_mutex);
 	br_ioctl_hook = hook;
@@ -1074,6 +1078,22 @@ void brioctl_set(int (*hook) (struct net *, unsigned int, void __user *))
 }
 EXPORT_SYMBOL(brioctl_set);
 
+int br_ioctl_call(struct net *net, struct net_bridge *br, unsigned int cmd,
+		  struct ifreq *ifr, void __user *uarg)
+{
+	int err = -ENOPKG;
+
+	if (!br_ioctl_hook)
+		request_module("bridge");
+
+	mutex_lock(&br_ioctl_mutex);
+	if (br_ioctl_hook)
+		err = br_ioctl_hook(net, br, cmd, ifr, uarg);
+	mutex_unlock(&br_ioctl_mutex);
+
+	return err;
+}
+
 static DEFINE_MUTEX(vlan_ioctl_mutex);
 static int (*vlan_ioctl_hook) (struct net *, void __user *arg);
 
@@ -1162,14 +1182,7 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		case SIOCSIFBR:
 		case SIOCBRADDBR:
 		case SIOCBRDELBR:
-			err = -ENOPKG;
-			if (!br_ioctl_hook)
-				request_module("bridge");
-
-			mutex_lock(&br_ioctl_mutex);
-			if (br_ioctl_hook)
-				err = br_ioctl_hook(net, cmd, argp);
-			mutex_unlock(&br_ioctl_mutex);
+			err = br_ioctl_call(net, NULL, cmd, NULL, argp);
 			break;
 		case SIOCGIFVLAN:
 		case SIOCSIFVLAN:
-- 
2.29.2

