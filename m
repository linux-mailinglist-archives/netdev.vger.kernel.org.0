Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2183134B5
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBHOMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:12:36 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57454 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhBHOFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:05:38 -0500
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
Subject: [PATCH 07/20] net: stmmac: Clear descriptors before initializing them
Date:   Mon, 8 Feb 2021 17:03:28 +0300
Message-ID: <20210208140341.9271-8-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the methods naming and partly based on their semantics the
descriptors need to be cleared first, then they can be properly
initialized. That specifically concerns the Tx descriptors and the chain
mode. Moreover doing the Rx-descriptors clearance twice is redundant. Fix
all of that by discarding the Rx descriptor clearance from the
init_dma_rx_desc_rings() method and move the generic method of all
descriptors clearance to the head of the init_dma_desc_rings() function.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1c40dc26fbf7..3bc07f5b64e1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1399,8 +1399,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 			  "(%s) dma_rx_phy=0x%08x\n", __func__,
 			  (u32)rx_q->dma_rx_phy);
 
-		stmmac_clear_rx_descriptors(priv, queue);
-
 		for (i = 0; i < priv->dma_rx_size; i++) {
 			struct dma_desc *p;
 
@@ -1522,14 +1520,14 @@ static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
+	stmmac_clear_descriptors(priv);
+
 	ret = init_dma_rx_desc_rings(dev, flags);
 	if (ret)
 		return ret;
 
 	ret = init_dma_tx_desc_rings(dev);
 
-	stmmac_clear_descriptors(priv);
-
 	if (netif_msg_hw(priv))
 		stmmac_display_rings(priv);
 
-- 
2.29.2

