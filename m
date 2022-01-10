Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8011048A087
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245060AbiAJTzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:55:05 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:56060 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243733AbiAJTzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:55:00 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 40192209A558
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Qiang Yu <yuq825@gmail.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        "Gustavo Pimentel" <gustavo.pimentel@synopsys.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mark Brown <broonie@kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>,
        Roger Quadros <rogerq@kernel.org>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <dri-devel@lists.freedesktop.org>, <lima@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [PATCH 2/2] platform: make platform_get_irq_byname_optional() optional
Date:   Mon, 10 Jan 2022 22:54:49 +0300
Message-ID: <20220110195449.12448-3-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20220110195449.12448-1-s.shtylyov@omp.ru>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently platform_get_irq_byname_optional() returns an error code even
if IRQ resource simply has not been found. It prevents the callers from
being error code agnostic in their error handling:

	ret = platform_get_irq_byname_optional(...);
	if (ret < 0 && ret != -ENXIO)
		return ret; // respect deferred probe
	if (ret > 0)
		...we get an IRQ...

All other *_optional() APIs seem to return 0 or NULL in case an optional
resource is not available. Let's follow this good example, so that the
callers would look like:

	ret = platform_get_irq_byname_optional(...);
	if (ret < 0)
		return ret;
	if (ret > 0)
		...we get an IRQ...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 drivers/base/platform.c                             | 13 ++++++++++---
 drivers/gpu/drm/lima/lima_device.c                  |  2 +-
 drivers/mailbox/tegra-hsp.c                         |  4 ++--
 drivers/net/can/rcar/rcar_canfd.c                   |  4 ++--
 drivers/net/dsa/b53/b53_srab.c                      |  2 +-
 drivers/net/ethernet/freescale/fec_main.c           |  2 +-
 drivers/net/ethernet/freescale/fec_ptp.c            |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c   |  4 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c   |  4 ++--
 drivers/pci/controller/dwc/pcie-designware-host.c   |  2 +-
 drivers/spi/spi-bcm-qspi.c                          |  2 +-
 drivers/spi/spi-rspi.c                              |  8 ++++----
 drivers/usb/cdns3/cdns3-plat.c                      |  5 +----
 drivers/usb/host/xhci-mtk.c                         |  2 +-
 drivers/usb/mtu3/mtu3_core.c                        |  2 +-
 15 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 7c7b3638f02d..1d0ea635922b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -495,14 +495,21 @@ EXPORT_SYMBOL_GPL(platform_get_irq_byname);
  * @name: IRQ name
  *
  * Get an optional IRQ by name like platform_get_irq_byname(). Except that it
- * does not print an error message if an IRQ can not be obtained.
+ * does not print an error message if an IRQ can not be obtained and returns
+ * 0 when IRQ resource has not been found.
  *
- * Return: non-zero IRQ number on success, negative error number on failure.
+ * Return: non-zero IRQ number on success, 0 if IRQ wasn't found, negative error
+ * number on failure.
  */
 int platform_get_irq_byname_optional(struct platform_device *dev,
 				     const char *name)
 {
-	return __platform_get_irq_byname(dev, name);
+	int ret;
+
+	ret = __platform_get_irq_byname(dev, name);
+	if (ret == -ENXIO)
+		return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_get_irq_byname_optional);
 
diff --git a/drivers/gpu/drm/lima/lima_device.c b/drivers/gpu/drm/lima/lima_device.c
index 65fdca366e41..e3659aa687c2 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -223,7 +223,7 @@ static int lima_init_ip(struct lima_device *dev, int index)
 	if (irq_name) {
 		err = must ? platform_get_irq_byname(pdev, irq_name) :
 			     platform_get_irq_byname_optional(pdev, irq_name);
-		if (err < 0)
+		if (err <= 0)
 			goto out;
 		ip->irq = err;
 	}
diff --git a/drivers/mailbox/tegra-hsp.c b/drivers/mailbox/tegra-hsp.c
index acd0675da681..17aa88e31445 100644
--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -667,7 +667,7 @@ static int tegra_hsp_probe(struct platform_device *pdev)
 	hsp->num_si = (value >> HSP_nSI_SHIFT) & HSP_nINT_MASK;
 
 	err = platform_get_irq_byname_optional(pdev, "doorbell");
-	if (err >= 0)
+	if (err > 0)
 		hsp->doorbell_irq = err;
 
 	if (hsp->num_si > 0) {
@@ -687,7 +687,7 @@ static int tegra_hsp_probe(struct platform_device *pdev)
 				return -ENOMEM;
 
 			err = platform_get_irq_byname_optional(pdev, name);
-			if (err >= 0) {
+			if (err > 0) {
 				hsp->shared_irqs[i] = err;
 				count++;
 			}
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ff9d0f5ae0dd..1d4794493c6a 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1778,7 +1778,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 
 	if (chip_id == RENESAS_RCAR_GEN3) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
-		if (ch_irq < 0) {
+		if (ch_irq <= 0) {
 			/* For backward compatibility get irq by index */
 			ch_irq = platform_get_irq(pdev, 0);
 			if (ch_irq < 0)
@@ -1786,7 +1786,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		}
 
 		g_irq = platform_get_irq_byname_optional(pdev, "g_int");
-		if (g_irq < 0) {
+		if (g_irq <= 0) {
 			/* For backward compatibility get irq by index */
 			g_irq = platform_get_irq(pdev, 1);
 			if (g_irq < 0)
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 4591bb1c05d2..80b7c8f053ad 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -420,7 +420,7 @@ static int b53_srab_irq_enable(struct b53_device *dev, int port)
 	/* Interrupt is optional and was not specified, do not make
 	 * this fatal
 	 */
-	if (p->irq == -ENXIO)
+	if (!p->irq)
 		return ret;
 
 	ret = request_threaded_irq(p->irq, b53_srab_port_isr,
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bc418b910999..fba36d09a6e0 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3933,7 +3933,7 @@ fec_probe(struct platform_device *pdev)
 	for (i = 0; i < irq_cnt; i++) {
 		snprintf(irq_name, sizeof(irq_name), "int%d", i);
 		irq = platform_get_irq_byname_optional(pdev, irq_name);
-		if (irq < 0)
+		if (irq <= 0)
 			irq = platform_get_irq(pdev, i);
 		if (irq < 0) {
 			ret = irq;
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 158676eda48d..251863c2d5a4 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -615,7 +615,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
 
 	irq = platform_get_irq_byname_optional(pdev, "pps");
-	if (irq < 0)
+	if (irq <= 0)
 		irq = platform_get_irq_optional(pdev, irq_idx);
 	/* Failure to get an irq is not fatal,
 	 * only the PTP_CLOCK_PPS clock events should stop
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 2b38a499a404..5519b5b35365 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -342,7 +342,7 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 	if (dwmac->irq_pwr_wakeup == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
-	if (!dwmac->clk_eth_ck && dwmac->irq_pwr_wakeup >= 0) {
+	if (!dwmac->clk_eth_ck && dwmac->irq_pwr_wakeup > 0) {
 		err = device_init_wakeup(&pdev->dev, true);
 		if (err) {
 			dev_err(&pdev->dev, "Failed to init wake up irq\n");
@@ -426,7 +426,7 @@ static int stm32_dwmac_remove(struct platform_device *pdev)
 
 	stm32_dwmac_clk_disable(priv->plat->bsp_priv);
 
-	if (dwmac->irq_pwr_wakeup >= 0) {
+	if (dwmac->irq_pwr_wakeup > 0) {
 		dev_pm_clear_wake_irq(&pdev->dev);
 		device_init_wakeup(&pdev->dev, false);
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 232ac98943cd..dcfc04f7bfd4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -679,7 +679,7 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	 */
 	stmmac_res->wol_irq =
 		platform_get_irq_byname_optional(pdev, "eth_wake_irq");
-	if (stmmac_res->wol_irq < 0) {
+	if (stmmac_res->wol_irq <= 0) {
 		if (stmmac_res->wol_irq == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 		dev_info(&pdev->dev, "IRQ eth_wake_irq not found\n");
@@ -688,7 +688,7 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 
 	stmmac_res->lpi_irq =
 		platform_get_irq_byname_optional(pdev, "eth_lpi");
-	if (stmmac_res->lpi_irq < 0) {
+	if (stmmac_res->lpi_irq <= 0) {
 		if (stmmac_res->lpi_irq == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 		dev_info(&pdev->dev, "IRQ eth_lpi not found\n");
diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index f4755f3a03be..00e1a33fd06d 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -364,7 +364,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 		} else if (pp->has_msi_ctrl) {
 			if (!pp->msi_irq) {
 				pp->msi_irq = platform_get_irq_byname_optional(pdev, "msi");
-				if (pp->msi_irq < 0) {
+				if (pp->msi_irq <= 0) {
 					pp->msi_irq = platform_get_irq(pdev, 0);
 					if (pp->msi_irq < 0)
 						return pp->msi_irq;
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index f3de3305d0f5..40ca101e9875 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1595,7 +1595,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 			irq = platform_get_irq(pdev, 0);
 		}
 
-		if (irq  >= 0) {
+		if (irq > 0) {
 			ret = devm_request_irq(&pdev->dev, irq,
 					       qspi_irq_tab[val].irq_handler, 0,
 					       name,
diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 41761f0d892a..b736b57f5ff2 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1330,16 +1330,16 @@ static int rspi_probe(struct platform_device *pdev)
 	ctlr->max_native_cs = rspi->ops->num_hw_ss;
 
 	ret = platform_get_irq_byname_optional(pdev, "rx");
-	if (ret < 0) {
+	if (ret <= 0) {
 		ret = platform_get_irq_byname_optional(pdev, "mux");
-		if (ret < 0)
+		if (ret <= 0)
 			ret = platform_get_irq(pdev, 0);
-		if (ret >= 0)
+		if (ret > 0)
 			rspi->rx_irq = rspi->tx_irq = ret;
 	} else {
 		rspi->rx_irq = ret;
 		ret = platform_get_irq_byname(pdev, "tx");
-		if (ret >= 0)
+		if (ret > 0)
 			rspi->tx_irq = ret;
 	}
 
diff --git a/drivers/usb/cdns3/cdns3-plat.c b/drivers/usb/cdns3/cdns3-plat.c
index 4d0f027e5bd3..7379b6026f9f 100644
--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -108,10 +108,7 @@ static int cdns3_plat_probe(struct platform_device *pdev)
 	cdns->wakeup_irq = platform_get_irq_byname_optional(pdev, "wakeup");
 	if (cdns->wakeup_irq == -EPROBE_DEFER)
 		return cdns->wakeup_irq;
-	else if (cdns->wakeup_irq == 0)
-		return -EINVAL;
-
-	if (cdns->wakeup_irq < 0) {
+	if (cdns->wakeup_irq <= 0) {
 		dev_dbg(dev, "couldn't get wakeup irq\n");
 		cdns->wakeup_irq = 0x0;
 	}
diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index 58a0eae4f41b..e3071e7cb165 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -495,7 +495,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 		return ret;
 
 	irq = platform_get_irq_byname_optional(pdev, "host");
-	if (irq < 0) {
+	if (irq <= 0) {
 		if (irq == -EPROBE_DEFER)
 			return irq;
 
diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index c4a2c37abf62..08173c05a1d6 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -925,7 +925,7 @@ int ssusb_gadget_init(struct ssusb_mtk *ssusb)
 		return -ENOMEM;
 
 	mtu->irq = platform_get_irq_byname_optional(pdev, "device");
-	if (mtu->irq < 0) {
+	if (mtu->irq <= 0) {
 		if (mtu->irq == -EPROBE_DEFER)
 			return mtu->irq;
 
-- 
2.26.3

