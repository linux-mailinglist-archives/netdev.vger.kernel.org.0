Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E084D42A916
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhJLQIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhJLQIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F5B461139;
        Tue, 12 Oct 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054799;
        bh=Uo3FESTATYhaUpvaGlmppUF90Umj4rkfkdmZkrG43ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKCBTZ1xPBlWNDYokdkBNxVVQLXoE//sVUY/U4DaboMEknjWOcWz1XwRvfYGRsWBm
         S7elbfD4bltWie4TMtN7TrNTSJoCMEcGiTJcFMJXHmPUYpYQEQ5rJmpai+8R0l0X7L
         3IUeT+VgRZVmoUd1odBMfnzA5pH7mSkwmJYTlz9wZ8VAmuL20XNPBepUV0H9tW/EGc
         m0RSZU/q6sbwH/V4U1Kf8maISBC2W7KSMQ3pCFTV6ytwAOuLZwPWo/7YPTg9FGoYCw
         ZrG1nG7Y4dpxyy04U1gSlu1X2ORBoqLLLWsn0/QIDA/bDg1picUgqFsjVV8lr4l/7n
         MwtMC68K4n7AA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ajk@comnets.uni-bremen.de, t.sailer@alumni.ethz.ch,
        jreuter@yaina.de, jpr@f6fbb.org
Subject: [PATCH net-next 2/3] hamradio: use dev_addr_set() for setting device address
Date:   Tue, 12 Oct 2021 09:06:33 -0700
Message-Id: <20211012160634.4152690-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012160634.4152690-1-kuba@kernel.org>
References: <20211012160634.4152690-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_addr_set() instead of writing to netdev->dev_addr
directly in hamradio drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ajk@comnets.uni-bremen.de
CC: t.sailer@alumni.ethz.ch
CC: jreuter@yaina.de
CC: jpr@f6fbb.org
---
 drivers/net/hamradio/6pack.c      | 6 +++---
 drivers/net/hamradio/baycom_epp.c | 2 +-
 drivers/net/hamradio/bpqether.c   | 5 ++---
 drivers/net/hamradio/dmascc.c     | 2 +-
 drivers/net/hamradio/hdlcdrv.c    | 2 +-
 drivers/net/hamradio/mkiss.c      | 6 +++---
 drivers/net/hamradio/scc.c        | 5 ++---
 drivers/net/hamradio/yam.c        | 2 +-
 8 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 6192244b304a..f4e8793e995d 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -288,7 +288,7 @@ static int sp_set_mac_address(struct net_device *dev, void *addr)
 
 	netif_tx_lock_bh(dev);
 	netif_addr_lock(dev);
-	memcpy(dev->dev_addr, &sa->sax25_call, AX25_ADDR_LEN);
+	__dev_addr_set(dev, &sa->sax25_call, AX25_ADDR_LEN);
 	netif_addr_unlock(dev);
 	netif_tx_unlock_bh(dev);
 
@@ -317,7 +317,7 @@ static void sp_setup(struct net_device *dev)
 
 	/* Only activated in AX.25 mode */
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &ax25_defaddr, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 
 	dev->flags		= 0;
 }
@@ -726,7 +726,7 @@ static int sixpack_ioctl(struct tty_struct *tty, struct file *file,
 			}
 
 			netif_tx_lock_bh(dev);
-			memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
+			__dev_addr_set(dev, &addr, AX25_ADDR_LEN);
 			netif_tx_unlock_bh(dev);
 			err = 0;
 			break;
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index f6428ff780ab..62da837cc707 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -1159,7 +1159,7 @@ static void baycom_probe(struct net_device *dev)
 	dev->mtu = AX25_DEF_PACLEN;        /* eth_mtu is the default */
 	dev->addr_len = AX25_ADDR_LEN;     /* sizeof an ax.25 address */
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &null_ax25_address, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&null_ax25_address);
 	dev->tx_queue_len = 16;
 
 	/* New style flags */
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 1ac816164a9b..30af0081e2be 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -457,9 +457,6 @@ static void bpq_setup(struct net_device *dev)
 	dev->netdev_ops	     = &bpq_netdev_ops;
 	dev->needs_free_netdev = true;
 
-	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr,  &ax25_defaddr, AX25_ADDR_LEN);
-
 	dev->flags      = 0;
 	dev->features	= NETIF_F_LLTX;	/* Allow recursion */
 
@@ -472,6 +469,8 @@ static void bpq_setup(struct net_device *dev)
 	dev->mtu             = AX25_DEF_PACLEN;
 	dev->addr_len        = AX25_ADDR_LEN;
 
+	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 }
 
 /*
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index a4ba1b79d2d0..7e527499d3ad 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -426,7 +426,7 @@ static void __init dev_setup(struct net_device *dev)
 	dev->addr_len = AX25_ADDR_LEN;
 	dev->tx_queue_len = 64;
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &ax25_defaddr, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 }
 
 static const struct net_device_ops scc_netdev_ops = {
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index ab5327acec22..b0edb91bb10a 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -675,7 +675,7 @@ static void hdlcdrv_setup(struct net_device *dev)
 	dev->mtu = AX25_DEF_PACLEN;        /* eth_mtu is the default */
 	dev->addr_len = AX25_ADDR_LEN;     /* sizeof an ax.25 address */
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &ax25_defaddr, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 	dev->tx_queue_len = 16;
 }
 
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 8666110bec55..867252a0247b 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -344,7 +344,7 @@ static int ax_set_mac_address(struct net_device *dev, void *addr)
 
 	netif_tx_lock_bh(dev);
 	netif_addr_lock(dev);
-	memcpy(dev->dev_addr, &sa->sax25_call, AX25_ADDR_LEN);
+	__dev_addr_set(dev, &sa->sax25_call, AX25_ADDR_LEN);
 	netif_addr_unlock(dev);
 	netif_tx_unlock_bh(dev);
 
@@ -647,7 +647,7 @@ static void ax_setup(struct net_device *dev)
 
 
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr,  &ax25_defaddr,  AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 
 	dev->flags      = IFF_BROADCAST | IFF_MULTICAST;
 }
@@ -850,7 +850,7 @@ static int mkiss_ioctl(struct tty_struct *tty, struct file *file,
 		}
 
 		netif_tx_lock_bh(dev);
-		memcpy(dev->dev_addr, addr, AX25_ADDR_LEN);
+		__dev_addr_set(dev, addr, AX25_ADDR_LEN);
 		netif_tx_unlock_bh(dev);
 
 		err = 0;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 9b745d09d327..3d59dac063ac 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1563,9 +1563,6 @@ static void scc_net_setup(struct net_device *dev)
 	dev->netdev_ops	     = &scc_netdev_ops;
 	dev->header_ops      = &ax25_header_ops;
 
-	memcpy(dev->broadcast, &ax25_bcast,  AX25_ADDR_LEN);
-	memcpy(dev->dev_addr,  &ax25_defaddr, AX25_ADDR_LEN);
- 
 	dev->flags      = 0;
 
 	dev->type = ARPHRD_AX25;
@@ -1573,6 +1570,8 @@ static void scc_net_setup(struct net_device *dev)
 	dev->mtu = AX25_DEF_PACLEN;
 	dev->addr_len = AX25_ADDR_LEN;
 
+	memcpy(dev->broadcast, &ax25_bcast,  AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 }
 
 /* ----> open network device <---- */
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index e557ccf98bcf..6376b8485976 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1107,7 +1107,7 @@ static void yam_setup(struct net_device *dev)
 	dev->mtu = AX25_MTU;
 	dev->addr_len = AX25_ADDR_LEN;
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &ax25_defaddr, AX25_ADDR_LEN);
+	dev_addr_set(dev, (u8 *)&ax25_defaddr);
 }
 
 static int __init yam_init_driver(void)
-- 
2.31.1

