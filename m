Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12E3D772E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhG0Nqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236805AbhG0NqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8621E61A8D;
        Tue, 27 Jul 2021 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393576;
        bh=dfFtRwhmshTCcPVwDZ2Z2pUhPD3m5IvZY+PMD6+ey7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvumA8EwQkekwtFpQy4p16tZw7UAFLngY2omlwB/UoBbVQzYizMk4dDqsTQdSyAEW
         gn8lHMrWDfO7TuWz32F+jCEdS+akXlmGH5QyVVm4k3bRk4Dop5r1xvt4gzBZ0jcDNC
         mIuTBqjZJ+8sC7k4WUA5gMjtSZaa1ZFV/Nn1QK5kMffxrM9HmTUYhzfnkPhxUCaX4L
         DfucGjj3wh+/eeZe8aAy6qhva4g3rLYEJCCmcpDIPjlDjzSBvMNnnRhALcVt00xPsR
         w5/RSrKMeTGNO8JCnoUbnGOzyQuOJx7U0SLxza/VkpU6p6qJAauP46lwpELtwbHzh0
         uDrFoKnyD9otw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 10/31] hamachi: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:56 +0200
Message-Id: <20210727134517.1384504-11-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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
index d058a63602a9..94823c5f7dff 100644
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
+	if (cmd != SIOCDEVPRIVATE + 3)
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
+	       (u32)readl(np->base + TxIntrCtrl),
+	       (u32)readl(np->base + RxIntrCtrl));
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
2.29.2

