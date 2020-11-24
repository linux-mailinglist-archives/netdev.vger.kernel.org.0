Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E862C2B12
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389414AbgKXPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387697AbgKXPSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:18:45 -0500
Received: from threadripper.lan (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB1D206D8;
        Tue, 24 Nov 2020 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606231124;
        bh=jJQ0X8vmSY8/4iYrv6r4aPgAmmluD0gJ4P5wes1+3e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNVzaEVEWIq6zu98XyNLUmbZzYEXLh0pybzS9E89an7NmPaNSCIhxinQBwJHmpcys
         RFaDAJ9kx4qZvZkpyCvmrB2CANsUd4GhW3d0xGYYblG7lC/xKTIWERayMQ1b2ufV9t
         o5bw0eNiS3B64E+1SF+tgH29uBIDk64BcOvF8xM8=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
Date:   Tue, 24 Nov 2020 16:18:26 +0100
Message-Id: <20201124151828.169152-3-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201124151828.169152-1-arnd@kernel.org>
References: <20201124151828.169152-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SIOCGIFMAP and SIOCSIFMAP currently require compat_alloc_user_space()
and copy_in_user() for compat mode.

Move the compat handling into the location where the structures are
actually used, to avoid using those interfaces and get a clearer
implementation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changes in v3:
 - complete rewrite

changes in v2:
 - fix building with CONFIG_COMPAT disabled (0day bot)
 - split up dev_ifmap() into more readable helpers (hch)
 - move rcu_read_unlock() for readability (hch)
---
 include/linux/compat.h | 18 ++++++------
 net/core/dev_ioctl.c   | 64 +++++++++++++++++++++++++++++++++---------
 net/socket.c           | 39 ++-----------------------
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 08dbd34bb7a5..47496c5eb5eb 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -96,6 +96,15 @@ struct compat_iovec {
 	compat_size_t	iov_len;
 };
 
+struct compat_ifmap {
+	compat_ulong_t mem_start;
+	compat_ulong_t mem_end;
+	unsigned short base_addr;
+	unsigned char irq;
+	unsigned char dma;
+	unsigned char port;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -314,15 +323,6 @@ typedef struct compat_sigevent {
 	} _sigev_un;
 } compat_sigevent_t;
 
-struct compat_ifmap {
-	compat_ulong_t mem_start;
-	compat_ulong_t mem_end;
-	unsigned short base_addr;
-	unsigned char irq;
-	unsigned char dma;
-	unsigned char port;
-};
-
 struct compat_if_settings {
 	unsigned int type;	/* Type of physical device or protocol */
 	unsigned int size;	/* Size of the data allocated by the caller */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index db8a0ff86f36..de3df6fe65fe 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -98,6 +98,55 @@ int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
 	return 0;
 }
 
+static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ifmap *ifmap = &ifr->ifr_map;
+	struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
+
+	if (in_compat_syscall()) {
+		cifmap->mem_start = dev->mem_start;
+		cifmap->mem_end   = dev->mem_end;
+		cifmap->base_addr = dev->base_addr;
+		cifmap->irq       = dev->irq;
+		cifmap->dma       = dev->dma;
+		cifmap->port      = dev->if_port;
+
+		return 0;
+	}
+
+	ifmap->mem_start  = dev->mem_start;
+	ifmap->mem_end    = dev->mem_end;
+	ifmap->base_addr  = dev->base_addr;
+	ifmap->irq        = dev->irq;
+	ifmap->dma        = dev->dma;
+	ifmap->port       = dev->if_port;
+
+	return 0;
+}
+
+static int dev_setifmap(struct net_device *dev, struct ifreq *ifr)
+{
+	struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
+
+	if (!dev->netdev_ops->ndo_set_config)
+		return -EOPNOTSUPP;
+
+	if (in_compat_syscall()) {
+		struct ifmap ifmap = {
+			.mem_start  = cifmap->mem_start,
+			.mem_end    = cifmap->mem_end,
+			.base_addr  = cifmap->base_addr,
+			.irq        = cifmap->irq,
+			.dma        = cifmap->dma,
+			.port       = cifmap->port,
+		};
+
+		return dev->netdev_ops->ndo_set_config(dev, &ifmap);
+	}
+
+	return dev->netdev_ops->ndo_set_config(dev, &ifr->ifr_map);
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rcu_read_lock()
  */
@@ -139,13 +188,7 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 		break;
 
 	case SIOCGIFMAP:
-		ifr->ifr_map.mem_start = dev->mem_start;
-		ifr->ifr_map.mem_end   = dev->mem_end;
-		ifr->ifr_map.base_addr = dev->base_addr;
-		ifr->ifr_map.irq       = dev->irq;
-		ifr->ifr_map.dma       = dev->dma;
-		ifr->ifr_map.port      = dev->if_port;
-		return 0;
+		return dev_getifmap(dev, ifr);
 
 	case SIOCGIFINDEX:
 		ifr->ifr_ifindex = dev->ifindex;
@@ -286,12 +329,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 		return 0;
 
 	case SIOCSIFMAP:
-		if (ops->ndo_set_config) {
-			if (!netif_device_present(dev))
-				return -ENODEV;
-			return ops->ndo_set_config(dev, &ifr->ifr_map);
-		}
-		return -EOPNOTSUPP;
+		return dev_setifmap(dev, ifr);
 
 	case SIOCADDMULTI:
 		if (!ops->ndo_set_rx_mode ||
diff --git a/net/socket.c b/net/socket.c
index 60df84a91051..2d32c8576e95 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3198,40 +3198,6 @@ static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
 	return err;
 }
 
-static int compat_sioc_ifmap(struct net *net, unsigned int cmd,
-			struct compat_ifreq __user *uifr32)
-{
-	struct ifreq ifr;
-	struct compat_ifmap __user *uifmap32;
-	int err;
-
-	uifmap32 = &uifr32->ifr_ifru.ifru_map;
-	err = copy_from_user(&ifr, uifr32, sizeof(ifr.ifr_name));
-	err |= get_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-	err |= get_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-	err |= get_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-	err |= get_user(ifr.ifr_map.irq, &uifmap32->irq);
-	err |= get_user(ifr.ifr_map.dma, &uifmap32->dma);
-	err |= get_user(ifr.ifr_map.port, &uifmap32->port);
-	if (err)
-		return -EFAULT;
-
-	err = dev_ioctl(net, cmd, &ifr, NULL);
-
-	if (cmd == SIOCGIFMAP && !err) {
-		err = copy_to_user(uifr32, &ifr, sizeof(ifr.ifr_name));
-		err |= put_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-		err |= put_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-		err |= put_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-		err |= put_user(ifr.ifr_map.irq, &uifmap32->irq);
-		err |= put_user(ifr.ifr_map.dma, &uifmap32->dma);
-		err |= put_user(ifr.ifr_map.port, &uifmap32->port);
-		if (err)
-			err = -EFAULT;
-	}
-	return err;
-}
-
 /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE
  * for some operations; this forces use of the newer bridge-utils that
  * use compatible ioctls
@@ -3265,9 +3231,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
-	case SIOCGIFMAP:
-	case SIOCSIFMAP:
-		return compat_sioc_ifmap(net, cmd, argp);
 	case SIOCGSTAMP_OLD:
 	case SIOCGSTAMPNS_OLD:
 		if (!sock->ops->gettstamp)
@@ -3297,6 +3260,8 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 
 	case SIOCGIFFLAGS:
 	case SIOCSIFFLAGS:
+	case SIOCGIFMAP:
+	case SIOCSIFMAP:
 	case SIOCGIFMETRIC:
 	case SIOCSIFMETRIC:
 	case SIOCGIFMTU:
-- 
2.27.0

