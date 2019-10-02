Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBDDC950B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfJBXic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbfJBXhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862613"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 24/45] mptcp: allow collapsing consecutive sendpages on the same substream
Date:   Wed,  2 Oct 2019 16:36:34 -0700
Message-Id: <20191002233655.24323-25-mathew.j.martineau@linux.intel.com>
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

If the current sendmsg() lands on the same subflow we used last, we
can try to collapse the data.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 74 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 758369256f9b..6b31c0e460d9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -58,11 +58,24 @@ static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
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
+	bool collapsed, can_collapse = false;
 	struct mptcp_ext *mpext = NULL;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
@@ -80,8 +93,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
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
@@ -90,14 +124,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
@@ -105,6 +134,14 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (unlikely(ret < psize))
 		iov_iter_revert(&msg->msg_iter, psize - ret);
 
+	collapsed = skb == tcp_write_queue_tail(ssk);
+	if (collapsed) {
+		WARN_ON_ONCE(!can_collapse);
+		/* when collapsing mpext always exists */
+		mpext->data_len += ret;
+		goto out;
+	}
+
 	skb = tcp_write_queue_tail(ssk);
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (mpext) {
@@ -119,23 +156,26 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
-	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 	return ret;
 }
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
+	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
-	int ret = 0;
 	long timeo;
 
 	lock_sock(sk);
@@ -170,15 +210,19 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
 
-- 
2.23.0

