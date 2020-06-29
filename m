Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0872020DE94
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389104AbgF2U1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389093AbgF2U07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MovKDMEF02ofNO7neOJ4Us5JemBpwLHyWiAbx4GOCrU=;
        b=PtxcoPCtZEi1Ns3BPONksj9HCWeeCRwBGLvIWRM+YtCVRV6LXvSNq250D/fDMoTaqNm00y
        rQgX8L6jEO144UdFw+hSNwXaKeLRL9xhMTkH9YxUwJeyAJ2gmYx7JdD6lPxn8qD/FYxKfU
        27ioCZGci4R/JZ/0ZKmE0qUkFWQ55N8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-aye8SMphMn6Mc0kpBE7J9g-1; Mon, 29 Jun 2020 16:26:47 -0400
X-MC-Unique: aye8SMphMn6Mc0kpBE7J9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99EF31932482;
        Mon, 29 Jun 2020 20:26:46 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1AE91C4;
        Mon, 29 Jun 2020 20:26:44 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 1/6] net: mptcp: improve fallback to TCP
Date:   Mon, 29 Jun 2020 22:26:20 +0200
Message-Id: <48551241b592f237f236361276b5b42774d2ba69.1593461586.git.dcaratti@redhat.com>
In-Reply-To: <cover.1593461586.git.dcaratti@redhat.com>
References: <cover.1593461586.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep using MPTCP sockets and a use "dummy mapping" in case of fallback
to regular TCP. When fallback is triggered, skip addition of the MPTCP
option on send.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/11
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/22
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/options.c  |  9 +++-
 net/mptcp/protocol.c | 98 ++++++++++++--------------------------------
 net/mptcp/protocol.h | 33 +++++++++++++++
 net/mptcp/subflow.c  | 47 +++++++++++++--------
 4 files changed, 98 insertions(+), 89 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index df9a51425c6f..b96d3660562f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -624,6 +624,9 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 
 	opts->suboptions = 0;
 
+	if (unlikely(mptcp_check_fallback(sk)))
+		return false;
+
 	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
@@ -714,7 +717,8 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 	 */
 	if (!mp_opt->mp_capable) {
 		subflow->mp_capable = 0;
-		tcp_sk(sk)->is_mptcp = 0;
+		pr_fallback(msk);
+		__mptcp_do_fallback(msk);
 		return false;
 	}
 
@@ -814,6 +818,9 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_options_received mp_opt;
 	struct mptcp_ext *mpext;
 
+	if (__mptcp_check_fallback(msk))
+		return;
+
 	mptcp_get_options(skb, &mp_opt);
 	if (!check_fully_established(msk, sk, subflow, skb, &mp_opt))
 		return;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index be09fd525f8f..84ae96be9837 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -52,11 +52,6 @@ static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
-static bool __mptcp_needs_tcp_fallback(const struct mptcp_sock *msk)
-{
-	return msk->first && !sk_is_mptcp(msk->first);
-}
-
 static struct socket *mptcp_is_tcpsk(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
@@ -94,7 +89,7 @@ static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 	if (unlikely(sock))
 		return sock;
 
-	if (likely(!__mptcp_needs_tcp_fallback(msk)))
+	if (likely(!__mptcp_check_fallback(msk)))
 		return NULL;
 
 	return msk->subflow;
@@ -133,6 +128,11 @@ static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
 	list_add(&subflow->node, &msk->conn_list);
 	subflow->request_mptcp = 1;
 
+	/* accept() will wait on first subflow sk_wq, and we always wakes up
+	 * via msk->sk_socket
+	 */
+	RCU_INIT_POINTER(msk->first->sk_wq, &sk->sk_socket->wq);
+
 set_state:
 	if (state != MPTCP_SAME_STATE)
 		inet_sk_state_store(sk, state);
@@ -229,6 +229,15 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		if (!skb)
 			break;
 
+		if (__mptcp_check_fallback(msk)) {
+			/* if we are running under the workqueue, TCP could have
+			 * collapsed skbs between dummy map creation and now
+			 * be sure to adjust the size
+			 */
+			map_remaining = skb->len;
+			subflow->map_data_len = skb->len;
+		}
+
 		offset = seq - TCP_SKB_CB(skb)->seq;
 		fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
 		if (fin) {
@@ -466,8 +475,15 @@ static void mptcp_clean_una(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
-	u64 snd_una = atomic64_read(&msk->snd_una);
 	bool cleaned = false;
+	u64 snd_una;
+
+	/* on fallback we just need to ignore snd_una, as this is really
+	 * plain TCP
+	 */
+	if (__mptcp_check_fallback(msk))
+		atomic64_set(&msk->snd_una, msk->write_seq);
+	snd_una = atomic64_read(&msk->snd_una);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
@@ -740,7 +756,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct page_frag *pfrag;
-	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
 	bool tx_ok;
@@ -759,15 +774,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto out;
 	}
 
-fallback:
-	ssock = __mptcp_tcp_fallback(msk);
-	if (unlikely(ssock)) {
-		release_sock(sk);
-		pr_debug("fallback passthrough");
-		ret = sock_sendmsg(ssock, msg);
-		return ret >= 0 ? ret + copied : (copied ? copied : ret);
-	}
-
 	pfrag = sk_page_frag(sk);
 restart:
 	mptcp_clean_una(sk);
@@ -819,17 +825,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 			break;
 		}
-		if (ret == 0 && unlikely(__mptcp_needs_tcp_fallback(msk))) {
-			/* Can happen for passive sockets:
-			 * 3WHS negotiated MPTCP, but first packet after is
-			 * plain TCP (e.g. due to middlebox filtering unknown
-			 * options).
-			 *
-			 * Fall back to TCP.
-			 */
-			release_sock(ssk);
-			goto fallback;
-		}
 
 		copied += ret;
 
@@ -972,7 +967,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *ssock;
 	int copied = 0;
 	int target;
 	long timeo;
@@ -981,16 +975,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return -EOPNOTSUPP;
 
 	lock_sock(sk);
-	ssock = __mptcp_tcp_fallback(msk);
-	if (unlikely(ssock)) {
-fallback:
-		release_sock(sk);
-		pr_debug("fallback-read subflow=%p",
-			 mptcp_subflow_ctx(ssock->sk));
-		copied = sock_recvmsg(ssock, msg, flags);
-		return copied;
-	}
-
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	len = min_t(size_t, len, INT_MAX);
@@ -1056,9 +1040,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		pr_debug("block timeout %ld", timeo);
 		mptcp_wait_data(sk, &timeo);
-		ssock = __mptcp_tcp_fallback(msk);
-		if (unlikely(ssock))
-			goto fallback;
 	}
 
 	if (skb_queue_empty(&sk->sk_receive_queue)) {
@@ -1335,8 +1316,6 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how,
 		break;
 	}
 
-	/* Wake up anyone sleeping in poll. */
-	ssk->sk_state_change(ssk);
 	release_sock(ssk);
 }
 
@@ -1660,12 +1639,6 @@ void mptcp_finish_connect(struct sock *ssk)
 	sk = subflow->conn;
 	msk = mptcp_sk(sk);
 
-	if (!subflow->mp_capable) {
-		MPTCP_INC_STATS(sock_net(sk),
-				MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
-		return;
-	}
-
 	pr_debug("msk=%p, token=%u", sk, subflow->token);
 
 	mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
@@ -1971,23 +1944,10 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct mptcp_sock *msk;
-	struct socket *ssock;
 	__poll_t mask = 0;
 
 	msk = mptcp_sk(sk);
-	lock_sock(sk);
-	ssock = __mptcp_tcp_fallback(msk);
-	if (!ssock)
-		ssock = __mptcp_nmpc_socket(msk);
-	if (ssock) {
-		mask = ssock->ops->poll(file, ssock, wait);
-		release_sock(sk);
-		return mask;
-	}
-
-	release_sock(sk);
 	sock_poll_wait(file, sock, wait);
-	lock_sock(sk);
 
 	if (test_bit(MPTCP_DATA_READY, &msk->flags))
 		mask = EPOLLIN | EPOLLRDNORM;
@@ -1997,8 +1957,6 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
-	release_sock(sk);
-
 	return mask;
 }
 
@@ -2006,18 +1964,11 @@ static int mptcp_shutdown(struct socket *sock, int how)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct mptcp_subflow_context *subflow;
-	struct socket *ssock;
 	int ret = 0;
 
 	pr_debug("sk=%p, how=%d", msk, how);
 
 	lock_sock(sock->sk);
-	ssock = __mptcp_tcp_fallback(msk);
-	if (ssock) {
-		release_sock(sock->sk);
-		return inet_shutdown(ssock, how);
-	}
-
 	if (how == SHUT_WR || how == SHUT_RDWR)
 		inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
 
@@ -2043,6 +1994,9 @@ static int mptcp_shutdown(struct socket *sock, int how)
 		mptcp_subflow_shutdown(tcp_sk, how, 1, msk->write_seq);
 	}
 
+	/* Wake up anyone sleeping in poll. */
+	sock->sk->sk_state_change(sock->sk);
+
 out_unlock:
 	release_sock(sock->sk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c05552e5fa23..a709df659ae0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -89,6 +89,7 @@
 #define MPTCP_SEND_SPACE	1
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
+#define MPTCP_FALLBACK_DONE	4
 
 struct mptcp_options_received {
 	u64	sndr_key;
@@ -457,4 +458,36 @@ static inline bool before64(__u64 seq1, __u64 seq2)
 
 void mptcp_diag_subflow_init(struct tcp_ulp_ops *ops);
 
+static inline bool __mptcp_check_fallback(struct mptcp_sock *msk)
+{
+	return test_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+}
+
+static inline bool mptcp_check_fallback(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	return __mptcp_check_fallback(msk);
+}
+
+static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
+{
+	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags)) {
+		pr_debug("TCP fallback already done (msk=%p)", msk);
+		return;
+	}
+	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+}
+
+static inline void mptcp_do_fallback(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	__mptcp_do_fallback(msk);
+}
+
+#define pr_fallback(a) pr_debug("%s:fallback to TCP (msk=%p)", __func__, a)
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 102db8c88e97..cb8a42ff4646 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -216,7 +216,6 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_options_received mp_opt;
 	struct sock *parent = subflow->conn;
-	struct tcp_sock *tp = tcp_sk(sk);
 
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
 
@@ -230,6 +229,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		return;
 
 	subflow->conn_finished = 1;
+	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
+	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
 
 	mptcp_get_options(skb, &mp_opt);
 	if (subflow->request_mptcp && mp_opt.mp_capable) {
@@ -245,21 +246,20 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u", subflow,
 			 subflow->thmac, subflow->remote_nonce);
 	} else {
-		tp->is_mptcp = 0;
+		if (subflow->request_mptcp)
+			MPTCP_INC_STATS(sock_net(sk),
+					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
+		mptcp_do_fallback(sk);
+		pr_fallback(mptcp_sk(subflow->conn));
 	}
 
-	if (!tp->is_mptcp)
+	if (mptcp_check_fallback(sk))
 		return;
 
 	if (subflow->mp_capable) {
 		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
 		mptcp_finish_connect(sk);
-
-		if (skb) {
-			pr_debug("synack seq=%u", TCP_SKB_CB(skb)->seq);
-			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
-		}
 	} else if (subflow->mp_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
 
@@ -279,9 +279,6 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 		memcpy(subflow->hmac, hmac, MPTCPOPT_HMAC_LEN);
 
-		if (skb)
-			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
-
 		if (!mptcp_finish_join(sk))
 			goto do_reset;
 
@@ -557,7 +554,8 @@ enum mapping_status {
 	MAPPING_OK,
 	MAPPING_INVALID,
 	MAPPING_EMPTY,
-	MAPPING_DATA_FIN
+	MAPPING_DATA_FIN,
+	MAPPING_DUMMY
 };
 
 static u64 expand_seq(u64 old_seq, u16 old_data_len, u64 seq)
@@ -621,6 +619,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 	if (!skb)
 		return MAPPING_EMPTY;
 
+	if (mptcp_check_fallback(ssk))
+		return MAPPING_DUMMY;
+
 	mpext = mptcp_get_ext(skb);
 	if (!mpext || !mpext->use_map) {
 		if (!subflow->map_valid && !skb->len) {
@@ -762,6 +763,16 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			ssk->sk_err = EBADMSG;
 			goto fatal;
 		}
+		if (status == MAPPING_DUMMY) {
+			__mptcp_do_fallback(msk);
+			skb = skb_peek(&ssk->sk_receive_queue);
+			subflow->map_valid = 1;
+			subflow->map_seq = READ_ONCE(msk->ack_seq);
+			subflow->map_data_len = skb->len;
+			subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq -
+						   subflow->ssn_offset;
+			return true;
+		}
 
 		if (status != MAPPING_OK)
 			return false;
@@ -885,14 +896,18 @@ static void subflow_data_ready(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct sock *parent = subflow->conn;
+	struct mptcp_sock *msk;
 
-	if (!subflow->mp_capable && !subflow->mp_join) {
-		subflow->tcp_data_ready(sk);
-
+	msk = mptcp_sk(parent);
+	if (inet_sk_state_load(sk) == TCP_LISTEN) {
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 		parent->sk_data_ready(parent);
 		return;
 	}
 
+	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
+		     !subflow->mp_join);
+
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
 }
@@ -1117,7 +1132,7 @@ static void subflow_state_change(struct sock *sk)
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.
 	 */
-	if (subflow->mp_capable && mptcp_subflow_data_available(sk))
+	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
 
 	if (!(parent->sk_shutdown & RCV_SHUTDOWN) &&
-- 
2.26.2

