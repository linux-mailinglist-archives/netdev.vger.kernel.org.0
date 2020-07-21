Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C3228A0D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgGUUhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgGUUhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B2C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz19-0003xd-Qx; Tue, 21 Jul 2020 22:37:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 11/12] mptcp: enable JOIN requests even if cookies are in use
Date:   Tue, 21 Jul 2020 22:36:41 +0200
Message-Id: <20200721203642.32753-12-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

JOIN requests do not work in syncookie mode -- for HMAC validation, the
peers nonce is required, but this nonce is only present in the SYN.

So either we need to drop or reject all JOIN requests once a listening
socket enters syncookie mode, or we need to store enough state to
validate the ACKs HMAC later on.

This allows the subflow request initialisation function to store the
request socket even when syncookies are used, i.e. the listener
socket queue will grow past its upper limit.

Following restrictions apply:
1. The (32bit) token contained in the MP_JOIN SYN packet returns
   a valid parent connection.
2. The parent connection can accept one more subflow.

To ensure 2), all MP_JOIN requests (new incoming and existing)
are accounted in the mptcp parent socket.

If the token is invalid or the parent cannot accept a new subflow,
no information is stored and TCP fallback path is used.

The parent socket can't be used without further changes in TCP stack,
because socket creation after 3whs completion checks that the associated
socket is in LISTEN state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 To ease review I think it would also be possible to
 defer the JOIN stuff for later and just focus on initial
 MP_CAPABLE request.  OTOH, doing so yields MPTCP-on-wire but with no
 Multipath capability so I'm not sure having MP_CAPABLE without
 MP_JOIN is useful.

 net/mptcp/pm_netlink.c |  2 +-
 net/mptcp/protocol.h   |  2 ++
 net/mptcp/subflow.c    | 60 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c8820c4156e6..117f794ecc54 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -41,7 +41,7 @@ struct pm_nl_pernet {
 	unsigned int		next_id;
 };
 
-#define MPTCP_PM_ADDR_MAX	8
+#define MPTCP_PM_ADDR_MAX	MPTCP_SUBFLOWS_MAX
 
 static bool addresses_equal(const struct mptcp_addr_info *a,
 			    struct mptcp_addr_info *b, bool use_port)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0ed402cdb9fd..586601e889fc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -154,6 +154,8 @@ enum mptcp_pm_status {
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 };
 
+#define MPTCP_SUBFLOWS_MAX	8
+
 struct mptcp_pm_data {
 	struct mptcp_addr_info local;
 	struct mptcp_addr_info remote;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 0761c35268ce..ab86010483fe 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -126,6 +126,49 @@ static int __subflow_check_options(const struct mptcp_options_received *mp_opt,
 	return 0;
 }
 
+static bool mptcp_join_store(struct mptcp_subflow_request_sock *req,
+			     struct sock *sk_listener,
+			     bool want_cookie)
+{
+	struct mptcp_sock *msk = req->msk;
+	struct inet_connection_sock *icsk;
+	struct sock *sk;
+
+	icsk = &msk->sk;
+	sk = &icsk->icsk_inet.sk;
+
+	if (inet_csk_reqsk_queue_len(sk) >= MPTCP_SUBFLOWS_MAX ||
+	    !mptcp_can_accept_new_subflow(msk))
+		return false;
+
+	atomic_inc(&inet_csk(sk)->icsk_accept_queue.qlen);
+
+	if (likely(!want_cookie))
+		return true;
+
+	/* Syncookies are used.
+	 * We can't do this for JOIN requests because we need to store
+	 * the initiators nonce for HMAC validation.
+	 *
+	 * At this point we know:
+	 * 1. a valid parent connection that should be joined
+	 * 2. the parent socket has less than MPTCP_SUBFLOWS_MAX joined
+	 * connections (includes those in progress).
+	 *
+	 * We add the request to the accept queue backlog ourselves
+	 * in this case.
+	 */
+	if (unlikely(!refcount_inc_not_zero(&sk_listener->sk_refcnt))) {
+		atomic_dec(&inet_csk(sk)->icsk_accept_queue.qlen);
+		return false;
+	}
+
+	req->sk.req.req.rsk_listener = sk_listener;
+	inet_csk_reqsk_queue_hash_add(sk, &req->sk.req.req,
+				      tcp_timeout_init((struct sock *)req));
+	return true;
+}
+
 static void subflow_init_req(struct request_sock *req,
 			     const struct sock *sk_listener,
 			     struct sk_buff *skb,
@@ -177,12 +220,18 @@ static void subflow_init_req(struct request_sock *req,
 
 	} else if (mp_opt.mp_join && listener->request_mptcp) {
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
-		subflow_req->mp_join = 1;
 		subflow_req->backup = mp_opt.backup;
 		subflow_req->remote_id = mp_opt.join_id;
 		subflow_req->token = mp_opt.token;
 		subflow_req->remote_nonce = mp_opt.nonce;
 		subflow_req->msk = subflow_token_join_request(req, skb);
+		if (!subflow_req->msk)
+			return;
+
+		if (!mptcp_join_store(subflow_req, (void *)sk_listener, want_cookie))
+			return;
+
+		subflow_req->mp_join = 1;
 		pr_debug("token=%u, remote_nonce=%u msk=%p", subflow_req->token,
 			 subflow_req->remote_nonce, subflow_req->msk);
 	}
@@ -1285,9 +1334,14 @@ static void subflow_ulp_release(struct sock *sk)
 	if (!ctx)
 		return;
 
-	if (ctx->conn)
-		sock_put(ctx->conn);
+	if (ctx->conn) {
+		struct sock *msk = ctx->conn;
+
+		if (ctx->mp_join)
+			atomic_add_unless(&inet_csk(msk)->icsk_accept_queue.qlen, -1, 0);
 
+		sock_put(msk);
+	}
 	kfree_rcu(ctx, rcu);
 }
 
-- 
2.26.2

