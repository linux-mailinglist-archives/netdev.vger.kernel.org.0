Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B43D775E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhG0Nrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhG0Nq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C7F61AA5;
        Tue, 27 Jul 2021 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393615;
        bh=F50Mhn/T+bUW+5xbXrNJuotyTutuRwySzq4bKfAHonw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6y835zbgZUnkMEQ+vDaFjTAgosLuMc6w7HkAq0W+GPw+8IyFWfmXLxh+Fcp6eZDN
         S6iOgBzFBitnUEqyN0EpRrcD7CtXB0RtUrOV4eFDEuKrOqtvInpr4QmPk5aGBjXpvv
         y9f+4Hb7EkidReNrc6+Bu0Uh8c5yEalKNEYkDMS4cuupfBUiAKeGSV/sBs3l/x2UPx
         K7jYtuHfZEqY1fGhECx5w1+7Jn7ZysoP6xV2L1y9f96ctN26L7N/hILoLTFn9xGnIw
         GdSG9jhWwb2GQtF834IiU4BFe1CnCemgumJvFGnzQxFrOOaQO9Vt2zBJ59CXDDdg8r
         Nv7/qz2gkF8nQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net-next v3 31/31] net: bonding: move ioctl handling to private ndo operation
Date:   Tue, 27 Jul 2021 15:45:17 +0200
Message-Id: <20210727134517.1384504-32-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
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
index 23769e937c28..bec8ceaff98f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4988,7 +4988,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_select_queue	= bond_select_queue,
 	.ndo_get_stats64	= bond_get_stats,
 	.ndo_eth_ioctl		= bond_eth_ioctl,
-	.ndo_do_ioctl		= bond_do_ioctl,
+	.ndo_siocbond		= bond_do_ioctl,
 	.ndo_siocdevprivate	= bond_siocdevprivate,
 	.ndo_change_rx_flags	= bond_change_rx_flags,
 	.ndo_set_rx_mode	= bond_set_rx_mode,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cc11382f76a3..226bbee06730 100644
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
index 3166f196b296..4035bce06bf8 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -260,14 +260,14 @@ static int dev_eth_ioctl(struct net_device *dev,
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
@@ -407,7 +407,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
 		    cmd == SIOCBONDINFOQUERY ||
 		    cmd == SIOCBONDCHANGEACTIVE) {
-			err = dev_do_ioctl(dev, ifr, cmd);
+			err = dev_siocbond(dev, ifr, cmd);
 		} else
 			err = -EINVAL;
 
-- 
2.29.2

