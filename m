Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ADBC94FA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbfJBXhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbfJBXhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862631"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 36/45] mptcp: queue data for mptcp level retransmission
Date:   Wed,  2 Oct 2019 16:36:46 -0700
Message-Id: <20191002233655.24323-37-mathew.j.martineau@linux.intel.com>
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

keep the send page fragment on an MPTCP level retransmission queue.
the queue entries are allocated inside the page frag allocator,
acquiring an additional reference to the page for each list entry.

Also switch to a custom page frag refill function, to ensure that
the current page fragment can always host an MPTCP rtx queue entry.

The MPTCP rtx queue is flushed at disconnect() and close() time

Note that now we need to call __mptcp_init_sock() regarless of mptcp
enable status, as the destructor will try to walk the rtx_queue.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 131 ++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |  20 +++++++
 2 files changed, 143 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2c64435aedd8..c2e89e8cbc0e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -69,14 +69,74 @@ static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
 	return mpext && mpext->data_seq + mpext->data_len == msk->write_seq;
 }
 
+static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
+					      const struct page_frag *pfrag,
+					      const struct mptcp_data_frag *df)
+{
+	return df && pfrag->page == df->page &&
+		df->data_seq + df->data_len == msk->write_seq;
+}
+
+static void dfrag_clear(struct mptcp_data_frag *dfrag)
+{
+	list_del(&dfrag->list);
+	put_page(dfrag->page);
+}
+
+static void mptcp_clean_una(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_data_frag *dtmp, *dfrag;
+	u64 snd_una = atomic64_read(&msk->snd_una);
+
+	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
+		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
+			break;
+
+		dfrag_clear(dfrag);
+	}
+}
+
+/* ensure we get enough memory for the frag hdr, beyond some minimal amount of
+ * data
+ */
+bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
+{
+	if (likely(skb_page_frag_refill(32U + sizeof(struct mptcp_data_frag),
+					pfrag, sk->sk_allocation)))
+		return true;
+
+	sk->sk_prot->enter_memory_pressure(sk);
+	sk_stream_moderate_sndbuf(sk);
+	return false;
+}
+
+static inline struct mptcp_data_frag *
+mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
+		      int orig_offset)
+{
+	int offset = ALIGN(orig_offset, sizeof(long));
+	struct mptcp_data_frag *dfrag;
+
+	dfrag = (struct mptcp_data_frag *)(page_to_virt(pfrag->page) + offset);
+	dfrag->data_len = 0;
+	dfrag->data_seq = msk->write_seq;
+	dfrag->overhead = offset - orig_offset + sizeof(struct mptcp_data_frag);
+	dfrag->offset = offset + sizeof(struct mptcp_data_frag);
+	dfrag->page = pfrag->page;
+
+	return dfrag;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct msghdr *msg, long *timeo, int *pmss_now,
 			      int *ps_goal)
 {
-	int mss_now, avail_size, size_goal, ret;
+	int mss_now, avail_size, size_goal, offset, ret, frag_truesize = 0;
+	bool dfrag_collapsed, collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	bool collapsed, can_collapse = false;
 	struct mptcp_ext *mpext = NULL;
+	struct mptcp_data_frag *dfrag;
 	struct page_frag *pfrag;
 	struct sk_buff *skb;
 	size_t psize;
@@ -85,10 +145,15 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 * from one substream to another, but do per subflow memory accounting
 	 */
 	pfrag = sk_page_frag(sk);
-	while (!sk_page_frag_refill(ssk, pfrag)) {
+	while (!mptcp_page_frag_refill(ssk, pfrag)) {
 		ret = sk_stream_wait_memory(ssk, timeo);
 		if (ret)
 			return ret;
+
+		/* id sk_stream_wait_memory() sleeps snd_una can change
+		 * significantly, refresh the rtx queue
+		 */
+		mptcp_clean_una(sk);
 	}
 
 	/* compute copy limit */
@@ -113,11 +178,23 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		else
 			avail_size = size_goal - skb->len;
 	}
-	psize = min_t(size_t, pfrag->size - pfrag->offset, avail_size);
+
+	/* reuse tail pfrag, if possible, or carve a new one from the page
+	 * allocator
+	 */
+	dfrag = mptcp_rtx_tail(sk);
+	offset = pfrag->offset;
+	dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
+	if (!dfrag_collapsed) {
+		dfrag = mptcp_carve_data_frag(msk, pfrag, offset);
+		offset = dfrag->offset;
+		frag_truesize = dfrag->overhead;
+	}
+	psize = min_t(size_t, pfrag->size - offset, avail_size);
 
 	/* Copy to page */
 	pr_debug("left=%zu", msg_data_left(msg));
-	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
+	psize = copy_page_from_iter(pfrag->page, offset,
 				    min_t(size_t, msg_data_left(msg), psize),
 				    &msg->msg_iter);
 	pr_debug("left=%zu", msg_data_left(msg));
@@ -127,13 +204,24 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	/* tell the TCP stack to delay the push so that we can safely
 	 * access the skb after the sendpages call
 	 */
-	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
+	ret = do_tcp_sendpages(ssk, pfrag->page, offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
 		return ret;
+
+	frag_truesize += ret;
 	if (unlikely(ret < psize))
 		iov_iter_revert(&msg->msg_iter, psize - ret);
 
+	/* send successful, keep track of sent data for mptcp-level
+	 * retransmission
+	 */
+	dfrag->data_len += ret;
+	if (!dfrag_collapsed) {
+		get_page(dfrag->page);
+		list_add_tail(&dfrag->list, &msk->rtx_queue);
+	}
+
 	collapsed = skb == tcp_write_queue_tail(ssk);
 	if (collapsed) {
 		WARN_ON_ONCE(!can_collapse);
@@ -162,7 +250,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 */
 
 out:
-	pfrag->offset += ret;
+	pfrag->offset += frag_truesize;
 	msk->write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
@@ -209,6 +297,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	lock_sock(ssk);
+	mptcp_clean_una(sk);
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	while (msg_data_left(msg)) {
 		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo, &mss_now,
@@ -596,16 +685,31 @@ static int __mptcp_init_sock(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	INIT_LIST_HEAD(&msk->conn_list);
+	INIT_LIST_HEAD(&msk->rtx_queue);
 
 	return 0;
 }
 
 static int mptcp_init_sock(struct sock *sk)
 {
+	int ret = __mptcp_init_sock(sk);
+
+	if (ret)
+		return ret;
+
 	if (!mptcp_is_enabled(sock_net(sk)))
 		return -ENOPROTOOPT;
 
-	return __mptcp_init_sock(sk);
+	return 0;
+}
+
+static void __mptcp_clear_xmit(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_data_frag *dtmp, *dfrag;
+
+	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
+		dfrag_clear(dfrag);
 }
 
 static void mptcp_close(struct sock *sk, long timeout)
@@ -634,10 +738,20 @@ static void mptcp_close(struct sock *sk, long timeout)
 		sock_release(mptcp_subflow_tcp_socket(subflow));
 	}
 
+	__mptcp_clear_xmit(sk);
 	release_sock(sk);
+
 	sk_common_release(sk);
 }
 
+static int mptcp_disconnect(struct sock *sk, int flags)
+{
+	lock_sock(sk);
+	__mptcp_clear_xmit(sk);
+	release_sock(sk);
+	return tcp_disconnect(sk, flags);
+}
+
 static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 				 bool kern)
 {
@@ -863,6 +977,7 @@ static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
+	.disconnect	= mptcp_disconnect,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
 	.setsockopt	= mptcp_setsockopt,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 45646e38aa4c..e09db0f85bfc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -111,6 +111,15 @@ struct mptcp_pm_data {
 	u32	token;
 };
 
+struct mptcp_data_frag {
+	struct list_head list;
+	u64 data_seq;
+	int data_len;
+	int offset;
+	int overhead;
+	struct page *page;
+};
+
 /* MPTCP connection sock */
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
@@ -124,6 +133,7 @@ struct mptcp_sock {
 	unsigned long	flags;
 	u16		dport;
 	struct list_head conn_list;
+	struct list_head rtx_queue;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct mptcp_pm_data	pm;
 	u8		addr_signal;
@@ -137,6 +147,16 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (list_empty(&msk->rtx_queue))
+		return NULL;
+
+	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+}
+
 struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u8	mp_capable : 1,
-- 
2.23.0

