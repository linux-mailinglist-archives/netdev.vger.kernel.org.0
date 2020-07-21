Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32964228A08
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgGUUh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgGUUh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76734C0619DB
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0v-0003wN-05; Tue, 21 Jul 2020 22:37:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 07/12] tcp: pass want_cookie down to req_init function
Date:   Tue, 21 Jul 2020 22:36:37 +0200
Message-Id: <20200721203642.32753-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In MPTCP case, we want to know if we should store a new token id or if we
should try best-effort only (cookie case).

This allows the MPTCP core to detect when it should elide the storage
of the generated MPTCP token.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This isn't nice either, its useless from TCP pov.

 One alternative would be to add a bit in the mptcp request
 socket and use that instead.
 Another alternative would be to store the token normally but
 then toss it again as soon as request sk is discarded again.

 Let me know if I should evaluate a different approach.

 include/net/tcp.h    |  3 ++-
 net/ipv4/tcp_input.c |  2 +-
 net/ipv4/tcp_ipv4.c  |  3 ++-
 net/ipv6/tcp_ipv6.c  |  3 ++-
 net/mptcp/subflow.c  | 17 ++++++++++-------
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 74c0b37584ef..401b9820628e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2019,7 +2019,8 @@ struct tcp_request_sock_ops {
 #endif
 	void (*init_req)(struct request_sock *req,
 			 struct sock *sk_listener,
-			 struct sk_buff *skb);
+			 struct sk_buff *skb,
+			 bool syncookie_req);
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
 				 __u16 *mss);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 727ca87a2929..17aa1c29d11c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6697,7 +6697,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	af_ops->init_req(req, sk, skb);
+	af_ops->init_req(req, sk, skb, want_cookie);
 
 	if (IS_ENABLED(CONFIG_MPTCP) && want_cookie)
 		tcp_rsk(req)->is_mptcp = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f0b01d09d5ad..0a8c61c4d590 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1421,7 +1421,8 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 
 static void tcp_v4_init_req(struct request_sock *req,
 			    struct sock *sk_listener,
-			    struct sk_buff *skb)
+			    struct sk_buff *skb,
+			    bool want_cookie)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	struct net *net = sock_net(sk_listener);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1c7bf70660e8..ccf03d5c143a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -793,7 +793,8 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 
 static void tcp_v6_init_req(struct request_sock *req,
 			    struct sock *sk_listener,
-			    struct sk_buff *skb)
+			    struct sk_buff *skb,
+			    bool want_cookie)
 {
 	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 55a19f8ed8ec..023e9f435d1b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -128,7 +128,8 @@ static int __subflow_check_options(const struct mptcp_options_received *mp_opt,
 
 static void subflow_init_req(struct request_sock *req,
 			     const struct sock *sk_listener,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb,
+			     bool want_cookie)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
@@ -176,25 +177,27 @@ static void subflow_init_req(struct request_sock *req,
 
 static void subflow_v4_init_req(struct request_sock *req,
 				struct sock *sk_listener,
-				struct sk_buff *skb)
+				struct sk_buff *skb,
+				bool want_cookie)
 {
 	tcp_rsk(req)->is_mptcp = 1;
 
-	tcp_request_sock_ipv4_ops.init_req(req, sk_listener, skb);
+	tcp_request_sock_ipv4_ops.init_req(req, sk_listener, skb, want_cookie);
 
-	subflow_init_req(req, sk_listener, skb);
+	subflow_init_req(req, sk_listener, skb, want_cookie);
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static void subflow_v6_init_req(struct request_sock *req,
 				struct sock *sk_listener,
-				struct sk_buff *skb)
+				struct sk_buff *skb,
+				bool want_cookie)
 {
 	tcp_rsk(req)->is_mptcp = 1;
 
-	tcp_request_sock_ipv6_ops.init_req(req, sk_listener, skb);
+	tcp_request_sock_ipv6_ops.init_req(req, sk_listener, skb, want_cookie);
 
-	subflow_init_req(req, sk_listener, skb);
+	subflow_init_req(req, sk_listener, skb, want_cookie);
 }
 #endif
 
-- 
2.26.2

