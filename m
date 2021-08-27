Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCF3F9160
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 02:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbhH0Apu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:45:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:46997 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243831AbhH0Apu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:45:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="240080598"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="240080598"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="599007127"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.68.199])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/5] mptcp: better binary layout for mptcp_options_received
Date:   Thu, 26 Aug 2021 17:44:51 -0700
Message-Id: <20210827004455.286754-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
References: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This change reorder the mptcp_options_received fields
to shrink the structure a bit and to ensure the most
frequently used fields are all in the first cacheline.

Sub-opt specific flags are moved out of the suboptions area,
and we must now explicitly set them when the relevant
suboption is parsed.

There is a notable exception: 'csum_reqd' is used by both DSS
and MPC suboptions, and keeping such field in the suboptions
flag area will simplfy the next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  8 +++-----
 net/mptcp/protocol.h | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f012a71dd996..79b68ae9ef4d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -83,8 +83,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		if (flags & MPTCP_CAP_CHECKSUM_REQD)
 			mp_opt->csum_reqd = 1;
 
-		if (flags & MPTCP_CAP_DENY_JOIN_ID0)
-			mp_opt->deny_join_id0 = 1;
+		mp_opt->deny_join_id0 = !!(flags & MPTCP_CAP_DENY_JOIN_ID0);
 
 		mp_opt->mp_capable = 1;
 		if (opsize >= TCPOLEN_MPTCP_MPC_SYNACK) {
@@ -262,6 +261,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 		mp_opt->add_addr = 1;
 		mp_opt->addr.id = *ptr++;
+		mp_opt->addr.port = 0;
+		mp_opt->ahmac = 0;
 		if (mp_opt->addr.family == AF_INET) {
 			memcpy((u8 *)&mp_opt->addr.addr.s_addr, (u8 *)ptr, 4);
 			ptr += 4;
@@ -363,15 +364,12 @@ void mptcp_get_options(const struct sock *sk,
 	mp_opt->mp_capable = 0;
 	mp_opt->mp_join = 0;
 	mp_opt->add_addr = 0;
-	mp_opt->ahmac = 0;
 	mp_opt->fastclose = 0;
-	mp_opt->addr.port = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
 	mp_opt->mp_prio = 0;
 	mp_opt->reset = 0;
 	mp_opt->csum_reqd = 0;
-	mp_opt->deny_join_id0 = 0;
 	mp_opt->mp_fail = 0;
 
 	length = (th->doff * 4) - sizeof(struct tcphdr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 57a50b1194a9..9a0d91f92bbc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -140,28 +140,28 @@ struct mptcp_options_received {
 		add_addr : 1,
 		rm_addr : 1,
 		mp_prio : 1,
-		mp_fail : 1,
-		echo : 1,
 		csum_reqd : 1,
-		backup : 1,
-		deny_join_id0 : 1;
+		mp_fail : 1;
 	u32	token;
 	u32	nonce;
-	u64	thmac;
-	u8	hmac[MPTCPOPT_HMAC_LEN];
-	u8	join_id;
-	u8	use_map:1,
+	u16	use_map:1,
 		dsn64:1,
 		data_fin:1,
 		use_ack:1,
 		ack64:1,
 		mpc_map:1,
+		reset_reason:4,
+		reset_transient:1,
+		echo:1,
+		backup:1,
+		deny_join_id0:1,
 		__unused:2;
+	u8	join_id;
+	u64	thmac;
+	u8	hmac[MPTCPOPT_HMAC_LEN];
 	struct mptcp_addr_info addr;
 	struct mptcp_rm_list rm_list;
 	u64	ahmac;
-	u8	reset_reason:4;
-	u8	reset_transient:1;
 	u64	fail_seq;
 };
 
-- 
2.33.0

