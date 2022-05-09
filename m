Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18E851FF9D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbiEIO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiEIO3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:29:14 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BE841EEE0F;
        Mon,  9 May 2022 07:25:19 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,211,1647270000"; 
   d="scan'208";a="119126795"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 09 May 2022 23:25:18 +0900
Received: from localhost.localdomain (unknown [10.226.93.110])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 602474009649;
        Mon,  9 May 2022 23:25:15 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 3/5] ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
Date:   Mon,  9 May 2022 15:24:29 +0100
Message-Id: <20220509142431.24898-4-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220509142431.24898-1-phil.edworthy@renesas.com>
References: <20220509142431.24898-1-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car has a combined interrupt line, ch22 = Line0_DiA | Line1_A | Line2_A.
RZ/V2M has separate interrupt lines for each of these, so add a feature
that allows the driver to get these interrupts and call the common handler.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
------
v2:
 - Move err_mgmt_irqs code under multi_irqs
 - Use dia, line3 irq names instead of ch22, ch24 when using err_mgmt_irqs
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++
 drivers/net/ethernet/renesas/ravb_main.c | 56 +++++++++++++++++++++---
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 0ec8256f7eef..4832beb0bddc 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1028,6 +1028,7 @@ struct ravb_hw_info {
 	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned irq_en_dis_regs:1;	/* Has separate irq enable and disable regs */
+	unsigned err_mgmt_irqs:1;	/* Line1 (Err) and Line2 (Mgmt) irqs are separate */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
@@ -1078,6 +1079,8 @@ struct ravb_private {
 	int msg_enable;
 	int speed;
 	int emac_irq;
+	int erra_irq;
+	int mgmta_irq;
 	int rx_irqs[NUM_RX_QUEUE];
 	int tx_irqs[NUM_TX_QUEUE];
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5f45c8d68f11..d1e1ced33a08 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1798,12 +1798,23 @@ static int ravb_open(struct net_device *ndev)
 				      ndev, dev, "ch19:tx_nc");
 		if (error)
 			goto out_free_irq_nc_rx;
+
+		if (info->err_mgmt_irqs) {
+			error = ravb_hook_irq(priv->erra_irq, ravb_multi_interrupt,
+					      ndev, dev, "err_a");
+			if (error)
+				goto out_free_irq_nc_tx;
+			error = ravb_hook_irq(priv->mgmta_irq, ravb_multi_interrupt,
+					      ndev, dev, "mgmt_a");
+			if (error)
+				goto out_free_irq_erra;
+		}
 	}
 
 	/* Device init */
 	error = ravb_dmac_init(ndev);
 	if (error)
-		goto out_free_irq_nc_tx;
+		goto out_free_irq_mgmta;
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
@@ -1823,9 +1834,15 @@ static int ravb_open(struct net_device *ndev)
 	/* Stop PTP Clock driver */
 	if (info->gptp)
 		ravb_ptp_stop(ndev);
-out_free_irq_nc_tx:
+out_free_irq_mgmta:
 	if (!info->multi_irqs)
 		goto out_free_irq;
+	if (info->err_mgmt_irqs)
+		free_irq(priv->mgmta_irq, ndev);
+out_free_irq_erra:
+	if (info->err_mgmt_irqs)
+		free_irq(priv->erra_irq, ndev);
+out_free_irq_nc_tx:
 	free_irq(priv->tx_irqs[RAVB_NC], ndev);
 out_free_irq_nc_rx:
 	free_irq(priv->rx_irqs[RAVB_NC], ndev);
@@ -2166,6 +2183,10 @@ static int ravb_close(struct net_device *ndev)
 		free_irq(priv->tx_irqs[RAVB_BE], ndev);
 		free_irq(priv->rx_irqs[RAVB_BE], ndev);
 		free_irq(priv->emac_irq, ndev);
+		if (info->err_mgmt_irqs) {
+			free_irq(priv->erra_irq, ndev);
+			free_irq(priv->mgmta_irq, ndev);
+		}
 	}
 	free_irq(ndev->irq, ndev);
 
@@ -2595,10 +2616,14 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (info->multi_irqs)
-		irq = platform_get_irq_byname(pdev, "ch22");
-	else
+	if (info->multi_irqs) {
+		if (info->err_mgmt_irqs)
+			irq = platform_get_irq_byname(pdev, "dia");
+		else
+			irq = platform_get_irq_byname(pdev, "ch22");
+	} else {
 		irq = platform_get_irq(pdev, 0);
+	}
 	if (irq < 0) {
 		error = irq;
 		goto out_release;
@@ -2640,7 +2665,10 @@ static int ravb_probe(struct platform_device *pdev)
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
 	if (info->multi_irqs) {
-		irq = platform_get_irq_byname(pdev, "ch24");
+		if (info->err_mgmt_irqs)
+			irq = platform_get_irq_byname(pdev, "line3");
+		else
+			irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
 			goto out_release;
@@ -2662,6 +2690,22 @@ static int ravb_probe(struct platform_device *pdev)
 			}
 			priv->tx_irqs[i] = irq;
 		}
+
+		if (info->err_mgmt_irqs) {
+			irq = platform_get_irq_byname(pdev, "err_a");
+			if (irq < 0) {
+				error = irq;
+				goto out_release;
+			}
+			priv->erra_irq = irq;
+
+			irq = platform_get_irq_byname(pdev, "mgmt_a");
+			if (irq < 0) {
+				error = irq;
+				goto out_release;
+			}
+			priv->mgmta_irq = irq;
+		}
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.32.0

