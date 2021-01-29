Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B443130831D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhA2BQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:16:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:6819 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231771AbhA2BQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:16:24 -0500
IronPort-SDR: EW0Dc6ScpwnPD/tupf4PftYiTPCj7WExWDWoKEoY0naAnWG6zLaufJrzF00FpShKu0RPUYUVUU
 g/mrhUZIIqTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430173"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430173"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: /dhiu3YY8DjmYx4CUqxcfIXYd/j4TJ6F7T3sBXA0Uo5Et7rbV8VH6fUAmAqOHbCsOF2LimgiTI
 QlcJoug1lLRQ==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538333"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/16] mptcp: create the listening socket for new port
Date:   Thu, 28 Jan 2021 17:11:06 -0800
Message-Id: <20210129011115.133953-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch creates a listening socket when an address with a port-number
is added by PM netlink. Then binds the new port to the socket, and
listens for new connections.

When the address is removed or the addresses are flushed by PM netlink,
release the listening socket.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.c   |  2 +-
 net/mptcp/protocol.h   |  4 ++
 net/mptcp/subflow.c    |  6 +--
 4 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 78a157a30c68..5ab79f659c6d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -26,6 +26,7 @@ struct mptcp_pm_addr_entry {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
 	struct rcu_head		rcu;
+	struct socket		*lsk;
 };
 
 struct mptcp_pm_add_entry {
@@ -678,6 +679,53 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	return ret;
 }
 
+static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
+					    struct mptcp_pm_addr_entry *entry)
+{
+	struct sockaddr_storage addr;
+	struct mptcp_sock *msk;
+	struct socket *ssock;
+	int backlog = 1024;
+	int err;
+
+	err = sock_create_kern(sock_net(sk), entry->addr.family,
+			       SOCK_STREAM, IPPROTO_MPTCP, &entry->lsk);
+	if (err)
+		return err;
+
+	msk = mptcp_sk(entry->lsk->sk);
+	if (!msk) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
+	err = kernel_bind(ssock, (struct sockaddr *)&addr,
+			  sizeof(struct sockaddr_in));
+	if (err) {
+		pr_warn("kernel_bind error, err=%d", err);
+		goto out;
+	}
+
+	err = kernel_listen(ssock, backlog);
+	if (err) {
+		pr_warn("kernel_listen error, err=%d", err);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	sock_release(entry->lsk);
+	return err;
+}
+
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 {
 	struct mptcp_pm_addr_entry *entry;
@@ -722,6 +770,8 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	entry->addr.ifindex = 0;
 	entry->addr.flags = 0;
 	entry->addr.id = 0;
+	entry->addr.port = 0;
+	entry->lsk = NULL;
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
 		kfree(entry);
@@ -891,9 +941,19 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	*entry = addr;
+	if (entry->addr.port) {
+		ret = mptcp_pm_nl_create_listen_socket(skb->sk, entry);
+		if (ret) {
+			GENL_SET_ERR_MSG(info, "create listen socket error");
+			kfree(entry);
+			return ret;
+		}
+	}
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
+		if (entry->lsk)
+			sock_release(entry->lsk);
 		kfree(entry);
 		return ret;
 	}
@@ -977,6 +1037,38 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 	return 0;
 }
 
+struct addr_entry_release_work {
+	struct rcu_work	rwork;
+	struct mptcp_pm_addr_entry *entry;
+};
+
+static void mptcp_pm_release_addr_entry(struct work_struct *work)
+{
+	struct addr_entry_release_work *w;
+	struct mptcp_pm_addr_entry *entry;
+
+	w = container_of(to_rcu_work(work), struct addr_entry_release_work, rwork);
+	entry = w->entry;
+	if (entry) {
+		if (entry->lsk)
+			sock_release(entry->lsk);
+		kfree(entry);
+	}
+	kfree(w);
+}
+
+static void mptcp_pm_free_addr_entry(struct mptcp_pm_addr_entry *entry)
+{
+	struct addr_entry_release_work *w;
+
+	w = kmalloc(sizeof(*w), GFP_ATOMIC);
+	if (w) {
+		INIT_RCU_WORK(&w->rwork, mptcp_pm_release_addr_entry);
+		w->entry = entry;
+		queue_rcu_work(system_wq, &w->rwork);
+	}
+}
+
 static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -1011,7 +1103,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	spin_unlock_bh(&pernet->lock);
 
 	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
-	kfree_rcu(entry, rcu);
+	mptcp_pm_free_addr_entry(entry);
 
 	return ret;
 }
@@ -1025,7 +1117,7 @@ static void __flush_addrs(struct net *net, struct list_head *list)
 				 struct mptcp_pm_addr_entry, list);
 		mptcp_nl_remove_subflow_and_signal_addr(net, &cur->addr);
 		list_del_rcu(&cur->list);
-		kfree_rcu(cur, rcu);
+		mptcp_pm_free_addr_entry(cur);
 	}
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a033bf9c26ee..1405e146dd7c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -52,7 +52,7 @@ static struct net_device mptcp_napi_dev;
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
  */
-static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
+struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 {
 	if (!msk->subflow || READ_ONCE(msk->can_ack))
 		return NULL;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fcab3784e4fa..7e0d8774c673 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -537,11 +537,15 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
+struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 			    const struct mptcp_addr_info *remote);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
+void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
+			 struct sockaddr_storage *addr,
+			 unsigned short family);
 
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 					      struct mptcp_subflow_context *ctx)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 586156281e5a..50a01546ac34 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1084,9 +1084,9 @@ void mptcpv6_handle_mapped(struct sock *sk, bool mapped)
 }
 #endif
 
-static void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
-				struct sockaddr_storage *addr,
-				unsigned short family)
+void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
+			 struct sockaddr_storage *addr,
+			 unsigned short family)
 {
 	memset(addr, 0, sizeof(*addr));
 	addr->ss_family = family;
-- 
2.30.0

