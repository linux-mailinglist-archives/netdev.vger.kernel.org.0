Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6722C639168
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiKYWal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKYWai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:38 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161CC57B7C
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:28 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so13094098ejc.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwbiTPzS3ycYqcRTF5ns89gbcE3hlofTchYdWSdIHzs=;
        b=dr2wjAd4gkwx+qYAtXISU4a8RG6hRFOYZoFmqFNU6SaL98Blbwc7dc0T5r169CVAVo
         SJjt4RdA2bP92GkTgHeNLWQdCy6d7nnesUwT/kvtdx47MWUUhTqRXOd8Ndvtg/z+dD+V
         38Mm11HKR1Do/MM3zAGeyldzbGwqI+dGLmQWyl6+Su7Y1SMXcTgZSNydfInI9watehPJ
         Dc1kVCZ9YdLEiEcO5IAui8rojV+A/uR/P0ur3YOIm6rPSXWDzJue77p5Kn7jKG6hKENg
         pmCcZ77YRLYLtIbxwqqHgp/JbGbn08ceEljjUqVC9SwoK72sdSpnVwlS0yhZuMeCBtx2
         O3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CwbiTPzS3ycYqcRTF5ns89gbcE3hlofTchYdWSdIHzs=;
        b=4lI5NFqVPQ6nctTY81vKcID6NohL4n+UgQ2tHZjNDiaoRvin5VONJDP22rQNlf4y7d
         E3qtQDh1msAM+l7ZEQ3XewdNQ5cmE09fwzA3BjymPJZmQ6zl+yuqq/Jsb/SDlR5yvpRQ
         YWWcAiRXtenY2YHRFHiWcoxYf9iAKLOeu/rVqq25c+r+VOgm+ly9Z7bMYOSwp4z1NRy5
         4z8UkPx9p7sv8TWmq+L/Hhq4hI7kMRNsNFSOOHn1MFjqriZAplXNH7IRsfo9zcg/oLsI
         3vcimSFmvkmLwEy3BE417Qg/PKprmqekGv7IfIIdiMFPdSOH8VJR4MksEITubpNLkMf6
         Qvtw==
X-Gm-Message-State: ANoB5pmXiwIIrS9AwhA1fM8P1YItczZ4g0YjxzgdjP564RgId84tYCXJ
        kTByMpqkpRe5qyG1TSRdPpvPIQ==
X-Google-Smtp-Source: AA0mqf6dyRoOdAkR+zoZX69TK0eUYnxixybCsZ9GP/ZO9X9VHXM4969+qWF95fpAvmngT8LQvj7OQA==
X-Received: by 2002:a17:906:7f05:b0:7af:a2d4:e95c with SMTP id d5-20020a1709067f0500b007afa2d4e95cmr34927417ejr.666.1669415427505;
        Fri, 25 Nov 2022 14:30:27 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:27 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] mptcp: add subflow_v(4,6)_send_synack()
Date:   Fri, 25 Nov 2022 23:29:51 +0100
Message-Id: <20221125222958.958636-6-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6996; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=fdHE6VR0e50V3X4U9+VV9KhWPpVVAiIAwbBlfqLVJp8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHP3MXt3FbPPsm+gevtwbsKKSJstEFM/rU6ZzUm
 6Tmo8giJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgcwbMEA
 DLIGqNOZL8Z7PBRtg5eTSLam0r2PV8s8wx7018znKHUSypysd7eiiM/YVsRPayrkWCfXcfDO32CHVz
 7xNqxpkoP8CWcEY0tQHUHJfz9qfApswpBmmng1IcC9Rr0o5xt3cx4YXi33c/dcdo98h3bMNusIp0gc
 reIUux4e04ciaF6nm0NGsAoXkb6kZ8pLw7ouaWuuS8xT9n3fEQOPNEKlZua3It02ltFswIBH1nqYkz
 ljvPTcwun77le5LjTma922mtesD5SVtoZsZxcP/aB2hJ5HvCF2++/sph1GdKHSpFB3HKdHjp9UfRTf
 q8S1GObmWvuwOt1gNgcB+bq7sSJdXEZgZVVakmxYFHsCYMOZ6ESTA4WycMUrENU0wqoL6RyDH1gber
 c3y6+F62/xiDujNdkFT/qvhF3bZRT4upioYyT8F3WvchTSqZCTYd1vVr0jP1qT94b2JJFZLAko8Jri
 h3vL5uFV88iF2NEB632PwyojhD57wljYrBw57Sf+FCw9Z8/brn+euXG+FGrjulprQUscXPBo5S81V3
 uiX8NcBSrXpKdNmw+3/hQNYOgxqZEIBChwevVgc0c1iSX0+W65x5wx712wBScYGWHeZ53t7VTCOGEM
 I4fb/1bCES0swP3NBLtiFcb6J6NcTXfNlbNhcmu0aFdeeqbQIcvy5KdMIl+w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

The send_synack() needs to be overridden for MPTCP to support TFO for
two reasons:

- There is not be enough space in the TCP options if the TFO cookie has
  to be added in the SYN+ACK with other options: MSS (4), SACK OK (2),
  Timestamps (10), Window Scale (3+1), TFO (10+2), MP_CAPABLE (12).
  MPTCPv1 specs -- RFC 8684, section B.1 [1] -- suggest to drop the TCP
  timestamps option in this case.

- The data received in the SYN has to be handled: the SKB can be
  dequeued from the subflow sk and transferred to the MPTCP sk. Counters
  need to be updated accordingly and the application can be notified at
  the end because some bytes have been received.

[1] https://www.rfc-editor.org/rfc/rfc8684.html#section-b.1

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/fastopen.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  2 +-
 net/mptcp/protocol.h |  3 +++
 net/mptcp/subflow.c  | 43 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/fastopen.c b/net/mptcp/fastopen.c
index 19c332af0834..d237d142171c 100644
--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -6,6 +6,51 @@
 
 #include "protocol.h"
 
+void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subflow,
+					      struct request_sock *req)
+{
+	struct sock *ssk = subflow->tcp_sock;
+	struct sock *sk = subflow->conn;
+	struct sk_buff *skb;
+	struct tcp_sock *tp;
+
+	tp = tcp_sk(ssk);
+
+	subflow->is_mptfo = 1;
+
+	skb = skb_peek(&ssk->sk_receive_queue);
+	if (WARN_ON_ONCE(!skb))
+		return;
+
+	/* dequeue the skb from sk receive queue */
+	__skb_unlink(skb, &ssk->sk_receive_queue);
+	skb_ext_reset(skb);
+	skb_orphan(skb);
+
+	/* We copy the fastopen data, but that don't belong to the mptcp sequence
+	 * space, need to offset it in the subflow sequence, see mptcp_subflow_get_map_offset()
+	 */
+	tp->copied_seq += skb->len;
+	subflow->ssn_offset += skb->len;
+
+	/* initialize a dummy sequence number, we will update it at MPC
+	 * completion, if needed
+	 */
+	MPTCP_SKB_CB(skb)->map_seq = -skb->len;
+	MPTCP_SKB_CB(skb)->end_seq = 0;
+	MPTCP_SKB_CB(skb)->offset = 0;
+	MPTCP_SKB_CB(skb)->has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
+
+	mptcp_data_lock(sk);
+
+	mptcp_set_owner_r(skb, sk);
+	__skb_queue_tail(&sk->sk_receive_queue, skb);
+
+	sk->sk_data_ready(sk);
+
+	mptcp_data_unlock(sk);
+}
+
 void mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
 				   const struct mptcp_options_received *mp_opt)
 {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a12ee763e52c..cd9ad6e461b1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -191,7 +191,7 @@ static void mptcp_rfree(struct sk_buff *skb)
 	mptcp_rmem_uncharge(sk, len);
 }
 
-static void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk)
+void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk)
 {
 	skb_orphan(skb);
 	skb->sk = sk;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 618ac85abaaf..8b4379a2cd85 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -633,6 +633,7 @@ void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
 void mptcp_cancel_work(struct sock *sk);
+void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);
@@ -842,6 +843,8 @@ bool mptcp_userspace_pm_active(const struct mptcp_sock *msk);
 
 void mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
 				   const struct mptcp_options_received *mp_opt);
+void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subflow,
+					      struct request_sock *req);
 
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 21cf26edb79a..fb3361f4b1e5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -307,7 +307,48 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	return NULL;
 }
 
+static void subflow_prep_synack(const struct sock *sk, struct request_sock *req,
+				struct tcp_fastopen_cookie *foc,
+				enum tcp_synack_type synack_type)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+	/* clear tstamp_ok, as needed depending on cookie */
+	if (foc && foc->len > -1)
+		ireq->tstamp_ok = 0;
+
+	if (synack_type == TCP_SYNACK_FASTOPEN)
+		mptcp_fastopen_subflow_synack_set_params(subflow, req);
+}
+
+static int subflow_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
+				  struct flowi *fl,
+				  struct request_sock *req,
+				  struct tcp_fastopen_cookie *foc,
+				  enum tcp_synack_type synack_type,
+				  struct sk_buff *syn_skb)
+{
+	subflow_prep_synack(sk, req, foc, synack_type);
+
+	return tcp_request_sock_ipv4_ops.send_synack(sk, dst, fl, req, foc,
+						     synack_type, syn_skb);
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static int subflow_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
+				  struct flowi *fl,
+				  struct request_sock *req,
+				  struct tcp_fastopen_cookie *foc,
+				  enum tcp_synack_type synack_type,
+				  struct sk_buff *syn_skb)
+{
+	subflow_prep_synack(sk, req, foc, synack_type);
+
+	return tcp_request_sock_ipv6_ops.send_synack(sk, dst, fl, req, foc,
+						     synack_type, syn_skb);
+}
+
 static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 					      struct sk_buff *skb,
 					      struct flowi *fl,
@@ -1945,6 +1986,7 @@ void __init mptcp_subflow_init(void)
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
 	subflow_request_sock_ipv4_ops.route_req = subflow_v4_route_req;
+	subflow_request_sock_ipv4_ops.send_synack = subflow_v4_send_synack;
 
 	subflow_specific = ipv4_specific;
 	subflow_specific.conn_request = subflow_v4_conn_request;
@@ -1958,6 +2000,7 @@ void __init mptcp_subflow_init(void)
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
 	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
+	subflow_request_sock_ipv6_ops.send_synack = subflow_v6_send_synack;
 
 	subflow_v6_specific = ipv6_specific;
 	subflow_v6_specific.conn_request = subflow_v6_conn_request;
-- 
2.37.2

