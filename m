Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514C4C94EE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfJBXhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbfJBXhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862612"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 23/45] mptcp: sendmsg() do spool all the provided data
Date:   Wed,  2 Oct 2019 16:36:33 -0700
Message-Id: <20191002233655.24323-24-mathew.j.martineau@linux.intel.com>
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

This makes mptcp sendmsg() behaviour more consistent and
improves xmit performances.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 126 ++++++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 55 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index da983ea4fb5e..758369256f9b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -58,71 +58,37 @@ static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
 	return NULL;
 }
 
-static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
+			      struct msghdr *msg, long *timeo)
 {
 	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *ssock;
-	struct sock *ssk;
 	struct mptcp_ext *mpext = NULL;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
 	size_t psize;
-	int poffset;
-	long timeo;
-
-	lock_sock(sk);
-	ssock = __mptcp_fallback_get_ref(msk);
-	if (ssock) {
-		release_sock(sk);
-		pr_debug("fallback passthrough");
-		ret = sock_sendmsg(ssock, msg);
-		sock_put(ssock->sk);
-		return ret;
-	}
-
-	ssk = mptcp_subflow_get_ref(msk);
-	if (!ssk) {
-		release_sock(sk);
-		return -ENOTCONN;
-	}
-
-	if (!msg_data_left(msg)) {
-		pr_debug("empty send");
-		ret = sock_sendmsg(ssk->sk_socket, msg);
-		goto put_out;
-	}
-
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL)) {
-		ret = -ENOTSUPP;
-		goto put_out;
-	}
-
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
-			goto put_out;
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
-		goto put_out;
-	}
+	if (!psize)
+		return -EINVAL;
 
 	/* Mark the end of the previous write so the beginning of the
 	 * next write (with its own mptcp skb extension data) is not
@@ -132,20 +98,15 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	psize = min_t(int, size_goal, psize);
-	ret = do_tcp_sendpages(ssk, pfrag->page, poffset, psize,
+	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
-		goto put_out;
-
-	if (skb == tcp_write_queue_tail(ssk))
-		pr_err("no new skb %p/%p", sk, ssk);
+		return ret;
+	if (unlikely(ret < psize))
+		iov_iter_revert(&msg->msg_iter, psize - ret);
 
 	skb = tcp_write_queue_tail(ssk);
-
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
-
 	if (mpext) {
 		memset(mpext, 0, sizeof(*mpext));
 		mpext->data_seq = msk->write_seq;
@@ -165,6 +126,61 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
 	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
+	return ret;
+}
+
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *ssock;
+	size_t copied = 0;
+	struct sock *ssk;
+	int ret = 0;
+	long timeo;
+
+	lock_sock(sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sk);
+		pr_debug("fallback passthrough");
+		ret = sock_sendmsg(ssock, msg);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk) {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
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
+	lock_sock(ssk);
+	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+	while (msg_data_left(msg)) {
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo);
+		if (ret < 0)
+			break;
+
+		copied += ret;
+	}
+
+	if (copied > 0)
+		ret = copied;
+
+	release_sock(ssk);
 
 put_out:
 	release_sock(sk);
-- 
2.23.0

