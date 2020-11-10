Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423632AD36C
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgKJKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:19:13 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:25374 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731327AbgKJKTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003546;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=0tSZQqbLxMtOAQqSv7xXuQUjGz61FmSkW4Hx2u7TkDg=;
        b=oElOmSizep+i/oJRcy/crHxnUV7PcXfFt7RDLik55e9O2CYCYh6hh9ihZ4/OR4o4cr
        o3eUhCZ06atguuWLGmkalYUQv0nNQ9u/CSvjP6eknLmuaEOaoPEjPsxdOIFwM8tI+ZfT
        hGLGVlx3TjNuffaUbBSuOdom9NFkS9XULFu/eCTBZDlz53SHBIWV6eDkzC7hiC/mn7Xu
        P1j3JG6hEnGjSMKXUxC7N0Qdy9l4J0c2/kWj88fk3XDQe5znNVBvDO6gaLyPmyyJ2rhK
        AjfpgcPCl3w0O/pjbSqaHp3OYhk3s1h38hGRYh2aYWH/UgQRuRdLT9q/Ta2plXktlOgI
        0ASA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsi+/Fw=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAJ3AQi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:19:03 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v6 6/8] can: update documentation for DLC usage in Classical CAN
Date:   Tue, 10 Nov 2020 11:18:50 +0100
Message-Id: <20201110101852.1973-7-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110101852.1973-1-socketcan@hartkopp.net>
References: <20201110101852.1973-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The extension of struct can_frame with the len8_dlc element and the
can_dlc naming issue required an update of the documentation.

Additionally introduce the term 'Classical CAN' which has been established
by CAN in Automation to separate the original CAN2.0 A/B from CAN FD.

Updated some data structures and flags.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 Documentation/networking/can.rst | 68 ++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index 4895b0dd2714..f8dae662e454 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -226,24 +226,40 @@ interface (which is different from TCP/IP due to different addressing
 the socket, you can read(2) and write(2) from/to the socket or use
 send(2), sendto(2), sendmsg(2) and the recv* counterpart operations
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
 default. A read(2) system call on a CAN_RAW socket transfers a
 struct can_frame to the user space.
@@ -258,10 +274,27 @@ PF_PACKET socket, that also binds to a specific interface:
             int         can_ifindex;
             union {
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
 
 To determine the interface index an appropriate ioctl() has to
@@ -369,11 +402,11 @@ bitrates for the arbitration phase and the payload phase of the CAN FD frame
 and up to 64 bytes of payload. This extended payload length breaks all the
 kernel interfaces (ABI) which heavily rely on the CAN frame with fixed eight
 bytes of payload (struct can_frame) like the CAN_RAW socket. Therefore e.g.
 the CAN_RAW socket supports a new socket option CAN_RAW_FD_FRAMES that
 switches the socket into a mode that allows the handling of CAN FD frames
-and (legacy) CAN frames simultaneously (see :ref:`socketcan-rawfd`).
+and Classical CAN frames simultaneously (see :ref:`socketcan-rawfd`).
 
 The struct canfd_frame is defined in include/linux/can.h:
 
 .. code-block:: C
 
@@ -395,21 +428,21 @@ all structure elements can be used as-is - only the data[] becomes extended.
 When introducing the struct canfd_frame it turned out that the data length
 code (DLC) of the struct can_frame was used as a length information as the
 length and the DLC has a 1:1 mapping in the range of 0 .. 8. To preserve
 the easy handling of the length information the canfd_frame.len element
 contains a plain length value from 0 .. 64. So both canfd_frame.len and
-can_frame.can_dlc are equal and contain a length information and no DLC.
+can_frame.len are equal and contain a length information and no DLC.
 For details about the distinction of CAN and CAN FD capable devices and
 the mapping to the bus-relevant data length code (DLC), see :ref:`socketcan-can-fd-driver`.
 
 The length of the two CAN(FD) frame structures define the maximum transfer
 unit (MTU) of the CAN(FD) network interface and skbuff data length. Two
 definitions are specified for CAN specific MTUs in include/linux/can.h:
 
 .. code-block:: C
 
-  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => 'legacy' CAN frame
+  #define CAN_MTU   (sizeof(struct can_frame))   == 16  => Classical CAN frame
   #define CANFD_MTU (sizeof(struct canfd_frame)) == 72  => CAN FD frame
 
 
 .. _socketcan-raw-sockets:
 
@@ -607,11 +640,11 @@ Example:
 
     if (nbytes == CANFD_MTU) {
             printf("got CAN FD frame with length %d\n", cfd.len);
             /* cfd.flags contains valid data */
     } else if (nbytes == CAN_MTU) {
-            printf("got legacy CAN frame with length %d\n", cfd.len);
+            printf("got Classical CAN frame with length %d\n", cfd.len);
             /* cfd.flags is undefined */
     } else {
             fprintf(stderr, "read: invalid CAN(FD) frame\n");
             return 1;
     }
@@ -621,21 +654,21 @@ Example:
     printf("can_id: %X data length: %d data: ", cfd.can_id, cfd.len);
     for (i = 0; i < cfd.len; i++)
             printf("%02X ", cfd.data[i]);
 
 When reading with size CANFD_MTU only returns CAN_MTU bytes that have
-been received from the socket a legacy CAN frame has been read into the
+been received from the socket a Classical CAN frame has been read into the
 provided CAN FD structure. Note that the canfd_frame.flags data field is
 not specified in the struct can_frame and therefore it is only valid in
 CANFD_MTU sized CAN FD frames.
 
 Implementation hint for new CAN applications:
 
 To build a CAN FD aware application use struct canfd_frame as basic CAN
 data structure for CAN_RAW based applications. When the application is
 executed on an older Linux kernel and switching the CAN_RAW_FD_FRAMES
-socket option returns an error: No problem. You'll get legacy CAN frames
+socket option returns an error: No problem. You'll get Classical CAN frames
 or CAN FD frames and can process them the same way.
 
 When sending to CAN devices make sure that the device is capable to handle
 CAN FD frames by checking if the device maximum transfer unit is CANFD_MTU.
 The CAN device MTU can be retrieved e.g. with a SIOCGIFMTU ioctl() syscall.
@@ -840,10 +873,12 @@ TX_RESET_MULTI_IDX:
 	Reset the index for the multiple frame transmission.
 
 RX_RTR_FRAME:
 	Send reply for RTR-request (placed in op->frames[0]).
 
+CAN_FD_FRAME:
+	The CAN frames following the bcm_msg_head are struct canfd_frame's
 
 Broadcast Manager Transmission Timers
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Periodic transmission configurations may use up to two interval timers.
@@ -1024,11 +1059,11 @@ In this example an application requests any CAN traffic from vcan0::
 
 Additional procfs files in /proc/net/can::
 
     stats       - SocketCAN core statistics (rx/tx frames, match ratios, ...)
     reset_stats - manual statistic reset
-    version     - prints the SocketCAN core version and the ABI version
+    version     - prints SocketCAN core and ABI version (removed in Linux 5.10)
 
 
 Writing Own CAN Protocol Modules
 --------------------------------
 
@@ -1068,11 +1103,11 @@ General Settings
 .. code-block:: C
 
     dev->type  = ARPHRD_CAN; /* the netdevice hardware type */
     dev->flags = IFF_NOARP;  /* CAN has no arp */
 
-    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> legacy CAN interface */
+    dev->mtu = CAN_MTU; /* sizeof(struct can_frame) -> Classical CAN interface */
 
     or alternative, when the controller supports CAN with flexible data rate:
     dev->mtu = CANFD_MTU; /* sizeof(struct canfd_frame) -> CAN FD interface */
 
 The struct can_frame or struct canfd_frame is the payload of each socket
@@ -1182,10 +1217,11 @@ Setting CAN device properties::
         [ one-shot { on | off } ]
         [ berr-reporting { on | off } ]
         [ fd { on | off } ]
         [ fd-non-iso { on | off } ]
         [ presume-ack { on | off } ]
+        [ cc-len8-dlc { on | off } ]
 
         [ restart-ms TIME-MS ]
         [ restart ]
 
         Where: BITRATE       := { 1..1000000 }
@@ -1324,26 +1360,26 @@ CAN FD (Flexible Data Rate) Driver Support
 CAN FD capable CAN controllers support two different bitrates for the
 arbitration phase and the payload phase of the CAN FD frame. Therefore a
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
 at least the bitrate which was configured for the arbitration phase. This
 second bitrate is specified analogue to the first bitrate but the bitrate
-- 
2.28.0

