Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741B3D7737
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbhG0Nqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236956AbhG0NqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB9B61A8E;
        Tue, 27 Jul 2021 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393584;
        bh=9/u5Ur/k/uSU/NAsBfy4KiRP2e5RCOOh3IVfmej+eLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfoR//PgnnE0VfW3ObpfiXWaGJyNlsD5+0d2P8UppK4gOWS0B2b1vp0A2ZBectQ7y
         T0tgQs5wY91isXSNPW5deKbt8gGJ1ahvFOxOvwZQTfIjUxsEQ5OaeMi5XtYQyxjb7B
         q52Ncdhn1x7+zMDH1AUXX3cO2MaHX5jGcdEE18K8oIQCz75d0DR9aQmXiDoajPQOok
         2zSAly7Qw/hl4clmwZg7GababKJCSEFoEmXoCKJNc0hrQIbEdadJMQwue9luJmJrSE
         DjVCqNsHZAIgX6LCeNVVyTMWfxrYKTu9HWj1elChA2Qop0mz+bgQPrjyyGx43RxeAD
         gCva/TamvWJSQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 15/31] slip/plip: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:01 +0200
Message-Id: <20210727134517.1384504-16-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

slip and plip both use a couple of SIOCDEVPRIVATE ioctl
commands that overload the ifreq layout in a way that is
incompatible with compat mode.

Convert to use ndo_siocdevprivate to allow passing the
data this way, but return an error in compat mode anyway
because the private structure is still incompatible.

This could be fixed as well to make compat work properly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/plip/plip.c | 12 +++++++++---
 drivers/net/slip/slip.c | 13 +++++++++----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index e26cf91bdec2..82d609401711 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -84,6 +84,7 @@ static const char version[] = "NET3 PLIP version 2.4-parport gniibe@mri.co.jp\n"
     extra grounds are 18,19,20,21,22,23,24
 */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -150,7 +151,8 @@ static int plip_hard_header_cache(const struct neighbour *neigh,
                                   struct hh_cache *hh, __be16 type);
 static int plip_open(struct net_device *dev);
 static int plip_close(struct net_device *dev);
-static int plip_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int plip_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			       void __user *data, int cmd);
 static int plip_preempt(void *handle);
 static void plip_wakeup(void *handle);
 
@@ -265,7 +267,7 @@ static const struct net_device_ops plip_netdev_ops = {
 	.ndo_open		 = plip_open,
 	.ndo_stop		 = plip_close,
 	.ndo_start_xmit		 = plip_tx_packet,
-	.ndo_do_ioctl		 = plip_ioctl,
+	.ndo_siocdevprivate	 = plip_siocdevprivate,
 	.ndo_set_mac_address	 = eth_mac_addr,
 	.ndo_validate_addr	 = eth_validate_addr,
 };
@@ -1207,7 +1209,8 @@ plip_wakeup(void *handle)
 }
 
 static int
-plip_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+plip_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+		    void __user *data, int cmd)
 {
 	struct net_local *nl = netdev_priv(dev);
 	struct plipconf *pc = (struct plipconf *) &rq->ifr_ifru;
@@ -1215,6 +1218,9 @@ plip_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (cmd != SIOCDEVPLIP)
 		return -EOPNOTSUPP;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
 	switch(pc->pcmd) {
 	case PLIP_GET_TIMEOUT:
 		pc->trigger = nl->trigger;
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index dc84cb844319..5435b5689ce6 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -62,6 +62,7 @@
  */
 
 #define SL_CHECK_TRANSMIT
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
@@ -108,7 +109,7 @@ static void slip_unesc6(struct slip *sl, unsigned char c);
 #ifdef CONFIG_SLIP_SMART
 static void sl_keepalive(struct timer_list *t);
 static void sl_outfill(struct timer_list *t);
-static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int sl_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd);
 #endif
 
 /********************************
@@ -647,7 +648,7 @@ static const struct net_device_ops sl_netdev_ops = {
 	.ndo_change_mtu		= sl_change_mtu,
 	.ndo_tx_timeout		= sl_tx_timeout,
 #ifdef CONFIG_SLIP_SMART
-	.ndo_do_ioctl		= sl_ioctl,
+	.ndo_siocdevprivate	= sl_siocdevprivate,
 #endif
 };
 
@@ -1179,11 +1180,12 @@ static int slip_ioctl(struct tty_struct *tty, struct file *file,
 
 /* VSV changes start here */
 #ifdef CONFIG_SLIP_SMART
-/* function do_ioctl called from net/core/dev.c
+/* function sl_siocdevprivate called from net/core/dev.c
    to allow get/set outfill/keepalive parameter
    by ifconfig                                 */
 
-static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int sl_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			     void __user *data, int cmd)
 {
 	struct slip *sl = netdev_priv(dev);
 	unsigned long *p = (unsigned long *)&rq->ifr_ifru;
@@ -1191,6 +1193,9 @@ static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (sl == NULL)		/* Allocation failed ?? */
 		return -ENODEV;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
 	spin_lock_bh(&sl->lock);
 
 	if (!sl->tty) {
-- 
2.29.2

