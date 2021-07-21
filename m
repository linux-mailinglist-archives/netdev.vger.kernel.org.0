Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D03D175C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhGUTKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:10:10 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:15349 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240239AbhGUTKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 15:10:06 -0400
X-IronPort-AV: E=Sophos;i="5.84,258,1620658800"; 
   d="scan'208";a="88399809"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Jul 2021 04:50:41 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D522C400D4D3;
        Thu, 22 Jul 2021 04:50:37 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
Date:   Wed, 21 Jul 2021 20:49:50 +0100
Message-Id: <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CANFD block on RZ/G2L SoC is almost identical to one found on
R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
are split into different sources and the IP doesn't divide (1/2)
CANFD clock within the IP.

This patch adds compatible string for RZ/G2L family and registers
the irq handlers required for CANFD operation. IRQ numbers are now
fetched based on names instead of indices. For backward compatibility
on non RZ/G2L SoC's we fallback reading based on indices.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 173 +++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 311e6ca3bdc4..04747573fc48 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -37,9 +37,15 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iopoll.h>
+#include <linux/reset.h>
 
 #define RCANFD_DRV_NAME			"rcar_canfd"
 
+enum rcanfd_chip_id {
+	RENESAS_RCAR_GEN3 = 0,
+	RENESAS_RZG2L,
+};
+
 /* Global register bits */
 
 /* RSCFDnCFDGRMCFG */
@@ -513,6 +519,9 @@ struct rcar_canfd_global {
 	enum rcar_canfd_fcanclk fcan;	/* CANFD or Ext clock */
 	unsigned long channels_mask;	/* Enabled channels mask */
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
+	struct reset_control *rstc1;
+	struct reset_control *rstc2;
+	enum rcanfd_chip_id chip_id;
 };
 
 /* CAN FD mode nominal rate constants */
@@ -1577,6 +1586,53 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
+	if (gpriv->chip_id == RENESAS_RZG2L) {
+		char *irq_name;
+		int err_irq;
+		int tx_irq;
+
+		err_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_err" : "ch1_err");
+		if (err_irq < 0) {
+			err = err_irq;
+			goto fail;
+		}
+
+		tx_irq = platform_get_irq_byname(pdev, ch == 0 ? "ch0_trx" : "ch1_trx");
+		if (tx_irq < 0) {
+			err = tx_irq;
+			goto fail;
+		}
+
+		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+					  "canfd.ch%d_err", ch);
+		if (!irq_name) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		err = devm_request_irq(&pdev->dev, err_irq,
+				       rcar_canfd_channel_interrupt, 0,
+				       irq_name, gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
+				err_irq, err);
+			goto fail;
+		}
+		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+					  "canfd.ch%d_trx", ch);
+		if (!irq_name) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		err = devm_request_irq(&pdev->dev, tx_irq,
+				       rcar_canfd_channel_interrupt, 0,
+				       irq_name, gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
+				tx_irq, err);
+			goto fail;
+		}
+	}
+
 	if (gpriv->fdmode) {
 		priv->can.bittiming_const = &rcar_canfd_nom_bittiming_const;
 		priv->can.data_bittiming_const =
@@ -1636,7 +1692,11 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	struct device_node *of_child;
 	unsigned long channels_mask = 0;
 	int err, ch_irq, g_irq;
+	int g_err_irq, g_recc_irq;
 	bool fdmode = true;			/* CAN FD only mode - default */
+	enum rcanfd_chip_id chip_id;
+
+	chip_id = (enum rcanfd_chip_id)of_device_get_match_data(&pdev->dev);
 
 	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
@@ -1649,16 +1709,30 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	if (of_child && of_device_is_available(of_child))
 		channels_mask |= BIT(1);	/* Channel 1 */
 
-	ch_irq = platform_get_irq(pdev, 0);
-	if (ch_irq < 0) {
-		err = ch_irq;
-		goto fail_dev;
-	}
+	if (chip_id == RENESAS_RCAR_GEN3) {
+		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
+		if (ch_irq < 0) {
+			/* For backward compatibility get irq by index */
+			ch_irq = platform_get_irq(pdev, 0);
+			if (ch_irq < 0)
+				return ch_irq;
+		}
 
-	g_irq = platform_get_irq(pdev, 1);
-	if (g_irq < 0) {
-		err = g_irq;
-		goto fail_dev;
+		g_irq = platform_get_irq_byname_optional(pdev, "g_int");
+		if (g_irq < 0) {
+			/* For backward compatibility get irq by index */
+			g_irq = platform_get_irq(pdev, 1);
+			if (g_irq < 0)
+				return g_irq;
+		}
+	} else {
+		g_err_irq = platform_get_irq_byname(pdev, "g_err");
+		if (g_err_irq < 0)
+			return g_err_irq;
+
+		g_recc_irq = platform_get_irq_byname(pdev, "g_recc");
+		if (g_recc_irq < 0)
+			return g_recc_irq;
 	}
 
 	/* Global controller context */
@@ -1670,6 +1744,19 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->pdev = pdev;
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
+	gpriv->chip_id = chip_id;
+
+	if (gpriv->chip_id == RENESAS_RZG2L) {
+		gpriv->rstc1 = devm_reset_control_get_exclusive(&pdev->dev, "rstp_n");
+		if (IS_ERR(gpriv->rstc1))
+			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc1),
+					     "failed to get rstp_n\n");
+
+		gpriv->rstc2 = devm_reset_control_get_exclusive(&pdev->dev, "rstc_n");
+		if (IS_ERR(gpriv->rstc2))
+			return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->rstc2),
+					     "failed to get rstc_n\n");
+	}
 
 	/* Peripheral clock */
 	gpriv->clkp = devm_clk_get(&pdev->dev, "fck");
@@ -1699,7 +1786,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK)
+	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id == RENESAS_RCAR_GEN3)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1711,20 +1798,51 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	err = devm_request_irq(&pdev->dev, ch_irq,
-			       rcar_canfd_channel_interrupt, 0,
-			       "canfd.chn", gpriv);
-	if (err) {
-		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
-			ch_irq, err);
-		goto fail_dev;
+	if (gpriv->chip_id == RENESAS_RCAR_GEN3) {
+		err = devm_request_irq(&pdev->dev, ch_irq,
+				       rcar_canfd_channel_interrupt, 0,
+				       "canfd.ch_int", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				ch_irq, err);
+			goto fail_dev;
+		}
+
+		err = devm_request_irq(&pdev->dev, g_irq,
+				       rcar_canfd_global_interrupt, 0,
+				       "canfd.g_int", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_irq, err);
+			goto fail_dev;
+		}
+	} else {
+		err = devm_request_irq(&pdev->dev, g_recc_irq,
+				       rcar_canfd_global_interrupt, 0,
+				       "canfd.g_recc", gpriv);
+
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_recc_irq, err);
+			goto fail_dev;
+		}
+
+		err = devm_request_irq(&pdev->dev, g_err_irq,
+				       rcar_canfd_global_interrupt, 0,
+				       "canfd.g_err", gpriv);
+		if (err) {
+			dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
+				g_err_irq, err);
+			goto fail_dev;
+		}
 	}
-	err = devm_request_irq(&pdev->dev, g_irq,
-			       rcar_canfd_global_interrupt, 0,
-			       "canfd.gbl", gpriv);
+
+	err = reset_control_reset(gpriv->rstc1);
+	if (err)
+		goto fail_dev;
+	err = reset_control_reset(gpriv->rstc2);
 	if (err) {
-		dev_err(&pdev->dev, "devm_request_irq(%d) failed, error %d\n",
-			g_irq, err);
+		reset_control_assert(gpriv->rstc1);
 		goto fail_dev;
 	}
 
@@ -1733,7 +1851,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"failed to enable peripheral clock, error %d\n", err);
-		goto fail_dev;
+		goto fail_reset;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
@@ -1790,6 +1908,9 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	rcar_canfd_disable_global_interrupts(gpriv);
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
+fail_reset:
+	reset_control_assert(gpriv->rstc1);
+	reset_control_assert(gpriv->rstc2);
 fail_dev:
 	return err;
 }
@@ -1810,6 +1931,9 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
 	clk_disable_unprepare(gpriv->clkp);
+	reset_control_assert(gpriv->rstc1);
+	reset_control_assert(gpriv->rstc2);
+
 	return 0;
 }
 
@@ -1827,7 +1951,8 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 			 rcar_canfd_resume);
 
 static const struct of_device_id rcar_canfd_of_table[] = {
-	{ .compatible = "renesas,rcar-gen3-canfd" },
+	{ .compatible = "renesas,rcar-gen3-canfd", .data = (void *)RENESAS_RCAR_GEN3 },
+	{ .compatible = "renesas,rzg2l-canfd", .data = (void *)RENESAS_RZG2L },
 	{ }
 };
 
-- 
2.17.1

