Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040B13134D7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhBHORn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:17:43 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57526 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbhBHOI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:08:28 -0500
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
Subject: [PATCH 19/20] net: stmmac: Move DMA stop procedure to HW-setup antagonist
Date:   Mon, 8 Feb 2021 17:03:40 +0300
Message-ID: <20210208140341.9271-20-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMA-channels enabling procedure is performed in the framework of the
the DW *MAC hardware setup method. For the sake of the driver code
coherency let's move the DMA-channels stop function invocation to the
HW-setup antagonist method - stmmac_hw_teardown(). The latter is called in
the stmmac_hw_setup() error path and in the network device release
callback. So by introducing this alteration we not only improve the code
readability, but also make the stmmac_hw_teardown() doing better the HW
cleanup work.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d6446aa712e1..3c03b773295a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2792,6 +2792,8 @@ static void stmmac_hw_teardown(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	stmmac_stop_all_dma(priv);
+
 	stmmac_release_ptp(priv);
 }
 
@@ -2970,9 +2972,6 @@ static int stmmac_release(struct net_device *dev)
 		del_timer_sync(&priv->eee_ctrl_timer);
 	}
 
-	/* Stop TX/RX DMA and clear the descriptors */
-	stmmac_stop_all_dma(priv);
-
 	/* Cleanup HW setup */
 	stmmac_hw_teardown(dev);
 
-- 
2.29.2

