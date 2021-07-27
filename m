Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10DF3D7740
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhG0NrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236989AbhG0Nqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A10C61AA2;
        Tue, 27 Jul 2021 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393590;
        bh=yC1msifH8Lj6FuTjA7nV3iK5yZLMGuC/TX+RR2SaT6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNQSQSiSKTM4puO5uGTDEhbCFdFE73z/2Q5NRIOCXY17FouzNAnIs81ewPYbrqsPc
         BAB2Futu1QaTQ4bHi9W+uKD5GPQ3gUaMEJY3cNUGNkg+nIIzkxrOrilx6wfltDC+NX
         oHFBzPDTfhgiLP8pjRuPUiSPQkQD7ckmsul+GywZRKyirwLoifC3dPCmB/Iv7nLNqi
         hzJ7Q7/MT/QeR7ROGqtEA23qbkdwzDBscfi+y6d+y3F6HJMYoJzac+fGQiOA+Dj5eN
         leFUBBzwRXjVzqyHCncvY3Lqny5+bl7gSN8Z6wwZLSe2MSUT70j9rSW4ITtMMw8W7t
         FE218zgSs22Sg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Joerg Reuter <jreuter@yaina.de>,
        Jean-Paul Roubelat <jpr@f6fbb.org>, linux-hams@vger.kernel.org
Subject: [PATCH net-next v3 18/31] hamradio: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:04 +0200
Message-Id: <20210727134517.1384504-19-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: Joerg Reuter <jreuter@yaina.de>
Cc: Jean-Paul Roubelat <jpr@f6fbb.org>
Cc: linux-hams@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hamradio/baycom_epp.c     |  9 +++++----
 drivers/net/hamradio/baycom_par.c     | 12 ++++++------
 drivers/net/hamradio/baycom_ser_fdx.c | 12 ++++++------
 drivers/net/hamradio/baycom_ser_hdx.c | 12 ++++++------
 drivers/net/hamradio/bpqether.c       |  9 +++++----
 drivers/net/hamradio/dmascc.c         | 18 ++++++++----------
 drivers/net/hamradio/hdlcdrv.c        | 20 +++++++++++---------
 drivers/net/hamradio/scc.c            | 13 ++++++++-----
 drivers/net/hamradio/yam.c            | 19 +++++++++----------
 include/linux/hdlcdrv.h               |  2 +-
 10 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 4435a1195194..775dcf4ebde5 100644
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
index 0e623c2e8b2d..d967b0748773 100644
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
index c25c8c99c5c7..b50b7fafd8d6 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -225,7 +225,8 @@ static int read_scc_data(struct scc_priv *priv);
 
 static int scc_open(struct net_device *dev);
 static int scc_close(struct net_device *dev);
-static int scc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int scc_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, int cmd);
 static int scc_send_packet(struct sk_buff *skb, struct net_device *dev);
 static int scc_set_mac_address(struct net_device *dev, void *sa);
 
@@ -432,7 +433,7 @@ static const struct net_device_ops scc_netdev_ops = {
 	.ndo_open = scc_open,
 	.ndo_stop = scc_close,
 	.ndo_start_xmit = scc_send_packet,
-	.ndo_do_ioctl = scc_ioctl,
+	.ndo_siocdevprivate = scc_siocdevprivate,
 	.ndo_set_mac_address = scc_set_mac_address,
 };
 
@@ -881,15 +882,13 @@ static int scc_close(struct net_device *dev)
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
@@ -897,13 +896,12 @@ static int scc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
index cbaf1cdde7cb..5805cfc83854 100644
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
index 3f1edd0526a4..e0bb131a33d7 100644
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
index d4911041596c..6ddacbdb224b 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -920,15 +920,15 @@ static int yam_close(struct net_device *dev)
 
 /* --------------------------------------------------------------------- */
 
-static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	struct yam_port *yp = netdev_priv(dev);
 	struct yamdrv_ioctl_cfg yi;
 	struct yamdrv_ioctl_mcs *ym;
 	int ioctl_cmd;
 
-	if (copy_from_user(&ioctl_cmd, ifr->ifr_data, sizeof(int)))
-		 return -EFAULT;
+	if (copy_from_user(&ioctl_cmd, data, sizeof(int)))
+		return -EFAULT;
 
 	if (yp->magic != YAM_MAGIC)
 		return -EINVAL;
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
@@ -965,8 +964,8 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCYAMSCFG:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-		if (copy_from_user(&yi, ifr->ifr_data, sizeof(struct yamdrv_ioctl_cfg)))
-			 return -EFAULT;
+		if (copy_from_user(&yi, data, sizeof(struct yamdrv_ioctl_cfg)))
+			return -EFAULT;
 
 		if (yi.cmd != SIOCYAMSCFG)
 			return -EINVAL;
@@ -1045,8 +1044,8 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		yi.cfg.txtail = yp->txtail;
 		yi.cfg.persist = yp->pers;
 		yi.cfg.slottime = yp->slot;
-		if (copy_to_user(ifr->ifr_data, &yi, sizeof(struct yamdrv_ioctl_cfg)))
-			 return -EFAULT;
+		if (copy_to_user(data, &yi, sizeof(struct yamdrv_ioctl_cfg)))
+			return -EFAULT;
 		break;
 
 	default:
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
2.29.2

