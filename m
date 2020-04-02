Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEDD19C05C
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgDBLpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:45:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44672 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:45:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJyHV-0002ir-HC; Thu, 02 Apr 2020 13:45:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 2/4] mptcp: subflow: check parent mptcp socket on subflow state change
Date:   Thu,  2 Apr 2020 13:44:52 +0200
Message-Id: <20200402114454.8533-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402114454.8533-1-fw@strlen.de>
References: <20200402114454.8533-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is needed at least until proper MPTCP-Level fin/reset
signalling gets added:

We wake parent when a subflow changes, but we should do this only
when all subflows have closed, not just one.

Schedule the mptcp worker and tell it to check eof state on all
subflows.

Only flag mptcp socket as closed and wake userspace processes blocking
in poll if all subflows have closed.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 33 +++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  |  3 +--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4cf88e3d5121..8cc9dd2cc828 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -327,6 +327,15 @@ void mptcp_data_acked(struct sock *sk)
 		sock_hold(sk);
 }
 
+void mptcp_subflow_eof(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (!test_and_set_bit(MPTCP_WORK_EOF, &msk->flags) &&
+	    schedule_work(&msk->work))
+		sock_hold(sk);
+}
+
 static void mptcp_stop_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1031,6 +1040,27 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
+static void mptcp_check_for_eof(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int receivers = 0;
+
+	mptcp_for_each_subflow(msk, subflow)
+		receivers += !subflow->rx_eof;
+
+	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
+		/* hopefully temporary hack: propagate shutdown status
+		 * to msk, when all subflows agree on it
+		 */
+		sk->sk_shutdown |= RCV_SHUTDOWN;
+
+		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		sk->sk_data_ready(sk);
+	}
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -1047,6 +1077,9 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_flush_join_list(msk);
 	__mptcp_move_skbs(msk);
 
+	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
+		mptcp_check_for_eof(msk);
+
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f733c5425552..67448002a2d7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -89,6 +89,7 @@
 #define MPTCP_DATA_READY	0
 #define MPTCP_SEND_SPACE	1
 #define MPTCP_WORK_RTX		2
+#define MPTCP_WORK_EOF		3
 
 static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 {
@@ -339,6 +340,7 @@ void mptcp_finish_connect(struct sock *sk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
+void mptcp_subflow_eof(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b5180c81588e..50a8bea987c6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -994,8 +994,7 @@ static void subflow_state_change(struct sock *sk)
 	if (!(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
 		subflow->rx_eof = 1;
-		parent->sk_shutdown |= RCV_SHUTDOWN;
-		__subflow_state_change(parent);
+		mptcp_subflow_eof(parent);
 	}
 }
 
-- 
2.24.1

