Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26C831A88E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBMADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:03:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:41549 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhBMADp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:03:45 -0500
IronPort-SDR: RItGRkFpWah8NQpZVdwNtYqRluEVIYCstX2aDoc++pyVKDEqkPPhpEnaitc1woR2EJfKuHdLk7
 NnkeFu3aOKNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179937491"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179937491"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:15 -0800
IronPort-SDR: LiS9m2dhIHlQv2/xllvcL4ZeJJrDpwAG6Hz6U/voGZutKXE+yiDtBBehVT33q2i/ATn/tAFDp7
 LovMLM1SHcmw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381142"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:15 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] mptcp: add netlink event support
Date:   Fri, 12 Feb 2021 16:00:01 -0800
Message-Id: <20210213000001.379332-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allow userspace (mptcpd) to subscribe to mptcp genl multicast events.
This implementation reuses the same event API as the mptcp kernel fork
to ease integration of existing tools, e.g. mptcpd.

Supported events include:
1. start and close of an mptcp connection
2. start and close of subflows (joins)
3. announce and withdrawals of addresses
4. subflow priority (backup/non-backup) change.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  74 +++++++++++
 net/mptcp/pm.c             |  20 ++-
 net/mptcp/pm_netlink.c     | 261 ++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.c       |  10 +-
 net/mptcp/protocol.h       |   6 +
 5 files changed, 364 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 3674a451a18c..c91578aaab32 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -36,6 +36,7 @@ enum {
 /* netlink interface */
 #define MPTCP_PM_NAME		"mptcp_pm"
 #define MPTCP_PM_CMD_GRP_NAME	"mptcp_pm_cmds"
+#define MPTCP_PM_EV_GRP_NAME	"mptcp_pm_events"
 #define MPTCP_PM_VER		0x1
 
 /*
@@ -104,4 +105,77 @@ struct mptcp_info {
 	__u64	mptcpi_rcv_nxt;
 };
 
+/*
+ * MPTCP_EVENT_CREATED: token, family, saddr4 | saddr6, daddr4 | daddr6,
+ *                      sport, dport
+ * A new MPTCP connection has been created. It is the good time to allocate
+ * memory and send ADD_ADDR if needed. Depending on the traffic-patterns
+ * it can take a long time until the MPTCP_EVENT_ESTABLISHED is sent.
+ *
+ * MPTCP_EVENT_ESTABLISHED: token, family, saddr4 | saddr6, daddr4 | daddr6,
+ *			    sport, dport
+ * A MPTCP connection is established (can start new subflows).
+ *
+ * MPTCP_EVENT_CLOSED: token
+ * A MPTCP connection has stopped.
+ *
+ * MPTCP_EVENT_ANNOUNCED: token, rem_id, family, daddr4 | daddr6 [, dport]
+ * A new address has been announced by the peer.
+ *
+ * MPTCP_EVENT_REMOVED: token, rem_id
+ * An address has been lost by the peer.
+ *
+ * MPTCP_EVENT_SUB_ESTABLISHED: token, family, saddr4 | saddr6,
+ *                              daddr4 | daddr6, sport, dport, backup,
+ *                              if_idx [, error]
+ * A new subflow has been established. 'error' should not be set.
+ *
+ * MPTCP_EVENT_SUB_CLOSED: token, family, saddr4 | saddr6, daddr4 | daddr6,
+ *                         sport, dport, backup, if_idx [, error]
+ * A subflow has been closed. An error (copy of sk_err) could be set if an
+ * error has been detected for this subflow.
+ *
+ * MPTCP_EVENT_SUB_PRIORITY: token, family, saddr4 | saddr6, daddr4 | daddr6,
+ *                           sport, dport, backup, if_idx [, error]
+ *       The priority of a subflow has changed. 'error' should not be set.
+ */
+enum mptcp_event_type {
+	MPTCP_EVENT_UNSPEC = 0,
+	MPTCP_EVENT_CREATED = 1,
+	MPTCP_EVENT_ESTABLISHED = 2,
+	MPTCP_EVENT_CLOSED = 3,
+
+	MPTCP_EVENT_ANNOUNCED = 6,
+	MPTCP_EVENT_REMOVED = 7,
+
+	MPTCP_EVENT_SUB_ESTABLISHED = 10,
+	MPTCP_EVENT_SUB_CLOSED = 11,
+
+	MPTCP_EVENT_SUB_PRIORITY = 13,
+};
+
+enum mptcp_event_attr {
+	MPTCP_ATTR_UNSPEC = 0,
+
+	MPTCP_ATTR_TOKEN,	/* u32 */
+	MPTCP_ATTR_FAMILY,	/* u16 */
+	MPTCP_ATTR_LOC_ID,	/* u8 */
+	MPTCP_ATTR_REM_ID,	/* u8 */
+	MPTCP_ATTR_SADDR4,	/* be32 */
+	MPTCP_ATTR_SADDR6,	/* struct in6_addr */
+	MPTCP_ATTR_DADDR4,	/* be32 */
+	MPTCP_ATTR_DADDR6,	/* struct in6_addr */
+	MPTCP_ATTR_SPORT,	/* be16 */
+	MPTCP_ATTR_DPORT,	/* be16 */
+	MPTCP_ATTR_BACKUP,	/* u8 */
+	MPTCP_ATTR_ERROR,	/* u8 */
+	MPTCP_ATTR_FLAGS,	/* u16 */
+	MPTCP_ATTR_TIMEOUT,	/* u32 */
+	MPTCP_ATTR_IF_IDX,	/* s32 */
+
+	__MPTCP_ATTR_AFTER_LAST
+};
+
+#define MPTCP_ATTR_MAX (__MPTCP_ATTR_AFTER_LAST - 1)
+
 #endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 1dd0e9d7ed06..6fd4b2c1b076 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -75,6 +75,7 @@ void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int
 	pr_debug("msk=%p, token=%u side=%d", msk, msk->token, server_side);
 
 	WRITE_ONCE(pm->server_side, server_side);
+	mptcp_event(MPTCP_EVENT_CREATED, msk, ssk, GFP_ATOMIC);
 }
 
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
@@ -122,13 +123,10 @@ static bool mptcp_pm_schedule_work(struct mptcp_sock *msk,
 void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk, gfp_t gfp)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
+	bool announce = false;
 
 	pr_debug("msk=%p", msk);
 
-	/* try to avoid acquiring the lock below */
-	if (!READ_ONCE(pm->work_pending))
-		return;
-
 	spin_lock_bh(&pm->lock);
 
 	/* mptcp_pm_fully_established() can be invoked by multiple
@@ -138,9 +136,15 @@ void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk,
 	if (READ_ONCE(pm->work_pending) &&
 	    !(msk->pm.status & BIT(MPTCP_PM_ALREADY_ESTABLISHED)))
 		mptcp_pm_schedule_work(msk, MPTCP_PM_ESTABLISHED);
-	msk->pm.status |= BIT(MPTCP_PM_ALREADY_ESTABLISHED);
 
+	if ((msk->pm.status & BIT(MPTCP_PM_ALREADY_ESTABLISHED)) == 0)
+		announce = true;
+
+	msk->pm.status |= BIT(MPTCP_PM_ALREADY_ESTABLISHED);
 	spin_unlock_bh(&pm->lock);
+
+	if (announce)
+		mptcp_event(MPTCP_EVENT_ESTABLISHED, msk, ssk, gfp);
 }
 
 void mptcp_pm_connection_closed(struct mptcp_sock *msk)
@@ -179,6 +183,8 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 	pr_debug("msk=%p remote_id=%d accept=%d", msk, addr->id,
 		 READ_ONCE(pm->accept_addr));
 
+	mptcp_event_addr_announced(msk, addr);
+
 	spin_lock_bh(&pm->lock);
 
 	if (!READ_ONCE(pm->accept_addr)) {
@@ -205,6 +211,8 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
 
 	pr_debug("msk=%p remote_id=%d", msk, rm_id);
 
+	mptcp_event_addr_removed(msk, rm_id);
+
 	spin_lock_bh(&pm->lock);
 	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
 	pm->rm_id = rm_id;
@@ -217,6 +225,8 @@ void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup)
 
 	pr_debug("subflow->backup=%d, bkup=%d\n", subflow->backup, bkup);
 	subflow->backup = bkup;
+
+	mptcp_event(MPTCP_EVENT_SUB_PRIORITY, mptcp_sk(subflow->conn), sk, GFP_ATOMIC);
 }
 
 /* path manager helpers */
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c3abff40fa4e..229fd1af2e29 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -860,10 +860,14 @@ void mptcp_pm_nl_data_init(struct mptcp_sock *msk)
 	WRITE_ONCE(pm->accept_subflow, subflows);
 }
 
-#define MPTCP_PM_CMD_GRP_OFFSET	0
+#define MPTCP_PM_CMD_GRP_OFFSET       0
+#define MPTCP_PM_EV_GRP_OFFSET        1
 
 static const struct genl_multicast_group mptcp_pm_mcgrps[] = {
 	[MPTCP_PM_CMD_GRP_OFFSET]	= { .name = MPTCP_PM_CMD_GRP_NAME, },
+	[MPTCP_PM_EV_GRP_OFFSET]        = { .name = MPTCP_PM_EV_GRP_NAME,
+					    .flags = GENL_UNS_ADMIN_PERM,
+					  },
 };
 
 static const struct nla_policy
@@ -1482,6 +1486,261 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static void mptcp_nl_mcast_send(struct net *net, struct sk_buff *nlskb, gfp_t gfp)
+{
+	genlmsg_multicast_netns(&mptcp_genl_family, net,
+				nlskb, 0, MPTCP_PM_EV_GRP_OFFSET, gfp);
+}
+
+static int mptcp_event_add_subflow(struct sk_buff *skb, const struct sock *ssk)
+{
+	const struct inet_sock *issk = inet_sk(ssk);
+	const struct mptcp_subflow_context *sf;
+
+	if (nla_put_u16(skb, MPTCP_ATTR_FAMILY, ssk->sk_family))
+		return -EMSGSIZE;
+
+	switch (ssk->sk_family) {
+	case AF_INET:
+		if (nla_put_in_addr(skb, MPTCP_ATTR_SADDR4, issk->inet_saddr))
+			return -EMSGSIZE;
+		if (nla_put_in_addr(skb, MPTCP_ATTR_DADDR4, issk->inet_daddr))
+			return -EMSGSIZE;
+		break;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	case AF_INET6: {
+		const struct ipv6_pinfo *np = inet6_sk(ssk);
+
+		if (nla_put_in6_addr(skb, MPTCP_ATTR_SADDR6, &np->saddr))
+			return -EMSGSIZE;
+		if (nla_put_in6_addr(skb, MPTCP_ATTR_DADDR6, &ssk->sk_v6_daddr))
+			return -EMSGSIZE;
+		break;
+	}
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		return -EMSGSIZE;
+	}
+
+	if (nla_put_be16(skb, MPTCP_ATTR_SPORT, issk->inet_sport))
+		return -EMSGSIZE;
+	if (nla_put_be16(skb, MPTCP_ATTR_DPORT, issk->inet_dport))
+		return -EMSGSIZE;
+
+	sf = mptcp_subflow_ctx(ssk);
+	if (WARN_ON_ONCE(!sf))
+		return -EINVAL;
+
+	if (nla_put_u8(skb, MPTCP_ATTR_LOC_ID, sf->local_id))
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, MPTCP_ATTR_REM_ID, sf->remote_id))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int mptcp_event_put_token_and_ssk(struct sk_buff *skb,
+					 const struct mptcp_sock *msk,
+					 const struct sock *ssk)
+{
+	const struct sock *sk = (const struct sock *)msk;
+	const struct mptcp_subflow_context *sf;
+	u8 sk_err;
+
+	if (nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token))
+		return -EMSGSIZE;
+
+	if (mptcp_event_add_subflow(skb, ssk))
+		return -EMSGSIZE;
+
+	sf = mptcp_subflow_ctx(ssk);
+	if (WARN_ON_ONCE(!sf))
+		return -EINVAL;
+
+	if (nla_put_u8(skb, MPTCP_ATTR_BACKUP, sf->backup))
+		return -EMSGSIZE;
+
+	if (ssk->sk_bound_dev_if &&
+	    nla_put_s32(skb, MPTCP_ATTR_IF_IDX, ssk->sk_bound_dev_if))
+		return -EMSGSIZE;
+
+	sk_err = ssk->sk_err;
+	if (sk_err && sk->sk_state == TCP_ESTABLISHED &&
+	    nla_put_u8(skb, MPTCP_ATTR_ERROR, sk_err))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int mptcp_event_sub_established(struct sk_buff *skb,
+				       const struct mptcp_sock *msk,
+				       const struct sock *ssk)
+{
+	return mptcp_event_put_token_and_ssk(skb, msk, ssk);
+}
+
+static int mptcp_event_sub_closed(struct sk_buff *skb,
+				  const struct mptcp_sock *msk,
+				  const struct sock *ssk)
+{
+	if (mptcp_event_put_token_and_ssk(skb, msk, ssk))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int mptcp_event_created(struct sk_buff *skb,
+			       const struct mptcp_sock *msk,
+			       const struct sock *ssk)
+{
+	int err = nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token);
+
+	if (err)
+		return err;
+
+	return mptcp_event_add_subflow(skb, ssk);
+}
+
+void mptcp_event_addr_removed(const struct mptcp_sock *msk, uint8_t id)
+{
+	struct net *net = sock_net((const struct sock *)msk);
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+
+	if (!genl_has_listeners(&mptcp_genl_family, net, MPTCP_PM_EV_GRP_OFFSET))
+		return;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	nlh = genlmsg_put(skb, 0, 0, &mptcp_genl_family, 0, MPTCP_EVENT_REMOVED);
+	if (!nlh)
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, MPTCP_ATTR_REM_ID, id))
+		goto nla_put_failure;
+
+	genlmsg_end(skb, nlh);
+	mptcp_nl_mcast_send(net, skb, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+}
+
+void mptcp_event_addr_announced(const struct mptcp_sock *msk,
+				const struct mptcp_addr_info *info)
+{
+	struct net *net = sock_net((const struct sock *)msk);
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+
+	if (!genl_has_listeners(&mptcp_genl_family, net, MPTCP_PM_EV_GRP_OFFSET))
+		return;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	nlh = genlmsg_put(skb, 0, 0, &mptcp_genl_family, 0,
+			  MPTCP_EVENT_ANNOUNCED);
+	if (!nlh)
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, MPTCP_ATTR_REM_ID, info->id))
+		goto nla_put_failure;
+
+	if (nla_put_be16(skb, MPTCP_ATTR_DPORT, info->port))
+		goto nla_put_failure;
+
+	switch (info->family) {
+	case AF_INET:
+		if (nla_put_in_addr(skb, MPTCP_ATTR_DADDR4, info->addr.s_addr))
+			goto nla_put_failure;
+		break;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	case AF_INET6:
+		if (nla_put_in6_addr(skb, MPTCP_ATTR_DADDR6, &info->addr6))
+			goto nla_put_failure;
+		break;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		goto nla_put_failure;
+	}
+
+	genlmsg_end(skb, nlh);
+	mptcp_nl_mcast_send(net, skb, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+}
+
+void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
+		 const struct sock *ssk, gfp_t gfp)
+{
+	struct net *net = sock_net((const struct sock *)msk);
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+
+	if (!genl_has_listeners(&mptcp_genl_family, net, MPTCP_PM_EV_GRP_OFFSET))
+		return;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!skb)
+		return;
+
+	nlh = genlmsg_put(skb, 0, 0, &mptcp_genl_family, 0, type);
+	if (!nlh)
+		goto nla_put_failure;
+
+	switch (type) {
+	case MPTCP_EVENT_UNSPEC:
+		WARN_ON_ONCE(1);
+		break;
+	case MPTCP_EVENT_CREATED:
+	case MPTCP_EVENT_ESTABLISHED:
+		if (mptcp_event_created(skb, msk, ssk) < 0)
+			goto nla_put_failure;
+		break;
+	case MPTCP_EVENT_CLOSED:
+		if (nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token) < 0)
+			goto nla_put_failure;
+		break;
+	case MPTCP_EVENT_ANNOUNCED:
+	case MPTCP_EVENT_REMOVED:
+		/* call mptcp_event_addr_announced()/removed instead */
+		WARN_ON_ONCE(1);
+		break;
+	case MPTCP_EVENT_SUB_ESTABLISHED:
+	case MPTCP_EVENT_SUB_PRIORITY:
+		if (mptcp_event_sub_established(skb, msk, ssk) < 0)
+			goto nla_put_failure;
+		break;
+	case MPTCP_EVENT_SUB_CLOSED:
+		if (mptcp_event_sub_closed(skb, msk, ssk) < 0)
+			goto nla_put_failure;
+		break;
+	}
+
+	genlmsg_end(skb, nlh);
+	mptcp_nl_mcast_send(net, skb, gfp);
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+}
+
 static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fe6da1b77723..c2a8392254dc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2150,6 +2150,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow)
 {
+	if (sk->sk_state == TCP_ESTABLISHED)
+		mptcp_event(MPTCP_EVENT_SUB_CLOSED, mptcp_sk(sk), ssk, GFP_KERNEL);
 	__mptcp_close_ssk(sk, ssk, subflow);
 }
 
@@ -2586,6 +2588,10 @@ static void mptcp_close(struct sock *sk, long timeout)
 	release_sock(sk);
 	if (do_cancel_work)
 		mptcp_cancel_work(sk);
+
+	if (mptcp_sk(sk)->token)
+		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
+
 	sock_put(sk);
 }
 
@@ -3057,7 +3063,7 @@ bool mptcp_finish_join(struct sock *ssk)
 		return false;
 
 	if (!msk->pm.server_side)
-		return true;
+		goto out;
 
 	if (!mptcp_pm_allow_new_subflow(msk))
 		return false;
@@ -3084,6 +3090,8 @@ bool mptcp_finish_join(struct sock *ssk)
 	if (parent_sock && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, parent_sock);
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
+out:
+	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 	return true;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f620e2f98d19..d31edbae8da8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -10,6 +10,7 @@
 #include <linux/random.h>
 #include <net/tcp.h>
 #include <net/inet_connection_sock.h>
+#include <uapi/linux/mptcp.h>
 
 #define MPTCP_SUPPORTED_VERSION	1
 
@@ -666,6 +667,11 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 local_id);
 
+void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
+		 const struct sock *ssk, gfp_t gfp);
+void mptcp_event_addr_announced(const struct mptcp_sock *msk, const struct mptcp_addr_info *info);
+void mptcp_event_addr_removed(const struct mptcp_sock *msk, u8 id);
+
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_ADD_ADDR_SIGNAL);
-- 
2.30.1

