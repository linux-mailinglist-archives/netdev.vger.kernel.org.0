Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE9A3D7751
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbhG0Nrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237148AbhG0Nqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA2A61AD1;
        Tue, 27 Jul 2021 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393601;
        bh=CdhAJIp7fNSznb5/1c8GBT4xHhCrxBJl05hwA1SGI0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY5WZ3o20/6TZa1t7Qa9EYvQ8fIZwbSu/hDcEnV2tnIsReFtOZuLOZCOWwT3Cwngb
         wciL8DWv7SOl8aSAcFvnj672B03JCjaDxXv9EkimSHpC/Ft6Qdb4Ae5hf4ung6mym6
         03rTyMd93svYG6wCixoh3xJ7mwQh5dwejRpphf23KTNh6uCxMycKjsxZath/IZEC9z
         KY5smKotEE8mucRZKqxm8+EH+yxkrC7cnA4m4k7LmNtchMAZjXgsLVPLOto5KXLLhP
         5HadngDv64riVhGl6O3ZV9g8T0Sx8SoZMAm/M3N3QUKftAaY1Zrw1O/eryXSpd79+U
         I7GZlF859GpMQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>
Subject: [PATCH net-next v3 24/31] wan: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:10 +0200
Message-Id: <20210727134517.1384504-25-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The wan drivers each support some custom SIOCDEVPRIVATE
ioctls, plus the common SIOCWANDEV command.

Split these so the ioctl callback only deals with SIOCWANDEV
and the rest is handled by ndo_siocdevprivate.

It might make sense to also split out SIOCWANDEV into a
separate callback in order to eventually remove ndo_do_ioctl
entirely.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Kevin Curtis <kevin.curtis@farsite.co.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/c101.c         | 20 ++++++++++++-----
 drivers/net/wan/farsync.c      | 39 +++++++++++++++++++++++++---------
 drivers/net/wan/hdlc_fr.c      |  3 +++
 drivers/net/wan/lmc/lmc_main.c | 39 ++++++++++++++++++++--------------
 drivers/net/wan/n2.c           | 19 +++++++++++------
 drivers/net/wan/pc300too.c     | 19 +++++++++++------
 drivers/net/wan/pci200syn.c    | 19 +++++++++++------
 drivers/net/wan/sbni.c         | 15 +++++++------
 8 files changed, 117 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 059c2f7133be..ca308230500d 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -208,14 +208,12 @@ static int c101_close(struct net_device *dev)
 	return 0;
 }
 
-static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int c101_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			       void __user *data, int cmd)
 {
-	const size_t size = sizeof(sync_serial_settings);
-	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+#ifdef DEBUG_RINGS
 	port_t *port = dev_to_port(dev);
 
-#ifdef DEBUG_RINGS
 	if (cmd == SIOCDEVPRIVATE) {
 		sca_dump_rings(dev);
 		printk(KERN_DEBUG "MSCI1: ST: %02x %02x %02x %02x\n",
@@ -226,6 +224,17 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 	}
 #endif
+
+	return -EOPNOTSUPP;
+}
+
+static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	const size_t size = sizeof(sync_serial_settings);
+	sync_serial_settings new_line;
+	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	port_t *port = dev_to_port(dev);
+
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -287,6 +296,7 @@ static const struct net_device_ops c101_ops = {
 	.ndo_stop       = c101_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = c101_ioctl,
+	.ndo_siocdevprivate = c101_siocdevprivate,
 };
 
 static int __init c101_run(unsigned long irq, unsigned long winbase)
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index b3466e084e84..d0e3cab98645 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1909,7 +1909,7 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 }
 
 static int
-fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+fst_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct fst_card_info *card;
 	struct fst_port_info *port;
@@ -1918,7 +1918,7 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	unsigned long flags;
 	void *buf;
 
-	dbg(DBG_IOCTL, "ioctl: %x, %p\n", cmd, ifr->ifr_data);
+	dbg(DBG_IOCTL, "ioctl: %x, %p\n", cmd, data);
 
 	port = dev_to_port(dev);
 	card = port->card;
@@ -1942,11 +1942,10 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		/* First copy in the header with the length and offset of data
 		 * to write
 		 */
-		if (!ifr->ifr_data)
+		if (!data)
 			return -EINVAL;
 
-		if (copy_from_user(&wrthdr, ifr->ifr_data,
-				   sizeof(struct fstioc_write)))
+		if (copy_from_user(&wrthdr, data, sizeof(struct fstioc_write)))
 			return -EFAULT;
 
 		/* Sanity check the parameters. We don't support partial writes
@@ -1958,7 +1957,7 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		/* Now copy the data to the card. */
 
-		buf = memdup_user(ifr->ifr_data + sizeof(struct fstioc_write),
+		buf = memdup_user(data + sizeof(struct fstioc_write),
 				  wrthdr.size);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
@@ -1991,12 +1990,12 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		if (!ifr->ifr_data)
+		if (!data)
 			return -EINVAL;
 
 		gather_conf_info(card, port, &info);
 
-		if (copy_to_user(ifr->ifr_data, &info, sizeof(info)))
+		if (copy_to_user(data, &info, sizeof(info)))
 			return -EFAULT;
 
 		return 0;
@@ -2011,11 +2010,30 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			       card->card_no, card->state);
 			return -EIO;
 		}
-		if (copy_from_user(&info, ifr->ifr_data, sizeof(info)))
+		if (copy_from_user(&info, data, sizeof(info)))
 			return -EFAULT;
 
 		return set_conf_from_info(card, port, &info);
+	default:
+		return -EINVAL;
+	}
+}
 
+static int
+fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct fst_card_info *card;
+	struct fst_port_info *port;
+
+	dbg(DBG_IOCTL, "ioctl: %x, %x\n", cmd, ifr->ifr_settings.type);
+
+	port = dev_to_port(dev);
+	card = port->card;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
 	case SIOCWANDEV:
 		switch (ifr->ifr_settings.type) {
 		case IF_GET_IFACE:
@@ -2310,7 +2328,8 @@ static const struct net_device_ops fst_ops = {
 	.ndo_open       = fst_open,
 	.ndo_stop       = fst_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = fst_ioctl,
+	.ndo_do_ioctl	= fst_ioctl,
+	.ndo_siocdevprivate = fst_siocdevprivate,
 	.ndo_tx_timeout = fst_tx_timeout,
 };
 
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 25e3564ce118..2910ea25e51d 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -362,6 +362,9 @@ static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct pvc_device *pvc = dev->ml_priv;
 	fr_proto_pvc_info info;
 
+	if (cmd != SIOCWANDEV)
+		return -EOPNOTSUPP;
+
 	if (ifr->ifr_settings.type == IF_GET_PROTO) {
 		if (dev->type == ARPHRD_ETHER)
 			ifr->ifr_settings.type = IF_PROTO_FR_ETH_PVC;
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 6c163db52835..26a4ffbff73b 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -105,7 +105,8 @@ static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueue);
  * linux reserves 16 device specific IOCTLs.  We call them
  * LMCIOC* to control various bits of our world.
  */
-int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
+static int lmc_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, int cmd) /*fold00*/
 {
     lmc_softc_t *sc = dev_to_sc(dev);
     lmc_ctl_t ctl;
@@ -124,7 +125,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
          * To date internally, just copy this out to the user.
          */
     case LMCIOCGINFO: /*fold01*/
-	if (copy_to_user(ifr->ifr_data, &sc->ictl, sizeof(lmc_ctl_t)))
+	if (copy_to_user(data, &sc->ictl, sizeof(lmc_ctl_t)))
 		ret = -EFAULT;
 	else
 		ret = 0;
@@ -141,7 +142,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             break;
         }
 
-	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+	if (copy_from_user(&ctl, data, sizeof(lmc_ctl_t))) {
 		ret = -EFAULT;
 		break;
 	}
@@ -171,7 +172,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 		break;
 	    }
 
-	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u16))) {
+	    if (copy_from_user(&new_type, data, sizeof(u16))) {
 		ret = -EFAULT;
 		break;
 	    }
@@ -211,8 +212,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
-        if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
-			 sizeof(struct lmc_xinfo)))
+	if (copy_to_user(data, &sc->lmc_xinfo, sizeof(struct lmc_xinfo)))
 		ret = -EFAULT;
 	else
 		ret = 0;
@@ -245,9 +245,9 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 			    regVal & T1FRAMER_SEF_MASK;
 	    }
 	    spin_unlock_irqrestore(&sc->lmc_lock, flags);
-	    if (copy_to_user(ifr->ifr_data, &sc->lmc_device->stats,
+	    if (copy_to_user(data, &sc->lmc_device->stats,
 			     sizeof(sc->lmc_device->stats)) ||
-		copy_to_user(ifr->ifr_data + sizeof(sc->lmc_device->stats),
+		copy_to_user(data + sizeof(sc->lmc_device->stats),
 			     &sc->extra_stats, sizeof(sc->extra_stats)))
 		    ret = -EFAULT;
 	    else
@@ -282,7 +282,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             break;
         }
 
-	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+	if (copy_from_user(&ctl, data, sizeof(lmc_ctl_t))) {
 		ret = -EFAULT;
 		break;
 	}
@@ -314,11 +314,11 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
 #ifdef DEBUG
     case LMCIOCDUMPEVENTLOG:
-	if (copy_to_user(ifr->ifr_data, &lmcEventLogIndex, sizeof(u32))) {
+	if (copy_to_user(data, &lmcEventLogIndex, sizeof(u32))) {
 		ret = -EFAULT;
 		break;
 	}
-	if (copy_to_user(ifr->ifr_data + sizeof(u32), lmcEventLogBuf,
+	if (copy_to_user(data + sizeof(u32), lmcEventLogBuf,
 			 sizeof(lmcEventLogBuf)))
 		ret = -EFAULT;
 	else
@@ -346,7 +346,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
              */
             netif_stop_queue(dev);
 
-	    if (copy_from_user(&xc, ifr->ifr_data, sizeof(struct lmc_xilinx_control))) {
+	    if (copy_from_user(&xc, data, sizeof(struct lmc_xilinx_control))) {
 		ret = -EFAULT;
 		break;
 	    }
@@ -609,15 +609,21 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
         }
         break;
-    default: /*fold01*/
-        /* If we don't know what to do, give the protocol a shot. */
-        ret = lmc_proto_ioctl (sc, ifr, cmd);
-        break;
+    default:
+	break;
     }
 
     return ret;
 }
 
+int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	if (cmd != SIOCWANDEV)
+		return -EOPNOTSUPP;
+
+	return lmc_proto_ioctl(dev_to_sc(dev), ifr, cmd);
+}
+
 
 /* the watchdog process that cruises around */
 static void lmc_watchdog(struct timer_list *t) /*fold00*/
@@ -789,6 +795,7 @@ static const struct net_device_ops lmc_ops = {
 	.ndo_stop       = lmc_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = lmc_ioctl,
+	.ndo_siocdevprivate = lmc_siocdevprivate,
 	.ndo_tx_timeout = lmc_driver_timeout,
 	.ndo_get_stats  = lmc_get_stats,
 };
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index bdb6dc2409bc..4122ca2cd07d 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -227,19 +227,25 @@ static int n2_close(struct net_device *dev)
 	return 0;
 }
 
-static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int n2_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			     void __user *data, int cmd)
 {
-	const size_t size = sizeof(sync_serial_settings);
-	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
-	port_t *port = dev_to_port(dev);
-
 #ifdef DEBUG_RINGS
 	if (cmd == SIOCDEVPRIVATE) {
 		sca_dump_rings(dev);
 		return 0;
 	}
 #endif
+	return -EOPNOTSUPP;
+}
+
+static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	const size_t size = sizeof(sync_serial_settings);
+	sync_serial_settings new_line;
+	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	port_t *port = dev_to_port(dev);
+
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -312,6 +318,7 @@ static const struct net_device_ops n2_ops = {
 	.ndo_stop       = n2_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = n2_ioctl,
+	.ndo_siocdevprivate = n2_siocdevprivate,
 };
 
 static int __init n2_run(unsigned long io, unsigned long irq,
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 7b123a771aa6..8cdfd0056c81 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -174,6 +174,18 @@ static int pc300_close(struct net_device *dev)
 	return 0;
 }
 
+static int pc300_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd)
+{
+#ifdef DEBUG_RINGS
+	if (cmd == SIOCDEVPRIVATE) {
+		sca_dump_rings(dev);
+		return 0;
+	}
+#endif
+	return -EOPNOTSUPP;
+}
+
 static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -182,12 +194,6 @@ static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	int new_type;
 	port_t *port = dev_to_port(dev);
 
-#ifdef DEBUG_RINGS
-	if (cmd == SIOCDEVPRIVATE) {
-		sca_dump_rings(dev);
-		return 0;
-	}
-#endif
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -273,6 +279,7 @@ static const struct net_device_ops pc300_ops = {
 	.ndo_stop       = pc300_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = pc300_ioctl,
+	.ndo_siocdevprivate = pc300_siocdevprivate,
 };
 
 static int pc300_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index dee9c4e15eca..f4dc3dda25b7 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -167,19 +167,25 @@ static int pci200_close(struct net_device *dev)
 	return 0;
 }
 
-static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int pci200_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				 void __user *data, int cmd)
 {
-	const size_t size = sizeof(sync_serial_settings);
-	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
-	port_t *port = dev_to_port(dev);
-
 #ifdef DEBUG_RINGS
 	if (cmd == SIOCDEVPRIVATE) {
 		sca_dump_rings(dev);
 		return 0;
 	}
 #endif
+	return -EOPNOTSUPP;
+}
+
+static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	const size_t size = sizeof(sync_serial_settings);
+	sync_serial_settings new_line;
+	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	port_t *port = dev_to_port(dev);
+
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -254,6 +260,7 @@ static const struct net_device_ops pci200_ops = {
 	.ndo_stop       = pci200_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = pci200_ioctl,
+	.ndo_siocdevprivate = pci200_siocdevprivate,
 };
 
 static int pci200_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 3092a09d3eaa..469fe979d664 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -119,7 +119,8 @@ static int  sbni_open( struct net_device * );
 static int  sbni_close( struct net_device * );
 static netdev_tx_t sbni_start_xmit(struct sk_buff *,
 					 struct net_device * );
-static int  sbni_ioctl( struct net_device *, struct ifreq *, int );
+static int  sbni_siocdevprivate(struct net_device *, struct ifreq *,
+				void __user *, int);
 static void  set_multicast_list( struct net_device * );
 
 static irqreturn_t sbni_interrupt( int, void * );
@@ -211,7 +212,7 @@ static const struct net_device_ops sbni_netdev_ops = {
 	.ndo_stop		= sbni_close,
 	.ndo_start_xmit		= sbni_start_xmit,
 	.ndo_set_rx_mode	= set_multicast_list,
-	.ndo_do_ioctl		= sbni_ioctl,
+	.ndo_siocdevprivate	= sbni_siocdevprivate,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -1297,7 +1298,7 @@ sbni_card_probe( unsigned long  ioaddr )
 /* -------------------------------------------------------------------------- */
 
 static int
-sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
+sbni_siocdevprivate(struct net_device  *dev,  struct ifreq  *ifr, void __user *data, int  cmd)
 {
 	struct net_local  *nl = netdev_priv(dev);
 	struct sbni_flags  flags;
@@ -1310,8 +1311,8 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
   
 	switch( cmd ) {
 	case  SIOCDEVGETINSTATS :
-		if (copy_to_user( ifr->ifr_data, &nl->in_stats,
-					sizeof(struct sbni_in_stats) ))
+		if (copy_to_user(data, &nl->in_stats,
+				 sizeof(struct sbni_in_stats)))
 			error = -EFAULT;
 		break;
 
@@ -1328,7 +1329,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		flags.rxl	= nl->cur_rxl_index;
 		flags.fixed_rxl	= nl->delta_rxl == 0;
 
-		if (copy_to_user( ifr->ifr_data, &flags, sizeof flags ))
+		if (copy_to_user(data, &flags, sizeof(flags)))
 			error = -EFAULT;
 		break;
 
@@ -1358,7 +1359,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		if (!capable(CAP_NET_ADMIN))
 			return  -EPERM;
 
-		if (copy_from_user( slave_name, ifr->ifr_data, sizeof slave_name ))
+		if (copy_from_user(slave_name, data, sizeof(slave_name)))
 			return -EFAULT;
 		slave_dev = dev_get_by_name(&init_net, slave_name );
 		if( !slave_dev  ||  !(slave_dev->flags & IFF_UP) ) {
-- 
2.29.2

