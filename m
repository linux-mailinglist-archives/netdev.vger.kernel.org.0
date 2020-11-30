Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA79D2C8833
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgK3Phj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgK3Phi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:37:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B11C0613D4;
        Mon, 30 Nov 2020 07:36:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kjlEV-000205-K8; Mon, 30 Nov 2020 16:36:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mptcp@lists.01.org, linux-security-module@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/3] mptcp: emit tcp reset when a join request fails
Date:   Mon, 30 Nov 2020 16:36:31 +0100
Message-Id: <20201130153631.21872-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130153631.21872-1-fw@strlen.de>
References: <20201130153631.21872-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 says:
 If the token is unknown or the host wants to refuse subflow establishment
 (for example, due to a limit on the number of subflows it will permit),
 the receiver will send back a reset (RST) signal, analogous to an unknown
 port in TCP, containing an MP_TCPRST option (Section 3.6) with an
 "MPTCP specific error" reason code.

mptcp-next doesn't support MP_TCPRST yet, this can be added in another
change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/subflow.c | 47 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c55b8f176746..5a8005746bc8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -112,9 +112,14 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
 	return 0;
 }
 
-static void subflow_init_req(struct request_sock *req,
-			     const struct sock *sk_listener,
-			     struct sk_buff *skb)
+/* Init mptcp request socket.
+ *
+ * Returns an error code if a JOIN has failed and a TCP reset
+ * should be sent.
+ */
+static int subflow_init_req(struct request_sock *req,
+			    const struct sock *sk_listener,
+			    struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
@@ -125,7 +130,7 @@ static void subflow_init_req(struct request_sock *req,
 
 	ret = __subflow_init_req(req, sk_listener);
 	if (ret)
-		return;
+		return 0;
 
 	mptcp_get_options(skb, &mp_opt);
 
@@ -133,7 +138,7 @@ static void subflow_init_req(struct request_sock *req,
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
 
 		if (mp_opt.mp_join)
-			return;
+			return 0;
 	} else if (mp_opt.mp_join) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
 	}
@@ -157,7 +162,7 @@ static void subflow_init_req(struct request_sock *req,
 			} else {
 				subflow_req->mp_capable = 1;
 			}
-			return;
+			return 0;
 		}
 
 		err = mptcp_token_new_request(req);
@@ -175,7 +180,11 @@ static void subflow_init_req(struct request_sock *req,
 		subflow_req->remote_nonce = mp_opt.nonce;
 		subflow_req->msk = subflow_token_join_request(req, skb);
 
-		if (unlikely(req->syncookie) && subflow_req->msk) {
+		/* Can't fall back to TCP in this case. */
+		if (!subflow_req->msk)
+			return -EPERM;
+
+		if (unlikely(req->syncookie)) {
 			if (mptcp_can_accept_new_subflow(subflow_req->msk))
 				subflow_init_req_cookie_join_save(subflow_req, skb);
 		}
@@ -183,6 +192,8 @@ static void subflow_init_req(struct request_sock *req,
 		pr_debug("token=%u, remote_nonce=%u msk=%p", subflow_req->token,
 			 subflow_req->remote_nonce, subflow_req->msk);
 	}
+
+	return 0;
 }
 
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
@@ -234,6 +245,7 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 					      struct request_sock *req)
 {
 	struct dst_entry *dst;
+	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
 
@@ -241,8 +253,14 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	if (!dst)
 		return NULL;
 
-	subflow_init_req(req, sk, skb);
-	return dst;
+	err = subflow_init_req(req, sk, skb);
+	if (err == 0)
+		return dst;
+
+	dst_release(dst);
+	if (!req->syncookie)
+		tcp_request_sock_ops.send_reset(sk, skb);
+	return NULL;
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -252,6 +270,7 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 					      struct request_sock *req)
 {
 	struct dst_entry *dst;
+	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
 
@@ -259,8 +278,14 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 	if (!dst)
 		return NULL;
 
-	subflow_init_req(req, sk, skb);
-	return dst;
+	err = subflow_init_req(req, sk, skb);
+	if (err == 0)
+		return dst;
+
+	dst_release(dst);
+	if (!req->syncookie)
+		tcp6_request_sock_ops.send_reset(sk, skb);
+	return NULL;
 }
 #endif
 
-- 
2.26.2

