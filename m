Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24C19496F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCZUrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:47:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:47899 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727661AbgCZUq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:59 -0400
IronPort-SDR: A9cvO3b0czdMI3aIXht7ig0uec7zPzK295x2k5BehMtOLrwoVYP+yOC6FUxbcLqe/rHYp6QEna
 q9envvasekjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:46:58 -0700
IronPort-SDR: sC8f3qR+dsGma24nlnJd9ERsBq4yBUhdvMF3+YwVFK1Oy4UTaFCaAEJ10lJHsgscmdmzsZCfTR
 J9bfs65uHQMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911660"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:46:58 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 01/17] mptcp: Add ADD_ADDR handling
Date:   Thu, 26 Mar 2020 13:46:24 -0700
Message-Id: <20200326204640.67336-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add handling for sending and receiving the ADD_ADDR, ADD_ADDR6,
and RM_ADDR suboptions.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/tcp.h  |  20 ++++-
 include/net/mptcp.h  |   9 ++
 net/mptcp/crypto.c   |  17 ++--
 net/mptcp/options.c  | 206 +++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |  28 +++++-
 5 files changed, 262 insertions(+), 18 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3dc964010fef..1225db308957 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -86,9 +86,13 @@ struct mptcp_options_received {
 	u64	data_seq;
 	u32	subflow_seq;
 	u16	data_len;
-	u8	mp_capable : 1,
+	u16	mp_capable : 1,
 		mp_join : 1,
-		dss : 1;
+		dss : 1,
+		add_addr : 1,
+		rm_addr : 1,
+		family : 4,
+		echo : 1;
 	u8	use_map:1,
 		dsn64:1,
 		data_fin:1,
@@ -96,6 +100,16 @@ struct mptcp_options_received {
 		ack64:1,
 		mpc_map:1,
 		__unused:2;
+	u8	addr_id;
+	u8	rm_id;
+	union {
+		struct in_addr	addr;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		struct in6_addr	addr6;
+#endif
+	};
+	u64	ahmac;
+	u16	port;
 };
 #endif
 
@@ -131,6 +145,8 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 #if IS_ENABLED(CONFIG_MPTCP)
 	rx_opt->mptcp.mp_capable = 0;
 	rx_opt->mptcp.mp_join = 0;
+	rx_opt->mptcp.add_addr = 0;
+	rx_opt->mptcp.rm_addr = 0;
 	rx_opt->mptcp.dss = 0;
 #endif
 }
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index c971d25431ea..0d5ea71dd3d0 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -33,6 +33,15 @@ struct mptcp_out_options {
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
+	union {
+		struct in_addr addr;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		struct in6_addr addr6;
+#endif
+	};
+	u8 addr_id;
+	u64 ahmac;
+	u8 rm_id;
 	struct mptcp_ext ext_copy;
 #endif
 };
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index 40d1bb18fd60..c151628bd416 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -44,8 +44,7 @@ void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn)
 		*idsn = be64_to_cpu(*((__be64 *)&mptcp_hashed_key[6]));
 }
 
-void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
-			   void *hmac)
+void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 {
 	u8 input[SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE];
 	__be32 mptcp_hashed_key[SHA256_DIGEST_WORDS];
@@ -55,6 +54,9 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 	u8 key2be[8];
 	int i;
 
+	if (WARN_ON_ONCE(len > SHA256_DIGEST_SIZE))
+		len = SHA256_DIGEST_SIZE;
+
 	put_unaligned_be64(key1, key1be);
 	put_unaligned_be64(key2, key2be);
 
@@ -65,11 +67,10 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 	for (i = 0; i < 8; i++)
 		input[i + 8] ^= key2be[i];
 
-	put_unaligned_be32(nonce1, &input[SHA256_BLOCK_SIZE]);
-	put_unaligned_be32(nonce2, &input[SHA256_BLOCK_SIZE + 4]);
+	memcpy(&input[SHA256_BLOCK_SIZE], msg, len);
 
 	sha256_init(&state);
-	sha256_update(&state, input, SHA256_BLOCK_SIZE + 8);
+	sha256_update(&state, input, SHA256_BLOCK_SIZE + len);
 
 	/* emit sha256(K1 || msg) on the second input block, so we can
 	 * reuse 'input' for the last hashing
@@ -125,6 +126,7 @@ static int __init test_mptcp_crypto(void)
 	char hmac[20], hmac_hex[41];
 	u32 nonce1, nonce2;
 	u64 key1, key2;
+	u8 msg[8];
 	int i, j;
 
 	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
@@ -134,7 +136,10 @@ static int __init test_mptcp_crypto(void)
 		nonce1 = be32_to_cpu(*((__be32 *)&tests[i].msg[0]));
 		nonce2 = be32_to_cpu(*((__be32 *)&tests[i].msg[4]));
 
-		mptcp_crypto_hmac_sha(key1, key2, nonce1, nonce2, hmac);
+		put_unaligned_be32(nonce1, &msg[0]);
+		put_unaligned_be32(nonce2, &msg[4]);
+
+		mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
 		for (j = 0; j < 20; ++j)
 			sprintf(&hmac_hex[j << 1], "%02x", hmac[j] & 0xff);
 		hmac_hex[40] = 0;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index aea1a62d9999..6c6c18a09a40 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -178,6 +178,71 @@ void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
 
 		break;
 
+	case MPTCPOPT_ADD_ADDR:
+		mp_opt->echo = (*ptr++) & MPTCP_ADDR_ECHO;
+		if (!mp_opt->echo) {
+			if (opsize == TCPOLEN_MPTCP_ADD_ADDR ||
+			    opsize == TCPOLEN_MPTCP_ADD_ADDR_PORT)
+				mp_opt->family = MPTCP_ADDR_IPVERSION_4;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+			else if (opsize == TCPOLEN_MPTCP_ADD_ADDR6 ||
+				 opsize == TCPOLEN_MPTCP_ADD_ADDR6_PORT)
+				mp_opt->family = MPTCP_ADDR_IPVERSION_6;
+#endif
+			else
+				break;
+		} else {
+			if (opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE ||
+			    opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT)
+				mp_opt->family = MPTCP_ADDR_IPVERSION_4;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+			else if (opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE ||
+				 opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT)
+				mp_opt->family = MPTCP_ADDR_IPVERSION_6;
+#endif
+			else
+				break;
+		}
+
+		mp_opt->add_addr = 1;
+		mp_opt->port = 0;
+		mp_opt->addr_id = *ptr++;
+		pr_debug("ADD_ADDR: id=%d", mp_opt->addr_id);
+		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
+			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
+			ptr += 4;
+			if (opsize == TCPOLEN_MPTCP_ADD_ADDR_PORT ||
+			    opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT) {
+				mp_opt->port = get_unaligned_be16(ptr);
+				ptr += 2;
+			}
+		}
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		else {
+			memcpy(mp_opt->addr6.s6_addr, (u8 *)ptr, 16);
+			ptr += 16;
+			if (opsize == TCPOLEN_MPTCP_ADD_ADDR6_PORT ||
+			    opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT) {
+				mp_opt->port = get_unaligned_be16(ptr);
+				ptr += 2;
+			}
+		}
+#endif
+		if (!mp_opt->echo) {
+			mp_opt->ahmac = get_unaligned_be64(ptr);
+			ptr += 8;
+		}
+		break;
+
+	case MPTCPOPT_RM_ADDR:
+		if (opsize != TCPOLEN_MPTCP_RM_ADDR_BASE)
+			break;
+
+		mp_opt->rm_addr = 1;
+		mp_opt->rm_id = *ptr++;
+		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
+		break;
+
 	default:
 		break;
 	}
@@ -386,6 +451,84 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
+static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
+				  struct in_addr *addr)
+{
+	u8 hmac[MPTCP_ADDR_HMAC_LEN];
+	u8 msg[7];
+
+	msg[0] = addr_id;
+	memcpy(&msg[1], &addr->s_addr, 4);
+	msg[5] = 0;
+	msg[6] = 0;
+
+	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
+
+	return get_unaligned_be64(hmac);
+}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
+				   struct in6_addr *addr)
+{
+	u8 hmac[MPTCP_ADDR_HMAC_LEN];
+	u8 msg[19];
+
+	msg[0] = addr_id;
+	memcpy(&msg[1], &addr->s6_addr, 16);
+	msg[17] = 0;
+	msg[18] = 0;
+
+	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
+
+	return get_unaligned_be64(hmac);
+}
+#endif
+
+static bool mptcp_established_options_addr(struct sock *sk,
+					   unsigned int *size,
+					   unsigned int remaining,
+					   struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct sockaddr_storage saddr;
+	u8 id;
+
+	id = 0;
+	memset(&saddr, 0, sizeof(saddr));
+
+	if (saddr.ss_family == AF_INET) {
+		if (remaining < TCPOLEN_MPTCP_ADD_ADDR)
+			return false;
+		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
+		opts->addr_id = id;
+		opts->addr = ((struct sockaddr_in *)&saddr)->sin_addr;
+		opts->ahmac = add_addr_generate_hmac(msk->local_key,
+						     msk->remote_key,
+						     opts->addr_id,
+						     &opts->addr);
+		*size = TCPOLEN_MPTCP_ADD_ADDR;
+	}
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (saddr.ss_family == AF_INET6) {
+		if (remaining < TCPOLEN_MPTCP_ADD_ADDR6)
+			return false;
+		opts->suboptions |= OPTION_MPTCP_ADD_ADDR6;
+		opts->addr_id = id;
+		opts->ahmac = add_addr6_generate_hmac(msk->local_key,
+						      msk->remote_key,
+						      opts->addr_id,
+						      &opts->addr6);
+		opts->addr6 = ((struct sockaddr_in6 *)&saddr)->sin6_addr;
+		*size = TCPOLEN_MPTCP_ADD_ADDR6;
+	}
+#endif
+	pr_debug("addr_id=%d, ahmac=%llu", opts->addr_id, opts->ahmac);
+
+	return true;
+}
+
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
@@ -393,6 +536,8 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	unsigned int opt_size = 0;
 	bool ret = false;
 
+	opts->suboptions = 0;
+
 	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
@@ -407,6 +552,11 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 
 	*size += opt_size;
 	remaining -= opt_size;
+	if (mptcp_established_options_addr(sk, &opt_size, remaining, opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		ret = true;
+	}
 
 	return ret;
 }
@@ -521,10 +671,9 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		else
 			len = TCPOLEN_MPTCP_MPC_ACK;
 
-		*ptr++ = htonl((TCPOPT_MPTCP << 24) | (len << 16) |
-			       (MPTCPOPT_MP_CAPABLE << 12) |
-			       (MPTCP_SUPPORTED_VERSION << 8) |
-			       MPTCP_CAP_HMAC_SHA256);
+		*ptr++ = mptcp_option(MPTCPOPT_MP_CAPABLE, len,
+				      MPTCP_SUPPORTED_VERSION,
+				      MPTCP_CAP_HMAC_SHA256);
 
 		if (!((OPTION_MPTCP_MPC_SYNACK | OPTION_MPTCP_MPC_ACK) &
 		    opts->suboptions))
@@ -546,6 +695,50 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 	}
 
 mp_capable_done:
+	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+		if (opts->ahmac)
+			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+					      TCPOLEN_MPTCP_ADD_ADDR, 0,
+					      opts->addr_id);
+		else
+			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+					      TCPOLEN_MPTCP_ADD_ADDR_BASE,
+					      MPTCP_ADDR_ECHO,
+					      opts->addr_id);
+		memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
+		ptr += 1;
+		if (opts->ahmac) {
+			put_unaligned_be64(opts->ahmac, ptr);
+			ptr += 2;
+		}
+	}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
+		if (opts->ahmac)
+			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+					      TCPOLEN_MPTCP_ADD_ADDR6, 0,
+					      opts->addr_id);
+		else
+			*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+					      TCPOLEN_MPTCP_ADD_ADDR6_BASE,
+					      MPTCP_ADDR_ECHO,
+					      opts->addr_id);
+		memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
+		ptr += 4;
+		if (opts->ahmac) {
+			put_unaligned_be64(opts->ahmac, ptr);
+			ptr += 2;
+		}
+	}
+#endif
+
+	if (OPTION_MPTCP_RM_ADDR & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_RM_ADDR,
+				      TCPOLEN_MPTCP_RM_ADDR_BASE,
+				      0, opts->rm_id);
+	}
+
 	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
 		u8 len = TCPOLEN_MPTCP_DSS_BASE;
@@ -567,10 +760,7 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				flags |= MPTCP_DSS_DATA_FIN;
 		}
 
-		*ptr++ = htonl((TCPOPT_MPTCP << 24) |
-			       (len  << 16) |
-			       (MPTCPOPT_DSS << 12) |
-			       (flags));
+		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
 
 		if (mpext->use_ack) {
 			put_unaligned_be64(mpext->data_ack, ptr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index eb3f65264a40..471e013d1c32 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -17,6 +17,9 @@
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
 #define OPTION_MPTCP_MPC_ACK	BIT(2)
+#define OPTION_MPTCP_ADD_ADDR	BIT(6)
+#define OPTION_MPTCP_ADD_ADDR6	BIT(7)
+#define OPTION_MPTCP_RM_ADDR	BIT(8)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -39,6 +42,16 @@
 #define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
+#define TCPOLEN_MPTCP_ADD_ADDR		16
+#define TCPOLEN_MPTCP_ADD_ADDR_PORT	18
+#define TCPOLEN_MPTCP_ADD_ADDR_BASE	8
+#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	10
+#define TCPOLEN_MPTCP_ADD_ADDR6		28
+#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	30
+#define TCPOLEN_MPTCP_ADD_ADDR6_BASE	20
+#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
+#define TCPOLEN_MPTCP_PORT_LEN		2
+#define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -55,10 +68,22 @@
 #define MPTCP_DSS_HAS_ACK	BIT(0)
 #define MPTCP_DSS_FLAG_MASK	(0x1F)
 
+/* MPTCP ADD_ADDR flags */
+#define MPTCP_ADDR_ECHO		BIT(0)
+#define MPTCP_ADDR_HMAC_LEN	20
+#define MPTCP_ADDR_IPVERSION_4	4
+#define MPTCP_ADDR_IPVERSION_6	6
+
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	0
 #define MPTCP_SEND_SPACE	1
 
+static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
+{
+	return htonl((TCPOPT_MPTCP << 24) | (len << 16) | (subopt << 12) |
+		     ((nib & 0xF) << 8) | field);
+}
+
 /* MPTCP connection sock */
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
@@ -219,8 +244,7 @@ static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
 	mptcp_crypto_key_sha(*key, token, idsn);
 }
 
-void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
-			   void *hash_out);
+void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {
-- 
2.26.0

