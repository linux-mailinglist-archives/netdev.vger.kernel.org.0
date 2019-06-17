Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB474958A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfFQW7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbfFQW6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:55 -0400
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
Subject: [RFC PATCH net-next 26/33] mptcp: sendmsg() do spool all the provided data
Date:   Mon, 17 Jun 2019 15:58:01 -0700
Message-Id: <20190617225808.665-27-mathew.j.martineau@linux.intel.com>
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

This makes mptcp sendmsg() behaviour more consistent and
improves xmit performances.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 110 +++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 47 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 98257a70ac2b..d51201c09519 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -47,66 +47,37 @@ static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
 	return NULL;
 }
 
-static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
+			      struct msghdr *msg, long *timeo)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int mss_now, size_goal, poffset, ret;
 	struct mptcp_ext *mpext = NULL;
+	int mss_now, size_goal, ret;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
-	struct sock *ssk;
 	size_t psize;
-	long timeo;
-
-	pr_debug("msk=%p", msk);
-	if (msk->subflow) {
-		pr_debug("fallback passthrough");
-		return sock_sendmsg(msk->subflow, msg);
-	}
-
-	ssk = mptcp_subflow_get_ref(msk);
-	if (!ssk)
-		return -ENOTCONN;
-
-	if (!msg_data_left(msg)) {
-		pr_debug("empty send");
-		ret = sock_sendmsg(ssk->sk_socket, msg);
-		goto put_out;
-	}
-
-	pr_debug("conn_list->subflow=%p", ssk);
-
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL)) {
-		ret = -ENOTSUPP;
-		goto put_out;
-	}
-
-	lock_sock(sk);
-	lock_sock(ssk);
-	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
 	/* use the mptcp page cache so that we can easily move the data
 	 * from one substream to another, but do per subflow memory accounting
 	 */
 	pfrag = sk_page_frag(sk);
 	while (!sk_page_frag_refill(ssk, pfrag)) {
-		ret = sk_stream_wait_memory(ssk, &timeo);
+		ret = sk_stream_wait_memory(ssk, timeo);
 		if (ret)
-			goto release_out;
+			return ret;
 	}
 
-	/* Copy to page */
-	poffset = pfrag->offset;
+	/* compute copy limit */
+	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
+	psize = min_t(int, pfrag->size - pfrag->offset, size_goal);
+
 	pr_debug("left=%zu", msg_data_left(msg));
-	psize = copy_page_from_iter(pfrag->page, poffset,
-				    min_t(size_t, msg_data_left(msg),
-					  pfrag->size - poffset),
+	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
+				    min_t(size_t, msg_data_left(msg), psize),
 				    &msg->msg_iter);
 	pr_debug("left=%zu", msg_data_left(msg));
-	if (!psize) {
-		ret = -EINVAL;
-		goto release_out;
-	}
+	if (!psize)
+		return -EINVAL;
 
 	/* Mark the end of the previous write so the beginning of the
 	 * next write (with its own mptcp skb extension data) is not
@@ -116,12 +87,12 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	psize = min_t(int, size_goal, psize);
-	ret = do_tcp_sendpages(ssk, pfrag->page, poffset, psize,
+	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
-		goto release_out;
+		return ret;
+	if (unlikely(ret < psize))
+		iov_iter_revert(&msg->msg_iter, psize - ret);
 
 	if (skb == tcp_write_queue_tail(ssk))
 		pr_err("no new skb %p/%p", sk, ssk);
@@ -149,8 +120,53 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	subflow_ctx(ssk)->rel_write_seq += ret;
 
 	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
+	return ret;
+}
+
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	size_t copied = 0;
+	struct sock *ssk;
+	int ret = 0;
+	long timeo;
+
+	pr_debug("msk=%p", msk);
+	if (msk->subflow) {
+		pr_debug("fallback passthrough");
+		return sock_sendmsg(msk->subflow, msg);
+	}
+
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk)
+		return -ENOTCONN;
+
+	if (!msg_data_left(msg)) {
+		pr_debug("empty send");
+		ret = sock_sendmsg(ssk->sk_socket, msg);
+		goto put_out;
+	}
+
+	pr_debug("conn_list->subflow=%p", ssk);
+
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL)) {
+		ret = -ENOTSUPP;
+		goto put_out;
+	}
+
+	lock_sock(sk);
+	lock_sock(ssk);
+	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+	while (msg_data_left(msg)) {
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo);
+		if (ret < 0)
+			break;
+
+		copied += ret;
+	}
+	if (copied > 0)
+		ret = copied;
 
-release_out:
 	release_sock(ssk);
 	release_sock(sk);
 
-- 
2.22.0

