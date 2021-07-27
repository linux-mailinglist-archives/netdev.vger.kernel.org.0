Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6833D773E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhG0Nq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236921AbhG0NqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C17E619F5;
        Tue, 27 Jul 2021 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393581;
        bh=H8eqYHK1w5Ld8XXi/hfeOdbBK38zaikB8TdAR920Syk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmUHuTj4wS31s9ZiwscusBpmW1kRhgIg+10vd6u2G4dwp8MaRN+sfKjSLnND0Hkgn
         Di5b0trM7Ti02tFs1kUA8JljDAZlGw5dpoUY6hrcwTLlFc3Fd0wVUeL+Mc5XI/kG30
         xIN70yQO2ZpTgb2O3qvs2EhdrOF7y4xJGztxDSf7JuXR3znCde2Xw/V3LTG8t0Gfgy
         StQhEyMOSwpHquVBnc0Iw6JRHLFeYbeOTNQ7F3RD7TU3KUgXF0QarCnES8R41m93+2
         VZ1+48eyD1aBc6IKTLaoKOa4luK8+rA/npW4LJm66+FgcDxD9OKeCbP/6LAa5xOzhU
         QPAf2lmUgHV5Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH net-next v3 13/31] fddi: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:59 +0200
Message-Id: <20210727134517.1384504-14-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/fddi/skfp/skfddi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index 69c29a2ef95d..f62e98fada1a 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -70,6 +70,7 @@ static const char * const boot_msg =
 /* Include files */
 
 #include <linux/capability.h>
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -103,7 +104,8 @@ static struct net_device_stats *skfp_ctl_get_stats(struct net_device *dev);
 static void skfp_ctl_set_multicast_list(struct net_device *dev);
 static void skfp_ctl_set_multicast_list_wo_lock(struct net_device *dev);
 static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr);
-static int skfp_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int skfp_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			       void __user *data, int cmd);
 static netdev_tx_t skfp_send_pkt(struct sk_buff *skb,
 				       struct net_device *dev);
 static void send_queued_packets(struct s_smc *smc);
@@ -164,7 +166,7 @@ static const struct net_device_ops skfp_netdev_ops = {
 	.ndo_get_stats		= skfp_ctl_get_stats,
 	.ndo_set_rx_mode	= skfp_ctl_set_multicast_list,
 	.ndo_set_mac_address	= skfp_ctl_set_mac_address,
-	.ndo_do_ioctl		= skfp_ioctl,
+	.ndo_siocdevprivate	= skfp_siocdevprivate,
 };
 
 /*
@@ -932,9 +934,9 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
 
 
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
@@ -954,16 +956,19 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
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
2.29.2

