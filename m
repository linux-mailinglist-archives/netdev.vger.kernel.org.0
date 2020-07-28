Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4040423156A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgG1WMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:2589 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbgG1WMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:16 -0400
IronPort-SDR: L9B3iO2p6cc7TOqK+gqS0wySlPD5Rf60exmCgQQwCHTyOW58GER4B4LJHl8hxpInMIeS6MiQC1
 B62i3ikbdZdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342677"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342677"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:14 -0700
IronPort-SDR: MIGbWBmnqzi7bmXVeISa7QKmxqdKSHP3/t5lyZhVzFGVfAFygmQ2RQwdFg7Ccc0v9e8teXPHtb
 4B3W63tRWchQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468882"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 04/12] mptcp: Use MPTCP-level flag for sending DATA_FIN
Date:   Tue, 28 Jul 2020 15:12:02 -0700
Message-Id: <20200728221210.92841-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since DATA_FIN information is the same for every subflow, store it only
in the mptcp_sock.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 18 ++++++++++++------
 net/mptcp/protocol.c | 21 +++++----------------
 net/mptcp/protocol.h |  3 +--
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 0b122b2a9c69..f157cb7e14c0 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -451,6 +451,8 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 				 struct sk_buff *skb, struct mptcp_ext *ext)
 {
+	u64 data_fin_tx_seq = READ_ONCE(mptcp_sk(subflow->conn)->write_seq);
+
 	if (!ext->use_map || !skb->len) {
 		/* RFC6824 requires a DSS mapping with specific values
 		 * if DATA_FIN is set but no data payload is mapped
@@ -458,10 +460,13 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 		ext->data_fin = 1;
 		ext->use_map = 1;
 		ext->dsn64 = 1;
-		ext->data_seq = subflow->data_fin_tx_seq;
+		/* The write_seq value has already been incremented, so
+		 * the actual sequence number for the DATA_FIN is one less.
+		 */
+		ext->data_seq = data_fin_tx_seq - 1;
 		ext->subflow_seq = 0;
 		ext->data_len = 1;
-	} else if (ext->data_seq + ext->data_len == subflow->data_fin_tx_seq) {
+	} else if (ext->data_seq + ext->data_len == data_fin_tx_seq) {
 		/* If there's an existing DSS mapping and it is the
 		 * final mapping, DATA_FIN consumes 1 additional byte of
 		 * mapping space.
@@ -477,15 +482,17 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 					  struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	unsigned int dss_size = 0;
+	u64 snd_data_fin_enable;
 	struct mptcp_ext *mpext;
-	struct mptcp_sock *msk;
 	unsigned int ack_size;
 	bool ret = false;
 
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
+	snd_data_fin_enable = READ_ONCE(msk->snd_data_fin_enable);
 
-	if (!skb || (mpext && mpext->use_map) || subflow->data_fin_tx_enable) {
+	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
 		unsigned int map_size;
 
 		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
@@ -495,7 +502,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		if (mpext)
 			opts->ext_copy = *mpext;
 
-		if (skb && subflow->data_fin_tx_enable)
+		if (skb && snd_data_fin_enable)
 			mptcp_write_data_fin(subflow, skb, &opts->ext_copy);
 		ret = true;
 	}
@@ -504,7 +511,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	 * if the first subflow may have the already the remote key handy
 	 */
 	opts->ext_copy.use_ack = 0;
-	msk = mptcp_sk(subflow->conn);
 	if (!READ_ONCE(msk->can_ack)) {
 		*size = ALIGN(dss_size, 4);
 		return ret;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7d7e0fa17219..dd403ba3679a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1391,8 +1391,7 @@ static void mptcp_cancel_work(struct sock *sk)
 		sock_put(sk);
 }
 
-static void mptcp_subflow_shutdown(struct sock *ssk, int how,
-				   bool data_fin_tx_enable, u64 data_fin_tx_seq)
+static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 {
 	lock_sock(ssk);
 
@@ -1405,14 +1404,6 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how,
 		tcp_disconnect(ssk, O_NONBLOCK);
 		break;
 	default:
-		if (data_fin_tx_enable) {
-			struct mptcp_subflow_context *subflow;
-
-			subflow = mptcp_subflow_ctx(ssk);
-			subflow->data_fin_tx_seq = data_fin_tx_seq;
-			subflow->data_fin_tx_enable = 1;
-		}
-
 		ssk->sk_shutdown |= how;
 		tcp_shutdown(ssk, how);
 		break;
@@ -1426,7 +1417,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	LIST_HEAD(conn_list);
-	u64 data_fin_tx_seq;
 
 	lock_sock(sk);
 
@@ -1440,7 +1430,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	spin_unlock_bh(&msk->join_list_lock);
 	list_splice_init(&msk->conn_list, &conn_list);
 
-	data_fin_tx_seq = msk->write_seq;
+	msk->snd_data_fin_enable = 1;
 
 	__mptcp_clear_xmit(sk);
 
@@ -1448,9 +1438,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		subflow->data_fin_tx_seq = data_fin_tx_seq;
-		subflow->data_fin_tx_enable = 1;
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
@@ -2146,10 +2133,12 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	}
 
 	__mptcp_flush_join_list(msk);
+	msk->snd_data_fin_enable = 1;
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
-		mptcp_subflow_shutdown(tcp_sk, how, 1, msk->write_seq);
+		mptcp_subflow_shutdown(tcp_sk, how);
 	}
 
 	/* Wake up anyone sleeping in poll. */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67634b595466..3f49cc105772 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -199,6 +199,7 @@ struct mptcp_sock {
 	unsigned long	flags;
 	bool		can_ack;
 	bool		fully_established;
+	bool		snd_data_fin_enable;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
@@ -291,10 +292,8 @@ struct mptcp_subflow_context {
 		backup : 1,
 		data_avail : 1,
 		rx_eof : 1,
-		data_fin_tx_enable : 1,
 		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
-	u64	data_fin_tx_seq;
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
-- 
2.28.0

