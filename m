Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8E116773
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfLIHVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:21:43 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:17274
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726623AbfLIHVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 02:21:43 -0500
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 8EB3D20942;
        Mon,  9 Dec 2019 07:21:38 +0000 (UTC)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net
Cc:     edumazet@google.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH v2] net/x25: add new state X25_STATE_5
Date:   Mon,  9 Dec 2019 08:21:34 +0100
Message-Id: <20191209072134.19746-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is needed, because if the flag X25_ACCPT_APPRV_FLAG is not set on a
socket (manual call confirmation) and the channel is cleared by remote
before the manual call confirmation was sent, this situation needs to
be handled.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 include/net/x25.h |  3 ++-
 net/x25/af_x25.c  |  8 ++++++++
 net/x25/x25_in.c  | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/net/x25.h b/include/net/x25.h
index ed1acc3044ac..d7d6c2b4ffa7 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -62,7 +62,8 @@ enum {
 	X25_STATE_1,		/* Awaiting Call Accepted */
 	X25_STATE_2,		/* Awaiting Clear Confirmation */
 	X25_STATE_3,		/* Data Transfer */
-	X25_STATE_4		/* Awaiting Reset Confirmation */
+	X25_STATE_4,		/* Awaiting Reset Confirmation */
+	X25_STATE_5		/* Call Accepted / Call Connected pending */
 };
 
 enum {
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index c34f7d077604..2efe44a34644 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -659,6 +659,12 @@ static int x25_release(struct socket *sock)
 			sock_set_flag(sk, SOCK_DEAD);
 			sock_set_flag(sk, SOCK_DESTROY);
 			break;
+
+		case X25_STATE_5:
+			x25_write_internal(sk, X25_CLEAR_REQUEST);
+			x25_disconnect(sk, 0, 0, 0);
+			__x25_destroy_socket(sk);
+			goto out;
 	}
 
 	sock_orphan(sk);
@@ -1054,6 +1060,8 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	if (test_bit(X25_ACCPT_APPRV_FLAG, &makex25->flags)) {
 		x25_write_internal(make, X25_CALL_ACCEPTED);
 		makex25->state = X25_STATE_3;
+	} else {
+		makex25->state = X25_STATE_5;
 	}
 
 	/*
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index f97c43344e95..4d3bb46aaae0 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -382,6 +382,35 @@ static int x25_state4_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 	return 0;
 }
 
+/*
+ * State machine for state 5, Call Accepted / Call Connected pending (X25_ACCPT_APPRV_FLAG).
+ * The handling of the timer(s) is in file x25_timer.c
+ * Handling of state 0 and connection release is in af_x25.c.
+ */
+static int x25_state5_machine(struct sock *sk, struct sk_buff *skb, int frametype)
+{
+	struct x25_sock *x25 = x25_sk(sk);
+
+	switch (frametype) {
+		case X25_CLEAR_REQUEST:
+			if (!pskb_may_pull(skb, X25_STD_MIN_LEN + 2)) {
+				x25_write_internal(sk, X25_CLEAR_REQUEST);
+				x25->state = X25_STATE_2;
+				x25_start_t23timer(sk);
+				return 0;
+			}
+
+			x25_write_internal(sk, X25_CLEAR_CONFIRMATION);
+			x25_disconnect(sk, 0, skb->data[3], skb->data[4]);
+			break;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
 /* Higher level upcall for a LAPB frame */
 int x25_process_rx_frame(struct sock *sk, struct sk_buff *skb)
 {
@@ -406,6 +435,9 @@ int x25_process_rx_frame(struct sock *sk, struct sk_buff *skb)
 	case X25_STATE_4:
 		queued = x25_state4_machine(sk, skb, frametype);
 		break;
+	case X25_STATE_5:
+		queued = x25_state5_machine(sk, skb, frametype);
+		break;
 	}
 
 	x25_kick(sk);
-- 
2.20.1

