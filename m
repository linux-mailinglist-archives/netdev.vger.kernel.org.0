Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0A3D25C2
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhGVNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhGVNsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C9D61278;
        Thu, 22 Jul 2021 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626964166;
        bh=au6vao3VHfIPdPAVPU8U92s0dP9EsEQ5hVMVd/IrSwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7NQ01a+lU5DAh8cRA1qNTRwVTX4+vPfpTIgzOUFwnyievMyIhSI37TmuXyDX1Ice
         hqF+kCd2XOMFZByp3Lc2UQybnkVqiHpuPaYnET45aO6hwPiYSVU/2CsdC5Ov4i5aSO
         fMQpouuRXsDGN/rrV6NkDiDdFxgEbklp/1XLKLOoig0FAaCKjr3CfUJt0+2ypYWHDK
         UzmIscp2WLxQ9SnpXT0wGx4KTiyuR61Pnd5ekZxPC7dwM62yIEecRqiqr0Uf7U8HtT
         a2JAJUIcVDyDLQEBzjXUQ9LvQXXesqmEW34hZ1SsFl0668hJcTShu83kv0vPQMuxC8
         Ih+Yu6cs+0XeQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH net-next v6 3/6] net: socket: rework SIOC?IFMAP ioctls
Date:   Thu, 22 Jul 2021 16:29:00 +0200
Message-Id: <20210722142903.213084-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210722142903.213084-1-arnd@kernel.org>
References: <20210722142903.213084-1-arnd@kernel.org>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changes in v3:
 - complete rewrite

changes in v2:
 - fix building with CONFIG_COMPAT disabled (0day bot)
 - split up dev_ifmap() into more readable helpers (hch)
 - move rcu_read_unlock() for readability (hch)
---
 net/core/dev_ioctl.c | 65 +++++++++++++++++++++++++++++++++++---------
 net/socket.c         | 39 ++------------------------
 2 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 478d032f34ac..62f45da7ecfe 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -98,6 +98,56 @@ int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
 	return 0;
 }
 
+static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ifmap *ifmap = &ifr->ifr_map;
+
+	if (in_compat_syscall()) {
+		struct compat_ifmap *cifmap = (struct compat_ifmap *)ifmap;
+
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
@@ -128,13 +178,7 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
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
@@ -275,12 +319,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
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
index ec63cf6de33e..62005a12ec70 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3241,40 +3241,6 @@ static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
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
@@ -3308,9 +3274,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
-	case SIOCGIFMAP:
-	case SIOCSIFMAP:
-		return compat_sioc_ifmap(net, cmd, argp);
 	case SIOCGSTAMP_OLD:
 	case SIOCGSTAMPNS_OLD:
 		if (!sock->ops->gettstamp)
@@ -3340,6 +3303,8 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 
 	case SIOCGIFFLAGS:
 	case SIOCSIFFLAGS:
+	case SIOCGIFMAP:
+	case SIOCSIFMAP:
 	case SIOCGIFMETRIC:
 	case SIOCSIFMETRIC:
 	case SIOCGIFMTU:
-- 
2.29.2

