Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30DF2AA042
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgKFWVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgKFWSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:35 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C48121D7F;
        Fri,  6 Nov 2020 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701114;
        bh=AjIS9Fwp+9zwOieexErSSkVefl0S4aqIyIhbjJBo8ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbeSOZuoctGdFTTctZYTPX/FZjuaNYEXLdm25I7crH1V5VQZOVT0UApSiH/I5+cwP
         t7VZxDeNGE7nZoOrCDqGufbZQlQCAgH5NLZroopgIQ8g/RH2lVRa8Mh+NPVk/qh+Eq
         nczzE6xnkVg8lqpFXIG6tp/IDPcrq7vgbV6Sme/E=
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
Subject: [RFC net-next 14/28] fddi: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:29 +0100
Message-Id: <20201106221743.3271965-15-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The skfddi driver has a private ioctl and passes the data correctly
through ifr_data, but the use of a pointer in s_skfp_ioctl is
broken in compat mode.

Change the driver to use ndo_siocdevprivate and disallow calling
it in compat mode until a conversion handler is added.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/fddi/skfp/skfddi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index 69c29a2ef95d..fe3b1d041142 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -103,7 +103,8 @@ static struct net_device_stats *skfp_ctl_get_stats(struct net_device *dev);
 static void skfp_ctl_set_multicast_list(struct net_device *dev);
 static void skfp_ctl_set_multicast_list_wo_lock(struct net_device *dev);
 static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr);
-static int skfp_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int skfp_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			       void __user *data, int cmd);
 static netdev_tx_t skfp_send_pkt(struct sk_buff *skb,
 				       struct net_device *dev);
 static void send_queued_packets(struct s_smc *smc);
@@ -164,7 +165,7 @@ static const struct net_device_ops skfp_netdev_ops = {
 	.ndo_get_stats		= skfp_ctl_get_stats,
 	.ndo_set_rx_mode	= skfp_ctl_set_multicast_list,
 	.ndo_set_mac_address	= skfp_ctl_set_mac_address,
-	.ndo_do_ioctl		= skfp_ioctl,
+	.ndo_siocdevprivate	= skfp_siocdevprivate,
 };
 
 /*
@@ -932,9 +933,9 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
 
 
 /*
- * ==============
- * = skfp_ioctl =
- * ==============
+ * =======================
+ * = skfp_siocdevprivate =
+ * =======================
  *   
  * Overview:
  *
@@ -954,16 +955,19 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
  */
 
 
-static int skfp_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int skfp_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
 {
 	struct s_smc *smc = netdev_priv(dev);
 	skfddi_priv *lp = &smc->os;
 	struct s_skfp_ioctl ioc;
 	int status = 0;
 
-	if (copy_from_user(&ioc, rq->ifr_data, sizeof(struct s_skfp_ioctl)))
+	if (copy_from_user(&ioc, data, sizeof(struct s_skfp_ioctl)))
 		return -EFAULT;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
 	switch (ioc.cmd) {
 	case SKFP_GET_STATS:	/* Get the driver statistics */
 		ioc.len = sizeof(lp->MacStat);
-- 
2.27.0

