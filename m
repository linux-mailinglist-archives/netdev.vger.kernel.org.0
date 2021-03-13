Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5601339ACC
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCMBQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232223AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: TokDxkzi7/WexKE21Ey6zutjbJsc8nDHLcqzOTNqwAsNLzBZox127F8Knn3GGYMBAforlPQR23
 ZcGgRZARrnGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828244"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: M0CR/UKgOKDOeOdZseJFQ0jeWmzhUyzQEvsvBjXMmNX17ri2uzL7IJjgZcVrbQF8Svicm6iqG2
 0y6HRpGKs6bQ==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197374"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/11] mptcp: remove multi addresses in PM
Date:   Fri, 12 Mar 2021 17:16:15 -0800
Message-Id: <20210313011621.211661-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch dropped the member rm_id of struct mptcp_pm_data. Use
rm_list_rx in mptcp_pm_nl_rm_addr_received instead of using rm_id.

In mptcp_pm_nl_rm_addr_received, iterated each address id from
pm.rm_list_rx, then shut down and closed each address id's subsocket.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 36 ++++++++++++++++++++----------------
 net/mptcp/protocol.h   |  1 -
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 1eb9d0139267..e8135702af39 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -575,36 +575,40 @@ static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
+	u8 i;
 
-	pr_debug("address rm_id %d", msk->pm.rm_id);
+	pr_debug("address rm_list_nr %d", msk->pm.rm_list_rx.nr);
 
 	msk_owned_by_me(msk);
 
-	if (!msk->pm.rm_id)
+	if (!msk->pm.rm_list_rx.nr)
 		return;
 
 	if (list_empty(&msk->conn_list))
 		return;
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
+	for (i = 0; i < msk->pm.rm_list_rx.nr; i++) {
+		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 
-		if (msk->pm.rm_id != subflow->remote_id)
-			continue;
+			if (msk->pm.rm_list_rx.ids[i] != subflow->remote_id)
+				continue;
 
-		spin_unlock_bh(&msk->pm.lock);
-		mptcp_subflow_shutdown(sk, ssk, how);
-		mptcp_close_ssk(sk, ssk, subflow);
-		spin_lock_bh(&msk->pm.lock);
+			pr_debug(" -> address rm_list_ids[%d]=%u", i, msk->pm.rm_list_rx.ids[i]);
+			spin_unlock_bh(&msk->pm.lock);
+			mptcp_subflow_shutdown(sk, ssk, how);
+			mptcp_close_ssk(sk, ssk, subflow);
+			spin_lock_bh(&msk->pm.lock);
 
-		msk->pm.add_addr_accepted--;
-		msk->pm.subflows--;
-		WRITE_ONCE(msk->pm.accept_addr, true);
+			msk->pm.add_addr_accepted--;
+			msk->pm.subflows--;
+			WRITE_ONCE(msk->pm.accept_addr, true);
 
-		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
+			__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
 
-		break;
+			break;
+		}
 	}
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 82a63abf2c7e..5324fbe40528 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -209,7 +209,6 @@ struct mptcp_pm_data {
 	u8		status;
 	struct mptcp_rm_list rm_list_tx;
 	struct mptcp_rm_list rm_list_rx;
-	u8		rm_id;
 };
 
 struct mptcp_data_frag {
-- 
2.30.2

