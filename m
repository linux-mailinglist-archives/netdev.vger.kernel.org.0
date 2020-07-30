Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5A23377D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgG3RQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730126AbgG3RQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:16:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10DEC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:16:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1C9v-0002wY-Ia; Thu, 30 Jul 2020 19:15:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 07/10] tcp: syncookies: create mptcp request socket for ACK cookies with MPTCP option
Date:   Thu, 30 Jul 2020 19:15:26 +0200
Message-Id: <20200730171529.22582-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730171529.22582-1-fw@strlen.de>
References: <20200730171529.22582-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If SYN packet contains MP_CAPABLE option, keep it enabled.
Syncokie validation and cookie-based socket creation is changed to
instantiate an mptcp request sockets if the ACK contains an MPTCP
connection request.

Rather than extend both cookie_v4/6_check, add a common helper to create
the (mp)tcp request socket.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/tcp.h     |  2 ++
 net/ipv4/syncookies.c | 38 ++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp_input.c  |  3 ---
 net/ipv6/syncookies.c |  5 +----
 4 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 84d524d92d12..4dcd4dd8e075 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -469,6 +469,8 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 int __cookie_v4_check(const struct iphdr *iph, const struct tcphdr *th,
 		      u32 cookie);
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
+struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    struct sock *sk, struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
 
 /* Syncookies use a monotonic timer which increments every 60 seconds.
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9a4f6b16c9bc..54838ee2e8d4 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -276,6 +276,39 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 }
 EXPORT_SYMBOL(cookie_ecn_ok);
 
+struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    struct sock *sk,
+					    struct sk_buff *skb)
+{
+	struct tcp_request_sock *treq;
+	struct request_sock *req;
+
+#ifdef CONFIG_MPTCP
+	if (sk_is_mptcp(sk))
+		ops = &mptcp_subflow_request_sock_ops;
+#endif
+
+	req = inet_reqsk_alloc(ops, sk, false);
+	if (!req)
+		return NULL;
+
+#if IS_ENABLED(CONFIG_MPTCP)
+	treq = tcp_rsk(req);
+	treq->is_mptcp = sk_is_mptcp(sk);
+	if (treq->is_mptcp) {
+		int err = mptcp_subflow_init_cookie_req(req, sk, skb);
+
+		if (err) {
+			reqsk_free(req);
+			return NULL;
+		}
+	}
+#endif
+
+	return req;
+}
+EXPORT_SYMBOL_GPL(cookie_tcp_reqsk_alloc);
+
 /* On input, sk is a listener.
  * Output is listener if incoming packet would not create a child
  *           NULL if memory could not be allocated.
@@ -326,7 +359,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = inet_reqsk_alloc(&tcp_request_sock_ops, sk, false); /* for safety */
+	req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops, sk, skb);
 	if (!req)
 		goto out;
 
@@ -350,9 +383,6 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
 
-	if (IS_ENABLED(CONFIG_MPTCP))
-		treq->is_mptcp = 0;
-
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e7dd9280325d..4382a3fc173b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6700,9 +6700,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	af_ops->init_req(req, sk, skb, want_cookie);
 
-	if (IS_ENABLED(CONFIG_MPTCP) && want_cookie)
-		tcp_rsk(req)->is_mptcp = 0;
-
 	if (security_inet_conn_request(sk, skb, req))
 		goto drop_and_free;
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 13235a012388..e796a64be308 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -170,7 +170,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = inet_reqsk_alloc(&tcp6_request_sock_ops, sk, false);
+	req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops, sk, skb);
 	if (!req)
 		goto out;
 
@@ -178,9 +178,6 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq = tcp_rsk(req);
 	treq->tfo_listener = false;
 
-	if (IS_ENABLED(CONFIG_MPTCP))
-		treq->is_mptcp = 0;
-
 	if (security_inet_conn_request(sk, skb, req))
 		goto out_free;
 
-- 
2.26.2

