Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0834AE8C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCZS15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:27:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:12659 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhCZS1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:34 -0400
IronPort-SDR: 0VgK4ySsIU8XFdhU5GOgtlPj16JAE87R9xtfpwKHTP3k8gXoM0msx7lQvUnJcrT2zqgLi/7Uli
 QXVen7FRHvyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276342983"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276342983"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:33 -0700
IronPort-SDR: ukOQwGLX5QrTOfu/sOr1DdCjH3Wo2bYyu5JdcRQBZO0fAgVLriu/KH73bmYfBdCvZriQyVm2B5
 BsUyr3wwiPJg==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456534"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/13] mptcp: clean-up the rtx path
Date:   Fri, 26 Mar 2021 11:26:30 -0700
Message-Id: <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
References: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After the previous patch we can easily avoid invoking
the workqueue to perform the retransmission, if the
msk socket lock is held at rtx timer expiration.

This also simplifies the relevant code.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 42 +++++++++++-------------------------------
 net/mptcp/protocol.h |  1 +
 2 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1590b9d4cde2..171b77537dcb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2047,28 +2047,21 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	return copied;
 }
 
-static void mptcp_retransmit_handler(struct sock *sk)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	set_bit(MPTCP_WORK_RTX, &msk->flags);
-	mptcp_schedule_work(sk);
-}
-
 static void mptcp_retransmit_timer(struct timer_list *t)
 {
 	struct inet_connection_sock *icsk = from_timer(icsk, t,
 						       icsk_retransmit_timer);
 	struct sock *sk = &icsk->icsk_inet.sk;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk)) {
-		mptcp_retransmit_handler(sk);
+		/* we need a process context to retransmit */
+		if (!test_and_set_bit(MPTCP_WORK_RTX, &msk->flags))
+			mptcp_schedule_work(sk);
 	} else {
 		/* delegate our work to tcp_release_cb() */
-		if (!test_and_set_bit(TCP_WRITE_TIMER_DEFERRED,
-				      &sk->sk_tsq_flags))
-			sock_hold(sk);
+		set_bit(MPTCP_RETRANSMIT, &msk->flags);
 	}
 	bh_unlock_sock(sk);
 	sock_put(sk);
@@ -2958,17 +2951,16 @@ void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 	}
 }
 
-#define MPTCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED)
-
 /* processes deferred events and flush wmem */
 static void mptcp_release_cb(struct sock *sk)
 {
-	unsigned long flags, nflags;
-
 	for (;;) {
-		flags = 0;
+		unsigned long flags = 0;
+
 		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
 			flags |= BIT(MPTCP_PUSH_PENDING);
+		if (test_and_clear_bit(MPTCP_RETRANSMIT, &mptcp_sk(sk)->flags))
+			flags |= BIT(MPTCP_RETRANSMIT);
 		if (!flags)
 			break;
 
@@ -2983,6 +2975,8 @@ static void mptcp_release_cb(struct sock *sk)
 		spin_unlock_bh(&sk->sk_lock.slock);
 		if (flags & BIT(MPTCP_PUSH_PENDING))
 			__mptcp_push_pending(sk, 0);
+		if (flags & BIT(MPTCP_RETRANSMIT))
+			__mptcp_retrans(sk);
 
 		cond_resched();
 		spin_lock_bh(&sk->sk_lock.slock);
@@ -2998,20 +2992,6 @@ static void mptcp_release_cb(struct sock *sk)
 	 */
 	__mptcp_update_wmem(sk);
 	__mptcp_update_rmem(sk);
-
-	do {
-		flags = sk->sk_tsq_flags;
-		if (!(flags & MPTCP_DEFERRED_ALL))
-			return;
-		nflags = flags & ~MPTCP_DEFERRED_ALL;
-	} while (cmpxchg(&sk->sk_tsq_flags, flags, nflags) != flags);
-
-	sock_release_ownership(sk);
-
-	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
-		mptcp_retransmit_handler(sk);
-		__sock_put(sk);
-	}
 }
 
 void mptcp_subflow_process_delegated(struct sock *ssk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1111a99b024f..0116308f5f69 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -104,6 +104,7 @@
 #define MPTCP_PUSH_PENDING	6
 #define MPTCP_CLEAN_UNA		7
 #define MPTCP_ERROR_REPORT	8
+#define MPTCP_RETRANSMIT	9
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
-- 
2.31.0

