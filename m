Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F63CFDA7
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhGTOxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239778AbhGTO2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06686611CE;
        Tue, 20 Jul 2021 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792413;
        bh=0xGD3/0Zic0jjPeC/gHVRi/xMKxPymQtNrC/i4voqrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra1sWxY+emH66IQfPc3sO8x0BftpDs/L+BEzlotpsa5tWd5Q+gafMr9Y24FEBLiX3
         u+MNKMVJ/TH+v9jY0JAnzaqfdDfKUNX8VQi9J0BONc76TQHs3K9dMq9NpRM/kFgQ3i
         eoQBik/kfORyZUj2cn7FfVtd6/z9tgfuLVULCW0I288x1J/ofZHJCPPDvkOVj44ZaQ
         3mbip7basT+jgifH7GZRBuV5cUJRoBHdCBWSHgqGjJszTkLZonbNj15sLNr1R7I0pb
         Ry1I3fTstaGnSg+HcEHkjpbQkDePaRRZor1jvdSrPA2QlOeBDGoV2f57UFHeSmN2Kj
         WC+He1IKHj2DQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 01/31] net: split out SIOCDEVPRIVATE handling from dev_ioctl
Date:   Tue, 20 Jul 2021 16:46:08 +0200
Message-Id: <20210720144638.2859828-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SIOCDEVPRIVATE ioctl commands are mainly used in really old
drivers, and they have a number of problems:

- They hide behind the normal .ndo_do_ioctl function that
  is also used for other things in modern drivers, so it's
  hard to spot a driver that actually uses one of these

- Since drivers use a number different calling conventions,
  it is impossible to support compat mode for them in
  a generic way.

- With all drivers using the same 16 commands codes, there
  is no way to introspect the data being passed through
  things like strace.

Add a new net_device_ops callback pointer, to address the
first two of these. Separating them from .ndo_do_ioctl
makes it easy to grep for drivers with a .ndo_siocdevprivate
callback, and the unwieldy name hopefully makes it easier
to spot in code review.

By passing the ifreq structure and the ifr_data pointer
separately, it is no longer necessary to overload these,
and the driver can use either one for a given command.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/netdevices.rst |  7 +++++++
 include/linux/netdevice.h               |  3 +++
 net/core/dev_ioctl.c                    | 25 ++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 17bdcb746dcf..02f1faac839a 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -222,6 +222,13 @@ ndo_do_ioctl:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
 
+ndo_siocdevprivate:
+	Synchronization: rtnl_lock() semaphore.
+	Context: process
+
+	This is used to implement SIOCDEVPRIVATE ioctl helpers.
+	These should not be added to new drivers, so don't use.
+
 ndo_get_stats:
 	Synchronization: rtnl_lock() semaphore, dev_base_lock rwlock, or RCU.
 	Context: atomic (can't sleep under rwlock or RCU)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5c39129101c0..05d70143715b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1361,6 +1361,9 @@ struct net_device_ops {
 	int			(*ndo_validate_addr)(struct net_device *dev);
 	int			(*ndo_do_ioctl)(struct net_device *dev,
 					        struct ifreq *ifr, int cmd);
+	int			(*ndo_siocdevprivate)(struct net_device *dev,
+						      struct ifreq *ifr,
+						      void __user *data, int cmd);
 	int			(*ndo_set_config)(struct net_device *dev,
 					          struct ifmap *map);
 	int			(*ndo_change_mtu)(struct net_device *dev,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 0af7b9f09970..a54414590c81 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -258,6 +258,23 @@ static int dev_do_ioctl(struct net_device *dev,
 	return err;
 }
 
+static int dev_siocdevprivate(struct net_device *dev,
+			      struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	void __user *data = ifr->ifr_data;
+
+	if (ops->ndo_siocdevprivate) {
+		if (netif_device_present(dev))
+			return ops->ndo_siocdevprivate(dev, ifr, data, cmd);
+		else
+			return -ENODEV;
+	}
+
+	/* fall back to do_ioctl for drivers not yet converted */
+	return dev_do_ioctl(dev, ifr, cmd);
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
  */
@@ -335,9 +352,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	 *	Unknown or private ioctl
 	 */
 	default:
-		if ((cmd >= SIOCDEVPRIVATE &&
-		    cmd <= SIOCDEVPRIVATE + 15) ||
-		    cmd == SIOCBONDENSLAVE ||
+		if (cmd >= SIOCDEVPRIVATE &&
+		    cmd <= SIOCDEVPRIVATE + 15)
+			return dev_siocdevprivate(dev, ifr, cmd);
+
+		if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
 		    cmd == SIOCBONDSETHWADDR ||
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
-- 
2.29.2

