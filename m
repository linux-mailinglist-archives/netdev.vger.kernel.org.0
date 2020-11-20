Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492D72BAB2C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgKTNd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKTNdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0DFC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XR-0006Fn-Ux; Fri, 20 Nov 2020 14:33:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 02/25] can: add optional DLC element to Classical CAN frame structure
Date:   Fri, 20 Nov 2020 14:32:55 +0100
Message-Id: <20201120133318.3428231-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

ISO 11898-1 Chapter 8.4.2.3 defines a 4 bit data length code (DLC) table which
maps the DLC to the payload length of the CAN frame in bytes:

    DLC      ->  payload length
    0 .. 8   ->  0 .. 8
    9 .. 15  ->  8

Although the DLC values 8 .. 15 in Classical CAN always result in a payload
length of 8 bytes these DLC values are transparently transmitted on the CAN
bus. As the struct can_frame only provides a 'len' element (formerly 'can_dlc')
which contains the plain payload length ( 0 .. 8 ) of the CAN frame, the raw
DLC is not visible to the application programmer, e.g. for testing use-cases.

To access the raw DLC values 9 .. 15 the len8_dlc element is introduced, which
is only valid when the payload length 'len' is 8 and the DLC is greater than 8.

The len8_dlc element is filled by the CAN interface driver and used for CAN
frame creation by the CAN driver when the CAN_CTRLMODE_CC_LEN8_DLC flag is
supported by the driver and enabled via netlink configuration interface.

Reported-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201110101852.1973-2-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can.h         | 38 ++++++++++++++++++++------------
 include/uapi/linux/can/netlink.h |  1 +
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 6a6d2c7655ff..f75238ac6dce 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -84,6 +84,7 @@ typedef __u32 can_err_mask_t;
 
 /* CAN payload length and DLC definitions according to ISO 11898-1 */
 #define CAN_MAX_DLC 8
+#define CAN_MAX_RAW_DLC 15
 #define CAN_MAX_DLEN 8
 
 /* CAN FD payload length and DLC definitions according to ISO 11898-7 */
@@ -91,23 +92,32 @@ typedef __u32 can_err_mask_t;
 #define CANFD_MAX_DLEN 64
 
 /**
- * struct can_frame - basic CAN frame structure
- * @can_id:  CAN ID of the frame and CAN_*_FLAG flags, see canid_t definition
- * @can_dlc: frame payload length in byte (0 .. 8) aka data length code
- *           N.B. the DLC field from ISO 11898-1 Chapter 8.4.2.3 has a 1:1
- *           mapping of the 'data length code' to the real payload length
- * @__pad:   padding
- * @__res0:  reserved / padding
- * @__res1:  reserved / padding
- * @data:    CAN frame payload (up to 8 byte)
+ * struct can_frame - Classical CAN frame structure (aka CAN 2.0B)
+ * @can_id:   CAN ID of the frame and CAN_*_FLAG flags, see canid_t definition
+ * @len:      CAN frame payload length in byte (0 .. 8)
+ * @can_dlc:  deprecated name for CAN frame payload length in byte (0 .. 8)
+ * @__pad:    padding
+ * @__res0:   reserved / padding
+ * @len8_dlc: optional DLC value (9 .. 15) at 8 byte payload length
+ *            len8_dlc contains values from 9 .. 15 when the payload length is
+ *            8 bytes but the DLC value (see ISO 11898-1) is greater then 8.
+ *            CAN_CTRLMODE_CC_LEN8_DLC flag has to be enabled in CAN driver.
+ * @data:     CAN frame payload (up to 8 byte)
  */
 struct can_frame {
 	canid_t can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
-	__u8    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
-	__u8    __pad;   /* padding */
-	__u8    __res0;  /* reserved / padding */
-	__u8    __res1;  /* reserved / padding */
-	__u8    data[CAN_MAX_DLEN] __attribute__((aligned(8)));
+	union {
+		/* CAN frame payload length in byte (0 .. CAN_MAX_DLEN)
+		 * was previously named can_dlc so we need to carry that
+		 * name for legacy support
+		 */
+		__u8 len;
+		__u8 can_dlc; /* deprecated */
+	};
+	__u8 __pad; /* padding */
+	__u8 __res0; /* reserved / padding */
+	__u8 len8_dlc; /* optional DLC for 8 byte payload length (9 .. 15) */
+	__u8 data[CAN_MAX_DLEN] __attribute__((aligned(8)));
 };
 
 /*
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 6f598b73839e..f730d443b918 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -100,6 +100,7 @@ struct can_ctrlmode {
 #define CAN_CTRLMODE_FD			0x20	/* CAN FD mode */
 #define CAN_CTRLMODE_PRESUME_ACK	0x40	/* Ignore missing CAN ACKs */
 #define CAN_CTRLMODE_FD_NON_ISO		0x80	/* CAN FD in non-ISO mode */
+#define CAN_CTRLMODE_CC_LEN8_DLC	0x100	/* Classic CAN DLC option */
 
 /*
  * CAN device statistics
-- 
2.29.2

