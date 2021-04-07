Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC38356008
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347412AbhDGAQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:16:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:23778 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347459AbhDGAQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:20 -0400
IronPort-SDR: m4Scq3UolWcYL/34BGz7YdNe63kSFvmd7XpzS9pbjQCz13hqEeSsELBmXmfDVQEw/RSu4Ek56a
 Bf2gWaM0mOhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297252"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297252"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
IronPort-SDR: zeEp1m/0Wdv3F26+yN42k10ZuDtJCeTnzayeb4bEkvCqgHBijUW//SoD+6UcWESiVsfdFCUS8O
 iX07qD9X0Etg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105195"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] mptcp: use mptcp_addr_info in mptcp_out_options
Date:   Tue,  6 Apr 2021 17:15:58 -0700
Message-Id: <20210407001604.85071-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch moved the mptcp_addr_info struct from protocol.h to mptcp.h,
added a new struct mptcp_addr_info member addr in struct mptcp_out_options,
and dropped the original addr, addr6, addr_id and port fields in it. Then
we can use opts->addr to get the adding address from PM directly using
mptcp_pm_add_addr_signal.

Since the port number became big-endian now, use ntohs to convert it
before sending it out with the ADD_ADDR suboption. Also convert it
when passing it to add_addr_generate_hmac or printing it out.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  | 21 +++++++++++++--------
 net/mptcp/options.c  | 44 ++++++++++++++++++++------------------------
 net/mptcp/protocol.h | 12 ------------
 3 files changed, 33 insertions(+), 44 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 16fe34d139c3..83f23774b908 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -41,20 +41,25 @@ struct mptcp_rm_list {
 	u8 nr;
 };
 
+struct mptcp_addr_info {
+	u8			id;
+	sa_family_t		family;
+	__be16			port;
+	union {
+		struct in_addr	addr;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		struct in6_addr	addr6;
+#endif
+	};
+};
+
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
-	union {
-		struct in_addr addr;
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		struct in6_addr addr6;
-#endif
-	};
-	u8 addr_id;
-	u16 port;
 	u64 ahmac;
+	struct mptcp_addr_info addr;
 	struct mptcp_rm_list rm_list;
 	u8 join_id;
 	u8 backup;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4b7119eb2c31..352c128337a7 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -626,7 +626,6 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	bool drop_other_suboptions = false;
 	unsigned int opt_size = *size;
-	struct mptcp_addr_info saddr;
 	bool echo;
 	bool port;
 	int len;
@@ -643,45 +642,40 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	}
 
 	if (!mptcp_pm_should_add_signal(msk) ||
-	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr, &echo, &port)))
+	    !(mptcp_pm_add_addr_signal(msk, remaining, &opts->addr, &echo, &port)))
 		return false;
 
-	len = mptcp_add_addr_len(saddr.family, echo, port);
+	len = mptcp_add_addr_len(opts->addr.family, echo, port);
 	if (remaining < len)
 		return false;
 
 	*size = len;
 	if (drop_other_suboptions)
 		*size -= opt_size;
-	opts->addr_id = saddr.id;
-	if (port)
-		opts->port = ntohs(saddr.port);
-	if (saddr.family == AF_INET) {
+	if (opts->addr.family == AF_INET) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
-		opts->addr = saddr.addr;
 		if (!echo) {
 			opts->ahmac = add_addr_generate_hmac(msk->local_key,
 							     msk->remote_key,
-							     opts->addr_id,
-							     &opts->addr,
-							     opts->port);
+							     opts->addr.id,
+							     &opts->addr.addr,
+							     ntohs(opts->addr.port));
 		}
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else if (saddr.family == AF_INET6) {
+	else if (opts->addr.family == AF_INET6) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR6;
-		opts->addr6 = saddr.addr6;
 		if (!echo) {
 			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
 							      msk->remote_key,
-							      opts->addr_id,
-							      &opts->addr6,
-							      opts->port);
+							      opts->addr.id,
+							      &opts->addr.addr6,
+							      ntohs(opts->addr.port));
 		}
 	}
 #endif
 	pr_debug("addr_id=%d, ahmac=%llu, echo=%d, port=%d",
-		 opts->addr_id, opts->ahmac, echo, opts->port);
+		 opts->addr.id, opts->ahmac, echo, ntohs(opts->addr.port));
 
 	return true;
 }
@@ -1217,7 +1211,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 #endif
 
-		if (opts->port)
+		if (opts->addr.port)
 			len += TCPOLEN_MPTCP_PORT_LEN;
 
 		if (opts->ahmac) {
@@ -1226,28 +1220,30 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		}
 
 		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
-				      len, echo, opts->addr_id);
+				      len, echo, opts->addr.id);
 		if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
-			memcpy((u8 *)ptr, (u8 *)&opts->addr.s_addr, 4);
+			memcpy((u8 *)ptr, (u8 *)&opts->addr.addr.s_addr, 4);
 			ptr += 1;
 		}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 		else if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
-			memcpy((u8 *)ptr, opts->addr6.s6_addr, 16);
+			memcpy((u8 *)ptr, opts->addr.addr6.s6_addr, 16);
 			ptr += 4;
 		}
 #endif
 
-		if (!opts->port) {
+		if (!opts->addr.port) {
 			if (opts->ahmac) {
 				put_unaligned_be64(opts->ahmac, ptr);
 				ptr += 2;
 			}
 		} else {
+			u16 port = ntohs(opts->addr.port);
+
 			if (opts->ahmac) {
 				u8 *bptr = (u8 *)ptr;
 
-				put_unaligned_be16(opts->port, bptr);
+				put_unaligned_be16(port, bptr);
 				bptr += 2;
 				put_unaligned_be64(opts->ahmac, bptr);
 				bptr += 8;
@@ -1256,7 +1252,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 				ptr += 3;
 			} else {
-				put_unaligned_be32(opts->port << 16 |
+				put_unaligned_be32(port << 16 |
 						   TCPOPT_NOP << 8 |
 						   TCPOPT_NOP, ptr);
 				ptr += 1;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index cb5dad522f39..4890dbb9f710 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -169,18 +169,6 @@ static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 		     ((nib & 0xF) << 8) | field);
 }
 
-struct mptcp_addr_info {
-	sa_family_t		family;
-	__be16			port;
-	u8			id;
-	union {
-		struct in_addr addr;
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		struct in6_addr addr6;
-#endif
-	};
-};
-
 enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_RECEIVED,
 	MPTCP_PM_ADD_ADDR_SEND_ACK,
-- 
2.31.1

