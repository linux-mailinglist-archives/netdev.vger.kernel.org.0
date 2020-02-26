Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C6F16FA69
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBZJPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:24 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60780 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727744AbgBZJPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:23 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smo-0001NO-If; Wed, 26 Feb 2020 10:15:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 6/7] mptcp: avoid work queue scheduling if possible
Date:   Wed, 26 Feb 2020 10:14:51 +0100
Message-Id: <20200226091452.1116-7-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't lock_sock() the mptcp socket from the subflow data_ready callback,
it would result in ABBA deadlock with the subflow socket lock.

We can however grab the spinlock: if that succeeds and the mptcp socket
is not owned at the moment, we can process the new skbs right away
without deferring this to the work queue.

This avoids the schedule_work and hence the small delay until the
work item is processed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 29 ++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  |  4 ++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b781498e69b4..70f20c8eddbd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -201,12 +201,39 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	return done;
 }
 
-void mptcp_data_ready(struct sock *sk)
+/* In most cases we will be able to lock the mptcp socket.  If its already
+ * owned, we need to defer to the work queue to avoid ABBA deadlock.
+ */
+static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct sock *sk = (struct sock *)msk;
+	unsigned int moved = 0;
+
+	if (READ_ONCE(sk->sk_lock.owned))
+		return false;
+
+	if (unlikely(!spin_trylock_bh(&sk->sk_lock.slock)))
+		return false;
+
+	/* must re-check after taking the lock */
+	if (!READ_ONCE(sk->sk_lock.owned))
+		__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+
+	spin_unlock_bh(&sk->sk_lock.slock);
+
+	return moved > 0;
+}
+
+void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	set_bit(MPTCP_DATA_READY, &msk->flags);
 
+	if (atomic_read(&sk->sk_rmem_alloc) < READ_ONCE(sk->sk_rcvbuf) &&
+	    move_skbs_to_msk(msk, ssk))
+		goto wake;
+
 	/* don't schedule if mptcp sk is (still) over limit */
 	if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf))
 		goto wake;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d06170c5f191..6c0b2c8ab674 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -195,7 +195,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
 void mptcp_finish_connect(struct sock *sk);
-void mptcp_data_ready(struct sock *sk);
+void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 37a4767db441..0de2a44bdaa0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -563,7 +563,7 @@ static void subflow_data_ready(struct sock *sk)
 	}
 
 	if (mptcp_subflow_data_available(sk))
-		mptcp_data_ready(parent);
+		mptcp_data_ready(parent, sk);
 }
 
 static void subflow_write_space(struct sock *sk)
@@ -696,7 +696,7 @@ static void subflow_state_change(struct sock *sk)
 	 * the data available machinery here.
 	 */
 	if (parent && subflow->mp_capable && mptcp_subflow_data_available(sk))
-		mptcp_data_ready(parent);
+		mptcp_data_ready(parent, sk);
 
 	if (parent && !(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
-- 
2.24.1

