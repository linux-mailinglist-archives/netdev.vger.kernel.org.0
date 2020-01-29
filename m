Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA80A14CCD2
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgA2OzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:55:14 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42584 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgA2OzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:55:13 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iwokJ-00078n-Gd; Wed, 29 Jan 2020 15:55:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net 4/4] mptcp: handle tcp fallback when using syn cookies
Date:   Wed, 29 Jan 2020 15:54:46 +0100
Message-Id: <20200129145446.26425-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129145446.26425-1-fw@strlen.de>
References: <20200129145446.26425-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't deal with syncookie mode yet, the syncookie rx path will create
tcp reqsk, i.e. we get OOB access because we treat tcp reqsk as mptcp reqsk one:

TCP: SYN flooding on port 20002. Sending cookies.
BUG: KASAN: slab-out-of-bounds in subflow_syn_recv_sock+0x451/0x4d0 net/mptcp/subflow.c:191
Read of size 1 at addr ffff8881167bc148 by task syz-executor099/2120
 subflow_syn_recv_sock+0x451/0x4d0 net/mptcp/subflow.c:191
 tcp_get_cookie_sock+0xcf/0x520 net/ipv4/syncookies.c:209
 cookie_v6_check+0x15a5/0x1e90 net/ipv6/syncookies.c:252
 tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1123 [inline]
 [..]

Bug can be reproduced via "sysctl net.ipv4.tcp_syncookies=2".

Note that MPTCP should work with syncookies (4th ack would carry needed
state), but it appears better to sort that out in -next so do tcp
fallback for now.

I removed the MPTCP ifdef for tcp_rsk "is_mptcp" member because
if (IS_ENABLED()) is easier to read than "#ifdef IS_ENABLED()/#endif" pair.

Cc: Eric Dumazet <edumazet@google.com>
Fixes: cec37a6e41aae7bf ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/tcp.h   | 2 --
 net/ipv4/syncookies.c | 4 ++++
 net/ipv4/tcp_input.c  | 3 +++
 net/ipv6/syncookies.c | 3 +++
 net/mptcp/subflow.c   | 5 ++++-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1cf73e6f85ca..3dc964010fef 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -148,9 +148,7 @@ struct tcp_request_sock {
 	const struct tcp_request_sock_ops *af_specific;
 	u64				snt_synack; /* first SYNACK sent time */
 	bool				tfo_listener;
-#if IS_ENABLED(CONFIG_MPTCP)
 	bool				is_mptcp;
-#endif
 	u32				txhash;
 	u32				rcv_isn;
 	u32				snt_isn;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 345b2b0ff618..9a4f6b16c9bc 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -349,6 +349,10 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	req->ts_recent		= tcp_opt.saw_tstamp ? tcp_opt.rcv_tsval : 0;
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
+
+	if (IS_ENABLED(CONFIG_MPTCP))
+		treq->is_mptcp = 0;
+
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e8b840a4767e..e325b4506e25 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6637,6 +6637,9 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	af_ops->init_req(req, sk, skb);
 
+	if (IS_ENABLED(CONFIG_MPTCP) && want_cookie)
+		tcp_rsk(req)->is_mptcp = 0;
+
 	if (security_inet_conn_request(sk, skb, req))
 		goto drop_and_free;
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 30915f6f31e3..13235a012388 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -178,6 +178,9 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq = tcp_rsk(req);
 	treq->tfo_listener = false;
 
+	if (IS_ENABLED(CONFIG_MPTCP))
+		treq->is_mptcp = 0;
+
 	if (security_inet_conn_request(sk, skb, req))
 		goto out_free;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 205dca1c30b7..c90c0e6ffb82 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -186,6 +186,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
+	if (tcp_rsk(req)->is_mptcp == 0)
+		goto create_child;
+
 	/* if the sk is MP_CAPABLE, we try to fetch the client key */
 	subflow_req = mptcp_subflow_rsk(req);
 	if (subflow_req->mp_capable) {
@@ -769,7 +772,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	struct mptcp_subflow_context *old_ctx = mptcp_subflow_ctx(newsk);
 	struct mptcp_subflow_context *new_ctx;
 
-	if (!subflow_req->mp_capable) {
+	if (!tcp_rsk(req)->is_mptcp || !subflow_req->mp_capable) {
 		subflow_ulp_fallback(newsk, old_ctx);
 		return;
 	}
-- 
2.24.1

