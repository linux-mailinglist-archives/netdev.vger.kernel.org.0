Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2E31345C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBHOCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:02:52 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57068 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbhBHN5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:57:47 -0500
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
Subject: [PATCH v2 08/24] net: stmmac: Add {axi,mtl-rx,mtl-tx}-config sub-nodes support
Date:   Mon, 8 Feb 2021 16:55:52 +0300
Message-ID: <20210208135609.7685-9-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the "snps,axi-config", "snps,mtl-rx-config" and
"snps,mtl-tx-config" DT node properties are marked as deprecated when
being defined as a phandle reference to a node with parameters. The new
way of defining the DW MAC interfaces config is to add sub-nodes to the DW
MAC device DT node with vendor-prefixless names. Make sure the STMMAC
driver supports them.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Changelog v2:
- Discard "snps" vendor-prefix from the new AXI/MTL Tx/Rx config
  sub-nodes.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 6dc9f10414e4..1815fe36b62f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -95,7 +95,8 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 	struct device_node *np;
 	struct stmmac_axi *axi;
 
-	np = of_parse_phandle(pdev->dev.of_node, "snps,axi-config", 0);
+	np = of_parse_phandle(pdev->dev.of_node, "snps,axi-config", 0) ?:
+	     of_get_child_by_name(pdev->dev.of_node, "axi-config");
 	if (!np)
 		return NULL;
 
@@ -150,11 +151,13 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	plat->rx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;
 	plat->tx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;
 
-	rx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-rx-config", 0);
+	rx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-rx-config", 0) ?:
+		  of_get_child_by_name(pdev->dev.of_node, "mtl-rx-config");
 	if (!rx_node)
 		return ret;
 
-	tx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-tx-config", 0);
+	tx_node = of_parse_phandle(pdev->dev.of_node, "snps,mtl-tx-config", 0) ?:
+		  of_get_child_by_name(pdev->dev.of_node, "mtl-tx-config");
 	if (!tx_node) {
 		of_node_put(rx_node);
 		return ret;
-- 
2.29.2

