Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60439105A3B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfKUTPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:15:50 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59726 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKUTPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:15:50 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 58C4D20062C;
        Thu, 21 Nov 2019 20:15:48 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 499FC20062B;
        Thu, 21 Nov 2019 20:15:48 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 13FFF203C8;
        Thu, 21 Nov 2019 20:15:48 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-eth: do not hold rtnl_lock on phylink_create() or _destroy()
Date:   Thu, 21 Nov 2019 21:15:25 +0200
Message-Id: <1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtnl_lock should not be held when calling phylink_create() or
phylink_destroy() since it leads to the deadlock listed below:

[   18.656576]  rtnl_lock+0x18/0x20
[   18.659798]  sfp_bus_add_upstream+0x28/0x90
[   18.663974]  phylink_create+0x2cc/0x828
[   18.667803]  dpaa2_mac_connect+0x14c/0x2a8
[   18.671890]  dpaa2_eth_connect_mac+0x94/0xd8

Fix this by moving the _lock() and _unlock() calls just outside of
phylink_of_phy_connect() and phylink_disconnect_phy().

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7ff147e89426..40290fea9e36 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3431,12 +3431,10 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 		set_mac_addr(netdev_priv(net_dev));
 		update_tx_fqids(priv);
 
-		rtnl_lock();
 		if (priv->mac)
 			dpaa2_eth_disconnect_mac(priv);
 		else
 			dpaa2_eth_connect_mac(priv);
-		rtnl_unlock();
 	}
 
 	return IRQ_HANDLED;
@@ -3675,9 +3673,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
-	rtnl_lock();
 	dpaa2_eth_disconnect_mac(priv);
-	rtnl_unlock();
 
 	unregister_netdev(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 84233e467ed1..0200308d1bc7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -277,7 +277,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
+	rtnl_lock();
 	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	rtnl_unlock();
 	if (err) {
 		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
@@ -301,7 +303,9 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 	if (!mac->phylink)
 		return;
 
+	rtnl_lock();
 	phylink_disconnect_phy(mac->phylink);
+	rtnl_unlock();
 	phylink_destroy(mac->phylink);
 	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
 }
-- 
1.9.1

