Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757403AF8D7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhFUW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:11257 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhFUW5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:57:01 -0400
IronPort-SDR: uB1dQZS1mPLVdKDWsiTclrtV5XXORveOYRFSdogSMj2p/4B81Cvg/L3Zo4soRsA2lc953yq6S/
 WZ95RPbsu/aA==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768515"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768515"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
IronPort-SDR: 0ePL0ZwUGPWE8jbvmdIsG0EJ0+0XrYSeZ7z7sJL9jCjNMzxDmgjZ/7uWgaQkvSJyMeioEMBBLR
 deIL9Ug4yMUg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673969"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: drop tx skb cache
Date:   Mon, 21 Jun 2021 15:54:33 -0700
Message-Id: <20210621225438.10777-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mentioned cache was introduced to reduce the number of skb
allocation in atomic context, but the required complexity is
excessive.

This change remove the mentioned cache.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 89 ++------------------------------------------
 net/mptcp/protocol.h |  2 -
 2 files changed, 4 insertions(+), 87 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b5f2f504b85b..77c90d6f04df 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -902,22 +902,14 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static int mptcp_wmem_with_overhead(struct sock *sk, int size)
+static int mptcp_wmem_with_overhead(int size)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	int ret, skbs;
-
-	ret = size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
-	skbs = (msk->tx_pending_data + size) / msk->size_goal_cache;
-	if (skbs < msk->skb_tx_cache.qlen)
-		return ret;
-
-	return ret + (skbs - msk->skb_tx_cache.qlen) * SKB_TRUESIZE(MAX_TCP_HEADER);
+	return size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
 }
 
 static void __mptcp_wmem_reserve(struct sock *sk, int size)
 {
-	int amount = mptcp_wmem_with_overhead(sk, size);
+	int amount = mptcp_wmem_with_overhead(size);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	WARN_ON_ONCE(msk->wmem_reserved);
@@ -1212,49 +1204,8 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	return NULL;
 }
 
-static bool mptcp_tx_cache_refill(struct sock *sk, int size,
-				  struct sk_buff_head *skbs, int *total_ts)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct sk_buff *skb;
-	int space_needed;
-
-	if (unlikely(tcp_under_memory_pressure(sk))) {
-		mptcp_mem_reclaim_partial(sk);
-
-		/* under pressure pre-allocate at most a single skb */
-		if (msk->skb_tx_cache.qlen)
-			return true;
-		space_needed = msk->size_goal_cache;
-	} else {
-		space_needed = msk->tx_pending_data + size -
-			       msk->skb_tx_cache.qlen * msk->size_goal_cache;
-	}
-
-	while (space_needed > 0) {
-		skb = __mptcp_do_alloc_tx_skb(sk, sk->sk_allocation);
-		if (unlikely(!skb)) {
-			/* under memory pressure, try to pass the caller a
-			 * single skb to allow forward progress
-			 */
-			while (skbs->qlen > 1) {
-				skb = __skb_dequeue_tail(skbs);
-				*total_ts -= skb->truesize;
-				__kfree_skb(skb);
-			}
-			return skbs->qlen > 0;
-		}
-
-		*total_ts += skb->truesize;
-		__skb_queue_tail(skbs, skb);
-		space_needed -= msk->size_goal_cache;
-	}
-	return true;
-}
-
 static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct sk_buff *skb;
 
 	if (ssk->sk_tx_skb_cache) {
@@ -1265,22 +1216,6 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 		return true;
 	}
 
-	skb = skb_peek(&msk->skb_tx_cache);
-	if (skb) {
-		if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
-			skb = __skb_dequeue(&msk->skb_tx_cache);
-			if (WARN_ON_ONCE(!skb))
-				return false;
-
-			mptcp_wmem_uncharge(sk, skb->truesize);
-			ssk->sk_tx_skb_cache = skb;
-			return true;
-		}
-
-		/* over memory limit, no point to try to allocate a new skb */
-		return false;
-	}
-
 	skb = __mptcp_do_alloc_tx_skb(sk, gfp);
 	if (!skb)
 		return false;
@@ -1296,7 +1231,6 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 static bool mptcp_must_reclaim_memory(struct sock *sk, struct sock *ssk)
 {
 	return !ssk->sk_tx_skb_cache &&
-	       !skb_peek(&mptcp_sk(sk)->skb_tx_cache) &&
 	       tcp_under_memory_pressure(sk);
 }
 
@@ -1339,7 +1273,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
 	avail_size = info->size_goal;
-	msk->size_goal_cache = info->size_goal;
 	skb = tcp_write_queue_tail(ssk);
 	if (skb) {
 		/* Limit the write to the size available in the
@@ -1688,7 +1621,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	while (msg_data_left(msg)) {
 		int total_ts, frag_truesize = 0;
 		struct mptcp_data_frag *dfrag;
-		struct sk_buff_head skbs;
 		bool dfrag_collapsed;
 		size_t psize, offset;
 
@@ -1721,16 +1653,10 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		psize = pfrag->size - offset;
 		psize = min_t(size_t, psize, msg_data_left(msg));
 		total_ts = psize + frag_truesize;
-		__skb_queue_head_init(&skbs);
-		if (!mptcp_tx_cache_refill(sk, psize, &skbs, &total_ts))
-			goto wait_for_memory;
 
-		if (!mptcp_wmem_alloc(sk, total_ts)) {
-			__skb_queue_purge(&skbs);
+		if (!mptcp_wmem_alloc(sk, total_ts))
 			goto wait_for_memory;
-		}
 
-		skb_queue_splice_tail(&skbs, &msk->skb_tx_cache);
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
 			mptcp_wmem_uncharge(sk, psize + frag_truesize);
@@ -2462,13 +2388,11 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->rtx_queue);
 	INIT_WORK(&msk->work, mptcp_worker);
 	__skb_queue_head_init(&msk->receive_queue);
-	__skb_queue_head_init(&msk->skb_tx_cache);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
 	msk->wmem_reserved = 0;
 	msk->rmem_released = 0;
 	msk->tx_pending_data = 0;
-	msk->size_goal_cache = TCP_BASE_MSS;
 
 	msk->ack_hint = NULL;
 	msk->first = NULL;
@@ -2525,15 +2449,10 @@ static void __mptcp_clear_xmit(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
-	struct sk_buff *skb;
 
 	WRITE_ONCE(msk->first_pending, NULL);
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
-	while ((skb = __skb_dequeue(&msk->skb_tx_cache)) != NULL) {
-		sk->sk_forward_alloc += skb->truesize;
-		kfree_skb(skb);
-	}
 }
 
 static void mptcp_cancel_work(struct sock *sk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 160d716ebc2b..160c2ab09f19 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -245,9 +245,7 @@ struct mptcp_sock {
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
 	struct sk_buff_head receive_queue;
-	struct sk_buff_head skb_tx_cache;	/* this is wmem accounted */
 	int		tx_pending_data;
-	int		size_goal_cache;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
-- 
2.32.0

