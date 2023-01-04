Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD2865D6B3
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbjADO5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbjADO52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:57:28 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE511A3B1;
        Wed,  4 Jan 2023 06:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672844242;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=v6BMM21BDCcCy2GIOvTUGduqcWN6NgGM2k12PWJ5Uno=;
    b=I5stwpn9gMaFXIL+dxtukhy+GD9QDMv1v0lJaixrXe/YYL1F1ymiT27Ysq6G6Wx6Yb
    JS6vwEHtiQhvcZIgn92a+/qZUfXmaD/SqS+zk4oGP9GHa0xA1oODTdd4UGO60x3YyRIb
    hdzYshExsHJ3AWDFTGPoqeryUz4GkZJO0K2KbgIPHtxeq9Q3J+uCyDsxV2JwPuBK+dNT
    vFxuNM08Km6ERFPz5zsgMTyCqtQdTTMhUQsMaZhMr4KMtVRYzyFcZB0cKCevBOZe/TS8
    10uq698i3Eho0g7XSWTeAR3mqHHQEtrWYY7D31gIXy87akQgB6ihlI1yuEnfxJXbNFhg
    9ZGw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJygjsS+Kjg=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id j06241z04EvL0jw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 4 Jan 2023 15:57:21 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] can: isotp: split tx timer into transmission and timeout
Date:   Wed,  4 Jan 2023 15:57:01 +0100
Message-Id: <20230104145701.2422-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/can/isotp.c | 65 ++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 608f8c24ae46..0476a506d4a4 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -138,11 +138,11 @@ struct isotp_sock {
 	int ifindex;
 	canid_t txid;
 	canid_t rxid;
 	ktime_t tx_gap;
 	ktime_t lastrxcf_tstamp;
-	struct hrtimer rxtimer, txtimer;
+	struct hrtimer rxtimer, txtimer, txfrtimer;
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
 	u32 frame_txtime;
 	u32 force_tx_stmin;
@@ -869,61 +869,51 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 		isotp_send_cframe(so);
 		return;
 	}
 
 	/* start timer to send next consecutive frame with correct delay */
-	hrtimer_start(&so->txtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
+	hrtimer_start(&so->txfrtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
 }
 
 static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 {
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
 {
 	struct sock *sk = sock->sk;
@@ -1192,10 +1182,11 @@ static int isotp_release(struct socket *sock)
 				synchronize_rcu();
 			}
 		}
 	}
 
+	hrtimer_cancel(&so->txfrtimer);
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);
 
 	so->ifindex = 0;
 	so->bound = 0;
@@ -1595,10 +1586,12 @@ static int isotp_init(struct sock *sk)
 
 	hrtimer_init(&so->rxtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->txtimer.function = isotp_tx_timer_handler;
+	hrtimer_init(&so->txfrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
+	so->txfrtimer.function = isotp_txfr_timer_handler;
 
 	init_waitqueue_head(&so->wait);
 	spin_lock_init(&so->rx_lock);
 
 	spin_lock(&isotp_notifier_lock);
-- 
2.30.2

