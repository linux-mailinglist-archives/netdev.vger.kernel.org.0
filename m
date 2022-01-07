Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A3D486EA3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbiAGAUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:47570 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343960AbiAGAUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514841; x=1673050841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TfRLYQUUvmMscHCH67d3go38s+1HcbG004kqYoXQKCM=;
  b=JK+2doWd8OLw8hzXOjLQtWGntdb14PKq0CaMzFugp1iTeDJ1hHmJQ+x+
   6ody2+O3BgqTEheoVksd/Mkljni1AWvjUT3OULtuN2HeHFFSHTLt33Stp
   XJUpMCTCTusvAyaNIdKnCSSeHTW3EkD8VBetlhzoUwfw8UCycbhgtlNvn
   ong4Bz23bth0hybOykxzoBVBJPduSlRCQCc3CFAz7dQLrjng3mzxe+MH4
   5MLFgYeb29XDnNZ9epJXcTpJXR4ki5VOOSkcJ5AAx27Fg9yBOirHN/Uw0
   wYVQWBzk+9HK4hwlmfXnPEPzdoqlFKVp51nvwHQcbC0Rn/oHzXEWru4+/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="230109511"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="230109511"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508521"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 13/13] mptcp: avoid atomic bit manipulation when possible
Date:   Thu,  6 Jan 2022 16:20:26 -0800
Message-Id: <20220107002026.375427-14-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently the msk->flags bitmask carries both state for the
mptcp_release_cb() - mostly touched under the mptcp data lock
- and others state info touched even outside such lock scope.

As a consequence, msk->flags is always manipulated with
atomic operations.

This change splits such bitmask in two separate fields, so
that we use plain bit operations when touching the
cb-related info.

The MPTCP_PUSH_PENDING bit needs additional care, as it is the
only CB related field currently accessed either under the mptcp
data lock or the mptcp socket lock.
Let's add another mask just for such bit's sake.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 47 +++++++++++++++++++++++---------------------
 net/mptcp/protocol.h | 18 ++++++++++-------
 net/mptcp/subflow.c  |  4 ++--
 3 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c5f64fb0474d..62d418813503 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -763,7 +763,7 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 		if (!sock_owned_by_user(sk))
 			__mptcp_error_report(sk);
 		else
-			set_bit(MPTCP_ERROR_REPORT,  &msk->flags);
+			__set_bit(MPTCP_ERROR_REPORT,  &msk->cb_flags);
 	}
 
 	/* If the moves have caught up with the DATA_FIN sequence number
@@ -1517,9 +1517,8 @@ static void mptcp_update_post_push(struct mptcp_sock *msk,
 
 void mptcp_check_and_set_pending(struct sock *sk)
 {
-	if (mptcp_send_head(sk) &&
-	    !test_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
-		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+	if (mptcp_send_head(sk))
+		mptcp_sk(sk)->push_pending |= BIT(MPTCP_PUSH_PENDING);
 }
 
 void __mptcp_push_pending(struct sock *sk, unsigned int flags)
@@ -2134,7 +2133,7 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 			mptcp_schedule_work(sk);
 	} else {
 		/* delegate our work to tcp_release_cb() */
-		set_bit(MPTCP_RETRANSMIT, &msk->flags);
+		__set_bit(MPTCP_RETRANSMIT, &msk->cb_flags);
 	}
 	bh_unlock_sock(sk);
 	sock_put(sk);
@@ -2840,7 +2839,9 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 
 	mptcp_destroy_common(msk);
 	msk->last_snd = NULL;
-	msk->flags = 0;
+	WRITE_ONCE(msk->flags, 0);
+	msk->cb_flags = 0;
+	msk->push_pending = 0;
 	msk->recovery = false;
 	msk->can_ack = false;
 	msk->fully_established = false;
@@ -3021,7 +3022,7 @@ void __mptcp_data_acked(struct sock *sk)
 	if (!sock_owned_by_user(sk))
 		__mptcp_clean_una(sk);
 	else
-		set_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags);
+		__set_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->cb_flags);
 
 	if (mptcp_pending_data_fin_ack(sk))
 		mptcp_schedule_work(sk);
@@ -3040,22 +3041,23 @@ void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 		else if (xmit_ssk)
 			mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk), MPTCP_DELEGATE_SEND);
 	} else {
-		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+		__set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->cb_flags);
 	}
 }
 
+#define MPTCP_FLAGS_PROCESS_CTX_NEED (BIT(MPTCP_PUSH_PENDING) | \
+				      BIT(MPTCP_RETRANSMIT) | \
+				      BIT(MPTCP_FLUSH_JOIN_LIST))
+
 /* processes deferred events and flush wmem */
 static void mptcp_release_cb(struct sock *sk)
+	__must_hold(&sk->sk_lock.slock)
 {
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
 	for (;;) {
-		unsigned long flags = 0;
-
-		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
-			flags |= BIT(MPTCP_PUSH_PENDING);
-		if (test_and_clear_bit(MPTCP_RETRANSMIT, &mptcp_sk(sk)->flags))
-			flags |= BIT(MPTCP_RETRANSMIT);
-		if (test_and_clear_bit(MPTCP_FLUSH_JOIN_LIST, &mptcp_sk(sk)->flags))
-			flags |= BIT(MPTCP_FLUSH_JOIN_LIST);
+		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
+				      msk->push_pending;
 		if (!flags)
 			break;
 
@@ -3066,7 +3068,8 @@ static void mptcp_release_cb(struct sock *sk)
 		 *    datapath acquires the msk socket spinlock while helding
 		 *    the subflow socket lock
 		 */
-
+		msk->push_pending = 0;
+		msk->cb_flags &= ~flags;
 		spin_unlock_bh(&sk->sk_lock.slock);
 		if (flags & BIT(MPTCP_FLUSH_JOIN_LIST))
 			__mptcp_flush_join_list(sk);
@@ -3082,11 +3085,11 @@ static void mptcp_release_cb(struct sock *sk)
 	/* be sure to set the current sk state before tacking actions
 	 * depending on sk_state
 	 */
-	if (test_and_clear_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags))
+	if (__test_and_clear_bit(MPTCP_CONNECTED, &msk->cb_flags))
 		__mptcp_set_connected(sk);
-	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
+	if (__test_and_clear_bit(MPTCP_CLEAN_UNA, &msk->cb_flags))
 		__mptcp_clean_una_wakeup(sk);
-	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
+	if (__test_and_clear_bit(MPTCP_ERROR_REPORT, &msk->cb_flags))
 		__mptcp_error_report(sk);
 
 	__mptcp_update_rmem(sk);
@@ -3128,7 +3131,7 @@ void mptcp_subflow_process_delegated(struct sock *ssk)
 		if (!sock_owned_by_user(sk))
 			__mptcp_subflow_push_pending(sk, ssk);
 		else
-			set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+			__set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->cb_flags);
 		mptcp_data_unlock(sk);
 		mptcp_subflow_delegated_done(subflow, MPTCP_DELEGATE_SEND);
 	}
@@ -3247,7 +3250,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	} else {
 		sock_hold(ssk);
 		list_add_tail(&subflow->node, &msk->join_list);
-		set_bit(MPTCP_FLUSH_JOIN_LIST, &msk->flags);
+		__set_bit(MPTCP_FLUSH_JOIN_LIST, &msk->cb_flags);
 	}
 	mptcp_data_unlock(parent);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 962f3b6b6a1d..a77f512d5ad7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -110,18 +110,20 @@
 /* MPTCP TCPRST flags */
 #define MPTCP_RST_TRANSIENT	BIT(0)
 
-/* MPTCP socket flags */
+/* MPTCP socket atomic flags */
 #define MPTCP_NOSPACE		1
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
-#define MPTCP_PUSH_PENDING	6
-#define MPTCP_CLEAN_UNA		7
-#define MPTCP_ERROR_REPORT	8
-#define MPTCP_RETRANSMIT	9
-#define MPTCP_FLUSH_JOIN_LIST	10
-#define MPTCP_CONNECTED		11
+
+/* MPTCP socket release cb flags */
+#define MPTCP_PUSH_PENDING	1
+#define MPTCP_CLEAN_UNA		2
+#define MPTCP_ERROR_REPORT	3
+#define MPTCP_RETRANSMIT	4
+#define MPTCP_FLUSH_JOIN_LIST	5
+#define MPTCP_CONNECTED		6
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -250,6 +252,8 @@ struct mptcp_sock {
 	u32		token;
 	int		rmem_released;
 	unsigned long	flags;
+	unsigned long	cb_flags;
+	unsigned long	push_pending;
 	bool		recovery;		/* closing subflow write queue reinjected */
 	bool		can_ack;
 	bool		fully_established;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a1cd39f97659..5bedc7e88977 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -388,7 +388,7 @@ static void mptcp_set_connected(struct sock *sk)
 	if (!sock_owned_by_user(sk))
 		__mptcp_set_connected(sk);
 	else
-		set_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags);
+		__set_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->cb_flags);
 	mptcp_data_unlock(sk);
 }
 
@@ -1274,7 +1274,7 @@ static void subflow_error_report(struct sock *ssk)
 	if (!sock_owned_by_user(sk))
 		__mptcp_error_report(sk);
 	else
-		set_bit(MPTCP_ERROR_REPORT,  &mptcp_sk(sk)->flags);
+		__set_bit(MPTCP_ERROR_REPORT,  &mptcp_sk(sk)->cb_flags);
 	mptcp_data_unlock(sk);
 }
 
-- 
2.34.1

