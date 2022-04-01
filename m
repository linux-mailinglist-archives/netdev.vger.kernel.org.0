Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274184EF2F3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348234AbiDAOxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352286AbiDAOuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:50:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90AD2B2077;
        Fri,  1 Apr 2022 07:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 667EAB82518;
        Fri,  1 Apr 2022 14:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C059C340EE;
        Fri,  1 Apr 2022 14:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824083;
        bh=hffhfGZggXIZrzhWpnf/mKyIGXVLLu+mdlXrm1Va7YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8GQtQXP8RN1D0yidqnV9s97OLB9+crUXMsmD+ILkt1rqXtdZv04L2W3ejyQOd57R
         ooV2nsPqB0P0aw6BvXmu/9XD22W2IwPv29tKkY6ODD8YRDfdAeUDirobA5NPb1NbT+
         XwCOwh0qW13wF5EL4eaRA6Mu7rHGf5/R9d4pd9IJk3KrUkzLpXUFMPY156vIzbErIp
         EItb886olybFVEwXWRI+kS8do3mxJaIyfhTkJ8wEZC5gEthVtgK7H7DA0unP7BvgNK
         wgF8Ypg3q8JmUaDKzKVOdN8y6BkNclxOAK5vvMmzwaQNcn0Mkd99qQfAzQFBoSeMhP
         Cs2zR10DFsETw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 79/98] can: isotp: set default value for N_As to 50 micro seconds
Date:   Fri,  1 Apr 2022 10:37:23 -0400
Message-Id: <20220401143742.1952163-79-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 530e0d46c61314c59ecfdb8d3bcb87edbc0f85d3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index d2a430b6a13b..ea8e932008a3 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -141,6 +141,7 @@ struct isotp_sock {
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
+	u32 frame_txtime;
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
@@ -360,7 +361,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 
 		so->tx_gap = ktime_set(0, 0);
 		/* add transmission time for CAN frame N_As */
-		so->tx_gap = ktime_add_ns(so->tx_gap, so->opt.frame_txtime);
+		so->tx_gap = ktime_add_ns(so->tx_gap, so->frame_txtime);
 		/* add waiting time for consecutive frames N_Cs */
 		if (so->opt.flags & CAN_ISOTP_FORCE_TXSTMIN)
 			so->tx_gap = ktime_add_ns(so->tx_gap,
@@ -1238,6 +1239,14 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
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
@@ -1439,6 +1448,7 @@ static int isotp_init(struct sock *sk)
 	so->opt.rxpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.txpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
+	so->frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
 	so->rxfc.bs = CAN_ISOTP_DEFAULT_RECV_BS;
 	so->rxfc.stmin = CAN_ISOTP_DEFAULT_RECV_STMIN;
 	so->rxfc.wftmax = CAN_ISOTP_DEFAULT_RECV_WFTMAX;
-- 
2.34.1

