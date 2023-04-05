Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58B6D7806
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbjDEJZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbjDEJZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:25:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C5749CE
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:25:03 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjzO2-0004F1-Cy
        for netdev@vger.kernel.org; Wed, 05 Apr 2023 11:25:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 82BC01A7153
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:25:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8852F1A7138;
        Wed,  5 Apr 2023 09:24:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0570bfc9;
        Wed, 5 Apr 2023 09:24:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        "Dae R . Jeong" <threeearcat@gmail.com>,
        Hillf Danton <hdanton@sina.com>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/4] can: isotp: fix race between isotp_sendsmg() and isotp_release()
Date:   Wed,  5 Apr 2023 11:24:44 +0200
Message-Id: <20230405092444.1802340-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405092444.1802340-1-mkl@pengutronix.de>
References: <20230405092444.1802340-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

As discussed with Dae R. Jeong and Hillf Danton here [1] the sendmsg()
function in isotp.c might get into a race condition when restoring the
former tx.state from the old_state.

Remove the old_state concept and implement proper locking for the
ISOTP_IDLE transitions in isotp_sendmsg(), inspired by a
simplification idea from Hillf Danton.

Introduce a new tx.state ISOTP_SHUTDOWN and use the same locking
mechanism from isotp_release() which resolves a potential race between
isotp_sendsmg() and isotp_release().

[1] https://lore.kernel.org/linux-can/ZB%2F93xJxq%2FBUqAgG@dragonet

v1: https://lore.kernel.org/all/20230331102114.15164-1-socketcan@hartkopp.net
v2: https://lore.kernel.org/all/20230331123600.3550-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_release()
v3: https://lore.kernel.org/all/20230331130654.9886-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_sendmsg() in the wait_tx_done case
v4: https://lore.kernel.org/all/20230331131935.21465-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_sendmsg() in ALL cases

Cc: Dae R. Jeong <threeearcat@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Fixes: 4f027cba8216 ("can: isotp: split tx timer into transmission and timeout")
Link: https://lore.kernel.org/all/20230331131935.21465-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
[mkl: rephrase commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 55 ++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 281b7766c54e..5761d4ab839d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,7 +119,8 @@ enum {
 	ISOTP_WAIT_FIRST_FC,
 	ISOTP_WAIT_FC,
 	ISOTP_WAIT_DATA,
-	ISOTP_SENDING
+	ISOTP_SENDING,
+	ISOTP_SHUTDOWN,
 };
 
 struct tpcon {
@@ -880,8 +881,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 					     txtimer);
 	struct sock *sk = &so->sk;
 
-	/* don't handle timeouts in IDLE state */
-	if (so->tx.state == ISOTP_IDLE)
+	/* don't handle timeouts in IDLE or SHUTDOWN state */
+	if (so->tx.state == ISOTP_IDLE || so->tx.state == ISOTP_SHUTDOWN)
 		return HRTIMER_NORESTART;
 
 	/* we did not get any flow control or echo frame in time */
@@ -918,7 +919,6 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
-	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
@@ -928,23 +928,24 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	int off;
 	int err;
 
-	if (!so->bound)
+	if (!so->bound || so->tx.state == ISOTP_SHUTDOWN)
 		return -EADDRNOTAVAIL;
 
+wait_free_buffer:
 	/* we do not support multiple buffers - for now */
-	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
-	    wq_has_sleeper(&so->wait)) {
-		if (msg->msg_flags & MSG_DONTWAIT) {
-			err = -EAGAIN;
-			goto err_out;
-		}
+	if (wq_has_sleeper(&so->wait) && (msg->msg_flags & MSG_DONTWAIT))
+		return -EAGAIN;
 
-		/* wait for complete transmission of current pdu */
-		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
-		if (err)
-			goto err_out;
+	/* wait for complete transmission of current pdu */
+	err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+	if (err)
+		goto err_event_drop;
 
-		so->tx.state = ISOTP_SENDING;
+	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
+		if (so->tx.state == ISOTP_SHUTDOWN)
+			return -EADDRNOTAVAIL;
+
+		goto wait_free_buffer;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
@@ -1074,7 +1075,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			goto err_event_drop;
 
 		if (sk->sk_err)
 			return -sk->sk_err;
@@ -1082,13 +1085,15 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	return size;
 
+err_event_drop:
+	/* got signal: force tx state machine to be idle */
+	so->tx.state = ISOTP_IDLE;
+	hrtimer_cancel(&so->txfrtimer);
+	hrtimer_cancel(&so->txtimer);
 err_out_drop:
 	/* drop this PDU and unlock a potential wait queue */
-	old_state = ISOTP_IDLE;
-err_out:
-	so->tx.state = old_state;
-	if (so->tx.state == ISOTP_IDLE)
-		wake_up_interruptible(&so->wait);
+	so->tx.state = ISOTP_IDLE;
+	wake_up_interruptible(&so->wait);
 
 	return err;
 }
@@ -1150,10 +1155,12 @@ static int isotp_release(struct socket *sock)
 	net = sock_net(sk);
 
 	/* wait for complete transmission of current pdu */
-	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+	while (wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE) == 0 &&
+	       cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SHUTDOWN) != ISOTP_IDLE)
+		;
 
 	/* force state machines to be idle also when a signal occurred */
-	so->tx.state = ISOTP_IDLE;
+	so->tx.state = ISOTP_SHUTDOWN;
 	so->rx.state = ISOTP_IDLE;
 
 	spin_lock(&isotp_notifier_lock);
-- 
2.39.2


