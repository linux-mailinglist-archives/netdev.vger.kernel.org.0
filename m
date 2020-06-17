Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302CA1FCA87
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgFQKKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 06:10:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725860AbgFQKKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592388607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FABBzhCgc7YkpG/7pAMDNHIol2g/rxKMvciS2P61yNE=;
        b=TdSxFNl+mOngvTtR95GZRW2KXk9fwwXjfUjRlWpu4oVwgYGGCMT6TeJ2Gz6cMARZnfgbkJ
        sehY89xRQbvvLR6exS3kSCjO6KDhm/SQw+LCB9h4u31u4eghz5IFGWDXpJ0bvlRRmnALXS
        CSbMDR6wTrJT/DSmEMc2lXn/B0TSbn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-Mv0I9YdIMHyuon2pVCULjQ-1; Wed, 17 Jun 2020 06:10:05 -0400
X-MC-Unique: Mv0I9YdIMHyuon2pVCULjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A15A873430;
        Wed, 17 Jun 2020 10:10:04 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-237.ams2.redhat.com [10.36.112.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8B6C79319;
        Wed, 17 Jun 2020 10:10:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 1/2] mptcp: cache msk on MP_JOIN init_req
Date:   Wed, 17 Jun 2020 12:08:56 +0200
Message-Id: <3213f22a1fa85217032ba3de482f2209c63f2870.1592388398.git.pabeni@redhat.com>
In-Reply-To: <cover.1592388398.git.pabeni@redhat.com>
References: <cover.1592388398.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The msk ownership is transferred to the child socket at
3rd ack time, so that we avoid more lookups later. If the
request does not reach the 3rd ack, the MSK reference is
dropped at request sock release time.

As a side effect, fallback is now tracked by a NULL msk
reference instead of zeroed 'mp_join' field. This will
simplify the next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 39 +++++++++++++++++----------------------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index db56535dfc29..c6eeaf3e8dcb 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -249,6 +249,7 @@ struct mptcp_subflow_request_sock {
 	u64	thmac;
 	u32	local_nonce;
 	u32	remote_nonce;
+	struct mptcp_sock	*msk;
 };
 
 static inline struct mptcp_subflow_request_sock *
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bbdb74b8bc3c..4068bdb2523b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -69,6 +69,9 @@ static void subflow_req_destructor(struct request_sock *req)
 
 	pr_debug("subflow_req=%p", subflow_req);
 
+	if (subflow_req->msk)
+		sock_put((struct sock *)subflow_req->msk);
+
 	if (subflow_req->mp_capable)
 		mptcp_token_destroy_request(subflow_req->token);
 	tcp_request_sock_ops.destructor(req);
@@ -86,8 +89,8 @@ static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 }
 
 /* validate received token and create truncated hmac and nonce for SYN-ACK */
-static bool subflow_token_join_request(struct request_sock *req,
-				       const struct sk_buff *skb)
+static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
+						     const struct sk_buff *skb)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	u8 hmac[SHA256_DIGEST_SIZE];
@@ -97,13 +100,13 @@ static bool subflow_token_join_request(struct request_sock *req,
 	msk = mptcp_token_get_sock(subflow_req->token);
 	if (!msk) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINNOTOKEN);
-		return false;
+		return NULL;
 	}
 
 	local_id = mptcp_pm_get_local_id(msk, (struct sock_common *)req);
 	if (local_id < 0) {
 		sock_put((struct sock *)msk);
-		return false;
+		return NULL;
 	}
 	subflow_req->local_id = local_id;
 
@@ -114,9 +117,7 @@ static bool subflow_token_join_request(struct request_sock *req,
 			      subflow_req->remote_nonce, hmac);
 
 	subflow_req->thmac = get_unaligned_be64(hmac);
-
-	sock_put((struct sock *)msk);
-	return true;
+	return msk;
 }
 
 static void subflow_init_req(struct request_sock *req,
@@ -133,6 +134,7 @@ static void subflow_init_req(struct request_sock *req,
 
 	subflow_req->mp_capable = 0;
 	subflow_req->mp_join = 0;
+	subflow_req->msk = NULL;
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -166,12 +168,9 @@ static void subflow_init_req(struct request_sock *req,
 		subflow_req->remote_id = mp_opt.join_id;
 		subflow_req->token = mp_opt.token;
 		subflow_req->remote_nonce = mp_opt.nonce;
-		pr_debug("token=%u, remote_nonce=%u", subflow_req->token,
-			 subflow_req->remote_nonce);
-		if (!subflow_token_join_request(req, skb)) {
-			subflow_req->mp_join = 0;
-			// @@ need to trigger RST
-		}
+		subflow_req->msk = subflow_token_join_request(req, skb);
+		pr_debug("token=%u, remote_nonce=%u msk=%p", subflow_req->token,
+			 subflow_req->remote_nonce, subflow_req->msk);
 	}
 }
 
@@ -354,10 +353,9 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 	const struct mptcp_subflow_request_sock *subflow_req;
 	u8 hmac[SHA256_DIGEST_SIZE];
 	struct mptcp_sock *msk;
-	bool ret;
 
 	subflow_req = mptcp_subflow_rsk(req);
-	msk = mptcp_token_get_sock(subflow_req->token);
+	msk = subflow_req->msk;
 	if (!msk)
 		return false;
 
@@ -365,12 +363,7 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 			      subflow_req->remote_nonce,
 			      subflow_req->local_nonce, hmac);
 
-	ret = true;
-	if (crypto_memneq(hmac, mp_opt->hmac, MPTCPOPT_HMAC_LEN))
-		ret = false;
-
-	sock_put((struct sock *)msk);
-	return ret;
+	return !crypto_memneq(hmac, mp_opt->hmac, MPTCPOPT_HMAC_LEN);
 }
 
 static void mptcp_sock_destruct(struct sock *sk)
@@ -522,10 +515,12 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
 
-			owner = mptcp_token_get_sock(ctx->token);
+			owner = subflow_req->msk;
 			if (!owner)
 				goto dispose_child;
 
+			/* move the msk reference ownership to the subflow */
+			subflow_req->msk = NULL;
 			ctx->conn = (struct sock *)owner;
 			if (!mptcp_finish_join(child))
 				goto dispose_child;
-- 
2.26.2

