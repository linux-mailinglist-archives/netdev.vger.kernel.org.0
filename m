Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3165D356015
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347527AbhDGARE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:17:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:23775 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347437AbhDGAQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:38 -0400
IronPort-SDR: C4npFCNsFJ5vq+5QyEdhundHuJ908rwT6aK+JS95nCB9h9sGAp3gCbNoy2IfFaBZQ41DB09mwb
 MClA9WLE5zow==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297250"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297250"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
IronPort-SDR: cBpZKbqlBOlINpAEXE1JMUm12KPj55JQGhTnWZO3eayaNqMZDmJg3nfqMyJ/pOc7WA2VenjEKg
 ovdvZAOZi5lw==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105192"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: move flags and ifindex out of mptcp_addr_info
Date:   Tue,  6 Apr 2021 17:15:57 -0700
Message-Id: <20210407001604.85071-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch moved the flags and ifindex fields from struct mptcp_addr_info
to struct mptcp_pm_addr_entry. Add the flags and ifindex values as two new
parameters to __mptcp_subflow_connect.

In mptcp_pm_create_subflow_or_signal_addr, pass the local address entry's
flags and ifindex fields to __mptcp_subflow_connect.

In mptcp_pm_nl_add_addr_received, just pass two zeros to it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 41 ++++++++++++++++++++++-------------------
 net/mptcp/protocol.h   |  5 ++---
 net/mptcp/subflow.c    |  7 ++++---
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 51be6c34b339..6ba040897738 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -25,6 +25,8 @@ static int pm_nl_pernet_id;
 struct mptcp_pm_addr_entry {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
+	u8			flags;
+	int			ifindex;
 	struct rcu_head		rcu;
 	struct socket		*lsk;
 };
@@ -168,7 +170,7 @@ select_local_address(const struct pm_nl_pernet *pernet,
 	rcu_read_lock();
 	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
+		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
 
 		if (entry->addr.family != sk->sk_family) {
@@ -206,7 +208,7 @@ select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
 	 * can lead to additional addresses not being announced.
 	 */
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 			continue;
 		if (i++ == pos) {
 			ret = entry;
@@ -459,7 +461,8 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			check_work_pending(msk);
 			remote_address((struct sock_common *)sk, &remote);
 			spin_unlock_bh(&msk->pm.lock);
-			__mptcp_subflow_connect(sk, &local->addr, &remote);
+			__mptcp_subflow_connect(sk, &local->addr, &remote,
+						local->flags, local->ifindex);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}
@@ -514,7 +517,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	local.family = remote.family;
 
 	spin_unlock_bh(&msk->pm.lock);
-	__mptcp_subflow_connect(sk, &local, &remote);
+	__mptcp_subflow_connect(sk, &local, &remote, 0, 0);
 	spin_lock_bh(&msk->pm.lock);
 
 add_addr_echo:
@@ -683,7 +686,7 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk)
 
 static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 {
-	return (entry->addr.flags &
+	return (entry->flags &
 		(MPTCP_PM_ADDR_FLAG_SIGNAL | MPTCP_PM_ADDR_FLAG_SUBFLOW)) ==
 		MPTCP_PM_ADDR_FLAG_SIGNAL;
 }
@@ -735,11 +738,11 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	if (entry->addr.id > pernet->next_id)
 		pernet->next_id = entry->addr.id;
 
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
+	if (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
 		addr_max = pernet->add_addr_signal_max;
 		WRITE_ONCE(pernet->add_addr_signal_max, addr_max + 1);
 	}
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+	if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
 		addr_max = pernet->local_addr_max;
 		WRITE_ONCE(pernet->local_addr_max, addr_max + 1);
 	}
@@ -841,10 +844,10 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 		return -ENOMEM;
 
 	entry->addr = skc_local;
-	entry->addr.ifindex = 0;
-	entry->addr.flags = 0;
 	entry->addr.id = 0;
 	entry->addr.port = 0;
+	entry->ifindex = 0;
+	entry->flags = 0;
 	entry->lsk = NULL;
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
@@ -959,14 +962,14 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 	if (tb[MPTCP_PM_ADDR_ATTR_IF_IDX]) {
 		u32 val = nla_get_s32(tb[MPTCP_PM_ADDR_ATTR_IF_IDX]);
 
-		entry->addr.ifindex = val;
+		entry->ifindex = val;
 	}
 
 	if (tb[MPTCP_PM_ADDR_ATTR_ID])
 		entry->addr.id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->addr.flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
 	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));
@@ -1218,11 +1221,11 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 		spin_unlock_bh(&pernet->lock);
 		return -EINVAL;
 	}
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
+	if (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
 		addr_max = pernet->add_addr_signal_max;
 		WRITE_ONCE(pernet->add_addr_signal_max, addr_max - 1);
 	}
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+	if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
 		addr_max = pernet->local_addr_max;
 		WRITE_ONCE(pernet->local_addr_max, addr_max - 1);
 	}
@@ -1338,10 +1341,10 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_u8(skb, MPTCP_PM_ADDR_ATTR_ID, addr->id))
 		goto nla_put_failure;
-	if (nla_put_u32(skb, MPTCP_PM_ADDR_ATTR_FLAGS, entry->addr.flags))
+	if (nla_put_u32(skb, MPTCP_PM_ADDR_ATTR_FLAGS, entry->flags))
 		goto nla_put_failure;
-	if (entry->addr.ifindex &&
-	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->addr.ifindex))
+	if (entry->ifindex &&
+	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
 		goto nla_put_failure;
 
 	if (addr->family == AF_INET &&
@@ -1569,7 +1572,7 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 
-	if (addr.addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
+	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
@@ -1579,9 +1582,9 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 				return ret;
 
 			if (bkup)
-				entry->addr.flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
 			else
-				entry->addr.flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
 		}
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 40e9b05856cd..cb5dad522f39 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -173,8 +173,6 @@ struct mptcp_addr_info {
 	sa_family_t		family;
 	__be16			port;
 	u8			id;
-	u8			flags;
-	int			ifindex;
 	union {
 		struct in_addr addr;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -557,7 +555,8 @@ struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
-			    const struct mptcp_addr_info *remote);
+			    const struct mptcp_addr_info *remote,
+			    u8 flags, int ifindex);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 223d6be5fc3b..3c19a5265a0f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1256,7 +1256,8 @@ void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 }
 
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
-			    const struct mptcp_addr_info *remote)
+			    const struct mptcp_addr_info *remote,
+			    u8 flags, int ifindex)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_subflow_context *subflow;
@@ -1300,7 +1301,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (addr.ss_family == AF_INET6)
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
-	ssk->sk_bound_dev_if = loc->ifindex;
+	ssk->sk_bound_dev_if = ifindex;
 	err = kernel_bind(sf, (struct sockaddr *)&addr, addrlen);
 	if (err)
 		goto failed;
@@ -1312,7 +1313,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->local_id = local_id;
 	subflow->remote_id = remote_id;
 	subflow->request_join = 1;
-	subflow->request_bkup = !!(loc->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
+	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
 
 	mptcp_add_pending_subflow(msk, subflow);
-- 
2.31.1

