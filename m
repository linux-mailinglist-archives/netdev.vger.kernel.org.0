Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380203EF573
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhHQWIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:08:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:12963 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhHQWIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:08:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="301788859"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="301788859"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="573058344"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.45])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@xiaomi.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] mptcp: local addresses fullmesh
Date:   Tue, 17 Aug 2021 15:07:24 -0700
Message-Id: <20210817220727.192198-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
References: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@xiaomi.com>

In mptcp_pm_nl_add_addr_received(), fill a temporary allocate array of
all local address corresponding to the fullmesh endpoint. If such array
is empty, keep the current behavior.

Elsewhere loop on such array and create a subflow for each local address
towards the given remote address

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@xiaomi.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 73 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index bf5b9b475bb7..6e3df62a87d2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -534,13 +534,67 @@ static void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk)
 	mptcp_pm_create_subflow_or_signal_addr(msk);
 }
 
+/* Fill all the local addresses into the array addrs[],
+ * and return the array size.
+ */
+static unsigned int fill_local_addresses_vec(struct mptcp_sock *msk,
+					     struct mptcp_addr_info *addrs)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct mptcp_pm_addr_entry *entry;
+	struct mptcp_addr_info local;
+	struct pm_nl_pernet *pernet;
+	unsigned int subflows_max;
+	int i = 0;
+
+	pernet = net_generic(sock_net(sk), pm_nl_pernet_id);
+	subflows_max = mptcp_pm_get_subflows_max(msk);
+
+	rcu_read_lock();
+	__mptcp_flush_join_list(msk);
+	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
+		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
+			continue;
+
+		if (entry->addr.family != sk->sk_family) {
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+			if ((entry->addr.family == AF_INET &&
+			     !ipv6_addr_v4mapped(&sk->sk_v6_daddr)) ||
+			    (sk->sk_family == AF_INET &&
+			     !ipv6_addr_v4mapped(&entry->addr.addr6)))
+#endif
+				continue;
+		}
+
+		if (msk->pm.subflows < subflows_max) {
+			msk->pm.subflows++;
+			addrs[i++] = entry->addr;
+		}
+	}
+	rcu_read_unlock();
+
+	/* If the array is empty, fill in the single
+	 * 'IPADDRANY' local address
+	 */
+	if (!i) {
+		memset(&local, 0, sizeof(local));
+		local.family = msk->pm.remote.family;
+
+		msk->pm.subflows++;
+		addrs[i++] = local;
+	}
+
+	return i;
+}
+
 static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 {
+	struct mptcp_addr_info addrs[MPTCP_PM_ADDR_MAX];
 	struct sock *sk = (struct sock *)msk;
 	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
-	struct mptcp_addr_info local;
 	unsigned int subflows_max;
+	int i, nr;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
@@ -552,23 +606,22 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	if (lookup_subflow_by_daddr(&msk->conn_list, &msk->pm.remote))
 		goto add_addr_echo;
 
-	msk->pm.add_addr_accepted++;
-	msk->pm.subflows++;
-	if (msk->pm.add_addr_accepted >= add_addr_accept_max ||
-	    msk->pm.subflows >= subflows_max)
-		WRITE_ONCE(msk->pm.accept_addr, false);
-
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
 	 */
 	remote = msk->pm.remote;
 	if (!remote.port)
 		remote.port = sk->sk_dport;
-	memset(&local, 0, sizeof(local));
-	local.family = remote.family;
+	nr = fill_local_addresses_vec(msk, addrs);
+
+	msk->pm.add_addr_accepted++;
+	if (msk->pm.add_addr_accepted >= add_addr_accept_max ||
+	    msk->pm.subflows >= subflows_max)
+		WRITE_ONCE(msk->pm.accept_addr, false);
 
 	spin_unlock_bh(&msk->pm.lock);
-	__mptcp_subflow_connect(sk, &local, &remote);
+	for (i = 0; i < nr; i++)
+		__mptcp_subflow_connect(sk, &addrs[i], &remote);
 	spin_lock_bh(&msk->pm.lock);
 
 add_addr_echo:
-- 
2.33.0

