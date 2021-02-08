Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7880313507
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhBHOWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:22:40 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57764 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBHOKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:11 -0500
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
Subject: [PATCH 12/16] net: stmmac: Introduce NIC software reset function
Date:   Mon, 8 Feb 2021 17:08:16 +0300
Message-ID: <20210208140820.10410-13-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we are about to move the IRQs handler setup into the device probe
method, the DW MAC reset procedure needs to be redefined to be performed
with care. We must make sure the IRQs handler isn't executed while the
reset is proceeded and the IRQs are fully masked after that. The later is
required for some early versions of DW GMAC (in our case it's DW GMAC
v3.73a).

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b37f49f3dc03..c4c41b554c6a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1827,6 +1827,34 @@ static void free_dma_desc_resources(struct stmmac_priv *priv)
 	free_dma_tx_desc_resources(priv);
 }
 
+/**
+ *  stmmac_sw_reset - reset the MAC/DMA/etc state
+ *  @priv: driver private structure
+ *  Description: Cleanup/reset the DW *MAC registers to their initial state.
+ */
+static int stmmac_sw_reset(struct stmmac_priv *priv)
+{
+	int ret;
+
+	/* Disable the IRQ signal while the reset is in progress so not to
+	 * interfere with what the main ISR is doing.
+	 */
+	disable_irq(priv->dev->irq);
+
+	ret = stmmac_reset(priv, priv->ioaddr);
+
+	/* Make sure all IRQs are disabled by default. Some DW MAC IP-cores
+	 * like early versions of DW GMAC have MAC and MMC interrupts enabled
+	 * after reset.
+	 */
+	if (!ret)
+		stmmac_disable_irq(priv);
+
+	enable_irq(priv->dev->irq);
+
+	return ret;
+}
+
 /**
  *  stmmac_mac_enable_rx_queues - Enable MAC rx queues
  *  @priv: driver private structure
@@ -2340,9 +2368,9 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 	if (priv->extend_desc && (priv->mode == STMMAC_RING_MODE))
 		atds = 1;
 
-	ret = stmmac_reset(priv, priv->ioaddr);
+	ret = stmmac_sw_reset(priv);
 	if (ret) {
-		dev_err(priv->device, "Failed to reset the dma\n");
+		dev_err(priv->device, "Failed to reset the core\n");
 		return ret;
 	}
 
-- 
2.29.2

