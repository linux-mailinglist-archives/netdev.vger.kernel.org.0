Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B12639167
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKYWak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiKYWa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:27 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B922EF2E
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:25 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so13093871ejc.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6lT3FZILfL+dT/ClXXJliaYvhVNzCsNrT4CNSWSYFQ=;
        b=fVMdLuD2sjzyXcJ5c+yrqCkXZQawn2evU+9L96MlHiUXWiFO9WEGvWRPyOM2X6fFw2
         SwCUGLZzN7vTE1wFL0lc8ElabwGGgy8zS+NjcSGyDjj9/H0TM432uhR5Yh82cXUmgtk6
         hEES8Ap5FwUTIuEzKyxwNNDYOLI7ATavsr83TcNpVgQLXshOmHZkgNVXe0x2lKPJtL4s
         mGXEjk7S8PiA1qOFv1geBSfHZAH/HnSXeQOg+bWOmqyBSXJA7T/0R7bsrI6AxhMgPfha
         jiQ5kcBtiBGUB/gELeR/4st+GxHIZivm+kz5cMUAWu48Ftl9E3zsJRezf9tNDsD3l2C5
         I2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6lT3FZILfL+dT/ClXXJliaYvhVNzCsNrT4CNSWSYFQ=;
        b=6TpxopHFXHHlQOCzGXrxr5SXk2ydjXnae1/TVpGD2xpq/z+HSfNy6i9TA3VASmQQ1Q
         SUQ7lVEez2F0X3oP7+2O6TMFWdjSFmeTM1eWgyfYO0xxQcCmlZrzaJJNnD5+58geJDmP
         UogHVmGQeSK1k2+yEVUp8OGDtxFciTiAHGhzIopCjSL+/lKC/Iz9dT5B27RHxKy4KBZP
         0Z4PsSp+URvdCoDqbOMktPG0fmrlaK6p7dumNmC247E1fra3wOJtXC9KkdduEuTIRv6s
         mXENdQUCwYJn7IuKlABAySh5cmXrIn8UlBAPBnokQIxqSv/NA/kxZb2JHD2kR7/tV1n1
         sQrQ==
X-Gm-Message-State: ANoB5pmVtrd9xByQrd5F7Q3GvNiUsK3b26EhOv4oTrCjGLz65IyX+n2S
        YI7ErL9Vv+B2Ikqg27dPyPOF8w==
X-Google-Smtp-Source: AA0mqf4FvFMPIKLFCuwR1KrjDr/GhlbDXMiLuTUZao+u9DM8bmALDjOjU2SD/KqHq6wZGfGonCMc2Q==
X-Received: by 2002:a17:906:78c:b0:78d:9c18:7307 with SMTP id l12-20020a170906078c00b0078d9c187307mr36585172ejc.23.1669415423722;
        Fri, 25 Nov 2022 14:30:23 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:23 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] mptcp: consolidate initial ack seq generation
Date:   Fri, 25 Nov 2022 23:29:49 +0100
Message-Id: <20221125222958.958636-4-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10336; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=1CGfFv+DlDhoY8aqKvjqlsXYaA49AqsSsU44nEr4dQo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHPQZRhYSYkZrfaYBrSFq4PiitStlqTeEbLVyK7
 +7nntCqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgc7MMEA
 DD1CjxEOK/YMwS0TwAWfCo0NvdPmTCGMjUjGtzUGqWsyanZUQmL93PCXjfT9f/XUxfkq03Vt0lc3GU
 KPDxGR9lOAbyYRJpHqC2t2IkGd74Qa3137qZbINy2LwX2ejK7aXicxAl2uYeAd9PUpKxEpN0pHURG/
 /AwHs3HfgGhOEvsgAuJ6khYueEoFinzvYiCNpXj+Q4/ekQSqQIUlXOW31q2pccZ6FOtch1z5ERCz4T
 ziUs96tl3ylkDwTOgMc28A9jYibwvyMwKE1cr8cvACFA8Lzc+6K60zLsqHFpOaLXt4pAF3oqzyRUv7
 wE34/boM8PfbBIYtxDnkvRlZbr+zdixGDFmOZc0MXYYpwUD2HI/lizeo3slY1ypjMqw7czXsjDa3sR
 UZxHlCpuHI4TsRP4VHSiRCm8WLPhAacsF6nFeJ8MbAa4WjDk6W96/xOJWKf5EglAA3pwx2B4Iq088N
 1SiPTsk14gw9mGYnMQebW05udnw5TQJ61G8GKBZb5OowfdRF8S1cF5Jv8M3M0nAsUinAEfTujcXUCL
 Atr25wF6vdj8VnhDISQOyN1rt+zVEAIYQ+DMJ2ASMqmf76D8/Q3XJcrVRBOv0qmhk5qAImpD6AN/YP
 b/Ww0+qeJRLAEhlmPGUsxmlfGbUfxUD1UJSzScP91mVEiT2CUTtKOSWLgcRw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently the initial ack sequence is generated on demand whenever
it's requested and the remote key is handy. The relevant code is
scattered in different places and can lead to multiple, unneeded,
crypto operations.

This change consolidates the ack sequence generation code in a single
helper, storing the sequence number at the subflow level.

The above additionally saves a few conditional in fast-path and will
simplify the upcoming fast-open implementation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/options.c  |  5 ++--
 net/mptcp/protocol.c | 19 +--------------
 net/mptcp/protocol.h |  9 ++++---
 net/mptcp/subflow.c  | 57 +++++++++++++++++++++++++++-----------------
 4 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 784a205e80da..ae076468fcb9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -953,8 +953,9 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return subflow->mp_capable;
 	}
 
-	if (((mp_opt->suboptions & OPTION_MPTCP_DSS) && mp_opt->use_ack) ||
-	    ((mp_opt->suboptions & OPTION_MPTCP_ADD_ADDR) && !mp_opt->echo)) {
+	if (subflow->remote_key_valid &&
+	    (((mp_opt->suboptions & OPTION_MPTCP_DSS) && mp_opt->use_ack) ||
+	     ((mp_opt->suboptions & OPTION_MPTCP_ADD_ADDR) && !mp_opt->echo))) {
 		/* subflows are fully established as soon as we get any
 		 * additional ack, including ADD_ADDR.
 		 */
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 37876e06d4c4..00de7f4fce10 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3046,7 +3046,6 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
 	struct mptcp_sock *msk;
-	u64 ack_seq;
 
 	if (!nsk)
 		return NULL;
@@ -3072,15 +3071,6 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
 	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 
-	if (mp_opt->suboptions & OPTIONS_MPTCP_MPC) {
-		msk->can_ack = true;
-		msk->remote_key = mp_opt->sndr_key;
-		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
-		ack_seq++;
-		WRITE_ONCE(msk->ack_seq, ack_seq);
-		atomic64_set(&msk->rcv_wnd_sent, ack_seq);
-	}
-
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
 	/* will be fully established after successful MPC subflow creation */
 	inet_sk_state_store(nsk, TCP_SYN_RECV);
@@ -3353,7 +3343,6 @@ void mptcp_finish_connect(struct sock *ssk)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk;
 	struct sock *sk;
-	u64 ack_seq;
 
 	subflow = mptcp_subflow_ctx(ssk);
 	sk = subflow->conn;
@@ -3361,22 +3350,16 @@ void mptcp_finish_connect(struct sock *ssk)
 
 	pr_debug("msk=%p, token=%u", sk, subflow->token);
 
-	mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
-	ack_seq++;
-	subflow->map_seq = ack_seq;
+	subflow->map_seq = subflow->iasn;
 	subflow->map_subflow_seq = 1;
 
 	/* the socket is not connected yet, no msk/subflow ops can access/race
 	 * accessing the field below
 	 */
-	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->local_key, subflow->local_key);
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
-	WRITE_ONCE(msk->ack_seq, ack_seq);
-	WRITE_ONCE(msk->can_ack, 1);
 	WRITE_ONCE(msk->snd_una, msk->write_seq);
-	atomic64_set(&msk->rcv_wnd_sent, ack_seq);
 
 	mptcp_pm_new_connection(msk, ssk, 0);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6a09ab99a12d..b5abea3d1a9c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -467,7 +467,7 @@ struct mptcp_subflow_context {
 		send_fastclose : 1,
 		send_infinite_map : 1,
 		rx_eof : 1,
-		can_ack : 1,        /* only after processing the remote a key */
+		remote_key_valid : 1,        /* received the peer key from */
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		local_id_valid : 1, /* local_id is correctly initialized */
@@ -477,7 +477,10 @@ struct mptcp_subflow_context {
 	u64	thmac;
 	u32	local_nonce;
 	u32	remote_token;
-	u8	hmac[MPTCPOPT_HMAC_LEN];
+	union {
+		u8	hmac[MPTCPOPT_HMAC_LEN]; /* MPJ subflow only */
+		u64	iasn;	    /* initial ack sequence number, MPC subflows only */
+	};
 	u8	local_id;
 	u8	remote_id;
 	u8	reset_seen:1;
@@ -603,7 +606,7 @@ unsigned int mptcp_stale_loss_cnt(const struct net *net);
 int mptcp_get_pm_type(const struct net *net);
 void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
-				     struct mptcp_options_received *mp_opt);
+				     const struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
 void mptcp_check_and_set_pending(struct sock *sk);
 void __mptcp_push_pending(struct sock *sk, unsigned int flags);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 437a283ba6ea..470e12ce0950 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -392,11 +392,33 @@ static void mptcp_set_connected(struct sock *sk)
 	mptcp_data_unlock(sk);
 }
 
+static void subflow_set_remote_key(struct mptcp_sock *msk,
+				   struct mptcp_subflow_context *subflow,
+				   const struct mptcp_options_received *mp_opt)
+{
+	/* active MPC subflow will reach here multiple times:
+	 * at subflow_finish_connect() time and at 4th ack time
+	 */
+	if (subflow->remote_key_valid)
+		return;
+
+	subflow->remote_key_valid = 1;
+	subflow->remote_key = mp_opt->sndr_key;
+	mptcp_crypto_key_sha(subflow->remote_key, NULL, &subflow->iasn);
+	subflow->iasn++;
+
+	WRITE_ONCE(msk->remote_key, subflow->remote_key);
+	WRITE_ONCE(msk->ack_seq, subflow->iasn);
+	WRITE_ONCE(msk->can_ack, true);
+	atomic64_set(&msk->rcv_wnd_sent, subflow->iasn);
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_options_received mp_opt;
 	struct sock *parent = subflow->conn;
+	struct mptcp_sock *msk;
 
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
 
@@ -404,6 +426,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	if (subflow->conn_finished)
 		return;
 
+	msk = mptcp_sk(parent);
 	mptcp_propagate_sndbuf(parent, sk);
 	subflow->rel_write_seq = 1;
 	subflow->conn_finished = 1;
@@ -416,19 +439,16 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			MPTCP_INC_STATS(sock_net(sk),
 					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
 			mptcp_do_fallback(sk);
-			pr_fallback(mptcp_sk(subflow->conn));
+			pr_fallback(msk);
 			goto fallback;
 		}
 
 		if (mp_opt.suboptions & OPTION_MPTCP_CSUMREQD)
-			WRITE_ONCE(mptcp_sk(parent)->csum_enabled, true);
+			WRITE_ONCE(msk->csum_enabled, true);
 		if (mp_opt.deny_join_id0)
-			WRITE_ONCE(mptcp_sk(parent)->pm.remote_deny_join_id0, true);
+			WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
 		subflow->mp_capable = 1;
-		subflow->can_ack = 1;
-		subflow->remote_key = mp_opt.sndr_key;
-		pr_debug("subflow=%p, remote_key=%llu", subflow,
-			 subflow->remote_key);
+		subflow_set_remote_key(msk, subflow, &mp_opt);
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEACTIVEACK);
 		mptcp_finish_connect(sk);
 		mptcp_set_connected(parent);
@@ -466,7 +486,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
 
-		if (subflow_use_different_dport(mptcp_sk(parent), sk)) {
+		if (subflow_use_different_dport(msk, sk)) {
 			pr_debug("synack inet_dport=%d %d",
 				 ntohs(inet_sk(sk)->inet_dport),
 				 ntohs(inet_sk(parent)->inet_dport));
@@ -474,7 +494,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		}
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
-		mptcp_rcv_space_init(mptcp_sk(parent), sk);
+		mptcp_rcv_space_init(msk, sk);
 		mptcp_set_connected(parent);
 	}
 	return;
@@ -637,13 +657,12 @@ static void subflow_drop_ctx(struct sock *ssk)
 }
 
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
-				     struct mptcp_options_received *mp_opt)
+				     const struct mptcp_options_received *mp_opt)
 {
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 
-	subflow->remote_key = mp_opt->sndr_key;
+	subflow_set_remote_key(msk, subflow, mp_opt);
 	subflow->fully_established = 1;
-	subflow->can_ack = 1;
 	WRITE_ONCE(msk->fully_established, true);
 }
 
@@ -1198,16 +1217,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		if (WARN_ON_ONCE(!skb))
 			goto no_data;
 
-		/* if msk lacks the remote key, this subflow must provide an
-		 * MP_CAPABLE-based mapping
-		 */
-		if (unlikely(!READ_ONCE(msk->can_ack))) {
-			if (!subflow->mpc_map)
-				goto fallback;
-			WRITE_ONCE(msk->remote_key, subflow->remote_key);
-			WRITE_ONCE(msk->ack_seq, subflow->map_seq);
-			WRITE_ONCE(msk->can_ack, true);
-		}
+		if (unlikely(!READ_ONCE(msk->can_ack)))
+			goto fallback;
 
 		old_ack = READ_ONCE(msk->ack_seq);
 		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
@@ -1480,6 +1491,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 
 	mptcp_pm_get_flags_and_ifindex_by_id(msk, local_id,
 					     &flags, &ifindex);
+	subflow->remote_key_valid = 1;
 	subflow->remote_key = msk->remote_key;
 	subflow->local_key = msk->local_key;
 	subflow->token = msk->token;
@@ -1873,6 +1885,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
+		new_ctx->remote_key_valid = 1;
 		new_ctx->backup = subflow_req->backup;
 		new_ctx->remote_id = subflow_req->remote_id;
 		new_ctx->token = subflow_req->token;
-- 
2.37.2

