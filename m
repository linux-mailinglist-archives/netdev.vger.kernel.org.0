Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74590486EB0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiAGAU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:47989 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344055AbiAGAUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514844; x=1673050844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1xG00dTFemk6+91lOhqDScRK+4QN48IfmgSY6haTzCs=;
  b=FYxwLIBCx5FoYRtqrdc5JRXXcrd2Zf87VPhpiyhsCblCgaO6RUy44C0S
   EhChgNPtqazHg1/JyYlDndgfbL0e3jggnwMRedfTC5GETmQhzsf14GZS4
   IreCNhj8n7jzHpJ1HQ5hqf0xbLT9ABThipSLRx6u1nJUJ3apkCjbL5lxT
   cKPHwb/f0j9tz7O3KVVDCh7oIykeVVYd7d4djK7uRsj3KjsPIIWfoJRz+
   NsPs3eCkanvmYBWsz/2hmlizhD3JmNrB44wQyAfrMnQ82RSpEoFgz6EZK
   Pk6GnjQt/5gKuPiJrj1A1hkcqFyOE0TJAAzr/yeFuroOzWM2yD0SYJtKf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721315"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721315"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508515"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/13] mptcp: do not block subflows creation on errors
Date:   Thu,  6 Jan 2022 16:20:23 -0800
Message-Id: <20220107002026.375427-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the MPTCP configuration allows for multiple subflows
creation, and the first additional subflows never reach
the fully established status - e.g. due to packets drop or
reset - the in kernel path manager do not move to the
next subflow.

This patch introduces a new PM helper to cope with MPJ
subflow creation failure and delay and hook it where appropriate.

Such helper triggers additional subflow creation, as needed
and updates the PM subflow counter, if the current one is
closing.

Additionally start all the needed additional subflows
as soon as the MPTCP socket is fully established, so we don't
have to cope with slow MPJ handshake blocking the next subflow
creation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         | 23 ++++++++++++--
 net/mptcp/pm_netlink.c | 69 +++++++++++++++++++++++++-----------------
 net/mptcp/protocol.c   |  6 ++++
 net/mptcp/protocol.h   |  4 ++-
 4 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index e9ba9551832c..696b2c4613a7 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -172,9 +172,28 @@ void mptcp_pm_subflow_established(struct mptcp_sock *msk)
 	spin_unlock_bh(&pm->lock);
 }
 
-void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id)
+void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
+				 const struct mptcp_subflow_context *subflow)
 {
-	pr_debug("msk=%p", msk);
+	struct mptcp_pm_data *pm = &msk->pm;
+	bool update_subflows;
+
+	update_subflows = (ssk->sk_state == TCP_CLOSE) &&
+			  (subflow->request_join || subflow->mp_join);
+	if (!READ_ONCE(pm->work_pending) && !update_subflows)
+		return;
+
+	spin_lock_bh(&pm->lock);
+	if (update_subflows)
+		pm->subflows--;
+
+	/* Even if this subflow is not really established, tell the PM to try
+	 * to pick the next ones, if possible.
+	 */
+	if (mptcp_pm_nl_check_work_pending(msk))
+		mptcp_pm_schedule_work(msk, MPTCP_PM_SUBFLOW_ESTABLISHED);
+
+	spin_unlock_bh(&pm->lock);
 }
 
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ad3dc9c6c531..5efb63ab1fa3 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -251,14 +251,17 @@ unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk)
 }
 EXPORT_SYMBOL_GPL(mptcp_pm_get_local_addr_max);
 
-static void check_work_pending(struct mptcp_sock *msk)
+bool mptcp_pm_nl_check_work_pending(struct mptcp_sock *msk)
 {
 	struct pm_nl_pernet *pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
 
 	if (msk->pm.subflows == mptcp_pm_get_subflows_max(msk) ||
 	    (find_next_and_bit(pernet->id_bitmap, msk->pm.id_avail_bitmap,
-			       MPTCP_PM_MAX_ADDR_ID + 1, 0) == MPTCP_PM_MAX_ADDR_ID + 1))
+			       MPTCP_PM_MAX_ADDR_ID + 1, 0) == MPTCP_PM_MAX_ADDR_ID + 1)) {
 		WRITE_ONCE(msk->pm.work_pending, false);
+		return false;
+	}
+	return true;
 }
 
 struct mptcp_pm_add_entry *
@@ -427,6 +430,7 @@ static bool lookup_address_in_vec(struct mptcp_addr_info *addrs, unsigned int nr
 static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullmesh,
 					      struct mptcp_addr_info *addrs)
 {
+	bool deny_id0 = READ_ONCE(msk->pm.remote_deny_join_id0);
 	struct sock *sk = (struct sock *)msk, *ssk;
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_addr_info remote = { 0 };
@@ -434,22 +438,28 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	int i = 0;
 
 	subflows_max = mptcp_pm_get_subflows_max(msk);
+	remote_address((struct sock_common *)sk, &remote);
 
 	/* Non-fullmesh endpoint, fill in the single entry
 	 * corresponding to the primary MPC subflow remote address
 	 */
 	if (!fullmesh) {
-		remote_address((struct sock_common *)sk, &remote);
+		if (deny_id0)
+			return 0;
+
 		msk->pm.subflows++;
 		addrs[i++] = remote;
 	} else {
 		mptcp_for_each_subflow(msk, subflow) {
 			ssk = mptcp_subflow_tcp_sock(subflow);
-			remote_address((struct sock_common *)ssk, &remote);
-			if (!lookup_address_in_vec(addrs, i, &remote) &&
+			remote_address((struct sock_common *)ssk, &addrs[i]);
+			if (deny_id0 && addresses_equal(&addrs[i], &remote, false))
+				continue;
+
+			if (!lookup_address_in_vec(addrs, i, &addrs[i]) &&
 			    msk->pm.subflows < subflows_max) {
 				msk->pm.subflows++;
-				addrs[i++] = remote;
+				i++;
 			}
 		}
 	}
@@ -503,12 +513,12 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 	/* do lazy endpoint usage accounting for the MPC subflows */
 	if (unlikely(!(msk->pm.status & BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED))) && msk->first) {
-		struct mptcp_addr_info local;
+		struct mptcp_addr_info mpc_addr;
 		int mpc_id;
 
-		local_address((struct sock_common *)msk->first, &local);
-		mpc_id = lookup_id_by_addr(pernet, &local);
-		if (mpc_id < 0)
+		local_address((struct sock_common *)msk->first, &mpc_addr);
+		mpc_id = lookup_id_by_addr(pernet, &mpc_addr);
+		if (mpc_id >= 0)
 			__clear_bit(mpc_id, msk->pm.id_avail_bitmap);
 
 		msk->pm.status |= BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED);
@@ -534,26 +544,28 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	}
 
 	/* check if should create a new subflow */
-	if (msk->pm.local_addr_used < local_addr_max &&
-	    msk->pm.subflows < subflows_max &&
-	    !READ_ONCE(msk->pm.remote_deny_join_id0)) {
+	while (msk->pm.local_addr_used < local_addr_max &&
+	       msk->pm.subflows < subflows_max) {
+		struct mptcp_addr_info addrs[MPTCP_PM_ADDR_MAX];
+		bool fullmesh;
+		int i, nr;
+
 		local = select_local_address(pernet, msk);
-		if (local) {
-			bool fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
-			struct mptcp_addr_info addrs[MPTCP_PM_ADDR_MAX];
-			int i, nr;
+		if (!local)
+			break;
 
-			msk->pm.local_addr_used++;
-			nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
-			if (nr)
-				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
-			spin_unlock_bh(&msk->pm.lock);
-			for (i = 0; i < nr; i++)
-				__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
-			spin_lock_bh(&msk->pm.lock);
-		}
+		fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
+
+		msk->pm.local_addr_used++;
+		nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
+		if (nr)
+			__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
+		spin_unlock_bh(&msk->pm.lock);
+		for (i = 0; i < nr; i++)
+			__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
+		spin_lock_bh(&msk->pm.lock);
 	}
-	check_work_pending(msk);
+	mptcp_pm_nl_check_work_pending(msk);
 }
 
 static void mptcp_pm_nl_fully_established(struct mptcp_sock *msk)
@@ -760,11 +772,12 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 				 i, rm_list->ids[i], subflow->local_id, subflow->remote_id);
 			spin_unlock_bh(&msk->pm.lock);
 			mptcp_subflow_shutdown(sk, ssk, how);
+
+			/* the following takes care of updating the subflows counter */
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
 			removed = true;
-			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
 		__set_bit(rm_list->ids[1], msk->pm.id_avail_bitmap);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5c956a8dc714..3e8cfaed00b5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2332,6 +2332,12 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 {
 	if (sk->sk_state == TCP_ESTABLISHED)
 		mptcp_event(MPTCP_EVENT_SUB_CLOSED, mptcp_sk(sk), ssk, GFP_KERNEL);
+
+	/* subflow aborted before reaching the fully_established status
+	 * attempt the creation of the next subflow
+	 */
+	mptcp_pm_subflow_check_next(mptcp_sk(sk), ssk, subflow);
+
 	__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_PUSH);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2a6f0960ba27..a8eb32e29215 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -743,7 +743,9 @@ void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk,
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
 void mptcp_pm_connection_closed(struct mptcp_sock *msk);
 void mptcp_pm_subflow_established(struct mptcp_sock *msk);
-void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id);
+bool mptcp_pm_nl_check_work_pending(struct mptcp_sock *msk);
+void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
+				 const struct mptcp_subflow_context *subflow);
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
-- 
2.34.1

