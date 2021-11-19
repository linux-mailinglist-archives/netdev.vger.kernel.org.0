Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731CB4570AE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhKSObs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:31:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235888AbhKSObs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637332126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INrXqMb0xiO+aKaGY2oTx0ddF5jN369v/Mx6mmDiDI0=;
        b=Fe78CY4ifQxRHIFDUY7qV5pAHzMcjRT7STR+Q2Y+7qeu2TOLVLN6VmX6omZf99H3hUEtzI
        E4yt9Q1UPCciC+cxwA0n6aKHtSpLH/Z8UAkKIrZiQ1xLmPa8YGBW9K/0Y2+DKOtc5vBLx1
        z1/ZqyWEkhsbSXC0k0p1FkNV37PgUCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-9Inxx5nVMkagwHz25Pe05w-1; Fri, 19 Nov 2021 09:28:41 -0500
X-MC-Unique: 9Inxx5nVMkagwHz25Pe05w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3661100C661;
        Fri, 19 Nov 2021 14:28:39 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEA18604CC;
        Fri, 19 Nov 2021 14:28:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 2/2] mptcp: use delegate action to schedule 3rd ack retrans
Date:   Fri, 19 Nov 2021 15:27:55 +0100
Message-Id: <fba74ffdd78018799c36688b137fe5e00be1d9f5.1637331462.git.pabeni@redhat.com>
In-Reply-To: <cover.1637331462.git.pabeni@redhat.com>
References: <cover.1637331462.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scheduling a delack in mptcp_established_options_mp() is
not a good idea: such function is called by tcp_send_ack() and
the pending delayed ack will be cleared shortly after by the
tcp_event_ack_sent() call in __tcp_transmit_skb().

Instead use the mptcp delegated action infrastructure to
schedule the delayed ack after the current bh processing completes.

Additionally moves the schedule_3rdack_retransmission() helper
into protocol.c to avoid making it visible in a different compilation
unit.

Fixes: ec3edaa7ca6ce02f ("mptcp: Add handling of outgoing MP_JOIN requests")
Reviewed-by: Mat Martineau <mathew.j.martineau>@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  | 33 ++++++++--------------------
 net/mptcp/protocol.c | 51 ++++++++++++++++++++++++++++++++++++--------
 net/mptcp/protocol.h | 17 ++++++++-------
 3 files changed, 60 insertions(+), 41 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 2e9b73eeeeb5..fe98e4f475ba 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -422,29 +422,6 @@ bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 	return false;
 }
 
-/* MP_JOIN client subflow must wait for 4th ack before sending any data:
- * TCP can't schedule delack timer before the subflow is fully established.
- * MPTCP uses the delack timer to do 3rd ack retransmissions
- */
-static void schedule_3rdack_retransmission(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
-	unsigned long timeout;
-
-	/* reschedule with a timeout above RTT, as we must look only for drop */
-	if (tp->srtt_us)
-		timeout = usecs_to_jiffies(tp->srtt_us >> (3 - 1));
-	else
-		timeout = TCP_TIMEOUT_INIT;
-	timeout += jiffies;
-
-	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
-	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
-	icsk->icsk_ack.timeout = timeout;
-	sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
-}
-
 static void clear_3rdack_retransmission(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -527,7 +504,15 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		*size = TCPOLEN_MPTCP_MPJ_ACK;
 		pr_debug("subflow=%p", subflow);
 
-		schedule_3rdack_retransmission(sk);
+		/* we can use the full delegate action helper only from BH context
+		 * If we are in process context - sk is flushing the backlog at
+		 * socket lock release time - just set the appropriate flag, will
+		 * be handled by the release callback
+		 */
+		if (sock_owned_by_user(sk))
+			set_bit(MPTCP_DELEGATE_ACK, &subflow->delegated_status);
+		else
+			mptcp_subflow_delegate(subflow, MPTCP_DELEGATE_ACK);
 		return true;
 	}
 	return false;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b7e32e316738..c82a76d2d0bf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1596,7 +1596,8 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 			if (!xmit_ssk)
 				goto out;
 			if (xmit_ssk != ssk) {
-				mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk));
+				mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk),
+						       MPTCP_DELEGATE_SEND);
 				goto out;
 			}
 
@@ -2943,7 +2944,7 @@ void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 		if (xmit_ssk == ssk)
 			__mptcp_subflow_push_pending(sk, ssk);
 		else if (xmit_ssk)
-			mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk));
+			mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk), MPTCP_DELEGATE_SEND);
 	} else {
 		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
 	}
@@ -2993,18 +2994,50 @@ static void mptcp_release_cb(struct sock *sk)
 	__mptcp_update_rmem(sk);
 }
 
+/* MP_JOIN client subflow must wait for 4th ack before sending any data:
+ * TCP can't schedule delack timer before the subflow is fully established.
+ * MPTCP uses the delack timer to do 3rd ack retransmissions
+ */
+static void schedule_3rdack_retransmission(struct sock *ssk)
+{
+	struct inet_connection_sock *icsk = inet_csk(ssk);
+	struct tcp_sock *tp = tcp_sk(ssk);
+	unsigned long timeout;
+
+	if (mptcp_subflow_ctx(ssk)->fully_established)
+		return;
+
+	/* reschedule with a timeout above RTT, as we must look only for drop */
+	if (tp->srtt_us)
+		timeout = usecs_to_jiffies(tp->srtt_us >> (3 - 1));
+	else
+		timeout = TCP_TIMEOUT_INIT;
+	timeout += jiffies;
+
+	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
+	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
+	icsk->icsk_ack.timeout = timeout;
+	sk_reset_timer(ssk, &icsk->icsk_delack_timer, timeout);
+}
+
 void mptcp_subflow_process_delegated(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
-	mptcp_data_lock(sk);
-	if (!sock_owned_by_user(sk))
-		__mptcp_subflow_push_pending(sk, ssk);
-	else
-		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
-	mptcp_data_unlock(sk);
-	mptcp_subflow_delegated_done(subflow);
+	if (test_bit(MPTCP_DELEGATE_SEND, &subflow->delegated_status)) {
+		mptcp_data_lock(sk);
+		if (!sock_owned_by_user(sk))
+			__mptcp_subflow_push_pending(sk, ssk);
+		else
+			set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+		mptcp_data_unlock(sk);
+		mptcp_subflow_delegated_done(subflow, MPTCP_DELEGATE_SEND);
+	}
+	if (test_bit(MPTCP_DELEGATE_ACK, &subflow->delegated_status)) {
+		schedule_3rdack_retransmission(ssk);
+		mptcp_subflow_delegated_done(subflow, MPTCP_DELEGATE_ACK);
+	}
 }
 
 static int mptcp_hash(struct sock *sk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67a61ac48b20..d87cc040352e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -387,6 +387,7 @@ struct mptcp_delegated_action {
 DECLARE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
 
 #define MPTCP_DELEGATE_SEND		0
+#define MPTCP_DELEGATE_ACK		1
 
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
@@ -492,23 +493,23 @@ static inline void mptcp_add_pending_subflow(struct mptcp_sock *msk,
 
 void mptcp_subflow_process_delegated(struct sock *ssk);
 
-static inline void mptcp_subflow_delegate(struct mptcp_subflow_context *subflow)
+static inline void mptcp_subflow_delegate(struct mptcp_subflow_context *subflow, int action)
 {
 	struct mptcp_delegated_action *delegated;
 	bool schedule;
 
+	/* the caller held the subflow bh socket lock */
+	lockdep_assert_in_softirq();
+
 	/* The implied barrier pairs with mptcp_subflow_delegated_done(), and
 	 * ensures the below list check sees list updates done prior to status
 	 * bit changes
 	 */
-	if (!test_and_set_bit(MPTCP_DELEGATE_SEND, &subflow->delegated_status)) {
+	if (!test_and_set_bit(action, &subflow->delegated_status)) {
 		/* still on delegated list from previous scheduling */
 		if (!list_empty(&subflow->delegated_node))
 			return;
 
-		/* the caller held the subflow bh socket lock */
-		lockdep_assert_in_softirq();
-
 		delegated = this_cpu_ptr(&mptcp_delegated_actions);
 		schedule = list_empty(&delegated->head);
 		list_add_tail(&subflow->delegated_node, &delegated->head);
@@ -533,16 +534,16 @@ mptcp_subflow_delegated_next(struct mptcp_delegated_action *delegated)
 
 static inline bool mptcp_subflow_has_delegated_action(const struct mptcp_subflow_context *subflow)
 {
-	return test_bit(MPTCP_DELEGATE_SEND, &subflow->delegated_status);
+	return !!READ_ONCE(subflow->delegated_status);
 }
 
-static inline void mptcp_subflow_delegated_done(struct mptcp_subflow_context *subflow)
+static inline void mptcp_subflow_delegated_done(struct mptcp_subflow_context *subflow, int action)
 {
 	/* pairs with mptcp_subflow_delegate, ensures delegate_node is updated before
 	 * touching the status bit
 	 */
 	smp_wmb();
-	clear_bit(MPTCP_DELEGATE_SEND, &subflow->delegated_status);
+	clear_bit(action, &subflow->delegated_status);
 }
 
 int mptcp_is_enabled(const struct net *net);
-- 
2.33.1

