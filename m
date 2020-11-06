Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF762A9FEC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgKFWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgKFWS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:58 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30538221F8;
        Fri,  6 Nov 2020 22:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701137;
        bh=seQyPg/UXirLn5UDyR4QGuqE/EaE7wnQkLvV23VTy/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fvaG8eHtqDhlWuLYn5Jw4JHSBqRDPVhgexXPIftkIcR4fphfVJqN1q58Rtl6q2di
         nivWSGJhlLfnR67yHeMnODWtaOEcwh6W5e4bFk15kwBxaLV0LtXZNaLdaTVARqv9tE
         oH1rSPZl4F7ZjijKE05cPOyUOcCE3o0K/guDu+UM=
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
Subject: [RFC net-next 22/28] hamradio: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:37 +0100
Message-Id: <20201106221743.3271965-23-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

hamradio uses a set of private ioctls that do seem to work
correctly in compat mode, as they only rely on the ifr_data
pointer.

Move them over to the ndo_siocdevprivate callback as a cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hamradio/baycom_epp.c     |  9 +++++----
 drivers/net/hamradio/baycom_par.c     | 12 ++++++------
 drivers/net/hamradio/baycom_ser_fdx.c | 12 ++++++------
 drivers/net/hamradio/baycom_ser_hdx.c | 12 ++++++------
 drivers/net/hamradio/bpqether.c       |  9 +++++----
 drivers/net/hamradio/dmascc.c         | 17 +++++++----------
 drivers/net/hamradio/hdlcdrv.c        | 20 +++++++++++---------
 drivers/net/hamradio/scc.c            | 13 ++++++++-----
 drivers/net/hamradio/yam.c            | 13 ++++++-------
 include/linux/hdlcdrv.h               |  2 +-
 10 files changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index e4e4981ac1d2..bc045f358128 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -1005,7 +1005,8 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int baycom_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				 void __user *data, int cmd)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 	struct hdlcdrv_ioctl hi;
@@ -1013,7 +1014,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCDEVPRIVATE)
 		return -ENOIOCTLCMD;
 
-	if (copy_from_user(&hi, ifr->ifr_data, sizeof(hi)))
+	if (copy_from_user(&hi, data, sizeof(hi)))
 		return -EFAULT;
 	switch (hi.cmd) {
 	default:
@@ -1104,7 +1105,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return HDLCDRV_PARMASK_IOBASE;
 
 	}
-	if (copy_to_user(ifr->ifr_data, &hi, sizeof(hi)))
+	if (copy_to_user(data, &hi, sizeof(hi)))
 		return -EFAULT;
 	return 0;
 }
@@ -1114,7 +1115,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static const struct net_device_ops baycom_netdev_ops = {
 	.ndo_open	     = epp_open,
 	.ndo_stop	     = epp_close,
-	.ndo_do_ioctl	     = baycom_ioctl,
+	.ndo_siocdevprivate  = baycom_siocdevprivate,
 	.ndo_start_xmit      = baycom_send_packet,
 	.ndo_set_mac_address = baycom_set_mac_address,
 };
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 6a3dc7b3f28a..fd7da5bb1fa5 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -380,7 +380,7 @@ static int par96_close(struct net_device *dev)
  * ===================== hdlcdrv driver interface =========================
  */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd);
 
 /* --------------------------------------------------------------------- */
@@ -408,7 +408,7 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd)
 {
 	struct baycom_state *bc;
@@ -428,7 +428,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	case HDLCDRVCTL_GETMODE:
 		strcpy(hi->data.modename, bc->options ? "par96" : "picpar");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -440,7 +440,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	case HDLCDRVCTL_MODELIST:
 		strcpy(hi->data.modename, "par96,picpar");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -449,7 +449,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	}
 
-	if (copy_from_user(&bi, ifr->ifr_data, sizeof(bi)))
+	if (copy_from_user(&bi, data, sizeof(bi)))
 		return -EFAULT;
 	switch (bi.cmd) {
 	default:
@@ -464,7 +464,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 #endif /* BAYCOM_DEBUG */
 
 	}
-	if (copy_to_user(ifr->ifr_data, &bi, sizeof(bi)))
+	if (copy_to_user(data, &bi, sizeof(bi)))
 		return -EFAULT;
 	return 0;
 
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 04bb409707fc..646f605e358f 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -462,7 +462,7 @@ static int ser12_close(struct net_device *dev)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd);
 
 /* --------------------------------------------------------------------- */
@@ -497,7 +497,7 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd)
 {
 	struct baycom_state *bc;
@@ -519,7 +519,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 		sprintf(hi->data.modename, "ser%u", bc->baud / 100);
 		if (bc->opt_dcd <= 0)
 			strcat(hi->data.modename, (!bc->opt_dcd) ? "*" : "+");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -531,7 +531,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	case HDLCDRVCTL_MODELIST:
 		strcpy(hi->data.modename, "ser12,ser3,ser24");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -540,7 +540,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	}
 
-	if (copy_from_user(&bi, ifr->ifr_data, sizeof(bi)))
+	if (copy_from_user(&bi, data, sizeof(bi)))
 		return -EFAULT;
 	switch (bi.cmd) {
 	default:
@@ -555,7 +555,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 #endif /* BAYCOM_DEBUG */
 
 	}
-	if (copy_to_user(ifr->ifr_data, &bi, sizeof(bi)))
+	if (copy_to_user(data, &bi, sizeof(bi)))
 		return -EFAULT;
 	return 0;
 
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index a1acb3a47bdb..5d1ab4840753 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -521,7 +521,7 @@ static int ser12_close(struct net_device *dev)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd);
 
 /* --------------------------------------------------------------------- */
@@ -551,7 +551,7 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 
 /* --------------------------------------------------------------------- */
 
-static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
+static int baycom_ioctl(struct net_device *dev, void __user *data,
 			struct hdlcdrv_ioctl *hi, int cmd)
 {
 	struct baycom_state *bc;
@@ -573,7 +573,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 		strcpy(hi->data.modename, "ser12");
 		if (bc->opt_dcd <= 0)
 			strcat(hi->data.modename, (!bc->opt_dcd) ? "*" : (bc->opt_dcd == -2) ? "@" : "+");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -585,7 +585,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	case HDLCDRVCTL_MODELIST:
 		strcpy(hi->data.modename, "ser12");
-		if (copy_to_user(ifr->ifr_data, hi, sizeof(struct hdlcdrv_ioctl)))
+		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
 
@@ -594,7 +594,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	}
 
-	if (copy_from_user(&bi, ifr->ifr_data, sizeof(bi)))
+	if (copy_from_user(&bi, data, sizeof(bi)))
 		return -EFAULT;
 	switch (bi.cmd) {
 	default:
@@ -609,7 +609,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 #endif /* BAYCOM_DEBUG */
 
 	}
-	if (copy_to_user(ifr->ifr_data, &bi, sizeof(bi)))
+	if (copy_to_user(data, &bi, sizeof(bi)))
 		return -EFAULT;
 	return 0;
 
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 1ad6085994b1..d648e2fb5ae3 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -314,9 +314,10 @@ static int bpq_set_mac_address(struct net_device *dev, void *addr)
  *					source ethernet address (broadcast
  *					or multicast: accept all)
  */
-static int bpq_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, int cmd)
 {
-	struct bpq_ethaddr __user *ethaddr = ifr->ifr_data;
+	struct bpq_ethaddr __user *ethaddr = data;
 	struct bpqdev *bpq = netdev_priv(dev);
 	struct bpq_req req;
 
@@ -325,7 +326,7 @@ static int bpq_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	switch (cmd) {
 		case SIOCSBPQETHOPT:
-			if (copy_from_user(&req, ifr->ifr_data, sizeof(struct bpq_req)))
+			if (copy_from_user(&req, data, sizeof(struct bpq_req)))
 				return -EFAULT;
 			switch (req.cmd) {
 				case SIOCGBPQETHPARAM:
@@ -448,7 +449,7 @@ static const struct net_device_ops bpq_netdev_ops = {
 	.ndo_stop	     = bpq_close,
 	.ndo_start_xmit	     = bpq_xmit,
 	.ndo_set_mac_address = bpq_set_mac_address,
-	.ndo_do_ioctl	     = bpq_ioctl,
+	.ndo_siocdevprivate  = bpq_siocdevprivate,
 };
 
 static void bpq_setup(struct net_device *dev)
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index c25c8c99c5c7..5227db7a757e 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -225,7 +225,7 @@ static int read_scc_data(struct scc_priv *priv);
 
 static int scc_open(struct net_device *dev);
 static int scc_close(struct net_device *dev);
-static int scc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int scc_siocdevprivate(struct net_device *dev, struct ifreq *ifr, int cmd);
 static int scc_send_packet(struct sk_buff *skb, struct net_device *dev);
 static int scc_set_mac_address(struct net_device *dev, void *sa);
 
@@ -432,7 +432,7 @@ static const struct net_device_ops scc_netdev_ops = {
 	.ndo_open = scc_open,
 	.ndo_stop = scc_close,
 	.ndo_start_xmit = scc_send_packet,
-	.ndo_do_ioctl = scc_ioctl,
+	.ndo_siocdevprivate = scc_siocdevprivate,
 	.ndo_set_mac_address = scc_set_mac_address,
 };
 
@@ -881,15 +881,13 @@ static int scc_close(struct net_device *dev)
 }
 
 
-static int scc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int scc_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct scc_priv *priv = dev->ml_priv;
 
 	switch (cmd) {
 	case SIOCGSCCPARAM:
-		if (copy_to_user
-		    (ifr->ifr_data, &priv->param,
-		     sizeof(struct scc_param)))
+		if (copy_to_user(data, &priv->param, sizeof(struct scc_param)))
 			return -EFAULT;
 		return 0;
 	case SIOCSSCCPARAM:
@@ -897,13 +895,12 @@ static int scc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			return -EPERM;
 		if (netif_running(dev))
 			return -EAGAIN;
-		if (copy_from_user
-		    (&priv->param, ifr->ifr_data,
-		     sizeof(struct scc_param)))
+		if (copy_from_user(&priv->param, data,
+				   sizeof(struct scc_param)))
 			return -EFAULT;
 		return 0;
 	default:
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 }
 
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index e7413a643929..0311980f9d5f 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -483,23 +483,25 @@ static int hdlcdrv_close(struct net_device *dev)
 
 /* --------------------------------------------------------------------- */
 
-static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int hdlcdrv_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				  void __user *data, int cmd)
 {
 	struct hdlcdrv_state *s = netdev_priv(dev);
 	struct hdlcdrv_ioctl bi;
 
-	if (cmd != SIOCDEVPRIVATE) {
-		if (s->ops && s->ops->ioctl)
-			return s->ops->ioctl(dev, ifr, &bi, cmd);
+	if (cmd != SIOCDEVPRIVATE)
 		return -ENOIOCTLCMD;
-	}
-	if (copy_from_user(&bi, ifr->ifr_data, sizeof(bi)))
+
+	if (in_compat_syscall()) /* to be implemented */
+		return -ENOIOCTLCMD;
+
+	if (copy_from_user(&bi, data, sizeof(bi)))
 		return -EFAULT;
 
 	switch (bi.cmd) {
 	default:
 		if (s->ops && s->ops->ioctl)
-			return s->ops->ioctl(dev, ifr, &bi, cmd);
+			return s->ops->ioctl(dev, data, &bi, cmd);
 		return -ENOIOCTLCMD;
 
 	case HDLCDRVCTL_GETCHANNELPAR:
@@ -605,7 +607,7 @@ static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 		
 	}
-	if (copy_to_user(ifr->ifr_data, &bi, sizeof(bi)))
+	if (copy_to_user(data, &bi, sizeof(bi)))
 		return -EFAULT;
 	return 0;
 
@@ -617,7 +619,7 @@ static const struct net_device_ops hdlcdrv_netdev = {
 	.ndo_open	= hdlcdrv_open,
 	.ndo_stop	= hdlcdrv_close,
 	.ndo_start_xmit = hdlcdrv_send_packet,
-	.ndo_do_ioctl	= hdlcdrv_ioctl,
+	.ndo_siocdevprivate  = hdlcdrv_siocdevprivate,
 	.ndo_set_mac_address = hdlcdrv_set_mac_address,
 };
 
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 36eeb80406f2..abc086de2af4 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -210,7 +210,8 @@ static int scc_net_close(struct net_device *dev);
 static void scc_net_rx(struct scc_channel *scc, struct sk_buff *skb);
 static netdev_tx_t scc_net_tx(struct sk_buff *skb,
 			      struct net_device *dev);
-static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int scc_net_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				  void __user *data, int cmd);
 static int scc_net_set_mac_address(struct net_device *dev, void *addr);
 static struct net_device_stats * scc_net_get_stats(struct net_device *dev);
 
@@ -1550,7 +1551,7 @@ static const struct net_device_ops scc_netdev_ops = {
 	.ndo_start_xmit	     = scc_net_tx,
 	.ndo_set_mac_address = scc_net_set_mac_address,
 	.ndo_get_stats       = scc_net_get_stats,
-	.ndo_do_ioctl        = scc_net_ioctl,
+	.ndo_siocdevprivate  = scc_net_siocdevprivate,
 };
 
 /* ----> Initialize device <----- */
@@ -1703,7 +1704,8 @@ static netdev_tx_t scc_net_tx(struct sk_buff *skb, struct net_device *dev)
  * SIOCSCCCAL		- send calib. pattern	arg: (struct scc_calibrate *) arg
  */
 
-static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int scc_net_siocdevprivate(struct net_device *dev,
+				  struct ifreq *ifr, void __user *arg, int cmd)
 {
 	struct scc_kiss_cmd kiss_cmd;
 	struct scc_mem_config memcfg;
@@ -1712,8 +1714,6 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct scc_channel *scc = (struct scc_channel *) dev->ml_priv;
 	int chan;
 	unsigned char device_name[IFNAMSIZ];
-	void __user *arg = ifr->ifr_data;
-	
 	
 	if (!Driver_Initialized)
 	{
@@ -1722,6 +1722,9 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			int found = 1;
 
 			if (!capable(CAP_SYS_RAWIO)) return -EPERM;
+			if (in_compat_syscall())
+				return -EOPNOTSUPP;
+
 			if (!arg) return -EFAULT;
 
 			if (Nchips >= SCC_MAXCHIPS) 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5ab53e9942f3..fa86ceaa28db 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -920,14 +920,14 @@ static int yam_close(struct net_device *dev)
 
 /* --------------------------------------------------------------------- */
 
-static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct yam_port *yp = netdev_priv(dev);
 	struct yamdrv_ioctl_cfg yi;
 	struct yamdrv_ioctl_mcs *ym;
 	int ioctl_cmd;
 
-	if (copy_from_user(&ioctl_cmd, ifr->ifr_data, sizeof(int)))
+	if (copy_from_user(&ioctl_cmd, data, sizeof(int)))
 		 return -EFAULT;
 
 	if (yp->magic != YAM_MAGIC)
@@ -947,8 +947,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCYAMSMCS:
 		if (netif_running(dev))
 			return -EINVAL;		/* Cannot change this parameter when up */
-		ym = memdup_user(ifr->ifr_data,
-				 sizeof(struct yamdrv_ioctl_mcs));
+		ym = memdup_user(data, sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
 		if (ym->cmd != SIOCYAMSMCS)
@@ -965,7 +964,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCYAMSCFG:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-		if (copy_from_user(&yi, ifr->ifr_data, sizeof(struct yamdrv_ioctl_cfg)))
+		if (copy_from_user(&yi, data, sizeof(struct yamdrv_ioctl_cfg)))
 			 return -EFAULT;
 
 		if (yi.cmd != SIOCYAMSCFG)
@@ -1045,7 +1044,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		yi.cfg.txtail = yp->txtail;
 		yi.cfg.persist = yp->pers;
 		yi.cfg.slottime = yp->slot;
-		if (copy_to_user(ifr->ifr_data, &yi, sizeof(struct yamdrv_ioctl_cfg)))
+		if (copy_to_user(data, &yi, sizeof(struct yamdrv_ioctl_cfg)))
 			 return -EFAULT;
 		break;
 
@@ -1074,7 +1073,7 @@ static const struct net_device_ops yam_netdev_ops = {
 	.ndo_open	     = yam_open,
 	.ndo_stop	     = yam_close,
 	.ndo_start_xmit      = yam_send_packet,
-	.ndo_do_ioctl 	     = yam_ioctl,
+	.ndo_siocdevprivate  = yam_siocdevprivate,
 	.ndo_set_mac_address = yam_set_mac_address,
 };
 
diff --git a/include/linux/hdlcdrv.h b/include/linux/hdlcdrv.h
index d4d633a49d36..5d70c3f98f5b 100644
--- a/include/linux/hdlcdrv.h
+++ b/include/linux/hdlcdrv.h
@@ -79,7 +79,7 @@ struct hdlcdrv_ops {
 	 */
 	int (*open)(struct net_device *);
 	int (*close)(struct net_device *);
-	int (*ioctl)(struct net_device *, struct ifreq *, 
+	int (*ioctl)(struct net_device *, void __user *,
 		     struct hdlcdrv_ioctl *, int);
 };
 
-- 
2.27.0

