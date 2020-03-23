Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA63919004F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgCWV3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:60326 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgCWV3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:39 -0400
IronPort-SDR: m7dxF8RbwVfQswhYksDnAtt18zmvYniPkmSSQla7KQXwZ1OVmngLqRfSdzC5x2Id2d4VfaVJhq
 y3VRIB/X05+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:39 -0700
IronPort-SDR: NyUufOcCcCZsRIjruCGwRHp6+SysufOhAAOpxWB9hmlSmPDuW4v0XPNUAYqJo37cXN4iiH+/BN
 kj/8fFXQKh8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960428"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/17] mptcp: rework mptcp_sendmsg_frag to accept optional dfrag
Date:   Mon, 23 Mar 2020 14:26:36 -0700
Message-Id: <20200323212642.34104-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
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

Because a peer could ack data at TCP level but refrain from
sending mptcp-level ACKs, we could grow the mptcp socket
backlog indefinitely.

We should thus block mptcp_sendmsg until the peer has acked some of the
sent data.

In order to be able to do so, increment the mptcp socket wmem_queued
counter on memory allocation and decrement it when releasing the memory
on mptcp-level ack reception.

Because TCP performns sndbuf auto-tuning up to tcp_wmem_max[2], make
this the mptcp sk_sndbuf limit.

In the future we could add experiment with autotuning as TCP does in
tcp_sndbuf_expand().

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 119 ++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 47 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d4b6ce984576..c7a333a6d917 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -316,7 +316,7 @@ static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 	return NULL;
 }
 
-static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
+static inline bool mptcp_skb_can_collapse_to(u64 write_seq,
 					     const struct sk_buff *skb,
 					     const struct mptcp_ext *mpext)
 {
@@ -324,7 +324,7 @@ static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
 		return false;
 
 	/* can collapse only if MPTCP level sequence is in order */
-	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
+	return mpext && mpext->data_seq + mpext->data_len == write_seq;
 }
 
 static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
@@ -417,23 +417,28 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 }
 
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
-			      struct msghdr *msg, long *timeo, int *pmss_now,
+			      struct msghdr *msg, struct mptcp_data_frag *dfrag,
+			      long *timeo, int *pmss_now,
 			      int *ps_goal)
 {
 	int mss_now, avail_size, size_goal, offset, ret, frag_truesize = 0;
 	bool dfrag_collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
-	struct mptcp_data_frag *dfrag;
+	bool retransmission = !!dfrag;
 	struct sk_buff *skb, *tail;
 	struct page_frag *pfrag;
+	struct page *page;
+	u64 *write_seq;
 	size_t psize;
 
 	/* use the mptcp page cache so that we can easily move the data
 	 * from one substream to another, but do per subflow memory accounting
+	 * Note: pfrag is used only !retransmission, but the compiler if
+	 * fooled into a warning if we don't init here
 	 */
 	pfrag = sk_page_frag(sk);
-	while (!mptcp_page_frag_refill(ssk, pfrag) ||
+	while ((!retransmission && !mptcp_page_frag_refill(ssk, pfrag)) ||
 	       !mptcp_ext_cache_refill(msk)) {
 		ret = sk_stream_wait_memory(ssk, timeo);
 		if (ret)
@@ -447,6 +452,13 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		if (unlikely(__mptcp_needs_tcp_fallback(msk)))
 			return 0;
 	}
+	if (!retransmission) {
+		write_seq = &msk->write_seq;
+		page = pfrag->page;
+	} else {
+		write_seq = &dfrag->data_seq;
+		page = dfrag->page;
+	}
 
 	/* compute copy limit */
 	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
@@ -464,63 +476,74 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
+			sk_wmem_queued_add(sk, frag_truesize);
+		} else {
+			sk_wmem_queued_add(sk, ret);
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
 
 	/* if the tail skb extension is still the cached one, collapsing
 	 * really happened. Note: we can't check for 'same skb' as the sk_buff
@@ -539,7 +562,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	msk->cached_ext = NULL;
 
 	memset(mpext, 0, sizeof(*mpext));
-	mpext->data_seq = msk->write_seq;
+	mpext->data_seq = *write_seq;
 	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
 	mpext->data_len = ret;
 	mpext->use_map = 1;
@@ -550,8 +573,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 out:
-	pfrag->offset += frag_truesize;
-	msk->write_seq += ret;
+	if (!retransmission)
+		pfrag->offset += frag_truesize;
+	*write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
 	return ret;
@@ -663,7 +687,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(ssk);
 	while (msg_data_left(msg)) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo, &mss_now,
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &timeo, &mss_now,
 					 &size_goal);
 		if (ret < 0)
 			break;
@@ -974,6 +998,7 @@ static int mptcp_init_sock(struct sock *sk)
 		return ret;
 
 	sk_sockets_allocated_inc(sk);
+	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
 
 	if (!mptcp_is_enabled(sock_net(sk)))
 		return -ENOPROTOOPT;
-- 
2.26.0

