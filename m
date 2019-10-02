Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1FC94FD
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfJBXh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862636"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 39/45] mptcp: rework mptcp_sendmsg_frag to accept optional dfrag
Date:   Wed,  2 Oct 2019 16:36:49 -0700
Message-Id: <20191002233655.24323-40-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This will simplify mptcp-level retransmission implementation
in the next patch. If dfrag is provided by the caller, skip
kernel space memory allocation and use data and metadata
provided by the dfrag itself.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 133 +++++++++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 55 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8319ee807481..6366dfd65aa8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -95,7 +95,7 @@ static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
 	return NULL;
 }
 
-static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
+static inline bool mptcp_skb_can_collapse_to(u64 write_seq,
 					     const struct sk_buff *skb,
 					     const struct mptcp_ext *mpext)
 {
@@ -103,7 +103,7 @@ static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
 		return false;
 
 	/* can collapse only if MPTCP level sequence is in order */
-	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
+	return mpext && mpext->data_seq + mpext->data_len == write_seq;
 }
 
 static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
@@ -168,31 +168,44 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 }
 
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
-			      struct msghdr *msg, long *timeo, int *pmss_now,
+			      struct msghdr *msg, struct mptcp_data_frag *dfrag,
+			      long *timeo, int *pmss_now,
 			      int *ps_goal)
 {
 	int mss_now, avail_size, size_goal, offset, ret, frag_truesize = 0;
 	bool dfrag_collapsed, collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
-	struct mptcp_data_frag *dfrag;
+	bool retransmission = !!dfrag;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
+	struct page *page;
+	u64 *write_seq;
 	size_t psize;
+	int *poffset;
 
 	/* use the mptcp page cache so that we can easily move the data
 	 * from one substream to another, but do per subflow memory accounting
+	 * Note: pfrag is used only !retransmission, but the compiler if
+	 * fooled into a warning if we don't init here
 	 */
 	pfrag = sk_page_frag(sk);
-	while (!mptcp_page_frag_refill(ssk, pfrag)) {
-		ret = sk_stream_wait_memory(ssk, timeo);
-		if (ret)
-			return ret;
-
-		/* id sk_stream_wait_memory() sleeps snd_una can change
-		 * significantly, refresh the rtx queue
-		 */
-		mptcp_clean_una(sk);
+	if (!retransmission) {
+		while (!mptcp_page_frag_refill(ssk, pfrag)) {
+			ret = sk_stream_wait_memory(ssk, timeo);
+			if (ret)
+				return ret;
+
+			/* id sk_stream_wait_memory() sleeps snd_una can change
+			 * significantly, refresh the rtx queue
+			 */
+			mptcp_clean_una(sk);
+		}
+		write_seq = &msk->write_seq;
+		page = pfrag->page;
+	} else {
+		write_seq = &dfrag->data_seq;
+		page = dfrag->page;
 	}
 
 	/* compute copy limit */
@@ -211,63 +224,73 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 * SSN association set here
 		 */
 		can_collapse = (size_goal - skb->len > 0) &&
-			      mptcp_skb_can_collapse_to(msk, skb, mpext);
+			      mptcp_skb_can_collapse_to(*write_seq, skb, mpext);
 		if (!can_collapse)
 			TCP_SKB_CB(skb)->eor = 1;
 		else
 			avail_size = size_goal - skb->len;
 	}
 
-	/* reuse tail pfrag, if possible, or carve a new one from the page
-	 * allocator
-	 */
-	dfrag = mptcp_rtx_tail(sk);
-	offset = pfrag->offset;
-	dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
-	if (!dfrag_collapsed) {
-		dfrag = mptcp_carve_data_frag(msk, pfrag, offset);
+	if (!retransmission) {
+		/* reuse tail pfrag, if possible, or carve a new one from the
+		 * page allocator
+		 */
+		dfrag = mptcp_rtx_tail(sk);
+		offset = pfrag->offset;
+		dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
+		if (!dfrag_collapsed) {
+			dfrag = mptcp_carve_data_frag(msk, pfrag, offset);
+			offset = dfrag->offset;
+			frag_truesize = dfrag->overhead;
+		}
+		poffset = &pfrag->offset;
+		psize = min_t(size_t, pfrag->size - offset, avail_size);
+
+		/* Copy to page */
+		pr_debug("left=%zu", msg_data_left(msg));
+		psize = copy_page_from_iter(pfrag->page, offset,
+					    min_t(size_t, msg_data_left(msg),
+						  psize),
+					    &msg->msg_iter);
+		pr_debug("left=%zu", msg_data_left(msg));
+		if (!psize)
+			return -EINVAL;
+
+		if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
+			return -ENOMEM;
+	} else {
 		offset = dfrag->offset;
-		frag_truesize = dfrag->overhead;
+		poffset = &dfrag->offset;
+		psize = min_t(size_t, dfrag->data_len, avail_size);
 	}
-	psize = min_t(size_t, pfrag->size - offset, avail_size);
-
-	/* Copy to page */
-	pr_debug("left=%zu", msg_data_left(msg));
-	psize = copy_page_from_iter(pfrag->page, offset,
-				    min_t(size_t, msg_data_left(msg), psize),
-				    &msg->msg_iter);
-	pr_debug("left=%zu", msg_data_left(msg));
-	if (!psize)
-		return -EINVAL;
-
-	if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
-		return -ENOMEM;
 
 	/* tell the TCP stack to delay the push so that we can safely
 	 * access the skb after the sendpages call
 	 */
-	ret = do_tcp_sendpages(ssk, pfrag->page, offset, psize,
+	ret = do_tcp_sendpages(ssk, page, offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
 		return ret;
 
 	frag_truesize += ret;
-	if (unlikely(ret < psize))
-		iov_iter_revert(&msg->msg_iter, psize - ret);
+	if (!retransmission) {
+		if (unlikely(ret < psize))
+			iov_iter_revert(&msg->msg_iter, psize - ret);
 
-	/* send successful, keep track of sent data for mptcp-level
-	 * retransmission
-	 */
-	dfrag->data_len += ret;
-	if (!dfrag_collapsed) {
-		get_page(dfrag->page);
-		list_add_tail(&dfrag->list, &msk->rtx_queue);
-	}
+		/* send successful, keep track of sent data for mptcp-level
+		 * retransmission
+		 */
+		dfrag->data_len += ret;
+		if (!dfrag_collapsed) {
+			get_page(dfrag->page);
+			list_add_tail(&dfrag->list, &msk->rtx_queue);
+		}
 
-	/* charge data on mptcp rtx queue to the master socket
-	 * Note: we charge such data both to sk and ssk
-	 */
-	sk->sk_forward_alloc -= frag_truesize;
+		/* charge data on mptcp rtx queue to the master socket
+		 * Note: we charge such data both to sk and ssk
+		 */
+		sk->sk_forward_alloc -= frag_truesize;
+	}
 
 	collapsed = skb == tcp_write_queue_tail(ssk);
 	if (collapsed) {
@@ -281,7 +304,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (mpext) {
 		memset(mpext, 0, sizeof(*mpext));
-		mpext->data_seq = msk->write_seq;
+		mpext->data_seq = *write_seq;
 		mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
 		mpext->data_len = ret;
 		mpext->checksum = 0xbeef;
@@ -297,8 +320,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 */
 
 out:
-	pfrag->offset += frag_truesize;
-	msk->write_seq += ret;
+	*poffset += frag_truesize;
+	*write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
 	return ret;
@@ -347,7 +370,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	mptcp_clean_una(sk);
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	while (msg_data_left(msg)) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo, &mss_now,
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &timeo, &mss_now,
 					 &size_goal);
 		if (ret < 0)
 			break;
-- 
2.23.0

