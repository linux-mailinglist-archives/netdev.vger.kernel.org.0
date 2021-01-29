Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5365E308320
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhA2BRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:17:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:6703 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhA2BRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:17:35 -0500
IronPort-SDR: pjbo2BydMRRH5ux/lOy3XUHelfdpl82U9Ptux4uqbUOSRIpANkHx6HsEghMjXV1Xqk/YVQ/Bpu
 sTD6Ovj+M6+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430175"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430175"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: A1eo1gU49YTaLyeOyypFVt8cDW/bddc12HkRbNHrCWp5VKN4IFulMplGMF+dxtl3P5//GhLB/U
 JOIyK4vRqc/w==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538335"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/16] mptcp: add a new helper subflow_req_create_thmac
Date:   Thu, 28 Jan 2021 17:11:08 -0800
Message-Id: <20210129011115.133953-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
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

