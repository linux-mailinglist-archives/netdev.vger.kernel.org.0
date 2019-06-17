Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C6949589
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfFQW7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbfFQW64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:52 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 27/33] mptcp: allow collapsing consecutive sendpages on the same substream
Date:   Mon, 17 Jun 2019 15:58:02 -0700
Message-Id: <20190617225808.665-28-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
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
---
 net/mptcp/protocol.c | 79 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 19 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d51201c09519..3fb0f3163743 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -47,12 +47,25 @@ static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
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
+	int mss_now, avail_size, size_goal, ret;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool collapsed, can_collapse = false;
 	struct mptcp_ext *mpext = NULL;
-	int mss_now, size_goal, ret;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
 	size_t psize;
@@ -69,8 +82,31 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
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
+		 * If we run out of space in the current skb (e.g. the window
+		 * size shrunk from last sent) a new skb will be allocated even
+		 * is collapsing was allowed: collapsing is effectively
+		 * disabled.
+		 */
+		can_collapse = mptcp_skb_can_collapse_to(msk, skb, mpext);
+		if (!can_collapse)
+			TCP_SKB_CB(skb)->eor = 1;
+		else if (size_goal - skb->len > 0)
+			avail_size = size_goal - skb->len;
+		else
+			can_collapse = false;
+	}
+	psize = min_t(size_t, pfrag->size - pfrag->offset, avail_size);
 
+	/* Copy to page */
 	pr_debug("left=%zu", msg_data_left(msg));
 	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
 				    min_t(size_t, msg_data_left(msg), psize),
@@ -79,14 +115,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
@@ -94,13 +125,16 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (unlikely(ret < psize))
 		iov_iter_revert(&msg->msg_iter, psize - ret);
 
-	if (skb == tcp_write_queue_tail(ssk))
-		pr_err("no new skb %p/%p", sk, ssk);
+	collapsed = skb == tcp_write_queue_tail(ssk);
+	BUG_ON(collapsed && !can_collapse);
+	if (collapsed) {
+		/* when collapsing mpext always exists */
+		mpext->data_len += ret;
+		goto out;
+	}
 
 	skb = tcp_write_queue_tail(ssk);
-
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
-
 	if (mpext) {
 		memset(mpext, 0, sizeof(*mpext));
 		mpext->data_seq = msk->write_seq;
@@ -113,22 +147,25 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		pr_debug("data_seq=%llu subflow_seq=%u data_len=%u checksum=%u, dsn64=%d",
 			 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
 			 mpext->checksum, mpext->dsn64);
-	} /* TODO: else fallback */
+	}
+	/* TODO: else fallback; allocation can fail, but we can't easily retire
+	 * skbs from the write_queue, as we need to roll-back TCP status
+	 */
 
+out:
 	pfrag->offset += ret;
 	msk->write_seq += ret;
 	subflow_ctx(ssk)->rel_write_seq += ret;
 
-	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 	return ret;
 }
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
+	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	size_t copied = 0;
 	struct sock *ssk;
-	int ret = 0;
 	long timeo;
 
 	pr_debug("msk=%p", msk);
@@ -158,14 +195,18 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	lock_sock(ssk);
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
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
 
 	release_sock(ssk);
 	release_sock(sk);
-- 
2.22.0

