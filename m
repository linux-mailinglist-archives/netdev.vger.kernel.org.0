Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E655D30B33A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBAXP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:15:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:51851 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhBAXPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:15:24 -0500
IronPort-SDR: 3SllMEppSMsonzr8EFEbnxS5kgJzlSdGup7zw2UxqfGYZZhu187JMLj49sTcQ8+oJQeWsVs+Om
 l2wqxC3yoqHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934343"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934343"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
IronPort-SDR: lWVbcnwJlw6+UHrGE52Yy/wIcsVzws1qtiNcpxQXllMIlT4O/d7pAZMomZmA64Wj8TA+6rfXCA
 GIfhjUmQ5Gig==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188473"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 09/15] mptcp: add a new helper subflow_req_create_thmac
Date:   Mon,  1 Feb 2021 15:09:14 -0800
Message-Id: <20210201230920.66027-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds a new helper named subflow_req_create_thmac, which is
extracted from subflow_token_join_request. It initializes subflow_req's
local_nonce and thmac fields, those are the more expensive to populate.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 2dcc0fb5a69e..94926ab74d48 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -64,10 +64,23 @@ static bool mptcp_can_accept_new_subflow(const struct mptcp_sock *msk)
 }
 
 /* validate received token and create truncated hmac and nonce for SYN-ACK */
+static void subflow_req_create_thmac(struct mptcp_subflow_request_sock *subflow_req)
+{
+	struct mptcp_sock *msk = subflow_req->msk;
+	u8 hmac[SHA256_DIGEST_SIZE];
+
+	get_random_bytes(&subflow_req->local_nonce, sizeof(u32));
+
+	subflow_generate_hmac(msk->local_key, msk->remote_key,
+			      subflow_req->local_nonce,
+			      subflow_req->remote_nonce, hmac);
+
+	subflow_req->thmac = get_unaligned_be64(hmac);
+}
+
 static struct mptcp_sock *subflow_token_join_request(struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
-	u8 hmac[SHA256_DIGEST_SIZE];
 	struct mptcp_sock *msk;
 	int local_id;
 
@@ -84,13 +97,6 @@ static struct mptcp_sock *subflow_token_join_request(struct request_sock *req)
 	}
 	subflow_req->local_id = local_id;
 
-	get_random_bytes(&subflow_req->local_nonce, sizeof(u32));
-
-	subflow_generate_hmac(msk->local_key, msk->remote_key,
-			      subflow_req->local_nonce,
-			      subflow_req->remote_nonce, hmac);
-
-	subflow_req->thmac = get_unaligned_be64(hmac);
 	return msk;
 }
 
@@ -186,6 +192,8 @@ static int subflow_init_req(struct request_sock *req,
 		if (!subflow_req->msk)
 			return -EPERM;
 
+		subflow_req_create_thmac(subflow_req);
+
 		if (unlikely(req->syncookie)) {
 			if (mptcp_can_accept_new_subflow(subflow_req->msk))
 				subflow_init_req_cookie_join_save(subflow_req, skb);
-- 
2.30.0

