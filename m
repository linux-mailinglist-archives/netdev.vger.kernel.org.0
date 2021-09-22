Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A168414F06
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhIVR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236842AbhIVR2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M07wprL0X3f7HruIFF/SqWbzyeUsqMkXranvpz3WQoE=;
        b=YfVojZafsEm2fEsowUfqV/AALVBzWwXpj0BO7cZd4DWT66mOiK4qHTvLsYge54rocF9/wY
        yJbwRY8J0jrwZbMYSZCmezly6GcabcnsKSl6uftpR1ss4z1ZAf5na82i/LhnAvxOHIL94y
        Tp9cxgj2WPlAl+n0Lkgw09tZfaYL+JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-9SsQ3LRRPs6POAjkeAG6og-1; Wed, 22 Sep 2021 13:27:02 -0400
X-MC-Unique: 9SsQ3LRRPs6POAjkeAG6og-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F051006AA3;
        Wed, 22 Sep 2021 17:27:01 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEB4919733;
        Wed, 22 Sep 2021 17:26:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [PATCH net-next 2/4] mptcp: stop relying on tcp_tx_skb_cache
Date:   Wed, 22 Sep 2021 19:26:41 +0200
Message-Id: <7507d77018397cff4238b4b058dd770197078c82.1632318035.git.pabeni@redhat.com>
In-Reply-To: <cover.1632318035.git.pabeni@redhat.com>
References: <cover.1632318035.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to revert the skb TX cache, but MPTCP is currently
using it unconditionally.

Rework the MPTCP tx code, so that tcp_tx_skb_cache is not
needed anymore: do the whole coalescing check, skb allocation
skb initialization/update inside mptcp_sendmsg_frag(), quite
alike the current TCP code.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 137 ++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dbcebf56798f..7e5f76092b64 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1224,6 +1224,7 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
 			skb->reserved_tailroom = skb->end - skb->tail;
+			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
 		__kfree_skb(skb);
@@ -1233,31 +1234,23 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	return NULL;
 }
 
-static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
+static struct sk_buff *__mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 {
 	struct sk_buff *skb;
 
-	if (ssk->sk_tx_skb_cache) {
-		skb = ssk->sk_tx_skb_cache;
-		if (unlikely(!skb_ext_find(skb, SKB_EXT_MPTCP) &&
-			     !__mptcp_add_ext(skb, gfp)))
-			return false;
-		return true;
-	}
-
 	skb = __mptcp_do_alloc_tx_skb(sk, gfp);
 	if (!skb)
-		return false;
+		return NULL;
 
 	if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
-		ssk->sk_tx_skb_cache = skb;
-		return true;
+		tcp_skb_entail(ssk, skb);
+		return skb;
 	}
 	kfree_skb(skb);
-	return false;
+	return NULL;
 }
 
-static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
+static struct sk_buff *mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
 {
 	gfp_t gfp = data_lock_held ? GFP_ATOMIC : sk->sk_allocation;
 
@@ -1287,23 +1280,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_sendmsg_info *info)
 {
 	u64 data_seq = dfrag->data_seq + info->sent;
+	int offset = dfrag->offset + info->sent;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
-	struct sk_buff *skb, *tail;
-	bool must_collapse = false;
-	int size_bias = 0;
-	int avail_size;
-	size_t ret = 0;
+	bool can_coalesce = false;
+	bool reuse_skb = true;
+	struct sk_buff *skb;
+	size_t copy;
+	int i;
 
 	pr_debug("msk=%p ssk=%p sending dfrag at seq=%llu len=%u already sent=%u",
 		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
 
+	if (WARN_ON_ONCE(info->sent > info->limit ||
+			 info->limit > dfrag->data_len))
+		return 0;
+
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
-	avail_size = info->size_goal;
+	copy = info->size_goal;
+
 	skb = tcp_write_queue_tail(ssk);
-	if (skb) {
+	if (skb && copy > skb->len) {
 		/* Limit the write to the size available in the
 		 * current skb, if any, so that we create at most a new skb.
 		 * Explicitly tells TCP internals to avoid collapsing on later
@@ -1316,62 +1315,80 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			goto alloc_skb;
 		}
 
-		must_collapse = (info->size_goal > skb->len) &&
-				(skb_shinfo(skb)->nr_frags < sysctl_max_skb_frags);
-		if (must_collapse) {
-			size_bias = skb->len;
-			avail_size = info->size_goal - skb->len;
+		i = skb_shinfo(skb)->nr_frags;
+		can_coalesce = skb_can_coalesce(skb, i, dfrag->page, offset);
+		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+			tcp_mark_push(tcp_sk(ssk), skb);
+			goto alloc_skb;
 		}
-	}
 
+		copy -= skb->len;
+	} else {
 alloc_skb:
-	if (!must_collapse &&
-	    !mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held))
-		return 0;
+		skb = mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held);
+		if (!skb)
+			return -ENOMEM;
+
+		i = skb_shinfo(skb)->nr_frags;
+		reuse_skb = false;
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
+	}
 
 	/* Zero window and all data acked? Probe. */
-	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
-	if (avail_size == 0) {
+	copy = mptcp_check_allowed_size(msk, data_seq, copy);
+	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (skb || snd_una != msk->snd_nxt)
+		if (snd_una != msk->snd_nxt) {
+			tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 			return 0;
+		}
+
 		zero_window_probe = true;
 		data_seq = snd_una - 1;
-		avail_size = 1;
-	}
+		copy = 1;
 
-	if (WARN_ON_ONCE(info->sent > info->limit ||
-			 info->limit > dfrag->data_len))
-		return 0;
+		/* all mptcp-level data is acked, no skbs should be present into the
+		 * ssk write queue
+		 */
+		WARN_ON_ONCE(reuse_skb);
+	}
 
-	ret = info->limit - info->sent;
-	tail = tcp_build_frag(ssk, avail_size + size_bias, info->flags,
-			      dfrag->page, dfrag->offset + info->sent, &ret);
-	if (!tail) {
-		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
+	copy = min_t(size_t, copy, info->limit - info->sent);
+	if (!sk_wmem_schedule(ssk, copy)) {
+		tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 		return -ENOMEM;
 	}
 
-	/* if the tail skb is still the cached one, collapsing really happened.
-	 */
-	if (skb == tail) {
-		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
-		mpext->data_len += ret;
+	if (can_coalesce) {
+		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+	} else {
+		get_page(dfrag->page);
+		skb_fill_page_desc(skb, i, dfrag->page, offset, copy);
+	}
+
+	skb->len += copy;
+	skb->data_len += copy;
+	skb->truesize += copy;
+	sk_wmem_queued_add(ssk, copy);
+	sk_mem_charge(ssk, copy);
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	WRITE_ONCE(tcp_sk(ssk)->write_seq, tcp_sk(ssk)->write_seq + copy);
+	TCP_SKB_CB(skb)->end_seq += copy;
+	tcp_skb_pcount_set(skb, 0);
+
+	/* on skb reuse we just need to update the DSS len */
+	if (reuse_skb) {
+		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
+		mpext->data_len += copy;
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
 
-	mpext = skb_ext_find(tail, SKB_EXT_MPTCP);
-	if (WARN_ON_ONCE(!mpext)) {
-		/* should never reach here, stream corrupted */
-		return -EINVAL;
-	}
-
 	memset(mpext, 0, sizeof(*mpext));
 	mpext->data_seq = data_seq;
 	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
-	mpext->data_len = ret;
+	mpext->data_len = copy;
 	mpext->use_map = 1;
 	mpext->dsn64 = 1;
 
@@ -1380,18 +1397,18 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 	if (zero_window_probe) {
-		mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
+		mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
 		mpext->frozen = 1;
 		if (READ_ONCE(msk->csum_enabled))
-			mptcp_update_data_checksum(tail, ret);
+			mptcp_update_data_checksum(skb, copy);
 		tcp_push_pending_frames(ssk);
 		return 0;
 	}
 out:
 	if (READ_ONCE(msk->csum_enabled))
-		mptcp_update_data_checksum(tail, ret);
-	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
-	return ret;
+		mptcp_update_data_checksum(skb, copy);
+	mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
+	return copy;
 }
 
 #define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
-- 
2.26.3

