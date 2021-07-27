Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726373D771C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhG0NqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236692AbhG0NqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6766661A54;
        Tue, 27 Jul 2021 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393561;
        bh=aRU6vY0xcd5CXDmrbFyOru0wOt0tlVrjv7S5ATljdus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyh7jnQ8z7RY5BUdx4ipwPCvs/8axzPgOSF7agsOXMKC107Su6tmN2UjZaAGN0OO6
         OwMpJ4Rx0X112Qy+rz9zf5vqBV6Bve1m3hrDBus3twm4lqplDGInxAu+FHgstntc34
         SRSg7kZWC7OET7WKfWUXgAa2PQ1/6X3/K+TeKevxzgogmkZZa9w5pp6d8nMaByMNzb
         dMOsja7Q0wENTb1gwVU1cNqoTA3X8Sa/OLfZwt9QhA6O4caXPYqsCF665nlwBMzXG9
         vETiYuvDhYW0ych26NAU/QzxhTAnKms49gerhbaJ22M+mpJOYBKr9CdScBStOhZpVP
         GAl28e0dgnqFA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH net-next v3 01/31] net: split out SIOCDEVPRIVATE handling from dev_ioctl
Date:   Tue, 27 Jul 2021 15:44:47 +0200
Message-Id: <20210727134517.1384504-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Cong Wang <cong.wang@bytedance.com>
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
index c871dc223dfa..670e1a8e5928 100644
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
index 950e2fe5d56a..75e3e340d884 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -259,6 +259,23 @@ static int dev_do_ioctl(struct net_device *dev,
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
@@ -336,9 +353,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
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

