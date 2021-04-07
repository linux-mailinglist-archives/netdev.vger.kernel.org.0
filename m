Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD8356018
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbhDGARK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:17:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:23778 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347451AbhDGAQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:39 -0400
IronPort-SDR: //Dyn6ETM/wUVft7ZATb9z3vedC3CIxmjrYKnb78fKBoI7X9EUilKwmZCcXWlp2m26ySG+9SNs
 vddKKXEo5Akw==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297256"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297256"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
IronPort-SDR: p0Fy8fuf9kqRwWHRPV2JCvoWkJwdyDp4/we7U+9BadA4rgUnkl7Ho5RY7EIeWuHdIhQlmChjx0
 aHaqb4aYYQfw==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105199"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: use mptcp_addr_info in mptcp_options_received
Date:   Tue,  6 Apr 2021 17:16:00 -0700
Message-Id: <20210407001604.85071-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new struct mptcp_addr_info member addr in struct
mptcp_options_received, and dropped the original family, addr_id, addr,
addr6 and port fields in it. Then we can pass the parameter mp_opt.addr
directly to mptcp_pm_add_addr_received and mptcp_pm_add_addr_echoed.

Since the port number became big-endian now, use htons to convert the
incoming port number to it. Also use ntohs to convert it when passing
it to add_addr_generate_hmac or printing it out.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 58 +++++++++++++++++---------------------------
 net/mptcp/protocol.h | 10 +-------
 2 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3a4c939b3aff..8d28f2e0de82 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -220,45 +220,45 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		if (!mp_opt->echo) {
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR ||
 			    opsize == TCPOLEN_MPTCP_ADD_ADDR_PORT)
-				mp_opt->family = MPTCP_ADDR_IPVERSION_4;
+				mp_opt->addr.family = MPTCP_ADDR_IPVERSION_4;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 			else if (opsize == TCPOLEN_MPTCP_ADD_ADDR6 ||
 				 opsize == TCPOLEN_MPTCP_ADD_ADDR6_PORT)
-				mp_opt->family = MPTCP_ADDR_IPVERSION_6;
+				mp_opt->addr.family = MPTCP_ADDR_IPVERSION_6;
 #endif
 			else
 				break;
 		} else {
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE ||
 			    opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT)
-				mp_opt->family = MPTCP_ADDR_IPVERSION_4;
+				mp_opt->addr.family = MPTCP_ADDR_IPVERSION_4;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 			else if (opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE ||
 				 opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT)
-				mp_opt->family = MPTCP_ADDR_IPVERSION_6;
+				mp_opt->addr.family = MPTCP_ADDR_IPVERSION_6;
 #endif
 			else
 				break;
 		}
 
 		mp_opt->add_addr = 1;
-		mp_opt->addr_id = *ptr++;
-		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
-			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
+		mp_opt->addr.id = *ptr++;
+		if (mp_opt->addr.family == MPTCP_ADDR_IPVERSION_4) {
+			memcpy((u8 *)&mp_opt->addr.addr.s_addr, (u8 *)ptr, 4);
 			ptr += 4;
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR_PORT ||
 			    opsize == TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT) {
-				mp_opt->port = get_unaligned_be16(ptr);
+				mp_opt->addr.port = htons(get_unaligned_be16(ptr));
 				ptr += 2;
 			}
 		}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 		else {
-			memcpy(mp_opt->addr6.s6_addr, (u8 *)ptr, 16);
+			memcpy(mp_opt->addr.addr6.s6_addr, (u8 *)ptr, 16);
 			ptr += 16;
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR6_PORT ||
 			    opsize == TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT) {
-				mp_opt->port = get_unaligned_be16(ptr);
+				mp_opt->addr.port = htons(get_unaligned_be16(ptr));
 				ptr += 2;
 			}
 		}
@@ -268,8 +268,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			ptr += 8;
 		}
 		pr_debug("ADD_ADDR%s: id=%d, ahmac=%llu, echo=%d, port=%d",
-			 (mp_opt->family == MPTCP_ADDR_IPVERSION_6) ? "6" : "",
-			 mp_opt->addr_id, mp_opt->ahmac, mp_opt->echo, mp_opt->port);
+			 (mp_opt->addr.family == MPTCP_ADDR_IPVERSION_6) ? "6" : "",
+			 mp_opt->addr.id, mp_opt->ahmac, mp_opt->echo, ntohs(mp_opt->addr.port));
 		break;
 
 	case MPTCPOPT_RM_ADDR:
@@ -335,7 +335,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 	mp_opt->add_addr = 0;
 	mp_opt->ahmac = 0;
 	mp_opt->fastclose = 0;
-	mp_opt->port = 0;
+	mp_opt->addr.port = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
 	mp_opt->mp_prio = 0;
@@ -991,17 +991,17 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 	if (mp_opt->echo)
 		return true;
 
-	if (mp_opt->family == MPTCP_ADDR_IPVERSION_4)
+	if (mp_opt->addr.family == MPTCP_ADDR_IPVERSION_4)
 		hmac = add_addr_generate_hmac(msk->remote_key,
 					      msk->local_key,
-					      mp_opt->addr_id, &mp_opt->addr,
-					      mp_opt->port);
+					      mp_opt->addr.id, &mp_opt->addr.addr,
+					      ntohs(mp_opt->addr.port));
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else
 		hmac = add_addr6_generate_hmac(msk->remote_key,
 					       msk->local_key,
-					       mp_opt->addr_id, &mp_opt->addr6,
-					       mp_opt->port);
+					       mp_opt->addr.id, &mp_opt->addr.addr6,
+					       ntohs(mp_opt->addr.port));
 #endif
 
 	pr_debug("msk=%p, ahmac=%llu, mp_opt->ahmac=%llu\n",
@@ -1043,30 +1043,16 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (mp_opt.add_addr && add_addr_hmac_valid(msk, &mp_opt)) {
-		struct mptcp_addr_info addr;
-
-		addr.port = htons(mp_opt.port);
-		addr.id = mp_opt.addr_id;
-		if (mp_opt.family == MPTCP_ADDR_IPVERSION_4) {
-			addr.family = AF_INET;
-			addr.addr = mp_opt.addr;
-		}
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		else if (mp_opt.family == MPTCP_ADDR_IPVERSION_6) {
-			addr.family = AF_INET6;
-			addr.addr6 = mp_opt.addr6;
-		}
-#endif
 		if (!mp_opt.echo) {
-			mptcp_pm_add_addr_received(msk, &addr);
+			mptcp_pm_add_addr_received(msk, &mp_opt.addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
 		} else {
-			mptcp_pm_add_addr_echoed(msk, &addr);
-			mptcp_pm_del_add_timer(msk, &addr);
+			mptcp_pm_add_addr_echoed(msk, &mp_opt.addr);
+			mptcp_pm_del_add_timer(msk, &mp_opt.addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
 		}
 
-		if (mp_opt.port)
+		if (mp_opt.addr.port)
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_PORTADD);
 
 		mp_opt.add_addr = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7c5fd06ceaf2..ca3013facbba 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -133,7 +133,6 @@ struct mptcp_options_received {
 		add_addr : 1,
 		rm_addr : 1,
 		mp_prio : 1,
-		family : 4,
 		echo : 1,
 		backup : 1;
 	u32	token;
@@ -148,16 +147,9 @@ struct mptcp_options_received {
 		ack64:1,
 		mpc_map:1,
 		__unused:2;
-	u8	addr_id;
+	struct mptcp_addr_info addr;
 	struct mptcp_rm_list rm_list;
-	union {
-		struct in_addr	addr;
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		struct in6_addr	addr6;
-#endif
-	};
 	u64	ahmac;
-	u16	port;
 	u8	reset_reason:4;
 	u8	reset_transient:1;
 };
-- 
2.31.1

