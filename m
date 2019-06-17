Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CE249587
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfFQW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfFQW66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:52 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 32/33] mptcp: Add ADD_ADDR handling
Date:   Mon, 17 Jun 2019 15:58:07 -0700
Message-Id: <20190617225808.665-33-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
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
 include/linux/tcp.h  | 11 +++++
 include/net/mptcp.h  | 16 ++++++--
 net/mptcp/options.c  | 98 +++++++++++++++++++++++++++++++++++++++-----
 net/mptcp/pm.c       | 11 ++++-
 net/mptcp/protocol.h | 16 ++++++++
 5 files changed, 138 insertions(+), 14 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 81cfa7834111..b1d2ff2af0c2 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -122,6 +122,16 @@ struct tcp_options_received {
 			use_ack:1,
 			ack64:1,
 			__unused:2;
+		u8	add_addr : 1,
+			rm_addr : 1,
+			family : 4;
+		u8	addr_id;
+		union {
+			struct	in_addr	addr;
+#if IS_ENABLED(CONFIG_IPV6)
+			struct	in6_addr addr6;
+#endif
+		};
 	} mptcp;
 #endif
 };
@@ -135,6 +145,7 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	rx_opt->mptcp.mp_capable = rx_opt->mptcp.mp_join = 0;
+	rx_opt->mptcp.add_addr = rx_opt->mptcp.rm_addr = 0;
 	rx_opt->mptcp.dss = 0;
 #endif
 }
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index ecc45733d8cf..92c630a25666 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -25,15 +25,25 @@ struct mptcp_ext {
 };
 
 /* MPTCP option subtypes */
-#define OPTION_MPTCP_MPC_SYN	BIT(0)
-#define OPTION_MPTCP_MPC_SYNACK	BIT(1)
-#define OPTION_MPTCP_MPC_ACK	BIT(2)
+#define OPTION_MPTCP_MPC_SYN		BIT(0)
+#define OPTION_MPTCP_MPC_SYNACK		BIT(1)
+#define OPTION_MPTCP_MPC_ACK		BIT(2)
+#define OPTION_MPTCP_ADD_ADDR		BIT(6)
+#define OPTION_MPTCP_ADD_ADDR6		BIT(7)
+#define OPTION_MPTCP_RM_ADDR		BIT(8)
 
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
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
index 6c5aed6351b3..68d0b4bec1dd 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -160,12 +160,51 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
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
+			mp_opt->addr.s_addr = get_unaligned_be32(ptr);
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
 
-	/* MPTCPOPT_REMOVE_ADDR
+	/* MPTCPOPT_RM_ADDR
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
@@ -336,27 +375,47 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
+static bool mptcp_established_options_addr(struct sock *sk,
+					   unsigned int *size,
+					   unsigned int remaining,
+					   struct mptcp_out_options *opts)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	if (subflow->fourth_ack)
+		return pm_addr_signal(msk, size, remaining, opts);
+
+	return false;
+}
+
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
 	unsigned int opt_size = 0;
+	bool ret = false;
 
 	if (!subflow_ctx(sk)->mp_capable)
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
@@ -427,10 +486,8 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
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
@@ -440,6 +497,27 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		}
 	}
 
+	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR, TCPOLEN_MPTCP_ADD_ADDR,
+				      MPTCP_ADDR_IPVERSION_4, opts->addr_id);
+		*ptr++ = htonl(opts->addr.s_addr);
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
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 512dc110098a..9e9c681a4544 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -51,7 +51,16 @@ void pm_rm_addr(struct mptcp_sock *msk, u8 id)
 bool pm_addr_signal(struct mptcp_sock *msk, unsigned int *size,
 		    unsigned int remaining, struct mptcp_out_options *opts)
 {
+	if (!msk || !msk->addr_signal)
+		return false;
+
+	if (msk->pm.family == AF_INET && remaining < TCPOLEN_MPTCP_ADD_ADDR)
+		return false;
+
 	pr_debug("msk=%p", msk);
+	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
+	opts->addr_id = msk->pm.addr_id;
+	opts->addr.s_addr = msk->pm.addr.s_addr;
 
-	return false;
+	return true;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 044665328b79..4e4c8fc59972 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -8,6 +8,7 @@
 #define __MPTCP_PROTOCOL_H
 
 #include <linux/spinlock.h>
+#include <net/tcp.h>
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -29,6 +30,9 @@
 #define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
+#define TCPOLEN_MPTCP_ADD_ADDR		8
+#define TCPOLEN_MPTCP_ADD_ADDR6		20
+#define TCPOLEN_MPTCP_RM_ADDR		4
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -45,6 +49,17 @@
 #define MPTCP_DSS_HAS_ACK	BIT(0)
 #define MPTCP_DSS_FLAG_MASK	(0x1F)
 
+/* MPTCP ADD_ADDR flags */
+#define MPTCP_ADDR_FAMILY_MASK	(0x0F)
+#define MPTCP_ADDR_IPVERSION_4	4
+#define MPTCP_ADDR_IPVERSION_6	6
+
+static inline u32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
+{
+	return htonl((TCPOPT_MPTCP << 24) | (len << 16) | (subopt << 12) |
+		     ((nib & 0xF) << 8) | field);
+}
+
 struct pm_data {
 	u8 addr_id;
 	sa_family_t family;
@@ -68,6 +83,7 @@ struct mptcp_sock {
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct pm_data	pm;
+	u8		addr_signal;
 };
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
-- 
2.22.0

