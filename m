Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0823EF571
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhHQWIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:08:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:12963 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235578AbhHQWIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:08:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="301788853"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="301788853"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="573058342"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.45])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@xiaomi.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: drop flags and ifindex arguments
Date:   Tue, 17 Aug 2021 15:07:22 -0700
Message-Id: <20210817220727.192198-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
References: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@xiaomi.com>

This patch added a new helper mptcp_pm_get_flags_and_ifindex_by_id(),
and used it in __mptcp_subflow_connect() to get the flags and ifindex
values.

Then the two arguments flags and ifindex of __mptcp_subflow_connect()
can be dropped.

Signed-off-by: Geliang Tang <geliangtang@xiaomi.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 26 +++++++++++++++++++++++---
 net/mptcp/protocol.h   |  5 +++--
 net/mptcp/subflow.c    |  7 +++++--
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ac0aa6faacfa..64a39f30659f 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -462,8 +462,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			check_work_pending(msk);
 			remote_address((struct sock_common *)sk, &remote);
 			spin_unlock_bh(&msk->pm.lock);
-			__mptcp_subflow_connect(sk, &local->addr, &remote,
-						local->flags, local->ifindex);
+			__mptcp_subflow_connect(sk, &local->addr, &remote);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}
@@ -518,7 +517,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	local.family = remote.family;
 
 	spin_unlock_bh(&msk->pm.lock);
-	__mptcp_subflow_connect(sk, &local, &remote, 0, 0);
+	__mptcp_subflow_connect(sk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 
 add_addr_echo:
@@ -1105,6 +1104,27 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 	return NULL;
 }
 
+int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
+					 u8 *flags, int *ifindex)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	*flags = 0;
+	*ifindex = 0;
+
+	if (id) {
+		rcu_read_lock();
+		entry = __lookup_addr_by_id(net_generic(net, pm_nl_pernet_id), id);
+		if (entry) {
+			*flags = entry->flags;
+			*ifindex = entry->ifindex;
+		}
+		rcu_read_unlock();
+	}
+
+	return 0;
+}
+
 static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 				      struct mptcp_addr_info *addr)
 {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8bdd038def38..bc1bfd7ac9c1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -577,8 +577,7 @@ struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
-			    const struct mptcp_addr_info *remote,
-			    u8 flags, int ifindex);
+			    const struct mptcp_addr_info *remote);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
@@ -733,6 +732,8 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 struct mptcp_pm_add_entry *
 mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 				struct mptcp_addr_info *addr);
+int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
+					 u8 *flags, int *ifindex);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1151926d335b..8c43aa14897a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1355,8 +1355,7 @@ void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 }
 
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
-			    const struct mptcp_addr_info *remote,
-			    u8 flags, int ifindex)
+			    const struct mptcp_addr_info *remote)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_subflow_context *subflow;
@@ -1367,6 +1366,8 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	struct sock *ssk;
 	u32 remote_token;
 	int addrlen;
+	int ifindex;
+	u8 flags;
 	int err;
 
 	if (!mptcp_is_fully_established(sk))
@@ -1390,6 +1391,8 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 		local_id = err;
 	}
 
+	mptcp_pm_get_flags_and_ifindex_by_id(sock_net(sk), local_id,
+					     &flags, &ifindex);
 	subflow->remote_key = msk->remote_key;
 	subflow->local_key = msk->local_key;
 	subflow->token = msk->token;
-- 
2.33.0

