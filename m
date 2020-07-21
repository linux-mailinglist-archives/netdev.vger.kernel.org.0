Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FA0228A0A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgGUUhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgGUUha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61A6C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0z-0003wo-7L; Tue, 21 Jul 2020 22:37:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 08/12] mptcp: subflow: add mptcp_subflow_init_cookie_req helper
Date:   Tue, 21 Jul 2020 22:36:38 +0200
Message-Id: <20200721203642.32753-9-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will be used to initialize the mptcp request socket when a MP_CAPABLE
request was handled in syncookie mode, i.e. when a TCP ACK containing a
MP_CAPABLE option is a valid syncookie value.

Normally (non-cookie case), MPTCP will generate a 32 bit connection
ID and stores it in the MPTCP token storage to be able to retrieve the
mptcp socket for JOIN requests.

In syncookie case, we do not want to store any state, so just generate the
unique ID and use it in the reply.

This means there is a small window where another connection could generate
the same token.

When Cookie ACK comes back, we check that the token has not been registered
in the mean time.  If it was, the connection needs to fall back to TCP.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/mptcp.h  | 10 ++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 55 +++++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/token.c    | 26 +++++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 76eb915bf91c..3525d2822abe 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -131,6 +131,9 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 }
 
 void mptcp_seq_show(struct seq_file *seq);
+int mptcp_subflow_init_cookie_req(struct request_sock *req,
+				  const struct sock *sk_listener,
+				  struct sk_buff *skb);
 #else
 
 static inline void mptcp_init(void)
@@ -200,6 +203,13 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 
 static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
 static inline void mptcp_seq_show(struct seq_file *seq) { }
+
+static inline int mptcp_subflow_init_cookie_req(struct request_sock *req,
+						const struct sock *sk_listener,
+						struct sk_buff *skb)
+{
+	return 0; /* TCP fallback */
+}
 #endif /* CONFIG_MPTCP */
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index cf74305c1d42..0ed402cdb9fd 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -392,6 +392,7 @@ void mptcp_token_destroy_request(struct request_sock *req);
 int mptcp_token_new_connect(struct sock *sk);
 void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
 			struct mptcp_sock *msk);
+bool mptcp_token_exists(u32 token);
 struct mptcp_sock *mptcp_token_get_sock(u32 token);
 struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 					 long *s_num);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 023e9f435d1b..0761c35268ce 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -150,18 +150,31 @@ static void subflow_init_req(struct request_sock *req,
 	if (mp_opt.mp_capable && listener->request_mptcp) {
 		int err, retries = 4;
 
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 again:
 		do {
 			get_random_bytes(&subflow_req->local_key, sizeof(subflow_req->local_key));
 		} while (subflow_req->local_key == 0);
 
+		if (unlikely(want_cookie)) {
+			mptcp_crypto_key_sha(subflow_req->local_key,
+					     &subflow_req->token,
+					     &subflow_req->idsn);
+			if (mptcp_token_exists(subflow_req->token)) {
+				if (retries-- > 0)
+					goto again;
+			} else {
+				subflow_req->mp_capable = 1;
+			}
+			return;
+		}
+
 		err = mptcp_token_new_request(req);
 		if (err == 0)
 			subflow_req->mp_capable = 1;
 		else if (retries-- > 0)
 			goto again;
 
-		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	} else if (mp_opt.mp_join && listener->request_mptcp) {
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 		subflow_req->mp_join = 1;
@@ -175,6 +188,46 @@ static void subflow_init_req(struct request_sock *req,
 	}
 }
 
+int mptcp_subflow_init_cookie_req(struct request_sock *req,
+				  const struct sock *sk_listener,
+				  struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_options_received mp_opt;
+	int ret;
+
+	ret = __subflow_init_req(req, sk_listener);
+	if (ret)
+		return ret;
+
+	mptcp_get_options(skb, &mp_opt);
+	ret = __subflow_check_options(&mp_opt, req);
+	if (ret)
+		return ret;
+
+	if (mp_opt.mp_capable && listener->request_mptcp) {
+		int err;
+
+		if (mp_opt.sndr_key == 0)
+			return -EINVAL;
+
+		subflow_req->local_key = mp_opt.rcvr_key;
+		err = mptcp_token_new_request(req);
+		if (err)
+			return err;
+
+		subflow_req->mp_capable = 1;
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq - 1;
+	}
+	/* JOIN cannot be handled via cookies due to need
+	 * to store the remote peer nonce value.
+	 */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mptcp_subflow_init_cookie_req);
+
 static void subflow_v4_init_req(struct request_sock *req,
 				struct sock *sk_listener,
 				struct sk_buff *skb,
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index f82410c54653..8b47c4bb1c6b 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -204,6 +204,32 @@ void mptcp_token_accept(struct mptcp_subflow_request_sock *req,
 	spin_unlock_bh(&bucket->lock);
 }
 
+bool mptcp_token_exists(u32 token)
+{
+	struct hlist_nulls_node *pos;
+	struct token_bucket *bucket;
+	struct mptcp_sock *msk;
+	struct sock *sk;
+
+	rcu_read_lock();
+	bucket = token_bucket(token);
+
+again:
+	sk_nulls_for_each_rcu(sk, pos, &bucket->msk_chain) {
+		msk = mptcp_sk(sk);
+		if (READ_ONCE(msk->token) == token)
+			goto found;
+	}
+	if (get_nulls_value(pos) != (token & token_mask))
+		goto again;
+
+	rcu_read_unlock();
+	return false;
+found:
+	rcu_read_unlock();
+	return true;
+}
+
 /**
  * mptcp_token_get_sock - retrieve mptcp connection sock using its token
  * @token: token of the mptcp connection to retrieve
-- 
2.26.2

