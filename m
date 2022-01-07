Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B702486EAF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344103AbiAGAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:47984 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344048AbiAGAUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514844; x=1673050844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xmpU6oESAborR1BVZEnjtiG+H88NZlprm7RU1qJL9QU=;
  b=Wqz3yPoGZN1vr9pNs+5rPA2UJm/RDnAJLO2ZrbUSXpQxQuuexCsfaCKA
   Oej+I+XpD9bP9dio9HEp+L6JgNCsfORq/SY6ubMLFqcm4eMw2b14sd7t4
   pciuu7lvZq2YGWnWvuy1Zd8YZjv876oJaDCPWsaYWMZcjeTWY+/Io+Kb3
   fWnWz2KAoIq7xCemENkeMXSjaGwoEnse4Uq8WxlCcqeWugwyfILKWrMxJ
   LA2Ya8NRdO6Gp1qRfWd9/MyU/NZEYf01QyyI9dFjfgOak2qiP0OjizP83
   pxPRRLx7NRdBKdnGMAhGxDoK/rlEXeEnJzStsjyvncYOzQ8vFbQq2AFNn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721313"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721313"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508513"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/13] mptcp: keep track of local endpoint still available for each msk
Date:   Thu,  6 Jan 2022 16:20:22 -0800
Message-Id: <20220107002026.375427-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Include into the path manager status a bitmap tracking the list
of local endpoints still available - not yet used - for the
relevant mptcp socket.

Keep such map updated at endpoint creation/deletion time, so
that we can easily skip already used endpoint at local address
selection time.

The endpoint used by the initial subflow is lazyly accounted at
subflow creation time: the usage bitmap is be up2date before
endpoint selection and we avoid such unneeded task in some relevant
scenarios - e.g. busy servers accepting incoming subflows but
not creating any additional ones nor annuncing additional addresses.

Overall this allows for fair local endpoints usage in case of
subflow failure.

As a side effect, this patch also enforces that each endpoint
is used at most once for each mptcp connection.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c                                |   1 +
 net/mptcp/pm_netlink.c                        | 125 +++++++++++-------
 net/mptcp/protocol.c                          |   3 +-
 net/mptcp/protocol.h                          |  12 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh |   5 +-
 5 files changed, 91 insertions(+), 55 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 6b2bfe89d445..e9ba9551832c 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -370,6 +370,7 @@ void mptcp_pm_data_reset(struct mptcp_sock *msk)
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	WRITE_ONCE(msk->pm.remote_deny_join_id0, false);
 	msk->pm.status = 0;
+	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 
 	mptcp_pm_nl_data_init(msk);
 }
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 27427aeeee0e..ad3dc9c6c531 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -38,10 +38,6 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
-/* max value of mptcp_addr_info.id */
-#define MAX_ADDR_ID		U8_MAX
-#define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
-
 struct pm_nl_pernet {
 	/* protects pernet updates */
 	spinlock_t		lock;
@@ -53,14 +49,14 @@ struct pm_nl_pernet {
 	unsigned int		local_addr_max;
 	unsigned int		subflows_max;
 	unsigned int		next_id;
-	unsigned long		id_bitmap[BITMAP_SZ];
+	DECLARE_BITMAP(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 };
 
 #define MPTCP_PM_ADDR_MAX	8
 #define ADD_ADDR_RETRANS_MAX	3
 
 static bool addresses_equal(const struct mptcp_addr_info *a,
-			    struct mptcp_addr_info *b, bool use_port)
+			    const struct mptcp_addr_info *b, bool use_port)
 {
 	bool addr_equals = false;
 
@@ -174,6 +170,9 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
 
+		if (!test_bit(entry->addr.id, msk->pm.id_avail_bitmap))
+			continue;
+
 		if (entry->addr.family != sk->sk_family) {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 			if ((entry->addr.family == AF_INET &&
@@ -184,23 +183,17 @@ select_local_address(const struct pm_nl_pernet *pernet,
 				continue;
 		}
 
-		/* avoid any address already in use by subflows and
-		 * pending join
-		 */
-		if (!lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
-			ret = entry;
-			break;
-		}
+		ret = entry;
+		break;
 	}
 	rcu_read_unlock();
 	return ret;
 }
 
 static struct mptcp_pm_addr_entry *
-select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
+select_signal_address(struct pm_nl_pernet *pernet, struct mptcp_sock *msk)
 {
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
-	int i = 0;
 
 	rcu_read_lock();
 	/* do not keep any additional per socket state, just signal
@@ -209,12 +202,14 @@ select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
 	 * can lead to additional addresses not being announced.
 	 */
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
+		if (!test_bit(entry->addr.id, msk->pm.id_avail_bitmap))
+			continue;
+
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 			continue;
-		if (i++ == pos) {
-			ret = entry;
-			break;
-		}
+
+		ret = entry;
+		break;
 	}
 	rcu_read_unlock();
 	return ret;
@@ -258,9 +253,11 @@ EXPORT_SYMBOL_GPL(mptcp_pm_get_local_addr_max);
 
 static void check_work_pending(struct mptcp_sock *msk)
 {
-	if (msk->pm.add_addr_signaled == mptcp_pm_get_add_addr_signal_max(msk) &&
-	    (msk->pm.local_addr_used == mptcp_pm_get_local_addr_max(msk) ||
-	     msk->pm.subflows == mptcp_pm_get_subflows_max(msk)))
+	struct pm_nl_pernet *pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+
+	if (msk->pm.subflows == mptcp_pm_get_subflows_max(msk) ||
+	    (find_next_and_bit(pernet->id_bitmap, msk->pm.id_avail_bitmap,
+			       MPTCP_PM_MAX_ADDR_ID + 1, 0) == MPTCP_PM_MAX_ADDR_ID + 1))
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
@@ -460,6 +457,35 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	return i;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (entry->addr.id == id)
+			return entry;
+	}
+	return NULL;
+}
+
+static int
+lookup_id_by_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_addr_entry *entry;
+	int ret = -1;
+
+	rcu_read_lock();
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, addr, entry->addr.port)) {
+			ret = entry->addr.id;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -475,6 +501,19 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	local_addr_max = mptcp_pm_get_local_addr_max(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
+	/* do lazy endpoint usage accounting for the MPC subflows */
+	if (unlikely(!(msk->pm.status & BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED))) && msk->first) {
+		struct mptcp_addr_info local;
+		int mpc_id;
+
+		local_address((struct sock_common *)msk->first, &local);
+		mpc_id = lookup_id_by_addr(pernet, &local);
+		if (mpc_id < 0)
+			__clear_bit(mpc_id, msk->pm.id_avail_bitmap);
+
+		msk->pm.status |= BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED);
+	}
+
 	pr_debug("local %d:%d signal %d:%d subflows %d:%d\n",
 		 msk->pm.local_addr_used, local_addr_max,
 		 msk->pm.add_addr_signaled, add_addr_signal_max,
@@ -482,21 +521,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
-		local = select_signal_address(pernet,
-					      msk->pm.add_addr_signaled);
+		local = select_signal_address(pernet, msk);
 
 		if (local) {
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
+				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 				msk->pm.add_addr_signaled++;
 				mptcp_pm_announce_addr(msk, &local->addr, false);
 				mptcp_pm_nl_addr_send_ack(msk);
 			}
-		} else {
-			/* pick failed, avoid fourther attempts later */
-			msk->pm.local_addr_used = add_addr_signal_max;
 		}
-
-		check_work_pending(msk);
 	}
 
 	/* check if should create a new subflow */
@@ -510,19 +544,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			int i, nr;
 
 			msk->pm.local_addr_used++;
-			check_work_pending(msk);
 			nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
+			if (nr)
+				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 			spin_unlock_bh(&msk->pm.lock);
 			for (i = 0; i < nr; i++)
 				__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
 			spin_lock_bh(&msk->pm.lock);
-			return;
 		}
-
-		/* lookup failed, avoid fourther attempts later */
-		msk->pm.local_addr_used = local_addr_max;
-		check_work_pending(msk);
 	}
+	check_work_pending(msk);
 }
 
 static void mptcp_pm_nl_fully_established(struct mptcp_sock *msk)
@@ -736,6 +767,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
+		__set_bit(rm_list->ids[1], msk->pm.id_avail_bitmap);
 		if (!removed)
 			continue;
 
@@ -765,6 +797,9 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk)
 
 	msk_owned_by_me(msk);
 
+	if (!(pm->status & MPTCP_PM_WORK_MASK))
+		return;
+
 	spin_lock_bh(&msk->pm.lock);
 
 	pr_debug("msk=%p status=%x", msk, pm->status);
@@ -810,7 +845,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	/* to keep the code simple, don't do IDR-like allocation for address ID,
 	 * just bail when we exceed limits
 	 */
-	if (pernet->next_id == MAX_ADDR_ID)
+	if (pernet->next_id == MPTCP_PM_MAX_ADDR_ID)
 		pernet->next_id = 1;
 	if (pernet->addrs >= MPTCP_PM_ADDR_MAX)
 		goto out;
@@ -830,7 +865,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	if (!entry->addr.id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
-						    MAX_ADDR_ID + 1,
+						    MPTCP_PM_MAX_ADDR_ID + 1,
 						    pernet->next_id);
 		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
@@ -1197,18 +1232,6 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static struct mptcp_pm_addr_entry *
-__lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
-{
-	struct mptcp_pm_addr_entry *entry;
-
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (entry->addr.id == id)
-			return entry;
-	}
-	return NULL;
-}
-
 int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
 					 u8 *flags, int *ifindex)
 {
@@ -1467,7 +1490,7 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	list_splice_init(&pernet->local_addr_list, &free_list);
 	__reset_counters(pernet);
 	pernet->next_id = 1;
-	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
+	bitmap_zero(pernet->id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
 	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
 	synchronize_rcu();
@@ -1577,7 +1600,7 @@ static int mptcp_nl_cmd_dump_addrs(struct sk_buff *msg,
 	pernet = net_generic(net, pm_nl_pernet_id);
 
 	spin_lock_bh(&pernet->lock);
-	for (i = id; i < MAX_ADDR_ID + 1; i++) {
+	for (i = id; i < MPTCP_PM_MAX_ADDR_ID + 1; i++) {
 		if (test_bit(i, pernet->id_bitmap)) {
 			entry = __lookup_addr_by_id(pernet, i);
 			if (!entry)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 667e153e6e24..5c956a8dc714 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2488,8 +2488,7 @@ static void mptcp_worker(struct work_struct *work)
 
 	mptcp_check_fastclose(msk);
 
-	if (msk->pm.status)
-		mptcp_pm_nl_work(msk);
+	mptcp_pm_nl_work(msk);
 
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 386d1a98ff1d..2a6f0960ba27 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -173,16 +173,25 @@ enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_SEND_ACK,
 	MPTCP_PM_RM_ADDR_RECEIVED,
 	MPTCP_PM_ESTABLISHED,
-	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
+	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
+	MPTCP_PM_MPC_ENDPOINT_ACCOUNTED /* persistent status, set after MPC local address is
+					 * accounted int id_avail_bitmap
+					 */
 };
 
+/* Status bits below MPTCP_PM_ALREADY_ESTABLISHED need pm worker actions */
+#define MPTCP_PM_WORK_MASK ((1 << MPTCP_PM_ALREADY_ESTABLISHED) - 1)
+
 enum mptcp_addr_signal_status {
 	MPTCP_ADD_ADDR_SIGNAL,
 	MPTCP_ADD_ADDR_ECHO,
 	MPTCP_RM_ADDR_SIGNAL,
 };
 
+/* max value of mptcp_addr_info.id */
+#define MPTCP_PM_MAX_ADDR_ID		U8_MAX
+
 struct mptcp_pm_data {
 	struct mptcp_addr_info local;
 	struct mptcp_addr_info remote;
@@ -201,6 +210,7 @@ struct mptcp_pm_data {
 	u8		local_addr_used;
 	u8		subflows;
 	u8		status;
+	DECLARE_BITMAP(id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	struct mptcp_rm_list rm_list_tx;
 	struct mptcp_rm_list rm_list_rx;
 };
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 7ef639a9d4a6..bbafa4cf5453 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1071,7 +1071,10 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
-	chk_add_nr 4 4
+
+	# the server will not signal the address terminating
+	# the MPC subflow
+	chk_add_nr 3 3
 }
 
 link_failure_tests()
-- 
2.34.1

