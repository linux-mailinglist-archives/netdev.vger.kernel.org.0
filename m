Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B50F2288E4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgGUTJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgGUTJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:09:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FF5C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 12:09:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxxdQ-0003Ru-0i; Tue, 21 Jul 2020 21:09:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] mptcp: move helper to where its used
Date:   Tue, 21 Jul 2020 21:08:54 +0200
Message-Id: <20200721190854.28268-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only used in token.c.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.h | 11 -----------
 net/mptcp/token.c    | 12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e5baaef5ec89..6e114c09e5b4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -396,17 +396,6 @@ struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 void mptcp_token_destroy(struct mptcp_sock *msk);
 
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
-static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
-{
-	/* we might consider a faster version that computes the key as a
-	 * hash of some information available in the MPTCP socket. Use
-	 * random data at the moment, as it's probably the safest option
-	 * in case multiple sockets are opened in different namespaces at
-	 * the same time.
-	 */
-	get_random_bytes(key, sizeof(u64));
-	mptcp_crypto_key_sha(*key, token, idsn);
-}
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 7d8106026081..b25b390dbbff 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -83,6 +83,18 @@ static bool __token_bucket_busy(struct token_bucket *t, u32 token)
 	       __token_lookup_req(t, token) || __token_lookup_msk(t, token);
 }
 
+static void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
+{
+	/* we might consider a faster version that computes the key as a
+	 * hash of some information available in the MPTCP socket. Use
+	 * random data at the moment, as it's probably the safest option
+	 * in case multiple sockets are opened in different namespaces at
+	 * the same time.
+	 */
+	get_random_bytes(key, sizeof(u64));
+	mptcp_crypto_key_sha(*key, token, idsn);
+}
+
 /**
  * mptcp_token_new_request - create new key/idsn/token for subflow_request
  * @req: the request socket
-- 
2.26.2

