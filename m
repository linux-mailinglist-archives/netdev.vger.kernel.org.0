Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E377C3EF572
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhHQWIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:08:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:12969 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235600AbhHQWIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:08:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="301788856"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="301788856"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="573058343"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.45])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@xiaomi.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] mptcp: remote addresses fullmesh
Date:   Tue, 17 Aug 2021 15:07:23 -0700
Message-Id: <20210817220727.192198-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
References: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@xiaomi.com>

This patch added and managed a new per endpoint flag, named
MPTCP_PM_ADDR_FLAG_FULLMESH.

In mptcp_pm_create_subflow_or_signal_addr(), if such flag is set, instead
of:
        remote_address((struct sock_common *)sk, &remote);
fill a temporary allocated array of all known remote address. After
releaseing the pm lock loop on such array and create a subflow for each
remote address from the given local.

Note that the we could still use an array even for non 'fullmesh'
endpoint: with a single entry corresponding to the primary MPC subflow
remote address.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@xiaomi.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  1 +
 net/mptcp/pm_netlink.c     | 59 +++++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 7b05f7102321..f66038b9551f 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -73,6 +73,7 @@ enum {
 #define MPTCP_PM_ADDR_FLAG_SIGNAL			(1 << 0)
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
+#define MPTCP_PM_ADDR_FLAG_FULLMESH			(1 << 3)
 
 enum {
 	MPTCP_PM_CMD_UNSPEC,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 64a39f30659f..bf5b9b475bb7 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -410,6 +410,55 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 	}
 }
 
+static bool lookup_address_in_vec(struct mptcp_addr_info *addrs, unsigned int nr,
+				  struct mptcp_addr_info *addr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (addresses_equal(&addrs[i], addr, addr->port))
+			return true;
+	}
+
+	return false;
+}
+
+/* Fill all the remote addresses into the array addrs[],
+ * and return the array size.
+ */
+static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullmesh,
+					      struct mptcp_addr_info *addrs)
+{
+	struct sock *sk = (struct sock *)msk, *ssk;
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_addr_info remote = { 0 };
+	unsigned int subflows_max;
+	int i = 0;
+
+	subflows_max = mptcp_pm_get_subflows_max(msk);
+
+	/* Non-fullmesh endpoint, fill in the single entry
+	 * corresponding to the primary MPC subflow remote address
+	 */
+	if (!fullmesh) {
+		remote_address((struct sock_common *)sk, &remote);
+		msk->pm.subflows++;
+		addrs[i++] = remote;
+	} else {
+		mptcp_for_each_subflow(msk, subflow) {
+			ssk = mptcp_subflow_tcp_sock(subflow);
+			remote_address((struct sock_common *)ssk, &remote);
+			if (!lookup_address_in_vec(addrs, i, &remote) &&
+			    msk->pm.subflows < subflows_max) {
+				msk->pm.subflows++;
+				addrs[i++] = remote;
+			}
+		}
+	}
+
+	return i;
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -455,14 +504,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	    !READ_ONCE(msk->pm.remote_deny_join_id0)) {
 		local = select_local_address(pernet, msk);
 		if (local) {
-			struct mptcp_addr_info remote = { 0 };
+			bool fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
+			struct mptcp_addr_info addrs[MPTCP_PM_ADDR_MAX];
+			int i, nr;
 
 			msk->pm.local_addr_used++;
-			msk->pm.subflows++;
 			check_work_pending(msk);
-			remote_address((struct sock_common *)sk, &remote);
+			nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
 			spin_unlock_bh(&msk->pm.lock);
-			__mptcp_subflow_connect(sk, &local->addr, &remote);
+			for (i = 0; i < nr; i++)
+				__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}
-- 
2.33.0

