Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806EA27DB70
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgI2WId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:08:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:6058 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgI2WI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:08:28 -0400
IronPort-SDR: TrgDFqkzjNlBjJ2iAmois41+1GuGFgvd8uiSn4oIa6+XnD9364zqYdq29ssEv8vyqu9ljQ+rT4
 BRhp8k+Owblg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223900089"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="223900089"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:26 -0700
IronPort-SDR: ceEg5L1dkXLjfia+VPgG//0ftQfmQ0XgzCu8oV3n4oZdBiWG0CYxvs/CsD3c07e3/Q/cYt5ugb
 L/Ys39g1wm+Q==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="312368805"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.88.125])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, pabeni@redhat.com
Subject: [PATCH net 2/2] mptcp: Handle incoming 32-bit DATA_FIN values
Date:   Tue, 29 Sep 2020 15:08:20 -0700
Message-Id: <20200929220820.278003-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
References: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The peer may send a DATA_FIN mapping with either a 32-bit or 64-bit
sequence number. When a 32-bit sequence number is received for the
DATA_FIN, it must be expanded to 64 bits before comparing it to the
last acked sequence number. This expansion was missing.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/93
Fixes: 3721b9b64676 (mptcp: Track received DATA_FIN sequence number and add related helpers)
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  7 ++++---
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  | 16 +++++++++++++---
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 120ef39fe589..afa486912f5a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -782,7 +782,7 @@ static void update_una(struct mptcp_sock *msk,
 	}
 }
 
-bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq)
+bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit)
 {
 	/* Skip if DATA_FIN was already received.
 	 * If updating simultaneously with the recvmsg loop, values
@@ -792,7 +792,8 @@ bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq)
 	if (READ_ONCE(msk->rcv_data_fin) || !READ_ONCE(msk->first))
 		return false;
 
-	WRITE_ONCE(msk->rcv_data_fin_seq, data_fin_seq);
+	WRITE_ONCE(msk->rcv_data_fin_seq,
+		   expand_ack(READ_ONCE(msk->ack_seq), data_fin_seq, use_64bit));
 	WRITE_ONCE(msk->rcv_data_fin, 1);
 
 	return true;
@@ -875,7 +876,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	 */
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		if (mp_opt.data_fin && mp_opt.data_len == 1 &&
-		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq) &&
+		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64) &&
 		    schedule_work(&msk->work))
 			sock_hold(subflow->conn);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 60b27d44c184..20f04ac85409 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -387,7 +387,7 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
-bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq);
+bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
 
 void __init mptcp_token_init(void);
 static inline void mptcp_token_init_request(struct request_sock *req)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8cbeb68f3775..5f2fa935022d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -731,7 +731,8 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 
 	if (mpext->data_fin == 1) {
 		if (data_len == 1) {
-			bool updated = mptcp_update_rcv_data_fin(msk, mpext->data_seq);
+			bool updated = mptcp_update_rcv_data_fin(msk, mpext->data_seq,
+								 mpext->dsn64);
 			pr_debug("DATA_FIN with no payload seq=%llu", mpext->data_seq);
 			if (subflow->map_valid) {
 				/* A DATA_FIN might arrive in a DSS
@@ -748,8 +749,17 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 				return MAPPING_DATA_FIN;
 			}
 		} else {
-			mptcp_update_rcv_data_fin(msk, mpext->data_seq + data_len);
-			pr_debug("DATA_FIN with mapping seq=%llu", mpext->data_seq + data_len);
+			u64 data_fin_seq = mpext->data_seq + data_len;
+
+			/* If mpext->data_seq is a 32-bit value, data_fin_seq
+			 * must also be limited to 32 bits.
+			 */
+			if (!mpext->dsn64)
+				data_fin_seq &= GENMASK_ULL(31, 0);
+
+			mptcp_update_rcv_data_fin(msk, data_fin_seq, mpext->dsn64);
+			pr_debug("DATA_FIN with mapping seq=%llu dsn64=%d",
+				 data_fin_seq, mpext->dsn64);
 		}
 
 		/* Adjust for DATA_FIN using 1 byte of sequence space */
-- 
2.28.0

