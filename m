Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB7C94F0
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfJBXhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbfJBXhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862620"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 27/45] mptcp: Add ADD_ADDR handling
Date:   Wed,  2 Oct 2019 16:36:37 -0700
Message-Id: <20191002233655.24323-28-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add handling for sending and receiving the ADD_ADDR, ADD_ADDR6,
and RM_ADDR suboptions.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/linux/tcp.h  |   2 +
 include/net/mptcp.h  |   7 +++
 net/mptcp/options.c  | 115 +++++++++++++++++++++++++++++++++++++++----
 net/mptcp/protocol.h |  16 +++++-
 4 files changed, 130 insertions(+), 10 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 31e546fe9643..b3289e69cac1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -118,6 +118,7 @@ struct tcp_options_received {
 			ack64:1,
 			__unused:2;
 		u8	add_addr : 1,
+			rm_addr : 1,
 			family : 4;
 		u8	addr_id;
 		union {
@@ -139,6 +140,7 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	rx_opt->mptcp.mp_capable = rx_opt->mptcp.mp_join = 0;
+	rx_opt->mptcp.add_addr = rx_opt->mptcp.rm_addr = 0;
 	rx_opt->mptcp.dss = 0;
 #endif
 }
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 21438bcacb14..f4a9962ea85f 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -29,6 +29,13 @@ struct mptcp_out_options {
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
+	union {
+		struct in_addr addr;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr addr6;
+#endif
+	};
+	u8 addr_id;
 	struct mptcp_ext ext_copy;
 #endif
 };
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 2981c0daa12c..6fd2c8b5001c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -173,12 +173,51 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 	 * 4 or 16 bytes of address (depending on ip version)
 	 * 0 or 2 bytes of port (depending on length)
 	 */
+	case MPTCPOPT_ADD_ADDR:
+		if (opsize != TCPOLEN_MPTCP_ADD_ADDR &&
+		    opsize != TCPOLEN_MPTCP_ADD_ADDR6)
+			break;
+		mp_opt->family = *ptr++ & MPTCP_ADDR_FAMILY_MASK;
+		if (mp_opt->family != MPTCP_ADDR_IPVERSION_4 &&
+		    mp_opt->family != MPTCP_ADDR_IPVERSION_6)
+			break;
+
+		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4 &&
+		    opsize != TCPOLEN_MPTCP_ADD_ADDR)
+			break;
+#if IS_ENABLED(CONFIG_IPV6)
+		if (mp_opt->family == MPTCP_ADDR_IPVERSION_6 &&
+		    opsize != TCPOLEN_MPTCP_ADD_ADDR6)
+			break;
+#endif
+		mp_opt->addr_id = *ptr++;
+		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
+			mp_opt->add_addr = 1;
+			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
+			pr_debug("ADD_ADDR: addr=%x, id=%d",
+				 mp_opt->addr.s_addr, mp_opt->addr_id);
+#if IS_ENABLED(CONFIG_IPV6)
+		} else {
+			mp_opt->add_addr = 1;
+			memcpy(mp_opt->addr6.s6_addr, (u8 *)ptr, 16);
+			pr_debug("ADD_ADDR: addr6=, id=%d", mp_opt->addr_id);
+#endif
+		}
+		break;
 
 	/* MPTCPOPT_RM_ADDR
 	 * 0: 4MSB=subtype, 0000
 	 * 1: Address ID
 	 * Additional bytes: More address IDs (depending on length)
 	 */
+	case MPTCPOPT_RM_ADDR:
+		if (opsize != TCPOLEN_MPTCP_RM_ADDR)
+			break;
+
+		mp_opt->rm_addr = 1;
+		mp_opt->addr_id = *ptr++;
+		pr_debug("RM_ADDR: id=%d", mp_opt->addr_id);
+		break;
 
 	/* MPTCPOPT_MP_PRIO
 	 * 0: 4MSB=subtype, 000, 1LSB=Backup
@@ -352,27 +391,65 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
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
+	if (!msk)
+		return false;
+
+	if (!msk->pm.fully_established || !msk->addr_signal)
+		return false;
+
+	if (pm_addr_signal(msk, &id, &saddr))
+		return false;
+
+	if (saddr.ss_family == AF_INET && remaining < TCPOLEN_MPTCP_ADD_ADDR)
+		return false;
+
+	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
+	opts->addr_id = id;
+	opts->addr.s_addr = ((struct sockaddr_in *)&saddr)->sin_addr.s_addr;
+	*size = TCPOLEN_MPTCP_ADD_ADDR;
+
+	msk->addr_signal = 0;
+
+	return true;
+}
+
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
 	unsigned int opt_size = 0;
+	bool ret = false;
 
 	if (!mptcp_subflow_ctx(sk)->mp_capable)
 		return false;
 
+	opts->suboptions = 0;
 	if (mptcp_established_options_mp(sk, &opt_size, remaining, opts)) {
 		*size += opt_size;
 		remaining -= opt_size;
-		return true;
+		ret = true;
 	} else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
-					       opts)) {
+						 opts)) {
 		*size += opt_size;
 		remaining -= opt_size;
-		return true;
+		ret = true;
 	}
-
-	return false;
+	if (mptcp_established_options_addr(sk, &opt_size, remaining, opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		ret = true;
+	}
+	return ret;
 }
 
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
@@ -459,10 +536,8 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		else
 			len = TCPOLEN_MPTCP_MPC_ACK;
 
-		*ptr++ = htonl((TCPOPT_MPTCP << 24) | (len << 16) |
-			       (MPTCPOPT_MP_CAPABLE << 12) |
-			       ((MPTCP_VERSION_MASK & 0) << 8) |
-			       MPTCP_CAP_HMAC_SHA1);
+		*ptr++ = mptcp_option(MPTCPOPT_MP_CAPABLE, len, 0,
+				      MPTCP_CAP_HMAC_SHA1);
 		put_unaligned_be64(opts->sndr_key, ptr);
 		ptr += 2;
 		if ((OPTION_MPTCP_MPC_SYNACK |
@@ -472,6 +547,28 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		}
 	}
 
+	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR, TCPOLEN_MPTCP_ADD_ADDR,
+				      MPTCP_ADDR_IPVERSION_4, opts->addr_id);
+		memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
+		ptr += 1;
+	}
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
+				      TCPOLEN_MPTCP_ADD_ADDR6,
+				      MPTCP_ADDR_IPVERSION_6, opts->addr_id);
+		memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
+		ptr += 4;
+	}
+#endif
+
+	if (OPTION_MPTCP_RM_ADDR & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_RM_ADDR, TCPOLEN_MPTCP_RM_ADDR,
+				      0, opts->addr_id);
+	}
+
 	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
 		u8 len = TCPOLEN_MPTCP_DSS_BASE;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 599c380145e3..fd21ed6c03b7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -8,13 +8,16 @@
 #define __MPTCP_PROTOCOL_H
 
 #include <linux/random.h>
-#include <linux/tcp.h>
+#include <net/tcp.h>
 #include <net/inet_connection_sock.h>
 
 /* MPTCP option bits */
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
 #define OPTION_MPTCP_MPC_ACK	BIT(2)
+#define OPTION_MPTCP_ADD_ADDR	BIT(6)
+#define OPTION_MPTCP_ADD_ADDR6	BIT(7)
+#define OPTION_MPTCP_RM_ADDR	BIT(8)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -36,6 +39,9 @@
 #define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
+#define TCPOLEN_MPTCP_ADD_ADDR		8
+#define TCPOLEN_MPTCP_ADD_ADDR6		20
+#define TCPOLEN_MPTCP_RM_ADDR		4
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -53,9 +59,16 @@
 #define MPTCP_DSS_FLAG_MASK	(0x1F)
 
 /* MPTCP ADD_ADDR flags */
+#define MPTCP_ADDR_FAMILY_MASK	(0x0F)
 #define MPTCP_ADDR_IPVERSION_4	4
 #define MPTCP_ADDR_IPVERSION_6	6
 
+static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
+{
+	return htonl((TCPOPT_MPTCP << 24) | (len << 16) | (subopt << 12) |
+		     ((nib & 0xF) << 8) | field);
+}
+
 struct mptcp_pm_data {
 	u8	local_valid;
 	u8	local_id;
@@ -96,6 +109,7 @@ struct mptcp_sock {
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct mptcp_pm_data	pm;
+	u8		addr_signal;
 };
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
-- 
2.23.0

