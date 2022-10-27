Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB860F232
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiJ0IWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiJ0IWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:22:21 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E0E859717;
        Thu, 27 Oct 2022 01:22:19 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,217,1661785200"; 
   d="scan'208";a="140573900"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 27 Oct 2022 17:22:19 +0900
Received: from localhost.localdomain (unknown [10.226.93.45])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0FA6E4048F22;
        Thu, 27 Oct 2022 17:22:13 +0900 (JST)
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
Subject: [PATCH v3 2/6] can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
Date:   Thu, 27 Oct 2022 09:21:54 +0100
Message-Id: <20221027082158.95895-3-biju.das.jz@bp.renesas.com>
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

R-Car V3U supports a maximum of 8 channels whereas rest of the SoCs
support 2 channels.

Add max_channels variable to struct rcar_canfd_hw_info to handle this
difference.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2->v3:
 * Replaced data type of max_channels from unsigned int->u8 to save memory.
v1->v2:
 * Replaced data type of max_channels from u32->unsigned int.
 * Added Rb tag from Geert.
---
 drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 5660bf0cd755..255cb0825f13 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -525,6 +525,7 @@ struct rcar_canfd_global;
 
 struct rcar_canfd_hw_info {
 	enum rcanfd_chip_id chip_id;
+	u8 max_channels;
 };
 
 /* Channel priv data */
@@ -553,7 +554,6 @@ struct rcar_canfd_global {
 	struct reset_control *rstc1;
 	struct reset_control *rstc2;
 	const struct rcar_canfd_hw_info *info;
-	u32 max_channels;
 };
 
 /* CAN FD mode nominal rate constants */
@@ -597,14 +597,17 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 	.chip_id = RENESAS_RCAR_GEN3,
+	.max_channels = 2,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
 	.chip_id = RENESAS_RZG2L,
+	.max_channels = 2,
 };
 
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
 	.chip_id = RENESAS_R8A779A0,
+	.max_channels = 8,
 };
 
 /* Helper functions */
@@ -738,7 +741,7 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	rcar_canfd_set_mode(gpriv);
 
 	/* Transition all Channels to reset mode */
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
 				     RCANFD_CCTR(ch), RCANFD_CCTR_CSLPR);
 
@@ -779,7 +782,7 @@ static void rcar_canfd_configure_controller(struct rcar_canfd_global *gpriv)
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCFG, cfg);
 
 	/* Channel configuration settings */
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_set_bit(gpriv->base, RCANFD_CCTR(ch),
 				   RCANFD_CCTR_ERRD);
 		rcar_canfd_update_bit(gpriv->base, RCANFD_CCTR(ch),
@@ -1163,7 +1166,7 @@ static irqreturn_t rcar_canfd_global_err_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels)
 		rcar_canfd_handle_global_err(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1195,7 +1198,7 @@ static irqreturn_t rcar_canfd_global_receive_fifo_interrupt(int irq, void *dev_i
 	struct rcar_canfd_global *gpriv = dev_id;
 	u32 ch;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels)
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels)
 		rcar_canfd_handle_global_receive(gpriv, ch);
 
 	return IRQ_HANDLED;
@@ -1209,7 +1212,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	/* Global error interrupts still indicate a condition specific
 	 * to a channel. RxFIFO interrupt is a global interrupt.
 	 */
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_handle_global_err(gpriv, ch);
 		rcar_canfd_handle_global_receive(gpriv, ch);
 	}
@@ -1305,7 +1308,7 @@ static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
 	u32 ch;
 
 	/* Common FIFO is a per channel resource */
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_handle_channel_err(gpriv, ch);
 		rcar_canfd_handle_channel_tx(gpriv, ch);
 	}
@@ -1849,17 +1852,15 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	int err, ch_irq, g_irq;
 	int g_err_irq, g_recc_irq;
 	bool fdmode = true;			/* CAN FD only mode - default */
-	int max_channels;
 	char name[9] = "channelX";
 	int i;
 
 	info = of_device_get_match_data(&pdev->dev);
-	max_channels = info->chip_id == RENESAS_R8A779A0 ? 8 : 2;
 
 	if (of_property_read_bool(pdev->dev.of_node, "renesas,no-can-fd"))
 		fdmode = false;			/* Classical CAN only mode */
 
-	for (i = 0; i < max_channels; ++i) {
+	for (i = 0; i < info->max_channels; ++i) {
 		name[7] = '0' + i;
 		of_child = of_get_child_by_name(pdev->dev.of_node, name);
 		if (of_child && of_device_is_available(of_child))
@@ -1902,7 +1903,6 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	gpriv->channels_mask = channels_mask;
 	gpriv->fdmode = fdmode;
 	gpriv->info = info;
-	gpriv->max_channels = max_channels;
 
 	gpriv->rstc1 = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								 "rstp_n");
@@ -2017,7 +2017,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	rcar_canfd_configure_controller(gpriv);
 
 	/* Configure per channel attributes */
-	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, info->max_channels) {
 		/* Configure Channel's Rx fifo */
 		rcar_canfd_configure_rx(gpriv, ch);
 
@@ -2043,7 +2043,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		goto fail_mode;
 	}
 
-	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, info->max_channels) {
 		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
 		if (err)
 			goto fail_channel;
@@ -2055,7 +2055,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	return 0;
 
 fail_channel:
-	for_each_set_bit(ch, &gpriv->channels_mask, max_channels)
+	for_each_set_bit(ch, &gpriv->channels_mask, info->max_channels)
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
@@ -2076,7 +2076,7 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	rcar_canfd_reset_controller(gpriv);
 	rcar_canfd_disable_global_interrupts(gpriv);
 
-	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_disable_channel_interrupts(gpriv->ch[ch]);
 		rcar_canfd_channel_remove(gpriv, ch);
 	}
-- 
2.25.1

