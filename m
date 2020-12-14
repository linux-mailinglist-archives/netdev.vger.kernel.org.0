Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFFC2D94E0
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439837AbgLNJSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:43 -0500
Received: from mx.baikalelectronics.com ([94.125.187.42]:46532 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728732AbgLNJSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:18:37 -0500
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
Subject: [PATCH 17/25] net: stmmac: Use optional reset control API to work with stmmaceth
Date:   Mon, 14 Dec 2020 12:16:07 +0300
Message-ID: <20201214091616.13545-18-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the manual implementation of the optional device reset control
functionality with using the devm_reset_control_get_optional() method in
order to improve the code maintainability and fix a potential bug. It
will come out if the reset control handler has been specified, but the
reset framework failed to request it.

Note there is no need in checking the priv->plat->stmmac_rst pointer for
being not NULL in order to perform the reset control assertion/deassertion
because the passed NULL will be considered by the reset framework as
absent optional reset control handler anyway.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 ++++++++-----------
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 14 +++++---------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e9003684efc8..7f4d54d2fc72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4889,15 +4889,13 @@ int stmmac_dvr_probe(struct device *device,
 	if ((phyaddr >= 0) && (phyaddr <= 31))
 		priv->plat->phy_addr = phyaddr;
 
-	if (priv->plat->stmmac_rst) {
-		ret = reset_control_assert(priv->plat->stmmac_rst);
-		reset_control_deassert(priv->plat->stmmac_rst);
-		/* Some reset controllers have only reset callback instead of
-		 * assert + deassert callbacks pair.
-		 */
-		if (ret == -ENOTSUPP)
-			reset_control_reset(priv->plat->stmmac_rst);
-	}
+	ret = reset_control_assert(priv->plat->stmmac_rst);
+	reset_control_deassert(priv->plat->stmmac_rst);
+	/* Some reset controllers have only reset callback instead of
+	 * assert + deassert callbacks pair.
+	 */
+	if (ret == -ENOTSUPP)
+		reset_control_reset(priv->plat->stmmac_rst);
 
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
@@ -5101,8 +5099,7 @@ int stmmac_dvr_remove(struct device *dev)
 	stmmac_exit_fs(ndev);
 #endif
 	phylink_destroy(priv->phylink);
-	if (priv->plat->stmmac_rst)
-		reset_control_assert(priv->plat->stmmac_rst);
+	reset_control_assert(priv->plat->stmmac_rst);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 367d1458d66d..38e8836861c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -602,16 +602,12 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
 	}
 
-	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
-						  STMMAC_RESOURCE_NAME);
+	plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev,
+							   STMMAC_RESOURCE_NAME);
 	if (IS_ERR(plat->stmmac_rst)) {
-		if (PTR_ERR(plat->stmmac_rst) == -EPROBE_DEFER) {
-			rc = PTR_ERR(plat->stmmac_rst);
-			goto error_hw_init;
-		}
-
-		dev_info(&pdev->dev, "no reset control found\n");
-		plat->stmmac_rst = NULL;
+		rc = PTR_ERR(plat->stmmac_rst);
+		dev_err_probe(&pdev->dev, rc, "Cannot get reset control\n");
+		goto error_hw_init;
 	}
 
 	return plat;
-- 
2.29.2

