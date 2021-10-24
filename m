Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A72438BF7
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhJXUr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhJXUrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE708C06122D
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMT-0006T4-70
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:57 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E6CA969C5A5
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5969269C559;
        Sun, 24 Oct 2021 20:43:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 76ff49bb;
        Sun, 24 Oct 2021 20:43:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/15] can: bittiming: change unit of TDC parameters to clock periods
Date:   Sun, 24 Oct 2021 22:43:14 +0200
Message-Id: <20211024204325.3293425-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

In the current implementation, all Transmission Delay Compensation
(TDC) parameters are expressed in time quantum. However, ISO 11898-1
actually specifies that these should be expressed in *minimum* time
quantum.

Furthermore, the minimum time quantum is specified to be "one node
clock period long" (c.f. paragraph 11.3.1.1 "Bit time"). For sake of
simplicity, we prefer to use the "clock period" term instead of
"minimum time quantum" because we believe that it is more broadly
understood.

This patch fixes that discrepancy by updating the documentation and
the formula for TDCO calculation.

N.B. In can_calc_tdco(), the sample point (in time quantum) was
calculated using a division, thus introducing a risk of rounding and
truncation errors. On top of changing the unit to clock period, we
also modified the formula to use only additions.

Link: https://lore.kernel.org/all/20210918095637.20108-3-mailhol.vincent@wanadoo.fr
Suggested-by: Stefan Mätje <Stefan.Maetje@esd.eu>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c |  9 +++++----
 include/linux/can/bittiming.h   | 28 +++++++++++++++++-----------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 9dda44c0ae9d..0ccf982ca301 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -193,12 +193,13 @@ void can_calc_tdco(struct net_device *dev)
 	 * one or two.
 	 */
 	if (dbt->brp == 1 || dbt->brp == 2) {
-		/* Reuse "normal" sample point and convert it to time quanta */
-		u32 sample_point_in_tq = can_bit_time(dbt) * dbt->sample_point / 1000;
+		/* Sample point in clock periods */
+		u32 sample_point_in_tc = (CAN_SYNC_SEG + dbt->prop_seg +
+					  dbt->phase_seg1) * dbt->brp;
 
-		if (sample_point_in_tq < tdc_const->tdco_min)
+		if (sample_point_in_tc < tdc_const->tdco_min)
 			return;
-		tdc->tdco = min(sample_point_in_tq, tdc_const->tdco_max);
+		tdc->tdco = min(sample_point_in_tc, tdc_const->tdco_max);
 		priv->ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
 	}
 }
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 9e20260611cc..aebbe65dab7e 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -31,8 +31,8 @@
  *
  * To solve this issue, ISO 11898-1 introduces in section 11.3.3
  * "Transmitter delay compensation" a SSP (Secondary Sample Point)
- * equal to the distance, in time quanta, from the start of the bit
- * time on the TX pin to the actual measurement on the RX pin.
+ * equal to the distance from the start of the bit time on the TX pin
+ * to the actual measurement on the RX pin.
  *
  * This structure contains the parameters to calculate that SSP.
  *
@@ -44,8 +44,13 @@
  *                           |<------- TDCO ------->|
  *  |<----------- Secondary Sample Point ---------->|
  *
+ * To increase precision, contrary to the other bittiming parameters
+ * which are measured in time quanta, the TDC parameters are measured
+ * in clock periods (also referred as "minimum time quantum" in ISO
+ * 11898-1).
+ *
  * @tdcv: Transmitter Delay Compensation Value. The time needed for
- *	the signal to propagate, i.e. the distance, in time quanta,
+ *	the signal to propagate, i.e. the distance, in clock periods,
  *	from the start of the bit on the TX pin to when it is received
  *	on the RX pin. @tdcv depends on the controller modes:
  *
@@ -62,17 +67,18 @@
  *	TDC is disabled and all the values of this structure should be
  *	ignored.
  *
- * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
- *	quanta, defining the distance between the start of the bit
- *	reception on the RX pin of the transceiver and the SSP
+ * @tdco: Transmitter Delay Compensation Offset. Offset value, in
+ *	clock periods, defining the distance between the start of the
+ *	bit reception on the RX pin of the transceiver and the SSP
  *	position such that SSP = @tdcv + @tdco.
  *
  * @tdcf: Transmitter Delay Compensation Filter window. Defines the
- *	minimum value for the SSP position in time quanta. If the SSP
- *	position is less than @tdcf, then no delay compensations occur
- *	and the normal sampling point is used instead. The feature is
- *	enabled if and only if @tdcv is set to zero (automatic mode)
- *	and @tdcf is configured to a value greater than @tdco.
+ *	minimum value for the SSP position in clock periods. If the
+ *	SSP position is less than @tdcf, then no delay compensations
+ *	occur and the normal sampling point is used instead. The
+ *	feature is enabled if and only if @tdcv is set to zero
+ *	(automatic mode) and @tdcf is configured to a value greater
+ *	than @tdco.
  */
 struct can_tdc {
 	u32 tdcv;
-- 
2.33.0


