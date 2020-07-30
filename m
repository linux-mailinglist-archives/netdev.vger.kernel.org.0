Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF37E2338F0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgG3T0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FF7C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1EBw-0003Vj-Qw; Thu, 30 Jul 2020 21:26:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 2/9] mptcp: token: move retry to caller
Date:   Thu, 30 Jul 2020 21:25:51 +0200
Message-Id: <20200730192558.25697-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once syncookie support is added, no state will be stored anymore when the
syn/ack is generated in syncookie mode.

When the ACK comes back, the generated key will be taken from the TCP ACK,
the token is re-generated and inserted into the token tree.

This means we can't retry with a new key when the token is already taken
in the syncookie case.

Therefore, move the retry logic to the caller to prepare for syncookie
support in mptcp.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/subflow.c |  9 ++++++++-
 net/mptcp/token.c   | 12 ++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1c8482bc2ce5..9feb87880d1c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -126,11 +126,18 @@ static void subflow_init_req(struct request_sock *req,
 	}
 
 	if (mp_opt.mp_capable && listener->request_mptcp) {
-		int err;
+		int err, retries = 4;
+
+again:
+		do {
+			get_random_bytes(&subflow_req->local_key, sizeof(subflow_req->local_key));
+		} while (subflow_req->local_key == 0);
 
 		err = mptcp_token_new_request(req);
 		if (err == 0)
 			subflow_req->mp_capable = 1;
+		else if (retries-- > 0)
+			goto again;
 
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	} else if (mp_opt.mp_join && listener->request_mptcp) {
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 97cfc45bcc4f..f82410c54653 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -109,14 +109,12 @@ static void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
 int mptcp_token_new_request(struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
-	int retries = TOKEN_MAX_RETRIES;
 	struct token_bucket *bucket;
 	u32 token;
 
-again:
-	mptcp_crypto_key_gen_sha(&subflow_req->local_key,
-				 &subflow_req->token,
-				 &subflow_req->idsn);
+	mptcp_crypto_key_sha(subflow_req->local_key,
+			     &subflow_req->token,
+			     &subflow_req->idsn);
 	pr_debug("req=%p local_key=%llu, token=%u, idsn=%llu\n",
 		 req, subflow_req->local_key, subflow_req->token,
 		 subflow_req->idsn);
@@ -126,9 +124,7 @@ int mptcp_token_new_request(struct request_sock *req)
 	spin_lock_bh(&bucket->lock);
 	if (__token_bucket_busy(bucket, token)) {
 		spin_unlock_bh(&bucket->lock);
-		if (!--retries)
-			return -EBUSY;
-		goto again;
+		return -EBUSY;
 	}
 
 	hlist_nulls_add_head_rcu(&subflow_req->token_node, &bucket->req_chain);
-- 
2.26.2

