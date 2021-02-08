Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189E83134E8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhBHOTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:19:21 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57518 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhBHOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:09:43 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/16] net: stmmac: Add STMMAC state getter
Date:   Mon, 8 Feb 2021 17:08:15 +0300
Message-ID: <20210208140820.10410-12-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the STMMAC driver has internal STMMAC_UP flag declared to indicate
the STMMAC network setup state, let's define the flag getter and use it in
the driver code to get the current NIC state. We can also convert the
netif_running() method invocation to calling the stmmac_is_up()
function instead because the latter gives more accurate notion of the
network state as the flag is set only after all the NIC initializations
are finished.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  4 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 34 +++++++++++++------
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index ab8b1e04ed22..c993dcd1c7d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -263,6 +263,7 @@ int stmmac_dvr_remove(struct device *dev);
 int stmmac_dvr_probe(struct device *device,
 		     struct plat_stmmacenet_data *plat_dat,
 		     struct stmmac_resources *res);
+bool stmmac_is_up(struct stmmac_priv *priv);
 void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 0ed287edbc2d..19debbd7f981 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -402,7 +402,9 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 static int stmmac_check_if_running(struct net_device *dev)
 {
-	if (!netif_running(dev))
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (!stmmac_is_up(priv))
 		return -EBUSY;
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f458d728825c..b37f49f3dc03 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2804,6 +2804,20 @@ static void stmmac_hw_teardown(struct net_device *dev)
 	stmmac_mac_set(priv, priv->ioaddr, false);
 }
 
+/**
+ * stmmac_is_up - test STMMAC state
+ *  @priv: driver private structure
+ *  Description:
+ *  Detects the current network adapter state just by testing the MAC
+ *  initialization completion flag.
+ *  Return value:
+ *  true if the STMMAC network is setup, false otherwise.
+ */
+bool stmmac_is_up(struct stmmac_priv *priv)
+{
+	return test_bit(STMMAC_UP, &priv->state);
+}
+
 /**
  *  stmmac_open - open entry point of the driver
  *  @dev : pointer to the device structure.
@@ -4046,7 +4060,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 
 	txfifosz /= priv->plat->tx_queues_to_use;
 
-	if (netif_running(dev)) {
+	if (stmmac_is_up(priv)) {
 		netdev_err(priv->dev, "must be stopped to change its MTU\n");
 		return -EBUSY;
 	}
@@ -4217,7 +4231,7 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 		pm_wakeup_event(priv->device, 0);
 
 	/* Check if adapter is up */
-	if (!test_bit(STMMAC_UP, &priv->state))
+	if (!stmmac_is_up(priv))
 		return IRQ_HANDLED;
 	/* Check if a fatal error happened */
 	if (stmmac_safety_feat_interrupt(priv))
@@ -4290,7 +4304,7 @@ static int stmmac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	struct stmmac_priv *priv = netdev_priv (dev);
 	int ret = -EOPNOTSUPP;
 
-	if (!netif_running(dev))
+	if (!stmmac_is_up(priv))
 		return -EINVAL;
 
 	switch (cmd) {
@@ -4743,7 +4757,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
 {
-	if (!test_bit(STMMAC_UP, &priv->state))
+	if (!stmmac_is_up(priv))
 		return;
 
 	netdev_err(priv->dev, "Reset adapter.\n");
@@ -4915,7 +4929,7 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = 0;
 
-	if (netif_running(dev))
+	if (stmmac_is_up(priv))
 		stmmac_release(dev);
 
 	stmmac_napi_del(dev);
@@ -4925,7 +4939,7 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	stmmac_napi_add(dev);
 
-	if (netif_running(dev))
+	if (stmmac_is_up(priv))
 		ret = stmmac_open(dev);
 
 	return ret;
@@ -4936,13 +4950,13 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = 0;
 
-	if (netif_running(dev))
+	if (stmmac_is_up(priv))
 		stmmac_release(dev);
 
 	priv->dma_rx_size = rx_size;
 	priv->dma_tx_size = tx_size;
 
-	if (netif_running(dev))
+	if (stmmac_is_up(priv))
 		ret = stmmac_open(dev);
 
 	return ret;
@@ -5253,7 +5267,7 @@ int stmmac_suspend(struct device *dev)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
 
-	if (!ndev || !netif_running(ndev))
+	if (!stmmac_is_up(priv))
 		return 0;
 
 	phylink_mac_change(priv->phylink, false);
@@ -5343,7 +5357,7 @@ int stmmac_resume(struct device *dev)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	if (!netif_running(ndev))
+	if (!stmmac_is_up(priv))
 		return 0;
 
 	/* Power Down bit, into the PM register, is cleared
-- 
2.29.2

