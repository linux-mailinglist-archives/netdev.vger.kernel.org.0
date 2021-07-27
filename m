Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584F63D775F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhG0Nrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237203AbhG0Nqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A3261A8B;
        Tue, 27 Jul 2021 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393614;
        bh=8ReC+FGP4lYZz9uV6y5T2LUadmvwaKCFRSNklcMmMsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOB/Pd9LrBD82LjMCLP4aeHXMJLnVDZeTQ9+6h7YYoDPrCeyrQIA0jObaxmjIVJCf
         7/3SYletDhE9tk18Oyl9h9DGKVneKrCw1adBnt0ty+J+xszklfvKszDTOaJxtIklml
         Gc4OvZDI95raRq+xyBGqS4e5/3l/x/1aBEbH6kmQ9lV5t1w011c/JdLaFXKMqzTfgY
         3IsjCbPXr3UD0vs49f3fljZDfS+YTdeUVwYSRZG8fDCN6OXSy63ihoVhwh7O+3zKzI
         97HHN6rdW3mCvaMPnlOKAmzSw9Krwul6e5czhTFbOoelkbbhtnNS4CP/DEZABrj8tl
         8YOLHfJ1vPgjw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: [PATCH net-next v3 30/31] net: bridge: move bridge ioctls out of .ndo_do_ioctl
Date:   Tue, 27 Jul 2021 15:45:16 +0200
Message-Id: <20210727134517.1384504-31-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: bridge@lists.linux-foundation.org
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
index b73b4ff749e1..21daed10322e 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -61,7 +61,12 @@ struct br_ip_list {
 
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
index 51f2e25c4cd6..8fb5dca5f8e0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -359,7 +359,7 @@ static int __init br_init(void)
 	if (err)
 		goto err_out5;
 
-	brioctl_set(br_ioctl_deviceless_stub);
+	brioctl_set(br_ioctl_stub);
 
 #if IS_ENABLED(CONFIG_ATM_LANE)
 	br_fdb_test_addr_hook = br_fdb_test_addr;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 1952bb433ca7..8d6bab244c4a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -454,7 +454,6 @@ static const struct net_device_ops br_netdev_ops = {
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
index 572c28ae41b8..f2d34ea1ea37 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -851,11 +851,10 @@ br_port_get_check_rtnl(const struct net_device *dev)
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
index 70a379cee5fd..3166f196b296 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -6,6 +6,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/wireless.h>
+#include <linux/if_bridge.h>
 #include <net/dsa.h>
 #include <net/wext.h>
 
@@ -374,6 +375,12 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
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
@@ -399,9 +406,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
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

