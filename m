Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B453F687924
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjBBJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBBJlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7530B8327A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNW68-0000e9-T9
        for netdev@vger.kernel.org; Thu, 02 Feb 2023 10:41:40 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C5C5816D0D2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:41:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D842C16D0AB;
        Thu,  2 Feb 2023 09:41:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fbcc429d;
        Thu, 2 Feb 2023 09:41:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/5] can: isotp: split tx timer into transmission and timeout
Date:   Thu,  2 Feb 2023 10:41:34 +0100
Message-Id: <20230202094135.2293939-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202094135.2293939-1-mkl@pengutronix.de>
References: <20230202094135.2293939-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The timer for the transmission of isotp PDUs formerly had two functions:
1. send two consecutive frames with a given time gap
2. monitor the timeouts for flow control frames and the echo frames

This led to larger txstate checks and potentially to a problem discovered
by syzbot which enabled the panic_on_warn feature while testing.

The former 'txtimer' function is split into 'txfrtimer' and 'txtimer'
to handle the two above functionalities with separate timer callbacks.

The two simplified timers now run in one-shot mode and make the state
transitions (especially with isotp_rcv_echo) better understandable.

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx processing")
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # >= v6.0
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104145701.2422-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 65 ++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index dae421f6c901..fc81d77724a1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -140,7 +140,7 @@ struct isotp_sock {
 	canid_t rxid;
 	ktime_t tx_gap;
 	ktime_t lastrxcf_tstamp;
-	struct hrtimer rxtimer, txtimer;
+	struct hrtimer rxtimer, txtimer, txfrtimer;
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
@@ -871,7 +871,7 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 	}
 
 	/* start timer to send next consecutive frame with correct delay */
-	hrtimer_start(&so->txtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
+	hrtimer_start(&so->txfrtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
 }
 
 static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
@@ -879,49 +879,39 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
 					     txtimer);
 	struct sock *sk = &so->sk;
-	enum hrtimer_restart restart = HRTIMER_NORESTART;
 
-	switch (so->tx.state) {
-	case ISOTP_SENDING:
+	/* don't handle timeouts in IDLE state */
+	if (so->tx.state == ISOTP_IDLE)
+		return HRTIMER_NORESTART;
 
-		/* cfecho should be consumed by isotp_rcv_echo() here */
-		if (!so->cfecho) {
-			/* start timeout for unlikely lost echo skb */
-			hrtimer_set_expires(&so->txtimer,
-					    ktime_add(ktime_get(),
-						      ktime_set(ISOTP_ECHO_TIMEOUT, 0)));
-			restart = HRTIMER_RESTART;
+	/* we did not get any flow control or echo frame in time */
 
-			/* push out the next consecutive frame */
-			isotp_send_cframe(so);
-			break;
-		}
-
-		/* cfecho has not been cleared in isotp_rcv_echo() */
-		pr_notice_once("can-isotp: cfecho %08X timeout\n", so->cfecho);
-		fallthrough;
+	/* report 'communication error on send' */
+	sk->sk_err = ECOMM;
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk_error_report(sk);
 
-	case ISOTP_WAIT_FC:
-	case ISOTP_WAIT_FIRST_FC:
+	/* reset tx state */
+	so->tx.state = ISOTP_IDLE;
+	wake_up_interruptible(&so->wait);
 
-		/* we did not get any flow control frame in time */
+	return HRTIMER_NORESTART;
+}
 
-		/* report 'communication error on send' */
-		sk->sk_err = ECOMM;
-		if (!sock_flag(sk, SOCK_DEAD))
-			sk_error_report(sk);
+static enum hrtimer_restart isotp_txfr_timer_handler(struct hrtimer *hrtimer)
+{
+	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
+					     txfrtimer);
 
-		/* reset tx state */
-		so->tx.state = ISOTP_IDLE;
-		wake_up_interruptible(&so->wait);
-		break;
+	/* start echo timeout handling and cover below protocol error */
+	hrtimer_start(&so->txtimer, ktime_set(ISOTP_ECHO_TIMEOUT, 0),
+		      HRTIMER_MODE_REL_SOFT);
 
-	default:
-		WARN_ONCE(1, "can-isotp: tx timer state %08X cfecho %08X\n",
-			  so->tx.state, so->cfecho);
-	}
+	/* cfecho should be consumed by isotp_rcv_echo() here */
+	if (so->tx.state == ISOTP_SENDING && !so->cfecho)
+		isotp_send_cframe(so);
 
-	return restart;
+	return HRTIMER_NORESTART;
 }
 
 static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -1198,6 +1188,7 @@ static int isotp_release(struct socket *sock)
 		}
 	}
 
+	hrtimer_cancel(&so->txfrtimer);
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);
 
@@ -1601,6 +1592,8 @@ static int isotp_init(struct sock *sk)
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->txtimer.function = isotp_tx_timer_handler;
+	hrtimer_init(&so->txfrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
+	so->txfrtimer.function = isotp_txfr_timer_handler;
 
 	init_waitqueue_head(&so->wait);
 	spin_lock_init(&so->rx_lock);
-- 
2.39.1


