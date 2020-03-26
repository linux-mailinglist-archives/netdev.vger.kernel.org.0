Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA9F194980
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCZUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:47:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:47908 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgCZUrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:47:02 -0400
IronPort-SDR: oR3EsLwgqGlVoQZhMeX5NzLljxeEh4FI2+NJN2FmD9142EQJVbgCe0f+F+dDwONGIrIGxTbuAw
 4M5dwlMzWeRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:47:01 -0700
IronPort-SDR: zfOxjLqchsTI6J8YVKGGqf6VkP70T2TDUgEMW1p+6FtPepm+p6uhnUirnHr2qwLCQoshRwqmRx
 XPsGW4t0jkFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911679"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:47:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 07/17] mptcp: queue data for mptcp level retransmission
Date:   Thu, 26 Mar 2020 13:46:30 -0700
Message-Id: <20200326204640.67336-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
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

Note that now we need to call __mptcp_init_sock() regardless of mptcp
enable status, as the destructor will try to walk the rtx_queue.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 135 ++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |  20 +++++++
 2 files changed, 147 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d3197ace2a89..dae5d3152da4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -285,15 +285,75 @@ static inline bool mptcp_skb_can_collapse_to(const struct mptcp_sock *msk,
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
+static bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
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
+	bool dfrag_collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
+	struct mptcp_data_frag *dfrag;
 	struct sk_buff *skb, *tail;
-	bool can_collapse = false;
 	struct page_frag *pfrag;
 	size_t psize;
 
@@ -301,11 +361,17 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 * from one substream to another, but do per subflow memory accounting
 	 */
 	pfrag = sk_page_frag(sk);
-	while (!sk_page_frag_refill(ssk, pfrag) ||
+	while (!mptcp_page_frag_refill(ssk, pfrag) ||
 	       !mptcp_ext_cache_refill(msk)) {
 		ret = sk_stream_wait_memory(ssk, timeo);
 		if (ret)
 			return ret;
+
+		/* if sk_stream_wait_memory() sleeps snd_una can change
+		 * significantly, refresh the rtx queue
+		 */
+		mptcp_clean_una(sk);
+
 		if (unlikely(__mptcp_needs_tcp_fallback(msk)))
 			return 0;
 	}
@@ -332,11 +398,23 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
@@ -346,13 +424,24 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
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
 	/* if the tail skb extension is still the cached one, collapsing
 	 * really happened. Note: we can't check for 'same skb' as the sk_buff
 	 * hdr on tail can be transmitted, freed and re-allocated by the
@@ -381,7 +470,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 out:
-	pfrag->offset += ret;
+	pfrag->offset += frag_truesize;
 	msk->write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
@@ -472,6 +561,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
+	mptcp_clean_una(sk);
+
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
 	while (!sk_stream_memory_free(sk) || !ssk) {
@@ -479,6 +570,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (ret)
 			goto out;
 
+		mptcp_clean_una(sk);
+
 		ssk = mptcp_subflow_get_send(msk);
 		if (list_empty(&msk->conn_list)) {
 			ret = -ENOTCONN;
@@ -744,6 +837,7 @@ static int __mptcp_init_sock(struct sock *sk)
 
 	INIT_LIST_HEAD(&msk->conn_list);
 	INIT_LIST_HEAD(&msk->join_list);
+	INIT_LIST_HEAD(&msk->rtx_queue);
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 	INIT_WORK(&msk->work, mptcp_worker);
 
@@ -757,10 +851,24 @@ static int __mptcp_init_sock(struct sock *sk)
 
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
 
 static void mptcp_cancel_work(struct sock *sk)
@@ -822,6 +930,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	data_fin_tx_seq = msk->write_seq;
 
+	__mptcp_clear_xmit(sk);
+
 	release_sock(sk);
 
 	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
@@ -863,6 +973,14 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 	inet_sk(msk)->inet_rcv_saddr = inet_sk(ssk)->inet_rcv_saddr;
 }
 
+static int mptcp_disconnect(struct sock *sk, int flags)
+{
+	lock_sock(sk);
+	__mptcp_clear_xmit(sk);
+	release_sock(sk);
+	return tcp_disconnect(sk, flags);
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
 {
@@ -1173,6 +1291,7 @@ static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
+	.disconnect	= mptcp_disconnect,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
 	.setsockopt	= mptcp_setsockopt,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 29db05467cc3..a1fdb879259a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -139,6 +139,15 @@ struct mptcp_pm_data {
 	struct		work_struct work;
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
@@ -154,6 +163,7 @@ struct mptcp_sock {
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
+	struct list_head rtx_queue;
 	struct list_head join_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
@@ -169,6 +179,16 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
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
 	u16	mp_capable : 1,
-- 
2.26.0

