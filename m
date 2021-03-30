Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897E34E68D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhC3Lqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhC3LqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CB7C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCp4-0005kq-LX
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 67F43603E0D
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0ED0F603DCD;
        Tue, 30 Mar 2021 11:46:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7360d24f;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 06/39] can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
Date:   Tue, 30 Mar 2021 13:45:26 +0200
Message-Id: <20210330114559.1114855-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

At high bit rates, the propagation delay from the TX pin to the RX pin
of the transceiver causes measurement errors: the sample point on the
RX pin might occur on the previous bit.

This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
delay compensation" (TDC).

This patch adds two new structures: can_tdc and can_tdc_const in order
to implement this TDC.

The structures are then added to can_priv.

A controller supports TDC if an only if can_priv::tdc_const is not
NULL.

TDC is active if and only if:
  - fd flag is on
  - can_priv::tdc.tdco is not zero.
It is the driver responsibility to check those two conditions are met.

No new controller modes are introduced (i.e. no CAN_CTRL_MODE_TDC) in
order not to be redundant with above logic.

The names of the parameters are chosen to match existing CAN
controllers specification. References:
  - Bosch C_CAN FD8:
https://www.bosch-semiconductors.com/media/ip_modules/pdf_2/c_can_fd8/users_manual_c_can_fd8_r210_1.pdf
  - Microchip CAN FD Controller Module:
http://ww1.microchip.com/downloads/en/DeviceDoc/MCP251XXFD-CAN-FD-Controller-Module-Family-Reference-Manual-20005678B.pdf
  - SAM E701/S70/V70/V71 Family:
https://www.mouser.com/datasheet/2/268/60001527A-1284321.pdf

Link: https://lore.kernel.org/r/20210224002008.4158-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/bittiming.h | 65 +++++++++++++++++++++++++++++++++++
 include/linux/can/dev.h       |  3 ++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 707575c668f4..b31a49f19b47 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /* Copyright (c) 2020 Pengutronix, Marc Kleine-Budde <kernel@pengutronix.de>
+ * Copyright (c) 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
 #ifndef _CAN_BITTIMING_H
@@ -10,6 +11,70 @@
 
 #define CAN_SYNC_SEG 1
 
+/*
+ * struct can_tdc - CAN FD Transmission Delay Compensation parameters
+ *
+ * At high bit rates, the propagation delay from the TX pin to the RX
+ * pin of the transceiver causes measurement errors: the sample point
+ * on the RX pin might occur on the previous bit.
+ *
+ * To solve this issue, ISO 11898-1 introduces in section 11.3.3
+ * "Transmitter delay compensation" a SSP (Secondary Sample Point)
+ * equal to the distance, in time quanta, from the start of the bit
+ * time on the TX pin to the actual measurement on the RX pin.
+ *
+ * This structure contains the parameters to calculate that SSP.
+ *
+ * @tdcv: Transmitter Delay Compensation Value. Distance, in time
+ *	quanta, from when the bit is sent on the TX pin to when it is
+ *	received on the RX pin of the transmitter. Possible options:
+ *
+ *	  O: automatic mode. The controller dynamically measure @tdcv
+ *	  for each transmitted CAN FD frame.
+ *
+ *	  Other values: manual mode. Use the fixed provided value.
+ *
+ * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
+ *	quanta, defining the distance between the start of the bit
+ *	reception on the RX pin of the transceiver and the SSP
+ *	position such as SSP = @tdcv + @tdco.
+ *
+ *	If @tdco is zero, then TDC is disabled and both @tdcv and
+ *	@tdcf should be ignored.
+ *
+ * @tdcf: Transmitter Delay Compensation Filter window. Defines the
+ *	minimum value for the SSP position in time quanta. If SSP is
+ *	less than @tdcf, then no delay compensations occur and the
+ *	normal sampling point is used instead. The feature is enabled
+ *	if and only if @tdcv is set to zero (automatic mode) and @tdcf
+ *	is configured to a value greater than @tdco.
+ */
+struct can_tdc {
+	u32 tdcv;
+	u32 tdco;
+	u32 tdcf;
+};
+
+/*
+ * struct can_tdc_const - CAN hardware-dependent constant for
+ *	Transmission Delay Compensation
+ *
+ * @tdcv_max: Transmitter Delay Compensation Value maximum value.
+ *	Should be set to zero if the controller does not support
+ *	manual mode for tdcv.
+ * @tdco_max: Transmitter Delay Compensation Offset maximum value.
+ *	Should not be zero. If the controller does not support TDC,
+ *	then the pointer to this structure should be NULL.
+ * @tdcf_max: Transmitter Delay Compensation Filter window maximum
+ *	value. Should be set to zero if the controller does not
+ *	support this feature.
+ */
+struct can_tdc_const {
+	u32 tdcv_max;
+	u32 tdco_max;
+	u32 tdcf_max;
+};
+
 #ifdef CONFIG_CAN_CALC_BITTIMING
 int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index ac4d83a1ab81..4795da0eb949 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -42,6 +42,9 @@ struct can_priv {
 	struct can_bittiming bittiming, data_bittiming;
 	const struct can_bittiming_const *bittiming_const,
 		*data_bittiming_const;
+	struct can_tdc tdc;
+	const struct can_tdc_const *tdc_const;
+
 	const u16 *termination_const;
 	unsigned int termination_const_cnt;
 	u16 termination;
-- 
2.30.2


