Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA82686BB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgINIC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgINICA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=riPQRKiBy26FP3cXcnTrrUWn6eSdzpOcSSCaNh5OETs=;
        b=aamc4/ChtsOeFu6t7e/fDH+W2J6Qyl/TfNXUfM/gKvmLeFbhTebn0R061hv99YHgOqomGP
        WUug8X5EOxp9aETyawiJhoSzQelcozEmbVjiXZWLGM0s7PbF4hqubSwa7HkMVdGVezj5Pl
        Sbgz14Bbrnevt9Lq6bglgvi756Mr5Iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-VHukLZcFMBG1B6B6FmBvYw-1; Mon, 14 Sep 2020 04:01:56 -0400
X-MC-Unique: VHukLZcFMBG1B6B6FmBvYw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B02B10051AE;
        Mon, 14 Sep 2020 08:01:55 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCFEB19C66;
        Mon, 14 Sep 2020 08:01:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 11/13] mptcp: allow picking different xmit subflows
Date:   Mon, 14 Sep 2020 10:01:17 +0200
Message-Id: <e676b2a4b3de838d458353e9f860a2fd4e1a9e35.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the scheduler to less trivial heuristic: cache
the last used subflow, and try to send on it a reasonably
long burst of data.

When the burst or the subflow send space is exhausted, pick
the subflow with the lower ratio between write space and
send buffer - that is, the subflow with the greater relative
amount of free space.

v1 -> v2:
 - fix 32 bit build breakage due to 64bits div
 - fix checkpath issues (uint64_t -> u64)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 111 ++++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h |   6 ++-
 2 files changed, 99 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ec9c38d3acc7..d7af96a900c4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1031,41 +1031,105 @@ static void mptcp_nospace(struct mptcp_sock *msk)
 	}
 }
 
+static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+{
+	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
+	if (subflow->request_join && !subflow->fully_established)
+		return false;
+
+	/* only send if our side has not closed yet */
+	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
+}
+
+#define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
+					 sizeof(struct tcphdr) - \
+					 MAX_TCP_OPTION_SPACE - \
+					 sizeof(struct ipv6hdr) - \
+					 sizeof(struct frag_hdr))
+
+struct subflow_send_info {
+	struct sock *ssk;
+	u64 ratio;
+};
+
 static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 					   u32 *sndbuf)
 {
+	struct subflow_send_info send_info[2];
 	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
-	struct sock *backup = NULL;
-	bool free;
+	int i, nr_active = 0;
+	struct sock *ssk;
+	u64 ratio;
+	u32 pace;
 
-	sock_owned_by_me(sk);
+	sock_owned_by_me((struct sock *)msk);
 
 	*sndbuf = 0;
 	if (!mptcp_ext_cache_refill(msk))
 		return NULL;
 
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		free = sk_stream_is_writeable(subflow->tcp_sock);
-		if (!free) {
-			mptcp_nospace(msk);
+	if (__mptcp_check_fallback(msk)) {
+		if (!msk->first)
 			return NULL;
+		*sndbuf = msk->first->sk_sndbuf;
+		return sk_stream_memory_free(msk->first) ? msk->first : NULL;
+	}
+
+	/* re-use last subflow, if the burst allow that */
+	if (msk->last_snd && msk->snd_burst > 0 &&
+	    sk_stream_memory_free(msk->last_snd) &&
+	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd))) {
+		mptcp_for_each_subflow(msk, subflow) {
+			ssk =  mptcp_subflow_tcp_sock(subflow);
+			*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
 		}
+		return msk->last_snd;
+	}
+
+	/* pick the subflow with the lower wmem/wspace ratio */
+	for (i = 0; i < 2; ++i) {
+		send_info[i].ssk = NULL;
+		send_info[i].ratio = -1;
+	}
+	mptcp_for_each_subflow(msk, subflow) {
+		ssk =  mptcp_subflow_tcp_sock(subflow);
+		if (!mptcp_subflow_active(subflow))
+			continue;
 
+		nr_active += !subflow->backup;
 		*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
-		if (subflow->backup) {
-			if (!backup)
-				backup = ssk;
+		if (!sk_stream_memory_free(subflow->tcp_sock))
+			continue;
 
+		pace = READ_ONCE(ssk->sk_pacing_rate);
+		if (!pace)
 			continue;
-		}
 
-		return ssk;
+		ratio = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32,
+				pace);
+		if (ratio < send_info[subflow->backup].ratio) {
+			send_info[subflow->backup].ssk = ssk;
+			send_info[subflow->backup].ratio = ratio;
+		}
 	}
 
-	return backup;
+	pr_debug("msk=%p nr_active=%d ssk=%p:%lld backup=%p:%lld",
+		 msk, nr_active, send_info[0].ssk, send_info[0].ratio,
+		 send_info[1].ssk, send_info[1].ratio);
+
+	/* pick the best backup if no other subflow is active */
+	if (!nr_active)
+		send_info[0].ssk = send_info[1].ssk;
+
+	if (send_info[0].ssk) {
+		msk->last_snd = send_info[0].ssk;
+		msk->snd_burst = min_t(int, MPTCP_SEND_BURST_SIZE,
+				       sk_stream_wspace(msk->last_snd));
+		return msk->last_snd;
+	}
+	return NULL;
 }
 
 static void ssk_check_wmem(struct mptcp_sock *msk)
@@ -1160,6 +1224,10 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			break;
 		}
 
+		/* burst can be negative, we will try move to the next subflow
+		 * at selection time, if possible.
+		 */
+		msk->snd_burst -= ret;
 		copied += ret;
 
 		tx_ok = msg_data_left(msg);
@@ -1375,6 +1443,11 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	unsigned int moved = 0;
 	bool done;
 
+	/* avoid looping forever below on racing close */
+	if (((struct sock *)msk)->sk_state == TCP_CLOSE)
+		return false;
+
+	__mptcp_flush_join_list(msk);
 	do {
 		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
 
@@ -1539,9 +1612,15 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 
 	sock_owned_by_me((const struct sock *)msk);
 
+	if (__mptcp_check_fallback(msk))
+		return msk->first;
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
+		if (!mptcp_subflow_active(subflow))
+			continue;
+
 		/* still data outstanding at TCP level?  Don't retransmit. */
 		if (!tcp_write_queue_empty(ssk))
 			return NULL;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index cfa5e1b9521b..493bd2c13bc6 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -196,6 +196,8 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u64		rcv_data_fin_seq;
+	struct sock	*last_snd;
+	int		snd_burst;
 	atomic64_t	snd_una;
 	unsigned long	timer_ival;
 	u32		token;
@@ -473,12 +475,12 @@ static inline bool before64(__u64 seq1, __u64 seq2)
 
 void mptcp_diag_subflow_init(struct tcp_ulp_ops *ops);
 
-static inline bool __mptcp_check_fallback(struct mptcp_sock *msk)
+static inline bool __mptcp_check_fallback(const struct mptcp_sock *msk)
 {
 	return test_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-static inline bool mptcp_check_fallback(struct sock *sk)
+static inline bool mptcp_check_fallback(const struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-- 
2.26.2

