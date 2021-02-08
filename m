Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0731350C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBHOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:23:08 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57770 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhBHOKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:51 -0500
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
Subject: [PATCH 15/16] net: stmmac: Add DW GMAC GPIOs support
Date:   Mon, 8 Feb 2021 17:08:19 +0300
Message-ID: <20210208140820.10410-16-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synopsys DW GMAC can be synthesized with up to four GPIs and four GPOs
support, which in case if enabled can be configured via a MAC CSR 0xe0.
In order to have the DW GMAC GPIO interface supported in the STMMAC GPIO
driver we just need to define the GPIO configs accessors and GPI state
getter.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Folks, I don't know whether the same GPIO CSR layout is defined for some
other DW MAC IP-core. So for now the accessors have been created for
GMACs only. But if you are sure the callbacks can be used for some other
IP, I can move them to dwmac_lib.c. Though in order to have the GPIOs
working in the driver the MAC/DMA cleanup methods need to be also defined
for that IP-core version.
---
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   | 11 +++++
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 40 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  1 +
 4 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 919f5b55bc7d..7fa75e0a33bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -30,6 +30,7 @@
 #define GMAC_INT_STATUS_MMCCSUM	BIT(7)
 #define GMAC_INT_STATUS_TSTAMP	BIT(9)
 #define GMAC_INT_STATUS_LPIIS	BIT(10)
+#define GMAC_INT_STATUS_GPIIS	BIT(11)
 
 /* interrupt mask register */
 #define	GMAC_INT_MASK		0x0000003c
@@ -101,6 +102,16 @@ enum power_event {
 #define GMAC_RGSMIIIS_SPEED_25		0x1
 #define GMAC_RGSMIIIS_SPEED_2_5		0x0
 
+/* General Purpose IO register */
+#define GMAC_GPIO		0x000000e0	/* General Purpose IO */
+#define GMAC_GPIO_GPIS		GENMASK(3, 0)
+#define GMAC_GPIO_NGPIS		4
+#define GMAC_GPIO_GPO		GENMASK(11, 8)
+#define GMAC_GPIO_NGPOS		4
+#define GMAC_GPIO_GPIE		GENMASK(19, 16)
+#define GMAC_GPIO_GPIT		GENMASK(27, 24)
+#define GMAC_GPIO_NGPIOS	(GMAC_GPIO_NGPIS + GMAC_GPIO_NGPOS)
+
 /* GMAC Configuration defines */
 #define GMAC_CONTROL_2K 0x08000000	/* IEEE 802.3as 2K packets */
 #define GMAC_CONTROL_TC	0x01000000	/* Transmit Conf. in RGMII/SGMII */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 7dc8b254c15a..e2a4b746fde9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -12,6 +12,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/bitfield.h>
 #include <linux/crc32.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
@@ -577,6 +578,45 @@ const struct stmmac_ops dwmac1000_ops = {
 	.set_mac_loopback = dwmac1000_set_mac_loopback,
 };
 
+static void dwmac1000_gpio_set_ctrl(struct stmmac_priv *priv, u32 gpie,
+				    u32 gpit, u32 gpo)
+{
+	u32 val;
+
+	val = FIELD_PREP(GMAC_GPIO_GPO, gpo) |
+	      FIELD_PREP(GMAC_GPIO_GPIE, gpie) |
+	      FIELD_PREP(GMAC_GPIO_GPIT, gpit);
+
+	writel(val, priv->ioaddr + GMAC_GPIO);
+}
+
+static void dwmac1000_gpio_get_ctrl(struct stmmac_priv *priv, u32 *gpie,
+				    u32 *gpit, u32 *gpo)
+{
+	u32 val;
+
+	val = readl(priv->ioaddr + GMAC_GPIO);
+
+	*gpie = FIELD_GET(GMAC_GPIO_GPIE, val);
+	*gpit = FIELD_GET(GMAC_GPIO_GPIT, val);
+	*gpo = FIELD_GET(GMAC_GPIO_GPO, val);
+}
+
+static int dwmac1000_gpio_get_gpi(struct stmmac_priv *priv)
+{
+	u32 val;
+
+	val = readl(priv->ioaddr + GMAC_GPIO);
+
+	return FIELD_GET(GMAC_GPIO_GPIS, val);
+}
+
+const struct stmmac_gpio_ops dwmac1000_gpio_ops = {
+	.set_ctrl = dwmac1000_gpio_set_ctrl,
+	.get_ctrl = dwmac1000_gpio_get_ctrl,
+	.get_gpi = dwmac1000_gpio_get_gpi,
+};
+
 int dwmac1000_setup(struct stmmac_priv *priv)
 {
 	struct mac_device_info *mac = priv->hw;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 067420059c11..18aaa27801e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -140,6 +140,7 @@ static const struct stmmac_hwif_entry {
 		.mode = NULL,
 		.tc = NULL,
 		.mmc = &dwmac_mmc_ops,
+		.gpio = &dwmac1000_gpio_ops,
 		.setup = dwmac1000_setup,
 		.quirks = stmmac_dwmac1_quirks,
 	}, {
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 99c5841f1060..1aabdd96ea32 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -661,6 +661,7 @@ extern const struct stmmac_ops dwmac100_ops;
 extern const struct stmmac_dma_ops dwmac100_dma_ops;
 extern const struct stmmac_ops dwmac1000_ops;
 extern const struct stmmac_dma_ops dwmac1000_dma_ops;
+extern const struct stmmac_gpio_ops dwmac1000_gpio_ops;
 extern const struct stmmac_ops dwmac4_ops;
 extern const struct stmmac_dma_ops dwmac4_dma_ops;
 extern const struct stmmac_ops dwmac410_ops;
-- 
2.29.2

