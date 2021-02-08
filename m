Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3927313461
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhBHODT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:03:19 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57062 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhBHN6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:08 -0500
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
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
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
Subject: [PATCH v2 16/24] net: stmmac: Use optional reset control API to work with stmmaceth
Date:   Mon, 8 Feb 2021 16:56:00 +0300
Message-ID: <20210208135609.7685-17-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit bb3222f71b57 ("net: stmmac: platform: use optional clk/reset
get APIs") a manual implementation of the optional device reset control
functionality has been replaced with using the
devm_reset_control_get_optional() method. But for some reason the optional
reset control handler usage hasn't been fixed and preserved the
NULL-checking statements. There is no need in that in order to perform the
reset control assertion/deassertion because the passed NULL will be
considered by the reset framework as absent optional reset control handler
anyway.

Fixes: bb3222f71b57 ("net: stmmac: platform: use optional clk/reset get APIs")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4f1bf8f6538b..a8dec219c295 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4935,15 +4935,13 @@ int stmmac_dvr_probe(struct device *device,
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
@@ -5155,8 +5153,7 @@ int stmmac_dvr_remove(struct device *dev)
 	stmmac_exit_fs(ndev);
 #endif
 	phylink_destroy(priv->phylink);
-	if (priv->plat->stmmac_rst)
-		reset_control_assert(priv->plat->stmmac_rst);
+	reset_control_assert(priv->plat->stmmac_rst);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
-- 
2.29.2

