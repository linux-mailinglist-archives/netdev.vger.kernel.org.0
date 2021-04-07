Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC0356016
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347502AbhDGARI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:17:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:23803 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347445AbhDGAQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:38 -0400
IronPort-SDR: aHxTq8hq6kpIypVXucdN0Z5AM3RH17gsAbTaUnyg3du7TQ/gjd2nkh6JqZFiFEAkvccBAE7vSS
 4khHyV86O+2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297254"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
IronPort-SDR: usLQ/0JQhXLu7GLCT0ny/wNYZfPRE/46eV1B06z0SREeCP57ZzCdK1ZVmtOb9lgVJrxTN3h2iN
 HjUQP8UylyHw==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105196"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/8] mptcp: drop OPTION_MPTCP_ADD_ADDR6
Date:   Tue,  6 Apr 2021 17:15:59 -0700
Message-Id: <20210407001604.85071-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Since the family field was added in struct mptcp_out_options, no need to
use OPTION_MPTCP_ADD_ADDR6 to identify the IPv6 address. Drop it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 15 +++++----------
 net/mptcp/protocol.h |  9 ++++-----
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 352c128337a7..3a4c939b3aff 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -652,8 +652,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	*size = len;
 	if (drop_other_suboptions)
 		*size -= opt_size;
+	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 	if (opts->addr.family == AF_INET) {
-		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 		if (!echo) {
 			opts->ahmac = add_addr_generate_hmac(msk->local_key,
 							     msk->remote_key,
@@ -664,7 +664,6 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else if (opts->addr.family == AF_INET6) {
-		opts->suboptions |= OPTION_MPTCP_ADD_ADDR6;
 		if (!echo) {
 			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
 							      msk->remote_key,
@@ -1198,16 +1197,12 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	}
 
 mp_capable_done:
-	if ((OPTION_MPTCP_ADD_ADDR
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	     | OPTION_MPTCP_ADD_ADDR6
-#endif
-	    ) & opts->suboptions) {
+	if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
 		u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
 		u8 echo = MPTCP_ADDR_ECHO;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions)
+		if (opts->addr.family == AF_INET6)
 			len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 #endif
 
@@ -1221,12 +1216,12 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 
 		*ptr++ = mptcp_option(MPTCPOPT_ADD_ADDR,
 				      len, echo, opts->addr.id);
-		if (OPTION_MPTCP_ADD_ADDR & opts->suboptions) {
+		if (opts->addr.family == AF_INET) {
 			memcpy((u8 *)ptr, (u8 *)&opts->addr.addr.s_addr, 4);
 			ptr += 1;
 		}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		else if (OPTION_MPTCP_ADD_ADDR6 & opts->suboptions) {
+		else if (opts->addr.family == AF_INET6) {
 			memcpy((u8 *)ptr, opts->addr.addr6.s6_addr, 16);
 			ptr += 4;
 		}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4890dbb9f710..7c5fd06ceaf2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -22,11 +22,10 @@
 #define OPTION_MPTCP_MPJ_SYNACK	BIT(4)
 #define OPTION_MPTCP_MPJ_ACK	BIT(5)
 #define OPTION_MPTCP_ADD_ADDR	BIT(6)
-#define OPTION_MPTCP_ADD_ADDR6	BIT(7)
-#define OPTION_MPTCP_RM_ADDR	BIT(8)
-#define OPTION_MPTCP_FASTCLOSE	BIT(9)
-#define OPTION_MPTCP_PRIO	BIT(10)
-#define OPTION_MPTCP_RST	BIT(11)
+#define OPTION_MPTCP_RM_ADDR	BIT(7)
+#define OPTION_MPTCP_FASTCLOSE	BIT(8)
+#define OPTION_MPTCP_PRIO	BIT(9)
+#define OPTION_MPTCP_RST	BIT(10)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
-- 
2.31.1

