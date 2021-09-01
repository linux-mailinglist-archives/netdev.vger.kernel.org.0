Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725A13FE105
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbhIARQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:16:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:61160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344614AbhIARQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 13:16:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="304389176"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="304389176"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 10:15:43 -0700
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="645852934"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.226.118])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 10:15:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net v3 1/2] mptcp: fix possible divide by zero
Date:   Wed,  1 Sep 2021 10:15:36 -0700
Message-Id: <20210901171537.121255-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901171537.121255-1-mathew.j.martineau@linux.intel.com>
References: <20210901171537.121255-1-mathew.j.martineau@linux.intel.com>
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

v1 -> v2:
 - use lockdep_assert_held_once() - Jakub
 - fix indentation - Jakub

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 724cfd2ee8aa ("mptcp: allocate TX skbs in msk context")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 76 ++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 41 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ade648c3512b..a4c6e37e07c9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1003,6 +1003,13 @@ static void mptcp_wmem_uncharge(struct sock *sk, int size)
 	msk->wmem_reserved += size;
 }
 
+static void __mptcp_mem_reclaim_partial(struct sock *sk)
+{
+	lockdep_assert_held_once(&sk->sk_lock.slock);
+	__mptcp_update_wmem(sk);
+	sk_mem_reclaim_partial(sk);
+}
+
 static void mptcp_mem_reclaim_partial(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1094,12 +1101,8 @@ static void __mptcp_clean_una(struct sock *sk)
 		msk->recovery = false;
 
 out:
-	if (cleaned) {
-		if (tcp_under_memory_pressure(sk)) {
-			__mptcp_update_wmem(sk);
-			sk_mem_reclaim_partial(sk);
-		}
-	}
+	if (cleaned && tcp_under_memory_pressure(sk))
+		__mptcp_mem_reclaim_partial(sk);
 
 	if (snd_una == READ_ONCE(msk->snd_nxt) && !msk->recovery) {
 		if (mptcp_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
@@ -1179,6 +1182,7 @@ struct mptcp_sendmsg_info {
 	u16 limit;
 	u16 sent;
 	unsigned int flags;
+	bool data_lock_held;
 };
 
 static int mptcp_check_allowed_size(struct mptcp_sock *msk, u64 data_seq,
@@ -1250,17 +1254,17 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
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
@@ -1284,7 +1288,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
 	struct sk_buff *skb, *tail;
-	bool can_collapse = false;
+	bool must_collapse = false;
 	int size_bias = 0;
 	int avail_size;
 	size_t ret = 0;
@@ -1304,16 +1308,24 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
@@ -1343,7 +1355,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (skb == tail) {
 		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
 		mpext->data_len += ret;
-		WARN_ON_ONCE(!can_collapse);
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
@@ -1530,15 +1541,6 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			if (ssk != prev_ssk)
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
@@ -1571,7 +1573,9 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct mptcp_sendmsg_info info;
+	struct mptcp_sendmsg_info info = {
+		.data_lock_held = true,
+	};
 	struct mptcp_data_frag *dfrag;
 	struct sock *xmit_ssk;
 	int len, copied = 0;
@@ -1597,13 +1601,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
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
@@ -2409,9 +2406,6 @@ static void __mptcp_retrans(struct sock *sk)
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

