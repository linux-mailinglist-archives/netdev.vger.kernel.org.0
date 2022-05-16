Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE31529211
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348166AbiEPUwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348640AbiEPUvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBAA2AE0E
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIe-00068a-6f
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2C70E7FB45
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 767C87FB35;
        Mon, 16 May 2022 20:26:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1dcbb828;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/9] can: isotp: add support for transmission without flow control
Date:   Mon, 16 May 2022 22:26:19 +0200
Message-Id: <20220516202625.1129281-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
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

Usually the ISO 15765-2 protocol is a point-to-point protocol to transfer
segmented PDUs to a dedicated receiver. This receiver sends a flow control
message to specify protocol options and timings (e.g. block size / STmin).

The so called functional addressing communication allows a 1:N
communication but is limited to a single frame length.

This new CAN_ISOTP_CF_BROADCAST allows an unconfirmed 1:N communication
with PDU length that would not fit into a single frame. This feature is
not covered by the ISO 15765-2 standard.

Link: https://lore.kernel.org/all/20220507115558.19065-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/isotp.h |  25 +++++----
 net/can/isotp.c                | 100 ++++++++++++++++++++++++++-------
 2 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 590f8aea2b6d..439c982f7e81 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -124,18 +124,19 @@ struct can_isotp_ll_options {
 
 /* flags for isotp behaviour */
 
-#define CAN_ISOTP_LISTEN_MODE	0x001	/* listen only (do not send FC) */
-#define CAN_ISOTP_EXTEND_ADDR	0x002	/* enable extended addressing */
-#define CAN_ISOTP_TX_PADDING	0x004	/* enable CAN frame padding tx path */
-#define CAN_ISOTP_RX_PADDING	0x008	/* enable CAN frame padding rx path */
-#define CAN_ISOTP_CHK_PAD_LEN	0x010	/* check received CAN frame padding */
-#define CAN_ISOTP_CHK_PAD_DATA	0x020	/* check received CAN frame padding */
-#define CAN_ISOTP_HALF_DUPLEX	0x040	/* half duplex error state handling */
-#define CAN_ISOTP_FORCE_TXSTMIN	0x080	/* ignore stmin from received FC */
-#define CAN_ISOTP_FORCE_RXSTMIN	0x100	/* ignore CFs depending on rx stmin */
-#define CAN_ISOTP_RX_EXT_ADDR	0x200	/* different rx extended addressing */
-#define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
-#define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
+#define CAN_ISOTP_LISTEN_MODE	0x0001	/* listen only (do not send FC) */
+#define CAN_ISOTP_EXTEND_ADDR	0x0002	/* enable extended addressing */
+#define CAN_ISOTP_TX_PADDING	0x0004	/* enable CAN frame padding tx path */
+#define CAN_ISOTP_RX_PADDING	0x0008	/* enable CAN frame padding rx path */
+#define CAN_ISOTP_CHK_PAD_LEN	0x0010	/* check received CAN frame padding */
+#define CAN_ISOTP_CHK_PAD_DATA	0x0020	/* check received CAN frame padding */
+#define CAN_ISOTP_HALF_DUPLEX	0x0040	/* half duplex error state handling */
+#define CAN_ISOTP_FORCE_TXSTMIN	0x0080	/* ignore stmin from received FC */
+#define CAN_ISOTP_FORCE_RXSTMIN	0x0100	/* ignore CFs depending on rx stmin */
+#define CAN_ISOTP_RX_EXT_ADDR	0x0200	/* different rx extended addressing */
+#define CAN_ISOTP_WAIT_TX_DONE	0x0400	/* wait for tx completion */
+#define CAN_ISOTP_SF_BROADCAST	0x0800	/* 1-to-N functional addressing */
+#define CAN_ISOTP_CF_BROADCAST	0x1000	/* 1-to-N transmission w/o FC */
 
 /* protocol machine default values */
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 35a1ae61744c..2caeeae8ec16 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -104,6 +104,7 @@ MODULE_ALIAS("can-proto-6");
 #define FC_CONTENT_SZ 3	/* flow control content size in byte (FS/BS/STmin) */
 
 #define ISOTP_CHECK_PADDING (CAN_ISOTP_CHK_PAD_LEN | CAN_ISOTP_CHK_PAD_DATA)
+#define ISOTP_ALL_BC_FLAGS (CAN_ISOTP_SF_BROADCAST | CAN_ISOTP_CF_BROADCAST)
 
 /* Flow Status given in FC frame */
 #define ISOTP_FC_CTS 0		/* clear to send */
@@ -159,6 +160,23 @@ static inline struct isotp_sock *isotp_sk(const struct sock *sk)
 	return (struct isotp_sock *)sk;
 }
 
+static u32 isotp_bc_flags(struct isotp_sock *so)
+{
+	return so->opt.flags & ISOTP_ALL_BC_FLAGS;
+}
+
+static bool isotp_register_rxid(struct isotp_sock *so)
+{
+	/* no broadcast modes => register rx_id for FC frame reception */
+	return (isotp_bc_flags(so) == 0);
+}
+
+static bool isotp_register_txecho(struct isotp_sock *so)
+{
+	/* all modes but SF_BROADCAST register for tx echo skbs */
+	return (isotp_bc_flags(so) != CAN_ISOTP_SF_BROADCAST);
+}
+
 static enum hrtimer_restart isotp_rx_timer_handler(struct hrtimer *hrtimer)
 {
 	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
@@ -803,7 +821,6 @@ static void isotp_create_fframe(struct canfd_frame *cf, struct isotp_sock *so,
 		cf->data[i] = so->tx.buf[so->tx.idx++];
 
 	so->tx.sn = 1;
-	so->tx.state = ISOTP_WAIT_FIRST_FC;
 }
 
 static void isotp_rcv_echo(struct sk_buff *skb, void *data)
@@ -936,7 +953,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
 
 	/* does the given data fit into a single frame for SF_BROADCAST? */
-	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
+	if ((isotp_bc_flags(so) == CAN_ISOTP_SF_BROADCAST) &&
 	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
 		err = -EINVAL;
 		goto err_out_drop;
@@ -1000,12 +1017,41 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* don't enable wait queue for a single frame transmission */
 		wait_tx_done = 0;
 	} else {
-		/* send first frame and wait for FC */
+		/* send first frame */
 
 		isotp_create_fframe(cf, so, ae);
 
-		/* start timeout for FC */
-		hrtimer_sec = 1;
+		if (isotp_bc_flags(so) == CAN_ISOTP_CF_BROADCAST) {
+			/* set timer for FC-less operation (STmin = 0) */
+			if (so->opt.flags & CAN_ISOTP_FORCE_TXSTMIN)
+				so->tx_gap = ktime_set(0, so->force_tx_stmin);
+			else
+				so->tx_gap = ktime_set(0, so->frame_txtime);
+
+			/* disable wait for FCs due to activated block size */
+			so->txfc.bs = 0;
+
+			/* cfecho should have been zero'ed by init */
+			if (so->cfecho)
+				pr_notice_once("can-isotp: no fc cfecho %08X\n",
+					       so->cfecho);
+
+			/* set consecutive frame echo tag */
+			so->cfecho = *(u32 *)cf->data;
+
+			/* switch directly to ISOTP_SENDING state */
+			so->tx.state = ISOTP_SENDING;
+
+			/* start timeout for unlikely lost echo skb */
+			hrtimer_sec = 2;
+		} else {
+			/* standard flow control check */
+			so->tx.state = ISOTP_WAIT_FIRST_FC;
+
+			/* start timeout for FC */
+			hrtimer_sec = 1;
+		}
+
 		hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
 			      HRTIMER_MODE_REL_SOFT);
 	}
@@ -1025,6 +1071,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		if (hrtimer_sec)
 			hrtimer_cancel(&so->txtimer);
 
+		/* reset consecutive frame echo tag */
+		so->cfecho = 0;
+
 		goto err_out_drop;
 	}
 
@@ -1120,15 +1169,17 @@ static int isotp_release(struct socket *sock)
 	lock_sock(sk);
 
 	/* remove current filters & unregister */
-	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
+	if (so->bound && isotp_register_txecho(so)) {
 		if (so->ifindex) {
 			struct net_device *dev;
 
 			dev = dev_get_by_index(net, so->ifindex);
 			if (dev) {
-				can_rx_unregister(net, dev, so->rxid,
-						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
+				if (isotp_register_rxid(so))
+					can_rx_unregister(net, dev, so->rxid,
+							  SINGLE_MASK(so->rxid),
+							  isotp_rcv, sk);
+
 				can_rx_unregister(net, dev, so->txid,
 						  SINGLE_MASK(so->txid),
 						  isotp_rcv_echo, sk);
@@ -1164,7 +1215,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	canid_t tx_id, rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
-	int do_rx_reg = 1;
 
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
@@ -1192,12 +1242,8 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		goto out;
 	}
 
-	/* do not register frame reception for functional addressing */
-	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
-		do_rx_reg = 0;
-
-	/* do not validate rx address for functional addressing */
-	if (do_rx_reg && rx_id == tx_id) {
+	/* ensure different CAN IDs when the rx_id is to be registered */
+	if (isotp_register_rxid(so) && rx_id == tx_id) {
 		err = -EADDRNOTAVAIL;
 		goto out;
 	}
@@ -1222,10 +1268,11 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	ifindex = dev->ifindex;
 
-	if (do_rx_reg) {
+	if (isotp_register_rxid(so))
 		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
 				isotp_rcv, sk, "isotp", sk);
 
+	if (isotp_register_txecho(so)) {
 		/* no consecutive frame echo skb in flight */
 		so->cfecho = 0;
 
@@ -1294,6 +1341,15 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 		if (!(so->opt.flags & CAN_ISOTP_RX_EXT_ADDR))
 			so->opt.rx_ext_address = so->opt.ext_address;
 
+		/* these broadcast flags are not allowed together */
+		if (isotp_bc_flags(so) == ISOTP_ALL_BC_FLAGS) {
+			/* CAN_ISOTP_SF_BROADCAST is prioritized */
+			so->opt.flags &= ~CAN_ISOTP_CF_BROADCAST;
+
+			/* give user feedback on wrong config attempt */
+			ret = -EINVAL;
+		}
+
 		/* check for frame_txtime changes (0 => no changes) */
 		if (so->opt.frame_txtime) {
 			if (so->opt.frame_txtime == CAN_ISOTP_FRAME_TXTIME_ZERO)
@@ -1444,10 +1500,12 @@ static void isotp_notify(struct isotp_sock *so, unsigned long msg,
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
-			can_rx_unregister(dev_net(dev), dev, so->rxid,
-					  SINGLE_MASK(so->rxid),
-					  isotp_rcv, sk);
+		if (so->bound && isotp_register_txecho(so)) {
+			if (isotp_register_rxid(so))
+				can_rx_unregister(dev_net(dev), dev, so->rxid,
+						  SINGLE_MASK(so->rxid),
+						  isotp_rcv, sk);
+
 			can_rx_unregister(dev_net(dev), dev, so->txid,
 					  SINGLE_MASK(so->txid),
 					  isotp_rcv_echo, sk);
-- 
2.35.1


