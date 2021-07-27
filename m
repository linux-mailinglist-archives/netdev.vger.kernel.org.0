Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD13D7768
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbhG0Nr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237169AbhG0Nqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BD0E619F5;
        Tue, 27 Jul 2021 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393610;
        bh=Hu0nXWiSDd56BsyP4aU8z4z3mXFXhgiEYKoWfB1HIOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOOSBukwSdza1/IXrHQTZYhfpbD4XOccwoj06AOvlTmhQ8idwnq+85ScQniRkhaWt
         3A+VcvoPHzux/xwNJ2dJ9KfFiwtPrRC6ehTnXYWEih7jHpRN2+hj07Oh7JIsVjFoeD
         LhtUJcMbkHJ6TJ4KhRRhOSVPrwhqqHopkWtN78Sh6Is1uffNLYItqVyvHvcMqe/cIO
         rKfE/NRvo+9GYHsLQRMKC7+FsKEYnvG1oFRL3TRq6j6KjAl2H+TfNPtCsR0/9CTH+B
         KozVJcqVW2XWx1wq//lynr4p9K7lijbcSuu5EByAzD/fdQciMGz3b0LGgn/H/Us6DN
         vMsz82rE5xsTA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jiri Slaby <jirislaby@kernel.org>, linux-x25@vger.kernel.org
Subject: [PATCH net-next v3 28/31] net: split out ndo_siowandev ioctl
Date:   Tue, 27 Jul 2021 15:45:14 +0200
Message-Id: <20210727134517.1384504-29-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

In order to further reduce the scope of ndo_do_ioctl(), move
out the SIOCWANDEV handling into a new network device operation
function.

Adjust the prototype to only pass the if_settings sub-structure
in place of the ifreq, and remove the redundant 'cmd' argument
in the process.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Jan \"Yenya\" Kasprzak" <kas@fi.muni.cz>
Cc: Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc: Zhao Qiang <qiang.zhao@nxp.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: linux-x25@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/netdevices.rst |  7 ++
 drivers/char/pcmcia/synclink_cs.c       | 23 +++----
 drivers/net/wan/c101.c                  | 19 +++--
 drivers/net/wan/cosa.c                  |  2 +-
 drivers/net/wan/farsync.c               | 92 +++++++++++--------------
 drivers/net/wan/fsl_ucc_hdlc.c          | 19 +++--
 drivers/net/wan/hdlc.c                  |  9 +--
 drivers/net/wan/hdlc_cisco.c            | 14 ++--
 drivers/net/wan/hdlc_fr.c               | 43 ++++++------
 drivers/net/wan/hdlc_ppp.c              |  8 +--
 drivers/net/wan/hdlc_raw.c              | 14 ++--
 drivers/net/wan/hdlc_raw_eth.c          | 14 ++--
 drivers/net/wan/hdlc_x25.c              | 16 ++---
 drivers/net/wan/hostess_sv11.c          |  7 +-
 drivers/net/wan/ixp4xx_hss.c            | 19 +++--
 drivers/net/wan/lmc/lmc.h               |  2 +-
 drivers/net/wan/lmc/lmc_main.c          | 10 +--
 drivers/net/wan/lmc/lmc_proto.c         |  7 --
 drivers/net/wan/lmc/lmc_proto.h         |  1 -
 drivers/net/wan/n2.c                    | 19 +++--
 drivers/net/wan/pc300too.c              | 29 ++++----
 drivers/net/wan/pci200syn.c             | 19 +++--
 drivers/net/wan/sealevel.c              | 10 +--
 drivers/net/wan/wanxl.c                 | 21 +++---
 drivers/tty/synclink_gt.c               | 19 +++--
 include/linux/hdlc.h                    |  4 +-
 include/linux/netdevice.h               |  2 +
 net/core/dev_ioctl.c                    | 20 +++++-
 28 files changed, 211 insertions(+), 258 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index f57f255f2397..3c42b0b0be93 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -222,6 +222,13 @@ ndo_do_ioctl:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
 
+ndo_siocwandev:
+	Synchronization: rtnl_lock() semaphore.
+	Context: process
+
+	Used by the drivers/net/wan framework to handle
+	the SIOCWANDEV ioctl with the if_settings structure.
+
 ndo_siocdevprivate:
 	Synchronization: rtnl_lock() semaphore.
 	Context: process
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 6eaefea0520e..5ac53dcb3a6a 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -4050,16 +4050,15 @@ static int hdlcdev_close(struct net_device *dev)
  * called by network layer to process IOCTL call to network device
  *
  * dev  pointer to network device structure
- * ifr  pointer to network interface request structure
- * cmd  IOCTL command code
+ * ifs  pointer to network interface settings structure
  *
  * returns 0 if success, otherwise error code
  */
-static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int hdlcdev_wan_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	MGSLPC_INFO *info = dev_to_port(dev);
 	unsigned int flags;
 
@@ -4070,17 +4069,14 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (info->port.count)
 		return -EBUSY;
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
 	memset(&new_line, 0, size);
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
-		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_SYNC_SERIAL;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 
@@ -4148,9 +4144,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			tty_kref_put(tty);
 		}
 		return 0;
-
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -4225,7 +4220,7 @@ static const struct net_device_ops hdlcdev_ops = {
 	.ndo_open       = hdlcdev_open,
 	.ndo_stop       = hdlcdev_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = hdlcdev_ioctl,
+	.ndo_siocwandev = hdlcdev_wan_ioctl,
 	.ndo_tx_timeout = hdlcdev_tx_timeout,
 };
 
diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index ca308230500d..8dd14d916c3a 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -228,21 +228,18 @@ static int c101_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int c101_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	port_t *port = dev_to_port(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_SYNC_SERIAL;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(line, &port->settings, size))
@@ -270,7 +267,7 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -295,7 +292,7 @@ static const struct net_device_ops c101_ops = {
 	.ndo_open       = c101_open,
 	.ndo_stop       = c101_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = c101_ioctl,
+	.ndo_siocwandev = c101_ioctl,
 	.ndo_siocdevprivate = c101_siocdevprivate,
 };
 
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 4c0e9cf02217..23d2954d9747 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -414,7 +414,7 @@ static const struct net_device_ops cosa_ops = {
 	.ndo_open       = cosa_net_open,
 	.ndo_stop       = cosa_net_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = hdlc_ioctl,
+	.ndo_siocwandev = hdlc_ioctl,
 	.ndo_tx_timeout = cosa_net_timeout,
 };
 
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index d0e3cab98645..6a212c085435 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1784,16 +1784,15 @@ gather_conf_info(struct fst_card_info *card, struct fst_port_info *port,
 
 static int
 fst_set_iface(struct fst_card_info *card, struct fst_port_info *port,
-	      struct ifreq *ifr)
+	      struct if_settings *ifs)
 {
 	sync_serial_settings sync;
 	int i;
 
-	if (ifr->ifr_settings.size != sizeof(sync))
+	if (ifs->size != sizeof(sync))
 		return -ENOMEM;
 
-	if (copy_from_user
-	    (&sync, ifr->ifr_settings.ifs_ifsu.sync, sizeof(sync)))
+	if (copy_from_user(&sync, ifs->ifs_ifsu.sync, sizeof(sync)))
 		return -EFAULT;
 
 	if (sync.loopback)
@@ -1801,7 +1800,7 @@ fst_set_iface(struct fst_card_info *card, struct fst_port_info *port,
 
 	i = port->index;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_IFACE_V35:
 		FST_WRW(card, portConfig[i].lineInterface, V35);
 		port->hwif = V35;
@@ -1857,7 +1856,7 @@ fst_set_iface(struct fst_card_info *card, struct fst_port_info *port,
 
 static int
 fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
-	      struct ifreq *ifr)
+	      struct if_settings *ifs)
 {
 	sync_serial_settings sync;
 	int i;
@@ -1868,29 +1867,29 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	 */
 	switch (port->hwif) {
 	case E1:
-		ifr->ifr_settings.type = IF_IFACE_E1;
+		ifs->type = IF_IFACE_E1;
 		break;
 	case T1:
-		ifr->ifr_settings.type = IF_IFACE_T1;
+		ifs->type = IF_IFACE_T1;
 		break;
 	case V35:
-		ifr->ifr_settings.type = IF_IFACE_V35;
+		ifs->type = IF_IFACE_V35;
 		break;
 	case V24:
-		ifr->ifr_settings.type = IF_IFACE_V24;
+		ifs->type = IF_IFACE_V24;
 		break;
 	case X21D:
-		ifr->ifr_settings.type = IF_IFACE_X21D;
+		ifs->type = IF_IFACE_X21D;
 		break;
 	case X21:
 	default:
-		ifr->ifr_settings.type = IF_IFACE_X21;
+		ifs->type = IF_IFACE_X21;
 		break;
 	}
-	if (ifr->ifr_settings.size == 0)
+	if (!ifs->size)
 		return 0;	/* only type requested */
 
-	if (ifr->ifr_settings.size < sizeof(sync))
+	if (ifs->size < sizeof(sync))
 		return -ENOMEM;
 
 	i = port->index;
@@ -1901,10 +1900,10 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	    INTCLK ? CLOCK_INT : CLOCK_EXT;
 	sync.loopback = 0;
 
-	if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &sync, sizeof(sync)))
+	if (copy_to_user(ifs->ifs_ifsu.sync, &sync, sizeof(sync)))
 		return -EFAULT;
 
-	ifr->ifr_settings.size = sizeof(sync);
+	ifs->size = sizeof(sync);
 	return 0;
 }
 
@@ -2020,12 +2019,12 @@ fst_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data,
 }
 
 static int
-fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+fst_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	struct fst_card_info *card;
 	struct fst_port_info *port;
 
-	dbg(DBG_IOCTL, "ioctl: %x, %x\n", cmd, ifr->ifr_settings.type);
+	dbg(DBG_IOCTL, "SIOCDEVPRIVATE, %x\n", ifs->type);
 
 	port = dev_to_port(dev);
 	card = port->card;
@@ -2033,42 +2032,35 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	switch (cmd) {
-	case SIOCWANDEV:
-		switch (ifr->ifr_settings.type) {
-		case IF_GET_IFACE:
-			return fst_get_iface(card, port, ifr);
-
-		case IF_IFACE_SYNC_SERIAL:
-		case IF_IFACE_V35:
-		case IF_IFACE_V24:
-		case IF_IFACE_X21:
-		case IF_IFACE_X21D:
-		case IF_IFACE_T1:
-		case IF_IFACE_E1:
-			return fst_set_iface(card, port, ifr);
-
-		case IF_PROTO_RAW:
-			port->mode = FST_RAW;
-			return 0;
+	switch (ifs->type) {
+	case IF_GET_IFACE:
+		return fst_get_iface(card, port, ifs);
 
-		case IF_GET_PROTO:
-			if (port->mode == FST_RAW) {
-				ifr->ifr_settings.type = IF_PROTO_RAW;
-				return 0;
-			}
-			return hdlc_ioctl(dev, ifr, cmd);
+	case IF_IFACE_SYNC_SERIAL:
+	case IF_IFACE_V35:
+	case IF_IFACE_V24:
+	case IF_IFACE_X21:
+	case IF_IFACE_X21D:
+	case IF_IFACE_T1:
+	case IF_IFACE_E1:
+		return fst_set_iface(card, port, ifs);
 
-		default:
-			port->mode = FST_GEN_HDLC;
-			dbg(DBG_IOCTL, "Passing this type to hdlc %x\n",
-			    ifr->ifr_settings.type);
-			return hdlc_ioctl(dev, ifr, cmd);
+	case IF_PROTO_RAW:
+		port->mode = FST_RAW;
+		return 0;
+
+	case IF_GET_PROTO:
+		if (port->mode == FST_RAW) {
+			ifs->type = IF_PROTO_RAW;
+			return 0;
 		}
+		return hdlc_ioctl(dev, ifs);
 
 	default:
-		/* Not one of ours. Pass through to HDLC package */
-		return hdlc_ioctl(dev, ifr, cmd);
+		port->mode = FST_GEN_HDLC;
+		dbg(DBG_IOCTL, "Passing this type to hdlc %x\n",
+		    ifs->type);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -2328,7 +2320,7 @@ static const struct net_device_ops fst_ops = {
 	.ndo_open       = fst_open,
 	.ndo_stop       = fst_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl	= fst_ioctl,
+	.ndo_siocwandev	= fst_ioctl,
 	.ndo_siocdevprivate = fst_siocdevprivate,
 	.ndo_tx_timeout = fst_tx_timeout,
 };
diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 39f05fabbfa4..cda1b4ce6b21 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -674,31 +674,28 @@ static irqreturn_t ucc_hdlc_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int uhdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int uhdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(te1_settings);
 	te1_settings line;
 	struct ucc_hdlc_private *priv = netdev_priv(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_E1;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_E1;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		memset(&line, 0, sizeof(line));
 		line.clock_type = priv->clocking;
 
-		if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &line, size))
+		if (copy_to_user(ifs->ifs_ifsu.sync, &line, size))
 			return -EFAULT;
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -1053,7 +1050,7 @@ static const struct net_device_ops uhdlc_ops = {
 	.ndo_open       = uhdlc_open,
 	.ndo_stop       = uhdlc_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = uhdlc_ioctl,
+	.ndo_siocwandev = uhdlc_ioctl,
 	.ndo_tx_timeout	= uhdlc_tx_timeout,
 };
 
diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index dd6312b69861..cbed10b1d862 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -196,16 +196,13 @@ void hdlc_close(struct net_device *dev)
 }
 EXPORT_SYMBOL(hdlc_close);
 
-int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+int hdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	struct hdlc_proto *proto = first_proto;
 	int result;
 
-	if (cmd != SIOCWANDEV)
-		return -EINVAL;
-
 	if (dev_to_hdlc(dev)->proto) {
-		result = dev_to_hdlc(dev)->proto->ioctl(dev, ifr);
+		result = dev_to_hdlc(dev)->proto->ioctl(dev, ifs);
 		if (result != -EINVAL)
 			return result;
 	}
@@ -213,7 +210,7 @@ int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	/* Not handled by currently attached protocol (if any) */
 
 	while (proto) {
-		result = proto->ioctl(dev, ifr);
+		result = proto->ioctl(dev, ifs);
 		if (result != -EINVAL)
 			return result;
 		proto = proto->next;
diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index c54fdae950fb..cdebe65a7e2d 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -56,7 +56,7 @@ struct cisco_state {
 	u32 rxseq; /* RX sequence number */
 };
 
-static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int cisco_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static inline struct cisco_state *state(hdlc_device *hdlc)
 {
@@ -306,21 +306,21 @@ static const struct header_ops cisco_header_ops = {
 	.create = cisco_hard_header,
 };
 
-static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int cisco_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
-	cisco_proto __user *cisco_s = ifr->ifr_settings.ifs_ifsu.cisco;
+	cisco_proto __user *cisco_s = ifs->ifs_ifsu.cisco;
 	const size_t size = sizeof(cisco_proto);
 	cisco_proto new_settings;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_CISCO;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_PROTO_CISCO;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(cisco_s, &state(hdlc)->settings, size))
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 2910ea25e51d..7637edce443e 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -146,7 +146,7 @@ struct frad_state {
 	u8 rxseq; /* RX sequence number */
 };
 
-static int fr_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int fr_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static inline u16 q922_to_dlci(u8 *hdr)
 {
@@ -357,29 +357,26 @@ static int pvc_close(struct net_device *dev)
 	return 0;
 }
 
-static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int pvc_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	struct pvc_device *pvc = dev->ml_priv;
 	fr_proto_pvc_info info;
 
-	if (cmd != SIOCWANDEV)
-		return -EOPNOTSUPP;
-
-	if (ifr->ifr_settings.type == IF_GET_PROTO) {
+	if (ifs->type == IF_GET_PROTO) {
 		if (dev->type == ARPHRD_ETHER)
-			ifr->ifr_settings.type = IF_PROTO_FR_ETH_PVC;
+			ifs->type = IF_PROTO_FR_ETH_PVC;
 		else
-			ifr->ifr_settings.type = IF_PROTO_FR_PVC;
+			ifs->type = IF_PROTO_FR_PVC;
 
-		if (ifr->ifr_settings.size < sizeof(info)) {
+		if (ifs->size < sizeof(info)) {
 			/* data size wanted */
-			ifr->ifr_settings.size = sizeof(info);
+			ifs->size = sizeof(info);
 			return -ENOBUFS;
 		}
 
 		info.dlci = pvc->dlci;
 		memcpy(info.master, pvc->frad->name, IFNAMSIZ);
-		if (copy_to_user(ifr->ifr_settings.ifs_ifsu.fr_pvc_info,
+		if (copy_to_user(ifs->ifs_ifsu.fr_pvc_info,
 				 &info, sizeof(info)))
 			return -EFAULT;
 		return 0;
@@ -1059,7 +1056,7 @@ static const struct net_device_ops pvc_ops = {
 	.ndo_open       = pvc_open,
 	.ndo_stop       = pvc_close,
 	.ndo_start_xmit = pvc_xmit,
-	.ndo_do_ioctl   = pvc_ioctl,
+	.ndo_siocwandev = pvc_ioctl,
 };
 
 static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
@@ -1182,22 +1179,22 @@ static struct hdlc_proto proto = {
 	.module		= THIS_MODULE,
 };
 
-static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int fr_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
-	fr_proto __user *fr_s = ifr->ifr_settings.ifs_ifsu.fr;
+	fr_proto __user *fr_s = ifs->ifs_ifsu.fr;
 	const size_t size = sizeof(fr_proto);
 	fr_proto new_settings;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	fr_proto_pvc pvc;
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto) /* Different proto */
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_FR;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_PROTO_FR;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(fr_s, &state(hdlc)->settings, size))
@@ -1259,21 +1256,21 @@ static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
-		if (copy_from_user(&pvc, ifr->ifr_settings.ifs_ifsu.fr_pvc,
+		if (copy_from_user(&pvc, ifs->ifs_ifsu.fr_pvc,
 				   sizeof(fr_proto_pvc)))
 			return -EFAULT;
 
 		if (pvc.dlci <= 0 || pvc.dlci >= 1024)
 			return -EINVAL;	/* Only 10 bits, DLCI 0 reserved */
 
-		if (ifr->ifr_settings.type == IF_PROTO_FR_ADD_ETH_PVC ||
-		    ifr->ifr_settings.type == IF_PROTO_FR_DEL_ETH_PVC)
+		if (ifs->type == IF_PROTO_FR_ADD_ETH_PVC ||
+		    ifs->type == IF_PROTO_FR_DEL_ETH_PVC)
 			result = ARPHRD_ETHER; /* bridged Ethernet device */
 		else
 			result = ARPHRD_DLCI;
 
-		if (ifr->ifr_settings.type == IF_PROTO_FR_ADD_PVC ||
-		    ifr->ifr_settings.type == IF_PROTO_FR_ADD_ETH_PVC)
+		if (ifs->type == IF_PROTO_FR_ADD_PVC ||
+		    ifs->type == IF_PROTO_FR_ADD_ETH_PVC)
 			return fr_add_pvc(dev, pvc.dlci, result);
 		else
 			return fr_del_pvc(hdlc, pvc.dlci, result);
diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index b81ecf432a0c..37a3c989cba1 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -100,7 +100,7 @@ static const char *const event_names[EVENTS] = {
 
 static struct sk_buff_head tx_queue; /* used when holding the spin lock */
 
-static int ppp_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int ppp_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static inline struct ppp *get_ppp(struct net_device *dev)
 {
@@ -655,17 +655,17 @@ static const struct header_ops ppp_header_ops = {
 	.create = ppp_hard_header,
 };
 
-static int ppp_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int ppp_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct ppp *ppp;
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_PPP;
+		ifs->type = IF_PROTO_PPP;
 		return 0; /* return protocol only, no settable parameters */
 
 	case IF_PROTO_PPP:
diff --git a/drivers/net/wan/hdlc_raw.c b/drivers/net/wan/hdlc_raw.c
index 54d28496fefd..4a2f068721bc 100644
--- a/drivers/net/wan/hdlc_raw.c
+++ b/drivers/net/wan/hdlc_raw.c
@@ -19,7 +19,7 @@
 #include <linux/skbuff.h>
 
 
-static int raw_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int raw_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static __be16 raw_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
@@ -33,21 +33,21 @@ static struct hdlc_proto proto = {
 };
 
 
-static int raw_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int raw_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
-	raw_hdlc_proto __user *raw_s = ifr->ifr_settings.ifs_ifsu.raw_hdlc;
+	raw_hdlc_proto __user *raw_s = ifs->ifs_ifsu.raw_hdlc;
 	const size_t size = sizeof(raw_hdlc_proto);
 	raw_hdlc_proto new_settings;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_HDLC;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_PROTO_HDLC;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(raw_s, hdlc->state, size))
diff --git a/drivers/net/wan/hdlc_raw_eth.c b/drivers/net/wan/hdlc_raw_eth.c
index 927596276a07..0a66b7356405 100644
--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -20,7 +20,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 
-static int raw_eth_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int raw_eth_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static netdev_tx_t eth_tx(struct sk_buff *skb, struct net_device *dev)
 {
@@ -48,22 +48,22 @@ static struct hdlc_proto proto = {
 };
 
 
-static int raw_eth_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int raw_eth_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
-	raw_hdlc_proto __user *raw_s = ifr->ifr_settings.ifs_ifsu.raw_hdlc;
+	raw_hdlc_proto __user *raw_s = ifs->ifs_ifsu.raw_hdlc;
 	const size_t size = sizeof(raw_hdlc_proto);
 	raw_hdlc_proto new_settings;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	unsigned int old_qlen;
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_HDLC_ETH;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_PROTO_HDLC_ETH;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(raw_s, hdlc->state, size))
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 9b7ebf8bd85c..f72c92c24003 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -29,7 +29,7 @@ struct x25_state {
 	struct tasklet_struct rx_tasklet;
 };
 
-static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
+static int x25_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 static struct x25_state *state(hdlc_device *hdlc)
 {
@@ -274,21 +274,21 @@ static struct hdlc_proto proto = {
 	.module		= THIS_MODULE,
 };
 
-static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
+static int x25_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
-	x25_hdlc_proto __user *x25_s = ifr->ifr_settings.ifs_ifsu.x25;
+	x25_hdlc_proto __user *x25_s = ifs->ifs_ifsu.x25;
 	const size_t size = sizeof(x25_hdlc_proto);
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	x25_hdlc_proto new_settings;
 	int result;
 
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_PROTO:
 		if (dev_to_hdlc(dev)->proto != &proto)
 			return -EINVAL;
-		ifr->ifr_settings.type = IF_PROTO_X25;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_PROTO_X25;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(x25_s, &state(hdlc)->settings, size))
@@ -303,7 +303,7 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return -EBUSY;
 
 		/* backward compatibility */
-		if (ifr->ifr_settings.size == 0) {
+		if (ifs->size == 0) {
 			new_settings.dce = 0;
 			new_settings.modulo = 8;
 			new_settings.window = 7;
diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index fd61a7cc4fdf..15a754310fd7 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -142,11 +142,6 @@ static int hostess_close(struct net_device *d)
 	return 0;
 }
 
-static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
-{
-	return hdlc_ioctl(d, ifr, cmd);
-}
-
 /*	Passed network frames, fire them downwind.
  */
 
@@ -171,7 +166,7 @@ static const struct net_device_ops hostess_ops = {
 	.ndo_open       = hostess_open,
 	.ndo_stop       = hostess_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = hostess_ioctl,
+	.ndo_siocwandev = hdlc_ioctl,
 };
 
 static struct z8530_dev *sv11_init(int iobase, int irq)
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 2cebbfca0bd1..88a36a069311 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1254,23 +1254,20 @@ static void find_best_clock(u32 timer_freq, u32 rate, u32 *best, u32 *reg)
 	}
 }
 
-static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int hss_hdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	struct port *port = dev_to_port(dev);
 	unsigned long flags;
 	int clk;
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_V35;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_V35;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		memset(&new_line, 0, sizeof(new_line));
@@ -1323,7 +1320,7 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -1335,7 +1332,7 @@ static const struct net_device_ops hss_hdlc_ops = {
 	.ndo_open       = hss_hdlc_open,
 	.ndo_stop       = hss_hdlc_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = hss_hdlc_ioctl,
+	.ndo_siocwandev = hss_hdlc_ioctl,
 };
 
 static int hss_init_one(struct platform_device *pdev)
diff --git a/drivers/net/wan/lmc/lmc.h b/drivers/net/wan/lmc/lmc.h
index 3bd541c868d5..d7d59b4595f9 100644
--- a/drivers/net/wan/lmc/lmc.h
+++ b/drivers/net/wan/lmc/lmc.h
@@ -19,7 +19,7 @@ void lmc_mii_writereg(lmc_softc_t * const, unsigned, unsigned, unsigned);
 void lmc_gpio_mkinput(lmc_softc_t * const sc, u32 bits);
 void lmc_gpio_mkoutput(lmc_softc_t * const sc, u32 bits);
 
-int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+int lmc_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 extern lmc_media_t lmc_ds3_media;
 extern lmc_media_t lmc_ssi_media;
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 26a4ffbff73b..ed687bf6ec47 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -616,14 +616,6 @@ static int lmc_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
     return ret;
 }
 
-int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	if (cmd != SIOCWANDEV)
-		return -EOPNOTSUPP;
-
-	return lmc_proto_ioctl(dev_to_sc(dev), ifr, cmd);
-}
-
 
 /* the watchdog process that cruises around */
 static void lmc_watchdog(struct timer_list *t) /*fold00*/
@@ -794,7 +786,7 @@ static const struct net_device_ops lmc_ops = {
 	.ndo_open       = lmc_open,
 	.ndo_stop       = lmc_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = lmc_ioctl,
+	.ndo_siocwandev = hdlc_ioctl,
 	.ndo_siocdevprivate = lmc_siocdevprivate,
 	.ndo_tx_timeout = lmc_driver_timeout,
 	.ndo_get_stats  = lmc_get_stats,
diff --git a/drivers/net/wan/lmc/lmc_proto.c b/drivers/net/wan/lmc/lmc_proto.c
index 4e9cc83b615a..e5487616a816 100644
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -58,13 +58,6 @@ void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
         }
 }
 
-int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd)
-{
-	if (sc->if_type == LMC_PPP)
-		return hdlc_ioctl(sc->lmc_device, ifr, cmd);
-	return -EOPNOTSUPP;
-}
-
 int lmc_proto_open(lmc_softc_t *sc)
 {
 	int ret = 0;
diff --git a/drivers/net/wan/lmc/lmc_proto.h b/drivers/net/wan/lmc/lmc_proto.h
index bb098e443776..e56e7072de44 100644
--- a/drivers/net/wan/lmc/lmc_proto.h
+++ b/drivers/net/wan/lmc/lmc_proto.h
@@ -5,7 +5,6 @@
 #include <linux/hdlc.h>
 
 void lmc_proto_attach(lmc_softc_t *sc);
-int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd);
 int lmc_proto_open(lmc_softc_t *sc);
 void lmc_proto_close(lmc_softc_t *sc);
 __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb);
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 4122ca2cd07d..f3e80722ba1d 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -239,21 +239,18 @@ static int n2_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int n2_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	port_t *port = dev_to_port(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_SYNC_SERIAL;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(line, &port->settings, size))
@@ -281,7 +278,7 @@ static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -317,7 +314,7 @@ static const struct net_device_ops n2_ops = {
 	.ndo_open       = n2_open,
 	.ndo_stop       = n2_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = n2_ioctl,
+	.ndo_siocwandev = n2_ioctl,
 	.ndo_siocdevprivate = n2_siocdevprivate,
 };
 
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 8cdfd0056c81..4766446f0fa0 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -186,21 +186,18 @@ static int pc300_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int pc300_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	int new_type;
 	port_t *port = dev_to_port(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	if (ifr->ifr_settings.type == IF_GET_IFACE) {
-		ifr->ifr_settings.type = port->iface;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+	if (ifs->type == IF_GET_IFACE) {
+		ifs->type = port->iface;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(line, &port->settings, size))
@@ -209,21 +206,21 @@ static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 
 	if (port->card->type == PC300_X21 &&
-	    (ifr->ifr_settings.type == IF_IFACE_SYNC_SERIAL ||
-	     ifr->ifr_settings.type == IF_IFACE_X21))
+	    (ifs->type == IF_IFACE_SYNC_SERIAL ||
+	     ifs->type == IF_IFACE_X21))
 		new_type = IF_IFACE_X21;
 
 	else if (port->card->type == PC300_RSV &&
-		 (ifr->ifr_settings.type == IF_IFACE_SYNC_SERIAL ||
-		  ifr->ifr_settings.type == IF_IFACE_V35))
+		 (ifs->type == IF_IFACE_SYNC_SERIAL ||
+		  ifs->type == IF_IFACE_V35))
 		new_type = IF_IFACE_V35;
 
 	else if (port->card->type == PC300_RSV &&
-		 ifr->ifr_settings.type == IF_IFACE_V24)
+		 ifs->type == IF_IFACE_V24)
 		new_type = IF_IFACE_V24;
 
 	else
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -278,7 +275,7 @@ static const struct net_device_ops pc300_ops = {
 	.ndo_open       = pc300_open,
 	.ndo_stop       = pc300_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = pc300_ioctl,
+	.ndo_siocwandev = pc300_ioctl,
 	.ndo_siocdevprivate = pc300_siocdevprivate,
 };
 
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index f4dc3dda25b7..ea86c7035653 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -179,21 +179,18 @@ static int pci200_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int pci200_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	port_t *port = dev_to_port(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_V35;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_V35;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		if (copy_to_user(line, &port->settings, size))
@@ -223,7 +220,7 @@ static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -259,7 +256,7 @@ static const struct net_device_ops pci200_ops = {
 	.ndo_open       = pci200_open,
 	.ndo_stop       = pci200_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = pci200_ioctl,
+	.ndo_siocwandev = pci200_ioctl,
 	.ndo_siocdevprivate = pci200_siocdevprivate,
 };
 
diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 4403e219ca03..eddd20aab691 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -124,14 +124,6 @@ static int sealevel_close(struct net_device *d)
 	return 0;
 }
 
-static int sealevel_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
-{
-	/* struct slvl_device *slvl=dev_to_chan(d);
-	 * z8530_ioctl(d,&slvl->sync.chanA,ifr,cmd)
-	 */
-	return hdlc_ioctl(d, ifr, cmd);
-}
-
 /*	Passed network frames, fire them downwind. */
 
 static netdev_tx_t sealevel_queue_xmit(struct sk_buff *skb,
@@ -152,7 +144,7 @@ static const struct net_device_ops sealevel_ops = {
 	.ndo_open       = sealevel_open,
 	.ndo_stop       = sealevel_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = sealevel_ioctl,
+	.ndo_siocwandev = hdlc_ioctl,
 };
 
 static int slvl_setup(struct slvl_device *sv, int iobase, int irq)
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index f22e48415e6f..5a9e262188ef 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -343,20 +343,17 @@ static int wanxl_attach(struct net_device *dev, unsigned short encoding,
 	return 0;
 }
 
-static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int wanxl_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings line;
 	struct port *port = dev_to_port(dev);
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
-	switch (ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE:
-		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_SYNC_SERIAL;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 		memset(&line, 0, sizeof(line));
@@ -364,7 +361,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		line.clock_rate = 0;
 		line.loopback = 0;
 
-		if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &line, size))
+		if (copy_to_user(ifs->ifs_ifsu.sync, &line, size))
 			return -EFAULT;
 		return 0;
 
@@ -374,7 +371,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 
-		if (copy_from_user(&line, ifr->ifr_settings.ifs_ifsu.sync,
+		if (copy_from_user(&line, ifs->ifs_ifsu.sync,
 				   size))
 			return -EFAULT;
 
@@ -389,7 +386,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -545,7 +542,7 @@ static const struct net_device_ops wanxl_ops = {
 	.ndo_open       = wanxl_open,
 	.ndo_stop       = wanxl_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = wanxl_ioctl,
+	.ndo_siocwandev = wanxl_ioctl,
 	.ndo_get_stats  = wanxl_get_stats,
 };
 
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 5bb928b7873e..3e3b8873fa29 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1524,11 +1524,11 @@ static int hdlcdev_close(struct net_device *dev)
  *
  * Return: 0 if success, otherwise error code
  */
-static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int hdlcdev_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
 	sync_serial_settings new_line;
-	sync_serial_settings __user *line = ifr->ifr_settings.ifs_ifsu.sync;
+	sync_serial_settings __user *line = ifs->ifs_ifsu.sync;
 	struct slgt_info *info = dev_to_port(dev);
 	unsigned int flags;
 
@@ -1538,17 +1538,14 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (info->port.count)
 		return -EBUSY;
 
-	if (cmd != SIOCWANDEV)
-		return hdlc_ioctl(dev, ifr, cmd);
-
 	memset(&new_line, 0, sizeof(new_line));
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifs->type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
-		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
-		if (ifr->ifr_settings.size < size) {
-			ifr->ifr_settings.size = size; /* data size wanted */
+		ifs->type = IF_IFACE_SYNC_SERIAL;
+		if (ifs->size < size) {
+			ifs->size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
 
@@ -1615,7 +1612,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	default:
-		return hdlc_ioctl(dev, ifr, cmd);
+		return hdlc_ioctl(dev, ifs);
 	}
 }
 
@@ -1688,7 +1685,7 @@ static const struct net_device_ops hdlcdev_ops = {
 	.ndo_open       = hdlcdev_open,
 	.ndo_stop       = hdlcdev_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = hdlcdev_ioctl,
+	.ndo_siocwandev = hdlcdev_ioctl,
 	.ndo_tx_timeout = hdlcdev_tx_timeout,
 };
 
diff --git a/include/linux/hdlc.h b/include/linux/hdlc.h
index cacc4dd27794..630a388035f1 100644
--- a/include/linux/hdlc.h
+++ b/include/linux/hdlc.h
@@ -22,7 +22,7 @@ struct hdlc_proto {
 	void (*start)(struct net_device *dev); /* if open & DCD */
 	void (*stop)(struct net_device *dev); /* if open & !DCD */
 	void (*detach)(struct net_device *dev);
-	int (*ioctl)(struct net_device *dev, struct ifreq *ifr);
+	int (*ioctl)(struct net_device *dev, struct if_settings *ifs);
 	__be16 (*type_trans)(struct sk_buff *skb, struct net_device *dev);
 	int (*netif_rx)(struct sk_buff *skb);
 	netdev_tx_t (*xmit)(struct sk_buff *skb, struct net_device *dev);
@@ -54,7 +54,7 @@ typedef struct hdlc_device {
 /* Exported from hdlc module */
 
 /* Called by hardware driver when a user requests HDLC service */
-int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+int hdlc_ioctl(struct net_device *dev, struct if_settings *ifs);
 
 /* Must be used by hardware driver on module startup/exit */
 #define register_hdlc_device(dev)	register_netdev(dev)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b6e062a3b0d4..cc11382f76a3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1367,6 +1367,8 @@ struct net_device_ops {
 					        struct ifreq *ifr, int cmd);
 	int			(*ndo_eth_ioctl)(struct net_device *dev,
 						 struct ifreq *ifr, int cmd);
+	int			(*ndo_siocwandev)(struct net_device *dev,
+						  struct if_settings *ifs);
 	int			(*ndo_siocdevprivate)(struct net_device *dev,
 						      struct ifreq *ifr,
 						      void __user *data, int cmd);
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 8e30fe8b5645..e0586bc4d6c6 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -291,6 +291,20 @@ static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	return dev_do_ioctl(dev, ifr, cmd);
 }
 
+static int dev_siocwandev(struct net_device *dev, struct if_settings *ifs)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (ops->ndo_siocwandev) {
+		if (netif_device_present(dev))
+			return ops->ndo_siocwandev(dev, ifs);
+		else
+			return -ENODEV;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
  */
@@ -359,6 +373,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		ifr->ifr_newname[IFNAMSIZ-1] = '\0';
 		return dev_change_name(dev, ifr->ifr_newname);
 
+	case SIOCWANDEV:
+		return dev_siocwandev(dev, &ifr->ifr_settings);
+
 	case SIOCSHWTSTAMP:
 		err = net_hwtstamp_validate(ifr);
 		if (err)
@@ -386,8 +403,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCBONDINFOQUERY ||
 		    cmd == SIOCBONDCHANGEACTIVE ||
 		    cmd == SIOCBRADDIF ||
-		    cmd == SIOCBRDELIF ||
-		    cmd == SIOCWANDEV) {
+		    cmd == SIOCBRDELIF) {
 			err = dev_do_ioctl(dev, ifr, cmd);
 		} else
 			err = -EINVAL;
-- 
2.29.2

