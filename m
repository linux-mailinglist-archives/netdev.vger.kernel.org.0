Return-Path: <netdev+bounces-7873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDD7721EA4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 358DC2811C5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C7A53A7;
	Mon,  5 Jun 2023 07:00:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DB5194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:00:54 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F67102
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:00:53 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q64Cx-0007mw-B9
	for netdev@vger.kernel.org; Mon, 05 Jun 2023 09:00:51 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 83A1B1D20FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 77C691D20C7;
	Mon,  5 Jun 2023 06:59:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 581126c1;
	Mon, 5 Jun 2023 06:59:53 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	David Jander <david@protonic.nl>,
	stable@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/3] can: j1939: j1939_sk_send_loop_abort(): improved error queue handling in J1939 Socket
Date: Mon,  5 Jun 2023 08:59:50 +0200
Message-Id: <20230605065952.1074928-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605065952.1074928-1-mkl@pengutronix.de>
References: <20230605065952.1074928-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Oleksij Rempel <o.rempel@pengutronix.de>

This patch addresses an issue within the j1939_sk_send_loop_abort()
function in the j1939/socket.c file, specifically in the context of
Transport Protocol (TP) sessions.

Without this patch, when a TP session is initiated and a Clear To Send
(CTS) frame is received from the remote side requesting one data packet,
the kernel dispatches the first Data Transport (DT) frame and then waits
for the next CTS. If the remote side doesn't respond with another CTS,
the kernel aborts due to a timeout. This leads to the user-space
receiving an EPOLLERR on the socket, and the socket becomes active.

However, when trying to read the error queue from the socket with
sock.recvmsg(, , socket.MSG_ERRQUEUE), it returns -EAGAIN,
given that the socket is non-blocking. This situation results in an
infinite loop: the user-space repeatedly calls epoll(), epoll() returns
the socket file descriptor with EPOLLERR, but the socket then blocks on
the recv() of ERRQUEUE.

This patch introduces an additional check for the J1939_SOCK_ERRQUEUE
flag within the j1939_sk_send_loop_abort() function. If the flag is set,
it indicates that the application has subscribed to receive error queue
messages. In such cases, the kernel can communicate the current transfer
state via the error queue. This allows for the function to return early,
preventing the unnecessary setting of the socket into an error state,
and breaking the infinite loop. It is crucial to note that a socket
error is only needed if the application isn't using the error queue, as,
without it, the application wouldn't be aware of transfer issues.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: David Jander <david@protonic.nl>
Tested-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20230526081946.715190-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 1790469b2580..35970c25496a 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1088,6 +1088,11 @@ void j1939_sk_errqueue(struct j1939_session *session,
 
 void j1939_sk_send_loop_abort(struct sock *sk, int err)
 {
+	struct j1939_sock *jsk = j1939_sk(sk);
+
+	if (jsk->state & J1939_SOCK_ERRQUEUE)
+		return;
+
 	sk->sk_err = err;
 
 	sk_error_report(sk);

base-commit: 8cde87b007dad2e461015ff70352af56ceb02c75
-- 
2.39.2



