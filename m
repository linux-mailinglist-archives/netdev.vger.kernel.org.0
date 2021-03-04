Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC5632DBE3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbhCDVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:37:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:5221 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239599AbhCDVgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:36:51 -0500
IronPort-SDR: xz3yGCpIFO+mPC7qszuG9oSABBkwSM1bHcGWFkxOyRCylW77bFOH4TX4rOJO7brlRxJSERu4VN
 4So02iJr0PyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769419"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769419"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: CrV11krjb7+wKupoGGQUgXvV5V5PfBSMo6moqh78VDQ/CUbltl/dTKFI/8zP24PvolC6lq5Mhk
 O4gTe+wyMadw==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329495"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 9/9] mptcp: free resources when the port number is mismatched
Date:   Thu,  4 Mar 2021 13:32:16 -0800
Message-Id: <20210304213216.205472-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

When the port number is mismatched with the announced ones, use
'goto dispose_child' to free the resources instead of using 'goto out'.

This patch also moves the port number checking code in
subflow_syn_recv_sock before mptcp_finish_join, otherwise subflow_drop_ctx
will fail in dispose_child.

Fixes: 5bc56388c74f ("mptcp: add port number check for MP_JOIN")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 41695e26c374..3d47d670e665 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -687,11 +687,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* move the msk reference ownership to the subflow */
 			subflow_req->msk = NULL;
 			ctx->conn = (struct sock *)owner;
-			if (!mptcp_finish_join(child))
-				goto dispose_child;
-
-			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
-			tcp_rsk(req)->drop_req = true;
 
 			if (subflow_use_different_sport(owner, sk)) {
 				pr_debug("ack inet_sport=%d %d",
@@ -699,10 +694,16 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					 ntohs(inet_sk((struct sock *)owner)->inet_sport));
 				if (!mptcp_pm_sport_in_anno_list(owner, sk)) {
 					SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MISMATCHPORTACKRX);
-					goto out;
+					goto dispose_child;
 				}
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINPORTACKRX);
 			}
+
+			if (!mptcp_finish_join(child))
+				goto dispose_child;
+
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
+			tcp_rsk(req)->drop_req = true;
 		}
 	}
 
-- 
2.30.1

