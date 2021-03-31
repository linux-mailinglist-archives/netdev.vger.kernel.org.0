Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6351134F54F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhCaAJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:14824 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhCaAJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:04 -0400
IronPort-SDR: LI3zMSxgMBJT+c++TN0I71+cB97xfN5n+/A4qg7joIcIzM56iU3ZSdXl1jEX1oUkImrxri3/R0
 evLLCocEnGuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058939"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058939"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: HeiqdIO/OcKRWOuul2yEYG5iB8OYmQN1pRzRvSGfkBS7frZmV2+iFxpZmqNcomTUEpCUrvQgdd
 hDPm7KTHOo4g==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682557"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] mptcp: unify RM_ADDR and RM_SUBFLOW receiving
Date:   Tue, 30 Mar 2021 17:08:52 -0700
Message-Id: <20210331000856.117636-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

There are some duplicate code in mptcp_pm_nl_rm_addr_received and
mptcp_pm_nl_rm_subflow_received. This patch unifies them into a new
function named mptcp_pm_nl_rm_addr_or_subflow. In it, use the input
parameter rm_type to identify it's now removing an address or a subflow.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 82 +++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 87a6133fd778..e00397f2abf1 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -586,45 +586,68 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 	return -EINVAL;
 }
 
-static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
+static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
+					   const struct mptcp_rm_list *rm_list,
+					   enum linux_mptcp_mib_field rm_type)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
 	u8 i;
 
-	pr_debug("address rm_list_nr %d", msk->pm.rm_list_rx.nr);
+	pr_debug("%s rm_list_nr %d",
+		 rm_type == MPTCP_MIB_RMADDR ? "address" : "subflow", rm_list->nr);
 
 	msk_owned_by_me(msk);
 
-	if (!msk->pm.rm_list_rx.nr)
+	if (!rm_list->nr)
 		return;
 
 	if (list_empty(&msk->conn_list))
 		return;
 
-	for (i = 0; i < msk->pm.rm_list_rx.nr; i++) {
+	for (i = 0; i < rm_list->nr; i++) {
 		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
+			u8 id = subflow->local_id;
+
+			if (rm_type == MPTCP_MIB_RMADDR)
+				id = subflow->remote_id;
 
-			if (msk->pm.rm_list_rx.ids[i] != subflow->remote_id)
+			if (rm_list->ids[i] != id)
 				continue;
 
-			pr_debug(" -> address rm_list_ids[%d]=%u", i, msk->pm.rm_list_rx.ids[i]);
+			pr_debug(" -> %s rm_list_ids[%d]=%u local_id=%u remote_id=%u",
+				 rm_type == MPTCP_MIB_RMADDR ? "address" : "subflow",
+				 i, rm_list->ids[i], subflow->local_id, subflow->remote_id);
 			spin_unlock_bh(&msk->pm.lock);
 			mptcp_subflow_shutdown(sk, ssk, how);
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
-			msk->pm.add_addr_accepted--;
+			if (rm_type == MPTCP_MIB_RMADDR) {
+				msk->pm.add_addr_accepted--;
+				WRITE_ONCE(msk->pm.accept_addr, true);
+			} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
+				msk->pm.local_addr_used--;
+			}
 			msk->pm.subflows--;
-			WRITE_ONCE(msk->pm.accept_addr, true);
-
-			__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
+			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
 	}
 }
 
+static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
+{
+	mptcp_pm_nl_rm_addr_or_subflow(msk, &msk->pm.rm_list_rx, MPTCP_MIB_RMADDR);
+}
+
+void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
+				     const struct mptcp_rm_list *rm_list)
+{
+	mptcp_pm_nl_rm_addr_or_subflow(msk, rm_list, MPTCP_MIB_RMSUBFLOW);
+}
+
 void mptcp_pm_nl_work(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
@@ -658,45 +681,6 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->pm.lock);
 }
 
-void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
-				     const struct mptcp_rm_list *rm_list)
-{
-	struct mptcp_subflow_context *subflow, *tmp;
-	struct sock *sk = (struct sock *)msk;
-	u8 i;
-
-	pr_debug("subflow rm_list_nr %d", rm_list->nr);
-
-	msk_owned_by_me(msk);
-
-	if (!rm_list->nr)
-		return;
-
-	if (list_empty(&msk->conn_list))
-		return;
-
-	for (i = 0; i < rm_list->nr; i++) {
-		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
-			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
-
-			if (rm_list->ids[i] != subflow->local_id)
-				continue;
-
-			pr_debug(" -> subflow rm_list_ids[%d]=%u", i, rm_list->ids[i]);
-			spin_unlock_bh(&msk->pm.lock);
-			mptcp_subflow_shutdown(sk, ssk, how);
-			mptcp_close_ssk(sk, ssk, subflow);
-			spin_lock_bh(&msk->pm.lock);
-
-			msk->pm.local_addr_used--;
-			msk->pm.subflows--;
-
-			__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMSUBFLOW);
-		}
-	}
-}
-
 static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 {
 	return (entry->addr.flags &
-- 
2.31.1

