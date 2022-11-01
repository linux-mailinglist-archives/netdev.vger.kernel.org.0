Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE2615454
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 22:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiKAVfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 17:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKAVfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 17:35:39 -0400
X-Greylist: delayed 363 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 14:35:35 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0DA1E3F9;
        Tue,  1 Nov 2022 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667338168;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=LwgcuQpDVphRmoE8aGvGLTtr8UFcb+TsyQ/w+VFhDEg=;
    b=nSNfcLMBfXB0v8fsjV6/7DunKlywdM2aoe46ExMjbVTik1c22GbFPdGaSOtSOmgB2c
    z4Tb5PwILC61GsPxDk3EfJHul/TBZ/gSCW85ywuSiyrqWKyKJ28rsBalmayNLDUch9+Q
    tl58WmA5jLXzkR6Psb8s7UxyXP8YJCE2FPee7JcO94HTHlC4hjhmgX1d4gPvmsCNI5Sr
    Ab/kBRAvbZLyTNRdvJrdXEnWOfJWScjpDme6rdHV33+zp2+Pkkfr+cVI6YhIw2MsiDH4
    0yajOEBDJiPBvYXcgCUea3O1JEVmYTBccYqp0BTjhun13z9RwpSwcncyC/fv10cPaiq2
    Rjow==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JiLceSWNadhq4/jU"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA1LTSHQr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 1 Nov 2022 22:29:28 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] can: isotp: fix tx state handling for echo tx processing
Date:   Tue,  1 Nov 2022 22:29:02 +0100
Message-Id: <20221101212902.10702-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 4b7fe92c0690 ("can: isotp: add local echo tx processing for
consecutive frames") the data flow for consecutive frames (CF) has been
reworked to improve the reliability of long data transfers.

This rework did not touch the transmission and the tx state changes of
single frame (SF) transfers which likely led to the WARN in the
isotp_tx_timer_handler() catching a wrong tx state. This patch makes use
of the improved frame processing for SF frames and sets the ISOTP_SENDING
state in isotp_sendmsg() within the cmpxchg() condition handling.

A review of the state machine and the timer handling additionally revealed
a missing echo timeout handling in the case of the burst mode in
isotp_rcv_echo() and removes a potential timer configuration uncertainty
in isotp_rcv_fc() when the receiver requests consecutive frames.

Fixes: 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive frames")
Link: https://lore.kernel.org/linux-can/CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vichigUMQwsxX4M=45QEw@mail.gmail.com/T/#u
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: stable@vger.kernel.org # v6.0
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 69 ++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index a9d1357f8489..08fd4d5013a4 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -109,10 +109,13 @@ MODULE_ALIAS("can-proto-6");
 /* Flow Status given in FC frame */
 #define ISOTP_FC_CTS 0		/* clear to send */
 #define ISOTP_FC_WT 1		/* wait */
 #define ISOTP_FC_OVFLW 2	/* overflow */
 
+#define ISOTP_FC_TIMEOUT 1	/* 1 sec */
+#define ISOTP_ECHO_TIMEOUT 2	/* 2 secs */
+
 enum {
 	ISOTP_IDLE = 0,
 	ISOTP_WAIT_FIRST_FC,
 	ISOTP_WAIT_FC,
 	ISOTP_WAIT_DATA,
@@ -256,11 +259,12 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	/* reset last CF frame rx timestamp for rx stmin enforcement */
 	so->lastrxcf_tstamp = ktime_set(0, 0);
 
 	/* start rx timeout watchdog */
-	hrtimer_start(&so->rxtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
+	hrtimer_start(&so->rxtimer, ktime_set(ISOTP_FC_TIMEOUT, 0),
+		      HRTIMER_MODE_REL_SOFT);
 	return 0;
 }
 
 static void isotp_rcv_skb(struct sk_buff *skb, struct sock *sk)
 {
@@ -342,10 +346,12 @@ static int check_pad(struct isotp_sock *so, struct canfd_frame *cf,
 				return 1;
 	}
 	return 0;
 }
 
+static void isotp_send_cframe(struct isotp_sock *so);
+
 static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 {
 	struct sock *sk = &so->sk;
 
 	if (so->tx.state != ISOTP_WAIT_FC &&
@@ -396,18 +402,19 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 
 	switch (cf->data[ae] & 0x0F) {
 	case ISOTP_FC_CTS:
 		so->tx.bs = 0;
 		so->tx.state = ISOTP_SENDING;
-		/* start cyclic timer for sending CF frame */
-		hrtimer_start(&so->txtimer, so->tx_gap,
+		/* send CF frame and enable echo timeout handling */
+		hrtimer_start(&so->txtimer, ktime_set(ISOTP_ECHO_TIMEOUT, 0),
 			      HRTIMER_MODE_REL_SOFT);
+		isotp_send_cframe(so);
 		break;
 
 	case ISOTP_FC_WT:
 		/* start timer to wait for next FC frame */
-		hrtimer_start(&so->txtimer, ktime_set(1, 0),
+		hrtimer_start(&so->txtimer, ktime_set(ISOTP_FC_TIMEOUT, 0),
 			      HRTIMER_MODE_REL_SOFT);
 		break;
 
 	case ISOTP_FC_OVFLW:
 		/* overflow on receiver side - report 'message too long' */
@@ -598,11 +605,11 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 	}
 
 	/* perform blocksize handling, if enabled */
 	if (!so->rxfc.bs || ++so->rx.bs < so->rxfc.bs) {
 		/* start rx timeout watchdog */
-		hrtimer_start(&so->rxtimer, ktime_set(1, 0),
+		hrtimer_start(&so->rxtimer, ktime_set(ISOTP_FC_TIMEOUT, 0),
 			      HRTIMER_MODE_REL_SOFT);
 		return 0;
 	}
 
 	/* no creation of flow control frames */
@@ -827,11 +834,11 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 {
 	struct sock *sk = (struct sock *)data;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 
-	/* only handle my own local echo skb's */
+	/* only handle my own local echo CF/SF skb's (no FF!) */
 	if (skb->sk != sk || so->cfecho != *(u32 *)cf->data)
 		return;
 
 	/* cancel local echo timeout */
 	hrtimer_cancel(&so->txtimer);
@@ -847,17 +854,20 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 	}
 
 	if (so->txfc.bs && so->tx.bs >= so->txfc.bs) {
 		/* stop and wait for FC with timeout */
 		so->tx.state = ISOTP_WAIT_FC;
-		hrtimer_start(&so->txtimer, ktime_set(1, 0),
+		hrtimer_start(&so->txtimer, ktime_set(ISOTP_FC_TIMEOUT, 0),
 			      HRTIMER_MODE_REL_SOFT);
 		return;
 	}
 
 	/* no gap between data frames needed => use burst mode */
 	if (!so->tx_gap) {
+		/* enable echo timeout handling */
+		hrtimer_start(&so->txtimer, ktime_set(ISOTP_ECHO_TIMEOUT, 0),
+			      HRTIMER_MODE_REL_SOFT);
 		isotp_send_cframe(so);
 		return;
 	}
 
 	/* start timer to send next consecutive frame with correct delay */
@@ -877,11 +887,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		/* cfecho should be consumed by isotp_rcv_echo() here */
 		if (!so->cfecho) {
 			/* start timeout for unlikely lost echo skb */
 			hrtimer_set_expires(&so->txtimer,
 					    ktime_add(ktime_get(),
-						      ktime_set(2, 0)));
+						      ktime_set(ISOTP_ECHO_TIMEOUT, 0)));
 			restart = HRTIMER_RESTART;
 
 			/* push out the next consecutive frame */
 			isotp_send_cframe(so);
 			break;
@@ -905,10 +915,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		so->tx.state = ISOTP_IDLE;
 		wake_up_interruptible(&so->wait);
 		break;
 
 	default:
+		pr_notice_once("can-isotp: tx timer state %X\n", so->tx.state);
 		WARN_ON_ONCE(1);
 	}
 
 	return restart;
 }
@@ -921,11 +932,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
-	s64 hrtimer_sec = 0;
+	s64 hrtimer_sec = ISOTP_ECHO_TIMEOUT;
 	int off;
 	int err;
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
@@ -940,10 +951,12 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 		/* wait for complete transmission of current pdu */
 		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 		if (err)
 			goto err_out;
+
+		so->tx.state = ISOTP_SENDING;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
 		goto err_out_drop;
@@ -984,10 +997,14 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
 
+	/* cfecho should have been zero'ed by init / former isotp_rcv_echo() */
+	if (so->cfecho)
+		pr_notice_once("can-isotp: uninit cfecho %08X\n", so->cfecho);
+
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
 		 *
 		 * SF_DL ESC offset optimization:
@@ -1009,15 +1026,12 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		if (off)
 			cf->data[SF_PCI_SZ4 + ae] = size;
 		else
 			cf->data[ae] |= size;
 
-		so->tx.state = ISOTP_IDLE;
-		wake_up_interruptible(&so->wait);
-
-		/* don't enable wait queue for a single frame transmission */
-		wait_tx_done = 0;
+		/* set CF echo tag for isotp_rcv_echo() (SF-mode) */
+		so->cfecho = *(u32 *)cf->data;
 	} else {
 		/* send first frame */
 
 		isotp_create_fframe(cf, so, ae);
 
@@ -1029,35 +1043,27 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 				so->tx_gap = ktime_set(0, so->frame_txtime);
 
 			/* disable wait for FCs due to activated block size */
 			so->txfc.bs = 0;
 
-			/* cfecho should have been zero'ed by init */
-			if (so->cfecho)
-				pr_notice_once("can-isotp: no fc cfecho %08X\n",
-					       so->cfecho);
-
-			/* set consecutive frame echo tag */
+			/* set CF echo tag for isotp_rcv_echo() (CF-mode) */
 			so->cfecho = *(u32 *)cf->data;
-
-			/* switch directly to ISOTP_SENDING state */
-			so->tx.state = ISOTP_SENDING;
-
-			/* start timeout for unlikely lost echo skb */
-			hrtimer_sec = 2;
 		} else {
 			/* standard flow control check */
 			so->tx.state = ISOTP_WAIT_FIRST_FC;
 
 			/* start timeout for FC */
-			hrtimer_sec = 1;
-		}
+			hrtimer_sec = ISOTP_FC_TIMEOUT;
 
-		hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
-			      HRTIMER_MODE_REL_SOFT);
+			/* no CF echo tag for isotp_rcv_echo() (FF-mode) */
+			so->cfecho = 0;
+		}
 	}
 
+	hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
+		      HRTIMER_MODE_REL_SOFT);
+
 	/* send the first or only CAN frame */
 	cf->flags = so->ll.tx_flags;
 
 	skb->dev = dev;
 	skb->sk = sk;
@@ -1066,12 +1072,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
 
 		/* no transmission -> no timeout monitoring */
-		if (hrtimer_sec)
-			hrtimer_cancel(&so->txtimer);
+		hrtimer_cancel(&so->txtimer);
 
 		/* reset consecutive frame echo tag */
 		so->cfecho = 0;
 
 		goto err_out_drop;
-- 
2.30.2

