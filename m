Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C56286A2A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgJGVcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgJGVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACF7C0613DB
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:11 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2g-0005qi-0X; Wed, 07 Oct 2020 23:32:10 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 07/17] can: dev: add a helper function to calculate the duration of one bit
Date:   Wed,  7 Oct 2020 23:31:49 +0200
Message-Id: <20201007213159.1959308-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Rename macro CAN_CALC_SYNC_SEG to CAN_SYNC_SEG and make it available
through include/linux/can/dev.h

Add an helper function can_bit_time() which returns the duration (in
time quanta) of one CAN bit.

Rationale for this patch: the sync segment and the bit time are two
concepts which are defined in the CAN ISO standard. Device drivers for
CAN might need those.

Please refer to ISO 11898-1:2015, section 11.3.1.1 "Bit time" for
additional information.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20201002154219.4887-6-mailhol.vincent@wanadoo.fr
[mkl: Let can_bit_time() return an unsinged int, make argument const]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c   | 13 ++++++-------
 include/linux/can/dev.h | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3c40bba71d5b..b70ded3760f2 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -60,7 +60,6 @@ EXPORT_SYMBOL_GPL(can_len2dlc);
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
 #define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
-#define CAN_CALC_SYNC_SEG 1
 
 /* Bit-timing calculation derived from:
  *
@@ -86,8 +85,8 @@ can_update_sample_point(const struct can_bittiming_const *btc,
 	int i;
 
 	for (i = 0; i <= 1; i++) {
-		tseg2 = tseg + CAN_CALC_SYNC_SEG -
-			(sample_point_nominal * (tseg + CAN_CALC_SYNC_SEG)) /
+		tseg2 = tseg + CAN_SYNC_SEG -
+			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
 			1000 - i;
 		tseg2 = clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
 		tseg1 = tseg - tseg2;
@@ -96,8 +95,8 @@ can_update_sample_point(const struct can_bittiming_const *btc,
 			tseg2 = tseg - tseg1;
 		}
 
-		sample_point = 1000 * (tseg + CAN_CALC_SYNC_SEG - tseg2) /
-			(tseg + CAN_CALC_SYNC_SEG);
+		sample_point = 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
+			(tseg + CAN_SYNC_SEG);
 		sample_point_error = abs(sample_point_nominal - sample_point);
 
 		if (sample_point <= sample_point_nominal &&
@@ -145,7 +144,7 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	/* tseg even = round down, odd = round up */
 	for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
 	     tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
-		tsegall = CAN_CALC_SYNC_SEG + tseg / 2;
+		tsegall = CAN_SYNC_SEG + tseg / 2;
 
 		/* Compute all possible tseg choices (tseg=tseg1+tseg2) */
 		brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
@@ -223,7 +222,7 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 
 	/* real bitrate */
 	bt->bitrate = priv->clock.freq /
-		(bt->brp * (CAN_CALC_SYNC_SEG + tseg1 + tseg2));
+		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
 
 	return 0;
 }
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index f8975d0b90bb..41ff31795320 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -82,6 +82,21 @@ struct can_priv {
 #endif
 };
 
+#define CAN_SYNC_SEG 1
+
+/*
+ * can_bit_time() - Duration of one bit
+ *
+ * Please refer to ISO 11898-1:2015, section 11.3.1.1 "Bit time" for
+ * additional information.
+ *
+ * Return: the number of time quanta in one bit.
+ */
+static inline unsigned int can_bit_time(const struct can_bittiming *bt)
+{
+	return CAN_SYNC_SEG + bt->prop_seg + bt->phase_seg1 + bt->phase_seg2;
+}
+
 /*
  * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
  * to u8 and ensure the dlc value to be max. 8 bytes.
-- 
2.28.0

