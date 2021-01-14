Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9692F5BCA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbhANH5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbhANH5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:57:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C17AC0617A6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUZ-00074z-Ok
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:27 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6D7A45C3630
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 28D465C35FD;
        Thu, 14 Jan 2021 07:56:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9af4031c;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 04/17] can: dev: move bittiming related code into seperate file
Date:   Thu, 14 Jan 2021 08:56:04 +0100
Message-Id: <20210114075617.1402597-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the bittiming related code of the CAN device infrastructure
into a separate file.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS                     |   1 +
 drivers/net/can/dev/Makefile    |   1 +
 drivers/net/can/dev/bittiming.c | 261 ++++++++++++++++++++++++++++++++
 drivers/net/can/dev/dev.c       | 261 --------------------------------
 include/linux/can/bittiming.h   |  44 ++++++
 include/linux/can/dev.h         |  16 +-
 6 files changed, 308 insertions(+), 276 deletions(-)
 create mode 100644 drivers/net/can/dev/bittiming.c
 create mode 100644 include/linux/can/bittiming.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c3091a91ebbf..d17662df1cd7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3943,6 +3943,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git
 F:	Documentation/devicetree/bindings/net/can/
 F:	drivers/net/can/
+F:	include/linux/can/bittiming.h
 F:	include/linux/can/dev.h
 F:	include/linux/can/led.h
 F:	include/linux/can/platform/
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index cba92e6bcf6f..b5c6bb848d9d 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+can-dev-y			+= bittiming.o
 can-dev-y			+= dev.o
 can-dev-y			+= rx-offload.o
 
diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
new file mode 100644
index 000000000000..f7fe226bb395
--- /dev/null
+++ b/drivers/net/can/dev/bittiming.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2005 Marc Kleine-Budde, Pengutronix
+ * Copyright (C) 2006 Andrey Volkov, Varma Electronics
+ * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
+ */
+
+#include <linux/can/dev.h>
+
+#ifdef CONFIG_CAN_CALC_BITTIMING
+#define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
+
+/* Bit-timing calculation derived from:
+ *
+ * Code based on LinCAN sources and H8S2638 project
+ * Copyright 2004-2006 Pavel Pisa - DCE FELK CVUT cz
+ * Copyright 2005      Stanislav Marek
+ * email: pisa@cmp.felk.cvut.cz
+ *
+ * Calculates proper bit-timing parameters for a specified bit-rate
+ * and sample-point, which can then be used to set the bit-timing
+ * registers of the CAN controller. You can find more information
+ * in the header file linux/can/netlink.h.
+ */
+static int
+can_update_sample_point(const struct can_bittiming_const *btc,
+			unsigned int sample_point_nominal, unsigned int tseg,
+			unsigned int *tseg1_ptr, unsigned int *tseg2_ptr,
+			unsigned int *sample_point_error_ptr)
+{
+	unsigned int sample_point_error, best_sample_point_error = UINT_MAX;
+	unsigned int sample_point, best_sample_point = 0;
+	unsigned int tseg1, tseg2;
+	int i;
+
+	for (i = 0; i <= 1; i++) {
+		tseg2 = tseg + CAN_SYNC_SEG -
+			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
+			1000 - i;
+		tseg2 = clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
+		tseg1 = tseg - tseg2;
+		if (tseg1 > btc->tseg1_max) {
+			tseg1 = btc->tseg1_max;
+			tseg2 = tseg - tseg1;
+		}
+
+		sample_point = 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
+			(tseg + CAN_SYNC_SEG);
+		sample_point_error = abs(sample_point_nominal - sample_point);
+
+		if (sample_point <= sample_point_nominal &&
+		    sample_point_error < best_sample_point_error) {
+			best_sample_point = sample_point;
+			best_sample_point_error = sample_point_error;
+			*tseg1_ptr = tseg1;
+			*tseg2_ptr = tseg2;
+		}
+	}
+
+	if (sample_point_error_ptr)
+		*sample_point_error_ptr = best_sample_point_error;
+
+	return best_sample_point;
+}
+
+int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+		       const struct can_bittiming_const *btc)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	unsigned int bitrate;			/* current bitrate */
+	unsigned int bitrate_error;		/* difference between current and nominal value */
+	unsigned int best_bitrate_error = UINT_MAX;
+	unsigned int sample_point_error;	/* difference between current and nominal value */
+	unsigned int best_sample_point_error = UINT_MAX;
+	unsigned int sample_point_nominal;	/* nominal sample point */
+	unsigned int best_tseg = 0;		/* current best value for tseg */
+	unsigned int best_brp = 0;		/* current best value for brp */
+	unsigned int brp, tsegall, tseg, tseg1 = 0, tseg2 = 0;
+	u64 v64;
+
+	/* Use CiA recommended sample points */
+	if (bt->sample_point) {
+		sample_point_nominal = bt->sample_point;
+	} else {
+		if (bt->bitrate > 800000)
+			sample_point_nominal = 750;
+		else if (bt->bitrate > 500000)
+			sample_point_nominal = 800;
+		else
+			sample_point_nominal = 875;
+	}
+
+	/* tseg even = round down, odd = round up */
+	for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
+	     tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
+		tsegall = CAN_SYNC_SEG + tseg / 2;
+
+		/* Compute all possible tseg choices (tseg=tseg1+tseg2) */
+		brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
+
+		/* choose brp step which is possible in system */
+		brp = (brp / btc->brp_inc) * btc->brp_inc;
+		if (brp < btc->brp_min || brp > btc->brp_max)
+			continue;
+
+		bitrate = priv->clock.freq / (brp * tsegall);
+		bitrate_error = abs(bt->bitrate - bitrate);
+
+		/* tseg brp biterror */
+		if (bitrate_error > best_bitrate_error)
+			continue;
+
+		/* reset sample point error if we have a better bitrate */
+		if (bitrate_error < best_bitrate_error)
+			best_sample_point_error = UINT_MAX;
+
+		can_update_sample_point(btc, sample_point_nominal, tseg / 2,
+					&tseg1, &tseg2, &sample_point_error);
+		if (sample_point_error > best_sample_point_error)
+			continue;
+
+		best_sample_point_error = sample_point_error;
+		best_bitrate_error = bitrate_error;
+		best_tseg = tseg / 2;
+		best_brp = brp;
+
+		if (bitrate_error == 0 && sample_point_error == 0)
+			break;
+	}
+
+	if (best_bitrate_error) {
+		/* Error in one-tenth of a percent */
+		v64 = (u64)best_bitrate_error * 1000;
+		do_div(v64, bt->bitrate);
+		bitrate_error = (u32)v64;
+		if (bitrate_error > CAN_CALC_MAX_ERROR) {
+			netdev_err(dev,
+				   "bitrate error %d.%d%% too high\n",
+				   bitrate_error / 10, bitrate_error % 10);
+			return -EDOM;
+		}
+		netdev_warn(dev, "bitrate error %d.%d%%\n",
+			    bitrate_error / 10, bitrate_error % 10);
+	}
+
+	/* real sample point */
+	bt->sample_point = can_update_sample_point(btc, sample_point_nominal,
+						   best_tseg, &tseg1, &tseg2,
+						   NULL);
+
+	v64 = (u64)best_brp * 1000 * 1000 * 1000;
+	do_div(v64, priv->clock.freq);
+	bt->tq = (u32)v64;
+	bt->prop_seg = tseg1 / 2;
+	bt->phase_seg1 = tseg1 - bt->prop_seg;
+	bt->phase_seg2 = tseg2;
+
+	/* check for sjw user settings */
+	if (!bt->sjw || !btc->sjw_max) {
+		bt->sjw = 1;
+	} else {
+		/* bt->sjw is at least 1 -> sanitize upper bound to sjw_max */
+		if (bt->sjw > btc->sjw_max)
+			bt->sjw = btc->sjw_max;
+		/* bt->sjw must not be higher than tseg2 */
+		if (tseg2 < bt->sjw)
+			bt->sjw = tseg2;
+	}
+
+	bt->brp = best_brp;
+
+	/* real bitrate */
+	bt->bitrate = priv->clock.freq /
+		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
+
+	return 0;
+}
+#endif /* CONFIG_CAN_CALC_BITTIMING */
+
+/* Checks the validity of the specified bit-timing parameters prop_seg,
+ * phase_seg1, phase_seg2 and sjw and tries to determine the bitrate
+ * prescaler value brp. You can find more information in the header
+ * file linux/can/netlink.h.
+ */
+static int can_fixup_bittiming(struct net_device *dev, struct can_bittiming *bt,
+			       const struct can_bittiming_const *btc)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	int tseg1, alltseg;
+	u64 brp64;
+
+	tseg1 = bt->prop_seg + bt->phase_seg1;
+	if (!bt->sjw)
+		bt->sjw = 1;
+	if (bt->sjw > btc->sjw_max ||
+	    tseg1 < btc->tseg1_min || tseg1 > btc->tseg1_max ||
+	    bt->phase_seg2 < btc->tseg2_min || bt->phase_seg2 > btc->tseg2_max)
+		return -ERANGE;
+
+	brp64 = (u64)priv->clock.freq * (u64)bt->tq;
+	if (btc->brp_inc > 1)
+		do_div(brp64, btc->brp_inc);
+	brp64 += 500000000UL - 1;
+	do_div(brp64, 1000000000UL); /* the practicable BRP */
+	if (btc->brp_inc > 1)
+		brp64 *= btc->brp_inc;
+	bt->brp = (u32)brp64;
+
+	if (bt->brp < btc->brp_min || bt->brp > btc->brp_max)
+		return -EINVAL;
+
+	alltseg = bt->prop_seg + bt->phase_seg1 + bt->phase_seg2 + 1;
+	bt->bitrate = priv->clock.freq / (bt->brp * alltseg);
+	bt->sample_point = ((tseg1 + 1) * 1000) / alltseg;
+
+	return 0;
+}
+
+/* Checks the validity of predefined bitrate settings */
+static int
+can_validate_bitrate(struct net_device *dev, struct can_bittiming *bt,
+		     const u32 *bitrate_const,
+		     const unsigned int bitrate_const_cnt)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	unsigned int i;
+
+	for (i = 0; i < bitrate_const_cnt; i++) {
+		if (bt->bitrate == bitrate_const[i])
+			break;
+	}
+
+	if (i >= priv->bitrate_const_cnt)
+		return -EINVAL;
+
+	return 0;
+}
+
+int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
+		      const struct can_bittiming_const *btc,
+		      const u32 *bitrate_const,
+		      const unsigned int bitrate_const_cnt)
+{
+	int err;
+
+	/* Depending on the given can_bittiming parameter structure the CAN
+	 * timing parameters are calculated based on the provided bitrate OR
+	 * alternatively the CAN timing parameters (tq, prop_seg, etc.) are
+	 * provided directly which are then checked and fixed up.
+	 */
+	if (!bt->tq && bt->bitrate && btc)
+		err = can_calc_bittiming(dev, bt, btc);
+	else if (bt->tq && !bt->bitrate && btc)
+		err = can_fixup_bittiming(dev, bt, btc);
+	else if (!bt->tq && bt->bitrate && bitrate_const)
+		err = can_validate_bitrate(dev, bt, bitrate_const,
+					   bitrate_const_cnt);
+	else
+		err = -EINVAL;
+
+	return err;
+}
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 3486704c8a95..1b3ab95b3fd1 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -58,267 +58,6 @@ u8 can_fd_len2dlc(u8 len)
 }
 EXPORT_SYMBOL_GPL(can_fd_len2dlc);
 
-#ifdef CONFIG_CAN_CALC_BITTIMING
-#define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
-
-/* Bit-timing calculation derived from:
- *
- * Code based on LinCAN sources and H8S2638 project
- * Copyright 2004-2006 Pavel Pisa - DCE FELK CVUT cz
- * Copyright 2005      Stanislav Marek
- * email: pisa@cmp.felk.cvut.cz
- *
- * Calculates proper bit-timing parameters for a specified bit-rate
- * and sample-point, which can then be used to set the bit-timing
- * registers of the CAN controller. You can find more information
- * in the header file linux/can/netlink.h.
- */
-static int
-can_update_sample_point(const struct can_bittiming_const *btc,
-			unsigned int sample_point_nominal, unsigned int tseg,
-			unsigned int *tseg1_ptr, unsigned int *tseg2_ptr,
-			unsigned int *sample_point_error_ptr)
-{
-	unsigned int sample_point_error, best_sample_point_error = UINT_MAX;
-	unsigned int sample_point, best_sample_point = 0;
-	unsigned int tseg1, tseg2;
-	int i;
-
-	for (i = 0; i <= 1; i++) {
-		tseg2 = tseg + CAN_SYNC_SEG -
-			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
-			1000 - i;
-		tseg2 = clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
-		tseg1 = tseg - tseg2;
-		if (tseg1 > btc->tseg1_max) {
-			tseg1 = btc->tseg1_max;
-			tseg2 = tseg - tseg1;
-		}
-
-		sample_point = 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
-			(tseg + CAN_SYNC_SEG);
-		sample_point_error = abs(sample_point_nominal - sample_point);
-
-		if (sample_point <= sample_point_nominal &&
-		    sample_point_error < best_sample_point_error) {
-			best_sample_point = sample_point;
-			best_sample_point_error = sample_point_error;
-			*tseg1_ptr = tseg1;
-			*tseg2_ptr = tseg2;
-		}
-	}
-
-	if (sample_point_error_ptr)
-		*sample_point_error_ptr = best_sample_point_error;
-
-	return best_sample_point;
-}
-
-static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
-			      const struct can_bittiming_const *btc)
-{
-	struct can_priv *priv = netdev_priv(dev);
-	unsigned int bitrate;			/* current bitrate */
-	unsigned int bitrate_error;		/* difference between current and nominal value */
-	unsigned int best_bitrate_error = UINT_MAX;
-	unsigned int sample_point_error;	/* difference between current and nominal value */
-	unsigned int best_sample_point_error = UINT_MAX;
-	unsigned int sample_point_nominal;	/* nominal sample point */
-	unsigned int best_tseg = 0;		/* current best value for tseg */
-	unsigned int best_brp = 0;		/* current best value for brp */
-	unsigned int brp, tsegall, tseg, tseg1 = 0, tseg2 = 0;
-	u64 v64;
-
-	/* Use CiA recommended sample points */
-	if (bt->sample_point) {
-		sample_point_nominal = bt->sample_point;
-	} else {
-		if (bt->bitrate > 800000)
-			sample_point_nominal = 750;
-		else if (bt->bitrate > 500000)
-			sample_point_nominal = 800;
-		else
-			sample_point_nominal = 875;
-	}
-
-	/* tseg even = round down, odd = round up */
-	for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
-	     tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
-		tsegall = CAN_SYNC_SEG + tseg / 2;
-
-		/* Compute all possible tseg choices (tseg=tseg1+tseg2) */
-		brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
-
-		/* choose brp step which is possible in system */
-		brp = (brp / btc->brp_inc) * btc->brp_inc;
-		if (brp < btc->brp_min || brp > btc->brp_max)
-			continue;
-
-		bitrate = priv->clock.freq / (brp * tsegall);
-		bitrate_error = abs(bt->bitrate - bitrate);
-
-		/* tseg brp biterror */
-		if (bitrate_error > best_bitrate_error)
-			continue;
-
-		/* reset sample point error if we have a better bitrate */
-		if (bitrate_error < best_bitrate_error)
-			best_sample_point_error = UINT_MAX;
-
-		can_update_sample_point(btc, sample_point_nominal, tseg / 2,
-					&tseg1, &tseg2, &sample_point_error);
-		if (sample_point_error > best_sample_point_error)
-			continue;
-
-		best_sample_point_error = sample_point_error;
-		best_bitrate_error = bitrate_error;
-		best_tseg = tseg / 2;
-		best_brp = brp;
-
-		if (bitrate_error == 0 && sample_point_error == 0)
-			break;
-	}
-
-	if (best_bitrate_error) {
-		/* Error in one-tenth of a percent */
-		v64 = (u64)best_bitrate_error * 1000;
-		do_div(v64, bt->bitrate);
-		bitrate_error = (u32)v64;
-		if (bitrate_error > CAN_CALC_MAX_ERROR) {
-			netdev_err(dev,
-				   "bitrate error %d.%d%% too high\n",
-				   bitrate_error / 10, bitrate_error % 10);
-			return -EDOM;
-		}
-		netdev_warn(dev, "bitrate error %d.%d%%\n",
-			    bitrate_error / 10, bitrate_error % 10);
-	}
-
-	/* real sample point */
-	bt->sample_point = can_update_sample_point(btc, sample_point_nominal,
-						   best_tseg, &tseg1, &tseg2,
-						   NULL);
-
-	v64 = (u64)best_brp * 1000 * 1000 * 1000;
-	do_div(v64, priv->clock.freq);
-	bt->tq = (u32)v64;
-	bt->prop_seg = tseg1 / 2;
-	bt->phase_seg1 = tseg1 - bt->prop_seg;
-	bt->phase_seg2 = tseg2;
-
-	/* check for sjw user settings */
-	if (!bt->sjw || !btc->sjw_max) {
-		bt->sjw = 1;
-	} else {
-		/* bt->sjw is at least 1 -> sanitize upper bound to sjw_max */
-		if (bt->sjw > btc->sjw_max)
-			bt->sjw = btc->sjw_max;
-		/* bt->sjw must not be higher than tseg2 */
-		if (tseg2 < bt->sjw)
-			bt->sjw = tseg2;
-	}
-
-	bt->brp = best_brp;
-
-	/* real bitrate */
-	bt->bitrate = priv->clock.freq /
-		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
-
-	return 0;
-}
-#else /* !CONFIG_CAN_CALC_BITTIMING */
-static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
-			      const struct can_bittiming_const *btc)
-{
-	netdev_err(dev, "bit-timing calculation not available\n");
-	return -EINVAL;
-}
-#endif /* CONFIG_CAN_CALC_BITTIMING */
-
-/* Checks the validity of the specified bit-timing parameters prop_seg,
- * phase_seg1, phase_seg2 and sjw and tries to determine the bitrate
- * prescaler value brp. You can find more information in the header
- * file linux/can/netlink.h.
- */
-static int can_fixup_bittiming(struct net_device *dev, struct can_bittiming *bt,
-			       const struct can_bittiming_const *btc)
-{
-	struct can_priv *priv = netdev_priv(dev);
-	int tseg1, alltseg;
-	u64 brp64;
-
-	tseg1 = bt->prop_seg + bt->phase_seg1;
-	if (!bt->sjw)
-		bt->sjw = 1;
-	if (bt->sjw > btc->sjw_max ||
-	    tseg1 < btc->tseg1_min || tseg1 > btc->tseg1_max ||
-	    bt->phase_seg2 < btc->tseg2_min || bt->phase_seg2 > btc->tseg2_max)
-		return -ERANGE;
-
-	brp64 = (u64)priv->clock.freq * (u64)bt->tq;
-	if (btc->brp_inc > 1)
-		do_div(brp64, btc->brp_inc);
-	brp64 += 500000000UL - 1;
-	do_div(brp64, 1000000000UL); /* the practicable BRP */
-	if (btc->brp_inc > 1)
-		brp64 *= btc->brp_inc;
-	bt->brp = (u32)brp64;
-
-	if (bt->brp < btc->brp_min || bt->brp > btc->brp_max)
-		return -EINVAL;
-
-	alltseg = bt->prop_seg + bt->phase_seg1 + bt->phase_seg2 + 1;
-	bt->bitrate = priv->clock.freq / (bt->brp * alltseg);
-	bt->sample_point = ((tseg1 + 1) * 1000) / alltseg;
-
-	return 0;
-}
-
-/* Checks the validity of predefined bitrate settings */
-static int
-can_validate_bitrate(struct net_device *dev, struct can_bittiming *bt,
-		     const u32 *bitrate_const,
-		     const unsigned int bitrate_const_cnt)
-{
-	struct can_priv *priv = netdev_priv(dev);
-	unsigned int i;
-
-	for (i = 0; i < bitrate_const_cnt; i++) {
-		if (bt->bitrate == bitrate_const[i])
-			break;
-	}
-
-	if (i >= priv->bitrate_const_cnt)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
-			     const struct can_bittiming_const *btc,
-			     const u32 *bitrate_const,
-			     const unsigned int bitrate_const_cnt)
-{
-	int err;
-
-	/* Depending on the given can_bittiming parameter structure the CAN
-	 * timing parameters are calculated based on the provided bitrate OR
-	 * alternatively the CAN timing parameters (tq, prop_seg, etc.) are
-	 * provided directly which are then checked and fixed up.
-	 */
-	if (!bt->tq && bt->bitrate && btc)
-		err = can_calc_bittiming(dev, bt, btc);
-	else if (bt->tq && !bt->bitrate && btc)
-		err = can_fixup_bittiming(dev, bt, btc);
-	else if (!bt->tq && bt->bitrate && bitrate_const)
-		err = can_validate_bitrate(dev, bt, bitrate_const,
-					   bitrate_const_cnt);
-	else
-		err = -EINVAL;
-
-	return err;
-}
-
 static void can_update_state_error_stats(struct net_device *dev,
 					 enum can_state new_state)
 {
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
new file mode 100644
index 000000000000..707575c668f4
--- /dev/null
+++ b/include/linux/can/bittiming.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2020 Pengutronix, Marc Kleine-Budde <kernel@pengutronix.de>
+ */
+
+#ifndef _CAN_BITTIMING_H
+#define _CAN_BITTIMING_H
+
+#include <linux/netdevice.h>
+#include <linux/can/netlink.h>
+
+#define CAN_SYNC_SEG 1
+
+#ifdef CONFIG_CAN_CALC_BITTIMING
+int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+		       const struct can_bittiming_const *btc);
+#else /* !CONFIG_CAN_CALC_BITTIMING */
+static inline int
+can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+		   const struct can_bittiming_const *btc)
+{
+	netdev_err(dev, "bit-timing calculation not available\n");
+	return -EINVAL;
+}
+#endif /* CONFIG_CAN_CALC_BITTIMING */
+
+int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
+		      const struct can_bittiming_const *btc,
+		      const u32 *bitrate_const,
+		      const unsigned int bitrate_const_cnt);
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
+#endif /* !_CAN_BITTIMING_H */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 197a79535cc2..054c3bed190b 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -15,6 +15,7 @@
 #define _CAN_DEV_H
 
 #include <linux/can.h>
+#include <linux/can/bittiming.h>
 #include <linux/can/error.h>
 #include <linux/can/led.h>
 #include <linux/can/netlink.h>
@@ -82,21 +83,6 @@ struct can_priv {
 #endif
 };
 
-#define CAN_SYNC_SEG 1
-
-/*
- * can_bit_time() - Duration of one bit
- *
- * Please refer to ISO 11898-1:2015, section 11.3.1.1 "Bit time" for
- * additional information.
- *
- * Return: the number of time quanta in one bit.
- */
-static inline unsigned int can_bit_time(const struct can_bittiming *bt)
-{
-	return CAN_SYNC_SEG + bt->prop_seg + bt->phase_seg1 + bt->phase_seg2;
-}
-
 /*
  * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
  * Classical CAN frame into a valid data length of max. 8 bytes.
-- 
2.29.2


