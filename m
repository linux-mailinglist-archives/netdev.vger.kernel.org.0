Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7A2D94FA
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407299AbgLNJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:19 -0500
Received: from ns2.baikalelectronics.ru ([94.125.187.42]:46528 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439656AbgLNJR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:17:58 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
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
Subject: [PATCH 13/25] net: stmmac: Fix clocks left enabled on glue-probes failure
Date:   Mon, 14 Dec 2020 12:16:03 +0300
Message-ID: <20201214091616.13545-14-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic clocks request and preparation have been moved from
stmmac_dvr_probe()/stmmac_init_ptp() to the stmmac_probe_config_dt()
method in the framework of commit f573c0b9c4e0 ("stmmac: move stmmac_clk,
pclk, clk_ptp_ref and stmmac_rst to platform structure"). At the same time
the clocks disabling and reset assertion have been left in
stmmac_dvr_remove() instead of also being moved to the symmetric
antagonistic method - stmmac_remove_config_dt(). Due to that all the glue
drivers probe cleanup-on-failure paths don't perform the generic clocks
disable/unprepare procedure, which of course is wrong. Fix it by moving
the clocks disable/unprepare methods invocation to the
stmmac_remove_config_dt() function.

Fixes: f573c0b9c4e0 ("stmmac: move stmmac_clk, pclk, clk_ptp_ref and stmmac_rst to platform structure")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c     | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 81ee0a071b4e..884b8d661442 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -667,6 +667,8 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdev);
 
+	clk_disable_unprepare(priv->plat->stmmac_clk);
+
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d833908b660a..13681027dd09 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5103,8 +5103,6 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5110545090d2..56419f511a48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -630,11 +630,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
  * @pdev: platform_device structure
  * @plat: driver data platform structure
  *
- * Release resources claimed by stmmac_probe_config_dt().
+ * Disable and release resources claimed by stmmac_probe_config_dt().
  */
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	clk_disable_unprepare(plat->pclk);
+	clk_disable_unprepare(plat->stmmac_clk);
 	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }
-- 
2.29.2

