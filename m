Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131D5649D9A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiLLLaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiLLLay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:30:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE5260FF
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1H-0008SB-Ld
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:51 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AFDD613CB61
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:50 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 75C7413CB35;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8e61d393;
        Mon, 12 Dec 2022 11:30:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/39] can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
Date:   Mon, 12 Dec 2022 12:30:09 +0100
Message-Id: <20221212113045.222493-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

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
Link: https://lore.kernel.org/all/20221027082158.95895-2-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 43 +++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 0a59eab35da7..1a5a013ac5bc 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -522,6 +522,10 @@ enum rcar_canfd_fcanclk {
 
 struct rcar_canfd_global;
 
+struct rcar_canfd_hw_info {
+	enum rcanfd_chip_id chip_id;
+};
+
 /* Channel priv data */
 struct rcar_canfd_channel {
 	struct can_priv can;			/* Must be the first member */
@@ -547,7 +551,7 @@ struct rcar_canfd_global {
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
 	struct reset_control *rstc1;
 	struct reset_control *rstc2;
-	enum rcanfd_chip_id chip_id;
+	const struct rcar_canfd_hw_info *info;
 	u32 max_channels;
 };
 
@@ -590,10 +594,22 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
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
@@ -1696,6 +1712,7 @@ static const struct ethtool_ops rcar_canfd_ethtool_ops = {
 static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 				    u32 fcan_freq)
 {
+	const struct rcar_canfd_hw_info *info = gpriv->info;
 	struct platform_device *pdev = gpriv->pdev;
 	struct rcar_canfd_channel *priv;
 	struct net_device *ndev;
@@ -1718,7 +1735,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
-	if (gpriv->chip_id == RENESAS_RZG2L) {
+	if (info->chip_id == RENESAS_RZG2L) {
 		char *irq_name;
 		int err_irq;
 		int tx_irq;
@@ -1818,6 +1835,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
+	const struct rcar_canfd_hw_info *info;
 	void __iomem *addr;
 	u32 sts, ch, fcan_freq;
 	struct rcar_canfd_global *gpriv;
@@ -1826,13 +1844,12 @@ static int rcar_canfd_probe(struct platform_device *pdev)
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
@@ -1845,7 +1862,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_node_put(of_child);
 	}
 
-	if (chip_id != RENESAS_RZG2L) {
+	if (info->chip_id != RENESAS_RZG2L) {
 		ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
 		if (ch_irq < 0) {
 			/* For backward compatibility get irq by index */
@@ -1879,7 +1896,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->pdev = pdev;
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
-	gpriv->chip_id = chip_id;
+	gpriv->info = info;
 	gpriv->max_channels = max_channels;
 
 	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(&pdev->dev,
@@ -1917,7 +1934,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 	fcan_freq = clk_get_rate(gpriv->can_clk);
 
-	if (gpriv->fcan == RCANFD_CANFDCLK && gpriv->chip_id != RENESAS_RZG2L)
+	if (gpriv->fcan == RCANFD_CANFDCLK && info->chip_id != RENESAS_RZG2L)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
@@ -1929,7 +1946,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->base = addr;
 
 	/* Request IRQ that's common for both channels */
-	if (gpriv->chip_id != RENESAS_RZG2L) {
+	if (info->chip_id != RENESAS_RZG2L) {
 		err = devm_request_irq(&pdev->dev, ch_irq,
 				       rcar_canfd_channel_interrupt, 0,
 				       "canfd.ch_int", gpriv);
@@ -2082,9 +2099,9 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
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
2.35.1


