Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B553A2B9BB1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgKSTqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:56916 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbgKSTqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:13 -0500
IronPort-SDR: bRvEhjL2IbjQiy34vxPuURAlhrPY6xbhrV6MSRkmX1maK+k8B7npEYGetqVAk3d3WKRBgPRNZm
 Jadie7Z8z4/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171451136"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171451136"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: coZ2WVjKfSXP57B7U/rof2lcw7Zbfuv+u3ijnWBXE5/U6Pmlo9kFk+vN4CZ3mi/ba4saxi+b97
 SiYDxEtIC7+g==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940489"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, kuba@kernel.org,
        mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/10] mptcp: track window announced to peer
Date:   Thu, 19 Nov 2020 11:46:02 -0800
Message-Id: <20201119194603.103158-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

OoO handling attempts to detect when packet is out-of-window by testing
current ack sequence and remaining space vs. sequence number.

This doesn't work reliably. Store the highest allowed sequence number
that we've announced and use it to detect oow packets.

Do this when mptcp options get written to the packet (wire format).
For this to work we need to move the write_options call until after
stack selected a new tcp window.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h   |  3 ++-
 net/ipv4/tcp_output.c | 11 +++++++----
 net/mptcp/options.c   | 22 +++++++++++++++++++++-
 net/mptcp/protocol.c  | 12 +++++++-----
 net/mptcp/protocol.h  |  1 +
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 6e706d838e4e..b6cf07143a8a 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -88,7 +88,8 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       struct mptcp_out_options *opts);
 void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb);
 
-void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
+void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+			 struct mptcp_out_options *opts);
 
 /* move the skb extension owership, with the assumption that 'to' is
  * newly allocated
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 99905bc01d40..41880d3521ed 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -445,11 +445,12 @@ struct tcp_out_options {
 	struct mptcp_out_options mptcp;
 };
 
-static void mptcp_options_write(__be32 *ptr, struct tcp_out_options *opts)
+static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
+				struct tcp_out_options *opts)
 {
 #if IS_ENABLED(CONFIG_MPTCP)
 	if (unlikely(OPTION_MPTCP & opts->options))
-		mptcp_write_options(ptr, &opts->mptcp);
+		mptcp_write_options(ptr, tp, &opts->mptcp);
 #endif
 }
 
@@ -701,7 +702,7 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 
 	smc_options_write(ptr, &options);
 
-	mptcp_options_write(ptr, opts);
+	mptcp_options_write(ptr, tp, opts);
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
@@ -1346,7 +1347,6 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	tcp_options_write((__be32 *)(th + 1), tp, &opts);
 	skb_shinfo(skb)->gso_type = sk->sk_gso_type;
 	if (likely(!(tcb->tcp_flags & TCPHDR_SYN))) {
 		th->window      = htons(tcp_select_window(sk));
@@ -1357,6 +1357,9 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		 */
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
+
+	tcp_options_write((__be32 *)(th + 1), tp, &opts);
+
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
 	if (md5) {
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index d7afffcc87c1..248e3930c0cb 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1010,7 +1010,24 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
-void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
+static void mptcp_set_rwin(const struct tcp_sock *tp)
+{
+	const struct sock *ssk = (const struct sock *)tp;
+	const struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk;
+	u64 ack_seq;
+
+	subflow = mptcp_subflow_ctx(ssk);
+	msk = mptcp_sk(subflow->conn);
+
+	ack_seq = READ_ONCE(msk->ack_seq) + tp->rcv_wnd;
+
+	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent)))
+		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
+}
+
+void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+			 struct mptcp_out_options *opts)
 {
 	if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
 	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
@@ -1167,4 +1184,7 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
 		}
 	}
+
+	if (tp)
+		mptcp_set_rwin(tp);
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c2629190b1ce..4ae2c4a30e44 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -168,19 +168,19 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 	struct rb_node **p, *parent;
 	u64 seq, end_seq, max_seq;
 	struct sk_buff *skb1;
-	int space;
 
 	seq = MPTCP_SKB_CB(skb)->map_seq;
 	end_seq = MPTCP_SKB_CB(skb)->end_seq;
-	space = tcp_space(sk);
-	max_seq = space > 0 ? space + msk->ack_seq : msk->ack_seq;
+	max_seq = READ_ONCE(msk->rcv_wnd_sent);
 
 	pr_debug("msk=%p seq=%llx limit=%llx empty=%d", msk, seq, max_seq,
 		 RB_EMPTY_ROOT(&msk->out_of_order_queue));
-	if (after64(seq, max_seq)) {
+	if (after64(end_seq, max_seq)) {
 		/* out of window */
 		mptcp_drop(sk, skb);
-		pr_debug("oow by %ld", (unsigned long)seq - (unsigned long)max_seq);
+		pr_debug("oow by %lld, rcv_wnd_sent %llu\n",
+			 (unsigned long long)end_seq - (unsigned long)max_seq,
+			 (unsigned long long)msk->rcv_wnd_sent);
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_NODSSWINDOW);
 		return;
 	}
@@ -2294,6 +2294,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
 		ack_seq++;
 		WRITE_ONCE(msk->ack_seq, ack_seq);
+		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 	}
 
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
@@ -2586,6 +2587,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
+	WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
 	atomic64_set(&msk->snd_una, msk->write_seq);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4d6dd4adaaaf..67f86818203f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -216,6 +216,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		snd_nxt;
 	u64		ack_seq;
+	u64		rcv_wnd_sent;
 	u64		rcv_data_fin_seq;
 	struct sock	*last_snd;
 	int		snd_burst;
-- 
2.29.2

