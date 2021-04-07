Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9295356021
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347574AbhDGARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:17:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:23775 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347433AbhDGAQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:53 -0400
IronPort-SDR: H1lMUZVbheXD45RYL7nbfD1Mkip8XlZ70U60VGZxBjMn/JE7lXxb1j0zAQaJBBwGo9Y5PMWXIw
 xkOG+wSgh2aQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297265"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297265"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:11 -0700
IronPort-SDR: e/GUHPe5ntUQltgGqm64vEmJmG9ockp1Dm9rmYCXZn213k/+AEtMabpoaaX125dG8Q+ayZJ18O
 3/ZeZTw+vBrg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105202"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:11 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: unify add_addr(6)_generate_hmac
Date:   Tue,  6 Apr 2021 17:16:02 -0700
Message-Id: <20210407001604.85071-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

The length of the IPv4 address is 4 octets and IPv6 is 16. That's the only
difference between add_addr_generate_hmac and add_addr6_generate_hmac.

This patch dropped the duplicate code and unify them into one.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 81 ++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 56 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3bdb92a3b480..c7eb61d0564c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -583,39 +583,32 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
-static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				  struct in_addr *addr, u16 port)
-{
-	u8 hmac[SHA256_DIGEST_SIZE];
-	u8 msg[7];
-
-	msg[0] = addr_id;
-	memcpy(&msg[1], &addr->s_addr, 4);
-	msg[5] = port >> 8;
-	msg[6] = port & 0xFF;
-
-	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
-
-	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
-}
-
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				   struct in6_addr *addr, u16 port)
+static u64 add_addr_generate_hmac(u64 key1, u64 key2,
+				  struct mptcp_addr_info *addr)
 {
+	u16 port = ntohs(addr->port);
 	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[19];
+	int i = 0;
 
-	msg[0] = addr_id;
-	memcpy(&msg[1], &addr->s6_addr, 16);
-	msg[17] = port >> 8;
-	msg[18] = port & 0xFF;
+	msg[i++] = addr->id;
+	if (addr->family == AF_INET) {
+		memcpy(&msg[i], &addr->addr.s_addr, 4);
+		i += 4;
+	}
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (addr->family == AF_INET6) {
+		memcpy(&msg[i], &addr->addr6.s6_addr, 16);
+		i += 16;
+	}
+#endif
+	msg[i++] = port >> 8;
+	msg[i++] = port & 0xFF;
 
-	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
+	mptcp_crypto_hmac_sha(key1, key2, msg, i, hmac);
 
 	return get_unaligned_be64(&hmac[SHA256_DIGEST_SIZE - sizeof(u64)]);
 }
-#endif
 
 static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *skb,
 					       unsigned int *size,
@@ -653,26 +646,11 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	if (drop_other_suboptions)
 		*size -= opt_size;
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
-	if (opts->addr.family == AF_INET) {
-		if (!echo) {
-			opts->ahmac = add_addr_generate_hmac(msk->local_key,
-							     msk->remote_key,
-							     opts->addr.id,
-							     &opts->addr.addr,
-							     ntohs(opts->addr.port));
-		}
+	if (!echo) {
+		opts->ahmac = add_addr_generate_hmac(msk->local_key,
+						     msk->remote_key,
+						     &opts->addr);
 	}
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else if (opts->addr.family == AF_INET6) {
-		if (!echo) {
-			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
-							      msk->remote_key,
-							      opts->addr.id,
-							      &opts->addr.addr6,
-							      ntohs(opts->addr.port));
-		}
-	}
-#endif
 	pr_debug("addr_id=%d, ahmac=%llu, echo=%d, port=%d",
 		 opts->addr.id, opts->ahmac, echo, ntohs(opts->addr.port));
 
@@ -991,18 +969,9 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 	if (mp_opt->echo)
 		return true;
 
-	if (mp_opt->addr.family == AF_INET)
-		hmac = add_addr_generate_hmac(msk->remote_key,
-					      msk->local_key,
-					      mp_opt->addr.id, &mp_opt->addr.addr,
-					      ntohs(mp_opt->addr.port));
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else
-		hmac = add_addr6_generate_hmac(msk->remote_key,
-					       msk->local_key,
-					       mp_opt->addr.id, &mp_opt->addr.addr6,
-					       ntohs(mp_opt->addr.port));
-#endif
+	hmac = add_addr_generate_hmac(msk->remote_key,
+				      msk->local_key,
+				      &mp_opt->addr);
 
 	pr_debug("msk=%p, ahmac=%llu, mp_opt->ahmac=%llu\n",
 		 msk, (unsigned long long)hmac,
-- 
2.31.1

