Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47A3FA216
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhH1ASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:18:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:60799 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhH1ASf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:18:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="205257940"
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; 
   d="scan'208";a="205257940"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 17:17:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; 
   d="scan'208";a="528512881"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.16.51])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 17:17:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: fix possible divide by zero
Date:   Fri, 27 Aug 2021 17:17:30 -0700
Message-Id: <20210828001731.67757-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210828001731.67757-1-mathew.j.martineau@linux.intel.com>
References: <20210828001731.67757-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Florian noted that if mptcp_alloc_tx_skb() allocation fails
in __mptcp_push_pending(), we can end-up invoking
mptcp_push_release()/tcp_push() with a zero mss, causing
a divide by 0 error.

This change addresses the issue refactoring the skb allocation
code checking if skb collapsing will happen for sure and doing
the skb allocation only after such check. Skb allocation will
now happen only after the call to tcp_send_mss() which
correctly initializes mss_now.

As side bonuses we now fill the skb tx cache only when needed,
and this also clean-up a bit the output path.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 724cfd2ee8aa ("mptcp: allocate TX skbs in msk context")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 78 +++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a88924947815..0d5c1ec28508 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -994,6 +994,15 @@ static void mptcp_wmem_uncharge(struct sock *sk, int size)
 	msk->wmem_reserved += size;
 }
 
+static void __mptcp_mem_reclaim_partial(struct sock *sk)
+{
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
+#endif
+	__mptcp_update_wmem(sk);
+	sk_mem_reclaim_partial(sk);
+}
+
 static void mptcp_mem_reclaim_partial(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1069,12 +1078,8 @@ static void __mptcp_clean_una(struct sock *sk)
 	}
 
 out:
-	if (cleaned) {
-		if (tcp_under_memory_pressure(sk)) {
-			__mptcp_update_wmem(sk);
-			sk_mem_reclaim_partial(sk);
-		}
-	}
+	if (cleaned && tcp_under_memory_pressure(sk))
+		__mptcp_mem_reclaim_partial(sk);
 
 	if (snd_una == READ_ONCE(msk->snd_nxt)) {
 		if (msk->timer_ival && !mptcp_data_fin_enabled(msk))
@@ -1154,6 +1159,7 @@ struct mptcp_sendmsg_info {
 	u16 limit;
 	u16 sent;
 	unsigned int flags;
+	bool data_lock_held;
 };
 
 static int mptcp_check_allowed_size(struct mptcp_sock *msk, u64 data_seq,
@@ -1225,17 +1231,17 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 	return false;
 }
 
-static bool mptcp_must_reclaim_memory(struct sock *sk, struct sock *ssk)
+static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
 {
-	return !ssk->sk_tx_skb_cache &&
-	       tcp_under_memory_pressure(sk);
-}
+	gfp_t gfp = data_lock_held ? GFP_ATOMIC : sk->sk_allocation;
 
-static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
-{
-	if (unlikely(mptcp_must_reclaim_memory(sk, ssk)))
-		mptcp_mem_reclaim_partial(sk);
-	return __mptcp_alloc_tx_skb(sk, ssk, sk->sk_allocation);
+	if (unlikely(tcp_under_memory_pressure(sk))) {
+		if (data_lock_held)
+			__mptcp_mem_reclaim_partial(sk);
+		else
+			mptcp_mem_reclaim_partial(sk);
+	}
+	return __mptcp_alloc_tx_skb(sk, ssk, gfp);
 }
 
 /* note: this always recompute the csum on the whole skb, even
@@ -1259,7 +1265,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
 	struct sk_buff *skb, *tail;
-	bool can_collapse = false;
+	bool must_collapse = false;
 	int size_bias = 0;
 	int avail_size;
 	size_t ret = 0;
@@ -1279,16 +1285,24 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 * SSN association set here
 		 */
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
-		can_collapse = (info->size_goal - skb->len > 0) &&
-			 mptcp_skb_can_collapse_to(data_seq, skb, mpext);
-		if (!can_collapse) {
+		if (!mptcp_skb_can_collapse_to(data_seq, skb, mpext)) {
 			TCP_SKB_CB(skb)->eor = 1;
-		} else {
+			goto alloc_skb;
+		}
+
+		must_collapse = (info->size_goal - skb->len > 0) &&
+				(skb_shinfo(skb)->nr_frags < sysctl_max_skb_frags);
+		if (must_collapse) {
 			size_bias = skb->len;
 			avail_size = info->size_goal - skb->len;
 		}
 	}
 
+alloc_skb:
+	if (!must_collapse && !ssk->sk_tx_skb_cache &&
+	    !mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held))
+		return 0;
+
 	/* Zero window and all data acked? Probe. */
 	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
 	if (avail_size == 0) {
@@ -1318,7 +1332,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (skb == tail) {
 		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
 		mpext->data_len += ret;
-		WARN_ON_ONCE(!can_collapse);
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
@@ -1470,15 +1483,6 @@ static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			if (ssk != prev_ssk || !prev_ssk)
 				lock_sock(ssk);
 
-			/* keep it simple and always provide a new skb for the
-			 * subflow, even if we will not use it when collapsing
-			 * on the pending one
-			 */
-			if (!mptcp_alloc_tx_skb(sk, ssk)) {
-				mptcp_push_release(sk, ssk, &info);
-				goto out;
-			}
-
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0) {
 				mptcp_push_release(sk, ssk, &info);
@@ -1512,7 +1516,9 @@ static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct mptcp_sendmsg_info info;
+	struct mptcp_sendmsg_info info = {
+				 .data_lock_held = true,
+	};
 	struct mptcp_data_frag *dfrag;
 	struct sock *xmit_ssk;
 	int len, copied = 0;
@@ -1538,13 +1544,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 				goto out;
 			}
 
-			if (unlikely(mptcp_must_reclaim_memory(sk, ssk))) {
-				__mptcp_update_wmem(sk);
-				sk_mem_reclaim_partial(sk);
-			}
-			if (!__mptcp_alloc_tx_skb(sk, ssk, GFP_ATOMIC))
-				goto out;
-
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0)
 				goto out;
@@ -2296,9 +2295,6 @@ static void __mptcp_retrans(struct sock *sk)
 	info.sent = 0;
 	info.limit = READ_ONCE(msk->csum_enabled) ? dfrag->data_len : dfrag->already_sent;
 	while (info.sent < info.limit) {
-		if (!mptcp_alloc_tx_skb(sk, ssk))
-			break;
-
 		ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 		if (ret <= 0)
 			break;
-- 
2.33.0

