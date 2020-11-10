Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7022AD371
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgKJKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:19:08 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:23328 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731008AbgKJKTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003543;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=MTQtC6hu8jphXFm30aQ9c48BEEYCvjQQKzJ5LYSSuWA=;
        b=neypGtT67+tRs+DxiGHWDeVnD/qp3rtB2f0Pxvi4tZ5f11M9+7j9w56DyhHZmFzd/t
        v/pVpNAAVDS4YayHHbjIyIvZPnkbU85/id7Zu+MvGYBt7m6Qho+Bd+qJOWcgOGGQoQ38
        c/lAB97Kb+FEN2dKxAECxyM+lqBBJ3l8LgYbDPNimBjJVBAc2QIqZhvRyGj/+4CIB6z6
        qtztqEERGfFtAyulvnJrFhjRpOITGODlco6ohwpHcokVSqrx/n3qdrfkcSBzb2vt9L+f
        8H+QO+6THySxXUOBYIZ4ux6Z2WInIicvX6FyQ4glWhWKT8VqQYaj1y5sZqFEXDlURkWf
        oitw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsi+/Fw=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAJ1AQd
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:19:01 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v6 1/8] can: add optional DLC element to Classical CAN frame structure
Date:   Tue, 10 Nov 2020 11:18:45 +0100
Message-Id: <20201110101852.1973-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110101852.1973-1-socketcan@hartkopp.net>
References: <20201110101852.1973-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/uapi/linux/can.h         | 38 ++++++++++++++++++++------------
 include/uapi/linux/can/netlink.h |  1 +
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 6a6d2c7655ff..f75238ac6dce 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -82,34 +82,44 @@ typedef __u32 canid_t;
  */
 typedef __u32 can_err_mask_t;
 
 /* CAN payload length and DLC definitions according to ISO 11898-1 */
 #define CAN_MAX_DLC 8
+#define CAN_MAX_RAW_DLC 15
 #define CAN_MAX_DLEN 8
 
 /* CAN FD payload length and DLC definitions according to ISO 11898-7 */
 #define CANFD_MAX_DLC 15
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
  * defined bits for canfd_frame.flags
  *
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 6f598b73839e..f730d443b918 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -98,10 +98,11 @@ struct can_ctrlmode {
 #define CAN_CTRLMODE_ONE_SHOT		0x08	/* One-Shot mode */
 #define CAN_CTRLMODE_BERR_REPORTING	0x10	/* Bus-error reporting */
 #define CAN_CTRLMODE_FD			0x20	/* CAN FD mode */
 #define CAN_CTRLMODE_PRESUME_ACK	0x40	/* Ignore missing CAN ACKs */
 #define CAN_CTRLMODE_FD_NON_ISO		0x80	/* CAN FD in non-ISO mode */
+#define CAN_CTRLMODE_CC_LEN8_DLC	0x100	/* Classic CAN DLC option */
 
 /*
  * CAN device statistics
  */
 struct can_device_stats {
-- 
2.28.0

