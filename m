Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58238F002
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfHOQC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfHOQC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 12:02:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 010D789C39;
        Thu, 15 Aug 2019 16:02:58 +0000 (UTC)
Received: from mob-31-157-107-94.net.vodafone.it.com (ovpn-204-48.brq.redhat.com [10.40.204.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A17876266B;
        Thu, 15 Aug 2019 16:02:55 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net/tls: use RCU protection on icsk->icsk_ulp_data
Date:   Thu, 15 Aug 2019 18:00:42 +0200
Message-Id: <b7c351a5ad6c756129d036fd87db6b4edcd3cb6a.1565882584.git.dcaratti@redhat.com>
In-Reply-To: <cover.1565882584.git.dcaratti@redhat.com>
References: <cover.1565882584.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 15 Aug 2019 16:02:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

We need to make sure context does not get freed while diag
code is interrogating it. Free struct tls_context with
kfree_rcu().

We add the __rcu annotation directly in icsk, and cast it
away in the datapath accessor. Presumably all ULPs will
do a similar thing.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/inet_connection_sock.h |  2 +-
 include/net/tls.h                  |  9 +++++++--
 net/core/sock_map.c                |  2 +-
 net/tls/tls_device.c               |  2 +-
 net/tls/tls_main.c                 | 31 +++++++++++++++++++++++-------
 5 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c57d53e7e02c..895546058a20 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -97,7 +97,7 @@ struct inet_connection_sock {
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
-	void			  *icsk_ulp_data;
+	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
 	struct hlist_node         icsk_listen_portaddr_node;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
diff --git a/include/net/tls.h b/include/net/tls.h
index 41b2d41bb1b8..4997742475cd 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -41,6 +41,7 @@
 #include <linux/tcp.h>
 #include <linux/skmsg.h>
 #include <linux/netdevice.h>
+#include <linux/rcupdate.h>
 
 #include <net/tcp.h>
 #include <net/strparser.h>
@@ -290,6 +291,7 @@ struct tls_context {
 
 	struct list_head list;
 	refcount_t refcount;
+	struct rcu_head rcu;
 };
 
 enum tls_offload_ctx_dir {
@@ -348,7 +350,7 @@ struct tls_offload_context_rx {
 #define TLS_OFFLOAD_CONTEXT_SIZE_RX					\
 	(sizeof(struct tls_offload_context_rx) + TLS_DRIVER_STATE_SIZE_RX)
 
-void tls_ctx_free(struct tls_context *ctx);
+void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
@@ -467,7 +469,10 @@ static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	return icsk->icsk_ulp_data;
+	/* Use RCU on icsk_ulp_data only for sock diag code,
+	 * TLS data path doesn't need rcu_dereference().
+	 */
+	return (__force void *)icsk->icsk_ulp_data;
 }
 
 static inline void tls_advance_record_sn(struct sock *sk,
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1330a7442e5b..01998860afaa 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -345,7 +345,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
-	if (unlikely(icsk->icsk_ulp_data))
+	if (unlikely(rcu_access_pointer(icsk->icsk_ulp_data)))
 		return -EINVAL;
 
 	link = sk_psock_init_link();
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index d184230665eb..436df5b4bb60 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -61,7 +61,7 @@ static void tls_device_free_ctx(struct tls_context *ctx)
 	if (ctx->rx_conf == TLS_HW)
 		kfree(tls_offload_ctx_rx(ctx));
 
-	tls_ctx_free(ctx);
+	tls_ctx_free(NULL, ctx);
 }
 
 static void tls_device_gc_task(struct work_struct *work)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9cbbae606ced..04829bef514c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,14 +251,31 @@ static void tls_write_space(struct sock *sk)
 	ctx->sk_write_space(sk);
 }
 
-void tls_ctx_free(struct tls_context *ctx)
+/**
+ * tls_ctx_free() - free TLS ULP context
+ * @sk:  socket to with @ctx is attached
+ * @ctx: TLS context structure
+ *
+ * Free TLS context. If @sk is %NULL caller guarantees that the socket
+ * to which @ctx was attached has no outstanding references.
+ */
+void tls_ctx_free(struct sock *sk, struct tls_context *ctx)
 {
+	struct inet_connection_sock *icsk;
+
 	if (!ctx)
 		return;
 
 	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
 	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
-	kfree(ctx);
+
+	if (sk) {
+		icsk = inet_csk(sk);
+		rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
+		kfree_rcu(ctx, rcu);
+	} else {
+		kfree(ctx);
+	}
 }
 
 static void tls_sk_proto_cleanup(struct sock *sk,
@@ -306,7 +323,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (free_ctx)
-		icsk->icsk_ulp_data = NULL;
+		rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
 	sk->sk_prot = ctx->sk_proto;
 	write_unlock_bh(&sk->sk_callback_lock);
 	release_sock(sk);
@@ -319,7 +336,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	ctx->sk_proto_close(sk, timeout);
 
 	if (free_ctx)
-		tls_ctx_free(ctx);
+		tls_ctx_free(sk, ctx);
 }
 
 static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
@@ -608,7 +625,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 	if (!ctx)
 		return NULL;
 
-	icsk->icsk_ulp_data = ctx;
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
@@ -649,8 +666,8 @@ static void tls_hw_sk_destruct(struct sock *sk)
 
 	ctx->sk_destruct(sk);
 	/* Free ctx */
-	tls_ctx_free(ctx);
-	icsk->icsk_ulp_data = NULL;
+	tls_ctx_free(sk, ctx);
+	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
 }
 
 static int tls_hw_prot(struct sock *sk)
-- 
2.20.1

