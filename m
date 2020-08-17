Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E537246FBA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgHQRxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:53:02 -0400
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:11902 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731600AbgHQRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 13:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6582; q=dns/txt; s=iport;
  t=1597686752; x=1598896352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JeSwWmzIRAQz6j2ejwjeJoylWXxzdWjzKvU1IpkMkOc=;
  b=F2yCHAjBkONahjLeoZz8iATsQoNd4cUdmo9BMOp+z4iQXgaCf1INA8vi
   vojsEscquicST5bN3duFpGUg66xzpBbID9f7JLtGef5BwukF1NuApXCTo
   GwY9v0siTLk4A4iowILzfU8U4w1Y1Y3tfi6WnNtVZUUvWjS3U9yi1zz+V
   o=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BbBACIwjpf/5tdJa1fHQEBAQEJARI?=
 =?us-ascii?q?BBQUBggqBdTWBRAEyLLFuCwEBAQ4vBAEBhEyCTwIkOBMCAwEBCwEBBQEBAQI?=
 =?us-ascii?q?BBgRthWiGHwsBRoENMhKDJoJ9sA+BdTOJGYFAgTiIIm2EDhuBQT+EX4o0BJJ?=
 =?us-ascii?q?Ch0SBa5o+gmyaEQ8hoCGSOZ9ngWojgVczGggbFTuCaVAZDY4rF45EIQMwNwI?=
 =?us-ascii?q?GCgEBAwmRLQEB?=
X-IronPort-AV: E=Sophos;i="5.76,324,1592870400"; 
   d="scan'208";a="816481828"
Received: from rcdn-core-4.cisco.com ([173.37.93.155])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Aug 2020 17:52:24 +0000
Received: from sjc-ads-9103.cisco.com (sjc-ads-9103.cisco.com [10.30.208.113])
        by rcdn-core-4.cisco.com (8.15.2/8.15.2) with ESMTP id 07HHqOF6012615;
        Mon, 17 Aug 2020 17:52:24 GMT
Received: by sjc-ads-9103.cisco.com (Postfix, from userid 487941)
        id 3A37B9A8; Mon, 17 Aug 2020 10:52:24 -0700 (PDT)
From:   Denys Zagorui <dzagorui@cisco.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     "ikhoronz@cisco.com--cc=xe-linux-external"@cisco.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com,
        richardcochran@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: core: SIOCADDMULTI/SIOCDELMULTI distinguish between uc and mc
Date:   Mon, 17 Aug 2020 10:52:24 -0700
Message-Id: <20200817175224.49608-1-dzagorui@cisco.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.30.208.113, sjc-ads-9103.cisco.com
X-Outbound-Node: rcdn-core-4.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SIOCADDMULTI API allows adding multicast/unicast mac addresses but
doesn't deferentiate them so if someone tries to add secondary
unicast mac addr it will be added to multicast netdev list which is
confusing. There is at least one user that allows adding secondary
unicast through this API.
(2f41f3358672 i40e/i40evf: fix unicast mac address add)

This patch adds check whether passed mac addr is uc or mc and adds
this mac addr to the corresponding list. Add 'global' variant for
adding/removing uc addresses similarly to mc.

Signed-off-by: Denys Zagorui <dzagorui@cisco.com>
---
 include/linux/netdevice.h    |  2 +
 include/uapi/linux/sockios.h |  2 +-
 net/core/dev_addr_lists.c    | 75 +++++++++++++++++++++++++++---------
 net/core/dev_ioctl.c         | 13 ++++++-
 4 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..9394f369be33 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4345,8 +4345,10 @@ int dev_addr_init(struct net_device *dev);
 
 /* Functions used for unicast addresses handling */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr);
+int dev_uc_add_global(struct net_device *dev, const unsigned char *addr);
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr);
 int dev_uc_del(struct net_device *dev, const unsigned char *addr);
+int dev_uc_del_global(struct net_device *dev, const unsigned char *addr);
 int dev_uc_sync(struct net_device *to, struct net_device *from);
 int dev_uc_sync_multiple(struct net_device *to, struct net_device *from);
 void dev_uc_unsync(struct net_device *to, struct net_device *from);
diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
index 7d1bccbbef78..f41b152b0268 100644
--- a/include/uapi/linux/sockios.h
+++ b/include/uapi/linux/sockios.h
@@ -80,7 +80,7 @@
 #define SIOCGIFHWADDR	0x8927		/* Get hardware address		*/
 #define SIOCGIFSLAVE	0x8929		/* Driver slaving support	*/
 #define SIOCSIFSLAVE	0x8930
-#define SIOCADDMULTI	0x8931		/* Multicast address lists	*/
+#define SIOCADDMULTI	0x8931		/* Mac address lists	*/
 #define SIOCDELMULTI	0x8932
 #define SIOCGIFINDEX	0x8933		/* name -> if_index mapping	*/
 #define SIOGIFINDEX	SIOCGIFINDEX	/* misprint compatibility :-)	*/
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 54cd568e7c2f..d150c2d84df4 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -573,6 +573,20 @@ int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 }
 EXPORT_SYMBOL(dev_uc_add_excl);
 
+static int __dev_uc_add(struct net_device *dev, const unsigned char *addr,
+			bool global)
+{
+	int err;
+
+	netif_addr_lock_bh(dev);
+	err = __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,
+			       NETDEV_HW_ADDR_T_UNICAST, global, false, 0);
+	if (!err)
+		__dev_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
+	return err;
+}
+
 /**
  *	dev_uc_add - Add a secondary unicast address
  *	@dev: device
@@ -583,18 +597,37 @@ EXPORT_SYMBOL(dev_uc_add_excl);
  */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_add(&dev->uc, addr, dev->addr_len,
-			    NETDEV_HW_ADDR_T_UNICAST);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_uc_add(dev, addr, false);
 }
 EXPORT_SYMBOL(dev_uc_add);
 
+/**
+ *	dev_uc_add_global - Add a global unicast address
+ *	@dev: device
+ *	@addr: address to add
+ *
+ *	Add a global unicast address to the device.
+ */
+int dev_uc_add_global(struct net_device *dev, const unsigned char *addr)
+{
+	return __dev_uc_add(dev, addr, true);
+}
+EXPORT_SYMBOL(dev_uc_add_global);
+
+static int __dev_uc_del(struct net_device *dev, const unsigned char *addr,
+			bool global)
+{
+	int err;
+
+	netif_addr_lock_bh(dev);
+	err = __hw_addr_del_ex(&dev->uc, addr, dev->addr_len,
+			       NETDEV_HW_ADDR_T_UNICAST, global, false);
+	if (!err)
+		__dev_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
+	return err;
+}
+
 /**
  *	dev_uc_del - Release secondary unicast address.
  *	@dev: device
@@ -605,18 +638,24 @@ EXPORT_SYMBOL(dev_uc_add);
  */
 int dev_uc_del(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_del(&dev->uc, addr, dev->addr_len,
-			    NETDEV_HW_ADDR_T_UNICAST);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_uc_del(dev, addr, false);
 }
 EXPORT_SYMBOL(dev_uc_del);
 
+/**
+ *	dev_uc_del_global - Delete a global unicast address.
+ *	@dev: device
+ *	@addr: address to delete
+ *
+ *	Release reference to a unicast address and remove it
+ *	from the device if the reference count drops to zero.
+ */
+int dev_uc_del_global(struct net_device *dev, const unsigned char *addr)
+{
+	return __dev_uc_del(dev, addr, true);
+}
+EXPORT_SYMBOL(dev_uc_del_global);
+
 /**
  *	dev_uc_sync - Synchronize device's unicast list to another device
  *	@to: destination device
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index b2cf9b7bb7b8..7883bfd920fd 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/wireless.h>
 #include <net/dsa.h>
 #include <net/wext.h>
+#include <linux/if_arp.h>
 
 /*
  *	Map an interface index to its name (SIOCGIFNAME)
@@ -299,7 +300,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 			return -EINVAL;
 		if (!netif_device_present(dev))
 			return -ENODEV;
-		return dev_mc_add_global(dev, ifr->ifr_hwaddr.sa_data);
+		if (dev->type == ARPHRD_ETHER &&
+		    is_unicast_ether_addr(ifr->ifr_hwaddr.sa_data))
+			return dev_uc_add_global(dev, ifr->ifr_hwaddr.sa_data);
+		else
+			return dev_mc_add_global(dev, ifr->ifr_hwaddr.sa_data);
 
 	case SIOCDELMULTI:
 		if (!ops->ndo_set_rx_mode ||
@@ -307,7 +312,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 			return -EINVAL;
 		if (!netif_device_present(dev))
 			return -ENODEV;
-		return dev_mc_del_global(dev, ifr->ifr_hwaddr.sa_data);
+		if (dev->type == ARPHRD_ETHER &&
+		    is_unicast_ether_addr(ifr->ifr_hwaddr.sa_data))
+			return dev_uc_del_global(dev, ifr->ifr_hwaddr.sa_data);
+		else
+			return dev_mc_del_global(dev, ifr->ifr_hwaddr.sa_data);
 
 	case SIOCSIFTXQLEN:
 		if (ifr->ifr_qlen < 0)
-- 
2.19.1

