Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E0486EAC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344163AbiAGAUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:47984 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344039AbiAGAUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514843; x=1673050843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pl68bDSpC4qdweZRyObhPBra8XJEPL/rbRE6WRFpyfw=;
  b=Vu65JcA/JNxr1PglSAcSIwzrXx+LYNMrwAUEfJnR7SFegE2bgQXIiBEj
   6eUjCmGaGSrG3cp0OyQM62EDS+VJH9hw3LwUK5fznLTnDlfBvP93B3ICH
   NqpNI7G6BlNZwQaWuNsNy7AOmT0t1siG2r7ti/XcrVmv6/glsbW47c5tA
   OydHKV/M9ktatsfPMrMqMjGJ0zJaZXHwmL/FBm4AP9cXlYs5r8u/5yQYK
   0zbWqrRvtYr21bAApZJm0f2ByWPRa+6gFJQOt4i2OmixsmIHw+2hIfR01
   UcoatB/K0F1RVEQGZJM6a8iSNX8JBRYYjjTM3RJIIZ4SOaVdHEzMZD6Aq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721310"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721310"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508506"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/13] mptcp: fix per socket endpoint accounting
Date:   Thu,  6 Jan 2022 16:20:20 -0800
Message-Id: <20220107002026.375427-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Since full-mesh endpoint support, the reception of a single ADD_ADDR
option can cause multiple subflows creation. When such option is
accepted we increment 'add_addr_accepted' by one. When we received
a paired RM_ADDR option, we deleted all the relevant subflows,
decrementing 'add_addr_accepted' by one for each of them.

We have a similar issue for 'local_addr_used'

Fix them moving the pm endpoint accounting outside the subflow
traversal.

Fixes: 1a0d6136c5f0 ("mptcp: local addresses fullmesh")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 6cde58c259a8..27427aeeee0e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -711,6 +711,8 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 		return;
 
 	for (i = 0; i < rm_list->nr; i++) {
+		bool removed = false;
+
 		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
@@ -730,15 +732,19 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
-			if (rm_type == MPTCP_MIB_RMADDR) {
-				msk->pm.add_addr_accepted--;
-				WRITE_ONCE(msk->pm.accept_addr, true);
-			} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
-				msk->pm.local_addr_used--;
-			}
+			removed = true;
 			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
+		if (!removed)
+			continue;
+
+		if (rm_type == MPTCP_MIB_RMADDR) {
+			msk->pm.add_addr_accepted--;
+			WRITE_ONCE(msk->pm.accept_addr, true);
+		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
+			msk->pm.local_addr_used--;
+		}
 	}
 }
 
-- 
2.34.1

