Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52411F087
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLNGEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:24724 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfLNGEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855229"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 13/15] mptcp: allow collapsing consecutive sendpages on the same substream
Date:   Fri, 13 Dec 2019 22:04:15 -0800
Message-Id: <20191214060417.2870-14-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the current sendmsg() lands on the same subflow we used last, we
can try to collapse the data.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 75 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fd89075bd1c9..7dc27a4f0403 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -123,14 +123,27 @@ static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 	return NULL;
 }
 
+static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
+					     const struct sk_buff *skb,
+					     const struct mptcp_ext *mpext)
+{
+	if (!tcp_skb_can_collapse_to(skb))
+		return false;
+
+	/* can collapse only if MPTCP level sequence is in order */
+	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
-			      struct msghdr *msg, long *timeo)
+			      struct msghdr *msg, long *timeo, int *pmss_now,
+			      int *ps_goal)
 {
-	int mss_now = 0, size_goal = 0, ret = 0;
+	int mss_now, avail_size, size_goal, ret;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
+	struct sk_buff *skb, *tail;
+	bool can_collapse = false;
 	struct page_frag *pfrag;
-	struct sk_buff *skb;
 	size_t psize;
 
 	/* use the mptcp page cache so that we can easily move the data
@@ -146,8 +159,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 	/* compute copy limit */
 	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	psize = min_t(int, pfrag->size - pfrag->offset, size_goal);
+	*pmss_now = mss_now;
+	*ps_goal = size_goal;
+	avail_size = size_goal;
+	skb = tcp_write_queue_tail(ssk);
+	if (skb) {
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
+
+		/* Limit the write to the size available in the
+		 * current skb, if any, so that we create at most a new skb.
+		 * Explicitly tells TCP internals to avoid collapsing on later
+		 * queue management operation, to avoid breaking the ext <->
+		 * SSN association set here
+		 */
+		can_collapse = (size_goal - skb->len > 0) &&
+			      mptcp_skb_can_collapse_to(msk, skb, mpext);
+		if (!can_collapse)
+			TCP_SKB_CB(skb)->eor = 1;
+		else
+			avail_size = size_goal - skb->len;
+	}
+	psize = min_t(size_t, pfrag->size - pfrag->offset, avail_size);
 
+	/* Copy to page */
 	pr_debug("left=%zu", msg_data_left(msg));
 	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
 				    min_t(size_t, msg_data_left(msg), psize),
@@ -156,14 +190,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (!psize)
 		return -EINVAL;
 
-	/* Mark the end of the previous write so the beginning of the
-	 * next write (with its own mptcp skb extension data) is not
-	 * collapsed.
+	/* tell the TCP stack to delay the push so that we can safely
+	 * access the skb after the sendpages call
 	 */
-	skb = tcp_write_queue_tail(ssk);
-	if (skb)
-		TCP_SKB_CB(skb)->eor = 1;
-
 	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
@@ -171,6 +200,18 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (unlikely(ret < psize))
 		iov_iter_revert(&msg->msg_iter, psize - ret);
 
+	/* if the tail skb extension is still the cached one, collapsing
+	 * really happened. Note: we can't check for 'same skb' as the sk_buff
+	 * hdr on tail can be transmitted, freed and re-allocated by the
+	 * do_tcp_sendpages() call
+	 */
+	tail = tcp_write_queue_tail(ssk);
+	if (mpext && tail && mpext == skb_ext_find(tail, SKB_EXT_MPTCP)) {
+		WARN_ON_ONCE(!can_collapse);
+		mpext->data_len += ret;
+		goto out;
+	}
+
 	skb = tcp_write_queue_tail(ssk);
 	mpext = __skb_ext_set(skb, SKB_EXT_MPTCP, msk->cached_ext);
 	msk->cached_ext = NULL;
@@ -186,11 +227,11 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
 		 mpext->dsn64);
 
+out:
 	pfrag->offset += ret;
 	msk->write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
-	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 	return ret;
 }
 
@@ -212,11 +253,11 @@ static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
+	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
-	int ret = 0;
 	long timeo;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
@@ -243,15 +284,19 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(ssk);
 	while (msg_data_left(msg)) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo);
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo, &mss_now,
+					 &size_goal);
 		if (ret < 0)
 			break;
 
 		copied += ret;
 	}
 
-	if (copied > 0)
+	if (copied) {
 		ret = copied;
+		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
+			 size_goal);
+	}
 
 	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
-- 
2.24.1

