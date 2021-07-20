Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7E83CFD5E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbhGTOjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239385AbhGTOSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4893E61355;
        Tue, 20 Jul 2021 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792449;
        bh=IwXnLFsU7B7Z5TL/tdtFN8AHHOr8651QpAy/kcrgkDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0+M9uKrU+lMqDqjFTZFlQX5cS8QV5MqhNKjGBBe64rThx4EkoM4mA5vH8gfFrtAD
         43u3TcqMHAcXx+q/nFrhL2XZGsE0aAckKPGP2+NKO3r9vMmxXe7edeH2h6MZbNnXvO
         DipFJGb7yIxLxRqlVUvjc5JWLkegg4+lQyPqx2wudAMBcPpw7lqamK49iJqNeBLl/f
         zBbM3CdLXzAT0nFfT9R3R69kQDF3Ms69LBVKGzMKpZvDjRS9VoCh8b+RUqyBxbHlLK
         xXWmjNtF2VwGP4bbJ7pC3+91V9rbqJAxSbGAZxCNqtkKIl+KoOiyLTqwMO4XQ3TVHd
         uwn6kJgpfEHrA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 31/31] net: bonding: move ioctl handling to private ndo operation
Date:   Tue, 20 Jul 2021 16:46:38 +0200
Message-Id: <20210720144638.2859828-32-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

All other user triggered operations are gone from ndo_ioctl, so move
the SIOCBOND family into a custom operation as well.

The .ndo_ioctl() helper is no longer called by the dev_ioctl.c code now,
but there are still a few definitions in obsolete wireless drivers as well
as the appletalk and ieee802154 layers to call SIOCSIFADDR/SIOCGIFADDR
helpers from inside the kernel.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/netdevices.rst | 11 +++++++++++
 drivers/net/bonding/bond_main.c         |  2 +-
 include/linux/netdevice.h               | 13 ++++++++++---
 net/core/dev_ioctl.c                    |  8 ++++----
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 3c42b0b0be93..9e4cccb90b87 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -222,6 +222,17 @@ ndo_do_ioctl:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
 
+        This is only called by network subsystems internally,
+        not by user space calling ioctl as it was in before
+        linux-5.14.
+
+ndo_siocbond:
+        Synchronization: rtnl_lock() semaphore.
+        Context: process
+
+        Used by the bonding driver for the SIOCBOND family of
+        ioctl commands.
+
 ndo_siocwandev:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0e580f6e4f5b..5ea5e7754dc5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4986,7 +4986,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_select_queue	= bond_select_queue,
 	.ndo_get_stats64	= bond_get_stats,
 	.ndo_eth_ioctl		= bond_eth_ioctl,
-	.ndo_do_ioctl		= bond_do_ioctl,
+	.ndo_siocbond		= bond_do_ioctl,
 	.ndo_siocdevprivate	= bond_siocdevprivate,
 	.ndo_change_rx_flags	= bond_change_rx_flags,
 	.ndo_set_rx_mode	= bond_set_rx_mode,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 719daa254cca..d0e2e2ce2bd0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1086,9 +1086,14 @@ struct netdev_net_notifier {
  *	Test if Media Access Control address is valid for the device.
  *
  * int (*ndo_do_ioctl)(struct net_device *dev, struct ifreq *ifr, int cmd);
- *	Called when a user requests an ioctl which can't be handled by
- *	the generic interface code. If not defined ioctls return
- *	not supported error code.
+ *	Old-style ioctl entry point. This is used internally by the
+ *	appletalk and ieee802154 subsystems but is no longer called by
+ *	the device ioctl handler.
+ *
+ * int (*ndo_siocbond)(struct net_device *dev, struct ifreq *ifr, int cmd);
+ *	Used by the bonding driver for its device specific ioctls:
+ *	SIOCBONDENSLAVE, SIOCBONDRELEASE, SIOCBONDSETHWADDR, SIOCBONDCHANGEACTIVE,
+ *	SIOCBONDSLAVEINFOQUERY, and SIOCBONDINFOQUERY
  *
  * * int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr, int cmd);
  *	Called for ethernet specific ioctls: SIOCGMIIPHY, SIOCGMIIREG,
@@ -1367,6 +1372,8 @@ struct net_device_ops {
 					        struct ifreq *ifr, int cmd);
 	int			(*ndo_eth_ioctl)(struct net_device *dev,
 						 struct ifreq *ifr, int cmd);
+	int			(*ndo_siocbond)(struct net_device *dev,
+						struct ifreq *ifr, int cmd);
 	int			(*ndo_siocwandev)(struct net_device *dev,
 						  struct if_settings *ifs);
 	int			(*ndo_siocdevprivate)(struct net_device *dev,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 73dbb136eb5e..b81bec2a10e9 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -259,14 +259,14 @@ static int dev_eth_ioctl(struct net_device *dev,
 	return err;
 }
 
-static int dev_do_ioctl(struct net_device *dev,
+static int dev_siocbond(struct net_device *dev,
 			struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
-	if (ops->ndo_do_ioctl) {
+	if (ops->ndo_siocbond) {
 		if (netif_device_present(dev))
-			return ops->ndo_do_ioctl(dev, ifr, cmd);
+			return ops->ndo_siocbond(dev, ifr, cmd);
 		else
 			return -ENODEV;
 	}
@@ -406,7 +406,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
 		    cmd == SIOCBONDINFOQUERY ||
 		    cmd == SIOCBONDCHANGEACTIVE) {
-			err = dev_do_ioctl(dev, ifr, cmd);
+			err = dev_siocbond(dev, ifr, cmd);
 		} else
 			err = -EINVAL;
 
-- 
2.29.2

