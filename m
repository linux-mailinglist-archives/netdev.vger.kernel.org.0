Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71881DDD06
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEVCKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:10:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:61643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgEVCKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 22:10:55 -0400
IronPort-SDR: nTtZOW22G1RiOVB3gDqRVs70VSdYudAUbyF6t/fTn14VXmz0fuiWU6LmfyIe7kD4owKr/slFAx
 NC9ImEIupzlA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 19:10:54 -0700
IronPort-SDR: tAiWdL4VJZQyuSYYz5hVVwS+iPKyvpb2JCbJdJT4PzfhlbinSm/Cnkfy9d4z0A30IuJFVDPHkL
 gTYi0hCQZUqw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="289955584"
Received: from tmalsbar-mobl2.sea.intel.com ([10.255.231.186])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 19:10:54 -0700
From:   Todd Malsbary <todd.malsbary@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] mptcp: use untruncated hash in ADD_ADDR HMAC
Date:   Thu, 21 May 2020 19:10:49 -0700
Message-Id: <20200522021049.361606-1-todd.malsbary@linux.intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is some ambiguity in the RFC as to whether the ADD_ADDR HMAC is
the rightmost 64 bits of the entire hash or of the leftmost 160 bits
of the hash.  The intention, as clarified with the author of the RFC,
is the entire hash.

This change returns the entire hash from
mptcp_crypto_hmac_sha (instead of only the first 160 bits), and moves
any truncation/selection operation on the hash to the caller.

Fixes: 12555a2d97e5 ("mptcp: use rightmost 64 bits in ADD_ADDR HMAC")
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Todd Malsbary <todd.malsbary@linux.intel.com>
---
 net/mptcp/crypto.c   | 24 +++++++++---------------
 net/mptcp/options.c  |  9 +++++----
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 15 ++++++++++-----
 4 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index c151628bd416..0f5a414a9366 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -47,8 +47,6 @@ void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn)
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 {
 	u8 input[SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE];
-	__be32 mptcp_hashed_key[SHA256_DIGEST_WORDS];
-	__be32 *hash_out = (__force __be32 *)hmac;
 	struct sha256_state state;
 	u8 key1be[8];
 	u8 key2be[8];
@@ -86,11 +84,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 
 	sha256_init(&state);
 	sha256_update(&state, input, SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE);
-	sha256_final(&state, (u8 *)mptcp_hashed_key);
-
-	/* takes only first 160 bits */
-	for (i = 0; i < 5; i++)
-		hash_out[i] = mptcp_hashed_key[i];
+	sha256_final(&state, (u8 *)hmac);
 }
 
 #ifdef CONFIG_MPTCP_HMAC_TEST
@@ -101,29 +95,29 @@ struct test_cast {
 };
 
 /* we can't reuse RFC 4231 test vectors, as we have constraint on the
- * input and key size, and we truncate the output.
+ * input and key size.
  */
 static struct test_cast tests[] = {
 	{
 		.key = "0b0b0b0b0b0b0b0b",
 		.msg = "48692054",
-		.result = "8385e24fb4235ac37556b6b886db106284a1da67",
+		.result = "8385e24fb4235ac37556b6b886db106284a1da671699f46db1f235ec622dcafa",
 	},
 	{
 		.key = "aaaaaaaaaaaaaaaa",
 		.msg = "dddddddd",
-		.result = "2c5e219164ff1dca1c4a92318d847bb6b9d44492",
+		.result = "2c5e219164ff1dca1c4a92318d847bb6b9d44492984e1eb71aff9022f71046e9",
 	},
 	{
 		.key = "0102030405060708",
 		.msg = "cdcdcdcd",
-		.result = "e73b9ba9969969cefb04aa0d6df18ec2fcc075b6",
+		.result = "e73b9ba9969969cefb04aa0d6df18ec2fcc075b6f23b4d8c4da736a5dbbc6e7d",
 	},
 };
 
 static int __init test_mptcp_crypto(void)
 {
-	char hmac[20], hmac_hex[41];
+	char hmac[32], hmac_hex[65];
 	u32 nonce1, nonce2;
 	u64 key1, key2;
 	u8 msg[8];
@@ -140,11 +134,11 @@ static int __init test_mptcp_crypto(void)
 		put_unaligned_be32(nonce2, &msg[4]);
 
 		mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
-		for (j = 0; j < 20; ++j)
+		for (j = 0; j < 32; ++j)
 			sprintf(&hmac_hex[j << 1], "%02x", hmac[j] & 0xff);
-		hmac_hex[40] = 0;
+		hmac_hex[64] = 0;
 
-		if (memcmp(hmac_hex, tests[i].result, 40))
+		if (memcmp(hmac_hex, tests[i].result, 64))
 			pr_err("test %d failed, got %s expected %s", i,
 			       hmac_hex, tests[i].result);
 		else
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b88fae233a62..7793b6011fa7 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) "MPTCP: " fmt
 
 #include <linux/kernel.h>
+#include <crypto/sha.h>
 #include <net/tcp.h>
 #include <net/mptcp.h>
 #include "protocol.h"
@@ -535,7 +536,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 				  struct in_addr *addr)
 {
-	u8 hmac[MPTCP_ADDR_HMAC_LEN];
+	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[7];
 
 	msg[0] = addr_id;
@@ -545,14 +546,14 @@ static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
 
-	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
+	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 				   struct in6_addr *addr)
 {
-	u8 hmac[MPTCP_ADDR_HMAC_LEN];
+	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[19];
 
 	msg[0] = addr_id;
@@ -562,7 +563,7 @@ static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
 
-	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
+	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
 }
 #endif
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e4ca6320ce76..d0803dfb8108 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -81,7 +81,6 @@
 
 /* MPTCP ADD_ADDR flags */
 #define MPTCP_ADDR_ECHO		BIT(0)
-#define MPTCP_ADDR_HMAC_LEN	20
 #define MPTCP_ADDR_IPVERSION_4	4
 #define MPTCP_ADDR_IPVERSION_6	6
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4931a29a6f08..8968b2c065e7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <crypto/algapi.h>
+#include <crypto/sha.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -89,7 +90,7 @@ static bool subflow_token_join_request(struct request_sock *req,
 				       const struct sk_buff *skb)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
-	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u8 hmac[SHA256_DIGEST_SIZE];
 	struct mptcp_sock *msk;
 	int local_id;
 
@@ -201,7 +202,7 @@ static void subflow_v6_init_req(struct request_sock *req,
 /* validate received truncated hmac and create hmac for third ACK */
 static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
 {
-	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u8 hmac[SHA256_DIGEST_SIZE];
 	u64 thmac;
 
 	subflow_generate_hmac(subflow->remote_key, subflow->local_key,
@@ -267,6 +268,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 		}
 	} else if (subflow->mp_join) {
+		u8 hmac[SHA256_DIGEST_SIZE];
+
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u",
 			 subflow, subflow->thmac,
 			 subflow->remote_nonce);
@@ -279,7 +282,9 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		subflow_generate_hmac(subflow->local_key, subflow->remote_key,
 				      subflow->local_nonce,
 				      subflow->remote_nonce,
-				      subflow->hmac);
+				      hmac);
+
+		memcpy(subflow->hmac, hmac, MPTCPOPT_HMAC_LEN);
 
 		if (skb)
 			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
@@ -347,7 +352,7 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 			       const struct mptcp_options_received *mp_opt)
 {
 	const struct mptcp_subflow_request_sock *subflow_req;
-	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u8 hmac[SHA256_DIGEST_SIZE];
 	struct mptcp_sock *msk;
 	bool ret;
 
@@ -361,7 +366,7 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 			      subflow_req->local_nonce, hmac);
 
 	ret = true;
-	if (crypto_memneq(hmac, mp_opt->hmac, sizeof(hmac)))
+	if (crypto_memneq(hmac, mp_opt->hmac, MPTCPOPT_HMAC_LEN))
 		ret = false;
 
 	sock_put((struct sock *)msk);
-- 
2.25.4

