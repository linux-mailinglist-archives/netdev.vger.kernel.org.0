Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905F93ABFB0
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhFQXso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:13468 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhFQXsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:38 -0400
IronPort-SDR: OqaJFZf7baZANDw3ZVmSat1rcNafxrev0KhzeqcWv5vsh96tHjt2mSLkt7nefxQQmUNoKkTvuY
 igxA4IRqsTOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506631"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506631"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
IronPort-SDR: CvkBEfLDzACp4ieQC5WF1iMcgqlxbQj+in/BlsR7oytxFrQ/kAgYEBER61H7rm6V005+sgdVwJ
 y+QMKd6/igvw==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943899"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/16] mptcp: add csum_reqd in mptcp_out_options
Date:   Thu, 17 Jun 2021 16:46:09 -0700
Message-Id: <20210617234622.472030-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member csum_reqd in struct mptcp_out_options and
struct mptcp_subflow_request_sock. Initialized it with the helper
function mptcp_is_checksum_enabled().

In mptcp_write_options, if this field is enabled, send out the MP_CAPABLE
suboption with the MPTCP_CAP_CHECKSUM_REQD flag.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |  5 +++--
 net/mptcp/options.c  | 11 +++++++++--
 net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  |  1 +
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 23bbd439e115..33af68eea96f 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -64,8 +64,9 @@ struct mptcp_out_options {
 	struct mptcp_rm_list rm_list;
 	u8 join_id;
 	u8 backup;
-	u8 reset_reason:4;
-	u8 reset_transient:1;
+	u8 reset_reason:4,
+	   reset_transient:1,
+	   csum_reqd:1;
 	u32 nonce;
 	u64 thmac;
 	u32 token;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 6b825fb3fa83..bb3a1f3b6e99 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -380,6 +380,7 @@ bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 	subflow->snd_isn = TCP_SKB_CB(skb)->end_seq;
 	if (subflow->request_mptcp) {
 		opts->suboptions = OPTION_MPTCP_MPC_SYN;
+		opts->csum_reqd = mptcp_is_checksum_enabled(sock_net(sk));
 		*size = TCPOLEN_MPTCP_MPC_SYN;
 		return true;
 	} else if (subflow->request_join) {
@@ -435,6 +436,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 					 struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct mptcp_ext *mpext;
 	unsigned int data_len;
 
@@ -465,6 +467,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		opts->suboptions = OPTION_MPTCP_MPC_ACK;
 		opts->sndr_key = subflow->local_key;
 		opts->rcvr_key = subflow->remote_key;
+		opts->csum_reqd = READ_ONCE(msk->csum_enabled);
 
 		/* Section 3.1.
 		 * The MP_CAPABLE option is carried on the SYN, SYN/ACK, and ACK
@@ -789,6 +792,7 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 	if (subflow_req->mp_capable) {
 		opts->suboptions = OPTION_MPTCP_MPC_SYNACK;
 		opts->sndr_key = subflow_req->local_key;
+		opts->csum_reqd = subflow_req->csum_reqd;
 		*size = TCPOLEN_MPTCP_MPC_SYNACK;
 		pr_debug("subflow_req=%p, local_key=%llu",
 			 subflow_req, subflow_req->local_key);
@@ -1123,7 +1127,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 {
 	if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
 	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
-		u8 len;
+		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
 
 		if (OPTION_MPTCP_MPC_SYN & opts->suboptions)
 			len = TCPOLEN_MPTCP_MPC_SYN;
@@ -1134,9 +1138,12 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		else
 			len = TCPOLEN_MPTCP_MPC_ACK;
 
+		if (opts->csum_reqd)
+			flag |= MPTCP_CAP_CHECKSUM_REQD;
+
 		*ptr++ = mptcp_option(MPTCPOPT_MP_CAPABLE, len,
 				      MPTCP_SUPPORTED_VERSION,
-				      MPTCP_CAP_HMAC_SHA256);
+				      flag);
 
 		if (!((OPTION_MPTCP_MPC_SYNACK | OPTION_MPTCP_MPC_ACK) &
 		    opts->suboptions))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4913ac7b6d19..09e94726e030 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -347,7 +347,8 @@ struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u16	mp_capable : 1,
 		mp_join : 1,
-		backup : 1;
+		backup : 1,
+		csum_reqd : 1;
 	u8	local_id;
 	u8	remote_id;
 	u64	local_key;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 33956337c46b..45acab63c387 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -108,6 +108,7 @@ static void subflow_init_req(struct request_sock *req, const struct sock *sk_lis
 
 	subflow_req->mp_capable = 0;
 	subflow_req->mp_join = 0;
+	subflow_req->csum_reqd = mptcp_is_checksum_enabled(sock_net(sk_listener));
 	subflow_req->msk = NULL;
 	mptcp_token_init_request(req);
 }
-- 
2.32.0

