Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9EE20AF76
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFZKOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:14:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29918 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726986AbgFZKOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wa0aKUUvIM+MPU6QkT1DFcJOg4Aqlh7NVrsKTcs/T1Q=;
        b=YPc9NV11fKwyvFUqpepg69RmxWHOZgOILpil7A6MfRlTKtzm6WrZroIck9WhCF5p2YN8C4
        DbEr4diBm7hXcF2eVSKj7TIsyAC7MGU4W625OG4b/dclk7SKYUJZRRGFN/Jt9gfNIl9GIL
        K1LiFX1BIT+7/pXzcHseVBwxy8GqoMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-ZLEj4GoNO52cA-j8BbyFVQ-1; Fri, 26 Jun 2020 06:13:57 -0400
X-MC-Unique: ZLEj4GoNO52cA-j8BbyFVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1924518585A5;
        Fri, 26 Jun 2020 10:13:56 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B77D05D9CA;
        Fri, 26 Jun 2020 10:13:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/4] mptcp: refactor token container
Date:   Fri, 26 Jun 2020 12:12:47 +0200
Message-Id: <c135588a2dfaf6d37d4e73ba198dce210c5c1f3f.1593159603.git.pabeni@redhat.com>
In-Reply-To: <cover.1593159603.git.pabeni@redhat.com>
References: <cover.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the radix tree with a hash table allocated
at boot time. The radix tree has some shortcoming:
a single lock is contented by all the mptcp operation,
the lookup currently use such lock, and traversing
all the items would require a lock, too.

With hash table instead we trade a little memory to
address all the above - a per bucket lock is used.

To hash the MPTCP sockets, we re-use the msk' sk_node
entry: the MPTCP sockets are never hashed by the stack.
Replace the existing hash proto callbacks with a dummy
implementation, annotating the above constraint.

Additionally refactor the token creation to code to:

- limit the number of consecutive attempts to a fixed
maximum. Hitting a hash bucket with a long chain is
considered a failed attempt

- accept() no longer can fail to token management.

- if token creation fails at connect() time, we do
fallback to TCP (before the connection was closed)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c |  45 ++++---
 net/mptcp/protocol.h |  14 ++-
 net/mptcp/subflow.c  |  19 ++-
 net/mptcp/token.c    | 271 ++++++++++++++++++++++++++++++-------------
 4 files changed, 236 insertions(+), 113 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9163a05b9e46..be09fd525f8f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1448,20 +1448,6 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
 
-	if (unlikely(mptcp_token_new_accept(subflow_req->token, nsk))) {
-		nsk->sk_state = TCP_CLOSE;
-		bh_unlock_sock(nsk);
-
-		/* we can't call into mptcp_close() here - possible BH context
-		 * free the sock directly.
-		 * sk_clone_lock() sets nsk refcnt to two, hence call sk_free()
-		 * too.
-		 */
-		sk_common_release(nsk);
-		sk_free(nsk);
-		return NULL;
-	}
-
 	msk->write_seq = subflow_req->idsn + 1;
 	atomic64_set(&msk->snd_una, msk->write_seq);
 	if (mp_opt->mp_capable) {
@@ -1547,7 +1533,7 @@ static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	mptcp_token_destroy(msk->token);
+	mptcp_token_destroy(msk);
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
 
@@ -1636,6 +1622,20 @@ static void mptcp_release_cb(struct sock *sk)
 	}
 }
 
+static int mptcp_hash(struct sock *sk)
+{
+	/* should never be called,
+	 * we hash the TCP subflows not the master socket
+	 */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static void mptcp_unhash(struct sock *sk)
+{
+	/* called from sk_common_release(), but nothing to do here */
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1679,7 +1679,6 @@ void mptcp_finish_connect(struct sock *ssk)
 	 */
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->local_key, subflow->local_key);
-	WRITE_ONCE(msk->token, subflow->token);
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
@@ -1761,8 +1760,8 @@ static struct proto mptcp_prot = {
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
 	.release_cb	= mptcp_release_cb,
-	.hash		= inet_hash,
-	.unhash		= inet_unhash,
+	.hash		= mptcp_hash,
+	.unhash		= mptcp_unhash,
 	.get_port	= mptcp_get_port,
 	.sockets_allocated	= &mptcp_sockets_allocated,
 	.memory_allocated	= &tcp_memory_allocated,
@@ -1771,6 +1770,7 @@ static struct proto mptcp_prot = {
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
 	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
+	.slab_flags	= SLAB_TYPESAFE_BY_RCU,
 	.no_autobind	= true,
 };
 
@@ -1800,6 +1800,7 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 				int addr_len, int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct mptcp_subflow_context *subflow;
 	struct socket *ssock;
 	int err;
 
@@ -1812,19 +1813,23 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto do_connect;
 	}
 
+	mptcp_token_destroy(msk);
 	ssock = __mptcp_socket_create(msk, TCP_SYN_SENT);
 	if (IS_ERR(ssock)) {
 		err = PTR_ERR(ssock);
 		goto unlock;
 	}
 
+	subflow = mptcp_subflow_ctx(ssock->sk);
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
 	 * TCP option space.
 	 */
 	if (rcu_access_pointer(tcp_sk(ssock->sk)->md5sig_info))
-		mptcp_subflow_ctx(ssock->sk)->request_mptcp = 0;
+		subflow->request_mptcp = 0;
 #endif
+	if (subflow->request_mptcp && mptcp_token_new_connect(ssock->sk))
+		subflow->request_mptcp = 0;
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
@@ -1888,6 +1893,7 @@ static int mptcp_listen(struct socket *sock, int backlog)
 	pr_debug("msk=%p", msk);
 
 	lock_sock(sock->sk);
+	mptcp_token_destroy(msk);
 	ssock = __mptcp_socket_create(msk, TCP_LISTEN);
 	if (IS_ERR(ssock)) {
 		err = PTR_ERR(ssock);
@@ -2086,6 +2092,7 @@ void __init mptcp_proto_init(void)
 
 	mptcp_subflow_init();
 	mptcp_pm_init();
+	mptcp_token_init();
 
 	if (proto_register(&mptcp_prot, 1) != 0)
 		panic("Failed to register MPTCP proto.\n");
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 571d39a1a17c..c05552e5fa23 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -250,6 +250,7 @@ struct mptcp_subflow_request_sock {
 	u32	local_nonce;
 	u32	remote_nonce;
 	struct mptcp_sock	*msk;
+	struct hlist_nulls_node token_node;
 };
 
 static inline struct mptcp_subflow_request_sock *
@@ -372,12 +373,19 @@ bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 
+void __init mptcp_token_init(void);
+static inline void mptcp_token_init_request(struct request_sock *req)
+{
+	mptcp_subflow_rsk(req)->token_node.pprev = NULL;
+}
+
 int mptcp_token_new_request(struct request_sock *req);
-void mptcp_token_destroy_request(u32 token);
+void mptcp_token_destroy_request(struct request_sock *req);
 int mptcp_token_new_connect(struct sock *sk);
-int mptcp_token_new_accept(u32 token, struct sock *conn);
+void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
+			struct mptcp_sock *msk);
 struct mptcp_sock *mptcp_token_get_sock(u32 token);
-void mptcp_token_destroy(u32 token);
+void mptcp_token_destroy(struct mptcp_sock *msk);
 
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
 static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c2389ba2d4ee..102db8c88e97 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -32,12 +32,9 @@ static void SUBFLOW_REQ_INC_STATS(struct request_sock *req,
 static int subflow_rebuild_header(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	int local_id, err = 0;
+	int local_id;
 
-	if (subflow->request_mptcp && !subflow->token) {
-		pr_debug("subflow=%p", sk);
-		err = mptcp_token_new_connect(sk);
-	} else if (subflow->request_join && !subflow->local_nonce) {
+	if (subflow->request_join && !subflow->local_nonce) {
 		struct mptcp_sock *msk = (struct mptcp_sock *)subflow->conn;
 
 		pr_debug("subflow=%p", sk);
@@ -57,9 +54,6 @@ static int subflow_rebuild_header(struct sock *sk)
 	}
 
 out:
-	if (err)
-		return err;
-
 	return subflow->icsk_af_ops->rebuild_header(sk);
 }
 
@@ -72,8 +66,7 @@ static void subflow_req_destructor(struct request_sock *req)
 	if (subflow_req->msk)
 		sock_put((struct sock *)subflow_req->msk);
 
-	if (subflow_req->mp_capable)
-		mptcp_token_destroy_request(subflow_req->token);
+	mptcp_token_destroy_request(req);
 	tcp_request_sock_ops.destructor(req);
 }
 
@@ -135,6 +128,7 @@ static void subflow_init_req(struct request_sock *req,
 	subflow_req->mp_capable = 0;
 	subflow_req->mp_join = 0;
 	subflow_req->msk = NULL;
+	mptcp_token_init_request(req);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -250,7 +244,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		subflow->remote_nonce = mp_opt.nonce;
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u", subflow,
 			 subflow->thmac, subflow->remote_nonce);
-	} else if (subflow->request_mptcp) {
+	} else {
 		tp->is_mptcp = 0;
 	}
 
@@ -386,7 +380,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
-	mptcp_token_destroy(mptcp_sk(sk)->token);
+	mptcp_token_destroy(mptcp_sk(sk));
 	inet_sock_destruct(sk);
 }
 
@@ -505,6 +499,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 */
 			new_msk->sk_destruct = mptcp_sock_destruct;
 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
+			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 33352dd99d4d..9c0771774815 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -24,7 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/radix-tree.h>
+#include <linux/memblock.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <net/sock.h>
@@ -33,10 +33,55 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
-static RADIX_TREE(token_tree, GFP_ATOMIC);
-static RADIX_TREE(token_req_tree, GFP_ATOMIC);
-static DEFINE_SPINLOCK(token_tree_lock);
-static int token_used __read_mostly;
+#define TOKEN_MAX_RETRIES	4
+#define TOKEN_MAX_CHAIN_LEN	4
+
+struct token_bucket {
+	spinlock_t		lock;
+	int			chain_len;
+	struct hlist_nulls_head	req_chain;
+	struct hlist_nulls_head	msk_chain;
+};
+
+static struct token_bucket *token_hash __read_mostly;
+static unsigned int token_mask __read_mostly;
+
+static struct token_bucket *token_bucket(u32 token)
+{
+	return &token_hash[token & token_mask];
+}
+
+/* called with bucket lock held */
+static struct mptcp_subflow_request_sock *
+__token_lookup_req(struct token_bucket *t, u32 token)
+{
+	struct mptcp_subflow_request_sock *req;
+	struct hlist_nulls_node *pos;
+
+	hlist_nulls_for_each_entry_rcu(req, pos, &t->req_chain, token_node)
+		if (req->token == token)
+			return req;
+	return NULL;
+}
+
+/* called with bucket lock held */
+static struct mptcp_sock *
+__token_lookup_msk(struct token_bucket *t, u32 token)
+{
+	struct hlist_nulls_node *pos;
+	struct sock *sk;
+
+	sk_nulls_for_each_rcu(sk, pos, &t->msk_chain)
+		if (mptcp_sk(sk)->token == token)
+			return mptcp_sk(sk);
+	return NULL;
+}
+
+static bool __token_bucket_busy(struct token_bucket *t, u32 token)
+{
+	return !token || t->chain_len >= TOKEN_MAX_CHAIN_LEN ||
+	       __token_lookup_req(t, token) || __token_lookup_msk(t, token);
+}
 
 /**
  * mptcp_token_new_request - create new key/idsn/token for subflow_request
@@ -52,30 +97,32 @@ static int token_used __read_mostly;
 int mptcp_token_new_request(struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
-	int err;
-
-	while (1) {
-		u32 token;
-
-		mptcp_crypto_key_gen_sha(&subflow_req->local_key,
-					 &subflow_req->token,
-					 &subflow_req->idsn);
-		pr_debug("req=%p local_key=%llu, token=%u, idsn=%llu\n",
-			 req, subflow_req->local_key, subflow_req->token,
-			 subflow_req->idsn);
-
-		token = subflow_req->token;
-		spin_lock_bh(&token_tree_lock);
-		if (!radix_tree_lookup(&token_req_tree, token) &&
-		    !radix_tree_lookup(&token_tree, token))
-			break;
-		spin_unlock_bh(&token_tree_lock);
+	int retries = TOKEN_MAX_RETRIES;
+	struct token_bucket *bucket;
+	u32 token;
+
+again:
+	mptcp_crypto_key_gen_sha(&subflow_req->local_key,
+				 &subflow_req->token,
+				 &subflow_req->idsn);
+	pr_debug("req=%p local_key=%llu, token=%u, idsn=%llu\n",
+		 req, subflow_req->local_key, subflow_req->token,
+		 subflow_req->idsn);
+
+	token = subflow_req->token;
+	bucket = token_bucket(token);
+	spin_lock_bh(&bucket->lock);
+	if (__token_bucket_busy(bucket, token)) {
+		spin_unlock_bh(&bucket->lock);
+		if (!--retries)
+			return -EBUSY;
+		goto again;
 	}
 
-	err = radix_tree_insert(&token_req_tree,
-				subflow_req->token, &token_used);
-	spin_unlock_bh(&token_tree_lock);
-	return err;
+	hlist_nulls_add_head_rcu(&subflow_req->token_node, &bucket->req_chain);
+	bucket->chain_len++;
+	spin_unlock_bh(&bucket->lock);
+	return 0;
 }
 
 /**
@@ -97,48 +144,56 @@ int mptcp_token_new_request(struct request_sock *req)
 int mptcp_token_new_connect(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	struct sock *mptcp_sock = subflow->conn;
-	int err;
-
-	while (1) {
-		u32 token;
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	int retries = TOKEN_MAX_RETRIES;
+	struct token_bucket *bucket;
 
-		mptcp_crypto_key_gen_sha(&subflow->local_key, &subflow->token,
-					 &subflow->idsn);
+	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
+		 sk, subflow->local_key, subflow->token, subflow->idsn);
 
-		pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
-			 sk, subflow->local_key, subflow->token, subflow->idsn);
+again:
+	mptcp_crypto_key_gen_sha(&subflow->local_key, &subflow->token,
+				 &subflow->idsn);
 
-		token = subflow->token;
-		spin_lock_bh(&token_tree_lock);
-		if (!radix_tree_lookup(&token_req_tree, token) &&
-		    !radix_tree_lookup(&token_tree, token))
-			break;
-		spin_unlock_bh(&token_tree_lock);
+	bucket = token_bucket(subflow->token);
+	spin_lock_bh(&bucket->lock);
+	if (__token_bucket_busy(bucket, subflow->token)) {
+		spin_unlock_bh(&bucket->lock);
+		if (!--retries)
+			return -EBUSY;
+		goto again;
 	}
-	err = radix_tree_insert(&token_tree, subflow->token, mptcp_sock);
-	spin_unlock_bh(&token_tree_lock);
 
-	return err;
+	WRITE_ONCE(msk->token, subflow->token);
+	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
+	bucket->chain_len++;
+	spin_unlock_bh(&bucket->lock);
+	return 0;
 }
 
 /**
- * mptcp_token_new_accept - insert token for later processing
- * @token: the token to insert to the tree
- * @conn: the just cloned socket linked to the new connection
+ * mptcp_token_accept - replace a req sk with full sock in token hash
+ * @req: the request socket to be removed
+ * @msk: the just cloned socket linked to the new connection
  *
  * Called when a SYN packet creates a new logical connection, i.e.
  * is not a join request.
  */
-int mptcp_token_new_accept(u32 token, struct sock *conn)
+void mptcp_token_accept(struct mptcp_subflow_request_sock *req,
+			struct mptcp_sock *msk)
 {
-	int err;
+	struct mptcp_subflow_request_sock *pos;
+	struct token_bucket *bucket;
 
-	spin_lock_bh(&token_tree_lock);
-	err = radix_tree_insert(&token_tree, token, conn);
-	spin_unlock_bh(&token_tree_lock);
+	bucket = token_bucket(req->token);
+	spin_lock_bh(&bucket->lock);
 
-	return err;
+	/* pedantic lookup check for the moved token */
+	pos = __token_lookup_req(bucket, req->token);
+	if (!WARN_ON_ONCE(pos != req))
+		hlist_nulls_del_init_rcu(&req->token_node);
+	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
+	spin_unlock_bh(&bucket->lock);
 }
 
 /**
@@ -152,45 +207,103 @@ int mptcp_token_new_accept(u32 token, struct sock *conn)
  */
 struct mptcp_sock *mptcp_token_get_sock(u32 token)
 {
-	struct sock *conn;
-
-	spin_lock_bh(&token_tree_lock);
-	conn = radix_tree_lookup(&token_tree, token);
-	if (conn) {
-		/* token still reserved? */
-		if (conn == (struct sock *)&token_used)
-			conn = NULL;
-		else
-			sock_hold(conn);
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
+		if (READ_ONCE(msk->token) != token)
+			continue;
+		if (!refcount_inc_not_zero(&sk->sk_refcnt))
+			goto not_found;
+		if (READ_ONCE(msk->token) != token) {
+			sock_put(sk);
+			goto again;
+		}
+		goto found;
 	}
-	spin_unlock_bh(&token_tree_lock);
+	if (get_nulls_value(pos) != (token & token_mask))
+		goto again;
+
+not_found:
+	msk = NULL;
 
-	return mptcp_sk(conn);
+found:
+	rcu_read_unlock();
+	return msk;
 }
 
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
- * @token: token of mptcp connection to remove
+ * @req: mptcp request socket dropping the token
  *
- * Remove not-yet-fully-established incoming connection identified
- * by @token.
+ * Remove the token associated to @req.
  */
-void mptcp_token_destroy_request(u32 token)
+void mptcp_token_destroy_request(struct request_sock *req)
 {
-	spin_lock_bh(&token_tree_lock);
-	radix_tree_delete(&token_req_tree, token);
-	spin_unlock_bh(&token_tree_lock);
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_subflow_request_sock *pos;
+	struct token_bucket *bucket;
+
+	if (hlist_nulls_unhashed(&subflow_req->token_node))
+		return;
+
+	bucket = token_bucket(subflow_req->token);
+	spin_lock_bh(&bucket->lock);
+	pos = __token_lookup_req(bucket, subflow_req->token);
+	if (!WARN_ON_ONCE(pos != subflow_req)) {
+		hlist_nulls_del_init_rcu(&pos->token_node);
+		bucket->chain_len--;
+	}
+	spin_unlock_bh(&bucket->lock);
 }
 
 /**
  * mptcp_token_destroy - remove mptcp connection/token
- * @token: token of mptcp connection to remove
+ * @msk: mptcp connection dropping the token
  *
- * Remove the connection identified by @token.
+ * Remove the token associated to @msk
  */
-void mptcp_token_destroy(u32 token)
+void mptcp_token_destroy(struct mptcp_sock *msk)
 {
-	spin_lock_bh(&token_tree_lock);
-	radix_tree_delete(&token_tree, token);
-	spin_unlock_bh(&token_tree_lock);
+	struct token_bucket *bucket;
+	struct mptcp_sock *pos;
+
+	if (sk_unhashed((struct sock *)msk))
+		return;
+
+	bucket = token_bucket(msk->token);
+	spin_lock_bh(&bucket->lock);
+	pos = __token_lookup_msk(bucket, msk->token);
+	if (!WARN_ON_ONCE(pos != msk)) {
+		__sk_nulls_del_node_init_rcu((struct sock *)pos);
+		bucket->chain_len--;
+	}
+	spin_unlock_bh(&bucket->lock);
+}
+
+void __init mptcp_token_init(void)
+{
+	int i;
+
+	token_hash = alloc_large_system_hash("MPTCP token",
+					     sizeof(struct token_bucket),
+					     0,
+					     20,/* one slot per 1MB of memory */
+					     0,
+					     NULL,
+					     &token_mask,
+					     0,
+					     64 * 1024);
+	for (i = 0; i < token_mask + 1; ++i) {
+		INIT_HLIST_NULLS_HEAD(&token_hash[i].req_chain, i);
+		INIT_HLIST_NULLS_HEAD(&token_hash[i].msk_chain, i);
+		spin_lock_init(&token_hash[i].lock);
+	}
 }
-- 
2.26.2

