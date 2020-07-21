Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB93228A0B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgGUUhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgGUUhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DE0C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz11-0003x2-FR; Tue, 21 Jul 2020 22:37:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 09/12] tcp: syncookies: create mptcp request socket for ACK cookies with MPTCP option
Date:   Tue, 21 Jul 2020 22:36:39 +0200
Message-Id: <20200721203642.32753-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/syncookies.c | 21 +++++++++++++++++----
 net/ipv4/tcp_input.c  |  3 ---
 net/ipv6/syncookies.c | 17 ++++++++++++++---
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index ee17f55401ef..5da49dc126f9 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -289,6 +289,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	__u32 cookie = ntohl(th->ack_seq) - 1;
+	const struct request_sock_ops *ops;
 	struct sock *ret = sk;
 	struct request_sock *req;
 	int mss;
@@ -326,12 +327,27 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = inet_reqsk_alloc(&tcp_request_sock_ops, sk, false); /* for safety */
+	ops = &tcp_request_sock_ops;
+#ifdef CONFIG_MPTCP
+	if (sk_is_mptcp(sk))
+		ops = &mptcp_subflow_request_sock_ops;
+#endif
+
+	req = inet_reqsk_alloc(ops, sk, false); /* for safety */
 	if (!req)
 		goto out;
 
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
+	treq->is_mptcp = sk_is_mptcp(sk);
+
+	if (treq->is_mptcp) {
+		int err = mptcp_subflow_init_cookie_req(req, sk, skb);
+
+		if (err)
+			goto out_free;
+	}
+
 	treq->rcv_isn		= ntohl(th->seq) - 1;
 	treq->snt_isn		= cookie;
 	treq->ts_off		= 0;
@@ -350,9 +366,6 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
 
-	if (IS_ENABLED(CONFIG_MPTCP))
-		treq->is_mptcp = 0;
-
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 17aa1c29d11c..7f4c21bca3b5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6699,9 +6699,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	af_ops->init_req(req, sk, skb, want_cookie);
 
-	if (IS_ENABLED(CONFIG_MPTCP) && want_cookie)
-		tcp_rsk(req)->is_mptcp = 0;
-
 	if (security_inet_conn_request(sk, skb, req))
 		goto drop_and_free;
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 13235a012388..0a05c3c1e776 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -134,6 +134,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	__u32 cookie = ntohl(th->ack_seq) - 1;
+	const struct request_sock_ops *ops;
 	struct sock *ret = sk;
 	struct request_sock *req;
 	int mss;
@@ -170,7 +171,13 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = inet_reqsk_alloc(&tcp6_request_sock_ops, sk, false);
+	ops = &tcp6_request_sock_ops;
+#ifdef CONFIG_MPTCP
+	if (sk_is_mptcp(sk))
+		ops = &mptcp_subflow_request_sock_ops;
+#endif
+
+	req = inet_reqsk_alloc(ops, sk, false);
 	if (!req)
 		goto out;
 
@@ -178,8 +185,12 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq = tcp_rsk(req);
 	treq->tfo_listener = false;
 
-	if (IS_ENABLED(CONFIG_MPTCP))
-		treq->is_mptcp = 0;
+	if (treq->is_mptcp) {
+		int err = mptcp_subflow_init_cookie_req(req, sk, skb);
+
+		if (err)
+			goto out_free;
+	}
 
 	if (security_inet_conn_request(sk, skb, req))
 		goto out_free;
-- 
2.26.2

