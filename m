Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927782A9FDB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgKFWSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgKFWS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:27 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFC121556;
        Fri,  6 Nov 2020 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701106;
        bh=zfW+TstbaETCjrecVXCK2p+9uJMUmc8aN3NLStSQrjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+NDqiGAoaCCJhFts1rR200TkCd/gvtVzXpkBVmN5w7aYl97WcN+0oY3wBoZqBqGW
         3F0gisLN/XVWNo8Xk4PtuyDrHuXyTQndBIFv0SmwZq2zOKLIPxKyo15BnVOPBRB8Oh
         Dln9WnKUO8/Ivp5n2dSR3tdfIYmdp0Ds4CprnUqc=
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
Subject: [RFC net-next 11/28] hamachi: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:26 +0100
Message-Id: <20201106221743.3271965-12-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

hamachi has one command that overloads the ifreq argument
and requires a conversion to ndo_siocdevprivate in order to
make compat mode work, so split it from ndo_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/packetengines/hamachi.c | 63 ++++++++++++--------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index d058a63602a9..f6980fac8407 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -546,7 +546,9 @@ static int read_eeprom(void __iomem *ioaddr, int location);
 static int mdio_read(struct net_device *dev, int phy_id, int location);
 static void mdio_write(struct net_device *dev, int phy_id, int location, int value);
 static int hamachi_open(struct net_device *dev);
-static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int hamachi_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int hamachi_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+				  void __user *data, int cmd);
 static void hamachi_timer(struct timer_list *t);
 static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void hamachi_init_ring(struct net_device *dev);
@@ -571,7 +573,8 @@ static const struct net_device_ops hamachi_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_tx_timeout		= hamachi_tx_timeout,
-	.ndo_do_ioctl		= netdev_ioctl,
+	.ndo_do_ioctl		= hamachi_ioctl,
+	.ndo_siocdevprivate	= hamachi_siocdevprivate,
 };
 
 
@@ -1867,7 +1870,36 @@ static const struct ethtool_ops ethtool_ops_no_mii = {
 	.get_drvinfo = hamachi_get_drvinfo,
 };
 
-static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+/* private ioctl: set rx,tx intr params */
+static int hamachi_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+				  void __user *data, int cmd)
+{
+	struct hamachi_private *np = netdev_priv(dev);
+	u32 *d = (u32 *)&rq->ifr_ifru;
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (cmd != SIOCDEVPRIVATE+3)
+		return -EOPNOTSUPP;
+
+	/* Should add this check here or an ordinary user can do nasty
+	 * things. -KDU
+	 *
+	 * TODO: Shut down the Rx and Tx engines while doing this.
+	 */
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+	writel(d[0], np->base + TxIntrCtrl);
+	writel(d[1], np->base + RxIntrCtrl);
+	printk(KERN_NOTICE "%s: tx %08x, rx %08x intr\n", dev->name,
+		(u32) readl(np->base + TxIntrCtrl),
+		(u32) readl(np->base + RxIntrCtrl));
+
+	return 0;
+}
+
+static int hamachi_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct hamachi_private *np = netdev_priv(dev);
 	struct mii_ioctl_data *data = if_mii(rq);
@@ -1876,28 +1908,9 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	if (cmd == (SIOCDEVPRIVATE+3)) { /* set rx,tx intr params */
-		u32 *d = (u32 *)&rq->ifr_ifru;
-		/* Should add this check here or an ordinary user can do nasty
-		 * things. -KDU
-		 *
-		 * TODO: Shut down the Rx and Tx engines while doing this.
-		 */
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		writel(d[0], np->base + TxIntrCtrl);
-		writel(d[1], np->base + RxIntrCtrl);
-		printk(KERN_NOTICE "%s: tx %08x, rx %08x intr\n", dev->name,
-		  (u32) readl(np->base + TxIntrCtrl),
-		  (u32) readl(np->base + RxIntrCtrl));
-		rc = 0;
-	}
-
-	else {
-		spin_lock_irq(&np->lock);
-		rc = generic_mii_ioctl(&np->mii_if, data, cmd, NULL);
-		spin_unlock_irq(&np->lock);
-	}
+	spin_lock_irq(&np->lock);
+	rc = generic_mii_ioctl(&np->mii_if, data, cmd, NULL);
+	spin_unlock_irq(&np->lock);
 
 	return rc;
 }
-- 
2.27.0

