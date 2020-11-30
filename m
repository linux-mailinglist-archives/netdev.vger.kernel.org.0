Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590CB2C8832
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgK3Phf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728106AbgK3Phe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:37:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4180C0613D3;
        Mon, 30 Nov 2020 07:36:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kjlER-0001zr-Dm; Mon, 30 Nov 2020 16:36:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mptcp@lists.01.org, linux-security-module@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/3] tcp: merge 'init_req' and 'route_req' functions
Date:   Mon, 30 Nov 2020 16:36:30 +0100
Message-Id: <20201130153631.21872-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130153631.21872-1-fw@strlen.de>
References: <20201130153631.21872-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Multipath-TCP standard (RFC 8684) says that an MPTCP host should send
a TCP reset if the token in a MP_JOIN request is unknown.

At this time we don't do this, the 3whs completes and the 'new subflow'
is reset afterwards.  There are two ways to allow MPTCP to send the
reset.

1. override 'send_synack' callback and emit the rst from there.
   The drawback is that the request socket gets inserted into the
   listeners queue just to get removed again right away.

2. Send the reset from the 'route_req' function instead.
   This avoids the 'add&remove request socket', but route_req lacks the
   skb that is required to send the TCP reset.

Instead of just adding the skb to that function for MPTCP sake alone,
Paolo suggested to merge init_req and route_req functions.

This saves one indirection from syn processing path and provides the skb
to the merged function at the same time.

'send reset on unknown mptcp join token' is added in next patch.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/tcp.h    |  9 ++++-----
 net/ipv4/tcp_input.c |  9 ++-------
 net/ipv4/tcp_ipv4.c  |  9 +++++++--
 net/ipv6/tcp_ipv6.c  |  9 +++++++--
 net/mptcp/subflow.c  | 36 ++++++++++++++++++++++++------------
 5 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d5d22c411918..4525d6256321 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2007,15 +2007,14 @@ struct tcp_request_sock_ops {
 					  const struct sock *sk,
 					  const struct sk_buff *skb);
 #endif
-	void (*init_req)(struct request_sock *req,
-			 const struct sock *sk_listener,
-			 struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
 				 __u16 *mss);
 #endif
-	struct dst_entry *(*route_req)(const struct sock *sk, struct flowi *fl,
-				       const struct request_sock *req);
+	struct dst_entry *(*route_req)(const struct sock *sk,
+				       struct sk_buff *skb,
+				       struct flowi *fl,
+				       struct request_sock *req);
 	u32 (*init_seq)(const struct sk_buff *skb);
 	u32 (*init_ts_off)(const struct net *net, const struct sk_buff *skb);
 	int (*send_synack)(const struct sock *sk, struct dst_entry *dst,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index fb3a7750f623..9e8a6c1aa019 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6799,18 +6799,13 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	af_ops->init_req(req, sk, skb);
-
-	if (security_inet_conn_request(sk, skb, req))
+	dst = af_ops->route_req(sk, skb, &fl, req);
+	if (!dst)
 		goto drop_and_free;
 
 	if (tmp_opt.tstamp_ok)
 		tcp_rsk(req)->ts_off = af_ops->init_ts_off(net, skb);
 
-	dst = af_ops->route_req(sk, &fl, req);
-	if (!dst)
-		goto drop_and_free;
-
 	if (!want_cookie && !isn) {
 		/* Kill the following clause, if you dislike this way. */
 		if (!net->ipv4.sysctl_tcp_syncookies &&
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e4b31e70bd30..af2338294598 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1444,9 +1444,15 @@ static void tcp_v4_init_req(struct request_sock *req,
 }
 
 static struct dst_entry *tcp_v4_route_req(const struct sock *sk,
+					  struct sk_buff *skb,
 					  struct flowi *fl,
-					  const struct request_sock *req)
+					  struct request_sock *req)
 {
+	tcp_v4_init_req(req, sk, skb);
+
+	if (security_inet_conn_request(sk, skb, req))
+		return NULL;
+
 	return inet_csk_route_req(sk, &fl->u.ip4, req);
 }
 
@@ -1466,7 +1472,6 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 #endif
-	.init_req	=	tcp_v4_init_req,
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 992cbf3eb9e3..1a1510513739 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -828,9 +828,15 @@ static void tcp_v6_init_req(struct request_sock *req,
 }
 
 static struct dst_entry *tcp_v6_route_req(const struct sock *sk,
+					  struct sk_buff *skb,
 					  struct flowi *fl,
-					  const struct request_sock *req)
+					  struct request_sock *req)
 {
+	tcp_v6_init_req(req, sk, skb);
+
+	if (security_inet_conn_request(sk, skb, req))
+		return NULL;
+
 	return inet6_csk_route_req(sk, &fl->u.ip6, req, IPPROTO_TCP);
 }
 
@@ -851,7 +857,6 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.req_md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 #endif
-	.init_req	=	tcp_v6_init_req,
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v6_init_sequence,
 #endif
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 2e5c3f4da3a4..c55b8f176746 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -228,27 +228,39 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 }
 EXPORT_SYMBOL_GPL(mptcp_subflow_init_cookie_req);
 
-static void subflow_v4_init_req(struct request_sock *req,
-				const struct sock *sk_listener,
-				struct sk_buff *skb)
+static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
+					      struct sk_buff *skb,
+					      struct flowi *fl,
+					      struct request_sock *req)
 {
+	struct dst_entry *dst;
+
 	tcp_rsk(req)->is_mptcp = 1;
 
-	tcp_request_sock_ipv4_ops.init_req(req, sk_listener, skb);
+	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req);
+	if (!dst)
+		return NULL;
 
-	subflow_init_req(req, sk_listener, skb);
+	subflow_init_req(req, sk, skb);
+	return dst;
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static void subflow_v6_init_req(struct request_sock *req,
-				const struct sock *sk_listener,
-				struct sk_buff *skb)
+static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
+					      struct sk_buff *skb,
+					      struct flowi *fl,
+					      struct request_sock *req)
 {
+	struct dst_entry *dst;
+
 	tcp_rsk(req)->is_mptcp = 1;
 
-	tcp_request_sock_ipv6_ops.init_req(req, sk_listener, skb);
+	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req);
+	if (!dst)
+		return NULL;
 
-	subflow_init_req(req, sk_listener, skb);
+	subflow_init_req(req, sk, skb);
+	return dst;
 }
 #endif
 
@@ -1398,7 +1410,7 @@ void __init mptcp_subflow_init(void)
 		panic("MPTCP: failed to init subflow request sock ops\n");
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
-	subflow_request_sock_ipv4_ops.init_req = subflow_v4_init_req;
+	subflow_request_sock_ipv4_ops.route_req = subflow_v4_route_req;
 
 	subflow_specific = ipv4_specific;
 	subflow_specific.conn_request = subflow_v4_conn_request;
@@ -1407,7 +1419,7 @@ void __init mptcp_subflow_init(void)
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
-	subflow_request_sock_ipv6_ops.init_req = subflow_v6_init_req;
+	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
 
 	subflow_v6_specific = ipv6_specific;
 	subflow_v6_specific.conn_request = subflow_v6_conn_request;
-- 
2.26.2

