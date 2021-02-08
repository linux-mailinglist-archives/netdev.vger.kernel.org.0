Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277DF3134CF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhBHOQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:16:57 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57454 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhBHOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:08:06 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/20] net: stmmac: Move PTP clock enabling to PTP-init method
Date:   Mon, 8 Feb 2021 17:03:39 +0300
Message-ID: <20210208140341.9271-19-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That clock is purely dedicated for the PTP feature of DW *MAC. From the
driver readability and maintainability point of the view it's better to
have it enabled/disable in the PTP interface init/release methods. Let's
do that by moving the clock prepare/enable procedure invocation to the
stmmac_init_ptp() method and adding the clock disable/unprepare function
call to stmmac_release_ptp(). Since the clock is now handled in the
framework of the PTP-interface related initializers/de-initializers we
need to call the stmmac_release_ptp() method in the HW-setup antagonist -
stmmac_hw_teardown(). Thus call the later one when the network device is
closed to clean the PTP-interface too.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f3ced94b3f4e..d6446aa712e1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -761,10 +761,18 @@ static int stmmac_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
 static int stmmac_init_ptp(struct stmmac_priv *priv)
 {
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	int ret;
 
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
+	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+	if (ret) {
+		netdev_warn(priv->dev, "failed to enable PTP ref-clock: %d\n",
+			    ret);
+		return ret;
+	}
+
 	priv->adv_ts = 0;
 	/* Check if adv_ts can be enabled for dwmac 4.x / xgmac core */
 	if (xmac && priv->dma_cap.atime_stamp)
@@ -790,8 +798,12 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 
 static void stmmac_release_ptp(struct stmmac_priv *priv)
 {
-	clk_disable_unprepare(priv->plat->clk_ptp_ref);
+	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
+		return;
+
 	stmmac_ptp_unregister(priv);
+
+	clk_disable_unprepare(priv->plat->clk_ptp_ref);
 }
 
 /**
@@ -2716,10 +2728,6 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	stmmac_mmc_setup(priv);
 
 	if (init_ptp) {
-		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-		if (ret < 0)
-			netdev_warn(priv->dev, "failed to enable PTP reference clock: %d\n", ret);
-
 		ret = stmmac_init_ptp(priv);
 		if (ret == -EOPNOTSUPP)
 			netdev_warn(priv->dev, "PTP not supported by HW\n");
@@ -2784,7 +2792,7 @@ static void stmmac_hw_teardown(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	clk_disable_unprepare(priv->plat->clk_ptp_ref);
+	stmmac_release_ptp(priv);
 }
 
 /**
@@ -2965,6 +2973,9 @@ static int stmmac_release(struct net_device *dev)
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
+	/* Cleanup HW setup */
+	stmmac_hw_teardown(dev);
+
 	/* Release and free the Rx/Tx resources */
 	free_dma_desc_resources(priv);
 
@@ -2973,8 +2984,6 @@ static int stmmac_release(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-	stmmac_release_ptp(priv);
-
 	return 0;
 }
 
-- 
2.29.2

