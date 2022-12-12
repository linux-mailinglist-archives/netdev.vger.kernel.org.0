Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D06649DB1
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiLLLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiLLLa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:30:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD02638E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1K-00004y-L6
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:54 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A92D713CB8C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:52 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8DF9E13CB5C;
        Mon, 12 Dec 2022 11:30:50 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ba6c3460;
        Mon, 12 Dec 2022 11:30:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/39] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
Date:   Mon, 12 Dec 2022 12:30:14 +0100
Message-Id: <20221212113045.222493-9-mkl@pengutronix.de>
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

RZ/G2L has separate IRQ lines for tx and error interrupt for each
channel whereas R-Car has a combined IRQ line for all the channel
specific tx and error interrupts.

Add multi_channel_irqs to struct rcar_canfd_hw_info to select the
driver to choose between combined and separate irq registration for
channel interrupts. This patch also removes enum rcanfd_chip_id and
chip_id from both struct rcar_canfd_hw_info, as it is unused.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/20221027082158.95895-6-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 16294a78320e..f6fa7157b99b 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -41,12 +41,6 @@
 
 #define RCANFD_DRV_NAME			"rcar_canfd"
 
-enum rcanfd_chip_id {
-	RENESAS_RCAR_GEN3 = 0,
-	RENESAS_RZG2L,
-	RENESAS_R8A779A0,
-};
-
 /* Global register bits */
 
 /* RSCFDnCFDGRMCFG */
@@ -523,11 +517,11 @@ enum rcar_canfd_fcanclk {
 struct rcar_canfd_global;
 
 struct rcar_canfd_hw_info {
-	enum rcanfd_chip_id chip_id;
 	u8 max_channels;
 	u8 postdiv;
 	/* hardware features */
 	unsigned shared_global_irqs:1;	/* Has shared global irqs */
+	unsigned multi_channel_irqs:1;	/* Has multiple channel irqs */
 };
 
 /* Channel priv data */
@@ -598,20 +592,18 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
 };
 
 static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
-	.chip_id = RENESAS_RCAR_GEN3,
 	.max_channels = 2,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
-	.chip_id = RENESAS_RZG2L,
-	.postdiv = 1,
 	.max_channels = 2,
+	.postdiv = 1,
+	.multi_channel_irqs = 1,
 };
 
 static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
-	.chip_id = RENESAS_R8A779A0,
 	.max_channels = 8,
 	.postdiv = 2,
 	.shared_global_irqs = 1,
@@ -1746,7 +1738,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
-	if (info->chip_id == RENESAS_RZG2L) {
+	if (info->multi_channel_irqs) {
 		char *irq_name;
 		int err_irq;
 		int tx_irq;
-- 
2.35.1


