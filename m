Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32600279BB3
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgIZR7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:59:51 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:59530 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgIZR7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 13:59:50 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d89 with ME
        id YhyX2300D2lQRaH03hzm4K; Sat, 26 Sep 2020 19:59:49 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 26 Sep 2020 19:59:49 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4/6] can: dev: add a helper function to calculate the duration of one bit
Date:   Sun, 27 Sep 2020 02:57:54 +0900
Message-Id: <20200926175810.278529-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/can/dev.c   | 13 ++++++-------
 include/linux/can/dev.h | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 8c3e11820e03..6070b4ab3bd8 100644
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
index 72a8a60c0094..30b327f1a4bd 100644
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
+static inline int can_bit_time(struct can_bittiming *bt)
+{
+	return CAN_SYNC_SEG + bt->prop_seg + bt->phase_seg1 + bt->phase_seg2;
+}
+
 /*
  * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
  * to __u8 and ensure the dlc value to be max. 8 bytes.
-- 
2.26.2

