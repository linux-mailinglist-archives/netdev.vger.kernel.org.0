Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDE52BAB45
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgKTNdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKTNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38236C061A49
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XU-0006Fn-8t; Fri, 20 Nov 2020 14:33:24 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 07/25] can: update documentation for DLC usage in Classical CAN
Date:   Fri, 20 Nov 2020 14:33:00 +0100
Message-Id: <20201120133318.3428231-8-mkl@pengutronix.de>
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

The extension of struct can_frame with the len8_dlc element and the
can_dlc naming issue required an update of the documentation.

Additionally introduce the term 'Classical CAN' which has been established
by CAN in Automation to separate the original CAN2.0 A/B from CAN FD.

Updated some data structures and flags.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201110101852.1973-7-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/can.rst | 68 ++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index 4895b0dd2714..f8dae662e454 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -228,20 +228,36 @@ send(2), sendto(2), sendmsg(2) and the recv* counterpart operations
 on the socket as usual. There are also CAN specific socket options
 described below.
 
-The basic CAN frame structure and the sockaddr structure are defined
-in include/linux/can.h:
+The Classical CAN frame structure (aka CAN 2.0B), the CAN FD frame structure
+and the sockaddr structure are defined in include/linux/can.h:
 
 .. code-block:: C
 
     struct can_frame {
             canid_t can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
-            __u8    can_dlc; /* frame payload length in byte (0 .. 8) */
+            union {
+                    /* CAN frame payload length in byte (0 .. CAN_MAX_DLEN)
+                     * was previously named can_dlc so we need to carry that
+                     * name for legacy support
+                     */
+                    __u8 len;
+                    __u8 can_dlc; /* deprecated */
+            };
             __u8    __pad;   /* padding */
             __u8    __res0;  /* reserved / padding */
-            __u8    __res1;  /* reserved / padding */
+            __u8    len8_dlc; /* optional DLC for 8 byte payload length (9 .. 15) */
             __u8    data[8] __attribute__((aligned(8)));
     };
 
+Remark: The len element contains the payload length in bytes and should be
+used instead of can_dlc. The deprecated can_dlc was misleadingly named as
+it always contained the plain payload length in bytes and not the so called
+'data length code' (DLC).
+
+To pass the raw DLC from/to a Classical CAN network device the len8_dlc
+element can contain values 9 .. 15 when the len element is 8 (the real
+payload length for all DLC values greater or equal to 8).
+
 The alignment of the (linear) payload data[] to a 64bit boundary
 allows the user to define their own structs and unions to easily access
 the CAN payload. There is no given byteorder on the CAN bus by
@@ -260,6 +276,23 @@ PF_PACKET socket, that also binds to a specific interface:
                     /* transport protocol class address info (e.g. ISOTP) */
                     struct { canid_t rx_id, tx_id; } tp;
 
+                    /* J1939 address information */
+                    struct {
+                            /* 8 byte name when using dynamic addressing */
+                            __u64 name;
+
+                            /* pgn:
+                             * 8 bit: PS in PDU2 case, else 0
+                             * 8 bit: PF
+                             * 1 bit: DP
+                             * 1 bit: reserved
+                             */
+                            __u32 pgn;
+
+                            /* 1 byte address */
+                            __u8 addr;
+                    } j1939;
+
                     /* reserved for future CAN protocols address information */
             } can_addr;
     };
@@ -371,7 +404,7 @@ kernel interfaces (ABI) which heavily rely on the CAN frame with fixed eight
 bytes of payload (struct can_frame) like the CAN_RAW socket. Therefore e.g.
 the CAN_RAW socket supports a new socket option CAN_RAW_FD_FRAMES that
 switches the socket into a mode that allows the handling of CAN FD frames
-and (legacy) CAN frames simultaneously (see :ref:`socketcan-rawfd`).
+and Classical CAN frames simultaneously (see :ref:`socketcan-rawfd`).
 
 The struct canfd_frame is defined in include/linux/can.h:
 
@@ -397,7 +430,7 @@ code (DLC) of the struct can_frame was used as a length information as the
 length and the DLC has a 1:1 mapping in the range of 0 .. 8. To preserve
 the easy handling of the length information the canfd_frame.len element
 contains a plain length value from 0 .. 64. So both canfd_frame.len and
-can_frame.can_dlc are equal and contain a length information and no DLC.
+can_frame.len are equal and contain a length information and no DLC.
 For details about the distinction of CAN and CAN FD capable devices and
 the mapping to the bus-relevant data length code (DLC), see :ref:`socketcan-can-fd-driver`.
 
@@ -407,7 +440,7 @@ definitions are specified for CAN specific MTUs in include/linux/can.h:
 
 .. code-block:: C
 
-  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => 'legacy' CAN frame
+  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => Classical CAN frame
   #define CANFD_MTU (sizeof(struct canfd_frame)) == 72  => CAN FD frame
 
 
@@ -609,7 +642,7 @@ Example:
             printf("got CAN FD frame with length %d\n", cfd.len);
             /* cfd.flags contains valid data */
     } else if (nbytes == CAN_MTU) {
-            printf("got legacy CAN frame with length %d\n", cfd.len);
+            printf("got Classical CAN frame with length %d\n", cfd.len);
             /* cfd.flags is undefined */
     } else {
             fprintf(stderr, "read: invalid CAN(FD) frame\n");
@@ -623,7 +656,7 @@ Example:
             printf("%02X ", cfd.data[i]);
 
 When reading with size CANFD_MTU only returns CAN_MTU bytes that have
-been received from the socket a legacy CAN frame has been read into the
+been received from the socket a Classical CAN frame has been read into the
 provided CAN FD structure. Note that the canfd_frame.flags data field is
 not specified in the struct can_frame and therefore it is only valid in
 CANFD_MTU sized CAN FD frames.
@@ -633,7 +666,7 @@ Implementation hint for new CAN applications:
 To build a CAN FD aware application use struct canfd_frame as basic CAN
 data structure for CAN_RAW based applications. When the application is
 executed on an older Linux kernel and switching the CAN_RAW_FD_FRAMES
-socket option returns an error: No problem. You'll get legacy CAN frames
+socket option returns an error: No problem. You'll get Classical CAN frames
 or CAN FD frames and can process them the same way.
 
 When sending to CAN devices make sure that the device is capable to handle
@@ -842,6 +875,8 @@ TX_RESET_MULTI_IDX:
 RX_RTR_FRAME:
 	Send reply for RTR-request (placed in op->frames[0]).
 
+CAN_FD_FRAME:
+	The CAN frames following the bcm_msg_head are struct canfd_frame's
 
 Broadcast Manager Transmission Timers
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -1026,7 +1061,7 @@ Additional procfs files in /proc/net/can::
 
     stats       - SocketCAN core statistics (rx/tx frames, match ratios, ...)
     reset_stats - manual statistic reset
-    version     - prints the SocketCAN core version and the ABI version
+    version     - prints SocketCAN core and ABI version (removed in Linux 5.10)
 
 
 Writing Own CAN Protocol Modules
@@ -1070,7 +1105,7 @@ General Settings
     dev->type  = ARPHRD_CAN; /* the netdevice hardware type */
     dev->flags = IFF_NOARP;  /* CAN has no arp */
 
-    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> legacy CAN interface */
+    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> Classical CAN interface */
 
     or alternative, when the controller supports CAN with flexible data rate:
     dev->mtu = CANFD_MTU; /* sizeof(struct canfd_frame) -> CAN FD interface */
@@ -1184,6 +1219,7 @@ Setting CAN device properties::
         [ fd { on | off } ]
         [ fd-non-iso { on | off } ]
         [ presume-ack { on | off } ]
+        [ cc-len8-dlc { on | off } ]
 
         [ restart-ms TIME-MS ]
         [ restart ]
@@ -1326,10 +1362,10 @@ arbitration phase and the payload phase of the CAN FD frame. Therefore a
 second bit timing has to be specified in order to enable the CAN FD bitrate.
 
 Additionally CAN FD capable CAN controllers support up to 64 bytes of
-payload. The representation of this length in can_frame.can_dlc and
+payload. The representation of this length in can_frame.len and
 canfd_frame.len for userspace applications and inside the Linux network
 layer is a plain value from 0 .. 64 instead of the CAN 'data length code'.
-The data length code was a 1:1 mapping to the payload length in the legacy
+The data length code was a 1:1 mapping to the payload length in the Classical
 CAN frames anyway. The payload length to the bus-relevant DLC mapping is
 only performed inside the CAN drivers, preferably with the helper
 functions can_fd_dlc2len() and can_fd_len2dlc().
@@ -1337,11 +1373,11 @@ functions can_fd_dlc2len() and can_fd_len2dlc().
 The CAN netdevice driver capabilities can be distinguished by the network
 devices maximum transfer unit (MTU)::
 
-  MTU = 16 (CAN_MTU)   => sizeof(struct can_frame)   => 'legacy' CAN device
+  MTU = 16 (CAN_MTU)   => sizeof(struct can_frame)   => Classical CAN device
   MTU = 72 (CANFD_MTU) => sizeof(struct canfd_frame) => CAN FD capable device
 
 The CAN device MTU can be retrieved e.g. with a SIOCGIFMTU ioctl() syscall.
-N.B. CAN FD capable devices can also handle and send legacy CAN frames.
+N.B. CAN FD capable devices can also handle and send Classical CAN frames.
 
 When configuring CAN FD capable CAN controllers an additional 'data' bitrate
 has to be set. This bitrate for the data phase of the CAN FD frame has to be
-- 
2.29.2

