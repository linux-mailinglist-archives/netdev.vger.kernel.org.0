Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFBD3EBE35
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhHMWQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:29030 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhHMWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520903"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520903"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320456"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: faster active backup recovery
Date:   Fri, 13 Aug 2021 15:15:45 -0700
Message-Id: <20210813221548.111990-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The msk can use backup subflows to transmit in-sequence data
only if there are no other active subflow. On active backup
scenario, the MPTCP connection can do forward progress only
due to MPTCP retransmissions - rtx can pick backup subflows.

This patch introduces a new flag flow MPTCP subflows: if the
underlying TCP connection made no progresses for long time,
and there are other less problematic subflows available, the
given subflow become stale.

Stale subflows are not considered active: if all non backup
subflows become stale, the MPTCP scheduler can pick backup
subflows for plain transmissions.

Stale subflows can return in active state, as soon as any reply
from the peer is observed.

Active backup scenarios can now leverage the available b/w
with no restrinction.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/207
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 Documentation/networking/mptcp-sysctl.rst | 12 +++++++
 net/mptcp/ctrl.c                          | 14 +++++++++
 net/mptcp/pm.c                            |  2 ++
 net/mptcp/pm_netlink.c                    | 38 +++++++++++++++++++++++
 net/mptcp/protocol.c                      | 27 ++++++++++++++--
 net/mptcp/protocol.h                      | 12 +++++--
 6 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/mptcp-sysctl.rst b/Documentation/networking/mptcp-sysctl.rst
index 76d939e688b8..b0d4da71e68e 100644
--- a/Documentation/networking/mptcp-sysctl.rst
+++ b/Documentation/networking/mptcp-sysctl.rst
@@ -45,3 +45,15 @@ allow_join_initial_addr_port - BOOLEAN
 	This is a per-namespace sysctl.
 
 	Default: 1
+
+stale_loss_cnt - INTEGER
+	The number of MPTCP-level retransmission intervals with no traffic and
+	pending outstanding data on a given subflow required to declare it stale.
+	The packet scheduler ignores stale subflows.
+	A low stale_loss_cnt  value allows for fast active-backup switch-over,
+	an high value maximize links utilization on edge scenarios e.g. lossy
+	link with high BER or peer pausing the data processing.
+
+	This is a per-namespace sysctl.
+
+	Default: 4
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 63bba9d8e289..8b235468c88f 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -22,6 +22,7 @@ struct mptcp_pernet {
 #endif
 
 	unsigned int add_addr_timeout;
+	unsigned int stale_loss_cnt;
 	u8 mptcp_enabled;
 	u8 checksum_enabled;
 	u8 allow_join_initial_addr_port;
@@ -52,12 +53,18 @@ int mptcp_allow_join_id0(const struct net *net)
 	return mptcp_get_pernet(net)->allow_join_initial_addr_port;
 }
 
+unsigned int mptcp_stale_loss_cnt(const struct net *net)
+{
+	return mptcp_get_pernet(net)->stale_loss_cnt;
+}
+
 static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
 {
 	pernet->mptcp_enabled = 1;
 	pernet->add_addr_timeout = TCP_RTO_MAX;
 	pernet->checksum_enabled = 0;
 	pernet->allow_join_initial_addr_port = 1;
+	pernet->stale_loss_cnt = 4;
 }
 
 #ifdef CONFIG_SYSCTL
@@ -95,6 +102,12 @@ static struct ctl_table mptcp_sysctl_table[] = {
 		.extra1       = SYSCTL_ZERO,
 		.extra2       = SYSCTL_ONE
 	},
+	{
+		.procname = "stale_loss_cnt",
+		.maxlen = sizeof(unsigned int),
+		.mode = 0644,
+		.proc_handler = proc_douintvec_minmax,
+	},
 	{}
 };
 
@@ -114,6 +127,7 @@ static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
 	table[1].data = &pernet->add_addr_timeout;
 	table[2].data = &pernet->checksum_enabled;
 	table[3].data = &pernet->allow_join_initial_addr_port;
+	table[4].data = &pernet->stale_loss_cnt;
 
 	hdr = register_net_sysctl(net, MPTCP_SYSCTL_PATH, table);
 	if (!hdr)
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 9ff17c5205ce..d8a85fe92360 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -320,8 +320,10 @@ void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 	} else if (subflow->stale_rcv_tstamp == rcv_tstamp) {
 		if (subflow->stale_count < U8_MAX)
 			subflow->stale_count++;
+		mptcp_pm_nl_subflow_chk_stale(msk, ssk);
 	} else {
 		subflow->stale_count = 0;
+		mptcp_subflow_set_active(subflow);
 	}
 }
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 56263c2c4014..c0eb14e05bea 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -46,6 +46,7 @@ struct pm_nl_pernet {
 	spinlock_t		lock;
 	struct list_head	local_addr_list;
 	unsigned int		addrs;
+	unsigned int		stale_loss_cnt;
 	unsigned int		add_addr_signal_max;
 	unsigned int		add_addr_accept_max;
 	unsigned int		local_addr_max;
@@ -899,6 +900,42 @@ static const struct nla_policy mptcp_pm_policy[MPTCP_PM_ATTR_MAX + 1] = {
 	[MPTCP_PM_ATTR_SUBFLOWS]	= { .type	= NLA_U32,	},
 };
 
+void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct mptcp_subflow_context *iter, *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = (struct sock *)msk;
+	unsigned int active_max_loss_cnt;
+	struct net *net = sock_net(sk);
+	unsigned int stale_loss_cnt;
+	bool slow;
+
+	stale_loss_cnt = mptcp_stale_loss_cnt(net);
+	if (subflow->stale || !stale_loss_cnt || subflow->stale_count <= stale_loss_cnt)
+		return;
+
+	/* look for another available subflow not in loss state */
+	active_max_loss_cnt = max_t(int, stale_loss_cnt - 1, 1);
+	mptcp_for_each_subflow(msk, iter) {
+		if (iter != subflow && mptcp_subflow_active(iter) &&
+		    iter->stale_count < active_max_loss_cnt) {
+			/* we have some alternatives, try to mark this subflow as idle ...*/
+			slow = lock_sock_fast(ssk);
+			if (!tcp_rtx_and_write_queues_empty(ssk)) {
+				subflow->stale = 1;
+				__mptcp_retransmit_pending_data(sk);
+			}
+			unlock_sock_fast(ssk, slow);
+
+			/* always try to push the pending data regarless of re-injections:
+			 * we can possibly use backup subflows now, and subflow selection
+			 * is cheap under the msk socket lock
+			 */
+			__mptcp_push_pending(sk, 0);
+			return;
+		}
+	}
+}
+
 static int mptcp_pm_family_to_addr(int family)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1922,6 +1959,7 @@ static int __net_init pm_nl_init_net(struct net *net)
 
 	INIT_LIST_HEAD_RCU(&pernet->local_addr_list);
 	pernet->next_id = 1;
+	pernet->stale_loss_cnt = 4;
 	spin_lock_init(&pernet->lock);
 
 	/* No need to initialize other pernet fields, the struct is zeroed at
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5fafa7a4cd69..18d3adccba5c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1391,6 +1391,27 @@ struct subflow_send_info {
 	u64 ratio;
 };
 
+void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow)
+{
+	if (!subflow->stale)
+		return;
+
+	subflow->stale = 0;
+}
+
+bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+{
+	if (unlikely(subflow->stale)) {
+		u32 rcv_tstamp = READ_ONCE(tcp_sk(mptcp_subflow_tcp_sock(subflow))->rcv_tstamp);
+
+		if (subflow->stale_rcv_tstamp == rcv_tstamp)
+			return false;
+
+		mptcp_subflow_set_active(subflow);
+	}
+	return __mptcp_subflow_active(subflow);
+}
+
 /* implement the mptcp packet scheduler;
  * returns the subflow that will transmit the next DSS
  * additionally updates the rtx timeout
@@ -1472,7 +1493,7 @@ static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 }
 
-static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
+void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
 	struct sock *prev_ssk = NULL, *ssk = NULL;
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -2115,7 +2136,7 @@ static void mptcp_timeout_timer(struct timer_list *t)
  *
  * A backup subflow is returned only if that is the only kind available.
  */
-static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
+static struct sock *mptcp_subflow_get_retrans(struct mptcp_sock *msk)
 {
 	struct sock *backup = NULL, *pick = NULL;
 	struct mptcp_subflow_context *subflow;
@@ -2129,7 +2150,7 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		if (!mptcp_subflow_active(subflow))
+		if (!__mptcp_subflow_active(subflow))
 			continue;
 
 		/* still data outstanding at TCP level? skip this */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 43ff6c5baddc..8bdd038def38 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -432,7 +432,8 @@ struct mptcp_subflow_context {
 		send_mp_prio : 1,
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
-		disposable : 1;	    /* ctx can be free at ulp release time */
+		disposable : 1,	    /* ctx can be free at ulp release time */
+		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
@@ -560,9 +561,11 @@ int mptcp_is_enabled(const struct net *net);
 unsigned int mptcp_get_add_addr_timeout(const struct net *net);
 int mptcp_is_checksum_enabled(const struct net *net);
 int mptcp_allow_join_id0(const struct net *net);
+unsigned int mptcp_stale_loss_cnt(const struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
+void __mptcp_push_pending(struct sock *sk, unsigned int flags);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
@@ -581,7 +584,7 @@ void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
 			 unsigned short family);
 
-static inline bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+static inline bool __mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 {
 	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -593,6 +596,10 @@ static inline bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
 }
 
+void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow);
+
+bool mptcp_subflow_active(struct mptcp_subflow_context *subflow);
+
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 					      struct mptcp_subflow_context *ctx)
 {
@@ -699,6 +706,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
+void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);
 void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk, gfp_t gfp);
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
-- 
2.32.0

