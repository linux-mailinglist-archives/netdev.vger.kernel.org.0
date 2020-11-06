Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C532A9FF1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgKFWTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbgKFWS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:58 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 596F6206F9;
        Fri,  6 Nov 2020 22:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701134;
        bh=5r0Twy0hkZ46Ow4AB53hpgvjT7PSWzsT+mWa0mgW00s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUVyYqYJ1u60yxZopNvlHebY97P5pBN9bVymcdNo7MXyiUrR9Uc2POrH7xmodAxhH
         /0FmfUz1nK/pKTV+UGDchrsJMz8DW/ANxkKq4ApsOOSmZ2fbvQNejc/8kMNw2ZLocv
         yfN0mACv/WDBKbPluMzBXdQYOHZWI6jNpvnuOmNA=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 21/28] wan: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:36 +0100
Message-Id: <20201106221743.3271965-22-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/c101.c         | 20 +++++++++++++-----
 drivers/net/wan/dlci.c         |  7 ++++---
 drivers/net/wan/farsync.c      | 38 ++++++++++++++++++++++++++--------
 drivers/net/wan/hdlc_fr.c      |  3 +++
 drivers/net/wan/lmc/lmc_main.c | 38 ++++++++++++++++++++--------------
 drivers/net/wan/n2.c           | 18 ++++++++++------
 drivers/net/wan/pc300too.c     | 19 ++++++++++-------
 drivers/net/wan/pci200syn.c    | 19 ++++++++++-------
 drivers/net/wan/sbni.c         | 12 +++++------
 drivers/net/wan/sdla.c         |  8 +++----
 10 files changed, 120 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index c354a5143e99..9821ead5df8a 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -219,14 +219,12 @@ static int c101_close(struct net_device *dev)
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
@@ -237,6 +235,17 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
 
@@ -300,6 +309,7 @@ static const struct net_device_ops c101_ops = {
 	.ndo_stop       = c101_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = c101_ioctl,
+	.ndo_siocdevprivate = c101_siocdevprivate,
 };
 
 static int __init c101_run(unsigned long irq, unsigned long winbase)
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 3ca4daf63389..057bf9080536 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -229,7 +229,8 @@ static int dlci_config(struct net_device *dev, struct dlci_conf __user *conf, in
 	return 0;
 }
 
-static int dlci_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int dlci_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			       void __user *data, int cmd)
 {
 	struct dlci_local *dlp;
 
@@ -252,7 +253,7 @@ static int dlci_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			if (!*(short *)(dev->dev_addr))
 				return -EINVAL;
 
-			return dlci_config(dev, ifr->ifr_data, cmd == DLCI_GET_CONF);
+			return dlci_config(dev, data, cmd == DLCI_GET_CONF);
 
 		default: 
 			return -EOPNOTSUPP;
@@ -458,7 +459,7 @@ static const struct header_ops dlci_header_ops = {
 static const struct net_device_ops dlci_netdev_ops = {
 	.ndo_open	= dlci_open,
 	.ndo_stop	= dlci_close,
-	.ndo_do_ioctl	= dlci_dev_ioctl,
+	.ndo_siocdevprivate = dlci_siocdevprivate,
 	.ndo_start_xmit	= dlci_transmit,
 	.ndo_change_mtu	= dlci_change_mtu,
 };
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index b50cf11d197d..1ee0245bf30a 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1975,7 +1975,7 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 }
 
 static int
-fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+fst_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct fst_card_info *card;
 	struct fst_port_info *port;
@@ -1984,7 +1984,7 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	unsigned long flags;
 	void *buf;
 
-	dbg(DBG_IOCTL, "ioctl: %x, %p\n", cmd, ifr->ifr_data);
+	dbg(DBG_IOCTL, "ioctl: %x, %p\n", cmd, data);
 
 	port = dev_to_port(dev);
 	card = port->card;
@@ -2008,10 +2008,10 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		/* First copy in the header with the length and offset of data
 		 * to write
 		 */
-		if (ifr->ifr_data == NULL) {
+		if (data == NULL) {
 			return -EINVAL;
 		}
-		if (copy_from_user(&wrthdr, ifr->ifr_data,
+		if (copy_from_user(&wrthdr, data,
 				   sizeof (struct fstioc_write))) {
 			return -EFAULT;
 		}
@@ -2026,7 +2026,7 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		/* Now copy the data to the card. */
 
-		buf = memdup_user(ifr->ifr_data + sizeof(struct fstioc_write),
+		buf = memdup_user(data + sizeof(struct fstioc_write),
 				  wrthdr.size);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
@@ -2059,13 +2059,13 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		if (ifr->ifr_data == NULL) {
+		if (data == NULL) {
 			return -EINVAL;
 		}
 
 		gather_conf_info(card, port, &info);
 
-		if (copy_to_user(ifr->ifr_data, &info, sizeof (info))) {
+		if (copy_to_user(data, &info, sizeof (info))) {
 			return -EFAULT;
 		}
 		return 0;
@@ -2082,12 +2082,31 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			       card->card_no, card->state);
 			return -EIO;
 		}
-		if (copy_from_user(&info, ifr->ifr_data, sizeof (info))) {
+		if (copy_from_user(&info, data, sizeof (info))) {
 			return -EFAULT;
 		}
 
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
@@ -2389,7 +2408,8 @@ static const struct net_device_ops fst_ops = {
 	.ndo_open       = fst_open,
 	.ndo_stop       = fst_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = fst_ioctl,
+	.ndo_do_ioctl	= fst_ioctl,
+	.ndo_siocdevprivate = fst_siocdevprivate,
 	.ndo_tx_timeout = fst_tx_timeout,
 };
 
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 409e5a7ad8e2..018f608e01d6 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -380,6 +380,9 @@ static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct pvc_device *pvc = dev->ml_priv;
 	fr_proto_pvc_info info;
 
+	if (cmd != SIOCWANDEV)
+		return -EOPNOTSUPP;
+
 	if (ifr->ifr_settings.type == IF_GET_PROTO) {
 		if (dev->type == ARPHRD_ETHER)
 			ifr->ifr_settings.type = IF_PROTO_FR_ETH_PVC;
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 36600b0a0ab0..76fcc4bd39c8 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -105,7 +105,8 @@ static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueue);
  * linux reserves 16 device specific IOCTLs.  We call them
  * LMCIOC* to control various bits of our world.
  */
-int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
+static int lmc_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			void __user *data, int cmd) /*fold00*/
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
@@ -211,7 +212,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
-        if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
+        if (copy_to_user(data, &sc->lmc_xinfo,
 			 sizeof(struct lmc_xinfo)))
 		ret = -EFAULT;
 	else
@@ -245,9 +246,9 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
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
@@ -282,7 +283,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             break;
         }
 
-	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+	if (copy_from_user(&ctl, data, sizeof(lmc_ctl_t))) {
 		ret = -EFAULT;
 		break;
 	}
@@ -314,11 +315,11 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
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
@@ -346,7 +347,7 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
              */
             netif_stop_queue(dev);
 
-	    if (copy_from_user(&xc, ifr->ifr_data, sizeof(struct lmc_xilinx_control))) {
+	    if (copy_from_user(&xc, data, sizeof(struct lmc_xilinx_control))) {
 		ret = -EFAULT;
 		break;
 	    }
@@ -611,15 +612,21 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
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
@@ -791,6 +798,7 @@ static const struct net_device_ops lmc_ops = {
 	.ndo_stop       = lmc_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = lmc_ioctl,
+	.ndo_siocdevprivate = lmc_siocdevprivate,
 	.ndo_tx_timeout = lmc_driver_timeout,
 	.ndo_get_stats  = lmc_get_stats,
 };
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 5bf4463873b1..c203c4fb29a6 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -242,6 +242,17 @@ static int n2_close(struct net_device *dev)
 }
 
 
+static int n2_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			     void __user *data, int cmd)
+{
+#ifdef DEBUG_RINGS
+	if (cmd == SIOCDEVPRIVATE) {
+		sca_dump_rings(dev);
+		return 0;
+	}
+#endif
+	return -EOPNOTSUPP;
+}
 
 static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
@@ -250,12 +261,6 @@ static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
 	port_t *port = dev_to_port(dev);
 
-#ifdef DEBUG_RINGS
-	if (cmd == SIOCDEVPRIVATE) {
-		sca_dump_rings(dev);
-		return 0;
-	}
-#endif
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -329,6 +334,7 @@ static const struct net_device_ops n2_ops = {
 	.ndo_stop       = n2_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = n2_ioctl,
+	.ndo_siocdevprivate = n2_siocdevprivate,
 };
 
 static int __init n2_run(unsigned long io, unsigned long irq,
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 001fd378d417..17073ed3456c 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -186,7 +186,17 @@ static int pc300_close(struct net_device *dev)
 	return 0;
 }
 
-
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
 
 static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
@@ -196,12 +206,6 @@ static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
 
@@ -290,6 +294,7 @@ static const struct net_device_ops pc300_ops = {
 	.ndo_stop       = pc300_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = pc300_ioctl,
+	.ndo_siocdevprivate = pc300_siocdevprivate,
 };
 
 static int pc300_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index d0062224b216..489453c52d3a 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -177,7 +177,17 @@ static int pci200_close(struct net_device *dev)
 	return 0;
 }
 
-
+static int pci200_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				 void __user *data, int cmd)
+{
+#ifdef DEBUG_RINGS
+	if (cmd == SIOCDEVPRIVATE) {
+		sca_dump_rings(dev);
+		return 0;
+	}
+#endif
+	return -EOPNOTSUPP;
+}
 
 static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
@@ -186,12 +196,6 @@ static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
 	port_t *port = dev_to_port(dev);
 
-#ifdef DEBUG_RINGS
-	if (cmd == SIOCDEVPRIVATE) {
-		sca_dump_rings(dev);
-		return 0;
-	}
-#endif
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
@@ -268,6 +272,7 @@ static const struct net_device_ops pci200_ops = {
 	.ndo_stop       = pci200_close,
 	.ndo_start_xmit = hdlc_start_xmit,
 	.ndo_do_ioctl   = pci200_ioctl,
+	.ndo_siocdevprivate = pci200_siocdevprivate,
 };
 
 static int pci200_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 2fde439543fb..f540578b1349 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -119,7 +119,7 @@ static int  sbni_open( struct net_device * );
 static int  sbni_close( struct net_device * );
 static netdev_tx_t sbni_start_xmit(struct sk_buff *,
 					 struct net_device * );
-static int  sbni_ioctl( struct net_device *, struct ifreq *, int );
+static int  sbni_siocdevprivate( struct net_device *, struct ifreq *, void __user *, int );
 static void  set_multicast_list( struct net_device * );
 
 static irqreturn_t sbni_interrupt( int, void * );
@@ -211,7 +211,7 @@ static const struct net_device_ops sbni_netdev_ops = {
 	.ndo_stop		= sbni_close,
 	.ndo_start_xmit		= sbni_start_xmit,
 	.ndo_set_rx_mode	= set_multicast_list,
-	.ndo_do_ioctl		= sbni_ioctl,
+	.ndo_siocdevprivate	= sbni_siocdevprivate,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -1297,7 +1297,7 @@ sbni_card_probe( unsigned long  ioaddr )
 /* -------------------------------------------------------------------------- */
 
 static int
-sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
+sbni_siocdevprivate( struct net_device  *dev,  struct ifreq  *ifr, void __user *data, int  cmd )
 {
 	struct net_local  *nl = netdev_priv(dev);
 	struct sbni_flags  flags;
@@ -1310,7 +1310,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
   
 	switch( cmd ) {
 	case  SIOCDEVGETINSTATS :
-		if (copy_to_user( ifr->ifr_data, &nl->in_stats,
+		if (copy_to_user(data, &nl->in_stats,
 					sizeof(struct sbni_in_stats) ))
 			error = -EFAULT;
 		break;
@@ -1328,7 +1328,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		flags.rxl	= nl->cur_rxl_index;
 		flags.fixed_rxl	= nl->delta_rxl == 0;
 
-		if (copy_to_user( ifr->ifr_data, &flags, sizeof flags ))
+		if (copy_to_user(data, &flags, sizeof flags ))
 			error = -EFAULT;
 		break;
 
@@ -1358,7 +1358,7 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 		if (!capable(CAP_NET_ADMIN))
 			return  -EPERM;
 
-		if (copy_from_user( slave_name, ifr->ifr_data, sizeof slave_name ))
+		if (copy_from_user( slave_name, data, sizeof slave_name ))
 			return -EFAULT;
 		slave_dev = dev_get_by_name(&init_net, slave_name );
 		if( !slave_dev  ||  !(slave_dev->flags & IFF_UP) ) {
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index bc2c1c7fb1a4..761e217e9954 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -1245,7 +1245,7 @@ static int sdla_reconfig(struct net_device *dev)
 	return 0;
 }
 
-static int sdla_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int sdla_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct frad_local *flp;
 
@@ -1261,7 +1261,7 @@ static int sdla_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	{
 		case FRAD_GET_CONF:
 		case FRAD_SET_CONF:
-			return sdla_config(dev, ifr->ifr_data, cmd == FRAD_GET_CONF);
+			return sdla_config(dev, data, cmd == FRAD_GET_CONF);
 
 		case SDLA_IDENTIFY:
 			ifr->ifr_flags = flp->type;
@@ -1298,7 +1298,7 @@ NOTE:  This is rather a useless action right now, as the
 		case SDLA_READMEM:
 			if(!capable(CAP_SYS_RAWIO))
 				return -EPERM;
-			return sdla_xfer(dev, ifr->ifr_data, cmd == SDLA_READMEM);
+			return sdla_xfer(dev, data, cmd == SDLA_READMEM);
 
 		case SDLA_START:
 			sdla_start(dev);
@@ -1586,7 +1586,7 @@ static int sdla_set_config(struct net_device *dev, struct ifmap *map)
 static const struct net_device_ops sdla_netdev_ops = {
 	.ndo_open	= sdla_open,
 	.ndo_stop	= sdla_close,
-	.ndo_do_ioctl	= sdla_ioctl,
+	.ndo_siocdevprivate = sdla_siocdevprivate,
 	.ndo_set_config	= sdla_set_config,
 	.ndo_start_xmit	= sdla_transmit,
 	.ndo_change_mtu	= sdla_change_mtu,
-- 
2.27.0

