Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053DF2F583E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbhANCQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbhAMVQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:16:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6CC061382
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:14:34 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznTN-0001vC-3X
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:14:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E74045C3075
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:14:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 47C5E5C300F;
        Wed, 13 Jan 2021 21:14:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3292b448;
        Wed, 13 Jan 2021 21:14:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 11/17] can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer
Date:   Wed, 13 Jan 2021 22:14:04 +0100
Message-Id: <20210113211410.917108-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113211410.917108-1-mkl@pengutronix.de>
References: <20210113211410.917108-1-mkl@pengutronix.de>
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

This patch adds the function can_skb_get_frame_len() which returns the length
of a CAN frame on the data link layer, including Start-of-frame, Identifier,
various other bits, the actual data, the CRC, the End-of-frame, the Inter frame
spacing.

Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Co-developed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20210111141930.693847-11-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/length.c |  50 +++++++++++++++
 include/linux/can/length.h   | 120 +++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
index d695a3bee1ed..20cd153a45a5 100644
--- a/drivers/net/can/dev/length.c
+++ b/drivers/net/can/dev/length.c
@@ -38,3 +38,53 @@ u8 can_fd_len2dlc(u8 len)
 	return len2dlc[len];
 }
 EXPORT_SYMBOL_GPL(can_fd_len2dlc);
+
+/**
+ * can_skb_get_frame_len() - Calculate the CAN Frame length in bytes
+ * 	of a given skb.
+ * @skb: socket buffer of a CAN message.
+ *
+ * Do a rough calculation: bit stuffing is ignored and length in bits
+ * is rounded up to a length in bytes.
+ *
+ * Rationale: this function is to be used for the BQL functions
+ * (netdev_sent_queue() and netdev_completed_queue()) which expect a
+ * value in bytes. Just using skb->len is insufficient because it will
+ * return the constant value of CAN(FD)_MTU. Doing the bit stuffing
+ * calculation would be too expensive in term of computing resources
+ * for no noticeable gain.
+ *
+ * Remarks: The payload of CAN FD frames with BRS flag are sent at a
+ * different bitrate. Currently, the can-utils canbusload tool does
+ * not support CAN-FD yet and so we could not run any benchmark to
+ * measure the impact. There might be possible improvement here.
+ *
+ * Return: length in bytes.
+ */
+unsigned int can_skb_get_frame_len(const struct sk_buff *skb)
+{
+	const struct canfd_frame *cf = (const struct canfd_frame *)skb->data;
+	u8 len;
+
+	if (can_is_canfd_skb(skb))
+		len = canfd_sanitize_len(cf->len);
+	else if (cf->can_id & CAN_RTR_FLAG)
+		len = 0;
+	else
+		len = cf->len;
+
+	if (can_is_canfd_skb(skb)) {
+		if (cf->can_id & CAN_EFF_FLAG)
+			len += CANFD_FRAME_OVERHEAD_EFF;
+		else
+			len += CANFD_FRAME_OVERHEAD_SFF;
+	} else {
+		if (cf->can_id & CAN_EFF_FLAG)
+			len += CAN_FRAME_OVERHEAD_EFF;
+		else
+			len += CAN_FRAME_OVERHEAD_SFF;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(can_skb_get_frame_len);
diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index b2313b2a0b02..6995092b774e 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,10 +1,127 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2020 Oliver Hartkopp <socketcan@hartkopp.net>
+ * Copyright (C) 2020 Marc Kleine-Budde <kernel@pengutronix.de>
  */
 
 #ifndef _CAN_LENGTH_H
 #define _CAN_LENGTH_H
 
+/*
+ * Size of a Classical CAN Standard Frame
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Start-of-frame			1
+ * Identifier				11
+ * Remote transmission request (RTR)	1
+ * Identifier extension bit (IDE)	1
+ * Reserved bit (r0)			1
+ * Data length code (DLC)		4
+ * Data field				0...64
+ * CRC					15
+ * CRC delimiter			1
+ * ACK slot				1
+ * ACK delimiter			1
+ * End-of-frame (EOF)			7
+ * Inter frame spacing			3
+ *
+ * rounded up and ignoring bitstuffing
+ */
+#define CAN_FRAME_OVERHEAD_SFF DIV_ROUND_UP(47, 8)
+
+/*
+ * Size of a Classical CAN Extended Frame
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Start-of-frame			1
+ * Identifier A				11
+ * Substitute remote request (SRR)	1
+ * Identifier extension bit (IDE)	1
+ * Identifier B				18
+ * Remote transmission request (RTR)	1
+ * Reserved bits (r1, r0)		2
+ * Data length code (DLC)		4
+ * Data field				0...64
+ * CRC					15
+ * CRC delimiter			1
+ * ACK slot				1
+ * ACK delimiter			1
+ * End-of-frame (EOF)			7
+ * Inter frame spacing			3
+ *
+ * rounded up and ignoring bitstuffing
+ */
+#define CAN_FRAME_OVERHEAD_EFF DIV_ROUND_UP(67, 8)
+
+/*
+ * Size of a CAN-FD Standard Frame
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Start-of-frame			1
+ * Identifier				11
+ * Reserved bit (r1)			1
+ * Identifier extension bit (IDE)	1
+ * Flexible data rate format (FDF)	1
+ * Reserved bit (r0)			1
+ * Bit Rate Switch (BRS)		1
+ * Error Status Indicator (ESI)		1
+ * Data length code (DLC)		4
+ * Data field				0...512
+ * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * CRC					0...16: 17 20...64:21
+ * CRC delimiter (CD)			1
+ * ACK slot (AS)			1
+ * ACK delimiter (AD)			1
+ * End-of-frame (EOF)			7
+ * Inter frame spacing			3
+ *
+ * assuming CRC21, rounded up and ignoring bitstuffing
+ */
+#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(61, 8)
+
+/*
+ * Size of a CAN-FD Extended Frame
+ *
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Start-of-frame			1
+ * Identifier A				11
+ * Substitute remote request (SRR)	1
+ * Identifier extension bit (IDE)	1
+ * Identifier B				18
+ * Reserved bit (r1)			1
+ * Flexible data rate format (FDF)	1
+ * Reserved bit (r0)			1
+ * Bit Rate Switch (BRS)		1
+ * Error Status Indicator (ESI)		1
+ * Data length code (DLC)		4
+ * Data field				0...512
+ * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * CRC					0...16: 17 20...64:21
+ * CRC delimiter (CD)			1
+ * ACK slot (AS)			1
+ * ACK delimiter (AD)			1
+ * End-of-frame (EOF)			7
+ * Inter frame spacing			3
+ *
+ * assuming CRC21, rounded up and ignoring bitstuffing
+ */
+#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(80, 8)
+
+/*
+ * Maximum size of a Classical CAN frame
+ * (rounded up and ignoring bitstuffing)
+ */
+#define CAN_FRAME_LEN_MAX (CAN_FRAME_OVERHEAD_EFF + CAN_MAX_DLEN)
+
+/*
+ * Maximum size of a CAN-FD frame
+ * (rounded up and ignoring bitstuffing)
+ */
+#define CANFD_FRAME_LEN_MAX (CANFD_FRAME_OVERHEAD_EFF + CANFD_MAX_DLEN)
+
 /*
  * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
  * Classical CAN frame into a valid data length of max. 8 bytes.
@@ -45,6 +162,9 @@ u8 can_fd_dlc2len(u8 dlc);
 /* map the sanitized data length to an appropriate data length code */
 u8 can_fd_len2dlc(u8 len);
 
+/* calculate the CAN Frame length in bytes of a given skb */
+unsigned int can_skb_get_frame_len(const struct sk_buff *skb);
+
 /* map the data length to an appropriate data link layer length */
 static inline u8 canfd_sanitize_len(u8 len)
 {
-- 
2.29.2


