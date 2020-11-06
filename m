Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD22AA01F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgKFWU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgKFWSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:41 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4279221FA;
        Fri,  6 Nov 2020 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701120;
        bh=awbN9CmiMFAq4njlBqIGiDvsLBx2twLKtUCtr3HCw4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7mtGk+pApVs4ypVk9owXbqjNJG0M+CrnJZF7aB5pr5dyVtA//dmy9AX2kurHq0jR
         Zj+o16Z+C2uNU4CYV8GrjLj02Vu5p4lgb+CsJDwrR2XA6Eg1+2mD4KqFv9Qy+HlR4A
         W1UEItjRNVD8T9TqRFmDvRT1tihlspjBHtihjsFw=
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
Subject: [RFC net-next 16/28] slip/plip: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:31 +0100
Message-Id: <20201106221743.3271965-17-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
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
 drivers/net/plip/plip.c | 11 ++++++++---
 drivers/net/slip/slip.c | 12 ++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 4406b353123e..771027461783 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -150,7 +150,8 @@ static int plip_hard_header_cache(const struct neighbour *neigh,
                                   struct hh_cache *hh, __be16 type);
 static int plip_open(struct net_device *dev);
 static int plip_close(struct net_device *dev);
-static int plip_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int plip_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			       void __user *data, int cmd);
 static int plip_preempt(void *handle);
 static void plip_wakeup(void *handle);
 
@@ -265,7 +266,7 @@ static const struct net_device_ops plip_netdev_ops = {
 	.ndo_open		 = plip_open,
 	.ndo_stop		 = plip_close,
 	.ndo_start_xmit		 = plip_tx_packet,
-	.ndo_do_ioctl		 = plip_ioctl,
+	.ndo_siocdevprivate	 = plip_siocdevprivate,
 	.ndo_set_mac_address	 = eth_mac_addr,
 	.ndo_validate_addr	 = eth_validate_addr,
 };
@@ -1205,7 +1206,8 @@ plip_wakeup(void *handle)
 }
 
 static int
-plip_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+plip_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+		    void __user *data, int cmd)
 {
 	struct net_local *nl = netdev_priv(dev);
 	struct plipconf *pc = (struct plipconf *) &rq->ifr_ifru;
@@ -1213,6 +1215,9 @@ plip_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (cmd != SIOCDEVPLIP)
 		return -EOPNOTSUPP;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
 	switch(pc->pcmd) {
 	case PLIP_GET_TIMEOUT:
 		pc->trigger = nl->trigger;
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index f81fb0b13a94..ecf89c5d7b5b 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -108,7 +108,7 @@ static void slip_unesc6(struct slip *sl, unsigned char c);
 #ifdef CONFIG_SLIP_SMART
 static void sl_keepalive(struct timer_list *t);
 static void sl_outfill(struct timer_list *t);
-static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int sl_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd);
 #endif
 
 /********************************
@@ -647,7 +647,7 @@ static const struct net_device_ops sl_netdev_ops = {
 	.ndo_change_mtu		= sl_change_mtu,
 	.ndo_tx_timeout		= sl_tx_timeout,
 #ifdef CONFIG_SLIP_SMART
-	.ndo_do_ioctl		= sl_ioctl,
+	.ndo_siocdevprivate	= sl_siocdevprivate,
 #endif
 };
 
@@ -1179,11 +1179,12 @@ static int slip_ioctl(struct tty_struct *tty, struct file *file,
 
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
@@ -1191,6 +1192,9 @@ static int sl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (sl == NULL)		/* Allocation failed ?? */
 		return -ENODEV;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
 	spin_lock_bh(&sl->lock);
 
 	if (!sl->tty) {
-- 
2.27.0

