Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C4E42A729
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhJLOaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236976AbhJLOaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 10:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB4B46101D;
        Tue, 12 Oct 2021 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634048885;
        bh=wRpUKNfda/k18VJZ/e+UYBVvtDps8dju8d9901w7nV8=;
        h=From:To:Cc:Subject:Date:From;
        b=KCtpIJP+kWrPZ36MmpZ8TSK8gFuJLsHSSCHSDjIy2RlVbQ9nq0y3ByaMZMh5ZkgVv
         Bmav0cdVNj4QQNLEid9LZKAyOy6owyc6vA3rJQDn/5NoZx4AAoR+Xx/lfveOo3DVUs
         DCzXT0ToLuu/rSM3fLdb42VG9cd5C8U3rqf8bvCibnR+l+qBknfLblYI/DneL7ifok
         8JaOLvvGUyxqeCKOJeyHiv/q+Bey+3NyuxwT5YpXv6I3p5ed6ndrPgawWMWVw9525B
         yQDigz4QJFWCyDvHe/P7z5oq9Whpr7q5u0Slamt0YvmQgA85UaYES8eesYhZxjUI9D
         3c6EeF9Zjbsng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sre@kernel.org, m.grzeschik@pengutronix.de,
        balbi@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: remove single-byte netdev->dev_addr writes
Date:   Tue, 12 Oct 2021 07:27:57 -0700
Message-Id: <20211012142757.4124842-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the drivers which use single-byte netdev addresses
(netdev->addr_len == 1) use the appropriate address setting
helpers.

arcnet copies from int variables and io reads a lot, so
add a helper for arcnet drivers to use.

Similar helper could be reused for phonet and appletalk
but there isn't any good central location where we could
put it, and netdevice.h is already very crowded.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/hsi/clients/ssi_protocol.c     | 4 +++-
 drivers/net/appletalk/cops.c           | 2 +-
 drivers/net/appletalk/ltpc.c           | 3 +--
 drivers/net/arcnet/arc-rimi.c          | 5 +++--
 drivers/net/arcnet/arcdevice.h         | 5 +++++
 drivers/net/arcnet/com20020-isa.c      | 2 +-
 drivers/net/arcnet/com20020-pci.c      | 2 +-
 drivers/net/arcnet/com20020.c          | 4 ++--
 drivers/net/arcnet/com20020_cs.c       | 2 +-
 drivers/net/arcnet/com90io.c           | 2 +-
 drivers/net/arcnet/com90xx.c           | 3 ++-
 drivers/net/usb/cdc-phonet.c           | 4 +++-
 drivers/usb/gadget/function/f_phonet.c | 5 ++++-
 13 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 96d0eccca3aa..21f11a5b965b 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -1055,14 +1055,16 @@ static const struct net_device_ops ssip_pn_ops = {
 
 static void ssip_pn_setup(struct net_device *dev)
 {
+	static const u8 addr = PN_MEDIA_SOS;
+
 	dev->features		= 0;
 	dev->netdev_ops		= &ssip_pn_ops;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= SSIP_DEFAULT_MTU;
 	dev->hard_header_len	= 1;
-	dev->dev_addr[0]	= PN_MEDIA_SOS;
 	dev->addr_len		= 1;
+	dev_addr_set(dev, &addr);
 	dev->tx_queue_len	= SSIP_TXQUEUE_LEN;
 
 	dev->needs_free_netdev	= true;
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index f0695d68c47e..97f254bdbb16 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -945,8 +945,8 @@ static int cops_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
                         dev->broadcast[0]       = 0xFF;
 			
 			/* Set hardware address. */
-                        dev->dev_addr[0]        = aa->s_node;
                         dev->addr_len           = 1;
+			dev_addr_set(dev, &aa->s_node);
                         return 0;
 
                 case SIOCGIFADDR:
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 1f8925e75b3f..388d7b3bd4c2 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -846,9 +846,8 @@ static int ltpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			set_30 (dev,ltflags);  
 
 			dev->broadcast[0] = 0xFF;
-			dev->dev_addr[0] = aa->s_node;
-
 			dev->addr_len=1;
+			dev_addr_set(dev, &aa->s_node);
    
 			return 0;
 
diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index 12d085405bd0..8c3ccc7c83cd 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -207,7 +207,8 @@ static int __init arcrimi_found(struct net_device *dev)
 	}
 
 	/* get and check the station ID from offset 1 in shmem */
-	dev->dev_addr[0] = arcnet_readb(lp->mem_start, COM9026_REG_R_STATION);
+	arcnet_set_addr(dev, arcnet_readb(lp->mem_start,
+					  COM9026_REG_R_STATION));
 
 	arc_printk(D_NORMAL, dev, "ARCnet RIM I: station %02Xh found at IRQ %d, ShMem %lXh (%ld*%d bytes)\n",
 		   dev->dev_addr[0],
@@ -324,7 +325,7 @@ static int __init arc_rimi_init(void)
 		return -ENOMEM;
 
 	if (node && node != 0xff)
-		dev->dev_addr[0] = node;
+		arcnet_set_addr(dev, node);
 
 	dev->mem_start = io;
 	dev->irq = irq;
diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.h
index 5d4a4c7efbbf..19e996a829c9 100644
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -364,6 +364,11 @@ netdev_tx_t arcnet_send_packet(struct sk_buff *skb,
 			       struct net_device *dev);
 void arcnet_timeout(struct net_device *dev, unsigned int txqueue);
 
+static inline void arcnet_set_addr(struct net_device *dev, u8 addr)
+{
+	dev_addr_set(dev, &addr);
+}
+
 /* I/O equivalents */
 
 #ifdef CONFIG_SA1100_CT6001
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index be618e4b9ed5..293a621e654c 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -151,7 +151,7 @@ static int __init com20020_init(void)
 		return -ENOMEM;
 
 	if (node && node != 0xff)
-		dev->dev_addr[0] = node;
+		arcnet_set_addr(dev, node);
 
 	dev->netdev_ops = &com20020_netdev_ops;
 
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 3c8f665c1558..6382e1937cca 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -194,7 +194,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 		SET_NETDEV_DEV(dev, &pdev->dev);
 		dev->base_addr = ioaddr;
-		dev->dev_addr[0] = node;
+		arcnet_set_addr(dev, node);
 		dev->sysfs_groups[0] = &com20020_state_group;
 		dev->irq = pdev->irq;
 		lp->card_name = "PCI COM20020";
diff --git a/drivers/net/arcnet/com20020.c b/drivers/net/arcnet/com20020.c
index 78043a9c5981..06e1651b594b 100644
--- a/drivers/net/arcnet/com20020.c
+++ b/drivers/net/arcnet/com20020.c
@@ -157,7 +157,7 @@ static int com20020_set_hwaddr(struct net_device *dev, void *addr)
 	struct arcnet_local *lp = netdev_priv(dev);
 	struct sockaddr *hwaddr = addr;
 
-	memcpy(dev->dev_addr, hwaddr->sa_data, 1);
+	dev_addr_set(dev, hwaddr->sa_data);
 	com20020_set_subaddress(lp, ioaddr, SUB_NODE);
 	arcnet_outb(dev->dev_addr[0], ioaddr, COM20020_REG_W_XREG);
 
@@ -220,7 +220,7 @@ int com20020_found(struct net_device *dev, int shared)
 
 	/* FIXME: do this some other way! */
 	if (!dev->dev_addr[0])
-		dev->dev_addr[0] = arcnet_inb(ioaddr, 8);
+		arcnet_set_addr(dev, arcnet_inb(ioaddr, 8));
 
 	com20020_set_subaddress(lp, ioaddr, SUB_SETUP1);
 	arcnet_outb(lp->setup, ioaddr, COM20020_REG_W_XREG);
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index b88a109b3b15..24150c933fcb 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -133,7 +133,7 @@ static int com20020_probe(struct pcmcia_device *p_dev)
 	lp->hw.owner = THIS_MODULE;
 
 	/* fill in our module parameters as defaults */
-	dev->dev_addr[0] = node;
+	arcnet_set_addr(dev, node);
 
 	p_dev->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
 	p_dev->resource[0]->end = 16;
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index 3856b447d38e..37b47749fc8b 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -252,7 +252,7 @@ static int __init com90io_found(struct net_device *dev)
 
 	/* get and check the station ID from offset 1 in shmem */
 
-	dev->dev_addr[0] = get_buffer_byte(dev, 1);
+	arcnet_set_addr(dev, get_buffer_byte(dev, 1));
 
 	err = register_netdev(dev);
 	if (err) {
diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
index d8dfb9ea0de8..f49dae194284 100644
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -531,7 +531,8 @@ static int __init com90xx_found(int ioaddr, int airq, u_long shmem,
 	}
 
 	/* get and check the station ID from offset 1 in shmem */
-	dev->dev_addr[0] = arcnet_readb(lp->mem_start, COM9026_REG_R_STATION);
+	arcnet_set_addr(dev, arcnet_readb(lp->mem_start,
+					  COM9026_REG_R_STATION));
 
 	dev->base_addr = ioaddr;
 
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index e1da9102a540..ad5121e9cf5d 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -275,6 +275,8 @@ static const struct net_device_ops usbpn_ops = {
 
 static void usbpn_setup(struct net_device *dev)
 {
+	const u8 addr = PN_MEDIA_USB;
+
 	dev->features		= 0;
 	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
@@ -284,8 +286,8 @@ static void usbpn_setup(struct net_device *dev)
 	dev->min_mtu		= PHONET_MIN_MTU;
 	dev->max_mtu		= PHONET_MAX_MTU;
 	dev->hard_header_len	= 1;
-	dev->dev_addr[0]	= PN_MEDIA_USB;
 	dev->addr_len		= 1;
+	dev_addr_set(dev, &addr);
 	dev->tx_queue_len	= 3;
 
 	dev->needs_free_netdev	= true;
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 0b468f5d55bc..068ed8417e5a 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -267,6 +267,8 @@ static const struct net_device_ops pn_netdev_ops = {
 
 static void pn_net_setup(struct net_device *dev)
 {
+	const u8 addr = PN_MEDIA_USB;
+
 	dev->features		= 0;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
@@ -274,8 +276,9 @@ static void pn_net_setup(struct net_device *dev)
 	dev->min_mtu		= PHONET_MIN_MTU;
 	dev->max_mtu		= PHONET_MAX_MTU;
 	dev->hard_header_len	= 1;
-	dev->dev_addr[0]	= PN_MEDIA_USB;
 	dev->addr_len		= 1;
+	dev_addr_set(dev, &addr);
+
 	dev->tx_queue_len	= 1;
 
 	dev->netdev_ops		= &pn_netdev_ops;
-- 
2.31.1

