Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927D160F22D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiJ0IWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiJ0IWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:22:15 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC6E65AA1F;
        Thu, 27 Oct 2022 01:22:13 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,217,1661785200"; 
   d="scan'208";a="140573886"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 27 Oct 2022 17:22:13 +0900
Received: from localhost.localdomain (unknown [10.226.93.45])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 36F69400B9FE;
        Thu, 27 Oct 2022 17:22:07 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 1/6] can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
Date:   Thu, 27 Oct 2022 09:21:53 +0100
Message-Id: <20221027082158.95895-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAN FD IP found on RZ/G2L SoC has some HW features different to that
of R-Car. For example, it has multiple resets and multiple IRQs for global
and channel interrupts. Also, it does not have ECC error flag registers
and clk post divider present on R-Car. Similarly, R-Car V3U has 8 channels
whereas other SoCs has only 2 channels.

This patch adds the struct rcar_canfd_hw_info to take care of the
HW feature differences and driver data present on both IPs. It also
replaces the driver data chip type with struct rcar_canfd_hw_info by
moving chip type to it.

Whilst started using driver data instead of chip_id for detecting
R-Car V3U SoCs.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2->v3:
 * No change
v1->v2:
 * Updated commit description for R-Car V3U SoC detection using
   driver data.
 * Added Rb tag from Geert.
---
 drivers/net/can/rcar/rcar_canfd.c | 43 +++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index a0dd6044830b..5660bf0cd755 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -523,6 +523,10 @@ enum rcar_canfd_fcanclk {
 
 struct rcar_canfd_global;
 
+struct rcar_canfd_hw_info {
+	enum rcanfd_chip_id chip_id;
+};
+
 /* Channel priv data */
 struct rcar_canfd_channel {
 	struct can_priv can;			/* Must be the first member */
@@ -548,7 +552,7 @@ struct rcar_canfd_global {
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
 	struct reset_control *rstc1;
 	struct reset_control *rstc2;
-	enum rcanfd_chip_id chip_id;
+	const struct rcar_canfd_hw_info *info;
 	u32 max_channels;
 };
 
@@ -591,10 +595,22 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 	.brp_inc = 1,
 };
 
+static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
+	.chip_id = RENESAS_RCAR_GEN3,
+};
+
+static const struct rcar_canfd_hw_info rzg2l_hw_info = {
+	.chip_id = RENESAS_RZG2L,
+};
+
+static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
+	.chip_id = RENESAS_R8A779A0,
+};
+
 /* Helper functions */
 static inline bool is_v3u(struct rcar_canfd_global *gpriv)
 {
-	return gpriv->chip_id == RENESAS_R8A779A0;
+	return gpriv->info == &r8a779a0_hw_info;
 }
 
 static inline u32 reg_v3u(struct rcar_canfd_global *gpriv,
@@ -1701,6 +1717,7 @@ static const struct ethtool_ops rcar_canfd_ethtool_ops = {
 static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				    u32 fcan_freq)
 {
+	const struct rcar_canfd_hw_info *info = gpriv->info;
 	struct platform_device *pdev = gpriv->pdev;
 	struct rcar_canfd_channel *priv;
 	struct net_device *ndev;
@@ -1723,7 +1740,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
-	if (gpriv->chip_id == RENESAS_RZG2L) {
+	if (info->chip_id == RENESAS_RZG2L) {
 		char *irq_name;
 		int err_irq;
 		int tx_irq;
@@ -1823,6 +1840,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
+	const struct rcar_canfd_hw_info *info;
 	void __iomem *addr;
 	u32 sts, ch, fcan_freq;
 	struct rcar_canfd_global *gpriv;
@@ -1831,13 +1849,12 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	int err, ch_irq, g_irq;
 	int g_err_irq, g_recc_irq;
 	bool fdmode = true;			/* CAN FD only mode - default */
-	enum rcanfd_chip_id chip_id;
 	int max_channels;
 	char name[9] = "channelX";
 	int i;
 
-	chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
-	max_channels = chip_id == RENESAS_R8A779A0 ? 8 : 2;
+	info = of_device_get_match_data(&pdev->dev);
+	max_channels = info->chip_id == RENESAS_R8A779A0 ? 8 : 2;
 
 	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
@@ -1850,7 +1867,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_node_put(of_child);
 	}
 
-	if (chip_id != RENESAS_RZG2L) {
+	if (info->chip_id != RENESAS_RZG2L) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
 		if (ch_irq < 0) {
 			/* For backward compatibility get irq by index */
@@ -1884,7 +1901,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->pdev = pdev;
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
-	gpriv->chip_id = chip_id;
+	gpriv->info = info;
 	gpriv->max_channels = max_channels;
 
 	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(&pdev->dev,
@@ -1922,7 +1939,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id != RENESAS_RZG2L)
+	if (gpriv->fcan == RCANFD_CANFDCLK && info->chip_id != RENESAS_RZG2L)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1934,7 +1951,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (gpriv->chip_id != RENESAS_RZG2L) {
+	if (info->chip_id != RENESAS_RZG2L) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
@@ -2087,9 +2104,9 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 			 rcar_canfd_resume);
 
 static const __maybe_unused struct of_device_id rcar_canfd_of_table[] = {
-	{ .compatible = "renesas,rcar-gen3-canfd", .data = (void *)RENESAS_RCAR_GEN3 },
-	{ .compatible = "renesas,rzg2l-canfd", .data = (void *)RENESAS_RZG2L },
-	{ .compatible = "renesas,r8a779a0-canfd", .data = (void *)RENESAS_R8A779A0 },
+	{ .compatible = "renesas,rcar-gen3-canfd", .data = &rcar_gen3_hw_info },
+	{ .compatible = "renesas,rzg2l-canfd", .data = &rzg2l_hw_info },
+	{ .compatible = "renesas,r8a779a0-canfd", .data = &r8a779a0_hw_info },
 	{ }
 };
 
-- 
2.25.1

