Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EE251A2C2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351576AbiEDPAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351579AbiEDPAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:00:01 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFF0E19C2D;
        Wed,  4 May 2022 07:56:22 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,198,1647270000"; 
   d="scan'208";a="119939371"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 04 May 2022 23:56:22 +0900
Received: from localhost.localdomain (unknown [10.226.93.27])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D53B94250F07;
        Wed,  4 May 2022 23:56:18 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/9] ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
Date:   Wed,  4 May 2022 15:54:50 +0100
Message-Id: <20220504145454.71287-6-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504145454.71287-1-phil.edworthy@renesas.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
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

We keep the "ch22" name for Line0_DiA and "ch24" for Line3 interrupts to
keep the code simple.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++
 drivers/net/ethernet/renesas/ravb_main.c | 41 ++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 67a240665cd2..73976a392457 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1028,6 +1028,7 @@ struct ravb_hw_info {
 	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned irq_en_dis_regs:1;	/* Has separate irq enable and disable regs */
+	unsigned err_mgmt_irqs:1;	/* Line1 (Err) and Line2 (Mgmt) irqs are separate */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned gptp_ptm_gic:1;	/* gPTP enables Presentation Time Match irq via GIC */
@@ -1079,6 +1080,8 @@ struct ravb_private {
 	int msg_enable;
 	int speed;
 	int emac_irq;
+	int erra_irq;
+	int mgmta_irq;
 	int rx_irqs[NUM_RX_QUEUE];
 	int tx_irqs[NUM_TX_QUEUE];
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d0b9688074ca..f12a23b9c391 100644
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
@@ -2167,6 +2184,10 @@ static int ravb_close(struct net_device *ndev)
 		free_irq(priv->rx_irqs[RAVB_BE], ndev);
 		free_irq(priv->emac_irq, ndev);
 	}
+	if (info->err_mgmt_irqs) {
+		free_irq(priv->erra_irq, ndev);
+		free_irq(priv->mgmta_irq, ndev);
+	}
 	free_irq(ndev->irq, ndev);
 
 	if (info->nc_queues)
@@ -2665,6 +2686,22 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (info->err_mgmt_irqs) {
+		irq = platform_get_irq_byname(pdev, "err_a");
+		if (irq < 0) {
+			error = irq;
+			goto out_release;
+		}
+		priv->erra_irq = irq;
+
+		irq = platform_get_irq_byname(pdev, "mgmt_a");
+		if (irq < 0) {
+			error = irq;
+			goto out_release;
+		}
+		priv->mgmta_irq = irq;
+	}
+
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		error = PTR_ERR(priv->clk);
-- 
2.32.0

