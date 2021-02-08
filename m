Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51683134F3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBHOUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:20:53 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57754 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhBHOKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:01 -0500
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
Subject: [PATCH 03/16] net: stmmac: Introduce MAC core cleanup method
Date:   Mon, 8 Feb 2021 17:08:07 +0300
Message-ID: <20210208140820.10410-4-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some DW MAC IP-core configurations and hardware setups it might be
necessary not to reset the MAC while the device is probed and added to
the system for a subsequent use. For instance having the MAC synthesized
with GPIs and GPOs requires that, so the GPIOs state would be in a
coherent state while GPIO-chip is registered in the kernel.

Since for such configurations the reset is prohibited let's provide the
MAC core cleanup method to get the basic core registers back to the
initial state so further device initialization would work with the values
it has been designed to expect.

That method will be useful for devices with GPIOs support. For now we've
got a chip with DW GMAC IP and GPIOs synthesied, so the cleanup method is
added to the corresponding driver sub-module only.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 33 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  4 +++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 6b9a4f54b93c..2af4c8ac6fb7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -21,6 +21,38 @@
 #include "stmmac_pcs.h"
 #include "dwmac1000.h"
 
+static void dwmac1000_core_clean(void __iomem *ioaddr)
+{
+	int idx;
+
+	/* Clean the basic MAC registers up. Note the MAC interrupts are
+	 * enabled by default after reset. Let's mask them out so not to have
+	 * any spurious MAC-related IRQ generated during the cleanup
+	 * procedure.
+	 */
+	writel(0x7FF, ioaddr + GMAC_INT_MASK);
+	writel(0, ioaddr + GMAC_CONTROL);
+	writel(0, ioaddr + GMAC_FRAME_FILTER);
+	writel(0, ioaddr + GMAC_HASH_HIGH);
+	writel(0, ioaddr + GMAC_HASH_LOW);
+	writel(0, ioaddr + GMAC_FLOW_CTRL);
+	writel(0, ioaddr + GMAC_VLAN_TAG);
+	writel(0, ioaddr + GMAC_DEBUG);
+	writel(0x80000000, ioaddr + GMAC_PMT);
+	writel(0, ioaddr + LPI_CTRL_STATUS);
+	writel(0x03e80000, ioaddr + LPI_TIMER_CTRL);
+	for (idx = 0; idx < 15; ++idx) {
+		writel(0x0000ffff, ioaddr + GMAC_ADDR_HIGH(idx));
+		writel(0xffffffff, ioaddr + GMAC_ADDR_LOW(idx));
+	}
+	writel(0, ioaddr + GMAC_PCS_BASE);
+	writel(0, ioaddr + GMAC_RGSMIIIS);
+	writel(0x1, ioaddr + GMAC_MMC_CTRL);
+	readl(ioaddr + GMAC_INT_STATUS);
+	readl(ioaddr + GMAC_PMT);
+	readl(ioaddr + LPI_CTRL_STATUS);
+}
+
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
@@ -511,6 +543,7 @@ static void dwmac1000_set_mac_loopback(void __iomem *ioaddr, bool enable)
 }
 
 const struct stmmac_ops dwmac1000_ops = {
+	.core_clean = dwmac1000_core_clean,
 	.core_init = dwmac1000_core_init,
 	.set_mac = stmmac_set_mac,
 	.rx_ipc = dwmac1000_rx_ipc_enable,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index b40b2e0667bb..3f5eed8333a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -287,6 +287,8 @@ struct stmmac_est;
 
 /* Helpers to program the MAC core */
 struct stmmac_ops {
+	/* MAC core cleanup */
+	void (*core_clean)(void __iomem *ioaddr);
 	/* MAC core initialization */
 	void (*core_init)(struct mac_device_info *hw, struct net_device *dev);
 	/* Enable the MAC RX/TX */
@@ -396,6 +398,8 @@ struct stmmac_ops {
 			      bool enable);
 };
 
+#define stmmac_core_clean(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, core_clean, __args)
 #define stmmac_core_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, core_init, __args)
 #define stmmac_mac_set(__priv, __args...) \
-- 
2.29.2

