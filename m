Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4683F4D4AD2
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbiCJOcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343959AbiCJObd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F96BA74F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:11 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJmv-0005pF-93
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9298847D6E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D168C47D61;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b7492c01;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 02/29] can: isotp: set default value for N_As to 50 micro seconds
Date:   Thu, 10 Mar 2022 15:28:36 +0100
Message-Id: <20220310142903.341658-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The N_As value describes the time a CAN frame needs on the wire when
transmitted by the CAN controller. Even very short CAN FD frames need
arround 100 usecs (bitrate 1Mbit/s, data bitrate 8Mbit/s).

Having N_As to be zero (the former default) leads to 'no CAN frame
separation' when STmin is set to zero by the receiving node. This 'burst
mode' should not be enabled by default as it could potentially dump a high
number of CAN frames into the netdev queue from the soft hrtimer context.
This does not affect the system stability but is just not nice and
cooperative.

With this N_As/frame_txtime value the 'burst mode' is disabled by default.

As user space applications usually do not set the frame_txtime element
of struct can_isotp_options the new in-kernel default is very likely
overwritten with zero when the sockopt() CAN_ISOTP_OPTS is invoked.
To make sure that a N_As value of zero is only set intentional the
value '0' is now interpreted as 'do not change the current value'.
When a frame_txtime of zero is required for testing purposes this
CAN_ISOTP_FRAME_TXTIME_ZERO u32 value has to be set in frame_txtime.

Link: https://lore.kernel.org/all/20220309120416.83514-2-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/isotp.h | 28 ++++++++++++++++++++++------
 net/can/isotp.c                | 12 +++++++++++-
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index c55935b64ccc..590f8aea2b6d 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -137,20 +137,16 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
 #define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
-/* default values */
+/* protocol machine default values */
 
 #define CAN_ISOTP_DEFAULT_FLAGS		0
 #define CAN_ISOTP_DEFAULT_EXT_ADDRESS	0x00
 #define CAN_ISOTP_DEFAULT_PAD_CONTENT	0xCC /* prevent bit-stuffing */
-#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	0
+#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	50000 /* 50 micro seconds */
 #define CAN_ISOTP_DEFAULT_RECV_BS	0
 #define CAN_ISOTP_DEFAULT_RECV_STMIN	0x00
 #define CAN_ISOTP_DEFAULT_RECV_WFTMAX	0
 
-#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
-#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
-#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
-
 /*
  * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
  *
@@ -162,4 +158,24 @@ struct can_isotp_ll_options {
  * consistency and copied directly into the flow control (FC) frame.
  */
 
+/* link layer default values => make use of Classical CAN frames */
+
+#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
+#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
+#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
+
+/*
+ * The CAN_ISOTP_DEFAULT_FRAME_TXTIME has become a non-zero value as
+ * it only makes sense for isotp implementation tests to run without
+ * a N_As value. As user space applications usually do not set the
+ * frame_txtime element of struct can_isotp_options the new in-kernel
+ * default is very likely overwritten with zero when the sockopt()
+ * CAN_ISOTP_OPTS is invoked.
+ * To make sure that a N_As value of zero is only set intentional the
+ * value '0' is now interpreted as 'do not change the current value'.
+ * When a frame_txtime of zero is required for testing purposes this
+ * CAN_ISOTP_FRAME_TXTIME_ZERO u32 value has to be set in frame_txtime.
+ */
+#define CAN_ISOTP_FRAME_TXTIME_ZERO	0xFFFFFFFF
+
 #endif /* !_UAPI_CAN_ISOTP_H */
diff --git a/net/can/isotp.c b/net/can/isotp.c
index d59f1758ac9c..47404ba59981 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -140,6 +140,7 @@ struct isotp_sock {
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
+	u32 frame_txtime;
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	u32 cfecho; /* consecutive frame echo tag */
@@ -360,7 +361,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 
 		so->tx_gap = ktime_set(0, 0);
 		/* add transmission time for CAN frame N_As */
-		so->tx_gap = ktime_add_ns(so->tx_gap, so->opt.frame_txtime);
+		so->tx_gap = ktime_add_ns(so->tx_gap, so->frame_txtime);
 		/* add waiting time for consecutive frames N_Cs */
 		if (so->opt.flags & CAN_ISOTP_FORCE_TXSTMIN)
 			so->tx_gap = ktime_add_ns(so->tx_gap,
@@ -1293,6 +1294,14 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 		/* no separate rx_ext_address is given => use ext_address */
 		if (!(so->opt.flags & CAN_ISOTP_RX_EXT_ADDR))
 			so->opt.rx_ext_address = so->opt.ext_address;
+
+		/* check for frame_txtime changes (0 => no changes) */
+		if (so->opt.frame_txtime) {
+			if (so->opt.frame_txtime == CAN_ISOTP_FRAME_TXTIME_ZERO)
+				so->frame_txtime = 0;
+			else
+				so->frame_txtime = so->opt.frame_txtime;
+		}
 		break;
 
 	case CAN_ISOTP_RECV_FC:
@@ -1498,6 +1507,7 @@ static int isotp_init(struct sock *sk)
 	so->opt.rxpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.txpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
+	so->frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
 	so->rxfc.bs = CAN_ISOTP_DEFAULT_RECV_BS;
 	so->rxfc.stmin = CAN_ISOTP_DEFAULT_RECV_STMIN;
 	so->rxfc.wftmax = CAN_ISOTP_DEFAULT_RECV_WFTMAX;
-- 
2.35.1


