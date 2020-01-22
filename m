Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6A144A7D
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAVDes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:34:48 -0500
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:58796 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVDes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:34:48 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0ux6t000395;
        Tue, 21 Jan 2020 16:57:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=Mo11qu68XXptC7F18Q0zSfwxwPMXjNEChqmbm5/5QPk=;
 b=BNEmHvB6zKYHZ5n4ZfbAtQm1++6yOKQSbOiu3M4cS/36SF6BEifWFdnPbxWxMNtFd5hD
 Ot7EbHU9Hh0t2iBaXy9S4k9r4n9l6Gih8PeDQdKAaFIbEs7W9VTuxrLYCtyWLxEC40Ul
 5io1xWfUqfmoUAj4XWMcdhqSkK5H+s8JD1emULJTtoe6NEviVZqvseH/UboH36Ry2rW5
 LBJ3ZieRT7ElDHSrGBxBSzJCg46a9cFj06qHtqHpi95BdZuQ0cKN+3Kv7gN9QCdC//TK
 G8fNXPYvU3TNO8gyRDiIEdiQ+/aPzGqoHVAA8bEpAi7sHZMpaa3Xzdo9xWlMDxRlwpZK Sg== 
Received: from ma1-mtap-s02.corp.apple.com (ma1-mtap-s02.corp.apple.com [17.40.76.6])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 2xkyjxgr5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:10 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s02.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H0018HHB4F030@ma1-mtap-s02.corp.apple.com>; Tue,
 21 Jan 2020 16:57:06 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:05 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 2bb8c2377df4632229015a09c88e84d8
X-Va-R-CD: d36872a0082b8a68a9205f4deb0f4013
X-Va-CD: 0
X-Va-ID: 30d7c300-e5fb-4f9a-baf8-df9bf2c6b0ea
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 2bb8c2377df4632229015a09c88e84d8
X-V-R-CD: d36872a0082b8a68a9205f4deb0f4013
X-V-CD: 0
X-V-ID: bc994a17-54d6-44d6-a218-9423c783ae97
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DT0HB1DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
Subject: [PATCH net-next v3 18/19] mptcp: process MP_CAPABLE data option
Date:   Tue, 21 Jan 2020 16:56:32 -0800
Message-id: <20200122005633.21229-19-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the handling of MP_CAPABLE + data option, as per
RFC 6824 bis / RFC 8684: MPTCP v1.

On the server side we can receive the remote key after that the connection
is established. We need to explicitly track the 'missing remote key'
status and avoid emitting a mptcp ack until we get such info.

When a late/retransmitted/OoO pkt carrying MP_CAPABLE[+data] option
is received, we have to propagate the mptcp seq number info to
the msk socket. To avoid ABBA locking issue, explicitly check for
that in recvmsg(), where we own msk and subflow sock locks.

The above also means that an established mp_capable subflow - still
waiting for the remote key - can be 'downgraded' to plain TCP.

Such change could potentially block a reader waiting for new data
forever - as they hook to msk, while later wake-up after the downgrade
will be on subflow only.

The above issue is not handled here, we likely have to get rid of
msk->fallback to handle that cleanly.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/options.c  | 56 ++++++++++++++++++++++++++++++++++----------
 net/mptcp/protocol.c | 16 +++++++------
 net/mptcp/protocol.h | 10 +++++---
 net/mptcp/subflow.c  | 40 +++++++++++++++++++++++++++----
 4 files changed, 95 insertions(+), 27 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8f82ff9a5a8e..45acd877bef3 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -243,6 +243,7 @@ void mptcp_rcv_synsent(struct sock *sk)
 	pr_debug("subflow=%p", subflow);
 	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
 		subflow->mp_capable = 1;
+		subflow->can_ack = 1;
 		subflow->remote_key = tp->rx_opt.mptcp.sndr_key;
 	} else {
 		tcp_sk(sk)->is_mptcp = 0;
@@ -332,6 +333,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_ext *mpext;
 	struct mptcp_sock *msk;
 	unsigned int ack_size;
+	bool ret = false;
 	u8 tcp_fin;
 
 	if (skb) {
@@ -355,6 +357,14 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		if (skb && tcp_fin &&
 		    subflow->conn->sk_state != TCP_ESTABLISHED)
 			mptcp_write_data_fin(subflow, &opts->ext_copy);
+		ret = true;
+	}
+
+	opts->ext_copy.use_ack = 0;
+	msk = mptcp_sk(subflow->conn);
+	if (!msk || !READ_ONCE(msk->can_ack)) {
+		*size = ALIGN(dss_size, 4);
+		return ret;
 	}
 
 	ack_size = TCPOLEN_MPTCP_DSS_ACK64;
@@ -365,15 +375,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 
 	dss_size += ack_size;
 
-	msk = mptcp_sk(mptcp_subflow_ctx(sk)->conn);
-	if (msk) {
-		opts->ext_copy.data_ack = msk->ack_seq;
-	} else {
-		mptcp_crypto_key_sha(mptcp_subflow_ctx(sk)->remote_key,
-				     NULL, &opts->ext_copy.data_ack);
-		opts->ext_copy.data_ack++;
-	}
-
+	opts->ext_copy.data_ack = msk->ack_seq;
 	opts->ext_copy.ack64 = 1;
 	opts->ext_copy.use_ack = 1;
 
@@ -422,13 +424,46 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 	return false;
 }
 
+static bool check_fourth_ack(struct mptcp_subflow_context *subflow,
+			     struct sk_buff *skb,
+			     struct mptcp_options_received *mp_opt)
+{
+	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
+	 * are relevant
+	 */
+	if (likely(subflow->fourth_ack ||
+		   TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1))
+		return true;
+
+	if (mp_opt->use_ack)
+		subflow->fourth_ack = 1;
+
+	if (subflow->can_ack)
+		return true;
+
+	/* If the first established packet does not contain MP_CAPABLE + data
+	 * then fallback to TCP
+	 */
+	if (!mp_opt->mp_capable) {
+		subflow->mp_capable = 0;
+		tcp_sk(mptcp_subflow_tcp_sock(subflow))->is_mptcp = 0;
+		return false;
+	}
+	subflow->remote_key = mp_opt->sndr_key;
+	subflow->can_ack = 1;
+	return true;
+}
+
 void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 			    struct tcp_options_received *opt_rx)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_options_received *mp_opt;
 	struct mptcp_ext *mpext;
 
 	mp_opt = &opt_rx->mptcp;
+	if (!check_fourth_ack(subflow, skb, mp_opt))
+		return;
 
 	if (!mp_opt->dss)
 		return;
@@ -441,9 +476,6 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 
 	if (mp_opt->use_map) {
 		if (mp_opt->mpc_map) {
-			struct mptcp_subflow_context *subflow =
-				mptcp_subflow_ctx(sk);
-
 			/* this is an MP_CAPABLE carrying MPTCP data
 			 * we know this map the first chunk of data
 			 */
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 45e482864a19..1b64dfaa5f63 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -30,7 +30,7 @@
  */
 static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 {
-	if (!msk->subflow || mptcp_subflow_ctx(msk->subflow->sk)->fourth_ack)
+	if (!msk->subflow || READ_ONCE(msk->can_ack))
 		return NULL;
 
 	return msk->subflow;
@@ -651,17 +651,20 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		__mptcp_init_sock(new_mptcp_sock);
 
 		msk = mptcp_sk(new_mptcp_sock);
-		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		msk->subflow = NULL;
 
 		mptcp_token_update_accept(newsk, new_mptcp_sock);
 
-		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
-		ack_seq++;
-		msk->ack_seq = ack_seq;
+		if (subflow->can_ack) {
+			msk->can_ack = true;
+			msk->remote_key = subflow->remote_key;
+			mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
+			ack_seq++;
+			msk->ack_seq = ack_seq;
+		}
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -678,8 +681,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		 * the receive path and process the pending ones
 		 */
 		lock_sock(ssk);
-		subflow->map_seq = ack_seq;
-		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
 		subflow->tcp_sock = ssk;
 		subflow->conn = new_mptcp_sock;
@@ -795,6 +796,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->token, subflow->token);
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
+	WRITE_ONCE(msk->can_ack, 1);
 }
 
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 36b90024d34d..10eaa7c7381b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -69,6 +69,7 @@ struct mptcp_sock {
 	u64		ack_seq;
 	u32		token;
 	unsigned long	flags;
+	bool		can_ack;
 	struct list_head conn_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
@@ -84,9 +85,10 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 
 struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
-	u8	mp_capable : 1,
+	u16	mp_capable : 1,
 		mp_join : 1,
-		backup : 1;
+		backup : 1,
+		remote_key_valid : 1;
 	u64	local_key;
 	u64	remote_key;
 	u64	idsn;
@@ -118,8 +120,10 @@ struct mptcp_subflow_context {
 		fourth_ack : 1,	    /* send initial DSS */
 		conn_finished : 1,
 		map_valid : 1,
+		mpc_map : 1,
 		data_avail : 1,
-		rx_eof : 1;
+		rx_eof : 1,
+		can_ack : 1;	    /* only after processing the remote a key */
 
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8892855f4f52..8cfa1d29d59c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -61,6 +61,7 @@ static void subflow_init_req(struct request_sock *req,
 	mptcp_get_options(skb, &rx_opt);
 
 	subflow_req->mp_capable = 0;
+	subflow_req->remote_key_valid = 0;
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -185,17 +186,28 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
-	/* if the sk is MP_CAPABLE, we need to fetch the client key */
+	/* if the sk is MP_CAPABLE, we try to fetch the client key */
 	subflow_req = mptcp_subflow_rsk(req);
 	if (subflow_req->mp_capable) {
+		if (TCP_SKB_CB(skb)->seq != subflow_req->ssn_offset + 1) {
+			/* here we can receive and accept an in-window,
+			 * out-of-order pkt, which will not carry the MP_CAPABLE
+			 * opt even on mptcp enabled paths
+			 */
+			goto create_child;
+		}
+
 		opt_rx.mptcp.mp_capable = 0;
 		mptcp_get_options(skb, &opt_rx);
-		if (!opt_rx.mptcp.mp_capable)
-			subflow_req->mp_capable = 0;
-		else
+		if (opt_rx.mptcp.mp_capable) {
 			subflow_req->remote_key = opt_rx.mptcp.sndr_key;
+			subflow_req->remote_key_valid = 1;
+		} else {
+			subflow_req->mp_capable = 0;
+		}
 	}
 
+create_child:
 	child = listener->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
 						     req_unhash, own_req);
 
@@ -377,6 +389,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 	subflow->map_subflow_seq = mpext->subflow_seq;
 	subflow->map_data_len = data_len;
 	subflow->map_valid = 1;
+	subflow->mpc_map = mpext->mpc_map;
 	pr_debug("new map seq=%llu subflow_seq=%u data_len=%u",
 		 subflow->map_seq, subflow->map_subflow_seq,
 		 subflow->map_data_len);
@@ -428,6 +441,19 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		if (WARN_ON_ONCE(!skb))
 			return false;
 
+		/* if msk lacks the remote key, this subflow must provide an
+		 * MP_CAPABLE-based mapping
+		 */
+		if (unlikely(!READ_ONCE(msk->can_ack))) {
+			if (!subflow->mpc_map) {
+				ssk->sk_err = EBADMSG;
+				goto fatal;
+			}
+			WRITE_ONCE(msk->remote_key, subflow->remote_key);
+			WRITE_ONCE(msk->ack_seq, subflow->map_seq);
+			WRITE_ONCE(msk->can_ack, true);
+		}
+
 		old_ack = READ_ONCE(msk->ack_seq);
 		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
 		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
@@ -752,13 +778,17 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		return;
 	}
 
+	/* see comments in subflow_syn_recv_sock(), MPTCP connection is fully
+	 * established only after we receive the remote key
+	 */
 	new_ctx->conn_finished = 1;
 	new_ctx->icsk_af_ops = old_ctx->icsk_af_ops;
 	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
 	new_ctx->tcp_state_change = old_ctx->tcp_state_change;
 	new_ctx->tcp_write_space = old_ctx->tcp_write_space;
 	new_ctx->mp_capable = 1;
-	new_ctx->fourth_ack = 1;
+	new_ctx->fourth_ack = subflow_req->remote_key_valid;
+	new_ctx->can_ack = subflow_req->remote_key_valid;
 	new_ctx->remote_key = subflow_req->remote_key;
 	new_ctx->local_key = subflow_req->local_key;
 	new_ctx->token = subflow_req->token;
-- 
2.23.0

